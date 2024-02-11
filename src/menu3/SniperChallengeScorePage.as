// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.SniperChallengeScorePage

package menu3 {
import flash.display.Sprite;

import common.Log;
import common.Localization;
import common.menu.MenuConstants;

import flash.external.ExternalInterface;
import flash.text.TextField;

import common.menu.MenuUtils;

import flash.text.TextFormat;
import flash.text.TextFormatAlign;

import common.Animate;

public dynamic class SniperChallengeScorePage extends MenuElementBase {

	private const HEADLINE_HEIGHT:Number = 40;
	private const LINE_HEIGHT:Number = 30;
	private const LIST_TOP:Number = 250;
	private const LIST_LEFT:Number = 930;
	private const LIST_WIDTH:Number = 720;
	private const BG_BORDER:Number = 20;

	private var m_listView:Sprite = new Sprite();
	private var m_bgTop:Sprite = new Sprite();
	private var m_bgBottom:Sprite = new Sprite();
	private var m_bgList:Sprite = new Sprite();
	private var m_posY:Number = 0;
	private var m_elements:Array = new Array();

	public function SniperChallengeScorePage(_arg_1:Object) {
		super(_arg_1);
		addChild(this.m_bgTop);
		addChild(this.m_bgBottom);
		addChild(this.m_bgList);
		this.m_listView.x = this.LIST_LEFT;
		this.m_listView.y = this.LIST_TOP;
		addChild(this.m_listView);
	}

	override public function onSetData(_arg_1:Object):void {
		var _local_2:String;
		var _local_3:int;
		var _local_12:String;
		var _local_13:String;
		this.clear();
		Log.debugData(this, _arg_1);
		for (_local_2 in _arg_1) {
			trace(((("SniperChallengeScorePage | onSetData | " + _local_2) + ": ") + _arg_1[_local_2]));
			for (_local_12 in _arg_1[_local_2]) {
				trace(((((("SniperChallengeScorePage | onSetData | " + _local_2) + " | ") + _local_12) + ": ") + _arg_1[_local_2][_local_12]));
				for (_local_13 in _arg_1[_local_2][_local_12]) {
					trace(((((((("SniperChallengeScorePage | onSetData | " + _local_2) + " | ") + _local_12) + " | ") + _local_13) + ": ") + _arg_1[_local_2][_local_12][_local_13]));
				}
				;
			}
			;
		}
		;
		if ((((_arg_1.loading) || (_arg_1.SniperChallengeScore == undefined)) || (_arg_1.SniperChallengeScore.Score == undefined))) {
			return;
		}
		;
		var _local_4:PaymentLine = PaymentLine.createLine("SCORE");
		_local_4.m_isHeadline = true;
		this.addPaymentLine(_local_4);
		var _local_5:Object = _arg_1.SniperChallengeScore.Score;
		this.addPaymentLine(PaymentLine.createLineWithIntAnimation(Localization.get("UI_SNIPERSCORING_SUMMARY_BASESCORE"), _local_5.BaseScore));
		this.addPaymentLine(PaymentLine.createLineWithIntAnimation((((Localization.get("UI_SNIPERSCORING_SUMMARY_BULLETS_MISSED_PENALTY") + " (") + int(_local_5.BulletsMissed)) + ")"), _local_5.BulletsMissedPenalty));
		this.addPaymentLine(PaymentLine.createLineWithIntAnimation((((Localization.get("UI_SNIPERSCORING_SUMMARY_TIME_BONUS") + " (") + this.getTimeString(_local_5.TimeTaken)) + ")"), _local_5.TimeBonus));
		this.addPaymentLine(PaymentLine.createLineWithIntAnimation(Localization.get("UI_SNIPERSCORING_SUMMARY_SILENT_ASSASIN_BONUS"), _local_5.SilentAssassinBonus));
		var _local_6:int = (((_local_5.BaseScore + _local_5.BulletsMissedPenalty) + _local_5.TimeBonus) + _local_5.SilentAssassinBonus);
		_local_6 = Math.max(_local_6, 0);
		_local_4 = PaymentLine.createLineWithIntAnimation(Localization.get("UI_SNIPERSCORING_SUMMARY_SUBTOTAL"), _local_6);
		_local_4.m_isHeadline = true;
		this.addPaymentLine(_local_4);
		_local_4 = PaymentLine.createLine("MULTIPLIER");
		_local_4.m_isHeadline = true;
		this.addPaymentLine(_local_4);
		this.addPaymentLine(PaymentLine.createLine(Localization.get("UI_SNIPERSCORING_SUMMARY_CHALLENGE_MULTIPLIER"), this.getNumberString(_local_5.TotalChallengeMultiplier)));
		this.addPaymentLine(PaymentLine.createLine(Localization.get("UI_SNIPERSCORING_SUMMARY_SILENT_ASSASIN_MULTIPLIER"), this.getNumberString(_local_5.SilentAssassinMultiplier)));
		_local_4 = PaymentLine.createLineWithIntAnimation(Localization.get("UI_SNIPERSCORING_SUMMARY_TOTAL"), _local_5.FinalScore);
		_local_4.m_isHeadline = true;
		this.addPaymentLine(_local_4);
		var _local_7:Number = (0 - (MenuConstants.tileGap + MenuConstants.TabsLineUpperYPos));
		var _local_8:Number = (this.LIST_LEFT - this.BG_BORDER);
		var _local_9:Number = (this.LIST_WIDTH + (this.BG_BORDER * 2));
		var _local_10:Number = (this.LIST_TOP - this.BG_BORDER);
		var _local_11:Number = ((this.LIST_TOP + this.m_posY) + this.BG_BORDER);
		this.m_bgTop.graphics.clear();
		this.m_bgTop.graphics.beginFill(0xFFFFFF, 0.8);
		this.m_bgTop.graphics.drawRect(_local_8, _local_7, _local_9, (_local_10 - _local_7));
		this.m_bgTop.graphics.endFill();
		this.m_bgBottom.graphics.clear();
		this.m_bgBottom.graphics.beginFill(0xFFFFFF, 0.8);
		this.m_bgBottom.graphics.drawRect(_local_8, _local_11, _local_9, (MenuConstants.BaseHeight - _local_11));
		this.m_bgBottom.graphics.endFill();
		this.m_bgList.graphics.clear();
		this.m_bgList.graphics.beginFill(0, 0.45);
		this.m_bgList.graphics.drawRect(_local_8, _local_10, _local_9, (_local_11 - _local_10));
		this.m_bgList.graphics.endFill();
		this.drawBackground();
		this.startAnimations();
	}

	override public function onUnregister():void {
		this.clear();
		super.onUnregister();
	}

	public function playSound(_arg_1:String):void {
		ExternalInterface.call("PlaySound", _arg_1);
	}

	private function addPaymentLine(_arg_1:PaymentLine):void {
		if (_arg_1.m_isHeadline) {
			if (this.m_posY > 0) {
				this.m_posY = (this.m_posY + this.LINE_HEIGHT);
			}
			;
		}
		;
		var _local_2:TextField = this.createTextField();
		MenuUtils.setupText(_local_2, _arg_1.m_title);
		var _local_3:TextField = this.createTextField();
		MenuUtils.setupText(_local_3, _arg_1.m_value);
		var _local_4:TextFormat = _local_3.getTextFormat();
		_local_4.align = TextFormatAlign.RIGHT;
		_local_3.setTextFormat(_local_4);
		_local_3.defaultTextFormat = _local_4;
		_arg_1.m_valueTextField = _local_3;
		_arg_1.m_container.addChild(_local_2);
		_arg_1.m_container.addChild(_local_3);
		_arg_1.m_container.y = this.m_posY;
		_arg_1.m_container.alpha = 0;
		if (_arg_1.m_isHeadline) {
			this.m_posY = (this.m_posY + this.HEADLINE_HEIGHT);
		} else {
			this.m_posY = (this.m_posY + this.LINE_HEIGHT);
		}
		;
		this.m_listView.addChild(_arg_1.m_container);
		this.m_elements.push(_arg_1);
	}

	private function createTextField():TextField {
		var _local_1:TextField = new TextField();
		_local_1.width = this.LIST_WIDTH;
		return (_local_1);
	}

	private function clear():void {
		var _local_1:PaymentLine;
		this.completeAnimations();
		for each (_local_1 in this.m_elements) {
			this.m_listView.removeChild(_local_1.m_container);
		}
		;
		this.m_elements.length = 0;
		this.m_posY = 0;
		this.clearBackground();
	}

	private function startAnimations():void {
		var _local_2:PaymentLine;
		var _local_3:Number;
		var _local_4:int;
		var _local_1:int;
		while (_local_1 < this.m_elements.length) {
			_local_2 = this.m_elements[_local_1];
			_local_3 = (0.5 * _local_1);
			Animate.fromTo(_local_2.m_container, 0.3, _local_3, {"x": -50}, {"x": 0}, Animate.ExpoOut);
			Animate.addFromTo(_local_2.m_container, 0.2, _local_3, {"alpha": 0}, {"alpha": 1}, Animate.Linear);
			if (_local_2.m_useIntAnimation) {
				_local_4 = _local_2.m_intValue;
				Animate.addFromTo(_local_2.m_valueTextField, 0.45, _local_3, {"intAnimation": 0}, {"intAnimation": _local_4}, Animate.SineOut);
			}
			;
			Animate.delay(_local_2.m_container, _local_3, this.playSound, "ScoreRating");
			_local_1++;
		}
		;
	}

	private function completeAnimations():void {
		var _local_1:int;
		while (_local_1 < this.m_elements.length) {
			Animate.kill(this.m_elements[_local_1]);
			_local_1++;
		}
		;
	}

	private function drawBackground():void {
		this.clearBackground();
		var _local_1:Number = (0 - (MenuConstants.tileGap + MenuConstants.TabsLineUpperYPos));
		var _local_2:Number = (this.LIST_LEFT - this.BG_BORDER);
		var _local_3:Number = (this.LIST_WIDTH + (this.BG_BORDER * 2));
		var _local_4:Number = (this.LIST_TOP - this.BG_BORDER);
		var _local_5:Number = ((this.LIST_TOP + this.m_posY) + this.BG_BORDER);
		this.m_bgTop.graphics.beginFill(0xFFFFFF, 0.8);
		this.m_bgTop.graphics.drawRect(_local_2, _local_1, _local_3, (_local_4 - _local_1));
		this.m_bgTop.graphics.endFill();
		this.m_bgBottom.graphics.beginFill(0xFFFFFF, 0.8);
		this.m_bgBottom.graphics.drawRect(_local_2, _local_5, _local_3, (MenuConstants.BaseHeight - _local_5));
		this.m_bgBottom.graphics.endFill();
		this.m_bgList.graphics.beginFill(0, 0.45);
		this.m_bgList.graphics.drawRect(_local_2, _local_4, _local_3, (_local_5 - _local_4));
		this.m_bgList.graphics.endFill();
	}

	private function clearBackground():void {
		this.m_bgTop.graphics.clear();
		this.m_bgBottom.graphics.clear();
		this.m_bgList.graphics.clear();
	}

	private function getTimeString(_arg_1:Number):String {
		var _local_2:Number = Math.abs(_arg_1);
		var _local_3:int = int(Math.floor((_local_2 / 60)));
		var _local_4:Number = (_local_2 - (_local_3 * 60));
		var _local_5:* = "";
		if (_local_3 < 10) {
			_local_5 = (_local_5 + "0");
		}
		;
		_local_5 = (_local_5 + _local_3.toString());
		var _local_6:* = "";
		if (_local_4 < 10) {
			_local_6 = (_local_6 + "0");
		}
		;
		_local_6 = (_local_6 + _local_4.toFixed(3));
		var _local_7:String = ((_local_5 + ":") + _local_6);
		if (_arg_1 < 0) {
			((_local_7 + "-") + _local_7);
		}
		;
		return (_local_7);
	}

	private function getNumberString(_arg_1:Number):String {
		return (_arg_1.toFixed(2));
	}


}
}//package menu3

import flash.display.Sprite;
import flash.text.TextField;

class PaymentLine {

	public var m_isHeadline:Boolean = false;
	public var m_title:String = "";
	public var m_value:String = "";
	public var m_useIntAnimation:Boolean = false;
	public var m_intValue:int = 0;
	public var m_container:Sprite = new Sprite();
	public var m_valueTextField:TextField = null;


	public static function createLine(_arg_1:String, _arg_2:String = ""):PaymentLine {
		var _local_3:PaymentLine = new (PaymentLine)();
		_local_3.m_title = _arg_1;
		_local_3.m_value = _arg_2;
		return (_local_3);
	}

	public static function createLineWithIntAnimation(_arg_1:String, _arg_2:int):PaymentLine {
		var _local_3:PaymentLine = new (PaymentLine)();
		_local_3.m_title = _arg_1;
		_local_3.m_value = "0";
		_local_3.m_useIntAnimation = true;
		_local_3.m_intValue = _arg_2;
		return (_local_3);
	}


}


