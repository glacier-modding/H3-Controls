package hud.sniper
{
	import common.Animate;
	import common.BaseControl;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.display.Sprite;
	import flash.external.ExternalInterface;
	
	public class ScrollingScoreElement extends BaseControl
	{
		
		private var m_elementYOffset:int = 26;
		
		private var m_elementsArray:Array;
		
		private var m_scrollingContainer:Sprite;
		
		private var m_staticContainer:Sprite;
		
		public function ScrollingScoreElement()
		{
			super();
			this.m_staticContainer = new Sprite();
			this.m_staticContainer.y = -this.m_elementYOffset;
			addChild(this.m_staticContainer);
			this.m_scrollingContainer = new Sprite();
			this.m_scrollingContainer.y = this.m_elementYOffset * 21;
			addChild(this.m_scrollingContainer);
			this.m_elementsArray = new Array();
		}
		
		public function onSetData(param1:Object):void
		{
			var _loc7_:String = null;
			if (param1 == null)
			{
				return;
			}
			if (param1.type == 12)
			{
				return;
			}
			var _loc2_:String = param1.point >= 0 ? "+" : "-";
			var _loc3_:String = String(Math.abs(param1.point));
			var _loc4_:String = param1.name + "     " + _loc2_ + " " + _loc3_;
			var _loc5_:ScrollingScoreElementView = new ScrollingScoreElementView();
			var _loc6_:String = MenuConstants.FontColorWhite;
			switch (true)
			{
			case param1.point < 0: 
				_loc7_ = "fail";
				break;
			case param1.point >= 0 && param1.point < 2000: 
				_loc7_ = "common";
				break;
			case param1.point >= 2000 && param1.point < 4000: 
				_loc7_ = "fair";
				break;
			case param1.point >= 4000 && param1.point < 5000: 
				_loc7_ = "good";
				break;
			case param1.point >= 5000: 
				_loc7_ = "awesome";
				break;
			default: 
				_loc7_ = "common";
			}
			switch (param1.type)
			{
			case 3: 
				_loc6_ = MenuConstants.FontColorRed;
				break;
			case 7: 
				_loc6_ = MenuConstants.FontColorYellow;
				break;
			case 8: 
				_loc6_ = MenuConstants.FontColorYellow;
				break;
			case 9: 
				_loc6_ = MenuConstants.FontColorYellow;
				break;
			case 10: 
				_loc6_ = MenuConstants.FontColorGreen;
				break;
			case 11: 
				_loc6_ = MenuConstants.FontColorGreen;
				break;
			default: 
				_loc6_ = MenuConstants.FontColorWhite;
			}
			MenuUtils.setupText(_loc5_.score_mc.score_txt, _loc4_, 18, MenuConstants.FONT_TYPE_MEDIUM, _loc6_);
			_loc5_.score_mc.alpha = 0.8;
			_loc5_.alpha = 0;
			_loc5_.y = this.m_elementsArray.length * this.m_elementYOffset - this.m_elementYOffset * 20;
			var _loc8_:int = 0;
			var _loc9_:int = 0;
			while (_loc9_ < this.m_elementsArray.length)
			{
				if (this.m_elementsArray[_loc9_].isactive)
				{
					_loc8_ += 1;
				}
				_loc9_++;
			}
			_loc5_.elementdelaynum = _loc8_;
			_loc5_.levelOfAwesomeness = _loc7_;
			_loc5_.isactive = true;
			this.m_elementsArray.push(_loc5_);
			this.m_scrollingContainer.addChild(_loc5_);
			this.scoreAnimFlowStart(_loc5_);
		}
		
		private function scoreAnimFlowStart(param1:ScrollingScoreElementView):void
		{
			Animate.offset(param1, 0.6, param1.elementdelaynum * 0.1, {"y": -this.m_elementYOffset}, Animate.ExpoOut, this.scoreAnimFlowPop, param1);
			Animate.addTo(param1, 0.6, param1.elementdelaynum * 0.1, {"alpha": 1}, Animate.ExpoOut);
		}
		
		private function scoreAnimFlowPop(param1:ScrollingScoreElementView):void
		{
			if (param1.levelOfAwesomeness == "fail")
			{
				this.playSound("ScoreFail");
			}
			else if (param1.levelOfAwesomeness == "common")
			{
				this.playSound("ScoreCommon");
				Animate.to(param1.score_mc, 0.4, 0, {"alpha": 1}, Animate.ExpoOut);
			}
			else if (param1.levelOfAwesomeness == "fair")
			{
				this.playSound("ScoreFair");
				Animate.to(param1.score_mc, 0.4, 0, {"alpha": 1}, Animate.ExpoOut);
			}
			else if (param1.levelOfAwesomeness == "good")
			{
				this.playSound("ScoreGood");
				Animate.to(param1.score_mc, 0.4, 0, {"alpha": 1}, Animate.ExpoOut);
			}
			else if (param1.levelOfAwesomeness == "awesome")
			{
				this.playSound("ScoreAwesome");
				Animate.to(param1.score_mc, 0.4, 0, {"alpha": 1, "scaleX": 1.05, "scaleY": 1.05}, Animate.ExpoOut);
			}
			Animate.offset(param1, 0.4, 0.3 + param1.elementdelaynum * 0.2, {"y": -this.m_elementYOffset}, Animate.ExpoIn, this.scoreAnimFlowSwipe, param1);
		}
		
		private function scoreAnimFlowSwipe(param1:ScrollingScoreElementView):void
		{
			this.m_scrollingContainer.removeChild(param1);
			this.m_staticContainer.addChild(param1);
			param1.y = 0;
			Animate.to(param1, 0.4, 0, {"x": 800, "y": -this.m_elementYOffset * 2, "alpha": 0}, Animate.ExpoIn, this.scoreAnimFlowFinish, param1);
			Animate.offset(this.m_scrollingContainer, 0.2, 0, {"y": -this.m_elementYOffset}, Animate.ExpoOut);
		}
		
		private function scoreAnimFlowFinish(param1:ScrollingScoreElementView):void
		{
			Animate.kill(param1);
			param1.isactive = false;
			var _loc2_:int = 0;
			while (_loc2_ < this.m_elementsArray.length)
			{
				if (this.m_elementsArray[_loc2_].isactive)
				{
					return;
				}
				_loc2_++;
			}
			this.m_elementsArray = [];
			this.m_scrollingContainer.y = this.m_elementYOffset * 21;
			while (this.m_staticContainer.numChildren > 0)
			{
				this.m_staticContainer.removeChildAt(0);
			}
		}
		
		public function playSound(param1:String):void
		{
			ExternalInterface.call("PlaySound", param1);
		}
		
		public function testScrollingScoreElement():void
		{
			var _loc1_:int = 0;
			while (_loc1_ < 4)
			{
				this.onSetData({"type": 6, "point": 1000, "name": "Test Wipe 0" + _loc1_});
				_loc1_++;
			}
		}
	}
}
