// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.OpportunityPreview

package hud {
import common.BaseControl;

import flash.display.MovieClip;

import basic.DottedLine;

import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.Localization;

import flash.text.TextFieldAutoSize;

import common.CommonUtils;
import common.Animate;

import flash.external.ExternalInterface;

public class OpportunityPreview extends BaseControl {

	public static const TRANSITION_TIME:Number = 0.3;
	public static const STATE_NEAR:String = "Near";
	public static const STATE_FAR:String = "Far";
	public static const STATE_TIMEOUT:String = "TimeoutBar";
	public static const STATE_DEFAULT:String = "";

	private var m_state:String = "";
	private var m_view:OpportunityView;
	private var m_headerFarClip:MovieClip;
	private var m_headerNearClip:MovieClip;
	private var m_titleClip:MovieClip;
	private var m_promptClip:MovieClip;
	private var m_timeoutClip:MovieClip;
	private var m_headerDottedLine:DottedLine;
	private var m_timeoutClipWidth:Number;
	private var m_headerFarInitPosY:Number;
	private var m_Loc_UI_HUD_OPPORTUNITY_NEARBY:String;
	private var m_Loc_UI_HUD_OPPORTUNITY_DISCOVERED:String;
	private var m_Loc_UI_MAP_BUTTON_TRACK_OPPORTUNITY:String;
	private var m_timeOutRunning:Boolean;

	public function OpportunityPreview() {
		this.m_view = new OpportunityView();
		this.m_headerFarClip = this.m_view.headerFarClip;
		this.m_headerNearClip = this.m_view.headerNearClip;
		this.m_titleClip = this.m_view.titleClip;
		this.m_promptClip = this.m_view.promptClip;
		this.m_timeoutClip = this.m_view.timeoutClip;
		this.m_headerFarInitPosY = this.m_headerFarClip.y;
		this.m_timeoutClipWidth = this.m_timeoutClip.width;
		MenuUtils.setColor(this.m_timeoutClip.fill, MenuConstants.COLOR_TURQUOISE);
		MenuUtils.setColor(this.m_timeoutClip.bg, MenuConstants.COLOR_BLACK);
		this.m_timeoutClip.bg.alpha = 0.5;
		addChild(this.m_view);
		this.m_view.visible = false;
		this.m_Loc_UI_HUD_OPPORTUNITY_NEARBY = Localization.get("UI_HUD_OPPORTUNITY_NEARBY").toUpperCase();
		this.m_Loc_UI_HUD_OPPORTUNITY_DISCOVERED = Localization.get("UI_HUD_OPPORTUNITY_DISCOVERED").toUpperCase();
		this.m_Loc_UI_MAP_BUTTON_TRACK_OPPORTUNITY = Localization.get("UI_MAP_BUTTON_TRACK_OPPORTUNITY").toUpperCase();
		MenuUtils.setupText(this.m_headerFarClip.txtLabel, this.m_Loc_UI_HUD_OPPORTUNITY_NEARBY, 26, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite, true);
		this.m_headerFarClip.txtLabel.autoSize = TextFieldAutoSize.CENTER;
		MenuUtils.setupText(this.m_headerNearClip.txtLabel, this.m_Loc_UI_HUD_OPPORTUNITY_DISCOVERED, 26, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite, true);
		this.m_headerNearClip.txtLabel.autoSize = TextFieldAutoSize.CENTER;
		this.addDottedLine();
		MenuUtils.setupText(this.m_titleClip.txtLabel, this.m_Loc_UI_MAP_BUTTON_TRACK_OPPORTUNITY, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_promptClip.txtLabel, getOpportunityAcceptLocalized(), 15, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
	}

	private static function getOpportunityAcceptLocalized():String {
		if (CommonUtils.getPlatformString() == CommonUtils.PLATFORM_ORBIS) {
			return (Localization.get("UI_HUD_OPPORTUNITY_ACCEPT_PS4"));
		}
		;
		if (CommonUtils.isPCVRControllerUsed()) {
			return (Localization.get("UI_HUD_OPPORTUNITY_ACCEPT_PCVR"));
		}
		;
		return (Localization.get("UI_HUD_OPPORTUNITY_ACCEPT"));
	}


	public function onControlLayoutChanged():void {
		this.m_promptClip.txtLabel.htmlText = getOpportunityAcceptLocalized();
	}

	public function onSetData(_arg_1:Object):void {
		this.m_state = _arg_1.state;
		switch (_arg_1.state) {
			case STATE_NEAR:
				this.handleUpdatedNearView(_arg_1);
				return;
			case STATE_FAR:
				this.handleUpdatedFarView(_arg_1);
				return;
			case STATE_TIMEOUT:
				this.handleUpdateTimeoutBar(_arg_1);
				return;
			default:
				this.handleUpdatedViewBlendOut(_arg_1);
		}
		;
	}

	private function handleUpdateTimeoutBar(_arg_1:Object):void {
		if (!this.m_timeOutRunning) {
			this.m_timeOutRunning = true;
			this.playSound("play_gui_opportunity_timer");
		}
		;
		var _local_2:Number = (_arg_1.durationTimeLeft / _arg_1.duration);
		_local_2 = Math.max(0, Math.min(_local_2, 1));
		this.m_timeoutClip.fill.scaleX = _local_2;
	}

	private function handleUpdatedFarView(_arg_1:Object):void {
		this.m_titleClip.visible = false;
		this.m_timeoutClip.visible = false;
		this.m_promptClip.visible = false;
		this.m_headerNearClip.visible = false;
		this.m_headerFarClip.visible = true;
		this.m_view.visible = true;
		this.m_view.alpha = 1;
		this.m_headerFarClip.alpha = 0;
		this.m_headerFarClip.y = (this.m_headerFarInitPosY + 20);
		Animate.to(this.m_headerFarClip, 0.2, 0, {"alpha": 1}, Animate.ExpoOut);
		Animate.addTo(this.m_headerFarClip, 0.5, 0, {"y": this.m_headerFarInitPosY}, Animate.ExpoOut);
		this.m_headerDottedLine.alpha = 0;
		Animate.to(this.m_headerDottedLine, TRANSITION_TIME, 0.3, {"alpha": 1}, Animate.ExpoOut);
	}

	private function handleUpdatedNearView(_arg_1:Object):void {
		this.m_headerFarClip.visible = false;
		this.m_headerDottedLine.alpha = 0;
		this.m_headerNearClip.visible = true;
		this.m_timeoutClip.width = this.m_headerNearClip.width;
		this.m_timeoutClip.fill.scaleX = 1;
		this.m_view.visible = true;
		this.m_view.alpha = 1;
		this.m_headerNearClip.alpha = 1;
		Animate.fromTo(this.m_headerNearClip, 0.2, 0, {
			"scaleX": 1.5,
			"scaleY": 1.5
		}, {
			"scaleX": 1,
			"scaleY": 1
		}, Animate.ExpoOut);
		this.m_timeoutClip.visible = true;
		this.m_timeoutClip.alpha = 0;
		Animate.to(this.m_timeoutClip, TRANSITION_TIME, 0.2, {"alpha": 1}, Animate.ExpoOut);
		this.m_titleClip.visible = true;
		this.m_titleClip.alpha = 0;
		Animate.to(this.m_titleClip, TRANSITION_TIME, 0.3, {"alpha": 1}, Animate.ExpoOut);
		this.m_promptClip.visible = true;
		this.m_promptClip.alpha = 0;
		Animate.to(this.m_promptClip, 1, 0.6, {"alpha": 1}, Animate.ExpoOut);
	}

	private function handleUpdatedViewBlendOut(iData:Object):void {
		Animate.delay(this.m_view, 0.5, function ():void {
			if (m_timeOutRunning) {
				m_timeOutRunning = false;
				playSound("stop_gui_opportunity_timer");
			}
			;
			if (m_state != STATE_DEFAULT) {
				return;
			}
			;
			Animate.to(m_view, TRANSITION_TIME, 0, {"alpha": 0}, Animate.ExpoOut, function ():void {
				m_view.visible = false;
			});
		});
	}

	private function addDottedLine():void {
		this.removeDottedLine();
		var _local_1:Number = this.m_headerFarClip.width;
		this.m_headerDottedLine = new DottedLine(_local_1, MenuConstants.COLOR_WHITE, DottedLine.TYPE_HORIZONTAL, 2, 4);
		this.m_headerDottedLine.x = -(_local_1 >> 1);
		this.m_headerDottedLine.y = this.m_timeoutClip.y;
		this.m_headerDottedLine.alpha = 0;
		this.m_view.addChild(this.m_headerDottedLine);
	}

	private function removeDottedLine():void {
		if (this.m_headerDottedLine != null) {
			this.m_view.removeChild(this.m_headerDottedLine);
			this.m_headerDottedLine = null;
		}
		;
	}

	public function playSound(_arg_1:String):void {
		ExternalInterface.call("PlaySound", _arg_1);
	}


}
}//package hud

