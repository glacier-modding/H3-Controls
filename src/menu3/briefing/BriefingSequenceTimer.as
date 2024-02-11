// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.briefing.BriefingSequenceTimer

package menu3.briefing {
import flash.utils.Timer;

import common.DateTimeUtils;

import flash.events.TimerEvent;

import common.menu.MenuUtils;
import common.menu.MenuConstants;

import flash.text.TextField;

public class BriefingSequenceTimer {

	private var countTimer:Timer;
	private var countTimerFunctions:Array;
	private var m_millisecondsLeft:Number;
	private var m_parentObj:Object;
	private var m_fontStyle:String;
	private var m_fontSize:int;
	private var m_fontColorBlack:Boolean;


	public function validateTimeStamp(_arg_1:String):Boolean {
		var _local_2:Number = DateTimeUtils.getUTCClockNow().getTime();
		var _local_3:Number = DateTimeUtils.parseUTCTimeStamp(_arg_1).getTime();
		return ((_local_3 - _local_2) > 0);
	}

	public function startCountDown(_arg_1:TextField, _arg_2:String, _arg_3:Object, _arg_4:String, _arg_5:int, _arg_6:Boolean):void {
		this.m_fontStyle = _arg_4;
		this.m_fontSize = _arg_5;
		this.m_fontColorBlack = _arg_6;
		this.m_parentObj = _arg_3;
		this.m_millisecondsLeft = 0;
		if (this.countTimer) {
			this.countTimer.reset();
			this.countTimer.removeEventListener(TimerEvent.TIMER, this.countTimerFunctions[0]);
			this.countTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.countTimerFunctions[1]);
		}
		;
		this.m_millisecondsLeft = this.getRemainingMilliseconds(_arg_2);
		MenuUtils.setupText(_arg_1, this.formatDurationHHMMSS(this.m_millisecondsLeft), this.m_fontSize, this.m_fontStyle, ((this.m_fontColorBlack) ? MenuConstants.FontColorBlack : MenuConstants.FontColorGreyUltraLight));
		this.countTimer = new Timer(1000, Math.ceil((this.m_millisecondsLeft / 1000)));
		this.countTimer.start();
		var _local_7:Function = this.timerHandler(_arg_1);
		var _local_8:Function = this.completeHandler(_arg_1);
		this.countTimerFunctions = new Array(_local_7, _local_8);
		this.countTimer.addEventListener(TimerEvent.TIMER, _local_7);
		this.countTimer.addEventListener(TimerEvent.TIMER_COMPLETE, _local_8);
	}

	private function timerHandler(textfield:TextField):Function {
		return (function (_arg_1:TimerEvent):void {
			m_millisecondsLeft = (m_millisecondsLeft - 1000);
			MenuUtils.setupText(textfield, formatDurationHHMMSS(m_millisecondsLeft), m_fontSize, m_fontStyle, ((m_fontColorBlack) ? MenuConstants.FontColorBlack : MenuConstants.FontColorGreyUltraLight));
		});
	}

	private function completeHandler(textfield:TextField):Function {
		return (function (_arg_1:TimerEvent):void {
			MenuUtils.setupText(textfield, "00:00:00", m_fontSize, m_fontStyle, ((m_fontColorBlack) ? MenuConstants.FontColorBlack : MenuConstants.FontColorGreyUltraLight));
			countTimer.reset();
			countTimer.removeEventListener(TimerEvent.TIMER, countTimerFunctions[0]);
			countTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, countTimerFunctions[1]);
			countTimerFunctions = [];
			m_parentObj.timerComplete();
		});
	}

	public function stopCountDown():void {
		if (this.countTimer) {
			this.countTimer.reset();
			this.countTimer.removeEventListener(TimerEvent.TIMER, this.countTimerFunctions[0]);
			this.countTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.countTimerFunctions[1]);
			this.countTimerFunctions = [];
		}
		;
	}

	private function getRemainingMilliseconds(_arg_1:String):Number {
		var _local_2:Number = DateTimeUtils.getUTCClockNow().getTime();
		var _local_3:Number = DateTimeUtils.parseUTCTimeStamp(_arg_1).getTime();
		if ((_local_3 - _local_2) <= 0) {
			return (0);
		}
		;
		return (_local_3 - _local_2);
	}

	private function formatDurationHHMMSS(_arg_1:Number):String {
		return (DateTimeUtils.formatDurationHHMMSS(_arg_1));
	}


}
}//package menu3.briefing

