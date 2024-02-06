package menu3.basic
{
	import basic.DottedLine;
	import common.Animate;
	import common.CommonUtils;
	import common.Localization;
	import common.MouseUtil;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.external.ExternalInterface;
	import menu3.MenuElementTileBase;
	
	public dynamic class DetailedScoreTile extends MenuElementTileBase
	{
		
		private const EDGE_PADDING:Number = 10;
		
		private var m_view:DetailedScoreTileView;
		
		private var m_yOffset:int;
		
		private var m_silentAssassinIsMedicineMan:Boolean = false;
		
		private var m_missionRatingMc:MovieClip;
		
		private var m_missionTimeMc:MovieClip;
		
		private var m_missionScoreMc:MovieClip;
		
		private var m_isEvergreen:Boolean = false;
		
		private var m_isNewBestScore:Boolean = false;
		
		private var m_isNewBestTime:Boolean = false;
		
		private var m_isNewBestRating:Boolean = false;
		
		public function DetailedScoreTile(param1:Object)
		{
			super(param1);
			m_mouseMode = MouseUtil.MODE_ONOVER_SELECT_ONUP_CLICK;
			this.m_view = new DetailedScoreTileView();
			this.m_view.y = -64;
			this.m_view.tileBg.alpha = 0;
			this.m_missionRatingMc = this.m_view.missionSummaryMc.missionRatingMc;
			this.m_missionTimeMc = this.m_view.missionSummaryMc.missionTimeMc;
			this.m_missionScoreMc = this.m_view.missionSummaryMc.missionScoreMc;
			var _loc2_:* = !ControlsMain.isVrModeActive();
			this.m_missionRatingMc.newBestFx.visible = _loc2_;
			this.m_missionTimeMc.newBestFx.visible = _loc2_;
			this.m_missionScoreMc.newBestFx.visible = _loc2_;
			this.m_view.missionSummaryMc.lineMc_01.alpha = this.m_view.missionSummaryMc.lineMc_02.alpha = this.m_view.missionSummaryMc.lineMc_03.alpha = this.m_view.missionSummaryMc.lineMc_04.alpha = 1;
			this.m_view.offlineTxt.visible = this.m_view.silentAssassinMc.visible = this.m_view.playStyleMc.visible = this.m_view.leaderboardPosMc.visible = false;
			this.formatNewBestTextFields(this.m_missionRatingMc);
			this.formatNewBestTextFields(this.m_missionTimeMc);
			this.formatNewBestTextFields(this.m_missionScoreMc);
			this.m_missionScoreMc.newBestBgNegative.alpha = 0;
			MenuUtils.setupTextUpper(this.m_view.leaderboardPosMc.lowTxt, Localization.get("UI_MENU_PAGE_DEBRIEFING_LEADERBOARDS_BOTTOM"), 14, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyLight);
			MenuUtils.setupTextUpper(this.m_view.leaderboardPosMc.titleTxt, Localization.get("UI_MENU_PAGE_DEBRIEFING_LEADERBOARDS_POSITION"), 14, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyLight);
			MenuUtils.setupTextUpper(this.m_view.leaderboardPosMc.highTxt, Localization.get("UI_MENU_PAGE_DEBRIEFING_LEADERBOARDS_TOP"), 14, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyLight);
			addChild(this.m_view);
		}
		
		override public function onSetData(param1:Object):void
		{
			var _loc9_:MovieClip = null;
			super.onSetData(param1);
			this.playSound("ui_debrief_detailsscreen_open");
			this.m_isEvergreen = param1.ContractType == "evergreen";
			this.m_yOffset = param1.Percentile != null ? 395 : 153;
			var _loc2_:* = param1.rating != null;
			var _loc3_:int = param1.rating != null ? int(param1.rating) : 0;
			if (this.m_isEvergreen)
			{
				_loc2_ = false;
			}
			var _loc4_:* = param1.animate === true;
			var _loc5_:Boolean = false;
			var _loc6_:String = "";
			var _loc7_:* = _loc3_ >= 5;
			this.m_silentAssassinIsMedicineMan = false;
			this.m_view.preliminaryScoreMc.y = this.m_yOffset;
			if (param1.player != undefined)
			{
				if (param1.player2 != undefined)
				{
					MenuUtils.setupText(this.m_view.headerTxt, param1.player + MenuConstants.PLAYER_MULTIPLAYER_DELIMITER + param1.player2, 60, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
					CommonUtils.changeFontToGlobalIfNeeded(this.m_view.headerTxt);
					MenuUtils.truncateMultipartTextfield(this.m_view.headerTxt, param1.player, param1.player2, MenuConstants.PLAYER_MULTIPLAYER_DELIMITER, MenuConstants.PLAYERNAME_MIN_CHAR_COUNT, MenuConstants.FontColorWhite);
					MenuUtils.shrinkTextToFit(this.m_view.headerTxt, this.m_view.headerTxt.width, -1);
				}
				else
				{
					MenuUtils.setupText(this.m_view.headerTxt, param1.player, 60, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
					CommonUtils.changeFontToGlobalIfNeeded(this.m_view.headerTxt);
					MenuUtils.truncateTextfieldWithCharLimit(this.m_view.headerTxt, 1, MenuConstants.PLAYERNAME_MIN_CHAR_COUNT);
					MenuUtils.shrinkTextToFit(this.m_view.headerTxt, this.m_view.headerTxt.width, -1);
				}
			}
			if (!param1.isonline)
			{
				this.m_view.offlineTxt.visible = true;
				MenuUtils.setupText(this.m_view.offlineTxt, Localization.get("UI_DIALOG_SCORE_OFFLINE"), 26, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
				return;
			}
			if (param1.silentAssassin != null)
			{
				_loc7_ = Boolean(param1.silentAssassin);
			}
			else if (param1.MedicineMan != null)
			{
				_loc7_ = Boolean(param1.MedicineMan);
				this.m_silentAssassinIsMedicineMan = true;
			}
			if (param1.PlayStyle != null && !_loc7_)
			{
				_loc6_ = String(param1.PlayStyle.Name);
				_loc5_ = true;
			}
			if (!this.m_isEvergreen && param1.IsNewBestScore != null)
			{
				if (param1.IsNewBestScore)
				{
					this.m_isNewBestScore = true;
					MenuUtils.setupTextUpper(this.m_missionScoreMc.newBestTitle, Localization.get("UI_RATING_NEW_PERSONAL BEST"), 14, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraDark);
					this.showNewBest(this.m_missionScoreMc);
				}
			}
			if (!this.m_isEvergreen && param1.IsNewBestTime != null)
			{
				if (param1.IsNewBestTime)
				{
					this.m_isNewBestTime = true;
					MenuUtils.setupTextUpper(this.m_missionTimeMc.newBestTitle, Localization.get("UI_RATING_NEW_PERSONAL BEST"), 14, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraDark);
					this.showNewBest(this.m_missionTimeMc);
				}
			}
			if (!this.m_isEvergreen && param1.IsNewBestStars != null)
			{
				if (param1.IsNewBestStars)
				{
					this.m_isNewBestRating = true;
					MenuUtils.setupTextUpper(this.m_missionRatingMc.newBestTitle, Localization.get("UI_RATING_NEW_PERSONAL BEST"), 14, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraDark);
					this.showNewBest(this.m_missionRatingMc);
				}
			}
			var _loc8_:int = 5;
			var _loc10_:int = 1;
			while (_loc10_ <= _loc8_)
			{
				_loc9_ = this.m_missionRatingMc.ratingIcons.getChildByName("icon" + _loc10_);
				MenuUtils.setColor(_loc9_, MenuConstants.COLOR_WHITE, true, _loc2_ ? 0.1 : 0);
				_loc10_++;
			}
			if (!this.m_isEvergreen && param1.Percentile != null)
			{
				this.setLeaderboardPositionChart(param1.Percentile);
			}
			if (param1.scoresummary != null)
			{
				this.setMissionTime(param1.scoresummary);
				this.setMissionScore(param1.scoresummary, param1.EvergreenPayout);
				if (this.m_isEvergreen)
				{
					this.setEvergreenDetailedPayout(param1.EvergreenPayoutsCompleted, param1.EvergreenPayoutsFailed, param1.EvergreenIsFailed);
				}
				else
				{
					this.setPreliminaryScore(param1.scoresummary);
				}
			}
			this.m_view.missionSummaryMc.y = this.m_yOffset + 19;
			if (_loc2_ || _loc7_ || _loc5_)
			{
				this.setMissionRating(_loc3_, _loc7_, _loc5_, _loc6_, _loc4_, param1);
			}
		}
		
		private function setMissionRating(param1:int, param2:Boolean, param3:Boolean, param4:String, param5:Boolean, param6:Object):void
		{
			var _loc7_:String = null;
			var _loc8_:int = 0;
			var _loc9_:MovieClip = null;
			var _loc10_:Number = NaN;
			var _loc11_:int = 0;
			var _loc12_:int = 0;
			var _loc13_:String = null;
			var _loc14_:int = 0;
			var _loc15_:Object = null;
			var _loc16_:int = 0;
			if (!this.m_isEvergreen)
			{
				_loc7_ = Localization.get("UI_MENU_MISSION_END_RATING_TITLE");
				MenuUtils.setupTextUpper(this.m_missionRatingMc.ratingTitle, _loc7_, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorRed);
				_loc8_ = 5;
				_loc10_ = 0;
				_loc11_ = 1;
				while (_loc11_ <= _loc8_)
				{
					_loc9_ = this.m_missionRatingMc.ratingIcons.getChildByName("icon" + _loc11_);
					if (this.m_isNewBestRating)
					{
						MenuUtils.setColor(_loc9_, MenuConstants.COLOR_GREY_ULTRA_DARK, false);
					}
					if (_loc11_ <= param1)
					{
						Animate.to(_loc9_, 0.15, _loc10_, {"alpha": 1}, Animate.ExpoOut);
						Animate.addFrom(_loc9_, 0.3, _loc10_, {"scaleX": 1.5, "scaleY": 1.5}, Animate.ExpoOut);
						_loc10_ += 0.05;
					}
					_loc11_++;
				}
			}
			else
			{
				_loc12_ = 0;
				if (Boolean(param6.Challenges) && param6.Challenges.length > 0)
				{
					_loc14_ = 0;
					while (_loc14_ < param6.Challenges.length)
					{
						_loc15_ = param6.Challenges[_loc14_];
						_loc16_ = 0;
						if (_loc15_.XPGain != undefined)
						{
							_loc16_ = int(_loc15_.XPGain);
						}
						if (_loc16_ > 0)
						{
							_loc12_ += _loc16_;
						}
						_loc14_++;
					}
				}
				_loc13_ = Localization.get("EVERGREEN_GAMEFLOW_XPGAINED_TITLE");
				MenuUtils.setupTextUpper(this.m_missionRatingMc.ratingTitle, _loc13_, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorRed);
				MenuUtils.setupText(this.m_missionRatingMc.ratingValue, this.formatXpNumber(_loc12_), 40, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorBlack);
				this.m_missionRatingMc.newBestBg.alpha = 1;
			}
			if (param2)
			{
				this.setSilentAssassin();
			}
			else if (param3)
			{
				this.setPlayStyle(param4);
			}
		}
		
		private function formatXpNumber(param1:int):String
		{
			return MenuUtils.formatNumber(param1) + " " + Localization.get("UI_PERFORMANCE_MASTERY_XP");
		}
		
		private function setLeaderboardPositionChart(param1:Object):void
		{
			param1.Spread.reverse();
			var _loc2_:int = param1.Spread.length - 1 - param1.Index;
			param1.Index = _loc2_;
			var _loc3_:Array = new Array();
			var _loc4_:int = 0;
			while (_loc4_ <= param1.Spread.length - 1)
			{
				_loc3_.push(param1.Spread[_loc4_]);
				_loc4_++;
			}
			_loc3_.sort(Array.NUMERIC);
			var _loc5_:Number = 1 / _loc3_[_loc3_.length - 1];
			this.m_view.leaderboardPosMc.visible = true;
			var _loc6_:int = 0;
			while (_loc6_ <= param1.Spread.length - 1)
			{
				Animate.kill(this.m_view.leaderboardPosMc["barMc_0" + _loc6_]);
				this.m_view.leaderboardPosMc["barMc_0" + _loc6_].scaleY = 0;
				Animate.to(this.m_view.leaderboardPosMc["barMc_0" + _loc6_], 0.3, 0, {"scaleY": param1.Spread[_loc6_] * _loc5_}, Animate.ExpoOut);
				if (_loc6_ == param1.Index)
				{
					MenuUtils.setColor(this.m_view.leaderboardPosMc["barMc_0" + _loc6_], MenuConstants.COLOR_RED, false);
				}
				_loc6_++;
			}
		}
		
		private function setMissionTime(param1:Array):void
		{
			var _loc4_:String = null;
			var _loc5_:int = 0;
			var _loc2_:String = Localization.get("UI_MENU_MISSION_END_TIME_TITLE");
			var _loc3_:String = "";
			if (param1 != null)
			{
				_loc5_ = 0;
				while (_loc5_ < param1.length)
				{
					if (param1[_loc5_].type == "summary" && (param1[_loc5_].headline == "UI_SCORING_SUMMARY_TIME" || param1[_loc5_].headline == "UI_SNIPERSCORING_SUMMARY_TIME_BONUS"))
					{
						_loc3_ = String(param1[_loc5_].count);
					}
					_loc5_++;
				}
			}
			MenuUtils.setupTextUpper(this.m_missionTimeMc.timeTitle, _loc2_, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorRed);
			if (this.m_isEvergreen)
			{
				_loc4_ = MenuConstants.FontColorBlack;
			}
			else if (this.m_isNewBestTime)
			{
				_loc4_ = MenuConstants.FontColorGreyUltraDark;
			}
			else
			{
				_loc4_ = MenuConstants.FontColorWhite;
			}
			MenuUtils.setupText(this.m_missionTimeMc.timeValue, _loc3_, 40, MenuConstants.FONT_TYPE_MEDIUM, _loc4_);
			CommonUtils.changeFontToGlobalFont(this.m_missionTimeMc.timeValue);
			this.m_missionTimeMc.visible = true;
			if (this.m_isEvergreen)
			{
				this.m_missionTimeMc.newBestBg.alpha = 1;
			}
		}
		
		private function setMissionScore(param1:Array, param2:Number):void
		{
			var _loc3_:String = null;
			var _loc4_:int = 0;
			var _loc5_:int = 0;
			var _loc6_:String = null;
			var _loc7_:String = null;
			if (!this.m_isEvergreen)
			{
				_loc3_ = Localization.get("UI_MENU_MISSION_END_SCORE_TITLE");
				_loc4_ = 0;
				if (param1 != null)
				{
					_loc5_ = 0;
					while (_loc5_ < param1.length)
					{
						if (param1[_loc5_].type == "total")
						{
							_loc4_ = int(param1[_loc5_].scoreTotal);
						}
						_loc5_++;
					}
				}
				MenuUtils.setupTextUpper(this.m_missionScoreMc.scoreTitle, _loc3_, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorRed);
				MenuUtils.setupText(this.m_missionScoreMc.scoreValue, MenuUtils.formatNumber(_loc4_), 40, MenuConstants.FONT_TYPE_MEDIUM, this.m_isNewBestScore ? MenuConstants.FontColorGreyUltraDark : MenuConstants.FontColorWhite);
			}
			else
			{
				param2 = !!param2 ? param2 : 0;
				if (param2 < 0)
				{
					_loc6_ = Localization.get("EVERGREEN_GAMEFLOW_MISSIONPAYOUT_LOST_TITLE");
					MenuUtils.setupTextUpper(this.m_missionScoreMc.scoreTitle, _loc6_, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
					_loc7_ = MenuUtils.formatNumber(param2) + Localization.get("UI_EVERGREEN_MERCES");
					MenuUtils.setupText(this.m_missionScoreMc.scoreValue, _loc7_, 40, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
					this.m_missionScoreMc.newBestBg.alpha = 0;
					this.m_missionScoreMc.newBestBgNegative.alpha = 1;
				}
				else
				{
					_loc6_ = Localization.get("EVERGREEN_GAMEFLOW_MISSIONPAYOUT_TITLE");
					MenuUtils.setupTextUpper(this.m_missionScoreMc.scoreTitle, _loc6_, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorRed);
					_loc7_ = MenuUtils.formatNumber(param2) + Localization.get("UI_EVERGREEN_MERCES");
					MenuUtils.setupText(this.m_missionScoreMc.scoreValue, _loc7_, 40, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorBlack);
					this.m_missionScoreMc.newBestBg.alpha = 1;
					this.m_missionScoreMc.newBestBgNegative.alpha = 0;
				}
			}
		}
		
		private function setPreliminaryScore(param1:Array):void
		{
			var _loc4_:ScoreListElementView = null;
			this.addDottedLine(0, 0, this.m_view.preliminaryScoreMc);
			this.addDottedLine(0, 32, this.m_view.preliminaryScoreMc);
			var _loc2_:Number = 250;
			var _loc3_:Number = 0;
			MenuUtils.setupTextUpper(this.m_view.preliminaryScoreMc.headerTxt, Localization.get("UI_SNIPERSCORING_SUMMARY_PRELIMINARY"), 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			this.m_view.preliminaryScoreMc.headerTxt.y = _loc3_ + 5;
			var _loc5_:int = 0;
			while (_loc5_ < param1.length)
			{
				if (param1[_loc5_].type == "summary")
				{
					(_loc4_ = new ScoreListElementView()).x = _loc2_;
					_loc4_.y = _loc3_ + 4;
					MenuUtils.setupText(_loc4_.titleTxt, Localization.get(param1[_loc5_].headline), 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
					MenuUtils.setupText(_loc4_.valueTxt, MenuUtils.formatNumber(param1[_loc5_].scoreTotal), 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
					this.m_view.preliminaryScoreMc.addChild(_loc4_);
					_loc3_ += 32;
				}
				_loc5_++;
			}
			_loc3_ += 14;
			this.addDottedLine(0, _loc3_, this.m_view.preliminaryScoreMc);
			this.m_yOffset += _loc3_;
		}
		
		private function setEvergreenDetailedPayout(param1:Array, param2:Array, param3:Boolean):void
		{
			var _loc9_:String = null;
			this.addDottedLine(0, 0, this.m_view.preliminaryScoreMc);
			this.addDottedLine(0, 32, this.m_view.preliminaryScoreMc);
			var _loc4_:Number = 250;
			var _loc5_:Number = 0;
			MenuUtils.setupTextUpper(this.m_view.preliminaryScoreMc.headerTxt, Localization.get("UI_MENU_MISSION_END_DETAILS_EVERGREEN_MERCES_EARNED"), 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			this.m_view.preliminaryScoreMc.headerTxt.y = _loc5_ + 5;
			var _loc6_:ScoreListElementView;
			(_loc6_ = new ScoreListElementView()).x = _loc4_;
			_loc6_.y = _loc5_ + 4;
			MenuUtils.setupText(_loc6_.titleTxt, Localization.get("UI_MENU_MISSION_END_DETAILS_EVERGREEN_OBJECTIVE").toUpperCase(), 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			MenuUtils.setupText(_loc6_.valueTxt, Localization.get("UI_MENU_MISSION_END_DETAILS_EVERGREEN_AMOUNT").toUpperCase(), 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			this.m_view.preliminaryScoreMc.addChild(_loc6_);
			_loc5_ += 32;
			var _loc7_:int = 0;
			while (_loc7_ < param1.length)
			{
				(_loc6_ = new ScoreListElementView()).x = _loc4_;
				_loc6_.y = _loc5_ + 4;
				_loc9_ = param3 ? MenuConstants.FontColorRed : MenuConstants.FontColorWhite;
				MenuUtils.setupText(_loc6_.titleTxt, Localization.get(param1[_loc7_].Name), 16, MenuConstants.FONT_TYPE_MEDIUM, _loc9_);
				MenuUtils.setupText(_loc6_.valueTxt, MenuUtils.formatNumber(param1[_loc7_].Payout) + Localization.get("UI_EVERGREEN_MERCES"), 16, MenuConstants.FONT_TYPE_MEDIUM, _loc9_);
				this.m_view.preliminaryScoreMc.addChild(_loc6_);
				_loc5_ += 32;
				_loc7_++;
			}
			var _loc8_:int = 0;
			while (_loc8_ < param2.length)
			{
				(_loc6_ = new ScoreListElementView()).x = _loc4_;
				_loc6_.y = _loc5_ + 4;
				MenuUtils.setupText(_loc6_.titleTxt, Localization.get(param2[_loc8_].Name), 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorRed);
				MenuUtils.setupText(_loc6_.valueTxt, MenuUtils.formatNumber(param2[_loc8_].Payout) + Localization.get("UI_EVERGREEN_MERCES"), 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorRed);
				this.m_view.preliminaryScoreMc.addChild(_loc6_);
				_loc5_ += 32;
				_loc8_++;
			}
			_loc5_ += 14;
			this.addDottedLine(0, _loc5_, this.m_view.preliminaryScoreMc);
			this.m_yOffset += _loc5_;
		}
		
		private function setSilentAssassin():void
		{
			if (this.m_silentAssassinIsMedicineMan)
			{
				MenuUtils.setupTextUpper(this.m_view.silentAssassinMc.title, Localization.get("UI_RATING_MEDICINE_MAN").toUpperCase(), 28, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
				MenuUtils.setColor(this.m_view.silentAssassinMc.bg, MenuConstants.COLOR_BLUE);
			}
			else
			{
				MenuUtils.setupTextUpper(this.m_view.silentAssassinMc.title, Localization.get("UI_RATING_SILENT_ASSASSIN").toUpperCase(), 28, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
				MenuUtils.setColor(this.m_view.silentAssassinMc.bg, MenuConstants.COLOR_RED);
			}
			this.m_view.silentAssassinMc.visible = true;
		}
		
		private function setPlayStyle(param1:String):void
		{
			MenuUtils.setupTextAndShrinkToFitUpper(this.m_view.playStyleMc.title, param1, 28, MenuConstants.FONT_TYPE_MEDIUM, this.m_view.playStyleMc.title.width, -1, 15, MenuConstants.FontColorGreyUltraDark);
			this.m_view.playStyleMc.visible = true;
		}
		
		private function showNewBest(param1:MovieClip):void
		{
			param1.newBestFx.height = param1.newBestBg.height = 82 + (param1.newBestTitle.numLines - 1) * 18;
			param1.newBestFx.y = 49.5 + param1.newBestTitle.numLines * 18 / 2;
			param1.newBestTitle.alpha = 1;
			param1.newBestBg.alpha = 1;
			this.offsetMissionSummary(param1);
			this.tintNewBest(param1);
			this.hideMissionSummaryLines(param1);
		}
		
		private function tintNewBest(param1:MovieClip):void
		{
			var _loc2_:int = 0;
			var _loc3_:MovieClip = null;
			if (param1 == this.m_missionRatingMc)
			{
				_loc2_ = 1;
				while (_loc2_ <= 5)
				{
					_loc3_ = this.m_missionRatingMc.ratingIcons.getChildByName("icon" + _loc2_);
					MenuUtils.setColor(_loc3_, MenuConstants.COLOR_GREY_ULTRA_DARK, false);
					_loc2_++;
				}
			}
			if (param1 == this.m_missionTimeMc)
			{
				MenuUtils.setupText(this.m_missionTimeMc.timeValue, this.m_missionTimeMc.timeValue.text, 40, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraDark);
				CommonUtils.changeFontToGlobalFont(this.m_missionTimeMc.timeValue);
			}
			if (param1 == this.m_missionScoreMc)
			{
				MenuUtils.setupText(this.m_missionScoreMc.scoreValue, this.m_missionScoreMc.scoreValue.text, 40, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraDark);
			}
		}
		
		private function hideMissionSummaryLines(param1:MovieClip):void
		{
			if (param1 == this.m_missionRatingMc)
			{
				this.m_view.missionSummaryMc.lineMc_01.alpha = this.m_view.missionSummaryMc.lineMc_02.alpha = 0;
			}
			if (param1 == this.m_missionTimeMc)
			{
				this.m_view.missionSummaryMc.lineMc_02.alpha = this.m_view.missionSummaryMc.lineMc_03.alpha = 0;
			}
			if (param1 == this.m_missionScoreMc)
			{
				this.m_view.missionSummaryMc.lineMc_03.alpha = this.m_view.missionSummaryMc.lineMc_04.alpha = 0;
			}
		}
		
		private function offsetMissionSummary(param1:MovieClip):void
		{
			param1.y = param1.newBestTitle.numLines == 1 ? -9 : -18;
		}
		
		private function formatNewBestTextFields(param1:MovieClip):void
		{
			param1.newBestTitle.alpha = 0;
			param1.newBestFx.alpha = 0;
			param1.newBestBg.alpha = 0;
			param1.newBestTitle.autoSize = "left";
			param1.newBestTitle.multiline = true;
			param1.newBestTitle.wordWrap = true;
			param1.newBestTitle.width = 220;
		}
		
		private function addDottedLine(param1:int, param2:int, param3:MovieClip):void
		{
			var _loc4_:DottedLine;
			(_loc4_ = new DottedLine(this.m_view.tileBg.width - this.EDGE_PADDING * 2, MenuConstants.COLOR_WHITE, DottedLine.TYPE_HORIZONTAL, 1, 2)).x = param1;
			_loc4_.y = param2;
			param3.addChild(_loc4_);
		}
		
		private function killAnimations():void
		{
			var _loc1_:int = 1;
			while (_loc1_ <= 5)
			{
				Animate.kill(this.m_missionRatingMc.ratingIcons.getChildByName("icon" + _loc1_));
				_loc1_++;
			}
			var _loc2_:int = 0;
			while (_loc2_ <= 9)
			{
				Animate.kill(this.m_view.leaderboardPosMc["barMc_0" + _loc2_]);
				_loc2_++;
			}
		}
		
		private function playSound(param1:String):void
		{
			ExternalInterface.call("PlaySound", param1);
		}
		
		override public function getView():Sprite
		{
			return this.m_view.tileBg;
		}
		
		override public function onUnregister():void
		{
			if (this.m_view)
			{
				this.killAnimations();
				removeChild(this.m_view);
				this.m_view = null;
			}
		}
	}
}
