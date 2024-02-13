// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.photomode.PhotoModeMessageWidget

package hud.photomode {
import common.BaseControl;

import flash.display.Sprite;


import common.Animate;


public class PhotoModeMessageWidget extends BaseControl {

	private static const DY_GAP_BETWEEN_MESSAGES:Number = 16;

	private var m_Sticky_view:StickyMessageView = new StickyMessageView();
	private var m_Sticky_htmlPrimaryEnqueued:String = null;
	private var m_Sticky_htmlSecondaryEnqueued:String = null;
	private var m_Sticky_isFadingOut:Boolean = false;
	private var m_FAF_container:FAFMessageViewContainer = new FAFMessageViewContainer();
	private var m_FAF_containerStickyOffset:Sprite = new Sprite();
	private var m_FAF_viewsEnqueued:Vector.<FAFMessageView> = new Vector.<FAFMessageView>();
	private var m_FAF_viewsActive:Vector.<FAFMessageView> = new Vector.<FAFMessageView>();
	private var m_FAF_yOffsetTotal:Number = 0;

	public function PhotoModeMessageWidget() {
		this.m_FAF_container.name = "faf";
		this.m_FAF_containerStickyOffset.name = "fafStickyOffset";
		this.m_FAF_containerStickyOffset.addChild(this.m_FAF_container);
		this.m_Sticky_view.name = "sticky";
		this.m_Sticky_view.visible = false;
		addChild(this.m_Sticky_view);
		addChild(this.m_FAF_containerStickyOffset);
	}

	public function fireAndForget(_arg_1:String, _arg_2:String):void {
		var _local_3:FAFMessageView = this.m_FAF_container.acquireView();
		_local_3.alpha = 0;
		_local_3.setupTextFields(_arg_1, _arg_2);
		this.m_FAF_viewsEnqueued.push(_local_3);
		this.m_FAF_yOffsetTotal = (this.m_FAF_yOffsetTotal + (_local_3.getTotalTextHeight() + DY_GAP_BETWEEN_MESSAGES));
		_local_3.y = -(this.m_FAF_yOffsetTotal);
		Animate.to(this.m_FAF_container, 0.125, 0, {"y": this.m_FAF_yOffsetTotal}, Animate.SineOut, this.onFAFSlideDownCompleted);
	}

	private function onFAFSlideDownCompleted():void {
		var _local_1:FAFMessageView;
		while (this.m_FAF_viewsEnqueued.length > 0) {
			_local_1 = this.m_FAF_viewsEnqueued.pop();
			this.m_FAF_viewsActive.push(_local_1);
			_local_1.startAnimation(this.onFAFAnimationCompleted);
		}

	}

	private function onFAFAnimationCompleted(_arg_1:FAFMessageView):void {
		this.m_FAF_container.releaseView(_arg_1);
		_arg_1.y = 0;
		var _local_2:int;
		while (_local_2 < this.m_FAF_viewsActive.length) {
			if (this.m_FAF_viewsActive[_local_2] == _arg_1) {
				this.m_FAF_viewsActive.splice(_local_2, 1);
				break;
			}

			_local_2++;
		}

		if (this.m_FAF_viewsActive.length == 0) {
			this.m_FAF_yOffsetTotal = 0;
			this.m_FAF_container.y = 0;
		}

	}

	public function clearAllFiredAndForgotten():void {
		var _local_1:FAFMessageView;
		Animate.kill(this.m_FAF_container);
		this.m_FAF_yOffsetTotal = 0;
		this.m_FAF_container.y = 0;
		while (this.m_FAF_viewsEnqueued.length > 0) {
			_local_1 = this.m_FAF_viewsEnqueued.pop();
			_local_1.y = 0;
			this.m_FAF_container.releaseView(_local_1);
		}

		while (this.m_FAF_viewsActive.length > 0) {
			_local_1 = this.m_FAF_viewsActive.pop();
			Animate.kill(_local_1);
			_local_1.y = 0;
			this.m_FAF_container.releaseView(_local_1);
		}

	}

	public function setSticky(_arg_1:String, _arg_2:String):void {
		if (!this.m_Sticky_view.visible) {
			this.m_Sticky_view.visible = true;
			this.m_Sticky_view.fadeInAnimation(_arg_1, _arg_2);
			Animate.to(this.m_FAF_containerStickyOffset, 0.125, 0, {"y": (this.m_Sticky_view.getTotalTextHeight() + DY_GAP_BETWEEN_MESSAGES)}, Animate.SineOut);
		} else {
			if (!this.m_Sticky_isFadingOut) {
				this.m_Sticky_view.fadeOutAnimation(this.onStickyFadeOutCompleted);
				this.m_Sticky_isFadingOut = true;
			}

			this.m_Sticky_htmlPrimaryEnqueued = _arg_1;
			this.m_Sticky_htmlSecondaryEnqueued = _arg_2;
		}

	}

	private function onStickyFadeOutCompleted():void {
		this.m_Sticky_isFadingOut = false;
		if (((!(this.m_Sticky_htmlPrimaryEnqueued == null)) && (!(this.m_Sticky_htmlSecondaryEnqueued == null)))) {
			this.m_Sticky_view.fadeInAnimation(this.m_Sticky_htmlPrimaryEnqueued, this.m_Sticky_htmlSecondaryEnqueued);
			this.m_Sticky_htmlPrimaryEnqueued = null;
			this.m_Sticky_htmlSecondaryEnqueued = null;
			Animate.to(this.m_FAF_containerStickyOffset, 0.125, 0, {"y": (this.m_Sticky_view.getTotalTextHeight() + DY_GAP_BETWEEN_MESSAGES)}, Animate.SineOut);
		} else {
			this.m_Sticky_view.visible = false;
		}

	}

	public function clearSticky():void {
		if (!this.m_Sticky_view.visible) {
			return;
		}

		if (!this.m_Sticky_isFadingOut) {
			this.m_Sticky_view.fadeOutAnimation(this.onStickyFadeOutCompleted);
			this.m_Sticky_isFadingOut = true;
			Animate.to(this.m_FAF_containerStickyOffset, 0.125, 0, {"y": 0}, Animate.SineOut);
		}

		this.m_Sticky_htmlPrimaryEnqueued = null;
		this.m_Sticky_htmlSecondaryEnqueued = null;
	}


}
}//package hud.photomode

