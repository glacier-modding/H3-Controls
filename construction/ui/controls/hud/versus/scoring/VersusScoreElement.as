package hud.versus.scoring
{
	import common.Animate;
	import common.BaseControl;
	import common.Localization;
	import common.Log;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.external.ExternalInterface;
	import flash.text.TextFieldAutoSize;
	
	public class VersusScoreElement extends BaseControl
	{
		
		private var m_playerScoreElement:PlayerScoreElementView;
		
		private var m_opponentScoreElement:OpponentScoreElementView;
		
		private var m_unnoticedKillElement:UnnoticedKillElement;
		
		private var m_initPreScoreTimeUpdate:Boolean = true;
		
		private var m_currentPlayerScore:Number = -1;
		
		private var m_currentOpponentScore:Number = -1;
		
		public function VersusScoreElement()
		{
			super();
			this.m_playerScoreElement = new PlayerScoreElementView();
			this.m_opponentScoreElement = new OpponentScoreElementView();
			this.m_unnoticedKillElement = new UnnoticedKillElement();
			addChild(this.m_playerScoreElement);
			addChild(this.m_opponentScoreElement);
			addChild(this.m_unnoticedKillElement);
			this.m_playerScoreElement.visible = false;
			this.m_opponentScoreElement.visible = false;
			this.m_unnoticedKillElement.visible = false;
			this.m_playerScoreElement.x = -2;
			this.m_opponentScoreElement.x = 2;
			this.m_unnoticedKillElement.y = 76;
		}
		
		public function onSetData(param1:Object):void
		{
			var _loc3_:int = 0;
			var _loc4_:Number = NaN;
			Log.debugData(this, param1);
			var _loc2_:Array = param1.players;
			if (_loc2_ != null)
			{
				_loc3_ = 0;
				while (_loc3_ < _loc2_.length)
				{
					if (_loc2_[_loc3_].isPlayer)
					{
						this.m_playerScoreElement.visible = true;
						if (_loc2_[_loc3_].playername != null)
						{
							if (_loc2_[_loc3_].playername != "")
							{
								MenuUtils.setupText(this.m_playerScoreElement.nameLabel, _loc2_[_loc3_].playername, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
								this.m_playerScoreElement.nameLabel.autoSize = TextFieldAutoSize.RIGHT;
							}
						}
						this.updatePlayerScore(_loc2_[_loc3_].score);
					}
					else
					{
						this.m_opponentScoreElement.visible = true;
						if (_loc2_[_loc3_].playername != null)
						{
							if (_loc2_[_loc3_].playername != "")
							{
								MenuUtils.setupText(this.m_opponentScoreElement.nameLabel, _loc2_[_loc3_].playername, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
								this.m_opponentScoreElement.nameLabel.autoSize = TextFieldAutoSize.LEFT;
							}
						}
						this.updateOpponentScore(_loc2_[_loc3_].score);
					}
					_loc3_++;
				}
				_loc4_ = this.m_playerScoreElement.nameLabel.width >= this.m_opponentScoreElement.nameLabel.width ? this.m_playerScoreElement.nameLabel.width : this.m_opponentScoreElement.nameLabel.width;
				this.m_playerScoreElement.bgMc.width = this.m_opponentScoreElement.bgMc.width = 100 + _loc4_;
			}
		}
		
		private function updatePlayerScore(param1:Number):void
		{
			if (param1 == this.m_currentPlayerScore)
			{
				return;
			}
			MenuUtils.setupText(this.m_playerScoreElement.scoreMc.scoreLabel, param1.toString(), 43, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
			if (param1 > 0)
			{
				Animate.fromTo(this.m_playerScoreElement.scoreMc, 0.2, 0, {"scaleX": 2, "scaleY": 2}, {"scaleX": 1, "scaleY": 1}, Animate.ExpoOut);
			}
			this.m_currentPlayerScore = param1;
		}
		
		private function updateOpponentScore(param1:Number):void
		{
			if (param1 == this.m_currentOpponentScore)
			{
				return;
			}
			MenuUtils.setupText(this.m_opponentScoreElement.scoreMc.scoreLabel, param1.toString(), 43, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
			if (param1 > 0)
			{
				Animate.fromTo(this.m_opponentScoreElement.scoreMc, 0.2, 0, {"scaleX": 2, "scaleY": 2}, {"scaleX": 1, "scaleY": 1}, Animate.ExpoOut);
			}
			this.m_currentOpponentScore = param1;
		}
		
		public function updatePreScoreTimer(param1:Object):void
		{
			var _loc4_:Object = null;
			var _loc2_:Boolean = Boolean(param1.IsMe);
			var _loc3_:Number = Number(param1.TimeLeft);
			if (_loc2_)
			{
				if (_loc3_ > 0)
				{
					if (this.m_initPreScoreTimeUpdate)
					{
						this.m_initPreScoreTimeUpdate = false;
						_loc4_ = {"header": Localization.get("UI_HUD_VS_UNNOTICED_KILL_TIMER"), "time": _loc3_};
						this.m_unnoticedKillElement.visible = true;
						this.m_unnoticedKillElement.onSetData(_loc4_);
					}
					else
					{
						this.m_unnoticedKillElement.update(_loc3_);
					}
				}
				else
				{
					this.m_unnoticedKillElement.hide();
					this.m_initPreScoreTimeUpdate = true;
				}
			}
		}
		
		public function playSound(param1:String):void
		{
			ExternalInterface.call("PlaySound", param1);
		}
	}
}
