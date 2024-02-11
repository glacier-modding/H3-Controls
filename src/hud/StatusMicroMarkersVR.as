// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.StatusMicroMarkersVR

package hud {
import common.BaseControl;

import flash.display.MovieClip;
import flash.display.Graphics;

import common.TaskletSequencer;
import common.Animate;

public class StatusMicroMarkersVR extends BaseControl {

	private static const DX_GAP_BETWEEN_INDICATORS:Number = 8;
	private static const ICON_SEARCHING:int = 1;
	private static const ICON_COMPROMISED:int = 2;
	private static const ICON_HUNTED:int = 3;
	private static const ICON_COMBAT:int = 4;
	private static const ICON_SECURITYCAMERA:int = 5;
	private static const ICON_HIDDENINLVA:int = 6;
	private static const ICON_QUESTIONMARK:int = 7;
	private static const ICON_UNCONSCIOUSWITNESS:int = 8;

	private var m_tensionIndicatorMc:MovieClip;
	private var m_informationBarLVA:MovieClip;
	private var m_trespassingIndicatorMc:MovieClip;
	private var m_timerView:TimerView = new TimerView();
	private var m_isTensionIndicatorVisible:Boolean = false;
	private var m_isLVAIndicatorVisible:Boolean = false;
	private var m_isTrespassingIndicatorVisible:Boolean = false;
	private var m_widthIndicator:Number;
	private var m_heightIndicator:Number;
	private var m_isRightAligned:Boolean = false;

	public function StatusMicroMarkersVR() {
		var _local_1:StatusMarkerView = new StatusMarkerView();
		this.m_trespassingIndicatorMc = _local_1.trespassingIndicatorMc;
		this.m_trespassingIndicatorMc.removeChild(this.m_trespassingIndicatorMc.bgGradient);
		this.m_trespassingIndicatorMc.removeChild(this.m_trespassingIndicatorMc.overlayMc);
		this.m_trespassingIndicatorMc.removeChild(this.m_trespassingIndicatorMc.pulseMc);
		this.m_trespassingIndicatorMc.removeChild(this.m_trespassingIndicatorMc.labelTxt);
		this.m_trespassingIndicatorMc.bgMc.width = this.m_trespassingIndicatorMc.bgMc.height;
		this.m_trespassingIndicatorMc.bgMc.x = (this.m_trespassingIndicatorMc.bgMc.width / 2);
		this.m_trespassingIndicatorMc.x = (this.m_trespassingIndicatorMc.y = 0);
		this.m_trespassingIndicatorMc.scaleX = (this.m_trespassingIndicatorMc.scaleY = 0);
		addChild(this.m_trespassingIndicatorMc);
		this.m_widthIndicator = this.m_trespassingIndicatorMc.bgMc.width;
		this.m_heightIndicator = this.m_trespassingIndicatorMc.bgMc.height;
		this.m_informationBarLVA = _local_1.informationBarLVA;
		this.m_informationBarLVA.removeChild(this.m_informationBarLVA.labelTxt);
		this.m_informationBarLVA.iconMc.gotoAndStop(ICON_HIDDENINLVA);
		var _local_2:Number = 1;
		var _local_3:Number = 1;
		var _local_4:uint = 0xFFFFFF;
		var _local_5:Number = 1;
		var _local_6:uint;
		var _local_7:Graphics = this.m_informationBarLVA.graphics;
		_local_7.beginFill(_local_4, _local_3);
		_local_7.drawRect(0, 0, this.m_widthIndicator, this.m_heightIndicator);
		_local_7.endFill();
		_local_7.beginFill(_local_6, _local_5);
		_local_7.drawRect(_local_2, _local_2, (this.m_widthIndicator - (2 * _local_2)), (this.m_heightIndicator - (2 * _local_2)));
		_local_7.endFill();
		this.m_informationBarLVA.x = (this.m_informationBarLVA.y = 0);
		this.m_informationBarLVA.scaleX = (this.m_informationBarLVA.scaleY = 0);
		addChild(this.m_informationBarLVA);
		this.m_tensionIndicatorMc = _local_1.tensionIndicatorMc;
		this.m_tensionIndicatorMc.removeChild(this.m_tensionIndicatorMc.bgGradient);
		this.m_tensionIndicatorMc.removeChild(this.m_tensionIndicatorMc.unconMc);
		this.m_tensionIndicatorMc.removeChild(this.m_tensionIndicatorMc.labelTxt);
		this.m_tensionIndicatorMc.bgMc.width = this.m_tensionIndicatorMc.bgMc.height;
		this.m_tensionIndicatorMc.x = (this.m_tensionIndicatorMc.y = 0);
		this.m_tensionIndicatorMc.scaleX = (this.m_tensionIndicatorMc.scaleY = 0);
		addChild(this.m_tensionIndicatorMc);
		addChild(this.m_timerView);
		this.m_timerView.rotationX = 1;
		this.m_timerView.rotationX = 0;
		this.m_timerView.visible = false;
	}

	public function set xTimerView(_arg_1:Number):void {
		this.m_timerView.x = _arg_1;
	}

	public function set yTimerView(_arg_1:Number):void {
		this.m_timerView.y = _arg_1;
	}

	public function set zTimerView(_arg_1:Number):void {
		this.m_timerView.z = _arg_1;
	}

	public function set degRotationTimerView(_arg_1:Number):void {
		this.m_timerView.rotationX = _arg_1;
	}

	public function onSetData(_arg_1:Object):void {
		this.m_isTrespassingIndicatorVisible = ((_arg_1.bTrespassing) || (_arg_1.bDeepTrespassing));
		TaskletSequencer.getGlobalInstance().addChunk(this.updateIndicators);
	}

	public function setInLVA(_arg_1:Boolean):void {
		this.m_isLVAIndicatorVisible = _arg_1;
		TaskletSequencer.getGlobalInstance().addChunk(this.updateIndicators);
	}

	public function setTensionMessage(msg:String, state:Number, nWitnesses:int):void {
		TaskletSequencer.getGlobalInstance().addChunk(function ():void {
			if (msg == "") {
				m_isTensionIndicatorVisible = false;
			} else {
				if (nWitnesses >= 1) {
					m_tensionIndicatorMc.iconMc.gotoAndStop(ICON_UNCONSCIOUSWITNESS);
				} else {
					m_tensionIndicatorMc.iconMc.gotoAndStop(((state > 0) ? state : 1));
				}

				m_isTensionIndicatorVisible = true;
			}

			updateIndicators();
		});
	}

	private function updateIndicators():void {
		var _local_2:Number;
		var _local_1:Number = 0;
		var _local_3:Number = ((this.m_isRightAligned) ? -1 : 1);
		_local_2 = ((this.m_isTensionIndicatorVisible) ? 1 : 0);
		Animate.to(this.m_tensionIndicatorMc, 0.5, 0, {
			"x": (_local_3 * _local_1),
			"scaleX": (_local_3 * _local_2),
			"scaleY": _local_2
		}, Animate.ExpoOut);
		if (this.m_isTensionIndicatorVisible) {
			_local_1 = (_local_1 + (this.m_widthIndicator + DX_GAP_BETWEEN_INDICATORS));
		}

		_local_2 = ((this.m_isLVAIndicatorVisible) ? 1 : 0);
		Animate.to(this.m_informationBarLVA, 0.5, 0, {
			"x": (_local_3 * _local_1),
			"scaleX": (_local_3 * _local_2),
			"scaleY": _local_2
		}, Animate.ExpoOut);
		if (this.m_isLVAIndicatorVisible) {
			_local_1 = (_local_1 + (this.m_widthIndicator + DX_GAP_BETWEEN_INDICATORS));
		}

		_local_2 = ((this.m_isTrespassingIndicatorVisible) ? 1 : 0);
		Animate.to(this.m_trespassingIndicatorMc, 0.5, 0, {
			"x": (_local_3 * _local_1),
			"scaleX": (_local_3 * _local_2),
			"scaleY": _local_2
		}, Animate.ExpoOut);
	}

	public function updateTimers(timers:Array):void {
		if (timers.length == 0) {
			this.m_timerView.visible = false;
			return;
		}

		this.m_timerView.visible = true;
		this.m_timerView.value_txt.text = timers[0].timerString;
		this.m_timerView.clockIcon.alpha = 0;
		Animate.to(this.m_timerView.clockIcon, 1.2, 0, {"alpha": 1}, Animate.ExpoOut, function ():void {
			m_timerView.visible = false;
		});
	}

	public function setRightAligned(_arg_1:Boolean):void {
		this.m_isRightAligned = _arg_1;
		this.updateIndicators();
		this.m_timerView.setRightAligned(_arg_1);
	}


}
}//package hud

