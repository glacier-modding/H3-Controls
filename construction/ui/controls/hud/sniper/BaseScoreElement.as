package hud.sniper
{
	import common.Animate;
	import common.BaseControl;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.external.ExternalInterface;
	
	public class BaseScoreElement extends BaseControl
	{
		
		private var m_view:BaseScoreElementView;
		
		private var m_previousScore:int = 0;
		
		private var m_scoreStackArray:Array;
		
		private var m_scoreAnimatingArray:Array;
		
		private var m_scoreStackCount:int = 1;
		
		public function BaseScoreElement()
		{
			this.m_scoreStackArray = new Array();
			this.m_scoreAnimatingArray = new Array();
			super();
			this.m_view = new BaseScoreElementView();
			addChild(this.m_view);
			this.hideText();
		}
		
		public function onSetData(param1:Object):void
		{
			this.showText(param1.title, param1.body);
		}
		
		public function showText(param1:String, param2:String):void
		{
			var _loc3_:BaseScoreElementTextView = new BaseScoreElementTextView();
			this.m_view.scorecontainer.addChild(_loc3_);
			var _loc4_:int;
			var _loc5_:int = (_loc4_ = int(param2)) - this.m_previousScore;
			var _loc6_:Number = 1;
			if (_loc5_ < 0)
			{
				_loc6_ = 0.8;
			}
			else if (_loc5_ >= 0 && _loc5_ <= 1000)
			{
				_loc6_ = 1.2;
			}
			else if (_loc5_ > 1000 && _loc5_ <= 2000)
			{
				_loc6_ = 1.4;
			}
			else if (_loc5_ > 2000 && _loc5_ <= 3000)
			{
				_loc6_ = 1.7;
			}
			else if (_loc5_ > 3000)
			{
				_loc6_ = 2;
			}
			this.m_scoreStackArray.push({"theClip": _loc3_, "previousScore": this.m_previousScore, "currentScore": _loc4_, "scoreDifference": _loc5_, "scaleValue": _loc6_});
			this.delayAnimation();
			this.m_previousScore = _loc4_;
			this.setVisible(true);
		}
		
		private function delayAnimation():void
		{
			var scoreObject:Object = null;
			var delay:Number = 0.6 + this.m_scoreStackArray.length * 0.1 + (0.4 + 0.3 + this.m_scoreStackArray.length * 0.2) + 0.4;
			scoreObject = this.m_scoreStackArray[this.m_scoreStackArray.length - 1];
			Animate.delay(scoreObject.theClip, delay, function():void
			{
				startAnimation(scoreObject);
			});
		}
		
		private function startAnimation(param1:Object):void
		{
			var previousScoreString:String;
			var currentScoreString:String;
			var currentScore:int = 0;
			var oldScoreObject:Object = null;
			var offsetX:Number = NaN;
			var scoreObject:Object = param1;
			this.m_scoreAnimatingArray.push(scoreObject);
			if (this.m_scoreAnimatingArray.length >= 2)
			{
				oldScoreObject = this.m_scoreAnimatingArray.shift();
				this.m_scoreStackArray.shift();
				Animate.kill(oldScoreObject.theClip.score_txt);
				Animate.kill(oldScoreObject.theClip);
				this.m_view.scorecontainer.removeChild(oldScoreObject.theClip);
				oldScoreObject.theClip = null;
			}
			previousScoreString = String(scoreObject.previousScore);
			currentScoreString = String(scoreObject.currentScore);
			currentScore = int(scoreObject.currentScore);
			MenuUtils.setupText(scoreObject.theClip.score_txt, previousScoreString, 18, MenuConstants.FONT_TYPE_BOLD, scoreObject.scoreDifference < 0 ? MenuConstants.FontColorRed : MenuConstants.FontColorWhite);
			if (scoreObject.scoreDifference != 0)
			{
				offsetX = (scoreObject.theClip.score_txt.textWidth * scoreObject.scaleValue - scoreObject.theClip.score_txt.textWidth) / 2;
				this.playSound("ScoreStartUpdate");
				Animate.fromTo(scoreObject.theClip.score_txt, 0.6, 0, {"intAnimation": previousScoreString}, {"intAnimation": currentScoreString}, Animate.ExpoOut, function():void
				{
					MenuUtils.setupText(scoreObject.theClip.score_txt, MenuUtils.formatNumber(currentScore), 18, MenuConstants.FONT_TYPE_BOLD, currentScore < 0 ? MenuConstants.FontColorRed : MenuConstants.FontColorWhite);
					m_scoreStackArray.shift();
					playSound("ScoreStopUpdate");
				});
				Animate.fromTo(scoreObject.theClip, 0.6, 0, {"scaleX": scoreObject.scaleValue, "scaleY": scoreObject.scaleValue, "x": offsetX}, {"scaleX": 1, "scaleY": 1, "x": 0}, Animate.ExpoOut);
			}
			else
			{
				this.m_scoreStackArray.shift();
			}
		}
		
		public function hideText():void
		{
			this.m_view.visible = false;
		}
		
		private function setVisible(param1:Boolean):void
		{
			this.m_view.visible = param1;
		}
		
		public function playSound(param1:String):void
		{
			ExternalInterface.call("PlaySound", param1);
		}
	}
}
