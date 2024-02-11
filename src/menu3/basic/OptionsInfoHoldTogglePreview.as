// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.OptionsInfoHoldTogglePreview

package menu3.basic {
import flash.display.Sprite;

import __AS3__.vec.Vector;

import flash.filters.DropShadowFilter;
import flash.filters.BitmapFilterQuality;

import hud.InteractionIndicator;

import common.menu.MenuConstants;

import __AS3__.vec.*;

public dynamic class OptionsInfoHoldTogglePreview extends OptionsInfoSlideshowPreview {

	private var m_buttonsContainer:Sprite = new Sprite();
	private var m_triggersPerIndicator:Vector.<Vector.<Trigger>> = new Vector.<Vector.<Trigger>>(0);

	public function OptionsInfoHoldTogglePreview(_arg_1:Object) {
		super(_arg_1);
		this.m_buttonsContainer.name = "m_buttonsContainer";
		this.m_buttonsContainer.x = 0;
		this.m_buttonsContainer.y = 352;
		getPreviewContentContainer().addChild(this.m_buttonsContainer);
		if (!ControlsMain.isVrModeActive()) {
			this.m_buttonsContainer.filters = [new DropShadowFilter(2, 90, 0, 1, 8, 8, 1, BitmapFilterQuality.HIGH, false, false, false)];
		}
		;
		this.onSetData(_arg_1);
	}

	override public function onSetData(_arg_1:Object):void {
		var _local_5:InteractionIndicator;
		super.onSetData(_arg_1);
		var _local_2:Number = OptionsInfoPreview.PX_PREVIEW_BACKGROUND_WIDTH;
		var _local_3:int = _arg_1.previewData.prompts.length;
		this.m_triggersPerIndicator.length = _local_3;
		var _local_4:int;
		while (_local_4 < _local_3) {
			if (this.m_buttonsContainer.numChildren > _local_4) {
				_local_5 = InteractionIndicator(this.m_buttonsContainer.getChildAt(_local_4));
			} else {
				_local_5 = new InteractionIndicator();
				this.m_buttonsContainer.addChild(_local_5);
			}
			;
			_local_5.onSetData({
				"m_eState": InteractionIndicator.STATE_AVAILABLE,
				"m_eTypeId": InteractionIndicator.TYPE_PRESS,
				"m_nIconId": _arg_1.previewData.prompts[_local_4].interactionData.m_nIconId,
				"m_sGlyph": _arg_1.previewData.prompts[_local_4].interactionData.m_sGlyph,
				"m_fProgress": 0,
				"m_sLabel": "",
				"m_sDescription": "",
				"m_nFontSize": MenuConstants.INTERACTIONPROMPTSIZE_SMALL
			});
			this.m_triggersPerIndicator[_local_4] = Trigger.parseArray(_arg_1.previewData.prompts[_local_4].triggers);
			_local_5.x = (((_local_4 + 1) * _local_2) / (_local_3 + 1));
			_local_5.y = 40;
			_local_5.scaleX = 1.25;
			_local_5.scaleY = 1.25;
			_local_4++;
		}
		;
		while (this.m_buttonsContainer.numChildren > _local_3) {
			this.m_buttonsContainer.removeChildAt(_local_3);
		}
		;
	}

	override protected function onPreviewSlideshowEnteredFrameLabel(_arg_1:String):void {
		var _local_4:Trigger;
		super.onPreviewSlideshowEnteredFrameLabel(_arg_1);
		var _local_2:int = this.m_triggersPerIndicator.length;
		var _local_3:int;
		while (_local_3 < _local_2) {
			for each (_local_4 in this.m_triggersPerIndicator[_local_3]) {
				if (_local_4.frameLabel == _arg_1) {
					if ((((_local_4.when == Trigger.When_OnEntered) || ((_local_4.when == Trigger.When_OnEnteredFwd) && (dirCurrent == Dir_Forward))) || ((_local_4.when == Trigger.When_OnEnteredBwd) && (dirCurrent == Dir_Backward)))) {
						_local_4.runOnIndicator(InteractionIndicator(this.m_buttonsContainer.getChildAt(_local_3)));
					}
					;
				}
				;
			}
			;
			_local_3++;
		}
		;
	}

	override protected function onPreviewSlideshowExitedFrameLabel(_arg_1:String):void {
		var _local_4:Trigger;
		super.onPreviewSlideshowExitedFrameLabel(_arg_1);
		var _local_2:int = this.m_triggersPerIndicator.length;
		var _local_3:int;
		while (_local_3 < _local_2) {
			for each (_local_4 in this.m_triggersPerIndicator[_local_3]) {
				if (_local_4.frameLabel == _arg_1) {
					if ((((_local_4.when == Trigger.When_OnExited) || ((_local_4.when == Trigger.When_OnExitedFwd) && (dirCurrent == Dir_Forward))) || ((_local_4.when == Trigger.When_OnExitedBwd) && (dirCurrent == Dir_Backward)))) {
						_local_4.runOnIndicator(InteractionIndicator(this.m_buttonsContainer.getChildAt(_local_3)));
					}
					;
				}
				;
			}
			;
			_local_3++;
		}
		;
	}


}
}//package menu3.basic

import __AS3__.vec.Vector;

import flash.display.DisplayObjectContainer;
import flash.display.DisplayObject;

import common.Animate;

import hud.InteractionIndicator;

import __AS3__.vec.*;

