// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.MissionPaymentPage

package menu3 {
import flash.display.Sprite;

import common.menu.MenuConstants;

import flash.external.ExternalInterface;
import flash.text.TextField;

import common.menu.MenuUtils;

import flash.text.TextFormat;
import flash.text.TextFormatAlign;

import common.Animate;

public dynamic class MissionPaymentPage extends MenuElementBase {

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
	private var m_posX:Number = 0;
	private var m_elements:Array = [];

	public function MissionPaymentPage(_arg_1:Object) {
		super(_arg_1);
		addChild(this.m_bgTop);
		addChild(this.m_bgBottom);
		addChild(this.m_bgList);
		this.m_listView.x = this.LIST_LEFT;
		this.m_listView.y = this.LIST_TOP;
		addChild(this.m_listView);
	}

	override public function onSetData(_arg_1:Object):void {
		var _local_2:int;
		var _local_13:Object;
		var _local_14:Object;
		var _local_15:Object;
		var _local_16:Object;
		var _local_17:String;
		this.clear();
		if ((((_arg_1.loading) || (_arg_1.ContractPayment == undefined)) || (_arg_1.ContractPayment.Currency == undefined))) {
			return;
		}

		this.addHeadline("AVAILABLE PAYOUT");
		var _local_3:Object = _arg_1.ContractPayment.Currency;
		var _local_4:Object = _local_3.Payment;
		if (_local_4 != null) {
			for each (_local_13 in _local_4) {
				this.addLine(_local_13.Name, _local_13.Amount);
			}

		}

		var _local_5:Object = _local_3.Bonuses;
		if (_local_5 != null) {
			for each (_local_14 in _local_5) {
				this.addLine(_local_14.Name, _local_14.Amount);
			}

		}

		this.addHeadline("DEDUCTIONS FOR EVIDENCE");
		var _local_6:Object = _local_3.Expenses;
		if (_local_6 != null) {
			for each (_local_15 in _local_6) {
				this.addLine(_local_15.Name, (_local_15.Amount * -1));
			}

		}

		var _local_7:Object = _local_3.TotalPayment;
		this.addHeadline("FINAL PAYOUT");
		if (_local_7 != null) {
			for each (_local_16 in _local_7) {
				for (_local_17 in _local_16) {
					this.addLine(_local_17, _local_16[_local_17]);
				}

			}

		}

		var _local_8:Number = (0 - (MenuConstants.tileGap + MenuConstants.TabsLineUpperYPos));
		var _local_9:Number = (this.LIST_LEFT - this.BG_BORDER);
		var _local_10:Number = (this.LIST_WIDTH + (this.BG_BORDER * 2));
		var _local_11:Number = (this.LIST_TOP - this.BG_BORDER);
		var _local_12:Number = ((this.LIST_TOP + this.m_posX) + this.BG_BORDER);
		this.m_bgTop.graphics.clear();
		this.m_bgTop.graphics.beginFill(0xFFFFFF, 0.8);
		this.m_bgTop.graphics.drawRect(_local_9, _local_8, _local_10, (_local_11 - _local_8));
		this.m_bgTop.graphics.endFill();
		this.m_bgBottom.graphics.clear();
		this.m_bgBottom.graphics.beginFill(0xFFFFFF, 0.8);
		this.m_bgBottom.graphics.drawRect(_local_9, _local_12, _local_10, (MenuConstants.BaseHeight - _local_12));
		this.m_bgBottom.graphics.endFill();
		this.m_bgList.graphics.clear();
		this.m_bgList.graphics.beginFill(0, 0.45);
		this.m_bgList.graphics.drawRect(_local_9, _local_11, _local_10, (_local_12 - _local_11));
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

	private function addHeadline(_arg_1:String):void {
		if (this.m_posX > 0) {
			this.m_posX = (this.m_posX + this.LINE_HEIGHT);
		}

		var _local_2:TextField = this.createTextField();
		MenuUtils.setupText(_local_2, _arg_1);
		_local_2.y = this.m_posX;
		this.m_posX = (this.m_posX + this.HEADLINE_HEIGHT);
		this.m_listView.addChild(_local_2);
	}

	private function addLine(_arg_1:String, _arg_2:int):void {
		var _local_3:TextField = this.createTextField();
		MenuUtils.setupText(_local_3, _arg_1);
		_local_3.y = this.m_posX;
		var _local_4:TextField = this.createTextField();
		MenuUtils.setupText(_local_4, _arg_2.toString());
		var _local_5:TextFormat = _local_4.getTextFormat();
		_local_5.align = TextFormatAlign.RIGHT;
		_local_4.setTextFormat(_local_5);
		_local_4.y = this.m_posX;
		this.m_posX = (this.m_posX + this.LINE_HEIGHT);
		this.m_listView.addChild(_local_3);
		this.m_listView.addChild(_local_4);
	}

	private function createTextField():TextField {
		var _local_1:TextField = new TextField();
		_local_1.width = this.LIST_WIDTH;
		_local_1.alpha = 0;
		this.m_elements.push(_local_1);
		return (_local_1);
	}

	private function clear():void {
		var _local_1:TextField;
		this.completeAnimations();
		for each (_local_1 in this.m_elements) {
			this.m_listView.removeChild(_local_1);
		}

		this.m_elements.length = 0;
		this.m_posX = 0;
		this.clearBackground();
	}

	private function startAnimations():void {
		var _local_2:Number;
		var _local_1:int;
		while (_local_1 < this.m_elements.length) {
			_local_2 = (0.3 * _local_1);
			Animate.fromTo(this.m_elements[_local_1], 0.25, _local_2, {"x": -50}, {"x": 0}, Animate.ExpoOut);
			Animate.addFromTo(this.m_elements[_local_1], 0.25, _local_2, {"alpha": 0}, {"alpha": 1}, Animate.Linear);
			Animate.delay(this.m_elements[_local_1], _local_2, this.playSound, "ScoreRating");
			_local_1++;
		}

	}

	private function completeAnimations():void {
		var _local_1:int;
		while (_local_1 < this.m_elements.length) {
			Animate.kill(this.m_elements[_local_1]);
			_local_1++;
		}

	}

	private function drawBackground():void {
		this.clearBackground();
		var _local_1:Number = (0 - (MenuConstants.tileGap + MenuConstants.TabsLineUpperYPos));
		var _local_2:Number = (this.LIST_LEFT - this.BG_BORDER);
		var _local_3:Number = (this.LIST_WIDTH + (this.BG_BORDER * 2));
		var _local_4:Number = (this.LIST_TOP - this.BG_BORDER);
		var _local_5:Number = ((this.LIST_TOP + this.m_posX) + this.BG_BORDER);
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


}
}//package menu3

