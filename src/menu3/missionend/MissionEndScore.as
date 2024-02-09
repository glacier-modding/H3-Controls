package menu3.missionend
{
   import basic.DottedLine;
   import common.Animate;
   import common.CommonUtils;
   import common.Localization;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.external.ExternalInterface;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.getTimer;
   import hud.evergreen.CampaignProgress;
   import menu3.MenuElementBase;
   import menu3.basic.Badge;
   
   public dynamic class MissionEndScore extends MenuElementBase
   {
       
      
      private const VIEW_WIDTH:Number = 680;
      
      private const ANIMATE_REWARD_DURATION:Number = 0.8;
      
      private const ANIMATE_UNLOCKABLE_MASTERY_DURATION:Number = 2;
      
      private const BADGE_MAX_SIZE:Number = 370;
      
      private const SOUND_ID_SILENT_ASSASSIN:String = "SilentAssassinScore";
      
      private const SOUND_ID_SCORE_RATING:String = "ScoreRating";
      
      private const SOUND_ID_LEVEL_UP:String = "LevelUp";
      
      private var m_view:MissionEndScoreView;
      
      private var m_dottedLineContainer:Sprite;
      
      private var m_dottedLineProfileMastery:DottedLine;
      
      private var m_dottedLineUnlockableMastery:DottedLine;
      
      private var m_dottedLineLeaderBoard:DottedLine;
      
      private var m_dottedLineMissionSummary:DottedLine;
      
      private var m_dottedLinePlayerName:DottedLine;
      
      private var m_separatorVersusWinnerTop:DottedLine;
      
      private var m_separatorVersusWinnerBottom:DottedLine;
      
      private var m_badge:Badge = null;
      
      private var m_playerBadgeMc:MovieClip;
      
      private var m_playerLevelMc:MovieClip;
      
      private var m_playerNameMc:MovieClip;
      
      private var m_profileMasteryMc:MovieClip;
      
      private var m_unlockableMasteryMc:MovieClip;
      
      private var m_silentAssassinMc:MovieClip;
      
      private var m_playStyleMc:MovieClip;
      
      private var m_missionRatingMc:MovieClip;
      
      private var m_missionTimeMc:MovieClip;
      
      private var m_missionScoreMc:MovieClip;
      
      private var m_leaderboardMc:MovieClip;
      
      private var m_locationCompletionMc:MovieClip;
      
      private var m_evergreenCampaignView:CampaignProgress;
      
      private var m_isEvergreen:Boolean = false;
      
      private var m_evergreenEndState:String = "";
      
      private var m_isSniper:Boolean = false;
      
      private var m_isOnline:Boolean = false;
      
      private var m_useAnimation:Boolean = true;
      
      private var m_evergreenAnimation:Boolean = false;
      
      private var m_animationStarted:Boolean = false;
      
      private var m_isVersus:Boolean = false;
      
      private var m_isWinner:Boolean = false;
      
      private var m_isWinnerMsg:String = "";
      
      private var m_hasLeaderboard:Boolean = false;
      
      private var m_showRating:Boolean = true;
      
      private var m_ratingScore:Number = 0;
      
      private var m_isSilentAssassin:Boolean = false;
      
      private var m_hasChallengeMultiplier:Boolean = false;
      
      private var m_hasPlayStyle:Boolean = false;
      
      private var m_playStyleSoundId:String;
      
      private var m_isNewBestScore:Boolean = false;
      
      private var m_isNewBestTime:Boolean = false;
      
      private var m_isNewBestRating:Boolean = false;
      
      private var m_profileLevelInfo:LevelInfo;
      
      private var m_locationLevelInfo:LevelInfo;
      
      private var m_sniperUnlockableLevelInfo:LevelInfo;
      
      private var m_actionXPGain:int = 0;
      
      private var m_challengeXPGain:int = 0;
      
      private var m_profileBarValues:BarValues;
      
      private var m_unlockableBarValues:BarValues = null;
      
      private var m_unlockableMaxLevel:int = 1;
      
      private var m_unlockableMasteryIsLocation:Boolean = false;
      
      private var m_barRewards:Array;
      
      private var m_barViews:Array;
      
      private var m_barViewsProgress:Array;
      
      private var m_infoTxtOriginalPosX:Number = 0;
      
      private var m_profileBarOriginalScale:Number = 1;
      
      private var m_unlockableBarOriginalScale:Number = 1;
      
      private var m_opportunityCountGain:int = 0;
      
      private var m_challengeCountGain:int = 0;
      
      private var m_hideLocationProgression:Boolean = true;
      
      private var m_isUnlockableMasteryVisible:Boolean = false;
      
      private var m_animateBarStartXp:Number = 0;
      
      private var m_animateBarStartXpUnlockable:Number = 0;
      
      private var m_newBestDelaySprite:Sprite;
      
      private var m_playstyleDelaySprite:Sprite;
      
      private var m_tickSoundStarted:Boolean;
      
      private var m_xpAnimatedValue:Number = 0;
      
      private var m_xpAnimatedTime:int = 0;
      
      private var m_xpTotal:Number = 0;
      
      private var m_timeAnimatedValue:Number = 0;
      
      private var m_timeAnimatedTime:int = 0;
      
      private var m_timeTotal:Number = 0;
      
      private var m_payoutAnimatedValue:Number = 0;
      
      private var m_payoutAnimatedTime:int = 0;
      
      private var m_payoutTotal:Number = 0;
      
      public function MissionEndScore(param1:Object)
      {
         this.m_barRewards = [];
         this.m_barViews = [];
         this.m_barViewsProgress = [];
         this.m_newBestDelaySprite = new Sprite();
         this.m_playstyleDelaySprite = new Sprite();
         super(param1);
         this.m_view = new MissionEndScoreView();
         addChild(this.m_view);
         this.m_view.offlineTxt.visible = false;
         this.m_evergreenCampaignView = new CampaignProgress();
         this.m_playerBadgeMc = this.m_view.playerBadgeMc;
         this.m_playerLevelMc = this.m_view.playerLevelMc;
         this.m_playerNameMc = this.m_view.playerNameMc;
         this.m_profileMasteryMc = this.m_view.profileMasteryMc;
         this.m_unlockableMasteryMc = this.m_view.unlockableMasteryMc;
         this.m_missionRatingMc = this.m_view.missionSummaryMc.missionRatingMc;
         this.m_missionTimeMc = this.m_view.missionSummaryMc.missionTimeMc;
         this.m_missionScoreMc = this.m_view.missionSummaryMc.missionScoreMc;
         this.m_silentAssassinMc = this.m_view.silentAssassinMc;
         this.m_playStyleMc = this.m_view.playStyleMc;
         this.m_leaderboardMc = this.m_view.leaderboardMc;
         this.m_locationCompletionMc = this.m_view.locationCompletionMc;
         this.m_infoTxtOriginalPosX = this.m_profileMasteryMc.infoTxt.x;
         this.m_profileBarOriginalScale = this.m_profileMasteryMc.barBg.scaleX;
         this.m_unlockableBarOriginalScale = this.m_unlockableMasteryMc.barBg.scaleX;
         this.m_dottedLineContainer = new Sprite();
         this.m_dottedLineProfileMastery = new DottedLine(this.VIEW_WIDTH,MenuConstants.COLOR_WHITE,DottedLine.TYPE_HORIZONTAL,1,2);
         this.m_dottedLineProfileMastery.alpha = 0;
         this.m_dottedLineProfileMastery.y = 567;
         this.m_dottedLineUnlockableMastery = new DottedLine(this.VIEW_WIDTH,MenuConstants.COLOR_WHITE,DottedLine.TYPE_HORIZONTAL,1,2);
         this.m_dottedLineUnlockableMastery.alpha = 0;
         this.m_dottedLineUnlockableMastery.y = 647;
         this.m_dottedLineMissionSummary = new DottedLine(this.VIEW_WIDTH,MenuConstants.COLOR_WHITE,DottedLine.TYPE_HORIZONTAL,1,2);
         this.m_dottedLineMissionSummary.alpha = 0;
         this.m_dottedLineMissionSummary.y = 759;
         this.m_dottedLineLeaderBoard = new DottedLine(this.VIEW_WIDTH,MenuConstants.COLOR_WHITE,DottedLine.TYPE_HORIZONTAL,1,2);
         this.m_dottedLineLeaderBoard.alpha = 0;
         this.m_dottedLineLeaderBoard.y = 791;
         this.m_dottedLineContainer.addChild(this.m_dottedLineProfileMastery);
         this.m_dottedLineContainer.addChild(this.m_dottedLineUnlockableMastery);
         this.m_dottedLineContainer.addChild(this.m_dottedLineMissionSummary);
         this.m_dottedLineContainer.addChild(this.m_dottedLineLeaderBoard);
         this.m_view.addChild(this.m_dottedLineContainer);
         this.m_evergreenCampaignView.showMarker = false;
         this.m_evergreenCampaignView.showBackground = false;
         this.m_evergreenCampaignView.onMissionEnd = true;
         this.m_view.addChild(this.m_evergreenCampaignView);
         this.resetVisibility();
         this.m_badge = new Badge();
         this.m_playerBadgeMc.addChild(this.m_badge);
         this.m_badge.setMaxSize(this.BADGE_MAX_SIZE);
      }
      
      private static function getFinalBarScale(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = param1 % 1;
         return _loc3_ * param2;
      }
      
      private static function createBarValues(param1:Object, param2:LevelInfo, param3:Number) : BarValues
      {
         var _loc4_:Boolean = param2.isLevelMaxed(param1.XP);
         var _loc5_:Number = param3;
         if(_loc4_)
         {
            _loc5_ = Math.min(param1.XPGain,_loc5_);
         }
         var _loc6_:BarValues;
         (_loc6_ = new BarValues()).xpTotalGain = _loc5_;
         _loc6_.endXP = param1.XP;
         _loc6_.startXP = _loc6_.endXP - _loc5_;
         var _loc7_:Number = param2.getLevelFromList(_loc6_.startXP);
         _loc6_.startLevelNr = int(_loc7_);
         _loc6_.startBarProgress = _loc7_ % 1;
         var _loc8_:Number = param2.getLevelFromList(_loc6_.endXP);
         _loc6_.endLevelNr = int(_loc8_);
         _loc6_.endBarProgress = _loc8_ % 1;
         var _loc9_:Boolean;
         if(_loc9_ = param2.isLevelMaxed(_loc6_.endXP))
         {
            _loc6_.endBarProgress = 1;
         }
         return _loc6_;
      }
      
      private static function initBarValues(param1:BarAnimationValues, param2:Number, param3:Number, param4:Number) : void
      {
         if(param1.levelInfo == null)
         {
            return;
         }
         var _loc5_:Boolean;
         if(_loc5_ = param1.levelInfo.isLevelMaxed(param3))
         {
            param1.barView.scaleX = param1.originalScale;
            return;
         }
         var _loc6_:Number = param1.levelInfo.getLevelFromList(param3);
         var _loc7_:Number = param1.levelInfo.getLevelFromList(param4);
         var _loc8_:int = int(_loc6_);
         var _loc9_:Number = _loc7_ - _loc8_;
         var _loc10_:Number = param2 / (_loc7_ - _loc6_);
         var _loc11_:Number = _loc7_ % 1;
         var _loc12_:Boolean;
         if(_loc12_ = param1.levelInfo.isLevelMaxed(param4))
         {
            _loc11_ = 1;
         }
         animateBarFill(param1,_loc8_,_loc9_,_loc11_,_loc10_);
      }
      
      private static function animateBarFill(param1:BarAnimationValues, param2:int, param3:Number, param4:Number, param5:Number) : void
      {
         var targetScale:Number;
         var nextFillingsLeft:Number = NaN;
         var barAniValues:BarAnimationValues = param1;
         var currentLevelNr:int = param2;
         var fillingsLeft:Number = param3;
         var endBarProgress:Number = param4;
         var speed:Number = param5;
         var duration:Number = 0;
         var currentBarProgress:Number = Math.max(0,Math.min(barAniValues.barView.scaleX / barAniValues.originalScale,1));
         if(fillingsLeft >= 1)
         {
            duration = (1 - currentBarProgress) * speed;
            nextFillingsLeft = fillingsLeft - 1;
            Animate.to(barAniValues.barView,duration,0,{"scaleX":barAniValues.originalScale},Animate.Linear,function():void
            {
               var _loc1_:int = currentLevelNr + 1;
               if(barAniValues.newLevelCallback != null)
               {
                  barAniValues.newLevelCallback(_loc1_);
               }
               if(endBarProgress == 1 && fillingsLeft == 1)
               {
                  return;
               }
               barAniValues.barView.scaleX = 0;
               animateBarFill(barAniValues,_loc1_,nextFillingsLeft,endBarProgress,speed);
            });
            return;
         }
         duration = Math.max(0,Math.min(endBarProgress - currentBarProgress,1)) * speed;
         targetScale = endBarProgress * barAniValues.originalScale;
         Animate.to(barAniValues.barView,duration,0,{"scaleX":targetScale},Animate.Linear);
      }
      
      private function resetVisibility() : void
      {
         var _loc1_:* = !ControlsMain.isVrModeActive();
         this.m_missionRatingMc.newBestFx.visible = _loc1_;
         this.m_missionTimeMc.newBestFx.visible = _loc1_;
         this.m_missionScoreMc.newBestFx.visible = _loc1_;
         this.m_playerBadgeMc.alpha = 0;
         this.m_playerLevelMc.alpha = 0;
         this.m_playerLevelMc.levelBg.visible = false;
         this.m_playerNameMc.alpha = 0;
         this.m_profileMasteryMc.alpha = 0;
         this.m_profileMasteryMc.fx.alpha = 0;
         this.m_profileMasteryMc.fx.visible = _loc1_;
         this.m_unlockableMasteryMc.alpha = 0;
         this.m_missionRatingMc.alpha = 0;
         this.m_missionTimeMc.alpha = 0;
         this.m_missionScoreMc.alpha = 0;
         this.m_view.missionSummaryMc.lineMc_01.alpha = 0;
         this.m_view.missionSummaryMc.lineMc_02.alpha = 0;
         this.m_view.missionSummaryMc.lineMc_03.alpha = 0;
         this.m_view.missionSummaryMc.lineMc_04.alpha = 0;
         this.formatNewBestTextFields(this.m_missionScoreMc);
         this.formatNewBestTextFields(this.m_missionTimeMc);
         this.formatNewBestTextFields(this.m_missionRatingMc);
         this.m_missionScoreMc.newBestBgNegative.alpha = 0;
         this.m_silentAssassinMc.alpha = 0;
         this.m_silentAssassinMc.fx.alpha = 0;
         this.m_silentAssassinMc.fx.visible = _loc1_;
         this.m_playStyleMc.alpha = 0;
         this.m_playStyleMc.fx.alpha = 0;
         this.m_playStyleMc.fx.visible = _loc1_;
         this.m_leaderboardMc.alpha = 0;
         this.m_locationCompletionMc.alpha = 0;
         this.m_locationCompletionMc.contractTitle.visible = false;
         this.m_dottedLineProfileMastery.alpha = 0;
         this.m_dottedLineUnlockableMastery.alpha = 0;
         this.m_dottedLineMissionSummary.alpha = 0;
         this.m_dottedLineLeaderBoard.alpha = 0;
         if(this.m_dottedLinePlayerName)
         {
            this.m_dottedLinePlayerName.alpha = 0;
         }
         this.m_evergreenCampaignView.alpha = 0;
      }
      
      override public function onSetData(param1:Object) : void
      {
         var _loc10_:int = 0;
         var _loc11_:Object = null;
         var _loc12_:int = 0;
         var _loc13_:Object = null;
         var _loc14_:int = 0;
         var _loc15_:MovieClip = null;
         var _loc16_:String = null;
         var _loc17_:* = null;
         var _loc18_:Number = NaN;
         var _loc19_:String = null;
         var _loc20_:int = 0;
         var _loc21_:String = null;
         var _loc22_:String = null;
         var _loc23_:String = null;
         var _loc24_:String = null;
         var _loc25_:String = null;
         var _loc26_:String = null;
         super.onSetData(param1);
         this.m_isOnline = param1.isonline != null ? Boolean(param1.isonline) : false;
         this.m_useAnimation = param1.animate != null ? Boolean(param1.animate) : true;
         this.m_animationStarted = false;
         this.m_isEvergreen = param1.ContractType == "evergreen";
         if(this.m_isEvergreen)
         {
            this.m_evergreenEndState = param1.EvergreenEndState;
            this.m_evergreenAnimation = this.m_useAnimation;
         }
         else
         {
            this.m_evergreenAnimation = false;
         }
         this.m_isSniper = param1.ContractType == "sniper";
         this.m_isUnlockableMasteryVisible = false;
         this.m_isVersus = param1.isversus != null ? Boolean(param1.isversus) : false;
         this.m_isWinner = param1.iswinner != null ? Boolean(param1.iswinner) : false;
         this.m_isWinnerMsg = param1.winnertext != null ? String(param1.winnertext) : "";
         this.m_actionXPGain = 0;
         this.m_challengeXPGain = 0;
         this.m_challengeCountGain = 0;
         this.m_barRewards.length = 0;
         if(!this.m_isEvergreen && param1.IsNewBestScore != null && Boolean(param1.IsNewBestScore))
         {
            this.m_isNewBestScore = true;
            MenuUtils.setupTextUpper(this.m_missionScoreMc.newBestTitle,Localization.get("UI_RATING_NEW_PERSONAL BEST"),14,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorGreyUltraDark);
         }
         if(!this.m_isEvergreen && param1.IsNewBestTime != null && Boolean(param1.IsNewBestTime))
         {
            this.m_isNewBestTime = true;
            MenuUtils.setupTextUpper(this.m_missionTimeMc.newBestTitle,Localization.get("UI_RATING_NEW_PERSONAL BEST"),14,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorGreyUltraDark);
         }
         if(!this.m_isEvergreen && param1.IsNewBestStars != null && Boolean(param1.IsNewBestStars))
         {
            this.m_isNewBestRating = true;
            MenuUtils.setupTextUpper(this.m_missionRatingMc.newBestTitle,Localization.get("UI_RATING_NEW_PERSONAL BEST"),14,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorGreyUltraDark);
         }
         if(Boolean(param1.Challenges) && param1.Challenges.length > 0)
         {
            _loc10_ = 0;
            while(_loc10_ < param1.Challenges.length)
            {
               _loc11_ = param1.Challenges[_loc10_];
               _loc12_ = 0;
               if(_loc11_.XPGain != undefined)
               {
                  _loc12_ = int(_loc11_.XPGain);
               }
               if(_loc11_.IsActionReward === true)
               {
                  if(_loc12_ > 0)
                  {
                     this.m_barRewards.push(_loc11_);
                     this.m_actionXPGain += _loc12_;
                  }
               }
               else
               {
                  ++this.m_challengeCountGain;
                  this.m_challengeXPGain += _loc12_;
               }
               _loc10_++;
            }
         }
         if(this.m_challengeXPGain > 0)
         {
            (_loc13_ = new Object()).ChallengeName = "UI_MENU_PAGE_PLANNING_CHALLENGES";
            _loc13_.XPGain = this.m_challengeXPGain;
            this.m_barRewards.unshift(_loc13_);
         }
         if(param1.player != null)
         {
            MenuUtils.setupText(this.m_playerNameMc.labelTxt,param1.player,60,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
            CommonUtils.changeFontToGlobalIfNeeded(this.m_playerNameMc.labelTxt);
            MenuUtils.truncateTextfieldWithCharLimit(this.m_playerNameMc.labelTxt,1,MenuConstants.PLAYERNAME_MIN_CHAR_COUNT,MenuConstants.FontColorWhite);
            MenuUtils.shrinkTextToFit(this.m_playerNameMc.labelTxt,this.m_playerNameMc.labelTxt.width,-1);
         }
         if(!this.m_isOnline)
         {
            this.resetVisibility();
            this.m_view.offlineTxt.visible = true;
            MenuUtils.setupText(this.m_view.offlineTxt,Localization.get("UI_DIALOG_SCORE_OFFLINE"),26,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
            Animate.to(this.m_playerNameMc,0.3,0.1,{"alpha":1},Animate.ExpoOut);
            return;
         }
         if(param1.LocationProgression != null)
         {
            this.m_locationLevelInfo = new LevelInfo();
            this.m_locationLevelInfo.init(param1.LocationProgression.LevelInfo,0);
         }
         if(param1.UnlockableProgression != null)
         {
            this.m_sniperUnlockableLevelInfo = new LevelInfo();
            this.m_sniperUnlockableLevelInfo.init(param1.UnlockableProgression.LevelInfo,0);
         }
         this.m_hideLocationProgression = true;
         if(param1.CompletionData != null)
         {
            this.m_hideLocationProgression = param1.CompletionData.HideProgression === true;
         }
         this.m_profileBarValues = new BarValues();
         this.m_profileMasteryMc.barFill.scaleX = 0;
         this.m_xpTotal = this.m_challengeXPGain + this.m_actionXPGain;
         if(param1.ProfileProgression != null)
         {
            this.m_profileLevelInfo = new LevelInfo();
            _loc14_ = param1.ProfileProgression.LevelInfoOffset != undefined ? int(param1.ProfileProgression.LevelInfoOffset) : 0;
            this.m_profileLevelInfo.init(param1.ProfileProgression.LevelInfo,_loc14_);
            this.m_profileBarValues = createBarValues(param1.ProfileProgression,this.m_profileLevelInfo,this.m_xpTotal);
            MenuUtils.setColor(this.m_profileMasteryMc.barBg,MenuConstants.COLOR_WHITE,true,0.1);
            MenuUtils.setColor(this.m_profileMasteryMc.barFill,MenuConstants.COLOR_WHITE);
            this.m_profileMasteryMc.barFill.scaleX = this.m_profileBarValues.startBarProgress * this.m_profileBarOriginalScale;
         }
         this.setLevelInfoProfile("");
         if(this.m_isEvergreen)
         {
            this.m_view.missionSummaryMc.lineMc_01.alpha = 0;
            this.m_view.missionSummaryMc.lineMc_02.alpha = 0;
            this.m_view.missionSummaryMc.lineMc_03.alpha = 0;
            this.m_view.missionSummaryMc.lineMc_04.alpha = 0;
         }
         this.m_showRating = param1.showrating != undefined ? Boolean(param1.showrating) : param1.rating != null;
         this.m_ratingScore = param1.rating != null ? Number(param1.rating) : 0;
         if(this.m_isEvergreen)
         {
            this.m_showRating = false;
         }
         var _loc2_:Boolean = false;
         this.m_isSilentAssassin = this.m_ratingScore >= 5;
         if(param1.silentAssassin != null)
         {
            this.m_isSilentAssassin = param1.silentAssassin;
         }
         else if(param1.MedicineMan != null)
         {
            this.m_isSilentAssassin = param1.MedicineMan;
            _loc2_ = true;
         }
         if(param1.PlayStyle != null && (param1.EvergreenFailed == null || !param1.EvergreenFailed))
         {
            MenuUtils.setupTextAndShrinkToFitUpper(this.m_playStyleMc.title,param1.PlayStyle.Name,28,MenuConstants.FONT_TYPE_MEDIUM,this.m_playStyleMc.title.width,-1,15,MenuConstants.FontColorGreyUltraDark);
            this.m_playStyleSoundId = "ui_debrief_scorescreen_playstyle_sweetener_" + param1.PlayStyle.Type;
            this.m_hasPlayStyle = true;
         }
         else
         {
            this.m_hasPlayStyle = false;
         }
         var _loc3_:int = 1;
         while(_loc3_ <= 5)
         {
            _loc15_ = this.m_missionRatingMc.ratingIcons.getChildByName("icon" + _loc3_);
            MenuUtils.setColor(_loc15_,MenuConstants.COLOR_WHITE,true,this.m_showRating ? 0.1 : 0);
            _loc3_++;
         }
         if(_loc2_)
         {
            MenuUtils.setupTextUpper(this.m_silentAssassinMc.title,Localization.get("UI_RATING_MEDICINE_MAN").toUpperCase(),28,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
            MenuUtils.setColor(this.m_silentAssassinMc.bg,MenuConstants.COLOR_BLUE);
         }
         else
         {
            MenuUtils.setupTextUpper(this.m_silentAssassinMc.title,Localization.get("UI_RATING_SILENT_ASSASSIN").toUpperCase(),28,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
            MenuUtils.setColor(this.m_silentAssassinMc.bg,MenuConstants.COLOR_RED);
         }
         if(!this.m_isEvergreen)
         {
            _loc16_ = Localization.get("UI_MENU_MISSION_END_RATING_TITLE");
            MenuUtils.setupTextUpper(this.m_missionRatingMc.ratingTitle,_loc16_,18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorRed);
            if(this.m_showRating == false && param1.challengeMultiplier != null)
            {
               this.m_hasChallengeMultiplier = true;
               _loc17_ = Localization.get("UI_SNIPERSCORING_SUMMARY_MULTIPLIER") + ":";
               MenuUtils.setupTextAndShrinkToFitUpper(this.m_missionRatingMc.ratingTitle,_loc17_,18,MenuConstants.FONT_TYPE_MEDIUM,this.m_missionRatingMc.ratingTitle.width,-1,15,MenuConstants.FontColorRed);
               _loc18_ = Number(param1.challengeMultiplier);
               MenuUtils.setupText(this.m_missionRatingMc.ratingValue,_loc18_.toFixed(2),40,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
            }
         }
         else
         {
            _loc19_ = Localization.get("EVERGREEN_GAMEFLOW_XPGAINED_TITLE");
            MenuUtils.setupTextUpper(this.m_missionRatingMc.ratingTitle,_loc19_,18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorRed);
            if(this.m_evergreenAnimation)
            {
               this.m_xpAnimatedValue = 0;
            }
            else
            {
               this.m_xpAnimatedValue = this.m_xpTotal;
            }
            MenuUtils.setupText(this.m_missionRatingMc.ratingValue,this.formatXpNumber(this.m_xpAnimatedValue),40,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorBlack);
            this.m_missionRatingMc.newBestBg.alpha = 1;
         }
         var _loc4_:int = 0;
         var _loc5_:Array;
         if((_loc5_ = param1.scoreSummary) != null)
         {
            _loc20_ = 0;
            while(_loc20_ < _loc5_.length)
            {
               if(_loc5_[_loc20_].type == "summary")
               {
                  if(_loc5_[_loc20_].headline == "UI_SCORING_SUMMARY_TIME")
                  {
                     this.m_timeTotal = this.timeFromString(_loc5_[_loc20_].count);
                  }
                  else if(_loc5_[_loc20_].headline == "UI_SNIPERSCORING_SUMMARY_TIME_BONUS")
                  {
                     this.m_timeTotal = this.timeFromStringSniper(_loc5_[_loc20_].count);
                  }
               }
               else if(_loc5_[_loc20_].type == "total")
               {
                  _loc4_ = int(_loc5_[_loc20_].scoreTotal);
               }
               _loc20_++;
            }
         }
         if(this.m_evergreenAnimation)
         {
            this.m_timeAnimatedValue = 0;
         }
         else
         {
            this.m_timeAnimatedValue = this.m_timeTotal;
         }
         var _loc6_:String = Localization.get("UI_MENU_MISSION_END_TIME_TITLE");
         MenuUtils.setupTextUpper(this.m_missionTimeMc.timeTitle,_loc6_,18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorRed);
         MenuUtils.setupText(this.m_missionTimeMc.timeValue,this.formatTime(this.m_timeAnimatedValue),40,MenuConstants.FONT_TYPE_MEDIUM,this.m_isEvergreen ? MenuConstants.FontColorBlack : MenuConstants.FontColorWhite);
         CommonUtils.changeFontToGlobalFont(this.m_missionTimeMc.timeValue);
         if(this.m_isEvergreen)
         {
            this.m_missionTimeMc.newBestBg.alpha = 1;
         }
         if(!this.m_isEvergreen)
         {
            _loc21_ = Localization.get("UI_MENU_MISSION_END_SCORE_TITLE");
            MenuUtils.setupTextUpper(this.m_missionScoreMc.scoreTitle,_loc21_,18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorRed);
            if(this.m_isVersus)
            {
               MenuUtils.setupText(this.m_missionScoreMc.scoreValue,param1.finalscore,40,MenuConstants.FONT_TYPE_MEDIUM,this.m_isNewBestScore ? MenuConstants.FontColorGreyUltraDark : MenuConstants.FontColorWhite);
            }
            else
            {
               MenuUtils.setupText(this.m_missionScoreMc.scoreValue,MenuUtils.formatNumber(_loc4_),40,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
            }
         }
         else
         {
            this.m_payoutTotal = !!param1.EvergreenPayout ? Number(param1.EvergreenPayout) : 0;
            if(this.m_evergreenAnimation)
            {
               this.m_payoutAnimatedValue = 0;
            }
            else
            {
               this.m_payoutAnimatedValue = this.m_payoutTotal;
            }
            if(this.m_payoutTotal < 0)
            {
               _loc22_ = Localization.get("EVERGREEN_GAMEFLOW_MISSIONPAYOUT_LOST_TITLE");
               MenuUtils.setupTextUpper(this.m_missionScoreMc.scoreTitle,_loc22_,18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
               _loc23_ = MenuUtils.formatNumber(this.m_payoutAnimatedValue) + Localization.get("UI_EVERGREEN_MERCES");
               MenuUtils.setupText(this.m_missionScoreMc.scoreValue,_loc23_,40,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
               this.m_missionScoreMc.newBestBg.alpha = 0;
               this.m_missionScoreMc.newBestBgNegative.alpha = 1;
            }
            else
            {
               _loc22_ = Localization.get("EVERGREEN_GAMEFLOW_MISSIONPAYOUT_TITLE");
               MenuUtils.setupTextUpper(this.m_missionScoreMc.scoreTitle,_loc22_,18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorRed);
               _loc23_ = MenuUtils.formatNumber(this.m_payoutAnimatedValue) + Localization.get("UI_EVERGREEN_MERCES");
               MenuUtils.setupText(this.m_missionScoreMc.scoreValue,_loc23_,40,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorBlack);
               this.m_missionScoreMc.newBestBg.alpha = 1;
               this.m_missionScoreMc.newBestBgNegative.alpha = 0;
            }
         }
         if(this.m_isEvergreen)
         {
            this.m_evergreenCampaignView.alpha = 1;
            this.m_evergreenCampaignView.x = 348;
            this.m_evergreenCampaignView.y = 802;
            this.m_evergreenCampaignView.waitWithAnimation = this.m_evergreenAnimation;
            this.m_evergreenCampaignView.onSetData(param1.EvergreenCampaignProgress);
            this.m_dottedLineLeaderBoard.alpha = 1;
            this.m_dottedLineLeaderBoard.y = 868;
            this.m_locationCompletionMc.y = 872;
         }
         var _loc7_:String = "";
         var _loc8_:String = "unlocked";
         this.m_unlockableBarValues = null;
         this.m_unlockableMaxLevel = 1;
         this.m_unlockableMasteryIsLocation = false;
         if(!this.m_hideLocationProgression && this.m_locationLevelInfo != null && param1.LocationProgression != null)
         {
            this.m_unlockableBarValues = createBarValues(param1.LocationProgression,this.m_locationLevelInfo,this.m_xpTotal);
            if(!this.m_isEvergreen)
            {
               _loc7_ = Localization.get("UI_MENU_PAGE_PROFILE_LOCATION_MASTERY");
            }
            else
            {
               _loc7_ = Localization.get("EVERGREEN_GAMEFLOW_MASTERY_TITLE");
            }
            this.m_unlockableMaxLevel = this.m_locationLevelInfo.getMaxLevel();
            this.m_unlockableMasteryIsLocation = true;
         }
         else if(this.m_sniperUnlockableLevelInfo != null && param1.UnlockableProgression != null)
         {
            this.m_unlockableBarValues = createBarValues(param1.UnlockableProgression,this.m_sniperUnlockableLevelInfo,_loc4_);
            _loc7_ = Localization.get(param1.UnlockableProgression.Name);
            this.m_unlockableMaxLevel = this.m_sniperUnlockableLevelInfo.getMaxLevel();
         }
         if(this.m_unlockableBarValues != null)
         {
            this.m_isUnlockableMasteryVisible = true;
            MenuUtils.setColor(this.m_unlockableMasteryMc.barBg,MenuConstants.COLOR_WHITE,true,0.1);
            MenuUtils.setColor(this.m_unlockableMasteryMc.barFill,MenuConstants.COLOR_WHITE);
            this.m_unlockableMasteryMc.barFill.scaleX = this.m_unlockableBarOriginalScale * this.m_unlockableBarValues.startBarProgress;
            MenuUtils.setupIcon(this.m_unlockableMasteryMc.icon,"unlocked",MenuConstants.COLOR_BLACK,false,true,MenuConstants.COLOR_WHITE);
            MenuUtils.setupTextUpper(this.m_unlockableMasteryMc.title,_loc7_,24,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorRed);
            this.setLevelNumberUnlockable(this.m_unlockableBarValues.startLevelNr);
         }
         this.m_hasLeaderboard = param1.LeaderboardFriendsInfo != null || param1.LeaderboardInfo != null;
         if(this.m_hasLeaderboard)
         {
            _loc25_ = (_loc24_ = Localization.get("UI_MENU_PAGE_LEADERBOARDS_TITLE")) + " " + Localization.get("UI_MENU_PAGE_LEADERBOARDS_FILTER_FRIENDS");
            _loc26_ = _loc24_ + " " + Localization.get("UI_MENU_PAGE_LEADERBOARDS_FILTER_GLOBAL");
            if(param1.LeaderboardFriendsInfo != null)
            {
               MenuUtils.setupTextUpper(this.m_leaderboardMc.friendsTxt,_loc25_,18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorRed);
               MenuUtils.setupTextUpper(this.m_leaderboardMc.friendsTxt," " + param1.LeaderboardFriendsInfo,18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite,true);
            }
            if(param1.LeaderboardInfo != null)
            {
               MenuUtils.setupTextUpper(this.m_leaderboardMc.globalTxt,_loc26_,18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorRed);
               MenuUtils.setupTextUpper(this.m_leaderboardMc.globalTxt," " + param1.LeaderboardInfo,18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite,true);
            }
         }
         var _loc9_:Array = param1.OpportunityRewards;
         this.m_opportunityCountGain = _loc9_ != null ? int(_loc9_.length) : 0;
         this.setLocationProgression(param1);
      }
      
      private function formatXpNumber(param1:int) : String
      {
         return MenuUtils.formatNumber(param1) + " " + Localization.get("UI_PERFORMANCE_MASTERY_XP");
      }
      
      private function formatTime(param1:int) : String
      {
         if(this.m_isSniper)
         {
            return this.formatTimeSniper(param1);
         }
         var _loc2_:String = "";
         var _loc3_:int = param1 / 3600;
         _loc2_ += (_loc3_ < 10 ? "0" : "") + _loc3_;
         var _loc4_:int = param1 / 60 % 60;
         _loc2_ += (_loc4_ < 10 ? ":0" : ":") + _loc4_;
         var _loc5_:int = param1 % 60;
         _loc2_ += (_loc5_ < 10 ? ":0" : ":") + _loc5_;
         return "<font face=\"$global\">" + _loc2_ + "</font>";
      }
      
      private function formatTimeSniper(param1:int) : String
      {
         var _loc2_:String = "";
         var _loc3_:int = param1 / 60000;
         _loc2_ += (_loc3_ < 10 ? "0" : "") + _loc3_;
         var _loc4_:int = param1 / 1000 % 60;
         _loc2_ += (_loc4_ < 10 ? ":0" : ":") + _loc4_;
         var _loc5_:int = param1 % 1000;
         _loc2_ += (_loc5_ < 100 ? (_loc5_ < 10 ? ".00" : ".0") : ".") + _loc5_;
         return "<font face=\"$global\">" + _loc2_ + "</font>";
      }
      
      private function timeFromString(param1:String) : int
      {
         if(param1.length < 8)
         {
            return 0;
         }
         var _loc2_:int = param1.length - 8;
         return parseInt(param1.substr(0,_loc2_ + 2)) * 3600 + parseInt(param1.substr(_loc2_ + 3,2)) * 60 + parseInt(param1.substr(_loc2_ + 6,2));
      }
      
      private function timeFromStringSniper(param1:String) : int
      {
         if(param1.length != 9)
         {
            return 0;
         }
         return parseInt(param1.substr(0,2)) * 60000 + parseInt(param1.substr(3,2)) * 1000 + parseInt(param1.substr(6,3));
      }
      
      public function startAnimation() : void
      {
         if(!this.m_isOnline || this.m_animationStarted)
         {
            return;
         }
         this.m_animationStarted = true;
         Animate.kill(this.m_view);
         var _loc1_:Number = this.m_useAnimation ? 0.1 : 0.05;
         var _loc2_:Number = 0.1;
         Animate.delay(this.m_view,_loc2_,this.showPlayerInfo);
         _loc2_ += _loc1_;
         Animate.delay(this.m_view,_loc2_,this.showProfileMastery);
         if(this.m_isUnlockableMasteryVisible)
         {
            _loc2_ += _loc1_;
            Animate.delay(this.m_view,_loc2_,this.showUnlockableMastery);
         }
         _loc2_ += _loc1_;
         Animate.delay(this.m_view,_loc2_,this.showMissionResults);
         if(this.m_isVersus)
         {
            _loc2_ += 1;
            Animate.delay(this.m_view,_loc2_,this.animateProfileProgression);
            return;
         }
         if(!this.m_useAnimation)
         {
            this.showMissionRating();
            if(this.m_isSilentAssassin)
            {
               Animate.delay(this.m_view,_loc2_,this.showSilentAssassin);
            }
            else if(this.m_hasPlayStyle)
            {
               Animate.delay(this.m_view,_loc2_,this.showPlayStyle);
            }
            if(this.m_isNewBestRating)
            {
               Animate.delay(this.m_view,_loc2_,this.showNewBest,this.m_missionRatingMc);
            }
            if(this.m_isNewBestTime)
            {
               Animate.delay(this.m_view,_loc2_,this.showNewBest,this.m_missionTimeMc);
            }
            if(this.m_isNewBestScore)
            {
               Animate.delay(this.m_view,_loc2_,this.showNewBest,this.m_missionScoreMc);
            }
         }
         _loc2_ += _loc1_;
         if(this.m_hasLeaderboard)
         {
            Animate.delay(this.m_view,_loc2_,this.showLeaderboardElement);
         }
         Animate.delay(this.m_view,_loc2_,this.showLocationCompletion);
         Animate.delay(this.m_view,_loc2_,this.showLocationProgression);
         if(!this.m_useAnimation)
         {
            return;
         }
         _loc2_ += 0.2;
         Animate.delay(this.m_view,_loc2_,this.showMissionRating);
         if(this.m_isSilentAssassin)
         {
            _loc2_ += 0.4;
            Animate.delay(this.m_view,_loc2_,this.showSilentAssassin);
         }
         else if(this.m_hasPlayStyle)
         {
            _loc2_ += 0.4;
            Animate.delay(this.m_view,_loc2_,this.showPlayStyle);
         }
         if(this.m_isNewBestRating)
         {
            _loc2_ += 0.4;
            Animate.delay(this.m_view,_loc2_,this.showNewBest,this.m_missionRatingMc);
         }
         if(this.m_isNewBestTime)
         {
            _loc2_ += 0.4;
            Animate.delay(this.m_view,_loc2_,this.showNewBest,this.m_missionTimeMc);
         }
         if(this.m_isNewBestScore)
         {
            _loc2_ += 0.4;
            Animate.delay(this.m_view,_loc2_,this.showNewBest,this.m_missionScoreMc);
         }
         _loc2_ += 1;
         Animate.delay(this.m_view,_loc2_,this.animateProfileProgression);
         if(this.m_evergreenAnimation)
         {
            _loc2_ += this.animateProfileProgressionDuration() + 0.5;
            Animate.delay(this.m_view,_loc2_,this.animateEvergreenMissionResults);
         }
      }
      
      private function showPlayerInfo() : void
      {
         Animate.to(this.m_playerBadgeMc,0.3,0,{"alpha":1},Animate.ExpoOut);
         Animate.to(this.m_playerLevelMc,0.3,0.05,{"alpha":1},Animate.ExpoOut);
         Animate.to(this.m_playerNameMc,0.3,0.1,{"alpha":1},Animate.ExpoOut);
      }
      
      private function showProfileMastery() : void
      {
         if(!this.m_useAnimation)
         {
            this.setLevelNumberProfile(this.m_profileBarValues.endLevelNr);
            this.m_profileMasteryMc.barFill.scaleX = getFinalBarScale(this.m_profileLevelInfo.getLevelFromList(this.m_profileBarValues.endXP),this.m_profileBarOriginalScale);
         }
         else
         {
            this.setLevelNumberProfile(this.m_profileBarValues.startLevelNr);
         }
         Animate.to(this.m_dottedLineProfileMastery,0.3,0,{"alpha":1},Animate.ExpoOut);
         Animate.to(this.m_profileMasteryMc,0.3,0.05,{"alpha":1},Animate.ExpoOut);
      }
      
      private function showUnlockableMastery() : void
      {
         var _loc1_:Boolean = false;
         if(!this.m_useAnimation)
         {
            this.setLevelNumberUnlockable(this.m_unlockableBarValues.endLevelNr);
            if(this.m_unlockableMasteryIsLocation)
            {
               _loc1_ = this.m_locationLevelInfo.isLevelMaxed(this.m_unlockableBarValues.endXP);
               this.m_unlockableMasteryMc.barFill.scaleX = _loc1_ ? this.m_unlockableBarOriginalScale : getFinalBarScale(this.m_locationLevelInfo.getLevelFromList(this.m_unlockableBarValues.endXP),this.m_unlockableBarOriginalScale);
            }
            else if(this.m_sniperUnlockableLevelInfo != null)
            {
               _loc1_ = this.m_sniperUnlockableLevelInfo.isLevelMaxed(this.m_unlockableBarValues.endXP);
               this.m_unlockableMasteryMc.barFill.scaleX = _loc1_ ? this.m_unlockableBarOriginalScale : getFinalBarScale(this.m_sniperUnlockableLevelInfo.getLevelFromList(this.m_unlockableBarValues.endXP),this.m_unlockableBarOriginalScale);
            }
         }
         Animate.to(this.m_dottedLineUnlockableMastery,0.3,0,{"alpha":1},Animate.ExpoOut);
         Animate.to(this.m_unlockableMasteryMc,0.3,0,{"alpha":1},Animate.ExpoOut);
      }
      
      private function showMissionResults() : void
      {
         var _loc1_:TextFormat = null;
         var _loc2_:Sprite = null;
         var _loc3_:TextField = null;
         if(this.m_isVersus)
         {
            _loc1_ = this.m_missionScoreMc.scoreTitle.getTextFormat();
            _loc1_.align = TextFormatAlign.RIGHT;
            this.m_missionScoreMc.scoreTitle.setTextFormat(_loc1_);
            _loc1_ = this.m_missionScoreMc.scoreValue.getTextFormat();
            _loc1_.align = TextFormatAlign.RIGHT;
            this.m_missionScoreMc.scoreValue.setTextFormat(_loc1_);
            this.m_missionScoreMc.x = this.VIEW_WIDTH - this.m_missionScoreMc.width;
            this.m_missionTimeMc.x = this.m_missionRatingMc.x;
            Animate.to(this.m_missionTimeMc,0.3,0,{"alpha":1},Animate.ExpoOut);
            Animate.to(this.m_missionScoreMc,0.3,0.05,{"alpha":1},Animate.ExpoOut);
            Animate.to(this.m_view.missionSummaryMc.lineMc_01,0.3,0.1,{"alpha":1},Animate.ExpoOut);
            Animate.to(this.m_view.missionSummaryMc.lineMc_02,0.3,0.1,{"alpha":1},Animate.ExpoOut);
            Animate.to(this.m_view.missionSummaryMc.lineMc_03,0.3,0.1,{"alpha":1},Animate.ExpoOut);
            Animate.to(this.m_view.missionSummaryMc.lineMc_04,0.3,0.1,{"alpha":1},Animate.ExpoOut);
            if(this.m_isWinner)
            {
               _loc2_ = new Sprite();
               _loc2_.alpha = 0;
               _loc2_.y = this.m_missionTimeMc.y + this.m_missionTimeMc.height + 10;
               _loc3_ = new TextField();
               _loc3_.autoSize = TextFieldAutoSize.CENTER;
               _loc3_.selectable = false;
               _loc3_.width = this.VIEW_WIDTH;
               MenuUtils.setupTextAndShrinkToFitUpper(_loc3_,this.m_isWinnerMsg,120,MenuConstants.FONT_TYPE_MEDIUM,this.VIEW_WIDTH,-1,70,MenuConstants.FontColorWhite);
               _loc3_.x = (this.VIEW_WIDTH >> 1) - (_loc3_.width >> 1);
               _loc3_.y = 40;
               this.m_separatorVersusWinnerTop = new DottedLine(this.VIEW_WIDTH,MenuConstants.COLOR_WHITE,DottedLine.TYPE_HORIZONTAL,1,2);
               this.m_separatorVersusWinnerBottom = new DottedLine(this.VIEW_WIDTH,MenuConstants.COLOR_WHITE,DottedLine.TYPE_HORIZONTAL,1,2);
               this.m_separatorVersusWinnerBottom.y = _loc3_.y + _loc3_.height + 40;
               _loc2_.addChild(this.m_separatorVersusWinnerTop);
               _loc2_.addChild(this.m_separatorVersusWinnerBottom);
               _loc2_.addChild(_loc3_);
               this.m_view.addChild(_loc2_);
               Animate.to(_loc2_,0.5,0.3,{"alpha":1},Animate.ExpoOut);
               Animate.from(_loc3_,0.5,0.3,{"x":_loc3_.x - 20},Animate.ExpoOut);
            }
         }
         else
         {
            Animate.to(this.m_missionRatingMc,0.3,0,{"alpha":1},Animate.ExpoOut);
            Animate.to(this.m_missionTimeMc,0.3,0.05,{"alpha":1},Animate.ExpoOut);
            Animate.to(this.m_missionScoreMc,0.3,0.1,{"alpha":1},Animate.ExpoOut);
            if(!this.m_isEvergreen)
            {
               Animate.to(this.m_view.missionSummaryMc.lineMc_01,0.3,0.1,{"alpha":1},Animate.ExpoOut);
               Animate.to(this.m_view.missionSummaryMc.lineMc_02,0.3,0.1,{"alpha":1},Animate.ExpoOut);
               Animate.to(this.m_view.missionSummaryMc.lineMc_03,0.3,0.1,{"alpha":1},Animate.ExpoOut);
               Animate.to(this.m_view.missionSummaryMc.lineMc_04,0.3,0.1,{"alpha":1},Animate.ExpoOut);
            }
         }
      }
      
      private function animateEvergreenMissionResults() : void
      {
         var _loc1_:Number = 0;
         Animate.delay(this.m_view,_loc1_,this.animateXp);
         if(this.m_xpTotal != 0)
         {
            _loc1_ += 1;
         }
         _loc1_ += 0.5;
         Animate.delay(this.m_view,_loc1_,this.animateTime);
         if(this.m_timeTotal != 0)
         {
            _loc1_ += 1;
         }
         _loc1_ += 0.5;
         Animate.delay(this.m_view,_loc1_,this.animatePayout);
         if(this.m_payoutTotal != 0)
         {
            _loc1_ += 1;
         }
         _loc1_ += 0.5;
         Animate.delay(this.m_view,_loc1_,this.animateCampaignProgress);
      }
      
      private function animateXp() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         if(this.m_xpAnimatedTime == 0)
         {
            this.m_xpAnimatedTime = getTimer();
            if(this.m_xpAnimatedValue != this.m_xpTotal)
            {
               this.playSound("ui_debrief_scorescreen_evergreen_xp_counting_begin");
            }
         }
         else if(this.m_xpAnimatedValue < this.m_xpTotal)
         {
            _loc1_ = getTimer();
            _loc2_ = _loc1_ - this.m_xpAnimatedTime;
            this.m_xpAnimatedTime = _loc1_;
            _loc3_ = _loc2_ / 1000 * this.m_xpTotal;
            if(this.m_xpAnimatedValue + _loc3_ < this.m_xpTotal)
            {
               this.m_xpAnimatedValue += _loc3_;
            }
            else
            {
               this.m_xpAnimatedValue = this.m_xpTotal;
            }
            MenuUtils.setupText(this.m_missionRatingMc.ratingValue,this.formatXpNumber(this.m_xpAnimatedValue),40,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorBlack);
         }
         if(this.m_xpAnimatedValue == this.m_xpTotal)
         {
            if(this.m_xpTotal != 0)
            {
               this.playSound("ui_debrief_scorescreen_evergreen_xp_counting_done");
            }
            else
            {
               this.playSound("ui_debrief_scorescreen_evergreen_xp_counting_done_zero");
            }
            this.blinkNewBestClip(this.m_missionRatingMc);
         }
         else
         {
            Animate.delay(this.m_view,0.01,this.animateXp);
         }
      }
      
      private function animateTime() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:String = null;
         if(this.m_timeAnimatedTime == 0)
         {
            this.m_timeAnimatedTime = getTimer();
            if(this.m_timeAnimatedValue != this.m_timeTotal)
            {
               this.playSound("ui_debrief_scorescreen_evergreen_time_counting_begin");
            }
         }
         else if(this.m_timeAnimatedValue < this.m_timeTotal)
         {
            _loc1_ = getTimer();
            _loc2_ = _loc1_ - this.m_timeAnimatedTime;
            this.m_timeAnimatedTime = _loc1_;
            _loc3_ = _loc2_ / 1000 * this.m_timeTotal;
            if(this.m_timeAnimatedValue + _loc3_ < this.m_timeTotal)
            {
               this.m_timeAnimatedValue += _loc3_;
            }
            else
            {
               this.m_timeAnimatedValue = this.m_timeTotal;
            }
            _loc4_ = this.formatTime(this.m_timeAnimatedValue);
            MenuUtils.setupText(this.m_missionTimeMc.timeValue,_loc4_,40,MenuConstants.FONT_TYPE_MEDIUM,this.m_isEvergreen ? MenuConstants.FontColorBlack : MenuConstants.FontColorWhite);
         }
         if(this.m_timeAnimatedValue == this.m_timeTotal)
         {
            this.playSound("ui_debrief_scorescreen_evergreen_time_counting_done");
            this.blinkNewBestClip(this.m_missionTimeMc);
         }
         else
         {
            Animate.delay(this.m_view,0.01,this.animateTime);
         }
      }
      
      private function animatePayout() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:String = null;
         if(this.m_payoutAnimatedTime == 0)
         {
            this.m_payoutAnimatedTime = getTimer();
            if(this.m_payoutAnimatedValue != this.m_payoutTotal)
            {
               this.playSound("ui_debrief_scorescreen_evergreen_payout_counting_begin");
            }
         }
         else if(Math.abs(this.m_payoutAnimatedValue) < Math.abs(this.m_payoutTotal))
         {
            _loc1_ = getTimer();
            _loc2_ = _loc1_ - this.m_payoutAnimatedTime;
            this.m_payoutAnimatedTime = _loc1_;
            _loc3_ = _loc2_ / 1000 * this.m_payoutTotal;
            if(Math.abs(this.m_payoutAnimatedValue + _loc3_) < Math.abs(this.m_payoutTotal))
            {
               this.m_payoutAnimatedValue += _loc3_;
            }
            else
            {
               this.m_payoutAnimatedValue = this.m_payoutTotal;
            }
            _loc4_ = MenuUtils.formatNumber(this.m_payoutAnimatedValue) + Localization.get("UI_EVERGREEN_MERCES");
            if(this.m_payoutTotal < 0)
            {
               MenuUtils.setupText(this.m_missionScoreMc.scoreValue,_loc4_,40,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
            }
            else
            {
               MenuUtils.setupText(this.m_missionScoreMc.scoreValue,_loc4_,40,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorBlack);
            }
         }
         if(this.m_payoutAnimatedValue == this.m_payoutTotal)
         {
            if(this.m_payoutTotal != 0)
            {
               this.playSound("ui_debrief_scorescreen_evergreen_payout_counting_done");
            }
            else
            {
               this.playSound("ui_debrief_scorescreen_evergreen_payout_counting_done_zero");
            }
            this.blinkNewBestClip(this.m_missionScoreMc);
         }
         else
         {
            Animate.delay(this.m_view,0.01,this.animatePayout);
         }
      }
      
      private function blinkNewBestClip(param1:MovieClip) : void
      {
         Animate.fromTo(param1.newBestFx,0.45,0,{"alpha":1},{"alpha":0},Animate.ExpoOut);
         Animate.addTo(param1.newBestFx,0.5,0,{"scaleX":param1.newBestFx.scaleX + 0.5},Animate.ExpoOut);
         Animate.addTo(param1.newBestFx,0.5,0,{"scaleY":param1.newBestFx.scaleY + 0.75},Animate.ExpoOut);
      }
      
      private function animateCampaignProgress() : void
      {
         this.m_evergreenCampaignView.doAnimation();
      }
      
      private function showMissionRating() : void
      {
         var _loc2_:MovieClip = null;
         var _loc1_:Number = 0.1;
         var _loc3_:int = 1;
         while(_loc3_ <= 5)
         {
            if(this.m_showRating && _loc3_ <= this.m_ratingScore)
            {
               _loc2_ = this.m_missionRatingMc.ratingIcons.getChildByName("icon" + _loc3_);
               if(!this.m_useAnimation)
               {
                  _loc2_.alpha = 1;
               }
               else
               {
                  Animate.to(_loc2_,0.15,_loc1_,{"alpha":1},Animate.ExpoOut,this.playMissionRatingSound);
                  Animate.addFrom(_loc2_,0.3,_loc1_,{
                     "scaleX":1.5,
                     "scaleY":1.5
                  },Animate.ExpoOut);
                  _loc1_ += 0.05;
               }
            }
            _loc3_++;
         }
         Animate.to(this.m_dottedLineMissionSummary,0.3,0,{"alpha":1},Animate.ExpoOut);
      }
      
      private function playMissionRatingSound() : void
      {
         this.playSound("ui_debrief_scorescreen_star_rating");
      }
      
      private function showSilentAssassin() : void
      {
         if(!this.m_useAnimation)
         {
            Animate.fromTo(this.m_silentAssassinMc,0.3,0,{"alpha":0},{"alpha":1},Animate.ExpoOut);
            return;
         }
         Animate.delay(this.m_playstyleDelaySprite,0.15,this.playPlayStyleSound);
         this.m_silentAssassinMc.bg.alpha = 0;
         this.m_silentAssassinMc.fx.scaleX = this.m_silentAssassinMc.fx.scaleY = 1;
         this.m_silentAssassinMc.title.alpha = 0;
         this.m_silentAssassinMc.alpha = 1;
         Animate.to(this.m_silentAssassinMc.bg,0.1,0.15,{"alpha":1},Animate.ExpoOut);
         Animate.addFromTo(this.m_silentAssassinMc.bg,0.25,0.15,{"scaleY":0.4},{"scaleY":1},Animate.ExpoOut);
         Animate.to(this.m_silentAssassinMc.title,0.1,0.2,{"alpha":1},Animate.ExpoOut);
         Animate.fromTo(this.m_silentAssassinMc.fx,0.45,0.2,{"alpha":1},{"alpha":0},Animate.ExpoOut);
         Animate.addTo(this.m_silentAssassinMc.fx,0.5,0.2,{"scaleX":1.05},Animate.ExpoOut);
         Animate.addTo(this.m_silentAssassinMc.fx,0.5,0.2,{"scaleY":1.75},Animate.ExpoOut);
      }
      
      private function showPlayStyle() : void
      {
         if(!this.m_useAnimation)
         {
            Animate.fromTo(this.m_playStyleMc,0.3,0,{"alpha":0},{"alpha":1},Animate.ExpoOut);
            return;
         }
         Animate.delay(this.m_playstyleDelaySprite,0.15,this.playPlayStyleSound);
         this.m_playStyleMc.bg.alpha = 0;
         this.m_playStyleMc.fx.scaleX = this.m_playStyleMc.fx.scaleY = 1;
         this.m_playStyleMc.title.alpha = 0;
         this.m_playStyleMc.alpha = 1;
         Animate.to(this.m_playStyleMc.bg,0.1,0.15,{"alpha":1},Animate.ExpoOut);
         Animate.addFromTo(this.m_playStyleMc.bg,0.25,0.15,{"scaleY":0.4},{"scaleY":1},Animate.ExpoOut);
         Animate.to(this.m_playStyleMc.title,0.1,0.2,{"alpha":1},Animate.ExpoOut);
         Animate.fromTo(this.m_playStyleMc.fx,0.45,0.2,{"alpha":1},{"alpha":0},Animate.ExpoOut);
         Animate.addTo(this.m_playStyleMc.fx,0.5,0.2,{"scaleX":1.05},Animate.ExpoOut);
         Animate.addTo(this.m_playStyleMc.fx,0.5,0.2,{"scaleY":1.75},Animate.ExpoOut);
      }
      
      private function playPlayStyleSound() : void
      {
         if(this.m_playStyleSoundId != null)
         {
            this.playSound(this.m_playStyleSoundId);
         }
         this.playSound("ui_debrief_scorescreen_playstyle");
      }
      
      private function showNewBest(param1:MovieClip) : void
      {
         Animate.kill(param1.newBestTitle);
         Animate.kill(param1.newBestFx);
         Animate.kill(param1.newBestBg);
         param1.newBestFx.height = param1.newBestBg.height = 82 + (param1.newBestTitle.numLines - 1) * 18;
         param1.newBestFx.y = 49.5 + param1.newBestTitle.numLines * 18 / 2;
         if(!this.m_useAnimation)
         {
            Animate.fromTo(param1.newBestTitle,0.1,0,{"alpha":0},{"alpha":1},Animate.ExpoOut);
            Animate.fromTo(param1.newBestBg,0.1,0,{"alpha":0},{"alpha":1},Animate.ExpoOut);
            this.offsetMissionSummary(0.1,param1);
            this.tintNewBest(param1);
            this.hideMissionSummaryLines(param1);
            return;
         }
         Animate.delay(this.m_newBestDelaySprite,0.15,this.playNewBestSound,param1);
         Animate.fromTo(param1.newBestTitle,0.1,0.2,{"alpha":0},{"alpha":1},Animate.ExpoOut);
         Animate.fromTo(param1.newBestBg,0.1,0.15,{"alpha":0},{"alpha":1},Animate.ExpoOut);
         Animate.fromTo(param1.newBestFx,0.45,0.2,{"alpha":1},{"alpha":0},Animate.ExpoOut);
         Animate.addTo(param1.newBestFx,0.5,0.2,{"scaleX":param1.newBestFx.scaleX + 0.5},Animate.ExpoOut);
         Animate.addTo(param1.newBestFx,0.5,0.2,{"scaleY":param1.newBestFx.scaleY + 0.75},Animate.ExpoOut);
         this.offsetMissionSummary(0.3,param1);
         this.tintNewBest(param1);
         this.hideMissionSummaryLines(param1);
      }
      
      private function playNewBestSound(param1:MovieClip) : void
      {
         if(param1 == this.m_missionRatingMc)
         {
            this.playSound("ui_debrief_scorescreen_mission_rating");
         }
         if(param1 == this.m_missionTimeMc)
         {
            this.playSound("ui_debrief_scorescreen_mission_time");
         }
         if(param1 == this.m_missionScoreMc)
         {
            this.playSound("ui_debrief_scorescreen_mission_score");
         }
      }
      
      private function offsetMissionSummary(param1:Number, param2:MovieClip) : void
      {
         Animate.kill(param2);
         var _loc3_:int = param2.newBestTitle.numLines == 1 ? -9 : -18;
         Animate.to(param2,param1,0,{
            "y":_loc3_,
            "alpha":1
         },Animate.ExpoOut);
      }
      
      private function tintNewBest(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         if(param1 == this.m_missionRatingMc)
         {
            if(this.m_hasChallengeMultiplier)
            {
               MenuUtils.setupText(this.m_missionRatingMc.ratingValue,this.m_missionRatingMc.ratingValue.text,40,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorGreyUltraDark);
            }
            else
            {
               _loc2_ = 1;
               while(_loc2_ <= 5)
               {
                  _loc3_ = this.m_missionRatingMc.ratingIcons.getChildByName("icon" + _loc2_);
                  MenuUtils.setColor(_loc3_,MenuConstants.COLOR_GREY_ULTRA_DARK,false);
                  _loc2_++;
               }
            }
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
            Animate.kill(this.m_view.missionSummaryMc.lineMc_01);
            Animate.kill(this.m_view.missionSummaryMc.lineMc_02);
            Animate.to(this.m_view.missionSummaryMc.lineMc_01,0.3,0.1,{"alpha":0},Animate.ExpoOut);
            Animate.to(this.m_view.missionSummaryMc.lineMc_02,0.3,0.1,{"alpha":0},Animate.ExpoOut);
         }
         if(param1 == this.m_missionTimeMc)
         {
            Animate.kill(this.m_view.missionSummaryMc.lineMc_02);
            Animate.kill(this.m_view.missionSummaryMc.lineMc_03);
            Animate.to(this.m_view.missionSummaryMc.lineMc_02,0.3,0.1,{"alpha":0},Animate.ExpoOut);
            Animate.to(this.m_view.missionSummaryMc.lineMc_03,0.3,0.1,{"alpha":0},Animate.ExpoOut);
         }
         if(param1 == this.m_missionScoreMc)
         {
            Animate.kill(this.m_view.missionSummaryMc.lineMc_03);
            Animate.kill(this.m_view.missionSummaryMc.lineMc_04);
            Animate.to(this.m_view.missionSummaryMc.lineMc_03,0.3,0.1,{"alpha":0},Animate.ExpoOut);
            Animate.to(this.m_view.missionSummaryMc.lineMc_04,0.3,0.1,{"alpha":0},Animate.ExpoOut);
         }
      }
      
      private function showLeaderboardElement() : void
      {
         Animate.to(this.m_dottedLineLeaderBoard,0.3,0,{"alpha":1},Animate.ExpoOut);
         Animate.to(this.m_leaderboardMc,0.3,0.05,{"alpha":1},Animate.ExpoOut);
      }
      
      private function showLocationCompletion() : void
      {
         Animate.to(this.m_locationCompletionMc,0.3,0,{"alpha":1},Animate.ExpoOut);
      }
      
      private function animateProfileProgressionDuration() : Number
      {
         return this.m_barRewards.length * this.ANIMATE_REWARD_DURATION + 0.5;
      }
      
      private function animateProfileProgression() : void
      {
         var _loc3_:BarAnimationValues = null;
         if(this.m_profileBarValues.startXP >= this.m_profileBarValues.endXP || this.m_barRewards.length == 0)
         {
            this.animateSniperProgression();
            return;
         }
         var _loc1_:Number = this.animateProfileProgressionDuration();
         this.animateBarRewards(0);
         var _loc2_:BarAnimationValues = new BarAnimationValues();
         _loc2_.barView = this.m_profileMasteryMc.barFill;
         _loc2_.originalScale = this.m_profileBarOriginalScale;
         _loc2_.newLevelCallback = this.setLevelNumberProfile;
         _loc2_.levelInfo = this.m_profileLevelInfo;
         initBarValues(_loc2_,_loc1_,this.m_profileBarValues.startXP,this.m_profileBarValues.endXP);
         if(this.m_isUnlockableMasteryVisible && this.m_unlockableMasteryIsLocation)
         {
            _loc3_ = new BarAnimationValues();
            _loc3_.barView = this.m_unlockableMasteryMc.barFill;
            _loc3_.originalScale = this.m_unlockableBarOriginalScale;
            _loc3_.newLevelCallback = this.setLevelNumberUnlockable;
            _loc3_.levelInfo = this.m_locationLevelInfo;
            initBarValues(_loc3_,_loc1_,this.m_unlockableBarValues.startXP,this.m_unlockableBarValues.endXP);
         }
         Animate.delay(this.m_view,_loc1_,this.animateSniperProgression);
      }
      
      private function animateSniperProgression() : void
      {
         if(this.m_isUnlockableMasteryVisible && !this.m_unlockableMasteryIsLocation)
         {
            this.animateSniperUnlockableMastery();
         }
      }
      
      private function animateBarRewards(param1:int) : void
      {
         if(!this.m_tickSoundStarted)
         {
            this.playSound("ui_debrief_achievement_scorescreen_tick_lp");
            this.m_tickSoundStarted = true;
         }
         if(param1 >= this.m_barRewards.length)
         {
            if(this.m_tickSoundStarted)
            {
               this.playSound("ui_debrief_achievement_scorescreen_tick_lp_stop");
               this.m_tickSoundStarted = false;
            }
            this.setLevelInfoProfile("");
            return;
         }
         if(param1 == 0)
         {
            this.m_animateBarStartXp = this.m_profileBarValues.startXP;
            if(this.m_unlockableBarValues != null)
            {
               this.m_animateBarStartXpUnlockable = this.m_unlockableBarValues.startXP;
            }
         }
         Animate.kill(this.m_profileMasteryMc.infoTxt);
         this.m_profileMasteryMc.infoTxt.alpha = 0;
         var _loc2_:Object = this.m_barRewards[param1];
         var _loc3_:String = Localization.get(_loc2_.ChallengeName);
         var _loc4_:int = int(_loc2_.XPGain);
         var _loc5_:String = _loc3_ + " +" + MenuUtils.formatNumber(_loc4_) + " " + Localization.get("UI_PERFORMANCE_MASTERY_XP");
         this.setLevelInfoProfile(_loc5_);
         var _loc6_:Number = this.ANIMATE_REWARD_DURATION / 4;
         this.playSound("ui_debrief_scorescreen_progressbar_text");
         Animate.fromTo(this.m_profileMasteryMc.infoTxt,_loc6_,0,{
            "x":this.m_infoTxtOriginalPosX - 20,
            "alpha":0
         },{
            "x":this.m_infoTxtOriginalPosX,
            "alpha":1
         },Animate.ExpoOut);
         Animate.addFromTo(this.m_profileMasteryMc.infoTxt,_loc6_,_loc6_ * 3,{
            "x":this.m_infoTxtOriginalPosX,
            "alpha":1
         },{
            "x":this.m_infoTxtOriginalPosX + 20,
            "alpha":0
         },Animate.ExpoIn);
         Animate.delay(this.m_profileMasteryMc,this.ANIMATE_REWARD_DURATION,this.animateBarRewards,param1 + 1);
      }
      
      private function animateSniperUnlockableMastery() : void
      {
         Animate.kill(this.m_unlockableMasteryMc.infoTxt);
         this.m_unlockableMasteryMc.infoTxt.alpha = 0;
         var _loc1_:String = Localization.get("UI_MENU_MISSION_END_SCORE_TITLE_NO_COLON");
         var _loc2_:String = _loc1_ + " +" + MenuUtils.formatNumber(this.m_unlockableBarValues.xpTotalGain);
         this.setLevelInfoUnlockable(_loc2_);
         var _loc3_:Number = this.ANIMATE_UNLOCKABLE_MASTERY_DURATION / 4;
         this.playSound("ui_debrief_scorescreen_progressbar_text");
         Animate.fromTo(this.m_unlockableMasteryMc.infoTxt,_loc3_,0,{
            "x":this.m_infoTxtOriginalPosX - 20,
            "alpha":0
         },{
            "x":this.m_infoTxtOriginalPosX,
            "alpha":1
         },Animate.ExpoOut);
         Animate.addFromTo(this.m_unlockableMasteryMc.infoTxt,_loc3_,_loc3_ * 3,{
            "x":this.m_infoTxtOriginalPosX,
            "alpha":1
         },{
            "x":this.m_infoTxtOriginalPosX + 20,
            "alpha":0
         },Animate.ExpoIn);
         var _loc4_:BarAnimationValues;
         (_loc4_ = new BarAnimationValues()).barView = this.m_unlockableMasteryMc.barFill;
         _loc4_.originalScale = this.m_unlockableBarOriginalScale;
         _loc4_.newLevelCallback = this.setLevelNumberUnlockable;
         _loc4_.levelInfo = this.m_sniperUnlockableLevelInfo;
         initBarValues(_loc4_,this.ANIMATE_UNLOCKABLE_MASTERY_DURATION / 1.1,this.m_unlockableBarValues.startXP,this.m_unlockableBarValues.endXP);
      }
      
      private function setLevelInfoProfile(param1:String) : void
      {
         MenuUtils.setupTextUpper(this.m_profileMasteryMc.infoTxt,param1,18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
      }
      
      private function setLevelNumberProfile(param1:int) : void
      {
         var _loc3_:* = false;
         MenuUtils.setupText(this.m_profileMasteryMc.levelCurrentTxt,param1.toFixed(0),18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         var _loc2_:int = param1 + 1;
         MenuUtils.setupText(this.m_profileMasteryMc.levelNextTxt,_loc2_.toFixed(0),18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         if(this.m_useAnimation)
         {
            _loc3_ = param1 == this.m_profileBarValues.startLevelNr;
         }
         else
         {
            _loc3_ = param1 == this.m_profileBarValues.endLevelNr;
         }
         if(this.m_useAnimation && !_loc3_)
         {
            Animate.fromTo(this.m_profileMasteryMc.fx,0.5,0,{"alpha":1},{"alpha":0},Animate.ExpoOut);
         }
         this.setLevelNumberBadge(param1,_loc3_);
      }
      
      private function setLevelNumberBadge(param1:int, param2:Boolean) : void
      {
         MenuUtils.setupText(this.m_playerLevelMc.levelTxt,param1.toFixed(0),40,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
         this.m_playerLevelMc.levelTxt.autoSize = TextFieldAutoSize.CENTER;
         if(param2)
         {
            this.m_dottedLinePlayerName = new DottedLine(100,MenuConstants.COLOR_WHITE,DottedLine.TYPE_HORIZONTAL,1,2);
            this.m_dottedLinePlayerName.x = this.m_playerLevelMc.x - (this.m_dottedLinePlayerName.width >> 1);
            this.m_dottedLinePlayerName.y = this.m_playerLevelMc.y + (this.m_playerLevelMc.height >> 1) - 8;
            this.m_view.addChild(this.m_dottedLinePlayerName);
         }
         if(this.m_useAnimation)
         {
            Animate.fromTo(this.m_playerLevelMc,0.3,0,{
               "alpha":0,
               "scaleX":0,
               "scaleY":0
            },{
               "alpha":1,
               "scaleX":1,
               "scaleY":1
            },Animate.ExpoOut);
            if(param2)
            {
               switch(this.m_evergreenEndState)
               {
                  case "ScoringScreenEndState_MildCompleted":
                     this.playSound("ui_debrief_scorescreen_badge_evergreen_mild_completed");
                     break;
                  case "ScoringScreenEndState_MildFailed_Left":
                     this.playSound("ui_debrief_scorescreen_badge_evergreen_mild_failed_left");
                     break;
                  case "ScoringScreenEndState_MildFailed_Wounded":
                     this.playSound("ui_debrief_scorescreen_badge_evergreen_mild_failed_wounded");
                     break;
                  case "ScoringScreenEndState_CampaignCompleted":
                     this.playSound("ui_debrief_scorescreen_badge_evergreen_campaign_completed");
                     break;
                  case "ScoringScreenEndState_CampaignFailed":
                     this.playSound("ui_debrief_scorescreen_badge_evergreen_campaign_failed");
                     break;
                  default:
                     this.playSound("ui_debrief_scorescreen_badge_init");
               }
            }
            else
            {
               this.playSound("ui_debrief_scorescreen_levelup");
            }
         }
         this.m_badge.setLevel(param1,param2,this.m_useAnimation);
      }
      
      private function setLevelInfoUnlockable(param1:String) : void
      {
         MenuUtils.setupTextUpper(this.m_unlockableMasteryMc.infoTxt,param1,18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
      }
      
      private function setLevelNumberUnlockable(param1:int) : void
      {
         var _loc2_:String = param1.toFixed(0) + " / " + this.m_unlockableMaxLevel.toFixed(0);
         MenuUtils.setupText(this.m_unlockableMasteryMc.valueTxt,_loc2_,24,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         if(param1 != this.m_unlockableBarValues.startLevelNr)
         {
            if(this.m_useAnimation)
            {
               this.playSound("ui_debrief_scorescreen_progressbar_locationmastery_levelup");
            }
         }
      }
      
      private function setLocationProgression(param1:Object) : void
      {
         var _loc5_:Object = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:String = null;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc2_:Boolean = false;
         if(param1.LocationCompletionTitle != null)
         {
            _loc2_ = param1.LocationCompletionTitle != param1.ContractTitle && param1.contractTitle != "";
         }
         this.m_barViews = [];
         this.m_barViewsProgress = [];
         var _loc3_:Array = [];
         this.m_barViews.push(this.m_locationCompletionMc.bar1);
         this.m_barViews.push(this.m_locationCompletionMc.bar2);
         this.m_barViews.push(this.m_locationCompletionMc.bar3);
         var _loc4_:int = 0;
         while(_loc4_ < this.m_barViews.length)
         {
            this.m_barViews[_loc4_].visible = false;
            if(_loc2_)
            {
               this.m_barViews[_loc4_].y += this.m_locationCompletionMc.contractTitle.height - 7;
            }
            _loc4_++;
         }
         if(param1.OpportunityStatistics != null)
         {
            (_loc5_ = new Object()).Title = Localization.get("UI_BRIEFING_OPPORTUNITIES");
            _loc5_.Icon = "opportunitydiscovered";
            _loc5_.Completed = param1.OpportunityStatistics.Completed;
            _loc5_.PreviousCompleted = Math.max(0,_loc5_.Completed - this.m_opportunityCountGain);
            _loc5_.Count = param1.OpportunityStatistics.Count;
            if(_loc5_.Count > 0)
            {
               _loc3_.push(_loc5_);
            }
         }
         if(param1.ChallengeCompletion != null)
         {
            (_loc5_ = new Object()).Title = Localization.get("UI_MENU_PAGE_PLANNING_CHALLENGES");
            _loc5_.Icon = "challenge";
            _loc5_.Completed = param1.ChallengeCompletion.CompletedChallengesCount;
            _loc5_.PreviousCompleted = Math.max(0,_loc5_.Completed - this.m_challengeCountGain);
            _loc5_.Count = param1.ChallengeCompletion.ChallengesCount;
            if(_loc5_.Count > 0)
            {
               _loc3_.push(_loc5_);
            }
         }
         var _loc6_:* = _loc3_.length > 0;
         this.m_locationCompletionMc.visible = _loc6_;
         if(!_loc6_)
         {
            return;
         }
         MenuUtils.setupIcon(this.m_locationCompletionMc.icon,"stats",MenuConstants.COLOR_BLACK,false,true,MenuConstants.COLOR_WHITE);
         MenuUtils.setupTextUpper(this.m_locationCompletionMc.title,param1.LocationCompletionTitle,24,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         MenuUtils.setupText(this.m_locationCompletionMc.value,param1.LocationCompletionPercent,24,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         if(_loc2_)
         {
            this.m_locationCompletionMc.contractTitle.visible = true;
            MenuUtils.setupTextUpper(this.m_locationCompletionMc.contractTitle,param1.ContractTitle,19,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
            MenuUtils.truncateTextfield(this.m_locationCompletionMc.contractTitle,1,MenuConstants.FontColorWhite,CommonUtils.changeFontToGlobalIfNeeded(this.m_locationCompletionMc.contractTitle));
         }
         var _loc7_:int = 0;
         while(_loc7_ < _loc3_.length && _loc7_ < this.m_barViews.length)
         {
            _loc8_ = int(_loc3_[_loc7_].Count);
            _loc9_ = int(_loc3_[_loc7_].Completed);
            _loc10_ = int(_loc3_[_loc7_].PreviousCompleted);
            _loc11_ = _loc9_.toFixed(0) + " / " + _loc8_.toFixed(0);
            MenuUtils.setupTextUpper(this.m_barViews[_loc7_].title,_loc3_[_loc7_].Title,14,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorBlack);
            MenuUtils.setupText(this.m_barViews[_loc7_].value,_loc11_,14,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
            MenuUtils.addDropShadowFilter(this.m_barViews[_loc7_].value);
            MenuUtils.setupIcon(this.m_barViews[_loc7_].icon,_loc3_[_loc7_].Icon,MenuConstants.COLOR_BLACK,true,false);
            _loc12_ = Number(this.m_barViews[_loc7_].bg.scaleX);
            _loc13_ = Math.min(Math.max(0,_loc9_ / _loc8_),1);
            _loc14_ = Math.min(Math.max(0,_loc10_ / _loc8_),1);
            this.m_barViews[_loc7_].barCompleted.scaleX = _loc14_ * _loc12_;
            this.m_barViews[_loc7_].barCompletedNew.scaleX = 0;
            this.m_barViewsProgress.push({
               "hasProgression":_loc9_ > _loc10_,
               "newScaleX":_loc13_ * _loc12_
            });
            MenuUtils.setColor(this.m_barViews[_loc7_].bg,MenuConstants.COLOR_WHITE,true,0.1);
            MenuUtils.setColor(this.m_barViews[_loc7_].barCompleted,MenuConstants.COLOR_WHITE);
            MenuUtils.setColor(this.m_barViews[_loc7_].barCompletedNew,MenuConstants.COLOR_WHITE,true,0.5);
            this.m_barViews[_loc7_].visible = true;
            _loc7_++;
         }
      }
      
      private function showLocationProgression() : void
      {
         var _loc1_:Number = 0.1;
         var _loc2_:int = 0;
         while(_loc2_ < this.m_barViews.length && _loc2_ < this.m_barViewsProgress.length)
         {
            if(this.m_barViewsProgress[_loc2_].hasProgression)
            {
               if(this.m_useAnimation)
               {
                  Animate.to(this.m_barViews[_loc2_].barCompletedNew,0.3,_loc1_,{"scaleX":this.m_barViewsProgress[_loc2_].newScaleX},Animate.ExpoInOut);
                  _loc1_ += 0.1;
               }
               else
               {
                  this.m_barViews[_loc2_].barCompletedNew.scaleX = this.m_barViewsProgress[_loc2_].newScaleX;
               }
            }
            _loc2_++;
         }
      }
      
      private function formatNewBestTextFields(param1:MovieClip) : void
      {
         param1.newBestTitle.alpha = 0;
         param1.newBestFx.alpha = 0;
         param1.newBestBg.alpha = this.m_isEvergreen ? 1 : 0;
         param1.newBestTitle.autoSize = "left";
         param1.newBestTitle.multiline = true;
         param1.newBestTitle.wordWrap = true;
         param1.newBestTitle.width = 220;
      }
      
      public function playSound(param1:String) : void
      {
         ExternalInterface.call("PlaySound",param1);
      }
      
      private function killAllAnimations() : void
      {
         Animate.kill(this.m_view);
         Animate.kill(this.m_playerNameMc);
         Animate.kill(this.m_playerBadgeMc);
         Animate.kill(this.m_playerLevelMc);
         Animate.kill(this.m_playerNameMc);
         Animate.kill(this.m_dottedLineProfileMastery);
         Animate.kill(this.m_profileMasteryMc);
         Animate.kill(this.m_dottedLineUnlockableMastery);
         Animate.kill(this.m_unlockableMasteryMc);
         Animate.kill(this.m_missionTimeMc);
         Animate.kill(this.m_missionScoreMc);
         Animate.kill(this.m_view.missionSummaryMc.lineMc_01);
         Animate.kill(this.m_view.missionSummaryMc.lineMc_02);
         Animate.kill(this.m_view.missionSummaryMc.lineMc_03);
         Animate.kill(this.m_view.missionSummaryMc.lineMc_04);
         Animate.kill(this.m_missionRatingMc);
         Animate.kill(this.m_missionTimeMc);
         Animate.kill(this.m_missionScoreMc);
         Animate.kill(this.m_dottedLineMissionSummary);
         Animate.kill(this.m_silentAssassinMc);
         Animate.kill(this.m_playstyleDelaySprite);
         Animate.kill(this.m_silentAssassinMc.bg);
         Animate.kill(this.m_silentAssassinMc.title);
         Animate.kill(this.m_silentAssassinMc.fx);
         Animate.kill(this.m_playStyleMc);
         Animate.kill(this.m_playstyleDelaySprite);
         Animate.kill(this.m_playStyleMc.bg);
         Animate.kill(this.m_playStyleMc.title);
         Animate.kill(this.m_playStyleMc.fx);
         Animate.kill(this.m_missionRatingMc.newBestTitle);
         Animate.kill(this.m_missionRatingMc.newBestFx);
         Animate.kill(this.m_missionRatingMc.newBestBg);
         Animate.kill(this.m_missionTimeMc.newBestTitle);
         Animate.kill(this.m_missionTimeMc.newBestFx);
         Animate.kill(this.m_missionTimeMc.newBestBg);
         Animate.kill(this.m_missionScoreMc.newBestTitle);
         Animate.kill(this.m_missionScoreMc.newBestFx);
         Animate.kill(this.m_missionScoreMc.newBestBg);
         Animate.kill(this.m_newBestDelaySprite);
         Animate.kill(this.m_view.missionSummaryMc.lineMc_01);
         Animate.kill(this.m_view.missionSummaryMc.lineMc_02);
         Animate.kill(this.m_view.missionSummaryMc.lineMc_03);
         Animate.kill(this.m_view.missionSummaryMc.lineMc_04);
         Animate.kill(this.m_dottedLineLeaderBoard);
         Animate.kill(this.m_leaderboardMc);
         Animate.kill(this.m_locationCompletionMc);
         Animate.kill(this.m_profileMasteryMc);
         Animate.kill(this.m_profileMasteryMc.infoTxt);
         Animate.kill(this.m_unlockableMasteryMc.infoTxt);
         Animate.kill(this.m_profileMasteryMc.fx);
         Animate.kill(this.m_playerLevelMc);
         Animate.kill(this.m_profileMasteryMc.barFill);
         Animate.kill(this.m_unlockableMasteryMc.barFill);
         var _loc1_:int = 0;
         while(_loc1_ < this.m_barViews.length)
         {
            Animate.kill(this.m_barViews[_loc1_].barCompletedNew);
            _loc1_++;
         }
      }
      
      override public function onUnregister() : void
      {
         if(this.m_view)
         {
            this.killAllAnimations();
            if(this.m_tickSoundStarted)
            {
               this.playSound("ui_debrief_achievement_scorescreen_tick_lp_stop");
               this.m_tickSoundStarted = false;
            }
            removeChild(this.m_view);
            this.m_view = null;
         }
         super.onUnregister();
      }
   }
}

class BarValues
{
    
   
   public var xpTotalGain:Number = 0;
   
   public var startXP:Number = 0;
   
   public var endXP:Number = 0;
   
   public var startLevelNr:int = 1;
   
   public var endLevelNr:int = 1;
   
   public var startBarProgress:Number = 0;
   
   public var endBarProgress:Number = 0;
   
   public function BarValues()
   {
      super();
   }
}

import flash.display.Sprite;
import menu3.missionend.LevelInfo;

class BarAnimationValues
{
    
   
   public var barView:Sprite = null;
   
   public var originalScale:Number = 1;
   
   public var newLevelCallback:Function = null;
   
   public var levelInfo:LevelInfo;
   
   public function BarAnimationValues()
   {
      super();
   }
}
