// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.SubtitleSpeakerIndicator

package hud {
import common.BaseControl;

import flash.display.Sprite;

import common.Animate;

public class SubtitleSpeakerIndicator extends BaseControl {

	public static const ICON_NONE:int = 0;
	public static const ICON_BUBBLE_BL:int = 1;
	public static const ICON_BUBBLE_BR:int = 2;
	public static const ICON_BUBBLE_B:int = 3;
	public static const ICON_BUBBLE_L:int = 4;
	public static const ICON_BUBBLE_R:int = 5;
	public static const ICON_BUBBLE_T:int = 6;
	public static const ICON_JAGGED_BL:int = 7;
	public static const ICON_JAGGED_BR:int = 8;
	public static const ICON_JAGGED_B:int = 9;
	public static const ICON_JAGGED_L:int = 10;
	public static const ICON_JAGGED_R:int = 11;
	public static const ICON_JAGGED_T:int = 12;

	private var m_cinematicWrapper:Sprite;
	private var m_iconView:Icons_SubtitleSpeaker_InWorld;
	private var m_fScaleBase:Number = 1;

	public function SubtitleSpeakerIndicator() {
		this.m_cinematicWrapper = new Sprite();
		this.m_cinematicWrapper.name = "m_cinematicWrapper";
		this.m_cinematicWrapper.alpha = 0;
		addChild(this.m_cinematicWrapper);
		this.m_iconView = new Icons_SubtitleSpeaker_InWorld();
		this.m_iconView.name = "m_iconView";
		this.m_iconView.alpha = 0;
		this.m_cinematicWrapper.addChild(this.m_iconView);
		this.m_iconView.blink_mc.stop();
		this.m_iconView.blinkDropShadow_mc.stop();
	}

	public function setCinematicMode(_arg_1:Number):void {
		this.m_cinematicWrapper.alpha = (1 - _arg_1);
	}

	public function hideIcon():void {
		Animate.kill(this.m_iconView);
		this.m_iconView.alpha = 0;
		this.m_iconView.blink_mc.stop();
		this.m_iconView.blinkDropShadow_mc.stop();
	}

	public function showNewIcon(iIcon:int):void {
		this.m_iconView.gotoAndStop(iIcon);
		this.m_iconView.blink_mc.gotoAndStop(1);
		this.m_iconView.blinkDropShadow_mc.gotoAndStop(1);
		this.m_iconView.blink_mc.pulse_mc.gotoAndStop(((iIcon <= ICON_BUBBLE_T) ? "round" : "square"));
		this.m_iconView.blinkDropShadow_mc.pulse_mc.gotoAndStop(((iIcon <= ICON_BUBBLE_T) ? "round" : "square"));
		this.m_iconView.alpha = 0;
		this.m_iconView.scaleX = 0;
		this.m_iconView.scaleY = 0;
		Animate.fromTo(this.m_iconView, 0.4, 0, {
			"alpha": 1,
			"scaleX": 0,
			"scaleY": 0
		}, {
			"alpha": 1,
			"scaleX": this.m_fScaleBase,
			"scaleY": this.m_fScaleBase
		}, Animate.ExpoOut, function ():void {
			m_iconView.blink_mc.play();
			m_iconView.blinkDropShadow_mc.play();
		});
	}

	public function updateIcon(_arg_1:int):void {
		this.m_iconView.gotoAndStop(_arg_1);
	}

	override public function onSetViewport(_arg_1:Number, _arg_2:Number, _arg_3:Number):void {
		this.m_fScaleBase = Math.min(_arg_1, _arg_2);
		this.m_iconView.scaleX = this.m_fScaleBase;
		this.m_iconView.scaleY = this.m_fScaleBase;
	}


}
}//package hud

