package menu3
{
	import common.Animate;
	import common.Localization;
	import common.Log;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.display.Sprite;
	import flash.external.ExternalInterface;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public dynamic class SniperChallengeScorePage extends MenuElementBase
	{
		
		private const HEADLINE_HEIGHT:Number = 40;
		
		private const LINE_HEIGHT:Number = 30;
		
		private const LIST_TOP:Number = 250;
		
		private const LIST_LEFT:Number = 930;
		
		private const LIST_WIDTH:Number = 720;
		
		private const BG_BORDER:Number = 20;
		
		private var m_listView:Sprite;
		
		private var m_bgTop:Sprite;
		
		private var m_bgBottom:Sprite;
		
		private var m_bgList:Sprite;
		
		private var m_posY:Number = 0;
		
		private var m_elements:Array;
		
		public function SniperChallengeScorePage(param1:Object)
		{
			this.m_listView = new Sprite();
			this.m_bgTop = new Sprite();
			this.m_bgBottom = new Sprite();
			this.m_bgList = new Sprite();
			this.m_elements = new Array();
			super(param1);
			addChild(this.m_bgTop);
			addChild(this.m_bgBottom);
			addChild(this.m_bgList);
			this.m_listView.x = this.LIST_LEFT;
			this.m_listView.y = this.LIST_TOP;
			addChild(this.m_listView);
		}
		
		override public function onSetData(param1:Object):void
		{
			var _loc2_:String = null;
			var _loc3_:int = 0;
			var _loc12_:String = null;
			var _loc13_:String = null;
			this.clear();
			Log.debugData(this, param1);
			for (_loc2_ in param1)
			{
				trace("SniperChallengeScorePage | onSetData | " + _loc2_ + ": " + param1[_loc2_]);
				for (_loc12_ in param1[_loc2_])
				{
					trace("SniperChallengeScorePage | onSetData | " + _loc2_ + " | " + _loc12_ + ": " + param1[_loc2_][_loc12_]);
					for (_loc13_ in param1[_loc2_][_loc12_])
					{
						trace("SniperChallengeScorePage | onSetData | " + _loc2_ + " | " + _loc12_ + " | " + _loc13_ + ": " + param1[_loc2_][_loc12_][_loc13_]);
					}
				}
			}
			if (param1.loading || param1.SniperChallengeScore == undefined || param1.SniperChallengeScore.Score == undefined)
			{
				return;
			}
			var _loc4_:PaymentLine;
			(_loc4_ = PaymentLine.createLine("SCORE")).m_isHeadline = true;
			this.addPaymentLine(_loc4_);
			var _loc5_:Object = param1.SniperChallengeScore.Score;
			this.addPaymentLine(PaymentLine.createLineWithIntAnimation(Localization.get("UI_SNIPERSCORING_SUMMARY_BASESCORE"), _loc5_.BaseScore));
			this.addPaymentLine(PaymentLine.createLineWithIntAnimation(Localization.get("UI_SNIPERSCORING_SUMMARY_BULLETS_MISSED_PENALTY") + " (" + int(_loc5_.BulletsMissed) + ")", _loc5_.BulletsMissedPenalty));
			this.addPaymentLine(PaymentLine.createLineWithIntAnimation(Localization.get("UI_SNIPERSCORING_SUMMARY_TIME_BONUS") + " (" + this.getTimeString(_loc5_.TimeTaken) + ")", _loc5_.TimeBonus));
			this.addPaymentLine(PaymentLine.createLineWithIntAnimation(Localization.get("UI_SNIPERSCORING_SUMMARY_SILENT_ASSASIN_BONUS"), _loc5_.SilentAssassinBonus));
			var _loc6_:int = _loc5_.BaseScore + _loc5_.BulletsMissedPenalty + _loc5_.TimeBonus + _loc5_.SilentAssassinBonus;
			_loc6_ = Math.max(_loc6_, 0);
			(_loc4_ = PaymentLine.createLineWithIntAnimation(Localization.get("UI_SNIPERSCORING_SUMMARY_SUBTOTAL"), _loc6_)).m_isHeadline = true;
			this.addPaymentLine(_loc4_);
			(_loc4_ = PaymentLine.createLine("MULTIPLIER")).m_isHeadline = true;
			this.addPaymentLine(_loc4_);
			this.addPaymentLine(PaymentLine.createLine(Localization.get("UI_SNIPERSCORING_SUMMARY_CHALLENGE_MULTIPLIER"), this.getNumberString(_loc5_.TotalChallengeMultiplier)));
			this.addPaymentLine(PaymentLine.createLine(Localization.get("UI_SNIPERSCORING_SUMMARY_SILENT_ASSASIN_MULTIPLIER"), this.getNumberString(_loc5_.SilentAssassinMultiplier)));
			(_loc4_ = PaymentLine.createLineWithIntAnimation(Localization.get("UI_SNIPERSCORING_SUMMARY_TOTAL"), _loc5_.FinalScore)).m_isHeadline = true;
			this.addPaymentLine(_loc4_);
			var _loc7_:Number = 0 - (MenuConstants.tileGap + MenuConstants.TabsLineUpperYPos);
			var _loc8_:Number = this.LIST_LEFT - this.BG_BORDER;
			var _loc9_:Number = this.LIST_WIDTH + this.BG_BORDER * 2;
			var _loc10_:Number = this.LIST_TOP - this.BG_BORDER;
			var _loc11_:Number = this.LIST_TOP + this.m_posY + this.BG_BORDER;
			this.m_bgTop.graphics.clear();
			this.m_bgTop.graphics.beginFill(16777215, 0.8);
			this.m_bgTop.graphics.drawRect(_loc8_, _loc7_, _loc9_, _loc10_ - _loc7_);
			this.m_bgTop.graphics.endFill();
			this.m_bgBottom.graphics.clear();
			this.m_bgBottom.graphics.beginFill(16777215, 0.8);
			this.m_bgBottom.graphics.drawRect(_loc8_, _loc11_, _loc9_, MenuConstants.BaseHeight - _loc11_);
			this.m_bgBottom.graphics.endFill();
			this.m_bgList.graphics.clear();
			this.m_bgList.graphics.beginFill(0, 0.45);
			this.m_bgList.graphics.drawRect(_loc8_, _loc10_, _loc9_, _loc11_ - _loc10_);
			this.m_bgList.graphics.endFill();
			this.drawBackground();
			this.startAnimations();
		}
		
		override public function onUnregister():void
		{
			this.clear();
			super.onUnregister();
		}
		
		public function playSound(param1:String):void
		{
			ExternalInterface.call("PlaySound", param1);
		}
		
		private function addPaymentLine(param1:PaymentLine):void
		{
			if (param1.m_isHeadline)
			{
				if (this.m_posY > 0)
				{
					this.m_posY += this.LINE_HEIGHT;
				}
			}
			var _loc2_:TextField = this.createTextField();
			MenuUtils.setupText(_loc2_, param1.m_title);
			var _loc3_:TextField = this.createTextField();
			MenuUtils.setupText(_loc3_, param1.m_value);
			var _loc4_:TextFormat;
			(_loc4_ = _loc3_.getTextFormat()).align = TextFormatAlign.RIGHT;
			_loc3_.setTextFormat(_loc4_);
			_loc3_.defaultTextFormat = _loc4_;
			param1.m_valueTextField = _loc3_;
			param1.m_container.addChild(_loc2_);
			param1.m_container.addChild(_loc3_);
			param1.m_container.y = this.m_posY;
			param1.m_container.alpha = 0;
			if (param1.m_isHeadline)
			{
				this.m_posY += this.HEADLINE_HEIGHT;
			}
			else
			{
				this.m_posY += this.LINE_HEIGHT;
			}
			this.m_listView.addChild(param1.m_container);
			this.m_elements.push(param1);
		}
		
		private function createTextField():TextField
		{
			var _loc1_:TextField = new TextField();
			_loc1_.width = this.LIST_WIDTH;
			return _loc1_;
		}
		
		private function clear():void
		{
			var _loc1_:PaymentLine = null;
			this.completeAnimations();
			for each (_loc1_ in this.m_elements)
			{
				this.m_listView.removeChild(_loc1_.m_container);
			}
			this.m_elements.length = 0;
			this.m_posY = 0;
			this.clearBackground();
		}
		
		private function startAnimations():void
		{
			var _loc2_:PaymentLine = null;
			var _loc3_:Number = NaN;
			var _loc4_:int = 0;
			var _loc1_:int = 0;
			while (_loc1_ < this.m_elements.length)
			{
				_loc2_ = this.m_elements[_loc1_];
				_loc3_ = 0.5 * _loc1_;
				Animate.fromTo(_loc2_.m_container, 0.3, _loc3_, {"x": -50}, {"x": 0}, Animate.ExpoOut);
				Animate.addFromTo(_loc2_.m_container, 0.2, _loc3_, {"alpha": 0}, {"alpha": 1}, Animate.Linear);
				if (_loc2_.m_useIntAnimation)
				{
					_loc4_ = _loc2_.m_intValue;
					Animate.addFromTo(_loc2_.m_valueTextField, 0.45, _loc3_, {"intAnimation": 0}, {"intAnimation": _loc4_}, Animate.SineOut);
				}
				Animate.delay(_loc2_.m_container, _loc3_, this.playSound, "ScoreRating");
				_loc1_++;
			}
		}
		
		private function completeAnimations():void
		{
			var _loc1_:int = 0;
			while (_loc1_ < this.m_elements.length)
			{
				Animate.kill(this.m_elements[_loc1_]);
				_loc1_++;
			}
		}
		
		private function drawBackground():void
		{
			this.clearBackground();
			var _loc1_:Number = 0 - (MenuConstants.tileGap + MenuConstants.TabsLineUpperYPos);
			var _loc2_:Number = this.LIST_LEFT - this.BG_BORDER;
			var _loc3_:Number = this.LIST_WIDTH + this.BG_BORDER * 2;
			var _loc4_:Number = this.LIST_TOP - this.BG_BORDER;
			var _loc5_:Number = this.LIST_TOP + this.m_posY + this.BG_BORDER;
			this.m_bgTop.graphics.beginFill(16777215, 0.8);
			this.m_bgTop.graphics.drawRect(_loc2_, _loc1_, _loc3_, _loc4_ - _loc1_);
			this.m_bgTop.graphics.endFill();
			this.m_bgBottom.graphics.beginFill(16777215, 0.8);
			this.m_bgBottom.graphics.drawRect(_loc2_, _loc5_, _loc3_, MenuConstants.BaseHeight - _loc5_);
			this.m_bgBottom.graphics.endFill();
			this.m_bgList.graphics.beginFill(0, 0.45);
			this.m_bgList.graphics.drawRect(_loc2_, _loc4_, _loc3_, _loc5_ - _loc4_);
			this.m_bgList.graphics.endFill();
		}
		
		private function clearBackground():void
		{
			this.m_bgTop.graphics.clear();
			this.m_bgBottom.graphics.clear();
			this.m_bgList.graphics.clear();
		}
		
		private function getTimeString(param1:Number):String
		{
			var _loc2_:Number = Math.abs(param1);
			var _loc3_:int = Math.floor(_loc2_ / 60);
			var _loc4_:Number = _loc2_ - _loc3_ * 60;
			var _loc5_:* = "";
			if (_loc3_ < 10)
			{
				_loc5_ += "0";
			}
			_loc5_ += _loc3_.toString();
			var _loc6_:* = "";
			if (_loc4_ < 10)
			{
				_loc6_ += "0";
			}
			_loc6_ += _loc4_.toFixed(3);
			var _loc7_:String = _loc5_ + ":" + _loc6_;
			if (param1 < 0)
			{
				_loc7_ + "-" + _loc7_;
			}
			return _loc7_;
		}
		
		private function getNumberString(param1:Number):String
		{
			return param1.toFixed(2);
		}
	}
}

import flash.display.Sprite;
import flash.text.TextField;

class PaymentLine
{
	
	public var m_isHeadline:Boolean = false;
	
	public var m_title:String = "";
	
	public var m_value:String = "";
	
	public var m_useIntAnimation:Boolean = false;
	
	public var m_intValue:int = 0;
	
	public var m_container:Sprite;
	
	public var m_valueTextField:TextField = null;
	
	public function PaymentLine()
	{
		this.m_container = new Sprite();
		super();
	}
	
	public static function createLine(param1:String, param2:String = ""):PaymentLine
	{
		var _loc3_:PaymentLine = new PaymentLine();
		_loc3_.m_title = param1;
		_loc3_.m_value = param2;
		return _loc3_;
	}
	
	public static function createLineWithIntAnimation(param1:String, param2:int):PaymentLine
	{
		var _loc3_:PaymentLine = new PaymentLine();
		_loc3_.m_title = param1;
		_loc3_.m_value = "0";
		_loc3_.m_useIntAnimation = true;
		_loc3_.m_intValue = param2;
		return _loc3_;
	}
}
