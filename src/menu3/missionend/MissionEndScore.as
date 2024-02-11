// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.missionend.MissionEndScore

package menu3.missionend {
import menu3.MenuElementBase;

import flash.display.Sprite;

import basic.DottedLine;

import menu3.basic.Badge;

import flash.display.MovieClip;

import hud.evergreen.CampaignProgress;

import common.menu.MenuConstants;
import common.Animate;
import common.menu.MenuUtils;
import common.Localization;
import common.CommonUtils;

import flash.text.TextFormat;
import flash.text.TextField;
import flash.text.TextFormatAlign;
import flash.text.TextFieldAutoSize;
import flash.utils.getTimer;
import flash.external.ExternalInterface;

public dynamic class MissionEndScore extends MenuElementBase {

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
	private var m_barRewards:Array = [];
	private var m_barViews:Array = [];
	private var m_barViewsProgress:Array = [];
	private var m_infoTxtOriginalPosX:Number = 0;
	private var m_profileBarOriginalScale:Number = 1;
	private var m_unlockableBarOriginalScale:Number = 1;
	private var m_opportunityCountGain:int = 0;
	private var m_challengeCountGain:int = 0;
	private var m_hideLocationProgression:Boolean = true;
	private var m_isUnlockableMasteryVisible:Boolean = false;
	private var m_animateBarStartXp:Number = 0;
	private var m_animateBarStartXpUnlockable:Number = 0;
	private var m_newBestDelaySprite:Sprite = new Sprite();
	private var m_playstyleDelaySprite:Sprite = new Sprite();
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

	public function MissionEndScore(_arg_1:Object) {
		super(_arg_1);
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
		this.m_dottedLineProfileMastery = new DottedLine(this.VIEW_WIDTH, MenuConstants.COLOR_WHITE, DottedLine.TYPE_HORIZONTAL, 1, 2);
		this.m_dottedLineProfileMastery.alpha = 0;
		this.m_dottedLineProfileMastery.y = 567;
		this.m_dottedLineUnlockableMastery = new DottedLine(this.VIEW_WIDTH, MenuConstants.COLOR_WHITE, DottedLine.TYPE_HORIZONTAL, 1, 2);
		this.m_dottedLineUnlockableMastery.alpha = 0;
		this.m_dottedLineUnlockableMastery.y = 647;
		this.m_dottedLineMissionSummary = new DottedLine(this.VIEW_WIDTH, MenuConstants.COLOR_WHITE, DottedLine.TYPE_HORIZONTAL, 1, 2);
		this.m_dottedLineMissionSummary.alpha = 0;
		this.m_dottedLineMissionSummary.y = 759;
		this.m_dottedLineLeaderBoard = new DottedLine(this.VIEW_WIDTH, MenuConstants.COLOR_WHITE, DottedLine.TYPE_HORIZONTAL, 1, 2);
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

	private static function getFinalBarScale(_arg_1:Number, _arg_2:Number):Number {
		var _local_3:Number = (_arg_1 % 1);
		return (_local_3 * _arg_2);
	}

	private static function createBarValues(_arg_1:Object, _arg_2:LevelInfo, _arg_3:Number):BarValues {
		var _local_4:Boolean = _arg_2.isLevelMaxed(_arg_1.XP);
		var _local_5:Number = _arg_3;
		if (_local_4) {
			_local_5 = Math.min(_arg_1.XPGain, _local_5);
		}
		;
		var _local_6:BarValues = new BarValues();
		_local_6.xpTotalGain = _local_5;
		_local_6.endXP = _arg_1.XP;
		_local_6.startXP = (_local_6.endXP - _local_5);
		var _local_7:Number = _arg_2.getLevelFromList(_local_6.startXP);
		_local_6.startLevelNr = int(_local_7);
		_local_6.startBarProgress = (_local_7 % 1);
		var _local_8:Number = _arg_2.getLevelFromList(_local_6.endXP);
		_local_6.endLevelNr = int(_local_8);
		_local_6.endBarProgress = (_local_8 % 1);
		var _local_9:Boolean = _arg_2.isLevelMaxed(_local_6.endXP);
		if (_local_9) {
			_local_6.endBarProgress = 1;
		}
		;
		return (_local_6);
	}

	private static function initBarValues(_arg_1:BarAnimationValues, _arg_2:Number, _arg_3:Number, _arg_4:Number):void {
		if (_arg_1.levelInfo == null) {
			return;
		}
		;
		var _local_5:Boolean = _arg_1.levelInfo.isLevelMaxed(_arg_3);
		if (_local_5) {
			_arg_1.barView.scaleX = _arg_1.originalScale;
			return;
		}
		;
		var _local_6:Number = _arg_1.levelInfo.getLevelFromList(_arg_3);
		var _local_7:Number = _arg_1.levelInfo.getLevelFromList(_arg_4);
		var _local_8:int = int(_local_6);
		var _local_9:Number = (_local_7 - _local_8);
		var _local_10:Number = (_arg_2 / (_local_7 - _local_6));
		var _local_11:Number = (_local_7 % 1);
		var _local_12:Boolean = _arg_1.levelInfo.isLevelMaxed(_arg_4);
		if (_local_12) {
			_local_11 = 1;
		}
		;
		animateBarFill(_arg_1, _local_8, _local_9, _local_11, _local_10);
	}

	private static function animateBarFill(barAniValues:BarAnimationValues, currentLevelNr:int, fillingsLeft:Number, endBarProgress:Number, speed:Number):void {
		var nextFillingsLeft:Number;
		var duration:Number = 0;
		var currentBarProgress:Number = Math.max(0, Math.min((barAniValues.barView.scaleX / barAniValues.originalScale), 1));
		if (fillingsLeft >= 1) {
			duration = ((1 - currentBarProgress) * speed);
			nextFillingsLeft = (fillingsLeft - 1);
			Animate.to(barAniValues.barView, duration, 0, {"scaleX": barAniValues.originalScale}, Animate.Linear, function ():void {
				var _local_1:int = (currentLevelNr + 1);
				if (barAniValues.newLevelCallback != null) {
					barAniValues.newLevelCallback(_local_1);
				}
				;
				if (((endBarProgress == 1) && (fillingsLeft == 1))) {
					return;
				}
				;
				barAniValues.barView.scaleX = 0;
				animateBarFill(barAniValues, _local_1, nextFillingsLeft, endBarProgress, speed);
			});
			return;
		}
		;
		duration = (Math.max(0, Math.min((endBarProgress - currentBarProgress), 1)) * speed);
		var targetScale:Number = (endBarProgress * barAniValues.originalScale);
		Animate.to(barAniValues.barView, duration, 0, {"scaleX": targetScale}, Animate.Linear);
	}


	private function resetVisibility():void {
		var _local_1:* = (!(ControlsMain.isVrModeActive()));
		this.m_missionRatingMc.newBestFx.visible = _local_1;
		this.m_missionTimeMc.newBestFx.visible = _local_1;
		this.m_missionScoreMc.newBestFx.visible = _local_1;
		this.m_playerBadgeMc.alpha = 0;
		this.m_playerLevelMc.alpha = 0;
		this.m_playerLevelMc.levelBg.visible = false;
		this.m_playerNameMc.alpha = 0;
		this.m_profileMasteryMc.alpha = 0;
		this.m_profileMasteryMc.fx.alpha = 0;
		this.m_profileMasteryMc.fx.visible = _local_1;
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
		this.m_silentAssassinMc.fx.visible = _local_1;
		this.m_playStyleMc.alpha = 0;
		this.m_playStyleMc.fx.alpha = 0;
		this.m_playStyleMc.fx.visible = _local_1;
		this.m_leaderboardMc.alpha = 0;
		this.m_locationCompletionMc.alpha = 0;
		this.m_locationCompletionMc.contractTitle.visible = false;
		this.m_dottedLineProfileMastery.alpha = 0;
		this.m_dottedLineUnlockableMastery.alpha = 0;
		this.m_dottedLineMissionSummary.alpha = 0;
		this.m_dottedLineLeaderBoard.alpha = 0;
		if (this.m_dottedLinePlayerName) {
			this.m_dottedLinePlayerName.alpha = 0;
		}
		;
		this.m_evergreenCampaignView.alpha = 0;
	}

	override public function onSetData(_arg_1:Object):void {
		var _local_10:int;
		var _local_11:Object;
		var _local_12:int;
		var _local_13:Object;
		var _local_14:int;
		var _local_15:MovieClip;
		var _local_16:String;
		var _local_17:String;
		var _local_18:Number;
		var _local_19:String;
		var _local_20:int;
		var _local_21:String;
		var _local_22:String;
		var _local_23:String;
		var _local_24:String;
		var _local_25:String;
		var _local_26:String;
		super.onSetData(_arg_1);
		this.m_isOnline = ((_arg_1.isonline != null) ? _arg_1.isonline : false);
		this.m_useAnimation = ((_arg_1.animate != null) ? _arg_1.animate : true);
		this.m_animationStarted = false;
		this.m_isEvergreen = (_arg_1.ContractType == "evergreen");
		if (this.m_isEvergreen) {
			this.m_evergreenEndState = _arg_1.EvergreenEndState;
			this.m_evergreenAnimation = this.m_useAnimation;
		} else {
			this.m_evergreenAnimation = false;
		}
		;
		this.m_isSniper = (_arg_1.ContractType == "sniper");
		this.m_isUnlockableMasteryVisible = false;
		this.m_isVersus = ((_arg_1.isversus != null) ? _arg_1.isversus : false);
		this.m_isWinner = ((_arg_1.iswinner != null) ? _arg_1.iswinner : false);
		this.m_isWinnerMsg = ((_arg_1.winnertext != null) ? _arg_1.winnertext : "");
		this.m_actionXPGain = 0;
		this.m_challengeXPGain = 0;
		this.m_challengeCountGain = 0;
		this.m_barRewards.length = 0;
		if ((((!(this.m_isEvergreen)) && (!(_arg_1.IsNewBestScore == null))) && (_arg_1.IsNewBestScore))) {
			this.m_isNewBestScore = true;
			MenuUtils.setupTextUpper(this.m_missionScoreMc.newBestTitle, Localization.get("UI_RATING_NEW_PERSONAL BEST"), 14, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraDark);
		}
		;
		if ((((!(this.m_isEvergreen)) && (!(_arg_1.IsNewBestTime == null))) && (_arg_1.IsNewBestTime))) {
			this.m_isNewBestTime = true;
			MenuUtils.setupTextUpper(this.m_missionTimeMc.newBestTitle, Localization.get("UI_RATING_NEW_PERSONAL BEST"), 14, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraDark);
		}
		;
		if ((((!(this.m_isEvergreen)) && (!(_arg_1.IsNewBestStars == null))) && (_arg_1.IsNewBestStars))) {
			this.m_isNewBestRating = true;
			MenuUtils.setupTextUpper(this.m_missionRatingMc.newBestTitle, Localization.get("UI_RATING_NEW_PERSONAL BEST"), 14, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraDark);
		}
		;
		if (((_arg_1.Challenges) && (_arg_1.Challenges.length > 0))) {
			_local_10 = 0;
			while (_local_10 < _arg_1.Challenges.length) {
				_local_11 = _arg_1.Challenges[_local_10];
				_local_12 = 0;
				if (_local_11.XPGain != undefined) {
					_local_12 = _local_11.XPGain;
				}
				;
				if (_local_11.IsActionReward === true) {
					if (_local_12 > 0) {
						this.m_barRewards.push(_local_11);
						this.m_actionXPGain = (this.m_actionXPGain + _local_12);
					}
					;
				} else {
					this.m_challengeCountGain++;
					this.m_challengeXPGain = (this.m_challengeXPGain + _local_12);
				}
				;
				_local_10++;
			}
			;
		}
		;
		if (this.m_challengeXPGain > 0) {
			_local_13 = new Object();
			_local_13.ChallengeName = "UI_MENU_PAGE_PLANNING_CHALLENGES";
			_local_13.XPGain = this.m_challengeXPGain;
			this.m_barRewards.unshift(_local_13);
		}
		;
		if (_arg_1.player != null) {
			MenuUtils.setupText(this.m_playerNameMc.labelTxt, _arg_1.player, 60, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
			CommonUtils.changeFontToGlobalIfNeeded(this.m_playerNameMc.labelTxt);
			MenuUtils.truncateTextfieldWithCharLimit(this.m_playerNameMc.labelTxt, 1, MenuConstants.PLAYERNAME_MIN_CHAR_COUNT, MenuConstants.FontColorWhite);
			MenuUtils.shrinkTextToFit(this.m_playerNameMc.labelTxt, this.m_playerNameMc.labelTxt.width, -1);
		}
		;
		if (!this.m_isOnline) {
			this.resetVisibility();
			this.m_view.offlineTxt.visible = true;
			MenuUtils.setupText(this.m_view.offlineTxt, Localization.get("UI_DIALOG_SCORE_OFFLINE"), 26, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
			Animate.to(this.m_playerNameMc, 0.3, 0.1, {"alpha": 1}, Animate.ExpoOut);
			return;
		}
		;
		if (_arg_1.LocationProgression != null) {
			this.m_locationLevelInfo = new LevelInfo();
			this.m_locationLevelInfo.init(_arg_1.LocationProgression.LevelInfo, 0);
		}
		;
		if (_arg_1.UnlockableProgression != null) {
			this.m_sniperUnlockableLevelInfo = new LevelInfo();
			this.m_sniperUnlockableLevelInfo.init(_arg_1.UnlockableProgression.LevelInfo, 0);
		}
		;
		this.m_hideLocationProgression = true;
		if (_arg_1.CompletionData != null) {
			this.m_hideLocationProgression = (_arg_1.CompletionData.HideProgression === true);
		}
		;
		this.m_profileBarValues = new BarValues();
		this.m_profileMasteryMc.barFill.scaleX = 0;
		this.m_xpTotal = (this.m_challengeXPGain + this.m_actionXPGain);
		if (_arg_1.ProfileProgression != null) {
			this.m_profileLevelInfo = new LevelInfo();
			_local_14 = ((_arg_1.ProfileProgression.LevelInfoOffset != undefined) ? _arg_1.ProfileProgression.LevelInfoOffset : 0);
			this.m_profileLevelInfo.init(_arg_1.ProfileProgression.LevelInfo, _local_14);
			this.m_profileBarValues = createBarValues(_arg_1.ProfileProgression, this.m_profileLevelInfo, this.m_xpTotal);
			MenuUtils.setColor(this.m_profileMasteryMc.barBg, MenuConstants.COLOR_WHITE, true, 0.1);
			MenuUtils.setColor(this.m_profileMasteryMc.barFill, MenuConstants.COLOR_WHITE);
			this.m_profileMasteryMc.barFill.scaleX = (this.m_profileBarValues.startBarProgress * this.m_profileBarOriginalScale);
		}
		;
		this.setLevelInfoProfile("");
		if (this.m_isEvergreen) {
			this.m_view.missionSummaryMc.lineMc_01.alpha = 0;
			this.m_view.missionSummaryMc.lineMc_02.alpha = 0;
			this.m_view.missionSummaryMc.lineMc_03.alpha = 0;
			this.m_view.missionSummaryMc.lineMc_04.alpha = 0;
		}
		;
		this.m_showRating = ((_arg_1.showrating != undefined) ? _arg_1.showrating : (!(_arg_1.rating == null)));
		this.m_ratingScore = ((_arg_1.rating != null) ? _arg_1.rating : 0);
		if (this.m_isEvergreen) {
			this.m_showRating = false;
		}
		;
		var _local_2:Boolean;
		this.m_isSilentAssassin = (this.m_ratingScore >= 5);
		if (_arg_1.silentAssassin != null) {
			this.m_isSilentAssassin = _arg_1.silentAssassin;
		} else {
			if (_arg_1.MedicineMan != null) {
				this.m_isSilentAssassin = _arg_1.MedicineMan;
				_local_2 = true;
			}
			;
		}
		;
		if (((!(_arg_1.PlayStyle == null)) && ((_arg_1.EvergreenFailed == null) || (!(_arg_1.EvergreenFailed))))) {
			MenuUtils.setupTextAndShrinkToFitUpper(this.m_playStyleMc.title, _arg_1.PlayStyle.Name, 28, MenuConstants.FONT_TYPE_MEDIUM, this.m_playStyleMc.title.width, -1, 15, MenuConstants.FontColorGreyUltraDark);
			this.m_playStyleSoundId = ("ui_debrief_scorescreen_playstyle_sweetener_" + _arg_1.PlayStyle.Type);
			this.m_hasPlayStyle = true;
		} else {
			this.m_hasPlayStyle = false;
		}
		;
		var _local_3:int = 1;
		while (_local_3 <= 5) {
			_local_15 = this.m_missionRatingMc.ratingIcons.getChildByName(("icon" + _local_3));
			MenuUtils.setColor(_local_15, MenuConstants.COLOR_WHITE, true, ((this.m_showRating) ? 0.1 : 0));
			_local_3++;
		}
		;
		if (_local_2) {
			MenuUtils.setupTextUpper(this.m_silentAssassinMc.title, Localization.get("UI_RATING_MEDICINE_MAN").toUpperCase(), 28, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			MenuUtils.setColor(this.m_silentAssassinMc.bg, MenuConstants.COLOR_BLUE);
		} else {
			MenuUtils.setupTextUpper(this.m_silentAssassinMc.title, Localization.get("UI_RATING_SILENT_ASSASSIN").toUpperCase(), 28, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			MenuUtils.setColor(this.m_silentAssassinMc.bg, MenuConstants.COLOR_RED);
		}
		;
		if (!this.m_isEvergreen) {
			_local_16 = Localization.get("UI_MENU_MISSION_END_RATING_TITLE");
			MenuUtils.setupTextUpper(this.m_missionRatingMc.ratingTitle, _local_16, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorRed);
			if (((this.m_showRating == false) && (!(_arg_1.challengeMultiplier == null)))) {
				this.m_hasChallengeMultiplier = true;
				_local_17 = (Localization.get("UI_SNIPERSCORING_SUMMARY_MULTIPLIER") + ":");
				MenuUtils.setupTextAndShrinkToFitUpper(this.m_missionRatingMc.ratingTitle, _local_17, 18, MenuConstants.FONT_TYPE_MEDIUM, this.m_missionRatingMc.ratingTitle.width, -1, 15, MenuConstants.FontColorRed);
				_local_18 = _arg_1.challengeMultiplier;
				MenuUtils.setupText(this.m_missionRatingMc.ratingValue, _local_18.toFixed(2), 40, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			}
			;
		} else {
			_local_19 = Localization.get("EVERGREEN_GAMEFLOW_XPGAINED_TITLE");
			MenuUtils.setupTextUpper(this.m_missionRatingMc.ratingTitle, _local_19, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorRed);
			if (this.m_evergreenAnimation) {
				this.m_xpAnimatedValue = 0;
			} else {
				this.m_xpAnimatedValue = this.m_xpTotal;
			}
			;
			MenuUtils.setupText(this.m_missionRatingMc.ratingValue, this.formatXpNumber(this.m_xpAnimatedValue), 40, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorBlack);
			this.m_missionRatingMc.newBestBg.alpha = 1;
		}
		;
		var _local_4:int;
		var _local_5:Array = _arg_1.scoreSummary;
		if (_local_5 != null) {
			_local_20 = 0;
			while (_local_20 < _local_5.length) {
				if (_local_5[_local_20].type == "summary") {
					if (_local_5[_local_20].headline == "UI_SCORING_SUMMARY_TIME") {
						this.m_timeTotal = this.timeFromString(_local_5[_local_20].count);
					} else {
						if (_local_5[_local_20].headline == "UI_SNIPERSCORING_SUMMARY_TIME_BONUS") {
							this.m_timeTotal = this.timeFromStringSniper(_local_5[_local_20].count);
						}
						;
					}
					;
				} else {
					if (_local_5[_local_20].type == "total") {
						_local_4 = _local_5[_local_20].scoreTotal;
					}
					;
				}
				;
				_local_20++;
			}
			;
		}
		;
		if (this.m_evergreenAnimation) {
			this.m_timeAnimatedValue = 0;
		} else {
			this.m_timeAnimatedValue = this.m_timeTotal;
		}
		;
		var _local_6:String = Localization.get("UI_MENU_MISSION_END_TIME_TITLE");
		MenuUtils.setupTextUpper(this.m_missionTimeMc.timeTitle, _local_6, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorRed);
		MenuUtils.setupText(this.m_missionTimeMc.timeValue, this.formatTime(this.m_timeAnimatedValue), 40, MenuConstants.FONT_TYPE_MEDIUM, ((this.m_isEvergreen) ? MenuConstants.FontColorBlack : MenuConstants.FontColorWhite));
		CommonUtils.changeFontToGlobalFont(this.m_missionTimeMc.timeValue);
		if (this.m_isEvergreen) {
			this.m_missionTimeMc.newBestBg.alpha = 1;
		}
		;
		if (!this.m_isEvergreen) {
			_local_21 = Localization.get("UI_MENU_MISSION_END_SCORE_TITLE");
			MenuUtils.setupTextUpper(this.m_missionScoreMc.scoreTitle, _local_21, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorRed);
			if (this.m_isVersus) {
				MenuUtils.setupText(this.m_missionScoreMc.scoreValue, _arg_1.finalscore, 40, MenuConstants.FONT_TYPE_MEDIUM, ((this.m_isNewBestScore) ? MenuConstants.FontColorGreyUltraDark : MenuConstants.FontColorWhite));
			} else {
				MenuUtils.setupText(this.m_missionScoreMc.scoreValue, MenuUtils.formatNumber(_local_4), 40, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			}
			;
		} else {
			this.m_payoutTotal = ((_arg_1.EvergreenPayout) ? _arg_1.EvergreenPayout : 0);
			if (this.m_evergreenAnimation) {
				this.m_payoutAnimatedValue = 0;
			} else {
				this.m_payoutAnimatedValue = this.m_payoutTotal;
			}
			;
			if (this.m_payoutTotal < 0) {
				_local_22 = Localization.get("EVERGREEN_GAMEFLOW_MISSIONPAYOUT_LOST_TITLE");
				MenuUtils.setupTextUpper(this.m_missionScoreMc.scoreTitle, _local_22, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
				_local_23 = (MenuUtils.formatNumber(this.m_payoutAnimatedValue) + Localization.get("UI_EVERGREEN_MERCES"));
				MenuUtils.setupText(this.m_missionScoreMc.scoreValue, _local_23, 40, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
				this.m_missionScoreMc.newBestBg.alpha = 0;
				this.m_missionScoreMc.newBestBgNegative.alpha = 1;
			} else {
				_local_22 = Localization.get("EVERGREEN_GAMEFLOW_MISSIONPAYOUT_TITLE");
				MenuUtils.setupTextUpper(this.m_missionScoreMc.scoreTitle, _local_22, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorRed);
				_local_23 = (MenuUtils.formatNumber(this.m_payoutAnimatedValue) + Localization.get("UI_EVERGREEN_MERCES"));
				MenuUtils.setupText(this.m_missionScoreMc.scoreValue, _local_23, 40, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorBlack);
				this.m_missionScoreMc.newBestBg.alpha = 1;
				this.m_missionScoreMc.newBestBgNegative.alpha = 0;
			}
			;
		}
		;
		if (this.m_isEvergreen) {
			this.m_evergreenCampaignView.alpha = 1;
			this.m_evergreenCampaignView.x = 348;
			this.m_evergreenCampaignView.y = 802;
			this.m_evergreenCampaignView.waitWithAnimation = this.m_evergreenAnimation;
			this.m_evergreenCampaignView.onSetData(_arg_1.EvergreenCampaignProgress);
			this.m_dottedLineLeaderBoard.alpha = 1;
			this.m_dottedLineLeaderBoard.y = 868;
			this.m_locationCompletionMc.y = 872;
		}
		;
		var _local_7:* = "";
		var _local_8:* = "unlocked";
		this.m_unlockableBarValues = null;
		this.m_unlockableMaxLevel = 1;
		this.m_unlockableMasteryIsLocation = false;
		if ((((!(this.m_hideLocationProgression)) && (!(this.m_locationLevelInfo == null))) && (!(_arg_1.LocationProgression == null)))) {
			this.m_unlockableBarValues = createBarValues(_arg_1.LocationProgression, this.m_locationLevelInfo, this.m_xpTotal);
			if (!this.m_isEvergreen) {
				_local_7 = Localization.get("UI_MENU_PAGE_PROFILE_LOCATION_MASTERY");
			} else {
				_local_7 = Localization.get("EVERGREEN_GAMEFLOW_MASTERY_TITLE");
			}
			;
			this.m_unlockableMaxLevel = this.m_locationLevelInfo.getMaxLevel();
			this.m_unlockableMasteryIsLocation = true;
		} else {
			if (((!(this.m_sniperUnlockableLevelInfo == null)) && (!(_arg_1.UnlockableProgression == null)))) {
				this.m_unlockableBarValues = createBarValues(_arg_1.UnlockableProgression, this.m_sniperUnlockableLevelInfo, _local_4);
				_local_7 = Localization.get(_arg_1.UnlockableProgression.Name);
				this.m_unlockableMaxLevel = this.m_sniperUnlockableLevelInfo.getMaxLevel();
			}
			;
		}
		;
		if (this.m_unlockableBarValues != null) {
			this.m_isUnlockableMasteryVisible = true;
			MenuUtils.setColor(this.m_unlockableMasteryMc.barBg, MenuConstants.COLOR_WHITE, true, 0.1);
			MenuUtils.setColor(this.m_unlockableMasteryMc.barFill, MenuConstants.COLOR_WHITE);
			this.m_unlockableMasteryMc.barFill.scaleX = (this.m_unlockableBarOriginalScale * this.m_unlockableBarValues.startBarProgress);
			MenuUtils.setupIcon(this.m_unlockableMasteryMc.icon, "unlocked", MenuConstants.COLOR_BLACK, false, true, MenuConstants.COLOR_WHITE);
			MenuUtils.setupTextUpper(this.m_unlockableMasteryMc.title, _local_7, 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorRed);
			this.setLevelNumberUnlockable(this.m_unlockableBarValues.startLevelNr);
		}
		;
		this.m_hasLeaderboard = ((!(_arg_1.LeaderboardFriendsInfo == null)) || (!(_arg_1.LeaderboardInfo == null)));
		if (this.m_hasLeaderboard) {
			_local_24 = Localization.get("UI_MENU_PAGE_LEADERBOARDS_TITLE");
			_local_25 = ((_local_24 + " ") + Localization.get("UI_MENU_PAGE_LEADERBOARDS_FILTER_FRIENDS"));
			_local_26 = ((_local_24 + " ") + Localization.get("UI_MENU_PAGE_LEADERBOARDS_FILTER_GLOBAL"));
			if (_arg_1.LeaderboardFriendsInfo != null) {
				MenuUtils.setupTextUpper(this.m_leaderboardMc.friendsTxt, _local_25, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorRed);
				MenuUtils.setupTextUpper(this.m_leaderboardMc.friendsTxt, (" " + _arg_1.LeaderboardFriendsInfo), 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite, true);
			}
			;
			if (_arg_1.LeaderboardInfo != null) {
				MenuUtils.setupTextUpper(this.m_leaderboardMc.globalTxt, _local_26, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorRed);
				MenuUtils.setupTextUpper(this.m_leaderboardMc.globalTxt, (" " + _arg_1.LeaderboardInfo), 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite, true);
			}
			;
		}
		;
		var _local_9:Array = _arg_1.OpportunityRewards;
		this.m_opportunityCountGain = ((_local_9 != null) ? _local_9.length : 0);
		this.setLocationProgression(_arg_1);
	}

	private function formatXpNumber(_arg_1:int):String {
		return ((MenuUtils.formatNumber(_arg_1) + " ") + Localization.get("UI_PERFORMANCE_MASTERY_XP"));
	}

	private function formatTime(_arg_1:int):String {
		if (this.m_isSniper) {
			return (this.formatTimeSniper(_arg_1));
		}
		;
		var _local_2:* = "";
		var _local_3:int = int((_arg_1 / 3600));
		_local_2 = (_local_2 + (((_local_3 < 10) ? "0" : "") + _local_3));
		var _local_4:int = int(((_arg_1 / 60) % 60));
		_local_2 = (_local_2 + (((_local_4 < 10) ? ":0" : ":") + _local_4));
		var _local_5:int = (_arg_1 % 60);
		_local_2 = (_local_2 + (((_local_5 < 10) ? ":0" : ":") + _local_5));
		return (('<font face="$global">' + _local_2) + "</font>");
	}

	private function formatTimeSniper(_arg_1:int):String {
		var _local_2:* = "";
		var _local_3:int = int((_arg_1 / 60000));
		_local_2 = (_local_2 + (((_local_3 < 10) ? "0" : "") + _local_3));
		var _local_4:int = int(((_arg_1 / 1000) % 60));
		_local_2 = (_local_2 + (((_local_4 < 10) ? ":0" : ":") + _local_4));
		var _local_5:int = (_arg_1 % 1000);
		_local_2 = (_local_2 + (((_local_5 < 100) ? ((_local_5 < 10) ? ".00" : ".0") : ".") + _local_5));
		return (('<font face="$global">' + _local_2) + "</font>");
	}

	private function timeFromString(_arg_1:String):int {
		if (_arg_1.length < 8) {
			return (0);
		}
		;
		var _local_2:int = (_arg_1.length - 8);
		return (((parseInt(_arg_1.substr(0, (_local_2 + 2))) * 3600) + (parseInt(_arg_1.substr((_local_2 + 3), 2)) * 60)) + parseInt(_arg_1.substr((_local_2 + 6), 2)));
	}

	private function timeFromStringSniper(_arg_1:String):int {
		if (_arg_1.length != 9) {
			return (0);
		}
		;
		return (((parseInt(_arg_1.substr(0, 2)) * 60000) + (parseInt(_arg_1.substr(3, 2)) * 1000)) + parseInt(_arg_1.substr(6, 3)));
	}

	public function startAnimation():void {
		if (((!(this.m_isOnline)) || (this.m_animationStarted))) {
			return;
		}
		;
		this.m_animationStarted = true;
		Animate.kill(this.m_view);
		var _local_1:Number = ((this.m_useAnimation) ? 0.1 : 0.05);
		var _local_2:Number = 0.1;
		Animate.delay(this.m_view, _local_2, this.showPlayerInfo);
		_local_2 = (_local_2 + _local_1);
		Animate.delay(this.m_view, _local_2, this.showProfileMastery);
		if (this.m_isUnlockableMasteryVisible) {
			_local_2 = (_local_2 + _local_1);
			Animate.delay(this.m_view, _local_2, this.showUnlockableMastery);
		}
		;
		_local_2 = (_local_2 + _local_1);
		Animate.delay(this.m_view, _local_2, this.showMissionResults);
		if (this.m_isVersus) {
			_local_2 = (_local_2 + 1);
			Animate.delay(this.m_view, _local_2, this.animateProfileProgression);
			return;
		}
		;
		if (!this.m_useAnimation) {
			this.showMissionRating();
			if (this.m_isSilentAssassin) {
				Animate.delay(this.m_view, _local_2, this.showSilentAssassin);
			} else {
				if (this.m_hasPlayStyle) {
					Animate.delay(this.m_view, _local_2, this.showPlayStyle);
				}
				;
			}
			;
			if (this.m_isNewBestRating) {
				Animate.delay(this.m_view, _local_2, this.showNewBest, this.m_missionRatingMc);
			}
			;
			if (this.m_isNewBestTime) {
				Animate.delay(this.m_view, _local_2, this.showNewBest, this.m_missionTimeMc);
			}
			;
			if (this.m_isNewBestScore) {
				Animate.delay(this.m_view, _local_2, this.showNewBest, this.m_missionScoreMc);
			}
			;
		}
		;
		_local_2 = (_local_2 + _local_1);
		if (this.m_hasLeaderboard) {
			Animate.delay(this.m_view, _local_2, this.showLeaderboardElement);
		}
		;
		Animate.delay(this.m_view, _local_2, this.showLocationCompletion);
		Animate.delay(this.m_view, _local_2, this.showLocationProgression);
		if (!this.m_useAnimation) {
			return;
		}
		;
		_local_2 = (_local_2 + 0.2);
		Animate.delay(this.m_view, _local_2, this.showMissionRating);
		if (this.m_isSilentAssassin) {
			_local_2 = (_local_2 + 0.4);
			Animate.delay(this.m_view, _local_2, this.showSilentAssassin);
		} else {
			if (this.m_hasPlayStyle) {
				_local_2 = (_local_2 + 0.4);
				Animate.delay(this.m_view, _local_2, this.showPlayStyle);
			}
			;
		}
		;
		if (this.m_isNewBestRating) {
			_local_2 = (_local_2 + 0.4);
			Animate.delay(this.m_view, _local_2, this.showNewBest, this.m_missionRatingMc);
		}
		;
		if (this.m_isNewBestTime) {
			_local_2 = (_local_2 + 0.4);
			Animate.delay(this.m_view, _local_2, this.showNewBest, this.m_missionTimeMc);
		}
		;
		if (this.m_isNewBestScore) {
			_local_2 = (_local_2 + 0.4);
			Animate.delay(this.m_view, _local_2, this.showNewBest, this.m_missionScoreMc);
		}
		;
		_local_2 = (_local_2 + 1);
		Animate.delay(this.m_view, _local_2, this.animateProfileProgression);
		if (this.m_evergreenAnimation) {
			_local_2 = (_local_2 + (this.animateProfileProgressionDuration() + 0.5));
			Animate.delay(this.m_view, _local_2, this.animateEvergreenMissionResults);
		}
		;
	}

	private function showPlayerInfo():void {
		Animate.to(this.m_playerBadgeMc, 0.3, 0, {"alpha": 1}, Animate.ExpoOut);
		Animate.to(this.m_playerLevelMc, 0.3, 0.05, {"alpha": 1}, Animate.ExpoOut);
		Animate.to(this.m_playerNameMc, 0.3, 0.1, {"alpha": 1}, Animate.ExpoOut);
	}

	private function showProfileMastery():void {
		if (!this.m_useAnimation) {
			this.setLevelNumberProfile(this.m_profileBarValues.endLevelNr);
			this.m_profileMasteryMc.barFill.scaleX = getFinalBarScale(this.m_profileLevelInfo.getLevelFromList(this.m_profileBarValues.endXP), this.m_profileBarOriginalScale);
		} else {
			this.setLevelNumberProfile(this.m_profileBarValues.startLevelNr);
		}
		;
		Animate.to(this.m_dottedLineProfileMastery, 0.3, 0, {"alpha": 1}, Animate.ExpoOut);
		Animate.to(this.m_profileMasteryMc, 0.3, 0.05, {"alpha": 1}, Animate.ExpoOut);
	}

	private function showUnlockableMastery():void {
		var _local_1:Boolean;
		if (!this.m_useAnimation) {
			this.setLevelNumberUnlockable(this.m_unlockableBarValues.endLevelNr);
			if (this.m_unlockableMasteryIsLocation) {
				_local_1 = this.m_locationLevelInfo.isLevelMaxed(this.m_unlockableBarValues.endXP);
				this.m_unlockableMasteryMc.barFill.scaleX = ((_local_1) ? this.m_unlockableBarOriginalScale : getFinalBarScale(this.m_locationLevelInfo.getLevelFromList(this.m_unlockableBarValues.endXP), this.m_unlockableBarOriginalScale));
			} else {
				if (this.m_sniperUnlockableLevelInfo != null) {
					_local_1 = this.m_sniperUnlockableLevelInfo.isLevelMaxed(this.m_unlockableBarValues.endXP);
					this.m_unlockableMasteryMc.barFill.scaleX = ((_local_1) ? this.m_unlockableBarOriginalScale : getFinalBarScale(this.m_sniperUnlockableLevelInfo.getLevelFromList(this.m_unlockableBarValues.endXP), this.m_unlockableBarOriginalScale));
				}
				;
			}
			;
		}
		;
		Animate.to(this.m_dottedLineUnlockableMastery, 0.3, 0, {"alpha": 1}, Animate.ExpoOut);
		Animate.to(this.m_unlockableMasteryMc, 0.3, 0, {"alpha": 1}, Animate.ExpoOut);
	}

	private function showMissionResults():void {
		var _local_1:TextFormat;
		var _local_2:Sprite;
		var _local_3:TextField;
		if (this.m_isVersus) {
			_local_1 = this.m_missionScoreMc.scoreTitle.getTextFormat();
			_local_1.align = TextFormatAlign.RIGHT;
			this.m_missionScoreMc.scoreTitle.setTextFormat(_local_1);
			_local_1 = this.m_missionScoreMc.scoreValue.getTextFormat();
			_local_1.align = TextFormatAlign.RIGHT;
			this.m_missionScoreMc.scoreValue.setTextFormat(_local_1);
			this.m_missionScoreMc.x = (this.VIEW_WIDTH - this.m_missionScoreMc.width);
			this.m_missionTimeMc.x = this.m_missionRatingMc.x;
			Animate.to(this.m_missionTimeMc, 0.3, 0, {"alpha": 1}, Animate.ExpoOut);
			Animate.to(this.m_missionScoreMc, 0.3, 0.05, {"alpha": 1}, Animate.ExpoOut);
			Animate.to(this.m_view.missionSummaryMc.lineMc_01, 0.3, 0.1, {"alpha": 1}, Animate.ExpoOut);
			Animate.to(this.m_view.missionSummaryMc.lineMc_02, 0.3, 0.1, {"alpha": 1}, Animate.ExpoOut);
			Animate.to(this.m_view.missionSummaryMc.lineMc_03, 0.3, 0.1, {"alpha": 1}, Animate.ExpoOut);
			Animate.to(this.m_view.missionSummaryMc.lineMc_04, 0.3, 0.1, {"alpha": 1}, Animate.ExpoOut);
			if (this.m_isWinner) {
				_local_2 = new Sprite();
				_local_2.alpha = 0;
				_local_2.y = ((this.m_missionTimeMc.y + this.m_missionTimeMc.height) + 10);
				_local_3 = new TextField();
				_local_3.autoSize = TextFieldAutoSize.CENTER;
				_local_3.selectable = false;
				_local_3.width = this.VIEW_WIDTH;
				MenuUtils.setupTextAndShrinkToFitUpper(_local_3, this.m_isWinnerMsg, 120, MenuConstants.FONT_TYPE_MEDIUM, this.VIEW_WIDTH, -1, 70, MenuConstants.FontColorWhite);
				_local_3.x = ((this.VIEW_WIDTH >> 1) - (_local_3.width >> 1));
				_local_3.y = 40;
				this.m_separatorVersusWinnerTop = new DottedLine(this.VIEW_WIDTH, MenuConstants.COLOR_WHITE, DottedLine.TYPE_HORIZONTAL, 1, 2);
				this.m_separatorVersusWinnerBottom = new DottedLine(this.VIEW_WIDTH, MenuConstants.COLOR_WHITE, DottedLine.TYPE_HORIZONTAL, 1, 2);
				this.m_separatorVersusWinnerBottom.y = ((_local_3.y + _local_3.height) + 40);
				_local_2.addChild(this.m_separatorVersusWinnerTop);
				_local_2.addChild(this.m_separatorVersusWinnerBottom);
				_local_2.addChild(_local_3);
				this.m_view.addChild(_local_2);
				Animate.to(_local_2, 0.5, 0.3, {"alpha": 1}, Animate.ExpoOut);
				Animate.from(_local_3, 0.5, 0.3, {"x": (_local_3.x - 20)}, Animate.ExpoOut);
			}
			;
		} else {
			Animate.to(this.m_missionRatingMc, 0.3, 0, {"alpha": 1}, Animate.ExpoOut);
			Animate.to(this.m_missionTimeMc, 0.3, 0.05, {"alpha": 1}, Animate.ExpoOut);
			Animate.to(this.m_missionScoreMc, 0.3, 0.1, {"alpha": 1}, Animate.ExpoOut);
			if (!this.m_isEvergreen) {
				Animate.to(this.m_view.missionSummaryMc.lineMc_01, 0.3, 0.1, {"alpha": 1}, Animate.ExpoOut);
				Animate.to(this.m_view.missionSummaryMc.lineMc_02, 0.3, 0.1, {"alpha": 1}, Animate.ExpoOut);
				Animate.to(this.m_view.missionSummaryMc.lineMc_03, 0.3, 0.1, {"alpha": 1}, Animate.ExpoOut);
				Animate.to(this.m_view.missionSummaryMc.lineMc_04, 0.3, 0.1, {"alpha": 1}, Animate.ExpoOut);
			}
			;
		}
		;
	}

	private function animateEvergreenMissionResults():void {
		var _local_1:Number = 0;
		Animate.delay(this.m_view, _local_1, this.animateXp);
		if (this.m_xpTotal != 0) {
			_local_1 = (_local_1 + 1);
		}
		;
		_local_1 = (_local_1 + 0.5);
		Animate.delay(this.m_view, _local_1, this.animateTime);
		if (this.m_timeTotal != 0) {
			_local_1 = (_local_1 + 1);
		}
		;
		_local_1 = (_local_1 + 0.5);
		Animate.delay(this.m_view, _local_1, this.animatePayout);
		if (this.m_payoutTotal != 0) {
			_local_1 = (_local_1 + 1);
		}
		;
		_local_1 = (_local_1 + 0.5);
		Animate.delay(this.m_view, _local_1, this.animateCampaignProgress);
	}

	private function animateXp():void {
		var _local_1:int;
		var _local_2:int;
		var _local_3:Number;
		if (this.m_xpAnimatedTime == 0) {
			this.m_xpAnimatedTime = getTimer();
			if (this.m_xpAnimatedValue != this.m_xpTotal) {
				this.playSound("ui_debrief_scorescreen_evergreen_xp_counting_begin");
			}
			;
		} else {
			if (this.m_xpAnimatedValue < this.m_xpTotal) {
				_local_1 = getTimer();
				_local_2 = (_local_1 - this.m_xpAnimatedTime);
				this.m_xpAnimatedTime = _local_1;
				_local_3 = ((_local_2 / 1000) * this.m_xpTotal);
				if ((this.m_xpAnimatedValue + _local_3) < this.m_xpTotal) {
					this.m_xpAnimatedValue = (this.m_xpAnimatedValue + _local_3);
				} else {
					this.m_xpAnimatedValue = this.m_xpTotal;
				}
				;
				MenuUtils.setupText(this.m_missionRatingMc.ratingValue, this.formatXpNumber(this.m_xpAnimatedValue), 40, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorBlack);
			}
			;
		}
		;
		if (this.m_xpAnimatedValue == this.m_xpTotal) {
			if (this.m_xpTotal != 0) {
				this.playSound("ui_debrief_scorescreen_evergreen_xp_counting_done");
			} else {
				this.playSound("ui_debrief_scorescreen_evergreen_xp_counting_done_zero");
			}
			;
			this.blinkNewBestClip(this.m_missionRatingMc);
		} else {
			Animate.delay(this.m_view, 0.01, this.animateXp);
		}
		;
	}

	private function animateTime():void {
		var _local_1:int;
		var _local_2:int;
		var _local_3:Number;
		var _local_4:String;
		if (this.m_timeAnimatedTime == 0) {
			this.m_timeAnimatedTime = getTimer();
			if (this.m_timeAnimatedValue != this.m_timeTotal) {
				this.playSound("ui_debrief_scorescreen_evergreen_time_counting_begin");
			}
			;
		} else {
			if (this.m_timeAnimatedValue < this.m_timeTotal) {
				_local_1 = getTimer();
				_local_2 = (_local_1 - this.m_timeAnimatedTime);
				this.m_timeAnimatedTime = _local_1;
				_local_3 = ((_local_2 / 1000) * this.m_timeTotal);
				if ((this.m_timeAnimatedValue + _local_3) < this.m_timeTotal) {
					this.m_timeAnimatedValue = (this.m_timeAnimatedValue + _local_3);
				} else {
					this.m_timeAnimatedValue = this.m_timeTotal;
				}
				;
				_local_4 = this.formatTime(this.m_timeAnimatedValue);
				MenuUtils.setupText(this.m_missionTimeMc.timeValue, _local_4, 40, MenuConstants.FONT_TYPE_MEDIUM, ((this.m_isEvergreen) ? MenuConstants.FontColorBlack : MenuConstants.FontColorWhite));
			}
			;
		}
		;
		if (this.m_timeAnimatedValue == this.m_timeTotal) {
			this.playSound("ui_debrief_scorescreen_evergreen_time_counting_done");
			this.blinkNewBestClip(this.m_missionTimeMc);
		} else {
			Animate.delay(this.m_view, 0.01, this.animateTime);
		}
		;
	}

	private function animatePayout():void {
		var _local_1:int;
		var _local_2:int;
		var _local_3:Number;
		var _local_4:String;
		if (this.m_payoutAnimatedTime == 0) {
			this.m_payoutAnimatedTime = getTimer();
			if (this.m_payoutAnimatedValue != this.m_payoutTotal) {
				this.playSound("ui_debrief_scorescreen_evergreen_payout_counting_begin");
			}
			;
		} else {
			if (Math.abs(this.m_payoutAnimatedValue) < Math.abs(this.m_payoutTotal)) {
				_local_1 = getTimer();
				_local_2 = (_local_1 - this.m_payoutAnimatedTime);
				this.m_payoutAnimatedTime = _local_1;
				_local_3 = ((_local_2 / 1000) * this.m_payoutTotal);
				if (Math.abs((this.m_payoutAnimatedValue + _local_3)) < Math.abs(this.m_payoutTotal)) {
					this.m_payoutAnimatedValue = (this.m_payoutAnimatedValue + _local_3);
				} else {
					this.m_payoutAnimatedValue = this.m_payoutTotal;
				}
				;
				_local_4 = (MenuUtils.formatNumber(this.m_payoutAnimatedValue) + Localization.get("UI_EVERGREEN_MERCES"));
				if (this.m_payoutTotal < 0) {
					MenuUtils.setupText(this.m_missionScoreMc.scoreValue, _local_4, 40, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
				} else {
					MenuUtils.setupText(this.m_missionScoreMc.scoreValue, _local_4, 40, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorBlack);
				}
				;
			}
			;
		}
		;
		if (this.m_payoutAnimatedValue == this.m_payoutTotal) {
			if (this.m_payoutTotal != 0) {
				this.playSound("ui_debrief_scorescreen_evergreen_payout_counting_done");
			} else {
				this.playSound("ui_debrief_scorescreen_evergreen_payout_counting_done_zero");
			}
			;
			this.blinkNewBestClip(this.m_missionScoreMc);
		} else {
			Animate.delay(this.m_view, 0.01, this.animatePayout);
		}
		;
	}

	private function blinkNewBestClip(_arg_1:MovieClip):void {
		Animate.fromTo(_arg_1.newBestFx, 0.45, 0, {"alpha": 1}, {"alpha": 0}, Animate.ExpoOut);
		Animate.addTo(_arg_1.newBestFx, 0.5, 0, {"scaleX": (_arg_1.newBestFx.scaleX + 0.5)}, Animate.ExpoOut);
		Animate.addTo(_arg_1.newBestFx, 0.5, 0, {"scaleY": (_arg_1.newBestFx.scaleY + 0.75)}, Animate.ExpoOut);
	}

	private function animateCampaignProgress():void {
		this.m_evergreenCampaignView.doAnimation();
	}

	private function showMissionRating():void {
		var _local_2:MovieClip;
		var _local_1:Number = 0.1;
		var _local_3:int = 1;
		while (_local_3 <= 5) {
			if (((this.m_showRating) && (_local_3 <= this.m_ratingScore))) {
				_local_2 = this.m_missionRatingMc.ratingIcons.getChildByName(("icon" + _local_3));
				if (!this.m_useAnimation) {
					_local_2.alpha = 1;
				} else {
					Animate.to(_local_2, 0.15, _local_1, {"alpha": 1}, Animate.ExpoOut, this.playMissionRatingSound);
					Animate.addFrom(_local_2, 0.3, _local_1, {
						"scaleX": 1.5,
						"scaleY": 1.5
					}, Animate.ExpoOut);
					_local_1 = (_local_1 + 0.05);
				}
				;
			}
			;
			_local_3++;
		}
		;
		Animate.to(this.m_dottedLineMissionSummary, 0.3, 0, {"alpha": 1}, Animate.ExpoOut);
	}

	private function playMissionRatingSound():void {
		this.playSound("ui_debrief_scorescreen_star_rating");
	}

	private function showSilentAssassin():void {
		if (!this.m_useAnimation) {
			Animate.fromTo(this.m_silentAssassinMc, 0.3, 0, {"alpha": 0}, {"alpha": 1}, Animate.ExpoOut);
			return;
		}
		;
		Animate.delay(this.m_playstyleDelaySprite, 0.15, this.playPlayStyleSound);
		this.m_silentAssassinMc.bg.alpha = 0;
		this.m_silentAssassinMc.fx.scaleX = (this.m_silentAssassinMc.fx.scaleY = 1);
		this.m_silentAssassinMc.title.alpha = 0;
		this.m_silentAssassinMc.alpha = 1;
		Animate.to(this.m_silentAssassinMc.bg, 0.1, 0.15, {"alpha": 1}, Animate.ExpoOut);
		Animate.addFromTo(this.m_silentAssassinMc.bg, 0.25, 0.15, {"scaleY": 0.4}, {"scaleY": 1}, Animate.ExpoOut);
		Animate.to(this.m_silentAssassinMc.title, 0.1, 0.2, {"alpha": 1}, Animate.ExpoOut);
		Animate.fromTo(this.m_silentAssassinMc.fx, 0.45, 0.2, {"alpha": 1}, {"alpha": 0}, Animate.ExpoOut);
		Animate.addTo(this.m_silentAssassinMc.fx, 0.5, 0.2, {"scaleX": 1.05}, Animate.ExpoOut);
		Animate.addTo(this.m_silentAssassinMc.fx, 0.5, 0.2, {"scaleY": 1.75}, Animate.ExpoOut);
	}

	private function showPlayStyle():void {
		if (!this.m_useAnimation) {
			Animate.fromTo(this.m_playStyleMc, 0.3, 0, {"alpha": 0}, {"alpha": 1}, Animate.ExpoOut);
			return;
		}
		;
		Animate.delay(this.m_playstyleDelaySprite, 0.15, this.playPlayStyleSound);
		this.m_playStyleMc.bg.alpha = 0;
		this.m_playStyleMc.fx.scaleX = (this.m_playStyleMc.fx.scaleY = 1);
		this.m_playStyleMc.title.alpha = 0;
		this.m_playStyleMc.alpha = 1;
		Animate.to(this.m_playStyleMc.bg, 0.1, 0.15, {"alpha": 1}, Animate.ExpoOut);
		Animate.addFromTo(this.m_playStyleMc.bg, 0.25, 0.15, {"scaleY": 0.4}, {"scaleY": 1}, Animate.ExpoOut);
		Animate.to(this.m_playStyleMc.title, 0.1, 0.2, {"alpha": 1}, Animate.ExpoOut);
		Animate.fromTo(this.m_playStyleMc.fx, 0.45, 0.2, {"alpha": 1}, {"alpha": 0}, Animate.ExpoOut);
		Animate.addTo(this.m_playStyleMc.fx, 0.5, 0.2, {"scaleX": 1.05}, Animate.ExpoOut);
		Animate.addTo(this.m_playStyleMc.fx, 0.5, 0.2, {"scaleY": 1.75}, Animate.ExpoOut);
	}

	private function playPlayStyleSound():void {
		if (this.m_playStyleSoundId != null) {
			this.playSound(this.m_playStyleSoundId);
		}
		;
		this.playSound("ui_debrief_scorescreen_playstyle");
	}

	private function showNewBest(_arg_1:MovieClip):void {
		Animate.kill(_arg_1.newBestTitle);
		Animate.kill(_arg_1.newBestFx);
		Animate.kill(_arg_1.newBestBg);
		_arg_1.newBestFx.height = (_arg_1.newBestBg.height = (82 + ((_arg_1.newBestTitle.numLines - 1) * 18)));
		_arg_1.newBestFx.y = (49.5 + ((_arg_1.newBestTitle.numLines * 18) / 2));
		if (!this.m_useAnimation) {
			Animate.fromTo(_arg_1.newBestTitle, 0.1, 0, {"alpha": 0}, {"alpha": 1}, Animate.ExpoOut);
			Animate.fromTo(_arg_1.newBestBg, 0.1, 0, {"alpha": 0}, {"alpha": 1}, Animate.ExpoOut);
			this.offsetMissionSummary(0.1, _arg_1);
			this.tintNewBest(_arg_1);
			this.hideMissionSummaryLines(_arg_1);
			return;
		}
		;
		Animate.delay(this.m_newBestDelaySprite, 0.15, this.playNewBestSound, _arg_1);
		Animate.fromTo(_arg_1.newBestTitle, 0.1, 0.2, {"alpha": 0}, {"alpha": 1}, Animate.ExpoOut);
		Animate.fromTo(_arg_1.newBestBg, 0.1, 0.15, {"alpha": 0}, {"alpha": 1}, Animate.ExpoOut);
		Animate.fromTo(_arg_1.newBestFx, 0.45, 0.2, {"alpha": 1}, {"alpha": 0}, Animate.ExpoOut);
		Animate.addTo(_arg_1.newBestFx, 0.5, 0.2, {"scaleX": (_arg_1.newBestFx.scaleX + 0.5)}, Animate.ExpoOut);
		Animate.addTo(_arg_1.newBestFx, 0.5, 0.2, {"scaleY": (_arg_1.newBestFx.scaleY + 0.75)}, Animate.ExpoOut);
		this.offsetMissionSummary(0.3, _arg_1);
		this.tintNewBest(_arg_1);
		this.hideMissionSummaryLines(_arg_1);
	}

	private function playNewBestSound(_arg_1:MovieClip):void {
		if (_arg_1 == this.m_missionRatingMc) {
			this.playSound("ui_debrief_scorescreen_mission_rating");
		}
		;
		if (_arg_1 == this.m_missionTimeMc) {
			this.playSound("ui_debrief_scorescreen_mission_time");
		}
		;
		if (_arg_1 == this.m_missionScoreMc) {
			this.playSound("ui_debrief_scorescreen_mission_score");
		}
		;
	}

	private function offsetMissionSummary(_arg_1:Number, _arg_2:MovieClip):void {
		Animate.kill(_arg_2);
		var _local_3:int = ((_arg_2.newBestTitle.numLines == 1) ? -9 : -18);
		Animate.to(_arg_2, _arg_1, 0, {
			"y": _local_3,
			"alpha": 1
		}, Animate.ExpoOut);
	}

	private function tintNewBest(_arg_1:MovieClip):void {
		var _local_2:int;
		var _local_3:MovieClip;
		if (_arg_1 == this.m_missionRatingMc) {
			if (this.m_hasChallengeMultiplier) {
				MenuUtils.setupText(this.m_missionRatingMc.ratingValue, this.m_missionRatingMc.ratingValue.text, 40, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraDark);
			} else {
				_local_2 = 1;
				while (_local_2 <= 5) {
					_local_3 = this.m_missionRatingMc.ratingIcons.getChildByName(("icon" + _local_2));
					MenuUtils.setColor(_local_3, MenuConstants.COLOR_GREY_ULTRA_DARK, false);
					_local_2++;
				}
				;
			}
			;
		}
		;
		if (_arg_1 == this.m_missionTimeMc) {
			MenuUtils.setupText(this.m_missionTimeMc.timeValue, this.m_missionTimeMc.timeValue.text, 40, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraDark);
			CommonUtils.changeFontToGlobalFont(this.m_missionTimeMc.timeValue);
		}
		;
		if (_arg_1 == this.m_missionScoreMc) {
			MenuUtils.setupText(this.m_missionScoreMc.scoreValue, this.m_missionScoreMc.scoreValue.text, 40, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraDark);
		}
		;
	}

	private function hideMissionSummaryLines(_arg_1:MovieClip):void {
		if (_arg_1 == this.m_missionRatingMc) {
			Animate.kill(this.m_view.missionSummaryMc.lineMc_01);
			Animate.kill(this.m_view.missionSummaryMc.lineMc_02);
			Animate.to(this.m_view.missionSummaryMc.lineMc_01, 0.3, 0.1, {"alpha": 0}, Animate.ExpoOut);
			Animate.to(this.m_view.missionSummaryMc.lineMc_02, 0.3, 0.1, {"alpha": 0}, Animate.ExpoOut);
		}
		;
		if (_arg_1 == this.m_missionTimeMc) {
			Animate.kill(this.m_view.missionSummaryMc.lineMc_02);
			Animate.kill(this.m_view.missionSummaryMc.lineMc_03);
			Animate.to(this.m_view.missionSummaryMc.lineMc_02, 0.3, 0.1, {"alpha": 0}, Animate.ExpoOut);
			Animate.to(this.m_view.missionSummaryMc.lineMc_03, 0.3, 0.1, {"alpha": 0}, Animate.ExpoOut);
		}
		;
		if (_arg_1 == this.m_missionScoreMc) {
			Animate.kill(this.m_view.missionSummaryMc.lineMc_03);
			Animate.kill(this.m_view.missionSummaryMc.lineMc_04);
			Animate.to(this.m_view.missionSummaryMc.lineMc_03, 0.3, 0.1, {"alpha": 0}, Animate.ExpoOut);
			Animate.to(this.m_view.missionSummaryMc.lineMc_04, 0.3, 0.1, {"alpha": 0}, Animate.ExpoOut);
		}
		;
	}

	private function showLeaderboardElement():void {
		Animate.to(this.m_dottedLineLeaderBoard, 0.3, 0, {"alpha": 1}, Animate.ExpoOut);
		Animate.to(this.m_leaderboardMc, 0.3, 0.05, {"alpha": 1}, Animate.ExpoOut);
	}

	private function showLocationCompletion():void {
		Animate.to(this.m_locationCompletionMc, 0.3, 0, {"alpha": 1}, Animate.ExpoOut);
	}

	private function animateProfileProgressionDuration():Number {
		return ((this.m_barRewards.length * this.ANIMATE_REWARD_DURATION) + 0.5);
	}

	private function animateProfileProgression():void {
		var _local_3:BarAnimationValues;
		if (((this.m_profileBarValues.startXP >= this.m_profileBarValues.endXP) || (this.m_barRewards.length == 0))) {
			this.animateSniperProgression();
			return;
		}
		;
		var _local_1:Number = this.animateProfileProgressionDuration();
		this.animateBarRewards(0);
		var _local_2:BarAnimationValues = new BarAnimationValues();
		_local_2.barView = this.m_profileMasteryMc.barFill;
		_local_2.originalScale = this.m_profileBarOriginalScale;
		_local_2.newLevelCallback = this.setLevelNumberProfile;
		_local_2.levelInfo = this.m_profileLevelInfo;
		initBarValues(_local_2, _local_1, this.m_profileBarValues.startXP, this.m_profileBarValues.endXP);
		if (((this.m_isUnlockableMasteryVisible) && (this.m_unlockableMasteryIsLocation))) {
			_local_3 = new BarAnimationValues();
			_local_3.barView = this.m_unlockableMasteryMc.barFill;
			_local_3.originalScale = this.m_unlockableBarOriginalScale;
			_local_3.newLevelCallback = this.setLevelNumberUnlockable;
			_local_3.levelInfo = this.m_locationLevelInfo;
			initBarValues(_local_3, _local_1, this.m_unlockableBarValues.startXP, this.m_unlockableBarValues.endXP);
		}
		;
		Animate.delay(this.m_view, _local_1, this.animateSniperProgression);
	}

	private function animateSniperProgression():void {
		if (((this.m_isUnlockableMasteryVisible) && (!(this.m_unlockableMasteryIsLocation)))) {
			this.animateSniperUnlockableMastery();
		}
		;
	}

	private function animateBarRewards(_arg_1:int):void {
		if (!this.m_tickSoundStarted) {
			this.playSound("ui_debrief_achievement_scorescreen_tick_lp");
			this.m_tickSoundStarted = true;
		}
		;
		if (_arg_1 >= this.m_barRewards.length) {
			if (this.m_tickSoundStarted) {
				this.playSound("ui_debrief_achievement_scorescreen_tick_lp_stop");
				this.m_tickSoundStarted = false;
			}
			;
			this.setLevelInfoProfile("");
			return;
		}
		;
		if (_arg_1 == 0) {
			this.m_animateBarStartXp = this.m_profileBarValues.startXP;
			if (this.m_unlockableBarValues != null) {
				this.m_animateBarStartXpUnlockable = this.m_unlockableBarValues.startXP;
			}
			;
		}
		;
		Animate.kill(this.m_profileMasteryMc.infoTxt);
		this.m_profileMasteryMc.infoTxt.alpha = 0;
		var _local_2:Object = this.m_barRewards[_arg_1];
		var _local_3:String = Localization.get(_local_2.ChallengeName);
		var _local_4:int = _local_2.XPGain;
		var _local_5:String = ((((_local_3 + " +") + MenuUtils.formatNumber(_local_4)) + " ") + Localization.get("UI_PERFORMANCE_MASTERY_XP"));
		this.setLevelInfoProfile(_local_5);
		var _local_6:Number = (this.ANIMATE_REWARD_DURATION / 4);
		this.playSound("ui_debrief_scorescreen_progressbar_text");
		Animate.fromTo(this.m_profileMasteryMc.infoTxt, _local_6, 0, {
			"x": (this.m_infoTxtOriginalPosX - 20),
			"alpha": 0
		}, {
			"x": this.m_infoTxtOriginalPosX,
			"alpha": 1
		}, Animate.ExpoOut);
		Animate.addFromTo(this.m_profileMasteryMc.infoTxt, _local_6, (_local_6 * 3), {
			"x": this.m_infoTxtOriginalPosX,
			"alpha": 1
		}, {
			"x": (this.m_infoTxtOriginalPosX + 20),
			"alpha": 0
		}, Animate.ExpoIn);
		Animate.delay(this.m_profileMasteryMc, this.ANIMATE_REWARD_DURATION, this.animateBarRewards, (_arg_1 + 1));
	}

	private function animateSniperUnlockableMastery():void {
		Animate.kill(this.m_unlockableMasteryMc.infoTxt);
		this.m_unlockableMasteryMc.infoTxt.alpha = 0;
		var _local_1:String = Localization.get("UI_MENU_MISSION_END_SCORE_TITLE_NO_COLON");
		var _local_2:String = ((_local_1 + " +") + MenuUtils.formatNumber(this.m_unlockableBarValues.xpTotalGain));
		this.setLevelInfoUnlockable(_local_2);
		var _local_3:Number = (this.ANIMATE_UNLOCKABLE_MASTERY_DURATION / 4);
		this.playSound("ui_debrief_scorescreen_progressbar_text");
		Animate.fromTo(this.m_unlockableMasteryMc.infoTxt, _local_3, 0, {
			"x": (this.m_infoTxtOriginalPosX - 20),
			"alpha": 0
		}, {
			"x": this.m_infoTxtOriginalPosX,
			"alpha": 1
		}, Animate.ExpoOut);
		Animate.addFromTo(this.m_unlockableMasteryMc.infoTxt, _local_3, (_local_3 * 3), {
			"x": this.m_infoTxtOriginalPosX,
			"alpha": 1
		}, {
			"x": (this.m_infoTxtOriginalPosX + 20),
			"alpha": 0
		}, Animate.ExpoIn);
		var _local_4:BarAnimationValues = new BarAnimationValues();
		_local_4.barView = this.m_unlockableMasteryMc.barFill;
		_local_4.originalScale = this.m_unlockableBarOriginalScale;
		_local_4.newLevelCallback = this.setLevelNumberUnlockable;
		_local_4.levelInfo = this.m_sniperUnlockableLevelInfo;
		initBarValues(_local_4, (this.ANIMATE_UNLOCKABLE_MASTERY_DURATION / 1.1), this.m_unlockableBarValues.startXP, this.m_unlockableBarValues.endXP);
	}

	private function setLevelInfoProfile(_arg_1:String):void {
		MenuUtils.setupTextUpper(this.m_profileMasteryMc.infoTxt, _arg_1, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
	}

	private function setLevelNumberProfile(_arg_1:int):void {
		var _local_3:Boolean;
		MenuUtils.setupText(this.m_profileMasteryMc.levelCurrentTxt, _arg_1.toFixed(0), 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		var _local_2:int = (_arg_1 + 1);
		MenuUtils.setupText(this.m_profileMasteryMc.levelNextTxt, _local_2.toFixed(0), 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		if (this.m_useAnimation) {
			_local_3 = (_arg_1 == this.m_profileBarValues.startLevelNr);
		} else {
			_local_3 = (_arg_1 == this.m_profileBarValues.endLevelNr);
		}
		;
		if (((this.m_useAnimation) && (!(_local_3)))) {
			Animate.fromTo(this.m_profileMasteryMc.fx, 0.5, 0, {"alpha": 1}, {"alpha": 0}, Animate.ExpoOut);
		}
		;
		this.setLevelNumberBadge(_arg_1, _local_3);
	}

	private function setLevelNumberBadge(_arg_1:int, _arg_2:Boolean):void {
		MenuUtils.setupText(this.m_playerLevelMc.levelTxt, _arg_1.toFixed(0), 40, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
		this.m_playerLevelMc.levelTxt.autoSize = TextFieldAutoSize.CENTER;
		if (_arg_2) {
			this.m_dottedLinePlayerName = new DottedLine(100, MenuConstants.COLOR_WHITE, DottedLine.TYPE_HORIZONTAL, 1, 2);
			this.m_dottedLinePlayerName.x = (this.m_playerLevelMc.x - (this.m_dottedLinePlayerName.width >> 1));
			this.m_dottedLinePlayerName.y = ((this.m_playerLevelMc.y + (this.m_playerLevelMc.height >> 1)) - 8);
			this.m_view.addChild(this.m_dottedLinePlayerName);
		}
		;
		if (this.m_useAnimation) {
			Animate.fromTo(this.m_playerLevelMc, 0.3, 0, {
				"alpha": 0,
				"scaleX": 0,
				"scaleY": 0
			}, {
				"alpha": 1,
				"scaleX": 1,
				"scaleY": 1
			}, Animate.ExpoOut);
			if (_arg_2) {
				switch (this.m_evergreenEndState) {
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
				;
			} else {
				this.playSound("ui_debrief_scorescreen_levelup");
			}
			;
		}
		;
		this.m_badge.setLevel(_arg_1, _arg_2, this.m_useAnimation);
	}

	private function setLevelInfoUnlockable(_arg_1:String):void {
		MenuUtils.setupTextUpper(this.m_unlockableMasteryMc.infoTxt, _arg_1, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
	}

	private function setLevelNumberUnlockable(_arg_1:int):void {
		var _local_2:String = ((_arg_1.toFixed(0) + " / ") + this.m_unlockableMaxLevel.toFixed(0));
		MenuUtils.setupText(this.m_unlockableMasteryMc.valueTxt, _local_2, 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		if (_arg_1 != this.m_unlockableBarValues.startLevelNr) {
			if (this.m_useAnimation) {
				this.playSound("ui_debrief_scorescreen_progressbar_locationmastery_levelup");
			}
			;
		}
		;
	}

	private function setLocationProgression(_arg_1:Object):void {
		var _local_5:Object;
		var _local_8:int;
		var _local_9:int;
		var _local_10:int;
		var _local_11:String;
		var _local_12:Number;
		var _local_13:Number;
		var _local_14:Number;
		var _local_2:Boolean;
		if (_arg_1.LocationCompletionTitle != null) {
			_local_2 = ((!(_arg_1.LocationCompletionTitle == _arg_1.ContractTitle)) && (!(_arg_1.contractTitle == "")));
		}
		;
		this.m_barViews = [];
		this.m_barViewsProgress = [];
		var _local_3:Array = [];
		this.m_barViews.push(this.m_locationCompletionMc.bar1);
		this.m_barViews.push(this.m_locationCompletionMc.bar2);
		this.m_barViews.push(this.m_locationCompletionMc.bar3);
		var _local_4:int;
		while (_local_4 < this.m_barViews.length) {
			this.m_barViews[_local_4].visible = false;
			if (_local_2) {
				this.m_barViews[_local_4].y = (this.m_barViews[_local_4].y + (this.m_locationCompletionMc.contractTitle.height - 7));
			}
			;
			_local_4++;
		}
		;
		if (_arg_1.OpportunityStatistics != null) {
			_local_5 = new Object();
			_local_5.Title = Localization.get("UI_BRIEFING_OPPORTUNITIES");
			_local_5.Icon = "opportunitydiscovered";
			_local_5.Completed = _arg_1.OpportunityStatistics.Completed;
			_local_5.PreviousCompleted = Math.max(0, (_local_5.Completed - this.m_opportunityCountGain));
			_local_5.Count = _arg_1.OpportunityStatistics.Count;
			if (_local_5.Count > 0) {
				_local_3.push(_local_5);
			}
			;
		}
		;
		if (_arg_1.ChallengeCompletion != null) {
			_local_5 = new Object();
			_local_5.Title = Localization.get("UI_MENU_PAGE_PLANNING_CHALLENGES");
			_local_5.Icon = "challenge";
			_local_5.Completed = _arg_1.ChallengeCompletion.CompletedChallengesCount;
			_local_5.PreviousCompleted = Math.max(0, (_local_5.Completed - this.m_challengeCountGain));
			_local_5.Count = _arg_1.ChallengeCompletion.ChallengesCount;
			if (_local_5.Count > 0) {
				_local_3.push(_local_5);
			}
			;
		}
		;
		var _local_6:* = (_local_3.length > 0);
		this.m_locationCompletionMc.visible = _local_6;
		if (!_local_6) {
			return;
		}
		;
		MenuUtils.setupIcon(this.m_locationCompletionMc.icon, "stats", MenuConstants.COLOR_BLACK, false, true, MenuConstants.COLOR_WHITE);
		MenuUtils.setupTextUpper(this.m_locationCompletionMc.title, _arg_1.LocationCompletionTitle, 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_locationCompletionMc.value, _arg_1.LocationCompletionPercent, 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		if (_local_2) {
			this.m_locationCompletionMc.contractTitle.visible = true;
			MenuUtils.setupTextUpper(this.m_locationCompletionMc.contractTitle, _arg_1.ContractTitle, 19, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			MenuUtils.truncateTextfield(this.m_locationCompletionMc.contractTitle, 1, MenuConstants.FontColorWhite, CommonUtils.changeFontToGlobalIfNeeded(this.m_locationCompletionMc.contractTitle));
		}
		;
		var _local_7:int;
		while (((_local_7 < _local_3.length) && (_local_7 < this.m_barViews.length))) {
			_local_8 = _local_3[_local_7].Count;
			_local_9 = _local_3[_local_7].Completed;
			_local_10 = _local_3[_local_7].PreviousCompleted;
			_local_11 = ((_local_9.toFixed(0) + " / ") + _local_8.toFixed(0));
			MenuUtils.setupTextUpper(this.m_barViews[_local_7].title, _local_3[_local_7].Title, 14, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorBlack);
			MenuUtils.setupText(this.m_barViews[_local_7].value, _local_11, 14, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			MenuUtils.addDropShadowFilter(this.m_barViews[_local_7].value);
			MenuUtils.setupIcon(this.m_barViews[_local_7].icon, _local_3[_local_7].Icon, MenuConstants.COLOR_BLACK, true, false);
			_local_12 = this.m_barViews[_local_7].bg.scaleX;
			_local_13 = Math.min(Math.max(0, (_local_9 / _local_8)), 1);
			_local_14 = Math.min(Math.max(0, (_local_10 / _local_8)), 1);
			this.m_barViews[_local_7].barCompleted.scaleX = (_local_14 * _local_12);
			this.m_barViews[_local_7].barCompletedNew.scaleX = 0;
			this.m_barViewsProgress.push({
				"hasProgression": (_local_9 > _local_10),
				"newScaleX": (_local_13 * _local_12)
			});
			MenuUtils.setColor(this.m_barViews[_local_7].bg, MenuConstants.COLOR_WHITE, true, 0.1);
			MenuUtils.setColor(this.m_barViews[_local_7].barCompleted, MenuConstants.COLOR_WHITE);
			MenuUtils.setColor(this.m_barViews[_local_7].barCompletedNew, MenuConstants.COLOR_WHITE, true, 0.5);
			this.m_barViews[_local_7].visible = true;
			_local_7++;
		}
		;
	}

	private function showLocationProgression():void {
		var _local_1:Number = 0.1;
		var _local_2:int;
		while (((_local_2 < this.m_barViews.length) && (_local_2 < this.m_barViewsProgress.length))) {
			if (this.m_barViewsProgress[_local_2].hasProgression) {
				if (this.m_useAnimation) {
					Animate.to(this.m_barViews[_local_2].barCompletedNew, 0.3, _local_1, {"scaleX": this.m_barViewsProgress[_local_2].newScaleX}, Animate.ExpoInOut);
					_local_1 = (_local_1 + 0.1);
				} else {
					this.m_barViews[_local_2].barCompletedNew.scaleX = this.m_barViewsProgress[_local_2].newScaleX;
				}
				;
			}
			;
			_local_2++;
		}
		;
	}

	private function formatNewBestTextFields(_arg_1:MovieClip):void {
		_arg_1.newBestTitle.alpha = 0;
		_arg_1.newBestFx.alpha = 0;
		_arg_1.newBestBg.alpha = ((this.m_isEvergreen) ? 1 : 0);
		_arg_1.newBestTitle.autoSize = "left";
		_arg_1.newBestTitle.multiline = true;
		_arg_1.newBestTitle.wordWrap = true;
		_arg_1.newBestTitle.width = 220;
	}

	public function playSound(_arg_1:String):void {
		ExternalInterface.call("PlaySound", _arg_1);
	}

	private function killAllAnimations():void {
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
		var _local_1:int;
		while (_local_1 < this.m_barViews.length) {
			Animate.kill(this.m_barViews[_local_1].barCompletedNew);
			_local_1++;
		}
		;
	}

	override public function onUnregister():void {
		if (this.m_view) {
			this.killAllAnimations();
			if (this.m_tickSoundStarted) {
				this.playSound("ui_debrief_achievement_scorescreen_tick_lp_stop");
				this.m_tickSoundStarted = false;
			}
			;
			removeChild(this.m_view);
			this.m_view = null;
		}
		;
		super.onUnregister();
	}


}
}//package menu3.missionend

import flash.display.Sprite;

import menu3.missionend.LevelInfo;

class BarValues {

	public var xpTotalGain:Number = 0;
	public var startXP:Number = 0;
	public var endXP:Number = 0;
	public var startLevelNr:int = 1;
	public var endLevelNr:int = 1;
	public var startBarProgress:Number = 0;
	public var endBarProgress:Number = 0;


}

class BarAnimationValues {

	public var barView:Sprite = null;
	public var originalScale:Number = 1;
	public var newLevelCallback:Function = null;
	public var levelInfo:LevelInfo;


}