import flash.display.Sprite;
import flash.display.DisplayObject;
import flash.text.TextField;

import common.menu.MenuUtils;
import common.menu.MenuConstants;

class TimerView extends Sprite {

	public var clockIcon:DisplayObject;
	public var bg:DisplayObject;
	public var value_txt:TextField;

	public function TimerView() {
		this.name = "timerView";
		var _local_1:LevelObjectiveView = new LevelObjectiveView();
		this.bg = _local_1.counterTimer_mc.static_bg.getChildAt(0);
		this.bg.x = -1;
		this.bg.y = -1;
		this.addChild(this.bg);
		_local_1.iconAnim_mc.icon_mc.gotoAndStop(1);
		_local_1.iconAnim_mc.icon_mc.type_mc.gotoAndStop(4);
		this.clockIcon = _local_1.iconAnim_mc.icon_mc.type_mc.getChildAt(0);
		this.addChild(this.clockIcon);
		this.value_txt = _local_1.counterTimer_mc.value_txt;
		this.value_txt.y = -5;
		this.value_txt.x = (this.clockIcon.width + 5);
		MenuUtils.setupText(this.value_txt, "", 24, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorGreyUltraDark);
		this.addChild(this.value_txt);
		this.value_txt.text = "00:00";
		this.bg.width = ((this.value_txt.x + this.value_txt.textWidth) + 10);
		this.bg.height = (this.clockIcon.height + 2);
		this.bg.scaleX = (this.bg.scaleX * -1);
	}

	public function setRightAligned(_arg_1:Boolean):void {
		if (!_arg_1) {
			this.bg.x = -1;
		} else {
			this.bg.x = (-(this.bg.width) - 1);
		}

		this.clockIcon.x = (this.bg.x + 1);
		this.value_txt.x = ((this.clockIcon.x + this.clockIcon.width) + 5);
	}


}