import flash.display.Sprite;
import flash.text.TextField;

import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.Animate;

import flash.display.Shape;


class MessageView extends Sprite {

	public var primary_txt:TextField = new TextField();
	public var secondary_txt:TextField = new TextField();

	public function MessageView() {
		this.primary_txt.name = "primary_txt";
		this.secondary_txt.name = "secondary_txt";
		this.primary_txt.autoSize = "left";
		this.secondary_txt.autoSize = "left";
		MenuUtils.setupText(this.primary_txt, "", 22, MenuConstants.FONT_TYPE_MEDIUM);
		MenuUtils.setupText(this.secondary_txt, "", 18, MenuConstants.FONT_TYPE_MEDIUM);
		MenuUtils.addDropShadowFilter(this.primary_txt);
		MenuUtils.addDropShadowFilter(this.secondary_txt);
		addChild(this.primary_txt);
		addChild(this.secondary_txt);
	}

	public function setupTextFields(_arg_1:String, _arg_2:String):void {
		this.primary_txt.htmlText = _arg_1.toUpperCase();
		this.primary_txt.x = (-(this.primary_txt.width) / 2);
		if (_arg_2 == "") {
			this.secondary_txt.visible = false;
		} else {
			this.secondary_txt.htmlText = _arg_2;
			this.secondary_txt.x = (-(this.secondary_txt.width) / 2);
			this.secondary_txt.alpha = 1;
			this.secondary_txt.visible = true;
		}

	}

	public function getTotalTextHeight():Number {
		var _local_1:Number = this.primary_txt.height;
		if (this.secondary_txt.visible) {
			_local_1 = (_local_1 + this.secondary_txt.height);
		}

		return (_local_1);
	}


}

class StickyMessageView extends MessageView {

	public function StickyMessageView() {
		alpha = 0;
		scaleX = 1.3;
		scaleY = 1.3;
	}

	public function fadeInAnimation(_arg_1:String, _arg_2:String):void {
		setupTextFields(_arg_1, _arg_2);
		if (secondary_txt.visible) {
			secondary_txt.y = primary_txt.height;
		}

		Animate.to(this, 0.125, 0, {
			"alpha": 1,
			"scaleX": 1,
			"scaleY": 1
		}, Animate.SineOut);
	}

	public function fadeOutAnimation(_arg_1:Function):void {
		Animate.to(this, 0.125, 0, {
			"alpha": 0,
			"scaleX": 1.3,
			"scaleY": 1.3
		}, Animate.SineIn, _arg_1);
	}


}

class FAFMessageView extends MessageView {

	public var bg:Shape = new Shape();

	public function FAFMessageView() {
		this.bg.name = "bg";
		this.bg.graphics.beginFill(0xFFFFFF);
		this.bg.graphics.drawRect(-10, 0, 20, 20);
		this.bg.graphics.endFill();
		this.bg.visible = false;
		addChild(this.bg);
	}

	public function startAnimation(_arg_1:Function):void {
		var _local_2:Number = 3;
		if (secondary_txt.visible) {
			secondary_txt.y = (primary_txt.height / 2);
			secondary_txt.alpha = 0;
			Animate.to(secondary_txt, 0.5, 1, {
				"alpha": 1,
				"y": primary_txt.height
			}, Animate.ExpoOut);
			_local_2 = (_local_2 + 1);
		}

		this.bg.width = primary_txt.width;
		this.bg.height = (primary_txt.height - 3);
		this.bg.alpha = 1;
		this.bg.visible = true;
		Animate.to(this.bg, 1, 0, {
			"alpha": 0,
			"width": (primary_txt.width + 200)
		}, Animate.ExpoOut);
		alpha = 1;
		Animate.to(this, 1, _local_2, {"alpha": 0}, Animate.Linear, _arg_1, this);
	}


}

class FAFMessageViewContainer extends Sprite {

	/*private*/
	internal var m_viewsAvailable:Vector.<FAFMessageView> = new Vector.<FAFMessageView>();

	public function FAFMessageViewContainer() {
		var _local_3:FAFMessageView;
		super();
		var _local_1:int = 2;
		var _local_2:int;
		while (_local_2 < _local_1) {
			_local_3 = new FAFMessageView();
			_local_3.visible = false;
			this.m_viewsAvailable.push(_local_3);
			addChild(_local_3);
			_local_2++;
		}

	}

	public function acquireView():FAFMessageView {
		var _local_1:FAFMessageView;
		if (this.m_viewsAvailable.length > 0) {
			_local_1 = this.m_viewsAvailable.pop();
			_local_1.visible = true;
		} else {
			_local_1 = new FAFMessageView();
			addChild(_local_1);
		}

		return (_local_1);
	}

	public function releaseView(_arg_1:FAFMessageView):void {
		_arg_1.visible = false;
		this.m_viewsAvailable.push(_arg_1);
	}


}


