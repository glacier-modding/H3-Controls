// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.DetailedScoreTile

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

public dynamic class DetailedScoreTile extends MenuElementTileBase {

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

	public function DetailedScoreTile(_arg_1:Object) {
		super(_arg_1);
		m_mouseMode = MouseUtil.MODE_ONOVER_SELECT_ONUP_CLICK;
		this.m_view = new DetailedScoreTileView();
		this.m_view.y = -64;
		this.m_view.tileBg.alpha = 0;
		this.m_missionRatingMc = this.m_view.missionSummaryMc.missionRatingMc;
		this.m_missionTimeMc = this.m_view.missionSummaryMc.missionTimeMc;
		this.m_missionScoreMc = this.m_view.missionSummaryMc.missionScoreMc;
		var _local_2:* = (!(ControlsMain.isVrModeActive()));
		this.m_missionRatingMc.newBestFx.visible = _local_2;
		this.m_missionTimeMc.newBestFx.visible = _local_2;
		this.m_missionScoreMc.newBestFx.visible = _local_2;
		this.m_view.missionSummaryMc.lineMc_01.alpha = (this.m_view.missionSummaryMc.lineMc_02.alpha = (this.m_view.missionSummaryMc.lineMc_03.alpha = (this.m_view.missionSummaryMc.lineMc_04.alpha = 1)));
		this.m_view.offlineTxt.visible = (this.m_view.silentAssassinMc.visible = (this.m_view.playStyleMc.visible = (this.m_view.leaderboardPosMc.visible = false)));
		this.formatNewBestTextFields(this.m_missionRatingMc);
		this.formatNewBestTextFields(this.m_missionTimeMc);
		this.formatNewBestTextFields(this.m_missionScoreMc);
		this.m_missionScoreMc.newBestBgNegative.alpha = 0;
		MenuUtils.setupTextUpper(this.m_view.leaderboardPosMc.lowTxt, Localization.get("UI_MENU_PAGE_DEBRIEFING_LEADERBOARDS_BOTTOM"), 14, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyLight);
		MenuUtils.setupTextUpper(this.m_view.leaderboardPosMc.titleTxt, Localization.get("UI_MENU_PAGE_DEBRIEFING_LEADERBOARDS_POSITION"), 14, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyLight);
		MenuUtils.setupTextUpper(this.m_view.leaderboardPosMc.highTxt, Localization.get("UI_MENU_PAGE_DEBRIEFING_LEADERBOARDS_TOP"), 14, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyLight);
		addChild(this.m_view);
	}

	override public function onSetData(_arg_1:Object):void {
		var _local_9:MovieClip;
		super.onSetData(_arg_1);
		this.playSound("ui_debrief_detailsscreen_open");
		this.m_isEvergreen = (_arg_1.ContractType == "evergreen");
		this.m_yOffset = ((_arg_1.Percentile != null) ? 395 : 153);
		var _local_2:* = (!(_arg_1.rating == null));
		var _local_3:int = ((_arg_1.rating != null) ? _arg_1.rating : 0);
		if (this.m_isEvergreen) {
			_local_2 = false;
		}
		;
		var _local_4:* = (_arg_1.animate === true);
		var _local_5:Boolean;
		var _local_6:* = "";
		var _local_7:* = (_local_3 >= 5);
		this.m_silentAssassinIsMedicineMan = false;
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
				MenuUtils.truncateTextfieldWithCharLimit(this.m_view.headerTxt, 1, MenuConstants.PLAYERNAME_MIN_CHAR_COUNT);
				MenuUtils.shrinkTextToFit(this.m_view.headerTxt, this.m_view.headerTxt.width, -1);
			}
			;
		}
		;
		if (!_arg_1.isonline) {
			this.m_view.offlineTxt.visible = true;
			MenuUtils.setupText(this.m_view.offlineTxt, Localization.get("UI_DIALOG_SCORE_OFFLINE"), 26, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
			return;
		}
		;
		if (_arg_1.silentAssassin != null) {
			_local_7 = _arg_1.silentAssassin;
		} else {
			if (_arg_1.MedicineMan != null) {
				_local_7 = _arg_1.MedicineMan;
				this.m_silentAssassinIsMedicineMan = true;
			}
			;
		}
		;
		if (((!(_arg_1.PlayStyle == null)) && (!(_local_7)))) {
			_local_6 = _arg_1.PlayStyle.Name;
			_local_5 = true;
		}
		;
		if (((!(this.m_isEvergreen)) && (!(_arg_1.IsNewBestScore == null)))) {
			if (_arg_1.IsNewBestScore) {
				this.m_isNewBestScore = true;
				MenuUtils.setupTextUpper(this.m_missionScoreMc.newBestTitle, Localization.get("UI_RATING_NEW_PERSONAL BEST"), 14, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraDark);
				this.showNewBest(this.m_missionScoreMc);
			}
			;
		}
		;
		if (((!(this.m_isEvergreen)) && (!(_arg_1.IsNewBestTime == null)))) {
			if (_arg_1.IsNewBestTime) {
				this.m_isNewBestTime = true;
				MenuUtils.setupTextUpper(this.m_missionTimeMc.newBestTitle, Localization.get("UI_RATING_NEW_PERSONAL BEST"), 14, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraDark);
				this.showNewBest(this.m_missionTimeMc);
			}
			;
		}
		;
		if (((!(this.m_isEvergreen)) && (!(_arg_1.IsNewBestStars == null)))) {
			if (_arg_1.IsNewBestStars) {
				this.m_isNewBestRating = true;
				MenuUtils.setupTextUpper(this.m_missionRatingMc.newBestTitle, Localization.get("UI_RATING_NEW_PERSONAL BEST"), 14, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraDark);
				this.showNewBest(this.m_missionRatingMc);
			}
			;
		}
		;
		var _local_8:int = 5;
		var _local_10:int = 1;
		while (_local_10 <= _local_8) {
			_local_9 = this.m_missionRatingMc.ratingIcons.getChildByName(("icon" + _local_10));
			MenuUtils.setColor(_local_9, MenuConstants.COLOR_WHITE, true, ((_local_2) ? 0.1 : 0));
			_local_10++;
		}
		;
		if (((!(this.m_isEvergreen)) && (!(_arg_1.Percentile == null)))) {
			this.setLeaderboardPositionChart(_arg_1.Percentile);
		}
		;
		if (_arg_1.scoresummary != null) {
			this.setMissionTime(_arg_1.scoresummary);
			this.setMissionScore(_arg_1.scoresummary, _arg_1.EvergreenPayout);
			if (this.m_isEvergreen) {
				this.setEvergreenDetailedPayout(_arg_1.EvergreenPayoutsCompleted, _arg_1.EvergreenPayoutsFailed, _arg_1.EvergreenIsFailed);
			} else {
				this.setPreliminaryScore(_arg_1.scoresummary);
			}
			;
		}
		;
		this.m_view.missionSummaryMc.y = (this.m_yOffset + 19);
		if ((((_local_2) || (_local_7)) || (_local_5))) {
			this.setMissionRating(_local_3, _local_7, _local_5, _local_6, _local_4, _arg_1);
		}
		;
	}

	private function setMissionRating(_arg_1:int, _arg_2:Boolean, _arg_3:Boolean, _arg_4:String, _arg_5:Boolean, _arg_6:Object):void {
		var _local_7:String;
		var _local_8:int;
		var _local_9:MovieClip;
		var _local_10:Number;
		var _local_11:int;
		var _local_12:int;
		var _local_13:String;
		var _local_14:int;
		var _local_15:Object;
		var _local_16:int;
		if (!this.m_isEvergreen) {
			_local_7 = Localization.get("UI_MENU_MISSION_END_RATING_TITLE");
			MenuUtils.setupTextUpper(this.m_missionRatingMc.ratingTitle, _local_7, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorRed);
			_local_8 = 5;
			_local_10 = 0;
			_local_11 = 1;
			while (_local_11 <= _local_8) {
				_local_9 = this.m_missionRatingMc.ratingIcons.getChildByName(("icon" + _local_11));
				if (this.m_isNewBestRating) {
					MenuUtils.setColor(_local_9, MenuConstants.COLOR_GREY_ULTRA_DARK, false);
				}
				;
				if (_local_11 <= _arg_1) {
					Animate.to(_local_9, 0.15, _local_10, {"alpha": 1}, Animate.ExpoOut);
					Animate.addFrom(_local_9, 0.3, _local_10, {
						"scaleX": 1.5,
						"scaleY": 1.5
					}, Animate.ExpoOut);
					_local_10 = (_local_10 + 0.05);
				}
				;
				_local_11++;
			}
			;
		} else {
			_local_12 = 0;
			if (((_arg_6.Challenges) && (_arg_6.Challenges.length > 0))) {
				_local_14 = 0;
				while (_local_14 < _arg_6.Challenges.length) {
					_local_15 = _arg_6.Challenges[_local_14];
					_local_16 = 0;
					if (_local_15.XPGain != undefined) {
						_local_16 = _local_15.XPGain;
					}
					;
					if (_local_16 > 0) {
						_local_12 = (_local_12 + _local_16);
					}
					;
					_local_14++;
				}
				;
			}
			;
			_local_13 = Localization.get("EVERGREEN_GAMEFLOW_XPGAINED_TITLE");
			MenuUtils.setupTextUpper(this.m_missionRatingMc.ratingTitle, _local_13, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorRed);
			MenuUtils.setupText(this.m_missionRatingMc.ratingValue, this.formatXpNumber(_local_12), 40, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorBlack);
			this.m_missionRatingMc.newBestBg.alpha = 1;
		}
		;
		if (_arg_2) {
			this.setSilentAssassin();
		} else {
			if (_arg_3) {
				this.setPlayStyle(_arg_4);
			}
			;
		}
		;
	}

	private function formatXpNumber(_arg_1:int):String {
		return ((MenuUtils.formatNumber(_arg_1) + " ") + Localization.get("UI_PERFORMANCE_MASTERY_XP"));
	}

	private function setLeaderboardPositionChart(_arg_1:Object):void {
		_arg_1.Spread.reverse();
		var _local_2:int = ((_arg_1.Spread.length - 1) - _arg_1.Index);
		_arg_1.Index = _local_2;
		var _local_3:Array = new Array();
		var _local_4:int;
		while (_local_4 <= (_arg_1.Spread.length - 1)) {
			_local_3.push(_arg_1.Spread[_local_4]);
			_local_4++;
		}
		;
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
			;
			_local_6++;
		}
		;
	}

	private function setMissionTime(_arg_1:Array):void {
		var _local_4:String;
		var _local_5:int;
		var _local_2:String = Localization.get("UI_MENU_MISSION_END_TIME_TITLE");
		var _local_3:* = "";
		if (_arg_1 != null) {
			_local_5 = 0;
			while (_local_5 < _arg_1.length) {
				if (((_arg_1[_local_5].type == "summary") && ((_arg_1[_local_5].headline == "UI_SCORING_SUMMARY_TIME") || (_arg_1[_local_5].headline == "UI_SNIPERSCORING_SUMMARY_TIME_BONUS")))) {
					_local_3 = _arg_1[_local_5].count;
				}
				;
				_local_5++;
			}
			;
		}
		;
		MenuUtils.setupTextUpper(this.m_missionTimeMc.timeTitle, _local_2, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorRed);
		if (this.m_isEvergreen) {
			_local_4 = MenuConstants.FontColorBlack;
		} else {
			if (this.m_isNewBestTime) {
				_local_4 = MenuConstants.FontColorGreyUltraDark;
			} else {
				_local_4 = MenuConstants.FontColorWhite;
			}
			;
		}
		;
		MenuUtils.setupText(this.m_missionTimeMc.timeValue, _local_3, 40, MenuConstants.FONT_TYPE_MEDIUM, _local_4);
		CommonUtils.changeFontToGlobalFont(this.m_missionTimeMc.timeValue);
		this.m_missionTimeMc.visible = true;
		if (this.m_isEvergreen) {
			this.m_missionTimeMc.newBestBg.alpha = 1;
		}
		;
	}

	private function setMissionScore(_arg_1:Array, _arg_2:Number):void {
		var _local_3:String;
		var _local_4:int;
		var _local_5:int;
		var _local_6:String;
		var _local_7:String;
		if (!this.m_isEvergreen) {
			_local_3 = Localization.get("UI_MENU_MISSION_END_SCORE_TITLE");
			_local_4 = 0;
			if (_arg_1 != null) {
				_local_5 = 0;
				while (_local_5 < _arg_1.length) {
					if (_arg_1[_local_5].type == "total") {
						_local_4 = _arg_1[_local_5].scoreTotal;
					}
					;
					_local_5++;
				}
				;
			}
			;
			MenuUtils.setupTextUpper(this.m_missionScoreMc.scoreTitle, _local_3, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorRed);
			MenuUtils.setupText(this.m_missionScoreMc.scoreValue, MenuUtils.formatNumber(_local_4), 40, MenuConstants.FONT_TYPE_MEDIUM, ((this.m_isNewBestScore) ? MenuConstants.FontColorGreyUltraDark : MenuConstants.FontColorWhite));
		} else {
			_arg_2 = ((_arg_2) ? _arg_2 : 0);
			if (_arg_2 < 0) {
				_local_6 = Localization.get("EVERGREEN_GAMEFLOW_MISSIONPAYOUT_LOST_TITLE");
				MenuUtils.setupTextUpper(this.m_missionScoreMc.scoreTitle, _local_6, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
				_local_7 = (MenuUtils.formatNumber(_arg_2) + Localization.get("UI_EVERGREEN_MERCES"));
				MenuUtils.setupText(this.m_missionScoreMc.scoreValue, _local_7, 40, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
				this.m_missionScoreMc.newBestBg.alpha = 0;
				this.m_missionScoreMc.newBestBgNegative.alpha = 1;
			} else {
				_local_6 = Localization.get("EVERGREEN_GAMEFLOW_MISSIONPAYOUT_TITLE");
				MenuUtils.setupTextUpper(this.m_missionScoreMc.scoreTitle, _local_6, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorRed);
				_local_7 = (MenuUtils.formatNumber(_arg_2) + Localization.get("UI_EVERGREEN_MERCES"));
				MenuUtils.setupText(this.m_missionScoreMc.scoreValue, _local_7, 40, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorBlack);
				this.m_missionScoreMc.newBestBg.alpha = 1;
				this.m_missionScoreMc.newBestBgNegative.alpha = 0;
			}
			;
		}
		;
	}

	private function setPreliminaryScore(_arg_1:Array):void {
		var _local_4:ScoreListElementView;
		this.addDottedLine(0, 0, this.m_view.preliminaryScoreMc);
		this.addDottedLine(0, 32, this.m_view.preliminaryScoreMc);
		var _local_2:Number = 250;
		var _local_3:Number = 0;
		MenuUtils.setupTextUpper(this.m_view.preliminaryScoreMc.headerTxt, Localization.get("UI_SNIPERSCORING_SUMMARY_PRELIMINARY"), 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		this.m_view.preliminaryScoreMc.headerTxt.y = (_local_3 + 5);
		var _local_5:int;
		while (_local_5 < _arg_1.length) {
			if (_arg_1[_local_5].type == "summary") {
				_local_4 = new ScoreListElementView();
				_local_4.x = _local_2;
				_local_4.y = (_local_3 + 4);
				MenuUtils.setupText(_local_4.titleTxt, Localization.get(_arg_1[_local_5].headline), 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
				MenuUtils.setupText(_local_4.valueTxt, MenuUtils.formatNumber(_arg_1[_local_5].scoreTotal), 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
				this.m_view.preliminaryScoreMc.addChild(_local_4);
				_local_3 = (_local_3 + 32);
			}
			;
			_local_5++;
		}
		;
		_local_3 = (_local_3 + 14);
		this.addDottedLine(0, _local_3, this.m_view.preliminaryScoreMc);
		this.m_yOffset = (this.m_yOffset + _local_3);
	}

	private function setEvergreenDetailedPayout(_arg_1:Array, _arg_2:Array, _arg_3:Boolean):void {
		var _local_9:String;
		this.addDottedLine(0, 0, this.m_view.preliminaryScoreMc);
		this.addDottedLine(0, 32, this.m_view.preliminaryScoreMc);
		var _local_4:Number = 250;
		var _local_5:Number = 0;
		MenuUtils.setupTextUpper(this.m_view.preliminaryScoreMc.headerTxt, Localization.get("UI_MENU_MISSION_END_DETAILS_EVERGREEN_MERCES_EARNED"), 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		this.m_view.preliminaryScoreMc.headerTxt.y = (_local_5 + 5);
		var _local_6:ScoreListElementView = new ScoreListElementView();
		_local_6.x = _local_4;
		_local_6.y = (_local_5 + 4);
		MenuUtils.setupText(_local_6.titleTxt, Localization.get("UI_MENU_MISSION_END_DETAILS_EVERGREEN_OBJECTIVE").toUpperCase(), 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		MenuUtils.setupText(_local_6.valueTxt, Localization.get("UI_MENU_MISSION_END_DETAILS_EVERGREEN_AMOUNT").toUpperCase(), 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		this.m_view.preliminaryScoreMc.addChild(_local_6);
		_local_5 = (_local_5 + 32);
		var _local_7:int;
		while (_local_7 < _arg_1.length) {
			_local_6 = new ScoreListElementView();
			_local_6.x = _local_4;
			_local_6.y = (_local_5 + 4);
			_local_9 = ((_arg_3) ? MenuConstants.FontColorRed : MenuConstants.FontColorWhite);
			MenuUtils.setupText(_local_6.titleTxt, Localization.get(_arg_1[_local_7].Name), 16, MenuConstants.FONT_TYPE_MEDIUM, _local_9);
			MenuUtils.setupText(_local_6.valueTxt, (MenuUtils.formatNumber(_arg_1[_local_7].Payout) + Localization.get("UI_EVERGREEN_MERCES")), 16, MenuConstants.FONT_TYPE_MEDIUM, _local_9);
			this.m_view.preliminaryScoreMc.addChild(_local_6);
			_local_5 = (_local_5 + 32);
			_local_7++;
		}
		;
		var _local_8:int;
		while (_local_8 < _arg_2.length) {
			_local_6 = new ScoreListElementView();
			_local_6.x = _local_4;
			_local_6.y = (_local_5 + 4);
			MenuUtils.setupText(_local_6.titleTxt, Localization.get(_arg_2[_local_8].Name), 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorRed);
			MenuUtils.setupText(_local_6.valueTxt, (MenuUtils.formatNumber(_arg_2[_local_8].Payout) + Localization.get("UI_EVERGREEN_MERCES")), 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorRed);
			this.m_view.preliminaryScoreMc.addChild(_local_6);
			_local_5 = (_local_5 + 32);
			_local_8++;
		}
		;
		_local_5 = (_local_5 + 14);
		this.addDottedLine(0, _local_5, this.m_view.preliminaryScoreMc);
		this.m_yOffset = (this.m_yOffset + _local_5);
	}

	private function setSilentAssassin():void {
		if (this.m_silentAssassinIsMedicineMan) {
			MenuUtils.setupTextUpper(this.m_view.silentAssassinMc.title, Localization.get("UI_RATING_MEDICINE_MAN").toUpperCase(), 28, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			MenuUtils.setColor(this.m_view.silentAssassinMc.bg, MenuConstants.COLOR_BLUE);
		} else {
			MenuUtils.setupTextUpper(this.m_view.silentAssassinMc.title, Localization.get("UI_RATING_SILENT_ASSASSIN").toUpperCase(), 28, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			MenuUtils.setColor(this.m_view.silentAssassinMc.bg, MenuConstants.COLOR_RED);
		}
		;
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
		var _local_2:int;
		var _local_3:MovieClip;
		if (_arg_1 == this.m_missionRatingMc) {
			_local_2 = 1;
			while (_local_2 <= 5) {
				_local_3 = this.m_missionRatingMc.ratingIcons.getChildByName(("icon" + _local_2));
				MenuUtils.setColor(_local_3, MenuConstants.COLOR_GREY_ULTRA_DARK, false);
				_local_2++;
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
			this.m_view.missionSummaryMc.lineMc_01.alpha = (this.m_view.missionSummaryMc.lineMc_02.alpha = 0);
		}
		;
		if (_arg_1 == this.m_missionTimeMc) {
			this.m_view.missionSummaryMc.lineMc_02.alpha = (this.m_view.missionSummaryMc.lineMc_03.alpha = 0);
		}
		;
		if (_arg_1 == this.m_missionScoreMc) {
			this.m_view.missionSummaryMc.lineMc_03.alpha = (this.m_view.missionSummaryMc.lineMc_04.alpha = 0);
		}
		;
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
		;
		var _local_2:int;
		while (_local_2 <= 9) {
			Animate.kill(this.m_view.leaderboardPosMc[("barMc_0" + _local_2)]);
			_local_2++;
		}
		;
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
		;
	}


}
}//package menu3.basic

