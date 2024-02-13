// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.DetailedScoreTileSniper

package menu3.basic {
import menu3.MenuElementTileBase;

import flash.display.MovieClip;

import common.MouseUtil;
import common.menu.MenuUtils;
import common.Localization;
import common.menu.MenuConstants;
import common.CommonUtils;
import common.Animate;


import basic.DottedLine;

import flash.external.ExternalInterface;
import flash.display.Sprite;


public dynamic class DetailedScoreTileSniper extends MenuElementTileBase {

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

	public function DetailedScoreTileSniper(_arg_1:Object) {
		super(_arg_1);
		m_mouseMode = MouseUtil.MODE_ONOVER_SELECT_ONUP_CLICK;
		this.m_view = new DetailedScoreTileSniperView();
		this.m_view.y = -64;
		this.m_view.tileBg.alpha = 0;
		this.m_missionRatingMc = this.m_view.missionSummaryMc.missionRatingMc;
		this.m_missionTimeMc = this.m_view.missionSummaryMc.missionTimeMc;
		this.m_missionScoreMc = this.m_view.missionSummaryMc.missionScoreMc;
		var _local_2:* = (!(ControlsMain.isVrModeActive()));
		this.m_missionRatingMc.newBestFx.visible = _local_2;
		this.m_missionTimeMc.newBestFx.visible = _local_2;
		this.m_missionScoreMc.newBestFx.visible = _local_2;
		this.m_missionRatingMc.ratingIcons.visible = false;
		this.m_view.missionSummaryMc.lineMc_01.alpha = (this.m_view.missionSummaryMc.lineMc_02.alpha = (this.m_view.missionSummaryMc.lineMc_03.alpha = (this.m_view.missionSummaryMc.lineMc_04.alpha = 1)));
		this.m_view.offlineTxt.visible = false;
		this.m_view.silentAssassinMc.visible = (this.m_view.playStyleMc.visible = (this.m_view.leaderboardPosMc.visible = false));
		this.formatNewBestTextFields(this.m_missionRatingMc);
		this.formatNewBestTextFields(this.m_missionTimeMc);
		this.formatNewBestTextFields(this.m_missionScoreMc);
		MenuUtils.setupTextUpper(this.m_view.leaderboardPosMc.lowTxt, Localization.get("UI_MENU_PAGE_DEBRIEFING_LEADERBOARDS_BOTTOM"), 14, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyLight);
		MenuUtils.setupTextUpper(this.m_view.leaderboardPosMc.titleTxt, Localization.get("UI_MENU_PAGE_DEBRIEFING_LEADERBOARDS_POSITION"), 14, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyLight);
		MenuUtils.setupTextUpper(this.m_view.leaderboardPosMc.highTxt, Localization.get("UI_MENU_PAGE_DEBRIEFING_LEADERBOARDS_TOP"), 14, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyLight);
		addChild(this.m_view);
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		this.playSound("ui_debrief_detailsscreen_open");
		this.m_yOffset = ((_arg_1.Percentile != null) ? 395 : 153);
		this.m_view.preliminaryScoreMc.y = this.m_yOffset;
		if (_arg_1.player != undefined) {
			if (_arg_1.player2 != undefined) {
				MenuUtils.setupText(this.m_view.headerTxt, ((_arg_1.player + MenuConstants.PLAYER_MULTIPLAYER_DELIMITER) + _arg_1.player2), 60, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
				CommonUtils.changeFontToGlobalIfNeeded(this.m_view.headerTxt);
				MenuUtils.truncateMultipartTextfield(this.m_view.headerTxt, _arg_1.player, _arg_1.player2, MenuConstants.PLAYER_MULTIPLAYER_DELIMITER, MenuConstants.PLAYERNAME_MIN_CHAR_COUNT, MenuConstants.FontColorWhite);
				MenuUtils.shrinkTextToFit(this.m_view.headerTxt, this.m_view.headerTxt.width, -1);
			} else {
				MenuUtils.setupText(this.m_view.headerTxt, _arg_1.player, 60, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
				CommonUtils.changeFontToGlobalIfNeeded(this.m_view.headerTxt);
				MenuUtils.truncateTextfield(this.m_view.headerTxt, 1, MenuConstants.FontColorWhite);
			}

		}

		if (!_arg_1.isonline) {
			this.m_view.offlineTxt.visible = true;
			MenuUtils.setupText(this.m_view.offlineTxt, Localization.get("UI_DIALOG_SCORE_OFFLINE"), 26, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
			return;
		}

		if (_arg_1.isloading) {
			return;
		}

		var _local_2:SniperScoreObject = new SniperScoreObject(Localization.get("UI_SNIPERSCORING_SUMMARY_BASESCORE"), _arg_1.SniperChallengeScore.BaseScore);
		var _local_3:SniperScoreObject = new SniperScoreObject(((Localization.get("UI_SNIPERSCORING_SUMMARY_TIME_BONUS") + "  |  ") + MenuUtils.getTimeString(_arg_1.SniperChallengeScore.TimeTaken)), _arg_1.SniperChallengeScore.TimeBonus);
		var _local_4:SniperScoreObject = new SniperScoreObject(Localization.get("UI_SNIPERSCORING_SUMMARY_SILENT_ASSASIN_BONUS"), _arg_1.SniperChallengeScore.SilentAssassinBonus);
		var _local_5:SniperScoreObject = new SniperScoreObject(Localization.get("UI_SNIPERSCORING_SUMMARY_SUBTOTAL"), Math.max((((_arg_1.SniperChallengeScore.BaseScore + _arg_1.SniperChallengeScore.BulletsMissedPenalty) + _arg_1.SniperChallengeScore.TimeBonus) + _arg_1.SniperChallengeScore.SilentAssassinBonus), 0));
		var _local_6:SniperScoreObject = new SniperScoreObject(Localization.get("UI_SNIPERSCORING_SUMMARY_CHALLENGE_MULTIPLIER"), _arg_1.SniperChallengeScore.TotalChallengeMultiplier);
		var _local_7:SniperScoreObject = new SniperScoreObject(Localization.get("UI_SNIPERSCORING_SUMMARY_SILENT_ASSASIN_MULTIPLIER"), _arg_1.SniperChallengeScore.SilentAssassinMultiplier);
		this.setPreliminaryScore(Vector.<SniperScoreObject>([_local_2, _local_3, _local_4, _local_5]));
		this.setMultiplierScore(Vector.<SniperScoreObject>([_local_6, _local_7]));
		this.m_view.missionSummaryMc.y = (this.m_yOffset + 19);
		this.setMissionRating(_arg_1.SniperChallengeScore.TotalChallengeMultiplier);
		this.setMissionTime(_arg_1.SniperChallengeScore.TimeTaken);
		this.setMissionScore(_arg_1.SniperChallengeScore.FinalScore);
		if (_arg_1.IsNewBestScore != null) {
			if (_arg_1.IsNewBestScore) {
				this.m_isNewBestScore = true;
				MenuUtils.setupTextUpper(this.m_missionScoreMc.newBestTitle, Localization.get("UI_RATING_NEW_PERSONAL BEST"), 14, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraDark);
				this.showNewBest(this.m_missionScoreMc);
			}

		}

		if (_arg_1.IsNewBestTime != null) {
			if (_arg_1.IsNewBestTime) {
				this.m_isNewBestTime = true;
				MenuUtils.setupTextUpper(this.m_missionTimeMc.newBestTitle, Localization.get("UI_RATING_NEW_PERSONAL BEST"), 14, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraDark);
				this.showNewBest(this.m_missionTimeMc);
			}

		}

		if (_arg_1.IsNewBestStars != null) {
			if (_arg_1.IsNewBestStars) {
				this.m_isNewBestRating = true;
				MenuUtils.setupTextUpper(this.m_missionRatingMc.newBestTitle, Localization.get("UI_RATING_NEW_PERSONAL BEST"), 14, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraDark);
				this.showNewBest(this.m_missionRatingMc);
			}

		}

		if (_arg_1.Percentile != null) {
			this.setLeaderboardPositionChart(_arg_1.Percentile);
		}

		if (((!(_arg_1.SniperChallengeScore.SilentAssassin == null)) && (_arg_1.SniperChallengeScore.SilentAssassin == true))) {
			this.setSilentAssassin();
		} else {
			if (_arg_1.SniperChallengeScore.PlayStyle != null) {
				this.setPlayStyle(_arg_1.SniperChallengeScore.PlayStyle.Name);
			}

		}

	}

	private function setLeaderboardPositionChart(_arg_1:Object):void {
		_arg_1.Spread.reverse();
		var _local_2:int = ((_arg_1.Spread.length - 1) - _arg_1.Index);
		_arg_1.Index = _local_2;
		var _local_3:Array = [];
		var _local_4:int;
		while (_local_4 <= (_arg_1.Spread.length - 1)) {
			_local_3.push(_arg_1.Spread[_local_4]);
			_local_4++;
		}

		_local_3.sort(Array.NUMERIC);
		var _local_5:Number = (1 / _local_3[(_local_3.length - 1)]);
		this.m_view.leaderboardPosMc.visible = true;
		var _local_6:int;
		while (_local_6 <= (_arg_1.Spread.length - 1)) {
			Animate.kill(this.m_view.leaderboardPosMc[("barMc_0" + _local_6)]);
			this.m_view.leaderboardPosMc[("barMc_0" + _local_6)].scaleY = 0;
			Animate.to(this.m_view.leaderboardPosMc[("barMc_0" + _local_6)], 0.3, 0, {"scaleY": (_arg_1.Spread[_local_6] * _local_5)}, Animate.ExpoOut);
			if (_local_6 == _arg_1.Index) {
				MenuUtils.setColor(this.m_view.leaderboardPosMc[("barMc_0" + _local_6)], MenuConstants.COLOR_RED, false);
			}

			_local_6++;
		}

	}

	private function setMissionRating(_arg_1:Number):void {
		MenuUtils.setupTextAndShrinkToFitUpper(this.m_missionRatingMc.ratingTitle, Localization.get("UI_SNIPERSCORING_SUMMARY_MULTIPLIER"), 18, MenuConstants.FONT_TYPE_MEDIUM, this.m_missionRatingMc.ratingTitle.width, -1, 15, MenuConstants.FontColorRed);
		this.m_totalChallengesMultiplier = _arg_1;
		MenuUtils.setupText(this.m_missionRatingMc.ratingValue, _arg_1.toFixed(2), 40, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		this.m_missionRatingMc.visible = true;
	}

	private function setMissionTime(_arg_1:Number):void {
		MenuUtils.setupTextUpper(this.m_missionTimeMc.timeTitle, Localization.get("UI_MENU_MISSION_END_TIME_TITLE"), 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorRed);
		MenuUtils.setupTextAndShrinkToFit(this.m_missionTimeMc.timeValue, MenuUtils.getTimeString(_arg_1), 40, MenuConstants.FONT_TYPE_MEDIUM, this.m_missionTimeMc.timeValue.width, -1, 30, MenuConstants.FontColorWhite);
		CommonUtils.changeFontToGlobalFont(this.m_missionTimeMc.timeValue);
		this.m_missionTimeMc.visible = true;
	}

	private function setMissionScore(_arg_1:Number):void {
		MenuUtils.setupTextUpper(this.m_missionScoreMc.scoreTitle, Localization.get("UI_MENU_MISSION_END_SCORE_TITLE"), 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorRed);
		MenuUtils.setupText(this.m_missionScoreMc.scoreValue, MenuUtils.formatNumber(_arg_1), 40, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		this.m_missionScoreMc.visible = true;
	}

	private function setPreliminaryScore(_arg_1:Vector.<SniperScoreObject>):void {
		var _local_4:ScoreListElementView;
		this.addDottedLine(0, 0, this.m_view.preliminaryScoreMc);
		this.addDottedLine(0, 32, this.m_view.preliminaryScoreMc);
		var _local_2:Number = 250;
		var _local_3:Number = 0;
		MenuUtils.setupTextUpper(this.m_view.preliminaryScoreMc.headerTxt, Localization.get("UI_SNIPERSCORING_SUMMARY_PRELIMINARY"), 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		this.m_view.preliminaryScoreMc.headerTxt.y = (_local_3 + 5);
		var _local_5:int;
		while (_local_5 < _arg_1.length) {
			_local_4 = new ScoreListElementView();
			_local_4.x = _local_2;
			_local_4.y = (_local_3 + 4);
			MenuUtils.setupText(_local_4.titleTxt, _arg_1[_local_5].header, 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			MenuUtils.setupText(_local_4.valueTxt, MenuUtils.formatNumber(_arg_1[_local_5].value), 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			this.m_view.preliminaryScoreMc.addChild(_local_4);
			_local_3 = (_local_3 + 32);
			_local_5++;
		}

		_local_3 = (_local_3 + 14);
		this.m_yOffset = (this.m_yOffset + _local_3);
	}

	private function setMultiplierScore(_arg_1:Vector.<SniperScoreObject>):void {
		var _local_4:ScoreListElementView;
		this.m_view.multipliersScoreMc.y = ((this.m_view.preliminaryScoreMc.y + this.m_view.preliminaryScoreMc.height) + (this.EDGE_PADDING * 2));
		this.addDottedLine(0, 0, this.m_view.multipliersScoreMc);
		this.addDottedLine(0, 32, this.m_view.multipliersScoreMc);
		var _local_2:Number = 250;
		var _local_3:Number = 0;
		MenuUtils.setupTextUpper(this.m_view.multipliersScoreMc.headerTxt, Localization.get("UI_SNIPERSCORING_SUMMARY_MULTIPLIERS"), 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		this.m_view.multipliersScoreMc.headerTxt.y = (_local_3 + 5);
		var _local_5:int;
		while (_local_5 < _arg_1.length) {
			_local_4 = new ScoreListElementView();
			_local_4.x = _local_2;
			_local_4.y = (_local_3 + 4);
			MenuUtils.setupText(_local_4.titleTxt, _arg_1[_local_5].header, 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			MenuUtils.setupText(_local_4.valueTxt, _arg_1[_local_5].value.toFixed(2), 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			this.m_view.multipliersScoreMc.addChild(_local_4);
			_local_3 = (_local_3 + 32);
			_local_5++;
		}

		_local_3 = (_local_3 + 14);
		this.addDottedLine(0, _local_3, this.m_view.multipliersScoreMc);
		this.m_yOffset = (this.m_yOffset + _local_3);
	}

	private function setSilentAssassin():void {
		MenuUtils.setupTextUpper(this.m_view.silentAssassinMc.title, Localization.get("UI_RATING_SILENT_ASSASSIN").toUpperCase(), 28, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		MenuUtils.setColor(this.m_view.silentAssassinMc.bg, MenuConstants.COLOR_RED);
		this.m_view.silentAssassinMc.visible = true;
	}

	private function setPlayStyle(_arg_1:String):void {
		MenuUtils.setupTextAndShrinkToFitUpper(this.m_view.playStyleMc.title, _arg_1, 28, MenuConstants.FONT_TYPE_MEDIUM, this.m_view.playStyleMc.title.width, -1, 15, MenuConstants.FontColorGreyUltraDark);
		this.m_view.playStyleMc.visible = true;
	}

	private function showNewBest(_arg_1:MovieClip):void {
		_arg_1.newBestFx.height = (_arg_1.newBestBg.height = (82 + ((_arg_1.newBestTitle.numLines - 1) * 18)));
		_arg_1.newBestFx.y = (49.5 + ((_arg_1.newBestTitle.numLines * 18) / 2));
		_arg_1.newBestTitle.alpha = 1;
		_arg_1.newBestBg.alpha = 1;
		this.offsetMissionSummary(_arg_1);
		this.tintNewBest(_arg_1);
		this.hideMissionSummaryLines(_arg_1);
	}

	private function tintNewBest(_arg_1:MovieClip):void {
		if (_arg_1 == this.m_missionRatingMc) {
			MenuUtils.setupText(this.m_missionRatingMc.ratingValue, this.m_totalChallengesMultiplier.toFixed(2), 40, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraDark);
		}

		if (_arg_1 == this.m_missionTimeMc) {
			MenuUtils.setupText(this.m_missionTimeMc.timeValue, this.m_missionTimeMc.timeValue.text, 40, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraDark);
			CommonUtils.changeFontToGlobalFont(this.m_missionTimeMc.timeValue);
		}

		if (_arg_1 == this.m_missionScoreMc) {
			MenuUtils.setupText(this.m_missionScoreMc.scoreValue, this.m_missionScoreMc.scoreValue.text, 40, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraDark);
		}

	}

	private function hideMissionSummaryLines(_arg_1:MovieClip):void {
		if (_arg_1 == this.m_missionRatingMc) {
			this.m_view.missionSummaryMc.lineMc_01.alpha = (this.m_view.missionSummaryMc.lineMc_02.alpha = 0);
		}

		if (_arg_1 == this.m_missionTimeMc) {
			this.m_view.missionSummaryMc.lineMc_02.alpha = (this.m_view.missionSummaryMc.lineMc_03.alpha = 0);
		}

		if (_arg_1 == this.m_missionScoreMc) {
			this.m_view.missionSummaryMc.lineMc_03.alpha = (this.m_view.missionSummaryMc.lineMc_04.alpha = 0);
		}

	}

	private function offsetMissionSummary(_arg_1:MovieClip):void {
		_arg_1.y = ((_arg_1.newBestTitle.numLines == 1) ? -9 : -18);
	}

	private function formatNewBestTextFields(_arg_1:MovieClip):void {
		_arg_1.newBestTitle.alpha = 0;
		_arg_1.newBestFx.alpha = 0;
		_arg_1.newBestBg.alpha = 0;
		_arg_1.newBestTitle.autoSize = "left";
		_arg_1.newBestTitle.multiline = true;
		_arg_1.newBestTitle.wordWrap = true;
		_arg_1.newBestTitle.width = 220;
	}

	private function addDottedLine(_arg_1:int, _arg_2:int, _arg_3:MovieClip):void {
		var _local_4:DottedLine = new DottedLine((this.m_view.tileBg.width - (this.EDGE_PADDING * 2)), MenuConstants.COLOR_WHITE, DottedLine.TYPE_HORIZONTAL, 1, 2);
		_local_4.x = _arg_1;
		_local_4.y = _arg_2;
		_arg_3.addChild(_local_4);
	}

	private function killAnimations():void {
		var _local_1:int = 1;
		while (_local_1 <= 5) {
			Animate.kill(this.m_missionRatingMc.ratingIcons.getChildByName(("icon" + _local_1)));
			_local_1++;
		}

		var _local_2:int;
		while (_local_2 <= 9) {
			Animate.kill(this.m_view.leaderboardPosMc[("barMc_0" + _local_2)]);
			_local_2++;
		}

	}

	private function playSound(_arg_1:String):void {
		ExternalInterface.call("PlaySound", _arg_1);
	}

	override public function getView():Sprite {
		return (this.m_view.tileBg);
	}

	override public function onUnregister():void {
		if (this.m_view) {
			this.killAnimations();
			removeChild(this.m_view);
			this.m_view = null;
		}

	}


}
}//package menu3.basic

class SniperScoreObject {

	public var header:String;
	public var value:Number;

	public function SniperScoreObject(_arg_1:String, _arg_2:Number) {
		this.header = _arg_1;
		this.value = _arg_2;
	}

}


