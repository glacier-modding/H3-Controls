package menu3
{
	import basic.InfoBoxWithBackground;
	import common.Animate;
	import common.Localization;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.display.Sprite;
	import flash.external.ExternalInterface;
	
	public dynamic class MissionRewardPage extends MenuElementBase
	{
		
		private const IMAGE_REQUEST_MAX:Number = 3;
		
		private const TILE_WIDTH:Number = 232;
		
		private const TILE_HEIGHT:Number = 175;
		
		private const CONTENT_OFFSET_X:Number = 82;
		
		private const CONTENT_OFFSET_Y:Number = 370;
		
		private const START_ANIMATION_DELAY:Number = 0.5;
		
		private const TILE_ANIMATION_DELAY:Number = 1;
		
		private var m_view:MissionRewardPageView;
		
		private var m_infoView:InfoBoxWithBackground;
		
		private var m_opportunityTiles:Array;
		
		private var m_challengeTiles:Array;
		
		private var m_actionRewardTiles:Array;
		
		private var m_dropTiles:Array;
		
		private var m_opportunityTilesContainer:Sprite;
		
		private var m_challengeTilesContainer:Sprite;
		
		private var m_actionRewardTilesContainer:Sprite;
		
		private var m_dropTilesContainer:Sprite;
		
		private var m_loadImageQue:Array;
		
		private var m_showXP:Boolean;
		
		private var m_animationComplete:Boolean;
		
		private var m_maxTilesInRow:int = 7;
		
		private var m_rowCount:int = 0;
		
		private var m_horizontalTiles:Array;
		
		private var m_verticalTiles:Array;
		
		private var m_typeHeadlineStartPosY:Number;
		
		private var m_locationMasteryBar:MissionRewardBar;
		
		private var m_profileMasteryBar:MissionRewardBar;
		
		private var m_opportunityCount:int = 0;
		
		private var m_locationChallengeCount:int = 0;
		
		private var m_contractChallengeCount:int = 0;
		
		private var m_opportunityCountEnd:int = 0;
		
		private var m_locationChallengeCountEnd:int = 0;
		
		private var m_contractChallengeCountEnd:int = 0;
		
		private var m_opportunityCountMax:int = 0;
		
		private var m_locationChallengeCountMax:int = 0;
		
		private var m_contractChallengeCountMax:int = 0;
		
		public function MissionRewardPage(param1:Object)
		{
			this.m_opportunityTiles = [];
			this.m_challengeTiles = [];
			this.m_actionRewardTiles = [];
			this.m_dropTiles = [];
			this.m_horizontalTiles = [];
			this.m_verticalTiles = [];
			super(param1);
			this.m_animationComplete = false;
			this.m_infoView = new InfoBoxWithBackground();
			this.m_infoView.visible = false;
			this.m_infoView.x = -MenuConstants.menuXOffset;
			this.m_infoView.y = 0;
			addChild(this.m_infoView);
			this.m_view = new MissionRewardPageView();
			this.m_view.visible = false;
			this.m_view.titleMc.mask = this.m_view.titleMask;
			this.m_view.titleMask.x = -this.m_view.titleMask.width;
			addChild(this.m_view);
			this.m_locationMasteryBar = new MissionRewardBar(this.m_view.locationMastery);
			this.m_profileMasteryBar = new MissionRewardBar(this.m_view.profileMastery);
		}
		
		override public function onSetData(param1:Object):void
		{
			var _loc16_:Number = NaN;
			var _loc17_:int = 0;
			var _loc18_:Object = null;
			var _loc19_:int = 0;
			var _loc20_:int = 0;
			var _loc21_:Boolean = false;
			var _loc22_:Boolean = false;
			super.onSetData(param1);
			var _loc2_:Object = param1.LocationProgression;
			if (_loc2_ == null)
			{
				_loc2_ = new Object();
			}
			var _loc3_:Object = param1.ProfileProgression;
			if (_loc3_ == null)
			{
				_loc3_ = new Object();
			}
			if (_loc2_.HideProgression != undefined)
			{
				this.m_showXP = !_loc2_.HideProgression;
			}
			else
			{
				this.m_showXP = true;
			}
			this.m_view.visible = true;
			MenuUtils.setupText(this.m_view.titleMc.label_txt, Localization.get("UI_MENU_PAGE_DEBRIEFING_SUCCESS"), 71, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorGreyDark);
			this.m_view.typeMc.visible = false;
			this.m_typeHeadlineStartPosY = this.m_view.typeMc.y;
			this.m_view.rewardDetailsMc.visible = false;
			this.m_locationMasteryBar.init(_loc2_.LevelInfo);
			this.m_profileMasteryBar.init(_loc3_.LevelInfo);
			if (param1.loading)
			{
				return;
			}
			Animate.legacyTo(this.m_view.titleMask, 0.5, {"x": 0}, Animate.ExpoIn);
			this.m_loadImageQue = [];
			if (_loc2_.LevelInfo != undefined)
			{
				_loc16_ = this.m_showXP ? 0.78 : 0.4;
				Animate.delay(this.m_view, _loc16_, this.initPage, null);
				if (this.m_showXP)
				{
					this.m_locationMasteryBar.animateShowBar();
					this.m_profileMasteryBar.animateShowBar();
				}
			}
			if (Boolean(param1.OpportunityRewards) && param1.OpportunityRewards.length > 0)
			{
				this.addOpportunityTiles(param1.OpportunityRewards);
			}
			var _loc4_:Array = new Array();
			var _loc5_:Array = new Array();
			if (Boolean(param1.Challenges) && param1.Challenges.length > 0)
			{
				_loc17_ = 0;
				while (_loc17_ < param1.Challenges.length)
				{
					if ((_loc18_ = param1.Challenges[_loc17_]).IsActionReward === true)
					{
						_loc5_.push(_loc18_);
					}
					else
					{
						_loc4_.push(_loc18_);
					}
					_loc17_++;
				}
			}
			if (_loc4_ != null && _loc4_.length > 0)
			{
				this.addChallengeTiles(_loc4_);
			}
			if (_loc5_ != null && _loc5_.length > 0)
			{
				this.addActionRewardTiles(_loc5_);
			}
			if (Boolean(param1.Drops) && param1.Drops.length > 0)
			{
				this.addDropsTiles(param1.Drops);
			}
			var _loc6_:int = 0;
			while (_loc6_ < Math.min(this.IMAGE_REQUEST_MAX, this.m_loadImageQue.length))
			{
				this.loadImageFromQue();
				_loc6_++;
			}
			this.m_opportunityCountEnd = 0;
			this.m_opportunityCountMax = 0;
			if (param1.OpportunityStatistics != undefined)
			{
				this.m_opportunityCountEnd = param1.OpportunityStatistics.Completed;
				this.m_opportunityCountMax = param1.OpportunityStatistics.Count;
			}
			this.m_locationChallengeCountEnd = 0;
			this.m_locationChallengeCountMax = 0;
			if (param1.ChallengeCompletion != undefined)
			{
				this.m_locationChallengeCountEnd = param1.ChallengeCompletion.CompletedChallengesCount;
				this.m_locationChallengeCountMax = param1.ChallengeCompletion.ChallengesCount;
			}
			this.m_contractChallengeCountEnd = 0;
			this.m_contractChallengeCountMax = 0;
			if (param1.ContractChallengeCompletion != undefined)
			{
				this.m_contractChallengeCountEnd = param1.ContractChallengeCompletion.CompletedChallengesCount;
				this.m_contractChallengeCountMax = param1.ContractChallengeCompletion.ChallengesCount;
			}
			var _loc7_:Number = 0;
			var _loc8_:int = 0;
			if (this.m_challengeTiles != null)
			{
				_loc19_ = 0;
				while (_loc19_ < this.m_challengeTiles.length)
				{
					if (this.m_challengeTiles[_loc19_].XPGain != undefined)
					{
						_loc7_ += this.m_challengeTiles[_loc19_].XPGain;
					}
					if (!this.m_challengeTiles[_loc19_].IsGlobal)
					{
						_loc8_++;
					}
					_loc19_++;
				}
			}
			if (this.m_actionRewardTiles != null)
			{
				_loc20_ = 0;
				while (_loc20_ < this.m_actionRewardTiles.length)
				{
					if (this.m_actionRewardTiles[_loc20_].XPGain != undefined)
					{
						_loc7_ += this.m_actionRewardTiles[_loc20_].XPGain;
					}
					_loc20_++;
				}
			}
			this.m_locationChallengeCount = Math.max(this.m_locationChallengeCountEnd - _loc8_, 0);
			this.m_contractChallengeCount = Math.max(this.m_contractChallengeCountEnd - _loc8_, 0);
			var _loc9_:int = this.m_opportunityTiles != null ? int(this.m_opportunityTiles.length) : 0;
			this.m_opportunityCount = Math.max(this.m_opportunityCountEnd - _loc9_, 0);
			this.updateChallengeCountText();
			var _loc10_:Number = 0;
			if (_loc2_.XP != undefined)
			{
				_loc10_ = Number(_loc2_.XP);
			}
			var _loc11_:Number = 0;
			if (_loc2_.XPGain != undefined)
			{
				_loc11_ = Number(_loc2_.XPGain);
			}
			if (_loc10_ > 0)
			{
				if (!(_loc21_ = this.m_locationMasteryBar.isLevelMaxed(_loc10_)) || _loc11_ >= _loc7_)
				{
					_loc11_ = _loc7_;
				}
			}
			var _loc12_:Number = Math.max(_loc10_ - _loc11_, 0);
			this.m_locationMasteryBar.setXpValues(_loc12_, _loc10_, Localization.get("UI_MENU_PAGE_PROFILE_LOCATION_MASTERY"));
			var _loc13_:Number = 0;
			if (_loc3_.XP != undefined)
			{
				_loc13_ = Number(_loc3_.XP);
			}
			var _loc14_:Number = 0;
			if (_loc3_.XPGain != undefined)
			{
				_loc14_ = Number(_loc3_.XPGain);
			}
			if (_loc13_ > 0)
			{
				if (!(_loc22_ = this.m_profileMasteryBar.isLevelMaxed(_loc13_)) || _loc14_ >= _loc7_)
				{
					_loc14_ = _loc7_;
				}
			}
			var _loc15_:Number = Math.max(_loc13_ - _loc14_, 0);
			this.m_profileMasteryBar.setXpValues(_loc15_, _loc13_, Localization.get("UI_MENU_PAGE_PROFILE_PLAYER_MASTERY"));
		}
		
		private function updateChallengeCountText():void
		{
			var _loc3_:String = null;
			var _loc1_:String = Localization.get("UI_MENU_PAGE_PROFILE_LOCATION_CHALLENGES") + " " + String(this.m_contractChallengeCount) + "/" + String(this.m_contractChallengeCountMax);
			var _loc2_:String = Localization.get("UI_MENU_PAGE_PROFILE_MISSION_CHALLENGES") + " " + String(this.m_locationChallengeCount) + "/" + String(this.m_locationChallengeCountMax);
			MenuUtils.setupText(this.m_view.missionChallengesTxt, _loc1_, 28, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyDark);
			MenuUtils.setupText(this.m_view.locationChallengesTxt, _loc2_, 28, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyDark);
			if (getData().OpportunityStatistics != null && getData().OpportunityStatistics.Count != null && getData().OpportunityStatistics.Count > 0)
			{
				_loc3_ = Localization.get("UI_MENU_PAGE_PROFILE_STATISTICS_CATEGORY_PROFILE_COMPLETEDOPPORTUNITIES") + " " + String(this.m_opportunityCount) + "/" + String(this.m_opportunityCountMax);
				MenuUtils.setupText(this.m_view.opportunityTxt, _loc3_, 28, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyDark);
			}
		}
		
		private function getImagePath(param1:Object):String
		{
			if (Boolean(param1.image) && param1.image.length > 0)
			{
				return param1.image;
			}
			return null;
		}
		
		private function createTilesContainer(param1:Array):Sprite
		{
			var _loc4_:Object = null;
			var _loc5_:MissionRewardItem = null;
			var _loc6_:String = null;
			var _loc2_:Sprite = new Sprite();
			_loc2_.x = this.CONTENT_OFFSET_X;
			_loc2_.y = this.CONTENT_OFFSET_Y;
			_loc2_.visible = false;
			this.m_view.addChild(_loc2_);
			var _loc3_:int = 0;
			while (_loc3_ < param1.length)
			{
				_loc4_ = param1[_loc3_];
				(_loc5_ = new MissionRewardItem()).visible = false;
				if ((_loc6_ = this.getImagePath(_loc4_)) != null && _loc6_.length > 0)
				{
					this.m_loadImageQue.push({"view": _loc5_, "path": _loc6_});
				}
				param1[_loc3_].view = _loc5_;
				_loc2_.addChild(_loc5_);
				_loc3_++;
			}
			return _loc2_;
		}
		
		private function addOpportunityTiles(param1:Array):void
		{
			this.m_opportunityTiles = param1;
			this.m_opportunityTilesContainer = this.createTilesContainer(this.m_opportunityTiles);
		}
		
		private function addChallengeTiles(param1:Array):void
		{
			this.m_challengeTiles = param1;
			this.m_challengeTilesContainer = this.createTilesContainer(this.m_challengeTiles);
		}
		
		private function addActionRewardTiles(param1:Array):void
		{
			this.m_actionRewardTiles = param1;
			this.m_actionRewardTilesContainer = this.createTilesContainer(this.m_actionRewardTiles);
		}
		
		private function addDropsTiles(param1:Array):void
		{
			this.m_dropTiles = param1;
			this.m_dropTilesContainer = this.createTilesContainer(this.m_dropTiles);
		}
		
		private function initPage(param1:*):void
		{
			Animate.delay(this.m_view, this.START_ANIMATION_DELAY, this.animateOpportunityTiles, 0);
		}
		
		private function updateXP(param1:Number):void
		{
			var xpGain:Number = param1;
			if (this.m_showXP)
			{
				this.m_locationMasteryBar.updateXPBar(xpGain);
				this.m_profileMasteryBar.updateXPBar(xpGain);
				this.m_view.rewardDetailsMc.visible = true;
				this.m_view.rewardDetailsMc.xpMc.alpha = 0;
				MenuUtils.setupText(this.m_view.rewardDetailsMc.xpMc.label_txt, String("+" + xpGain), 45, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyDark);
				this.m_view.rewardDetailsMc.xpMc.x = -40;
				this.m_view.rewardDetailsMc.xpMc.y = 20;
				Animate.legacyTo(this.m_view.rewardDetailsMc.xpMc, 0.2, {"alpha": 1, "x": 0}, Animate.ExpoOut);
				Animate.delay(this.m_view.rewardDetailsMc.xpMc, 0.1, function():void
				{
					Animate.legacyTo(m_view.rewardDetailsMc.xpMc, 0.2, {"alpha": 0, "y": 60}, Animate.ExpoIn);
				});
			}
		}
		
		private function checkTileVertical(param1:Object):void
		{
			var _loc3_:int = 0;
			var _loc4_:int = 0;
			var _loc2_:Number = 0;
			if (this.m_horizontalTiles.length == this.m_maxTilesInRow)
			{
				this.m_verticalTiles.unshift(this.m_horizontalTiles.concat());
				this.m_horizontalTiles = [];
				if (this.m_rowCount == 0)
				{
					Animate.legacyTo(this.m_view.typeMc, 0.3, {"y": this.m_view.typeMc.y - this.TILE_HEIGHT}, Animate.ExpoOut);
				}
				_loc3_ = int(this.m_verticalTiles.length - 1);
				while (_loc3_ >= 0)
				{
					_loc4_ = 0;
					while (_loc4_ < this.m_verticalTiles[_loc3_].length)
					{
						Animate.delay(this.m_verticalTiles[_loc3_][_loc4_], _loc2_, this.moveTileVertical, this.m_verticalTiles[_loc3_][_loc4_], _loc3_);
						_loc2_ += 0.015;
						_loc4_++;
					}
					_loc3_--;
				}
				++this.m_rowCount;
			}
			this.m_horizontalTiles.unshift(param1.view as MissionRewardItem);
			if (this.m_horizontalTiles.length > 1)
			{
				_loc3_ = 1;
				while (_loc3_ < Math.min(this.m_horizontalTiles.length, this.m_maxTilesInRow))
				{
					Animate.legacyTo(this.m_horizontalTiles[_loc3_], 0.3, {"x": this.TILE_WIDTH * _loc3_}, Animate.ExpoOut);
					_loc3_++;
				}
			}
			Animate.delay(param1.view, _loc2_, param1.view.animateIn, null);
		}
		
		public function moveTileVertical(param1:MissionRewardItem, param2:int):void
		{
			var _loc3_:Number = -(this.TILE_HEIGHT * (param2 + 1));
			if (param2 > 0)
			{
				param1.animateOut(null);
			}
			else
			{
				Animate.legacyTo(param1, 0.15, {"y": _loc3_}, Animate.ExpoOut);
			}
		}
		
		private function animateSingleTile(param1:Object, param2:String, param3:String):void
		{
			var tile:Object = param1;
			var type:String = param2;
			var header:String = param3;
			this.m_view.rewardDetailsMc.visible = true;
			this.m_view.rewardDetailsMc.alpha = 1;
			MenuUtils.setupText(this.m_view.rewardDetailsMc.typeMc.label_txt, type, 18, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorGreyDark);
			MenuUtils.setupText(this.m_view.rewardDetailsMc.headerMc.label_txt, header, 26, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyDark);
			this.m_view.rewardDetailsMc.typeMc.alpha = 0;
			this.m_view.rewardDetailsMc.typeMc.x -= 20;
			this.m_view.rewardDetailsMc.headerMc.alpha = 0;
			this.m_view.rewardDetailsMc.headerMc.x -= 20;
			this.checkTileVertical(tile);
			Animate.delay(this.m_view.rewardDetailsMc.headerMc, 0.2, function():void
			{
				Animate.legacyTo(m_view.rewardDetailsMc.typeMc, 0.3, {"alpha": 1, "x": m_view.rewardDetailsMc.typeMc.x + 20}, Animate.ExpoOut);
			});
			Animate.delay(this.m_view.rewardDetailsMc.headerMc, 0.25, function():void
			{
				Animate.legacyTo(m_view.rewardDetailsMc.headerMc, 0.2, {"alpha": 1, "x": m_view.rewardDetailsMc.headerMc.x + 20}, Animate.ExpoOut);
			});
		}
		
		public function animateOpportunityTiles(param1:int):void
		{
			var currentTile:Object = null;
			var currentTileNum:int = param1;
			if (!this.m_opportunityTiles || this.m_opportunityTiles.length == 0)
			{
				this.animateChallengeTiles(0);
				return;
			}
			this.m_opportunityTilesContainer.visible = true;
			this.m_view.typeMc.visible = true;
			MenuUtils.setupText(this.m_view.typeMc.label_txt, Localization.get("UI_MENU_PAGE_PROFILE_STATISTICS_CATEGORY_PROFILE_COMPLETEDOPPORTUNITIES"), 45, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyDark);
			if (currentTileNum < this.m_opportunityTiles.length)
			{
				currentTile = this.m_opportunityTiles[currentTileNum];
				this.animateSingleTile(currentTile, Localization.get("UI_OPPORTUNITIES_COMPLETED_TEXT"), Localization.get(currentTile.OpportunityName));
				this.m_opportunityCount = Math.min(this.m_opportunityCount + 1, this.m_opportunityCountEnd);
				Animate.delay(this.m_view.rewardDetailsMc.xpMc, 0.3, this.updateChallengeCountText, null);
				this.playSound("ShowChallenge");
				Animate.delay(this.m_view, this.TILE_ANIMATION_DELAY, this.animateOpportunityTiles, currentTileNum + 1);
			}
			else
			{
				this.m_view.typeMc.visible = false;
				this.m_view.typeMc.y = this.m_typeHeadlineStartPosY;
				Animate.kill(this.m_view);
				Animate.legacyTo(this.m_view.rewardDetailsMc, 0.5, {"alpha": 0}, Animate.ExpoOut, function():void
				{
					m_horizontalTiles = [];
					m_verticalTiles = [];
					m_rowCount = 0;
					Animate.legacyTo(m_opportunityTilesContainer, 0.2, {"alpha": 0}, Animate.ExpoOut);
					Animate.delay(m_view, 0.2, animateChallengeTiles, 0);
				});
			}
		}
		
		public function animateChallengeTiles(param1:int):void
		{
			var currentChallengeTile:Object = null;
			var currentTileNum:int = param1;
			if (!this.m_challengeTiles || this.m_challengeTiles.length == 0)
			{
				this.animateActionRewardTiles(0);
				return;
			}
			this.m_challengeTilesContainer.visible = true;
			this.m_view.typeMc.visible = true;
			MenuUtils.setupText(this.m_view.typeMc.label_txt, Localization.get("UI_MENU_PAGE_PROFILE_STATISTICS_CATEGORY_PROFILE_COMPLETEDCHALLENGES"), 45, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyDark);
			if (currentTileNum < this.m_challengeTiles.length)
			{
				currentChallengeTile = this.m_challengeTiles[currentTileNum];
				this.animateSingleTile(currentChallengeTile, Localization.get("UI_DIALOG_TITLE_CHALLENGE_COMPLETED"), Localization.get(currentChallengeTile.ChallengeName));
				if (currentChallengeTile.XPGain)
				{
					Animate.delay(this.m_view.rewardDetailsMc.xpMc, 0.3, this.updateXP, currentChallengeTile.XPGain);
				}
				if (!currentChallengeTile.IsGlobal)
				{
					this.m_contractChallengeCount = Math.min(this.m_contractChallengeCount + 1, this.m_contractChallengeCountEnd);
					this.m_locationChallengeCount = Math.min(this.m_locationChallengeCount + 1, this.m_locationChallengeCountEnd);
					Animate.delay(this.m_view.rewardDetailsMc.xpMc, 0.3, this.updateChallengeCountText, null);
				}
				this.playSound("ShowChallenge");
				Animate.delay(this.m_view, this.TILE_ANIMATION_DELAY, this.animateChallengeTiles, currentTileNum + 1);
			}
			else
			{
				this.m_view.typeMc.visible = false;
				this.m_view.typeMc.y = this.m_typeHeadlineStartPosY;
				this.m_locationMasteryBar.showXPLeft();
				this.m_profileMasteryBar.showXPLeft();
				Animate.kill(this.m_view);
				Animate.legacyTo(this.m_view.rewardDetailsMc, 0.5, {"alpha": 0}, Animate.ExpoOut, function():void
				{
					m_horizontalTiles = [];
					m_verticalTiles = [];
					m_rowCount = 0;
					Animate.legacyTo(m_challengeTilesContainer, 0.2, {"alpha": 0}, Animate.ExpoOut);
					Animate.delay(m_view, 0.2, animateActionRewardTiles, 0);
				});
			}
		}
		
		public function animateActionRewardTiles(param1:int):void
		{
			var currentActionRewardTile:Object = null;
			var currentTileNum:int = param1;
			if (!this.m_actionRewardTiles || this.m_actionRewardTiles.length == 0)
			{
				this.animateDropTiles(0);
				this.m_locationMasteryBar.showXPLeft();
				this.m_profileMasteryBar.showXPLeft();
				return;
			}
			this.m_actionRewardTilesContainer.visible = true;
			this.m_view.typeMc.visible = true;
			MenuUtils.setupText(this.m_view.typeMc.label_txt, Localization.get("UI_MENU_ACTIONREWARD_CATEGORY_TITLE"), 45, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyDark);
			if (currentTileNum < this.m_actionRewardTiles.length)
			{
				currentActionRewardTile = this.m_actionRewardTiles[currentTileNum];
				this.animateSingleTile(currentActionRewardTile, Localization.get("UI_MENU_ACTIONREWARD_TITLE"), Localization.get(currentActionRewardTile.ChallengeName));
				if (currentActionRewardTile.XPGain)
				{
					Animate.delay(this.m_view.rewardDetailsMc.xpMc, 0.3, this.updateXP, currentActionRewardTile.XPGain);
				}
				this.playSound("ShowChallenge");
				Animate.delay(this.m_view, this.TILE_ANIMATION_DELAY, this.animateActionRewardTiles, currentTileNum + 1);
			}
			else
			{
				this.m_view.typeMc.visible = false;
				this.m_view.typeMc.y = this.m_typeHeadlineStartPosY;
				this.m_locationMasteryBar.showXPLeft();
				this.m_profileMasteryBar.showXPLeft();
				Animate.kill(this.m_view);
				Animate.legacyTo(this.m_view.rewardDetailsMc, 0.5, {"alpha": 0}, Animate.ExpoOut, function():void
				{
					var _loc1_:Number = NaN;
					if (m_dropTiles != null && m_dropTiles.length > 0)
					{
						m_horizontalTiles = [];
						m_verticalTiles = [];
						m_rowCount = 0;
						Animate.legacyTo(m_actionRewardTilesContainer, 0.2, {"alpha": 0}, Animate.ExpoOut);
						_loc1_ = 0.2;
						Animate.delay(m_view, _loc1_, animateDropTiles, 0);
					}
				});
			}
		}
		
		public function animateDropTiles(param1:int):void
		{
			var _loc2_:Object = null;
			if (!this.m_dropTiles || this.m_dropTiles.length == 0)
			{
				this.m_animationComplete = true;
				return;
			}
			this.m_dropTilesContainer.visible = true;
			this.m_view.rewardDetailsMc.visible = true;
			this.m_view.rewardDetailsMc.alpha = 1;
			this.m_view.typeMc.visible = true;
			MenuUtils.setupText(this.m_view.typeMc.label_txt, Localization.get("UI_MENU_PAGE_DEBRIEFING_DROPS"), 45, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyDark);
			if (param1 < this.m_dropTiles.length)
			{
				_loc2_ = this.m_dropTiles[param1];
				this.animateSingleTile(_loc2_, _loc2_.type, _loc2_.name);
				this.playSound("ShowDrop");
				Animate.delay(this.m_view, this.TILE_ANIMATION_DELAY, this.animateDropTiles, param1 + 1);
			}
			else
			{
				Animate.legacyTo(this.m_view.rewardDetailsMc, 1, {"alpha": 0}, Animate.ExpoOut);
				Animate.kill(this.m_view);
				this.m_animationComplete = true;
			}
		}
		
		private function loadImageFromQue():void
		{
			var _loc1_:Object = null;
			if (this.m_loadImageQue.length > 0)
			{
				_loc1_ = this.m_loadImageQue.shift();
				_loc1_.view.loadImage(_loc1_.path, this.loadImageFromQue, this.loadImageFromQue);
			}
		}
		
		public function playSound(param1:String):void
		{
			ExternalInterface.call("PlaySound", param1);
		}
		
		public function isAnimationComplete():Boolean
		{
			return this.m_animationComplete;
		}
		
		override public function onUnregister():void
		{
			trace("MissionRewardPage, onUnregister, m_view:", this.m_view);
			if (this.m_view)
			{
				Animate.kill(this.m_view);
				if (this.m_locationMasteryBar != null)
				{
					this.m_locationMasteryBar.onUnregister();
					this.m_locationMasteryBar = null;
				}
				if (this.m_profileMasteryBar != null)
				{
					this.m_profileMasteryBar.onUnregister();
					this.m_profileMasteryBar = null;
				}
				trace("MissionRewardPage, onUnregister, rewardDetails:", this.m_view.rewardDetailsMc);
				if (this.m_view.rewardDetailsMc)
				{
					Animate.kill(this.m_view.rewardDetailsMc);
				}
				trace("MissionRewardPage, onUnregister, opportunityTilesContainer:", this.m_opportunityTilesContainer);
				trace("MissionRewardPage, onUnregister, opportunityTiles:", this.m_opportunityTiles);
				this.clearTiles(this.m_opportunityTilesContainer, this.m_opportunityTiles);
				this.m_opportunityTilesContainer = null;
				this.m_opportunityTiles = null;
				trace("MissionRewardPage, onUnregister, challTilesContainer:", this.m_challengeTilesContainer);
				trace("MissionRewardPage, onUnregister, challTiles:", this.m_challengeTiles);
				this.clearTiles(this.m_challengeTilesContainer, this.m_challengeTiles);
				this.m_challengeTilesContainer = null;
				this.m_challengeTiles = null;
				trace("MissionRewardPage, onUnregister, actionRewardTilesContainer:", this.m_actionRewardTilesContainer);
				trace("MissionRewardPage, onUnregister, actionRewardTiles:", this.m_actionRewardTiles);
				this.clearTiles(this.m_actionRewardTilesContainer, this.m_actionRewardTiles);
				this.m_actionRewardTilesContainer = null;
				this.m_actionRewardTiles = null;
				trace("MissionRewardPage, onUnregister, dropTilesContainer:", this.m_dropTilesContainer);
				trace("MissionRewardPage, onUnregister, dropTiles:", this.m_dropTiles);
				this.clearTiles(this.m_dropTilesContainer, this.m_dropTiles);
				this.m_dropTilesContainer = null;
				this.m_dropTiles = null;
				removeChild(this.m_view);
				this.m_view = null;
			}
		}
		
		private function clearTiles(param1:Sprite, param2:Array):void
		{
			var _loc3_:int = 0;
			var _loc4_:Object = null;
			if (param2 != null && param1 != null)
			{
				_loc3_ = 0;
				while (_loc3_ < param2.length)
				{
					if ((_loc4_ = param2[_loc3_]).view != null)
					{
						Animate.kill(_loc4_.view);
						param1.removeChild(_loc4_.view);
					}
					_loc3_++;
				}
				this.m_view.removeChild(param1);
			}
		}
	}
}
