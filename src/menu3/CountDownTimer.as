// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.CountDownTimer

package menu3 {
import flash.utils.Timer;

import common.DateTimeUtils;

import flash.events.TimerEvent;

import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.Log;

import flash.text.TextField;

public class CountDownTimer {

	private var countTimer:Timer;
	private var countTimerFunctions:Array;
	private var m_millisecondsLeft:Number;
	private var m_parentObj:Object;


	public function validateTimeStamp(_arg_1:String):Boolean {
		var _local_2:Number = DateTimeUtils.getUTCClockNow().getTime();
		var _local_3:Number = DateTimeUtils.parseUTCTimeStamp(_arg_1).getTime();
		return ((_local_3 - _local_2) > 0);
	}

	public function startCountDown(_arg_1:TextField, _arg_2:String, _arg_3:Object, _arg_4:int = 38, _arg_5:String = "#EBEBEB"):void {
		this.m_parentObj = _arg_3;
		this.m_millisecondsLeft = 0;
		if (this.countTimer) {
			this.countTimer.reset();
			this.countTimer.removeEventListener(TimerEvent.TIMER, this.countTimerFunctions[0]);
			this.countTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.countTimerFunctions[1]);
		}

		this.m_millisecondsLeft = this.getRemainingMilliseconds(_arg_2);
		MenuUtils.setupTextUpper(_arg_1, this.formatDurationHHMMSS(this.m_millisecondsLeft), _arg_4, MenuConstants.FONT_TYPE_MEDIUM, _arg_5);
		var _local_6:Number = Math.ceil((this.m_millisecondsLeft / 1000));
		if (_local_6 >= int.MAX_VALUE) {
			Log.warning(Log.ChannelDebug, this, "startCountDown: Timer not started, because the time period is too big. Only int.MAX_VALUE seconds are supported (or 69.8 years)");
			return;
		}

		this.countTimer = new Timer(1000, _local_6);
		this.countTimer.start();
		var _local_7:Function = this.timerHandler(_arg_1, _arg_4, _arg_5);
		var _local_8:Function = this.completeHandler(_arg_1, _arg_4, _arg_5);
		this.countTimerFunctions = [_local_7, _local_8];
		this.countTimer.addEventListener(TimerEvent.TIMER, _local_7);
		this.countTimer.addEventListener(TimerEvent.TIMER_COMPLETE, _local_8);
	}

	private function timerHandler(textfield:TextField, fontSize:int, fontColor:String):Function {
		return (function (_arg_1:TimerEvent):void {
			m_millisecondsLeft = (m_millisecondsLeft - 1000);
			MenuUtils.setupTextUpper(textfield, formatDurationHHMMSS(m_millisecondsLeft), fontSize, MenuConstants.FONT_TYPE_MEDIUM, fontColor);
		});
	}

	private function completeHandler(textfield:TextField, fontSize:int, fontColor:String):Function {
		return (function (_arg_1:TimerEvent):void {
			MenuUtils.setupTextUpper(textfield, "00:00:00", fontSize, MenuConstants.FONT_TYPE_MEDIUM, fontColor);
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

	}

	private function getRemainingMilliseconds(_arg_1:String):Number {
		var _local_2:Number = DateTimeUtils.getUTCClockNow().getTime();
		var _local_3:Number = DateTimeUtils.parseUTCTimeStamp(_arg_1).getTime();
		if ((_local_3 - _local_2) <= 0) {
			return (0);
		}

		return (_local_3 - _local_2);
	}

	private function formatDurationHHMMSS(_arg_1:Number):String {
		return (DateTimeUtils.formatDurationHHMMSS(_arg_1));
	}


}
}//package menu3

