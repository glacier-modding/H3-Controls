package menu3
{
	import common.Animate;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.display.Sprite;
	import flash.external.ExternalInterface;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public dynamic class MissionPaymentPage extends MenuElementBase
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
		
		private var m_posX:Number = 0;
		
		private var m_elements:Array;
		
		public function MissionPaymentPage(param1:Object)
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
			var _loc2_:int = 0;
			var _loc13_:Object = null;
			var _loc14_:Object = null;
			var _loc15_:Object = null;
			var _loc16_:Object = null;
			var _loc17_:String = null;
			this.clear();
			if (param1.loading || param1.ContractPayment == undefined || param1.ContractPayment.Currency == undefined)
			{
				return;
			}
			this.addHeadline("AVAILABLE PAYOUT");
			var _loc3_:Object = param1.ContractPayment.Currency;
			var _loc4_:Object;
			if ((_loc4_ = _loc3_.Payment) != null)
			{
				for each (_loc13_ in _loc4_)
				{
					this.addLine(_loc13_.Name, _loc13_.Amount);
				}
			}
			var _loc5_:Object;
			if ((_loc5_ = _loc3_.Bonuses) != null)
			{
				for each (_loc14_ in _loc5_)
				{
					this.addLine(_loc14_.Name, _loc14_.Amount);
				}
			}
			this.addHeadline("DEDUCTIONS FOR EVIDENCE");
			var _loc6_:Object;
			if ((_loc6_ = _loc3_.Expenses) != null)
			{
				for each (_loc15_ in _loc6_)
				{
					this.addLine(_loc15_.Name, _loc15_.Amount * -1);
				}
			}
			var _loc7_:Object = _loc3_.TotalPayment;
			this.addHeadline("FINAL PAYOUT");
			if (_loc7_ != null)
			{
				for each (_loc16_ in _loc7_)
				{
					for (_loc17_ in _loc16_)
					{
						this.addLine(_loc17_, _loc16_[_loc17_]);
					}
				}
			}
			var _loc8_:Number = 0 - (MenuConstants.tileGap + MenuConstants.TabsLineUpperYPos);
			var _loc9_:Number = this.LIST_LEFT - this.BG_BORDER;
			var _loc10_:Number = this.LIST_WIDTH + this.BG_BORDER * 2;
			var _loc11_:Number = this.LIST_TOP - this.BG_BORDER;
			var _loc12_:Number = this.LIST_TOP + this.m_posX + this.BG_BORDER;
			this.m_bgTop.graphics.clear();
			this.m_bgTop.graphics.beginFill(16777215, 0.8);
			this.m_bgTop.graphics.drawRect(_loc9_, _loc8_, _loc10_, _loc11_ - _loc8_);
			this.m_bgTop.graphics.endFill();
			this.m_bgBottom.graphics.clear();
			this.m_bgBottom.graphics.beginFill(16777215, 0.8);
			this.m_bgBottom.graphics.drawRect(_loc9_, _loc12_, _loc10_, MenuConstants.BaseHeight - _loc12_);
			this.m_bgBottom.graphics.endFill();
			this.m_bgList.graphics.clear();
			this.m_bgList.graphics.beginFill(0, 0.45);
			this.m_bgList.graphics.drawRect(_loc9_, _loc11_, _loc10_, _loc12_ - _loc11_);
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
		
		private function addHeadline(param1:String):void
		{
			if (this.m_posX > 0)
			{
				this.m_posX += this.LINE_HEIGHT;
			}
			var _loc2_:TextField = this.createTextField();
			MenuUtils.setupText(_loc2_, param1);
			_loc2_.y = this.m_posX;
			this.m_posX += this.HEADLINE_HEIGHT;
			this.m_listView.addChild(_loc2_);
		}
		
		private function addLine(param1:String, param2:int):void
		{
			var _loc3_:TextField = this.createTextField();
			MenuUtils.setupText(_loc3_, param1);
			_loc3_.y = this.m_posX;
			var _loc4_:TextField = this.createTextField();
			MenuUtils.setupText(_loc4_, param2.toString());
			var _loc5_:TextFormat;
			(_loc5_ = _loc4_.getTextFormat()).align = TextFormatAlign.RIGHT;
			_loc4_.setTextFormat(_loc5_);
			_loc4_.y = this.m_posX;
			this.m_posX += this.LINE_HEIGHT;
			this.m_listView.addChild(_loc3_);
			this.m_listView.addChild(_loc4_);
		}
		
		private function createTextField():TextField
		{
			var _loc1_:TextField = new TextField();
			_loc1_.width = this.LIST_WIDTH;
			_loc1_.alpha = 0;
			this.m_elements.push(_loc1_);
			return _loc1_;
		}
		
		private function clear():void
		{
			var _loc1_:TextField = null;
			this.completeAnimations();
			for each (_loc1_ in this.m_elements)
			{
				this.m_listView.removeChild(_loc1_);
			}
			this.m_elements.length = 0;
			this.m_posX = 0;
			this.clearBackground();
		}
		
		private function startAnimations():void
		{
			var _loc2_:Number = NaN;
			var _loc1_:int = 0;
			while (_loc1_ < this.m_elements.length)
			{
				_loc2_ = 0.3 * _loc1_;
				Animate.fromTo(this.m_elements[_loc1_], 0.25, _loc2_, {"x": -50}, {"x": 0}, Animate.ExpoOut);
				Animate.addFromTo(this.m_elements[_loc1_], 0.25, _loc2_, {"alpha": 0}, {"alpha": 1}, Animate.Linear);
				Animate.delay(this.m_elements[_loc1_], _loc2_, this.playSound, "ScoreRating");
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
			var _loc5_:Number = this.LIST_TOP + this.m_posX + this.BG_BORDER;
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
	}
}
