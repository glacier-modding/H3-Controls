﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.briefing.BriefingSequenceTimerTextBlock

package menu3.briefing {
import common.BaseControl;

import flash.text.TextField;
import flash.display.Sprite;

import common.menu.MenuConstants;

import flash.text.TextFormat;

import common.menu.MenuUtils;

import flash.text.TextLineMetrics;

import common.Animate;


public class BriefingSequenceTimerTextBlock extends BaseControl {

	public var m_countDownTimer:BriefingSequenceTimer;
	private var m_theTextField:TextField;
	private var m_playableUntil:String = "";
	private var m_countDownTextContainer:Sprite;
	private var m_textFieldRows:Number = 0;
	private var m_flickerIn:Boolean;
	private var m_flickerOut:Boolean;
	private var m_fontStyle:String;
	private var m_fontSize:int;
	private var m_fontColorBlack:Boolean;
	private var m_textRightAligned:Boolean;
	private var m_appendUpwards:Boolean;
	private var m_showRegPoint:Boolean;
	private var m_animateInDuration:Number;
	private var m_animateInStartRow:Number;
	private var m_animateInEndRow:Number;
	private var m_animateInStartCol:Number;
	private var m_animateInEndCol:Number;
	private var m_animateInEasingType:int;
	private var m_animateOutDuration:Number;
	private var m_animateOutStartRow:Number;
	private var m_animateOutEndRow:Number;
	private var m_animateOutStartCol:Number;
	private var m_animateOutEndCol:Number;
	private var m_animateOutEasingType:int;
	private var m_unitWidth:Number = (MenuConstants.BaseWidth / 10);
	private var m_unitHeight:Number = (MenuConstants.BaseHeight / 6);

	public function BriefingSequenceTimerTextBlock() {
		trace("ETBriefing | BriefingSequenceTimerTextBlock CALLED!!!");
		this.m_countDownTextContainer = new Sprite();
		this.m_countDownTextContainer.name = "m_countDownTextContainer";
		addChild(this.m_countDownTextContainer);
	}

	private function startCountDownTimer(_arg_1:TextField, _arg_2:String):void {
		if (this.m_countDownTimer) {
			this.m_countDownTimer.stopCountDown();
			this.m_countDownTimer = null;
		}

		if (((_arg_2) && (!(this.m_countDownTimer)))) {
			this.m_countDownTimer = new BriefingSequenceTimer();
			this.m_countDownTimer.startCountDown(_arg_1, _arg_2, this, this.m_fontStyle, this.m_fontSize, this.m_fontColorBlack);
		}

	}

	public function stopCountDownTimer():void {
		trace("ETBriefing | BriefingSequenceTimerTextBlock | stopCountDownTimer CALLED!!!");
		this.m_countDownTimer.stopCountDown();
		this.m_countDownTimer = null;
	}

	public function timerComplete():void {
		this.m_countDownTimer.stopCountDown();
		this.m_countDownTimer = null;
	}

	public function start(_arg_1:Number, _arg_2:Number):void {
		var _local_8:DotIndicatorView;
		this.m_countDownTextContainer.x = (this.m_unitWidth * this.m_animateInStartRow);
		this.m_countDownTextContainer.y = (this.m_unitHeight * this.m_animateInStartCol);
		var _local_3:TextFormat = new TextFormat();
		if (this.m_textRightAligned) {
			_local_3.align = "right";
		}

		this.m_theTextField = new TextField();
		this.m_theTextField.alpha = 0;
		this.m_theTextField.autoSize = "left";
		this.m_theTextField.width = (this.m_unitWidth * this.m_textFieldRows);
		MenuUtils.setupText(this.m_theTextField, "PgpqjMNOPQwWx:0123456789", this.m_fontSize, this.m_fontStyle, ((this.m_fontColorBlack) ? MenuConstants.FontColorBlack : MenuConstants.FontColorGreyUltraLight));
		var _local_4:TextLineMetrics = this.m_theTextField.getLineMetrics(0);
		this.m_theTextField.setTextFormat(_local_3);
		this.m_countDownTextContainer.addChild(this.m_theTextField);
		this.startCountDownTimer(this.m_theTextField, this.m_playableUntil);
		this.m_theTextField.setTextFormat(_local_3);
		this.m_theTextField.alpha = 1;
		var _local_5:Number = _local_4.ascent;
		var _local_6:int = 3;
		var _local_7:int = Math.ceil((this.m_fontSize * 0.23));
		this.m_theTextField.x = -(_local_6);
		this.m_theTextField.y = -(_local_7);
		if (this.m_appendUpwards) {
			this.m_theTextField.y = -(_local_5);
		}

		if (this.m_showRegPoint) {
			_local_8 = new DotIndicatorView();
			this.m_countDownTextContainer.addChild(_local_8);
		}

		Animate.delay(this, _arg_2, this.startSequence, _arg_1);
	}

	private function startSequence(baseduration:Number):void {
		var delayDuration:Number;
		var flickerInDurations:Vector.<Number>;
		var flickerOutDurations:Vector.<Number>;
		var flickerOutTotalDuration:Number;
		var i:int;
		Animate.kill(this);
		Animate.kill(this.m_theTextField);
		delayDuration = ((baseduration - this.m_animateInDuration) - this.m_animateOutDuration);
		if (this.m_flickerIn) {
			flickerInDurations = new Vector.<Number>();
			this.pushFlickerValues(flickerInDurations);
			this.startFlicker(flickerInDurations);
		}

		if (this.m_flickerOut) {
			flickerOutDurations = new Vector.<Number>();
			this.pushFlickerValues(flickerOutDurations);
			flickerOutTotalDuration = 0;
			i = 0;
			while (i < flickerOutDurations.length) {
				flickerOutTotalDuration = (flickerOutTotalDuration + flickerOutDurations[i]);
				i = (i + 1);
			}

			Animate.delay(this, (baseduration - flickerOutTotalDuration), this.startFlicker, flickerOutDurations);
		}

		Animate.to(this.m_countDownTextContainer, this.m_animateInDuration, 0, {
			"x": (this.m_unitWidth * this.m_animateInEndRow),
			"y": (this.m_unitHeight * this.m_animateInEndCol)
		}, this.m_animateInEasingType, function ():void {
			Animate.fromTo(m_countDownTextContainer, m_animateOutDuration, delayDuration, {
				"x": (m_unitWidth * m_animateOutStartRow),
				"y": (m_unitHeight * m_animateOutStartCol)
			}, {
				"x": (m_unitWidth * m_animateOutEndRow),
				"y": (m_unitHeight * m_animateOutEndCol)
			}, m_animateOutEasingType);
		});
	}

	private function startFlicker(_arg_1:Vector.<Number>):void {
		Animate.kill(this.m_theTextField);
		if (this.m_theTextField.alpha > 0) {
			this.m_theTextField.alpha = 0;
		} else {
			if (this.m_theTextField.alpha == 0) {
				this.m_theTextField.alpha = (this.getRandomRange(2, 10) / 10);
			}

		}

		if (_arg_1.length >= 1) {
			Animate.delay(this.m_theTextField, _arg_1.pop(), this.startFlicker, _arg_1);
		} else {
			if (this.m_flickerIn) {
				this.m_theTextField.alpha = 1;
				this.m_flickerIn = false;
			} else {
				if (this.m_flickerOut) {
					this.m_theTextField.alpha = 0;
					this.m_flickerOut = false;
				}

			}

		}

	}

	private function getRandomRange(_arg_1:Number, _arg_2:Number):Number {
		return (Math.floor((Math.random() * ((_arg_2 - _arg_1) + 1))) + _arg_1);
	}

	private function pushFlickerValues(_arg_1:Vector.<Number>):void {
		var _local_2:int = this.getRandomRange(3, 10);
		var _local_3:int;
		while (_local_3 < _local_2) {
			_arg_1.push((this.getRandomRange(2, 20) / 300));
			_local_3++;
		}

	}

	override public function getContainer():Sprite {
		return (this.m_countDownTextContainer);
	}

	public function set PlayableUntil(_arg_1:String):void {
		this.m_playableUntil = _arg_1;
	}

	public function set TextFieldWidthInRows(_arg_1:Number):void {
		this.m_textFieldRows = _arg_1;
	}

	public function set FontStyle(_arg_1:String):void {
		switch (_arg_1) {
			case "Light":
				this.m_fontStyle = MenuConstants.FONT_TYPE_LIGHT;
				return;
			case "Normal":
				this.m_fontStyle = MenuConstants.FONT_TYPE_NORMAL;
				return;
			case "Medium":
				this.m_fontStyle = MenuConstants.FONT_TYPE_MEDIUM;
				return;
			case "Bold":
				this.m_fontStyle = MenuConstants.FONT_TYPE_BOLD;
				return;
			default:
				this.m_fontStyle = MenuConstants.FONT_TYPE_NORMAL;
		}

	}

	public function set FontSize(_arg_1:int):void {
		this.m_fontSize = _arg_1;
	}

	public function set FontColorBlack(_arg_1:Boolean):void {
		this.m_fontColorBlack = _arg_1;
	}

	public function set TextRightAligned(_arg_1:Boolean):void {
		this.m_textRightAligned = _arg_1;
	}

	public function set TextAppendUpwards(_arg_1:Boolean):void {
		this.m_appendUpwards = _arg_1;
	}

	public function set ShowHelperRegistrationPoint(_arg_1:Boolean):void {
		this.m_showRegPoint = _arg_1;
	}

	public function set FlickerInFx(_arg_1:Boolean):void {
		this.m_flickerIn = _arg_1;
	}

	public function set FlickerOutFx(_arg_1:Boolean):void {
		this.m_flickerOut = _arg_1;
	}

	public function set AnimateInDuration(_arg_1:Number):void {
		this.m_animateInDuration = _arg_1;
	}

	public function set AnimateInStartRow(_arg_1:Number):void {
		this.m_animateInStartRow = _arg_1;
	}

	public function set AnimateInEndRow(_arg_1:Number):void {
		this.m_animateInEndRow = _arg_1;
	}

	public function set AnimateInStartCol(_arg_1:Number):void {
		this.m_animateInStartCol = _arg_1;
	}

	public function set AnimateInEndCol(_arg_1:Number):void {
		this.m_animateInEndCol = _arg_1;
	}

	public function set AnimateInEasingType(_arg_1:String):void {
		this.m_animateInEasingType = MenuUtils.getEaseType(_arg_1);
	}

	public function set AnimateOutDuration(_arg_1:Number):void {
		this.m_animateOutDuration = _arg_1;
	}

	public function set AnimateOutStartRow(_arg_1:Number):void {
		this.m_animateOutStartRow = _arg_1;
	}

	public function set AnimateOutEndRow(_arg_1:Number):void {
		this.m_animateOutEndRow = _arg_1;
	}

	public function set AnimateOutStartCol(_arg_1:Number):void {
		this.m_animateOutStartCol = _arg_1;
	}

	public function set AnimateOutEndCol(_arg_1:Number):void {
		this.m_animateOutEndCol = _arg_1;
	}

	public function set AnimateOutEasingType(_arg_1:String):void {
		this.m_animateOutEasingType = MenuUtils.getEaseType(_arg_1);
	}


}
}//package menu3.briefing

