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
   
   public dynamic class DetailedScoreTileSniper extends MenuElementTileBase
   {
       
      
      private const EDGE_PADDING:Number = 10;
      
      private var m_view:DetailedScoreTileSniperView;
      
      private var m_yOffset:int;
      
      private var m_missionRatingMc:MovieClip;
      
      private var m_missionTimeMc:MovieClip;
      
      private var m_missionScoreMc:MovieClip;
      
      private var m_isNewBestScore:Boolean = false;
      
      private var m_isNewBestTime:Boolean = false;
      
      private var m_isNewBestRating:Boolean = false;
      
      private var m_totalChallengesMultiplier:Number;
      
      public function DetailedScoreTileSniper(param1:Object)
      {
         super(param1);
         m_mouseMode = MouseUtil.MODE_ONOVER_SELECT_ONUP_CLICK;
         this.m_view = new DetailedScoreTileSniperView();
         this.m_view.y = -64;
         this.m_view.tileBg.alpha = 0;
         this.m_missionRatingMc = this.m_view.missionSummaryMc.missionRatingMc;
         this.m_missionTimeMc = this.m_view.missionSummaryMc.missionTimeMc;
         this.m_missionScoreMc = this.m_view.missionSummaryMc.missionScoreMc;
         var _loc2_:* = !ControlsMain.isVrModeActive();
         this.m_missionRatingMc.newBestFx.visible = _loc2_;
         this.m_missionTimeMc.newBestFx.visible = _loc2_;
         this.m_missionScoreMc.newBestFx.visible = _loc2_;
         this.m_missionRatingMc.ratingIcons.visible = false;
         this.m_view.missionSummaryMc.lineMc_01.alpha = this.m_view.missionSummaryMc.lineMc_02.alpha = this.m_view.missionSummaryMc.lineMc_03.alpha = this.m_view.missionSummaryMc.lineMc_04.alpha = 1;
         this.m_view.offlineTxt.visible = false;
         this.m_view.silentAssassinMc.visible = this.m_view.playStyleMc.visible = this.m_view.leaderboardPosMc.visible = false;
         this.formatNewBestTextFields(this.m_missionRatingMc);
         this.formatNewBestTextFields(this.m_missionTimeMc);
         this.formatNewBestTextFields(this.m_missionScoreMc);
         MenuUtils.setupTextUpper(this.m_view.leaderboardPosMc.lowTxt,Localization.get("UI_MENU_PAGE_DEBRIEFING_LEADERBOARDS_BOTTOM"),14,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorGreyLight);
         MenuUtils.setupTextUpper(this.m_view.leaderboardPosMc.titleTxt,Localization.get("UI_MENU_PAGE_DEBRIEFING_LEADERBOARDS_POSITION"),14,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorGreyLight);
         MenuUtils.setupTextUpper(this.m_view.leaderboardPosMc.highTxt,Localization.get("UI_MENU_PAGE_DEBRIEFING_LEADERBOARDS_TOP"),14,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorGreyLight);
         addChild(this.m_view);
      }
      
      override public function onSetData(param1:Object) : void
      {
         super.onSetData(param1);
         this.playSound("ui_debrief_detailsscreen_open");
         this.m_yOffset = param1.Percentile != null ? 395 : 153;
         this.m_view.preliminaryScoreMc.y = this.m_yOffset;
         if(param1.player != undefined)
         {
            if(param1.player2 != undefined)
            {
               MenuUtils.setupText(this.m_view.headerTxt,param1.player + MenuConstants.PLAYER_MULTIPLAYER_DELIMITER + param1.player2,60,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
               CommonUtils.changeFontToGlobalIfNeeded(this.m_view.headerTxt);
               MenuUtils.truncateMultipartTextfield(this.m_view.headerTxt,param1.player,param1.player2,MenuConstants.PLAYER_MULTIPLAYER_DELIMITER,MenuConstants.PLAYERNAME_MIN_CHAR_COUNT,MenuConstants.FontColorWhite);
               MenuUtils.shrinkTextToFit(this.m_view.headerTxt,this.m_view.headerTxt.width,-1);
            }
            else
            {
               MenuUtils.setupText(this.m_view.headerTxt,param1.player,60,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
               CommonUtils.changeFontToGlobalIfNeeded(this.m_view.headerTxt);
               MenuUtils.truncateTextfield(this.m_view.headerTxt,1,MenuConstants.FontColorWhite);
            }
         }
         if(!param1.isonline)
         {
            this.m_view.offlineTxt.visible = true;
            MenuUtils.setupText(this.m_view.offlineTxt,Localization.get("UI_DIALOG_SCORE_OFFLINE"),26,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
            return;
         }
         if(param1.isloading)
         {
            return;
         }
         var _loc2_:SniperScoreObject = new SniperScoreObject(Localization.get("UI_SNIPERSCORING_SUMMARY_BASESCORE"),param1.SniperChallengeScore.BaseScore);
         var _loc3_:SniperScoreObject = new SniperScoreObject(Localization.get("UI_SNIPERSCORING_SUMMARY_TIME_BONUS") + "  |  " + MenuUtils.getTimeString(param1.SniperChallengeScore.TimeTaken),param1.SniperChallengeScore.TimeBonus);
         var _loc4_:SniperScoreObject = new SniperScoreObject(Localization.get("UI_SNIPERSCORING_SUMMARY_SILENT_ASSASIN_BONUS"),param1.SniperChallengeScore.SilentAssassinBonus);
         var _loc5_:SniperScoreObject = new SniperScoreObject(Localization.get("UI_SNIPERSCORING_SUMMARY_SUBTOTAL"),Math.max(param1.SniperChallengeScore.BaseScore + param1.SniperChallengeScore.BulletsMissedPenalty + param1.SniperChallengeScore.TimeBonus + param1.SniperChallengeScore.SilentAssassinBonus,0));
         var _loc6_:SniperScoreObject = new SniperScoreObject(Localization.get("UI_SNIPERSCORING_SUMMARY_CHALLENGE_MULTIPLIER"),param1.SniperChallengeScore.TotalChallengeMultiplier);
         var _loc7_:SniperScoreObject = new SniperScoreObject(Localization.get("UI_SNIPERSCORING_SUMMARY_SILENT_ASSASIN_MULTIPLIER"),param1.SniperChallengeScore.SilentAssassinMultiplier);
         this.setPreliminaryScore(Vector.<SniperScoreObject>([_loc2_,_loc3_,_loc4_,_loc5_]));
         this.setMultiplierScore(Vector.<SniperScoreObject>([_loc6_,_loc7_]));
         this.m_view.missionSummaryMc.y = this.m_yOffset + 19;
         this.setMissionRating(param1.SniperChallengeScore.TotalChallengeMultiplier);
         this.setMissionTime(param1.SniperChallengeScore.TimeTaken);
         this.setMissionScore(param1.SniperChallengeScore.FinalScore);
         if(param1.IsNewBestScore != null)
         {
            if(param1.IsNewBestScore)
            {
               this.m_isNewBestScore = true;
               MenuUtils.setupTextUpper(this.m_missionScoreMc.newBestTitle,Localization.get("UI_RATING_NEW_PERSONAL BEST"),14,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorGreyUltraDark);
               this.showNewBest(this.m_missionScoreMc);
            }
         }
         if(param1.IsNewBestTime != null)
         {
            if(param1.IsNewBestTime)
            {
               this.m_isNewBestTime = true;
               MenuUtils.setupTextUpper(this.m_missionTimeMc.newBestTitle,Localization.get("UI_RATING_NEW_PERSONAL BEST"),14,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorGreyUltraDark);
               this.showNewBest(this.m_missionTimeMc);
            }
         }
         if(param1.IsNewBestStars != null)
         {
            if(param1.IsNewBestStars)
            {
               this.m_isNewBestRating = true;
               MenuUtils.setupTextUpper(this.m_missionRatingMc.newBestTitle,Localization.get("UI_RATING_NEW_PERSONAL BEST"),14,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorGreyUltraDark);
               this.showNewBest(this.m_missionRatingMc);
            }
         }
         if(param1.Percentile != null)
         {
            this.setLeaderboardPositionChart(param1.Percentile);
         }
         if(param1.SniperChallengeScore.SilentAssassin != null && param1.SniperChallengeScore.SilentAssassin == true)
         {
            this.setSilentAssassin();
         }
         else if(param1.SniperChallengeScore.PlayStyle != null)
         {
            this.setPlayStyle(param1.SniperChallengeScore.PlayStyle.Name);
         }
      }
      
      private function setLeaderboardPositionChart(param1:Object) : void
      {
         param1.Spread.reverse();
         var _loc2_:int = param1.Spread.length - 1 - param1.Index;
         param1.Index = _loc2_;
         var _loc3_:Array = new Array();
         var _loc4_:int = 0;
         while(_loc4_ <= param1.Spread.length - 1)
         {
            _loc3_.push(param1.Spread[_loc4_]);
            _loc4_++;
         }
         _loc3_.sort(Array.NUMERIC);
         var _loc5_:Number = 1 / _loc3_[_loc3_.length - 1];
         this.m_view.leaderboardPosMc.visible = true;
         var _loc6_:int = 0;
         while(_loc6_ <= param1.Spread.length - 1)
         {
            Animate.kill(this.m_view.leaderboardPosMc["barMc_0" + _loc6_]);
            this.m_view.leaderboardPosMc["barMc_0" + _loc6_].scaleY = 0;
            Animate.to(this.m_view.leaderboardPosMc["barMc_0" + _loc6_],0.3,0,{"scaleY":param1.Spread[_loc6_] * _loc5_},Animate.ExpoOut);
            if(_loc6_ == param1.Index)
            {
               MenuUtils.setColor(this.m_view.leaderboardPosMc["barMc_0" + _loc6_],MenuConstants.COLOR_RED,false);
            }
            _loc6_++;
         }
      }
      
      private function setMissionRating(param1:Number) : void
      {
         MenuUtils.setupTextAndShrinkToFitUpper(this.m_missionRatingMc.ratingTitle,Localization.get("UI_SNIPERSCORING_SUMMARY_MULTIPLIER"),18,MenuConstants.FONT_TYPE_MEDIUM,this.m_missionRatingMc.ratingTitle.width,-1,15,MenuConstants.FontColorRed);
         this.m_totalChallengesMultiplier = param1;
         MenuUtils.setupText(this.m_missionRatingMc.ratingValue,param1.toFixed(2),40,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         this.m_missionRatingMc.visible = true;
      }
      
      private function setMissionTime(param1:Number) : void
      {
         MenuUtils.setupTextUpper(this.m_missionTimeMc.timeTitle,Localization.get("UI_MENU_MISSION_END_TIME_TITLE"),18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorRed);
         MenuUtils.setupTextAndShrinkToFit(this.m_missionTimeMc.timeValue,MenuUtils.getTimeString(param1),40,MenuConstants.FONT_TYPE_MEDIUM,this.m_missionTimeMc.timeValue.width,-1,30,MenuConstants.FontColorWhite);
         CommonUtils.changeFontToGlobalFont(this.m_missionTimeMc.timeValue);
         this.m_missionTimeMc.visible = true;
      }
      
      private function setMissionScore(param1:Number) : void
      {
         MenuUtils.setupTextUpper(this.m_missionScoreMc.scoreTitle,Localization.get("UI_MENU_MISSION_END_SCORE_TITLE"),18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorRed);
         MenuUtils.setupText(this.m_missionScoreMc.scoreValue,MenuUtils.formatNumber(param1),40,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         this.m_missionScoreMc.visible = true;
      }
      
      private function setPreliminaryScore(param1:Vector.<SniperScoreObject>) : void
      {
         var _loc4_:ScoreListElementView = null;
         this.addDottedLine(0,0,this.m_view.preliminaryScoreMc);
         this.addDottedLine(0,32,this.m_view.preliminaryScoreMc);
         var _loc2_:Number = 250;
         var _loc3_:Number = 0;
         MenuUtils.setupTextUpper(this.m_view.preliminaryScoreMc.headerTxt,Localization.get("UI_SNIPERSCORING_SUMMARY_PRELIMINARY"),16,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         this.m_view.preliminaryScoreMc.headerTxt.y = _loc3_ + 5;
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            (_loc4_ = new ScoreListElementView()).x = _loc2_;
            _loc4_.y = _loc3_ + 4;
            MenuUtils.setupText(_loc4_.titleTxt,param1[_loc5_].header,16,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
            MenuUtils.setupText(_loc4_.valueTxt,MenuUtils.formatNumber(param1[_loc5_].value),16,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
            this.m_view.preliminaryScoreMc.addChild(_loc4_);
            _loc3_ += 32;
            _loc5_++;
         }
         _loc3_ += 14;
         this.m_yOffset += _loc3_;
      }
      
      private function setMultiplierScore(param1:Vector.<SniperScoreObject>) : void
      {
         var _loc4_:ScoreListElementView = null;
         this.m_view.multipliersScoreMc.y = this.m_view.preliminaryScoreMc.y + this.m_view.preliminaryScoreMc.height + this.EDGE_PADDING * 2;
         this.addDottedLine(0,0,this.m_view.multipliersScoreMc);
         this.addDottedLine(0,32,this.m_view.multipliersScoreMc);
         var _loc2_:Number = 250;
         var _loc3_:Number = 0;
         MenuUtils.setupTextUpper(this.m_view.multipliersScoreMc.headerTxt,Localization.get("UI_SNIPERSCORING_SUMMARY_MULTIPLIERS"),16,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         this.m_view.multipliersScoreMc.headerTxt.y = _loc3_ + 5;
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            (_loc4_ = new ScoreListElementView()).x = _loc2_;
            _loc4_.y = _loc3_ + 4;
            MenuUtils.setupText(_loc4_.titleTxt,param1[_loc5_].header,16,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
            MenuUtils.setupText(_loc4_.valueTxt,param1[_loc5_].value.toFixed(2),16,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
            this.m_view.multipliersScoreMc.addChild(_loc4_);
            _loc3_ += 32;
            _loc5_++;
         }
         _loc3_ += 14;
         this.addDottedLine(0,_loc3_,this.m_view.multipliersScoreMc);
         this.m_yOffset += _loc3_;
      }
      
      private function setSilentAssassin() : void
      {
         MenuUtils.setupTextUpper(this.m_view.silentAssassinMc.title,Localization.get("UI_RATING_SILENT_ASSASSIN").toUpperCase(),28,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         MenuUtils.setColor(this.m_view.silentAssassinMc.bg,MenuConstants.COLOR_RED);
         this.m_view.silentAssassinMc.visible = true;
      }
      
      private function setPlayStyle(param1:String) : void
      {
         MenuUtils.setupTextAndShrinkToFitUpper(this.m_view.playStyleMc.title,param1,28,MenuConstants.FONT_TYPE_MEDIUM,this.m_view.playStyleMc.title.width,-1,15,MenuConstants.FontColorGreyUltraDark);
         this.m_view.playStyleMc.visible = true;
      }
      
      private function showNewBest(param1:MovieClip) : void
      {
         param1.newBestFx.height = param1.newBestBg.height = 82 + (param1.newBestTitle.numLines - 1) * 18;
         param1.newBestFx.y = 49.5 + param1.newBestTitle.numLines * 18 / 2;
         param1.newBestTitle.alpha = 1;
         param1.newBestBg.alpha = 1;
         this.offsetMissionSummary(param1);
         this.tintNewBest(param1);
         this.hideMissionSummaryLines(param1);
      }
      
      private function tintNewBest(param1:MovieClip) : void
      {
         if(param1 == this.m_missionRatingMc)
         {
            MenuUtils.setupText(this.m_missionRatingMc.ratingValue,this.m_totalChallengesMultiplier.toFixed(2),40,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorGreyUltraDark);
         }
         if(param1 == this.m_missionTimeMc)
         {
            MenuUtils.setupText(this.m_missionTimeMc.timeValue,this.m_missionTimeMc.timeValue.text,40,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorGreyUltraDark);
            CommonUtils.changeFontToGlobalFont(this.m_missionTimeMc.timeValue);
         }
         if(param1 == this.m_missionScoreMc)
         {
            MenuUtils.setupText(this.m_missionScoreMc.scoreValue,this.m_missionScoreMc.scoreValue.text,40,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorGreyUltraDark);
         }
      }
      
      private function hideMissionSummaryLines(param1:MovieClip) : void
      {
         if(param1 == this.m_missionRatingMc)
         {
            this.m_view.missionSummaryMc.lineMc_01.alpha = this.m_view.missionSummaryMc.lineMc_02.alpha = 0;
         }
         if(param1 == this.m_missionTimeMc)
         {
            this.m_view.missionSummaryMc.lineMc_02.alpha = this.m_view.missionSummaryMc.lineMc_03.alpha = 0;
         }
         if(param1 == this.m_missionScoreMc)
         {
            this.m_view.missionSummaryMc.lineMc_03.alpha = this.m_view.missionSummaryMc.lineMc_04.alpha = 0;
         }
      }
      
      private function offsetMissionSummary(param1:MovieClip) : void
      {
         param1.y = param1.newBestTitle.numLines == 1 ? -9 : -18;
      }
      
      private function formatNewBestTextFields(param1:MovieClip) : void
      {
         param1.newBestTitle.alpha = 0;
         param1.newBestFx.alpha = 0;
         param1.newBestBg.alpha = 0;
         param1.newBestTitle.autoSize = "left";
         param1.newBestTitle.multiline = true;
         param1.newBestTitle.wordWrap = true;
         param1.newBestTitle.width = 220;
      }
      
      private function addDottedLine(param1:int, param2:int, param3:MovieClip) : void
      {
         var _loc4_:DottedLine;
         (_loc4_ = new DottedLine(this.m_view.tileBg.width - this.EDGE_PADDING * 2,MenuConstants.COLOR_WHITE,DottedLine.TYPE_HORIZONTAL,1,2)).x = param1;
         _loc4_.y = param2;
         param3.addChild(_loc4_);
      }
      
      private function killAnimations() : void
      {
         var _loc1_:int = 1;
         while(_loc1_ <= 5)
         {
            Animate.kill(this.m_missionRatingMc.ratingIcons.getChildByName("icon" + _loc1_));
            _loc1_++;
         }
         var _loc2_:int = 0;
         while(_loc2_ <= 9)
         {
            Animate.kill(this.m_view.leaderboardPosMc["barMc_0" + _loc2_]);
            _loc2_++;
         }
      }
      
      private function playSound(param1:String) : void
      {
         ExternalInterface.call("PlaySound",param1);
      }
      
      override public function getView() : Sprite
      {
         return this.m_view.tileBg;
      }
      
      override public function onUnregister() : void
      {
         if(this.m_view)
         {
            this.killAnimations();
            removeChild(this.m_view);
            this.m_view = null;
         }
      }
   }
}

class SniperScoreObject
{
    
   
   public var header:String;
   
   public var value:Number;
   
   public function SniperScoreObject(param1:String, param2:Number)
   {
      super();
      this.header = param1;
      this.value = param2;
   }
}
