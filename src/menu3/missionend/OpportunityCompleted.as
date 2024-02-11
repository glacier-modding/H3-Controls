// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.missionend.OpportunityCompleted

package menu3.missionend {
import menu3.MenuElementBase;
import menu3.MenuImageLoader;

import common.menu.MenuUtils;
import common.menu.MenuConstants;

import flash.text.TextField;
import flash.text.TextFormat;

import common.CommonUtils;

import flash.external.ExternalInterface;

import common.Animate;

public dynamic class OpportunityCompleted extends MenuElementBase {

	private var m_view:OpportunityCompletedView;
	private var m_loader:MenuImageLoader;
	private var m_animationXpos:Number;
	private var m_flickerCounter:int = 0;

	public function OpportunityCompleted(_arg_1:Object) {
		super(_arg_1);
		this.m_view = new OpportunityCompletedView();
		addChild(this.m_view);
		this.m_view.image.alpha = 0;
		this.m_animationXpos = this.m_view.header.x;
	}

	override public function onUnregister():void {
		this.unloadImage();
		this.killAnimations();
		super.onUnregister();
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		var _local_2:String = ((_arg_1.header != null) ? _arg_1.header : "");
		var _local_3:String = ((_arg_1.title != null) ? _arg_1.title : "");
		var _local_4:String = _arg_1.image;
		MenuUtils.setupTextUpper(this.m_view.header, _local_2, 42, MenuConstants.FONT_TYPE_LIGHT, MenuConstants.FontColorWhite);
		var _local_5:TextField = this.m_view.title;
		var _local_6:RegExp = / /g;
		var _local_7:String = _local_3.replace(_local_6, "\n");
		MenuUtils.setupTextUpper(_local_5, _local_7, 130, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
		_local_5.wordWrap = false;
		MenuUtils.shrinkTextToFit(_local_5, _local_5.width, -1);
		var _local_8:TextFormat = _local_5.getTextFormat();
		var _local_9:int = int(_local_8.size);
		_local_5.wordWrap = true;
		MenuUtils.setupTextUpper(_local_5, _local_3, _local_9, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
		var _local_10:Number = -0.15;
		if (CommonUtils.getActiveTextLocaleIndex() == 11) {
			_local_10 = 0.01;
		}
		;
		_local_8 = _local_5.getTextFormat();
		_local_8.leading = (_local_9 * _local_10);
		_local_5.setTextFormat(_local_8);
		MenuUtils.shrinkTextToFit(_local_5, _local_5.width, _local_5.height, 9, -1, _local_10);
		this.m_view.header.alpha = 0;
		this.m_view.title.alpha = 0;
		this.loadImage(_local_4);
	}

	private function loadImage(imagePath:String):void {
		this.unloadImage();
		if (((imagePath == null) || (imagePath.length == 0))) {
			return;
		}
		;
		this.m_loader = new MenuImageLoader();
		this.m_loader.center = true;
		this.m_view.image.addChild(this.m_loader);
		this.m_loader.loadImage(imagePath, function ():void {
			var _local_1:Object;
			var _local_2:Number = 1;
			_local_2 = (m_loader.width / m_loader.height);
			_local_1 = m_loader;
			var _local_3:int = m_view.imagemask.width;
			var _local_4:int = m_view.imagemask.height;
			_local_1.width = (_local_3 / m_view.image.scaleX);
			_local_1.height = ((_local_3 / m_view.image.scaleY) / _local_2);
			if (m_view.image.height < _local_4) {
				_local_1.height = (_local_4 / m_view.image.scaleX);
				_local_1.width = ((_local_4 / m_view.image.scaleY) * _local_2);
			}
			;
			playSound("ui_debrief_achievement_mission_story_complete");
			animateFlicker();
		}, null);
	}

	public function unloadImage():void {
		if (this.m_loader != null) {
			this.m_loader.cancelIfLoading();
			if (this.m_loader.parent != null) {
				this.m_loader.parent.removeChild(this.m_loader);
			}
			;
			this.m_loader = null;
		}
		;
	}

	public function playSound(_arg_1:String):void {
		ExternalInterface.call("PlaySound", _arg_1);
	}

	private function animateIn():void {
		this.killAnimations();
		Animate.fromTo(this.m_view.image, 0.2, 0, {"alpha": 0}, {"alpha": 1}, Animate.ExpoOut);
		Animate.fromTo(this.m_view.header, 0.15, 0.2, {"alpha": 0}, {"alpha": 1}, Animate.ExpoOut);
		Animate.addFromTo(this.m_view.header, 0.3, 0.2, {"x": (this.m_animationXpos - 25)}, {"x": this.m_animationXpos}, Animate.ExpoOut);
		Animate.fromTo(this.m_view.title, 0.15, 0.4, {"alpha": 0}, {"alpha": 1}, Animate.ExpoOut);
		Animate.addFromTo(this.m_view.title, 0.4, 0.4, {"x": (this.m_animationXpos - 25)}, {"x": this.m_animationXpos}, Animate.ExpoOut);
	}

	private function animateFlicker():void {
		this.m_flickerCounter = (this.m_flickerCounter + 1);
		if (this.m_flickerCounter <= 4) {
			Animate.fromTo(this.m_view.image, 0.1, 0, {"alpha": 0}, {"alpha": ((this.m_flickerCounter == 4) ? 0 : (this.m_flickerCounter * 0.1))}, Animate.ExpoOut, this.animateFlicker);
		} else {
			this.m_flickerCounter = 0;
			this.animateIn();
		}
		;
	}

	private function killAnimations():void {
		if (this.m_view != null) {
			Animate.kill(this.m_view.image);
			Animate.kill(this.m_view.header);
			Animate.kill(this.m_view.title);
		}
		;
	}


}
}//package menu3.missionend

