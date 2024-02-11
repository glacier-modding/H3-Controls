// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.tests.elusivetargetbriefingsequence.ElusiveTargetTesterSequenceBase

package menu3.tests.elusivetargetbriefingsequence {
import menu3.MenuElementBase;
import menu3.CountDownTimer;
import menu3.basic.TextTickerUtil;

import common.menu.MenuConstants;

import flash.display.Sprite;

import common.Animate;

import flash.display.DisplayObjectContainer;
import flash.text.TextField;

import common.menu.MenuUtils;
import common.Localization;

public dynamic class ElusiveTargetTesterSequenceBase extends MenuElementBase {

	public var m_countDownTimer:CountDownTimer;
	private var m_textTickerUtil:TextTickerUtil = new TextTickerUtil();
	public var m_textFieldVars:Object;
	public var m_unitWidth:Number = (MenuConstants.BaseWidth / 10);
	public var m_unitHeight:Number = (MenuConstants.BaseHeight / 6);

	public function ElusiveTargetTesterSequenceBase(_arg_1:Object) {
		super(_arg_1);
	}

	public function createRedOverlay(data:Object, totalduration:Number, container:Sprite):void {
		var delayDuration:Number;
		var redOverlaySplit01:Sprite;
		var redOverlaySplit02:Sprite;
		delayDuration = ((totalduration - data.animatein.duration) - data.animateout.duration);
		redOverlaySplit01 = new Sprite();
		redOverlaySplit01.name = "redOverlaySplit01";
		redOverlaySplit01.graphics.clear();
		redOverlaySplit01.graphics.beginFill(MenuConstants.COLOR_RED, 1);
		redOverlaySplit02 = new Sprite();
		redOverlaySplit02.name = "redOverlaySplit02";
		redOverlaySplit02.graphics.clear();
		redOverlaySplit02.graphics.beginFill(MenuConstants.COLOR_RED, 1);
		if (data.animatedirection == "horizontal") {
			redOverlaySplit01.graphics.drawRect(0, 0, -(MenuConstants.BaseWidth), MenuConstants.BaseHeight);
			redOverlaySplit01.graphics.endFill();
			redOverlaySplit01.x = (this.m_unitWidth * data.animatein.first_startpos);
			redOverlaySplit02.graphics.drawRect(0, 0, MenuConstants.BaseWidth, MenuConstants.BaseHeight);
			redOverlaySplit02.graphics.endFill();
			redOverlaySplit02.x = (this.m_unitWidth * data.animatein.second_startpos);
			container.addChild(redOverlaySplit01);
			container.addChild(redOverlaySplit02);
			Animate.to(redOverlaySplit01, data.animatein.duration, 0, {"x": (this.m_unitWidth * data.animatein.first_endpos)}, Animate.ExpoOut, function ():void {
				Animate.fromTo(redOverlaySplit01, data.animateout.duration, delayDuration, {"x": (m_unitWidth * data.animateout.first_startpos)}, {"x": (m_unitWidth * data.animateout.first_endpos)}, Animate.ExpoOut);
			});
			Animate.to(redOverlaySplit02, data.animatein.duration, 0, {"x": (this.m_unitWidth * data.animatein.second_endpos)}, Animate.ExpoOut, function ():void {
				Animate.fromTo(redOverlaySplit02, data.animateout.duration, delayDuration, {"x": (m_unitWidth * data.animateout.second_startpos)}, {"x": (m_unitWidth * data.animateout.second_endpos)}, Animate.ExpoOut);
			});
		} else {
			if (data.animatedirection == "vertical") {
				redOverlaySplit01.graphics.drawRect(0, 0, MenuConstants.BaseWidth, -(MenuConstants.BaseHeight));
				redOverlaySplit01.graphics.endFill();
				redOverlaySplit01.y = (this.m_unitHeight * data.animatein.first_startpos);
				redOverlaySplit02.graphics.drawRect(0, 0, MenuConstants.BaseWidth, MenuConstants.BaseHeight);
				redOverlaySplit02.graphics.endFill();
				redOverlaySplit02.y = (this.m_unitHeight * data.animatein.second_startpos);
				container.addChild(redOverlaySplit01);
				container.addChild(redOverlaySplit02);
				Animate.to(redOverlaySplit01, data.animatein.duration, 0, {"y": (this.m_unitHeight * data.animatein.first_endpos)}, Animate.ExpoOut, function ():void {
					Animate.fromTo(redOverlaySplit01, data.animateout.duration, delayDuration, {"y": (m_unitHeight * data.animateout.first_startpos)}, {"y": (m_unitHeight * data.animateout.first_endpos)}, Animate.ExpoOut);
				});
				Animate.to(redOverlaySplit02, data.animatein.duration, 0, {"y": (this.m_unitHeight * data.animatein.second_endpos)}, Animate.ExpoOut, function ():void {
					Animate.fromTo(redOverlaySplit02, data.animateout.duration, delayDuration, {"y": (m_unitHeight * data.animateout.second_startpos)}, {"y": (m_unitHeight * data.animateout.second_endpos)}, Animate.ExpoOut);
				});
			}

		}

	}

	public function animateSequenceContainer(data:Object, currentSequenceContainer:Sprite):void {
		var delayDuration:Number;
		delayDuration = (data.sequence.totalduration - data.sequence.animatein.duration);
		if (data.sequence.animatedirection == "horizontal") {
			currentSequenceContainer.x = (this.m_unitWidth * data.sequence.animatein.startpos);
			currentSequenceContainer.y = 0;
			currentSequenceContainer.alpha = 1;
			Animate.to(currentSequenceContainer, data.sequence.animatein.duration, 0, {"x": (this.m_unitWidth * data.sequence.animatein.endpos)}, Animate.ExpoInOut, function ():void {
				currentSequenceContainer.x = (m_unitWidth * data.sequence.animateout.startpos);
				Animate.to(currentSequenceContainer, data.sequence.animateout.duration, delayDuration, {"x": (m_unitWidth * data.sequence.animateout.endpos)}, Animate.ExpoInOut);
			});
		} else {
			if (data.sequence.animatedirection == "vertical") {
				currentSequenceContainer.x = 0;
				currentSequenceContainer.y = (this.m_unitHeight * data.sequence.animatein.startpos);
				currentSequenceContainer.alpha = 1;
				Animate.to(currentSequenceContainer, data.sequence.animatein.duration, 0, {"y": (this.m_unitHeight * data.sequence.animatein.endpos)}, Animate.ExpoInOut, function ():void {
					currentSequenceContainer.y = (m_unitHeight * data.sequence.animateout.startpos);
					Animate.to(currentSequenceContainer, data.sequence.animateout.duration, delayDuration, {"y": (m_unitHeight * data.sequence.animateout.endpos)}, Animate.ExpoInOut);
				});
			}

		}

	}

	public function animateImageContainer(_arg_1:DisplayObjectContainer, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:Number, _arg_8:Number, _arg_9:String):void {
		var _local_10:int = this.getEasing(_arg_9);
		var _local_11:Number = ((_arg_2 - (_arg_2 * _arg_7)) / 2);
		var _local_12:Number = ((_arg_2 - (_arg_2 * _arg_8)) / 2);
		var _local_13:Number = ((_arg_3 - (_arg_3 * _arg_7)) / 2);
		var _local_14:Number = ((_arg_3 - (_arg_3 * _arg_8)) / 2);
		_arg_1.x = ((this.m_unitWidth * _arg_5) + _local_11);
		_arg_1.y = _local_13;
		_arg_1.scaleX = (_arg_1.scaleY = _arg_7);
		Animate.to(_arg_1, _arg_4, 0, {
			"x": ((this.m_unitWidth * _arg_6) + _local_12),
			"y": _local_14,
			"scaleX": _arg_8,
			"scaleY": _arg_8
		}, _local_10);
	}

	public function insertTextBlock(_arg_1:Object, _arg_2:Number, _arg_3:*):void {
		if (_arg_1.type == "etsequencetimer") {
			_arg_3.x = (this.m_unitWidth * _arg_1.xpos);
			_arg_3.y = (this.m_unitHeight * _arg_1.ypos);
			EtSequenceTextBlocks.setupTimerBlock(_arg_1, _arg_3, this);
			this.animateTextBlock(_arg_3, _arg_1.animatedirection, _arg_1.animatein, _arg_1.animateout, _arg_2);
		}

	}

	private function animateTextBlock(container:*, animatedirection:String, animatein:Object, animateout:Object, totalduration:Number):void {
		var theEasingOut:int;
		var delayDuration:Number;
		var theEasingIn:int = this.getEasing(animatein.easing);
		theEasingOut = this.getEasing(animateout.easing);
		delayDuration = ((totalduration - animatein.duration) - animateout.duration);
		if (animatedirection == "horizontal") {
			Animate.fromTo(container, animatein.duration, 0, {"x": (this.m_unitWidth * animatein.startpos)}, {"x": (this.m_unitWidth * animatein.endpos)}, theEasingIn, function ():void {
				Animate.fromTo(container, animateout.duration, delayDuration, {"x": (m_unitWidth * animateout.startpos)}, {"x": (m_unitWidth * animateout.endpos)}, theEasingOut);
			});
		} else {
			if (animatedirection == "vertical") {
				Animate.fromTo(container, animatein.duration, 0, {"y": (this.m_unitHeight * animatein.startpos)}, {"y": (this.m_unitHeight * animatein.endpos)}, theEasingIn, function ():void {
					Animate.fromTo(container, animateout.duration, delayDuration, {"y": (m_unitHeight * animateout.startpos)}, {"y": (m_unitHeight * animateout.endpos)}, theEasingOut);
				});
			}

		}

	}

	public function getEasing(_arg_1:String):int {
		var _local_2:int;
		switch (_arg_1) {
			case "Linear":
				_local_2 = Animate.Linear;
				break;
			case "SineIn":
				_local_2 = Animate.SineIn;
				break;
			case "SineOut":
				_local_2 = Animate.SineOut;
				break;
			case "SineInOut":
				_local_2 = Animate.SineInOut;
				break;
			case "ExpoIn":
				_local_2 = Animate.ExpoIn;
				break;
			case "ExpoOut":
				_local_2 = Animate.ExpoOut;
				break;
			case "ExpoInOut":
				_local_2 = Animate.ExpoInOut;
				break;
			case "BackIn":
				_local_2 = Animate.BackIn;
				break;
			case "BackOut":
				_local_2 = Animate.BackOut;
				break;
			case "BackInOut":
				_local_2 = Animate.BackInOut;
				break;
			default:
				_local_2 = Animate.Linear;
		}

		return (_local_2);
	}

	public function startCountDownTimer(_arg_1:String, _arg_2:TextField, _arg_3:int):void {
		this.m_textFieldVars = {
			"theTextField": _arg_2,
			"theStyle": _arg_3
		};
		if (this.m_countDownTimer) {
			this.m_countDownTimer.stopCountDown();
			this.m_countDownTimer = null;
		}

		if (((_arg_1) && (!(this.m_countDownTimer)))) {
			this.m_countDownTimer = new CountDownTimer();
			this.m_countDownTimer.startCountDown(_arg_2, _arg_1, this, _arg_3);
		}

	}

	public function stopCountDownTimer():void {
		this.m_countDownTimer.stopCountDown();
		this.m_countDownTimer = null;
	}

	public function timerComplete():void {
		this.m_countDownTimer.stopCountDown();
		this.m_countDownTimer = null;
	}

	private function showTimeRanOut():void {
		MenuUtils.setupText(this.m_textFieldVars.theTextField, Localization.get("UI_CONTRACT_ELUSIVE_STATE_TIME_RAN_OUT"), 148, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorRed);
		MenuUtils.truncateTextfield(this.m_textFieldVars.theTextField, 1, MenuConstants.FontColorRed);
		this.m_textTickerUtil.addTextTicker(this.m_textFieldVars.theTextField, Localization.get("UI_CONTRACT_ELUSIVE_STATE_TIME_RAN_OUT"), MenuConstants.FontColorRed, MenuConstants.COLOR_RED);
	}

	override public function onUnregister():void {
		if (this.m_countDownTimer) {
			trace("XXXXXXXXXXXXXXXXX ElusiveTargetTesterSequenceBase | onUnregister | Stopping m_countDownTimer!!!");
			this.m_countDownTimer.stopCountDown();
			this.m_countDownTimer = null;
		}

		super.onUnregister();
	}


}
}//package menu3.tests.elusivetargetbriefingsequence