class Trigger {

	public static const When_OnEntered:int = 0;
	public static const When_OnExited:int = 1;
	public static const When_OnEnteredFwd:int = 2;
	public static const When_OnEnteredBwd:int = 3;
	public static const When_OnExitedFwd:int = 4;
	public static const When_OnExitedBwd:int = 5;
	public static const What_AnimatePress:int = 0;
	public static const What_AnimateHoldOn:int = 1;
	public static const What_AnimateHoldOff:int = 2;
	public static const What_AnimateHoldOffSubtle:int = 3;

	public var frameLabel:String;
	public var when:int;
	public var what:int;


	public static function parseArray(_arg_1:Array):Vector.<Trigger> {
		var _local_3:Object;
		var _local_4:Trigger;
		var _local_2:Vector.<Trigger> = new Vector.<Trigger>(0);
		for each (_local_3 in _arg_1) {
			_local_4 = new (Trigger)();
			_local_4.frameLabel = _local_3.frameLabel;
			if (!_local_4.frameLabel) {
				trace("error: missing triggerData.frameLabel");
			}
			;
			switch (_local_3.when) {
				case "OnEntered":
					_local_4.when = When_OnEntered;
					break;
				case "OnExited":
					_local_4.when = When_OnExited;
					break;
				case "OnEnteredFwd":
					_local_4.when = When_OnEnteredFwd;
					break;
				case "OnEnteredBwd":
					_local_4.when = When_OnEnteredBwd;
					break;
				case "OnExitedFwd":
					_local_4.when = When_OnExitedFwd;
					break;
				case "OnExitedBwd":
					_local_4.when = When_OnExitedBwd;
					break;
				default:
					trace(("error: unrecognized triggerData.when: " + _local_3.when));
			}
			;
			switch (_local_3.what) {
				case "AnimatePress":
					_local_4.what = What_AnimatePress;
					break;
				case "AnimateHoldOn":
					_local_4.what = What_AnimateHoldOn;
					break;
				case "AnimateHoldOff":
					_local_4.what = What_AnimateHoldOff;
					break;
				case "AnimateHoldOffSubtle":
					_local_4.what = What_AnimateHoldOffSubtle;
					break;
				default:
					trace(("error: unrecognized triggerData.what: " + _local_3.what));
			}
			;
			_local_2.push(_local_4);
		}
		;
		return (_local_2);
	}


	public function runOnIndicator(_arg_1:InteractionIndicator):void {
		var _local_2:InteractionIndicatorView = InteractionIndicatorView(_arg_1.getContainer().getChildAt(0));
		var _local_3:DisplayObjectContainer = _local_2.hold_mc;
		var _local_4:DisplayObject = _local_2.promptHolder_mc.getChildAt(0);
		_local_3.visible = true;
		_local_3.getChildAt(0).alpha = 1;
		switch (this.what) {
			case What_AnimatePress:
				_local_3.alpha = 0;
				Animate.fromTo(_local_3, 0.5, 0.1, {
					"scaleX": 0.8,
					"scaleY": 0.8,
					"alpha": 1
				}, {
					"scaleX": 2.5,
					"scaleY": 2.5,
					"alpha": 0
				}, Animate.ExpoOut);
				Animate.fromTo(_local_4, 0.1, 0, {
					"scaleX": 1,
					"scaleY": 1
				}, {
					"scaleX": 0.8,
					"scaleY": 0.8
				}, Animate.Linear, Animate.to, _local_4, 0.2, 0, {
					"scaleX": 1,
					"scaleY": 1
				}, Animate.SineOut);
				return;
			case What_AnimateHoldOn:
				_local_3.alpha = 0;
				Animate.fromTo(_local_3, 0.2, 0, {
					"scaleX": 2,
					"scaleY": 2,
					"alpha": 0
				}, {
					"scaleX": 0.9,
					"scaleY": 0.9,
					"alpha": 1
				}, Animate.SineOut, Animate.fromTo, _local_3, 3, 0, {
					"scaleX": 0.9,
					"scaleY": 0.9,
					"alpha": 0.85
				}, {
					"scaleX": 0.8,
					"scaleY": 0.8,
					"alpha": 0.85
				}, Animate.Linear);
				Animate.fromTo(_local_4, 0.1, 0, {
					"scaleX": 1,
					"scaleY": 1
				}, {
					"scaleX": 0.8,
					"scaleY": 0.8
				}, Animate.Linear);
				return;
			case What_AnimateHoldOff:
			case What_AnimateHoldOffSubtle:
				Animate.fromTo(_local_3, 0.5, 0, ((this.what != What_AnimateHoldOffSubtle) ? {
					"scaleX": 0.9,
					"scaleY": 0.9,
					"alpha": 1
				} : {
					"scaleX": 0.9,
					"scaleY": 0.9,
					"alpha": 0.85
				}), ((this.what != What_AnimateHoldOffSubtle) ? {
					"scaleX": 2.5,
					"scaleY": 2.5,
					"alpha": 0
				} : {
					"scaleX": 1.5,
					"scaleY": 1.5,
					"alpha": 0
				}), Animate.ExpoOut);
				Animate.fromTo(_local_4, 0.1, 0, {
					"scaleX": 0.8,
					"scaleY": 0.8
				}, {
					"scaleX": 1,
					"scaleY": 1
				}, Animate.Linear);
				return;
		}
		;
	}


}


