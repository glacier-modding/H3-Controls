// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//basic.GlobalLoadindicator

package basic {
import common.BaseControl;
import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.CommonUtils;
import common.Localization;

import flash.utils.getTimer;

import common.Animate;

import flash.events.Event;

public class GlobalLoadindicator extends BaseControl {

	private var m_view:GlobalLoadIndicatorView;
	private var m_totalFrames:int = 119;
	private var m_deltaTime:Number;
	private var m_prevFrame:Number;
	private var m_currentFrame:Number;
	private var m_fpsToReach:int = 24;
	private var m_frameFactor:Number = 0;
	private var m_frame:int;
	public var m_animated:Boolean = false;
	private var m_discrete:Boolean;
	private var m_bootFlowMode:Boolean;
	private var m_hasSetBarcodeScale:Boolean = false;
	private var m_originalBackgroundWidth:Number;

	public function GlobalLoadindicator():void {
		this.m_view = new GlobalLoadIndicatorView();
		MenuUtils.setColor(this.m_view.loadindicator.bg, MenuConstants.COLOR_MENU_SOLID_BACKGROUND, true, 1);
		MenuUtils.setColor(this.m_view.loadindicator.loadbarbg, MenuConstants.COLOR_MENU_BUTTON_TILE_DESELECTED, true, 1);
		this.m_view.loadindicator.bg.alpha = 0;
		MenuUtils.setColor(this.m_view.loadindicator.progressbar.bar, MenuConstants.COLOR_WHITE, true, 1);
		MenuUtils.setColor(this.m_view.loadindicator.progressbar.bg, MenuConstants.COLOR_WHITE, true, 0.25);
		this.m_view.loadindicator.progressbar.bar.visible = false;
		this.m_view.loadindicator.progressbar.bg.visible = false;
		addChild(this.m_view);
		this.m_originalBackgroundWidth = this.m_view.loadindicator.loadbarbg.width;
	}

	public function ShowLoadindicator(_arg_1:Object):void {
		this.m_view.alpha = 1;
		this.m_discrete = ((_arg_1.discrete) ? true : false);
		if (!this.m_hasSetBarcodeScale) {
			this.resizeBarcodes(false);
		}
		;
		this.m_view.loadindicator.icon.visible = ((_arg_1.discrete) ? false : true);
		this.m_view.loadindicator.progressbar.visible = ((_arg_1.discrete) ? false : true);
		this.m_view.loadindicator.header.visible = ((_arg_1.discrete) ? false : true);
		if (!this.m_bootFlowMode) {
			this.m_view.loadindicator.loadbarbg.gotoAndStop(((_arg_1.discrete) ? 2 : 1));
			this.m_originalBackgroundWidth = this.m_view.loadindicator.loadbarbg.width;
		}
		;
		this.m_view.loadindicator.loadbarbg.x = ((_arg_1.discrete) ? -13 : -53);
		MenuUtils.setupIcon(this.m_view.loadindicator.icon, _arg_1.icon, MenuConstants.COLOR_WHITE, false, true, MenuConstants.COLOR_WHITE, 1, 0, true);
		this.setText(_arg_1.header);
		MenuUtils.setColor(this.m_view.loadindicator.barcodes, MenuConstants.COLOR_WHITE);
		this.m_view.loadindicator.barcodes.visible = ((_arg_1.showbarcodes) ? true : false);
		this.startAnim();
	}

	public function HideLoadindicator():void {
		this.m_hasSetBarcodeScale = false;
		this.stopAnim();
	}

	public function set BootFlowMode(_arg_1:Boolean):void {
		this.m_bootFlowMode = _arg_1;
		this.m_view.loadindicator.loadbarbg.gotoAndStop(((_arg_1) ? 3 : 1));
		this.m_originalBackgroundWidth = this.m_view.loadindicator.loadbarbg.width;
	}

	public function setText(_arg_1:String):void {
		var _local_2:Number = -1;
		var _local_3:Number = 9;
		this.m_view.loadindicator.header.multiline = false;
		this.m_view.loadindicator.header.wordWrap = false;
		if (_arg_1 == null) {
			_arg_1 = "";
		}
		;
		MenuUtils.setupTextUpper(this.m_view.loadindicator.header, _arg_1, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		CommonUtils.changeFontToGlobalIfNeeded(this.m_view.loadindicator.header);
		var _local_4:Boolean = MenuUtils.setupTextAndShrinkToFitUpper(this.m_view.loadindicator.header, _arg_1, 18, MenuConstants.FONT_TYPE_MEDIUM, this.m_view.loadindicator.header.width, _local_2, _local_3, MenuConstants.FontColorWhite);
		if (!_local_4) {
			this.m_view.loadindicator.header.multiline = true;
			this.m_view.loadindicator.header.wordWrap = true;
		}
		;
	}

	override public function onSetVisible(_arg_1:Boolean):void {
	}

	public function showSaveIcon():void {
		this.ShowLoadindicator({
			"header": Localization.get("UI_HUD_SAVING"),
			"icon": "save",
			"showbarcodes": true
		});
	}

	public function hideSaveIcon():void {
		this.HideLoadindicator();
	}

	public function startAnim():void {
		this.pushBarcodeAnim();
		if (this.m_animated) {
			return;
		}
		;
		this.m_animated = true;
		this.m_prevFrame = getTimer();
		if (this.m_discrete) {
			this.m_view.gotoAndStop(15);
		} else {
			this.m_view.gotoAndPlay(2);
		}
		;
	}

	public function stopAnim():void {
		this.popBarcodeAnim();
		if (!this.m_animated) {
			return;
		}
		;
		this.m_animated = false;
		if (this.m_discrete) {
			this.m_view.alpha = 0;
		}
		;
		this.m_view.gotoAndPlay(21);
	}

	private function pushBarcodeAnim():void {
		var view:GlobalLoadindicator;
		var startFrame:Number = this.m_view.loadindicator.barcodes.currentFrame;
		var endFrame:Number = (161 + this.m_totalFrames);
		if (((startFrame < 161) || (startFrame == endFrame))) {
			startFrame = 161;
		}
		;
		var numFrames:Number = (endFrame - startFrame);
		var dur:Number = ((endFrame - startFrame) / this.m_fpsToReach);
		view = this;
		Animate.fromTo(this.m_view.loadindicator.barcodes, dur, 0, {"frames": startFrame}, {"frames": endFrame}, Animate.Linear, function ():void {
			if (view.m_animated) {
				pushBarcodeAnim();
			}
			;
		});
	}

	private function popBarcodeAnim():void {
		Animate.kill(this.m_view.loadindicator.barcodes);
	}

	private function update(_arg_1:Event):void {
		this.m_currentFrame = getTimer();
		this.m_deltaTime = ((this.m_currentFrame - this.m_prevFrame) * 0.001);
		this.m_prevFrame = this.m_currentFrame;
		this.m_frameFactor = (this.m_frameFactor + (this.m_fpsToReach * this.m_deltaTime));
		this.m_frame = Math.ceil(this.m_frameFactor);
		if (this.m_frame > this.m_totalFrames) {
			this.m_frameFactor = 0;
		}
		;
		this.m_view.loadindicator.barcodes.gotoAndStop((161 + this.m_frame));
	}

	public function setProgress(_arg_1:Number):void {
		if (!this.m_hasSetBarcodeScale) {
			this.resizeBarcodes(true);
			this.m_hasSetBarcodeScale = true;
		}
		;
		this.m_view.loadindicator.progressbar.bar.visible = true;
		this.m_view.loadindicator.progressbar.bg.visible = true;
		this.m_view.loadindicator.progressbar.visible = true;
		this.m_view.loadindicator.progressbar.bar.scaleX = _arg_1;
	}

	public function showProgress(_arg_1:Boolean):void {
		this.m_view.loadindicator.progressbar.bar.visible = _arg_1;
		this.m_view.loadindicator.progressbar.bg.visible = _arg_1;
		this.m_view.loadindicator.progressbar.visible = _arg_1;
	}

	private function resizeBarcodes(_arg_1:Boolean):void {
		if (_arg_1) {
			this.m_view.loadindicator.barcodes.y = 46;
			this.m_view.loadindicator.barcodes.scaleY = 0.25;
		} else {
			this.m_view.loadindicator.barcodes.y = 37;
			this.m_view.loadindicator.barcodes.scaleY = 0.813;
		}
		;
	}

	override public function onSetSize(_arg_1:Number, _arg_2:Number):void {
		super.onSetSize(_arg_1, _arg_2);
		if (this.m_bootFlowMode) {
			return;
		}
		;
		if (ControlsMain.isVrModeActive()) {
			this.m_view.loadindicator.loadbarbg.width = 230;
		} else {
			this.m_view.loadindicator.loadbarbg.width = this.m_originalBackgroundWidth;
		}
		;
	}


}
}//package basic

