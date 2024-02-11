// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.MenuElementAvailabilityBase

package menu3 {
import menu3.basic.TextTickerUtil;
import menu3.indicator.IndicatorUtil;

import flash.display.Sprite;

import menu3.indicator.IIndicator;

import common.menu.MenuConstants;
import common.menu.MenuUtils;

import menu3.indicator.EscalationLevelIndicator;
import menu3.indicator.InPlaylistIndicator;
import menu3.indicator.LevelCountIndicator;
import menu3.indicator.VRIndicator;
import menu3.indicator.NoVRIndicator;
import menu3.indicator.FreeDlcIndicator;
import menu3.indicator.CompletionStatusIndicatorUtil;

import common.Localization;
import common.menu.textTicker;
import common.DateTimeUtils;

public dynamic class MenuElementAvailabilityBase extends MenuElementTileBase {

	protected const EEscalationLevelIndicator:int = 0;
	protected const EFreeDlcIndicator:int = 1;
	protected const EInPlaylistIndicator:int = 2;
	protected const ELevelCountIndicator:int = 3;
	protected const EVRIndicator:int = 4;

	private var m_contractState:String;
	private var m_icon:String;
	public var m_infoIndicator:*;
	public var m_valueIndicator:*;
	public var m_ElusiveIndicator:*;
	public var m_timeindicator:*;
	public var m_newIndicator:*;
	public var m_countDownTimer:CountDownTimer;
	private var m_tileView:*;
	private var m_tileSize:String;
	private var m_hasDLCIssues:Boolean;
	private var m_textTickerUtil:TextTickerUtil = new TextTickerUtil();
	private var m_indicatorUtil:IndicatorUtil = new IndicatorUtil();
	private var m_aboveBarcodeIndicator:Sprite = null;

	public function MenuElementAvailabilityBase(_arg_1:Object) {
		super(_arg_1);
	}

	protected function getIndicator(_arg_1:int):IIndicator {
		return (this.m_indicatorUtil.getIndicator(_arg_1));
	}

	public function setAgencyPickup(_arg_1:*, _arg_2:Object, _arg_3:String):void {
		var _local_6:int;
		if (!this.m_tileView) {
			this.m_tileView = _arg_1;
		}

		if (!this.m_tileSize) {
			this.m_tileSize = _arg_3;
		}

		this.m_hasDLCIssues = false;
		if (this.m_valueIndicator) {
			this.m_tileView.indicator.removeChild(this.m_valueIndicator);
			this.m_valueIndicator = null;
		}

		if (_arg_2.agencypickup == null) {
			return;
		}

		switch (this.m_tileSize) {
			case "large":
				this.m_valueIndicator = new ValueIndicatorLargeView();
				break;
			default:
				this.m_valueIndicator = new ValueIndicatorSmallView();
		}

		if (_arg_2.hidebarcode) {
			this.m_valueIndicator.header.width = (this.m_valueIndicator.title.width = 278);
		}

		this.m_valueIndicator.y = (this.m_tileView.tileBg.height - MenuConstants.ValueIndicatorYOffset);
		MenuUtils.setupText(this.m_valueIndicator.header, _arg_2.agencypickup.header, 18, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorGrey);
		var _local_4:String = _arg_2.agencypickup.title;
		if (((!(_arg_2.agencypickup.itemcount == null)) && (_arg_2.agencypickup.itemcount > 1))) {
			_local_4 = (_local_4 + (", x" + _arg_2.agencypickup.itemcount));
		}

		MenuUtils.setupText(this.m_valueIndicator.title, _local_4, 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		var _local_5:String = this.m_valueIndicator.title.htmlText;
		MenuUtils.truncateTextfield(this.m_valueIndicator.header, 1);
		MenuUtils.truncateTextfield(this.m_valueIndicator.title, 1);
		this.m_valueIndicator.valueIcon.icons.gotoAndStop(_arg_2.agencypickup.icon);
		if (_arg_2.agencypickup.rarity != "common") {
			switch (_arg_2.agencypickup.rarity) {
				case "uncommon":
					_local_6 = MenuConstants.COLOR_UNCOMMON;
					break;
				case "rare":
					_local_6 = MenuConstants.COLOR_RARE;
					break;
				case "legendary":
					_local_6 = MenuConstants.COLOR_LEGENDARY;
					break;
				default:
					_local_6 = MenuConstants.COLOR_COMMON;
			}

			MenuUtils.setupIcon(this.m_valueIndicator.valueIcon, _arg_2.agencypickup.icon, MenuConstants.COLOR_WHITE, true, true, _local_6, 1);
		} else {
			MenuUtils.setupIcon(this.m_valueIndicator.valueIcon, _arg_2.agencypickup.icon, MenuConstants.COLOR_WHITE, true, true, MenuConstants.COLOR_MENU_TABS_BACKGROUND, MenuConstants.MenuElementBackgroundAlpha);
		}

		this.m_textTickerUtil.clearOnly();
		this.m_textTickerUtil.addTextTicker(this.m_valueIndicator.title, _local_5);
		this.m_tileView.indicator.addChild(this.m_valueIndicator);
	}

	public function setAvailablity(_arg_1:*, _arg_2:Object, _arg_3:String):void {
		var _local_4:EscalationLevelIndicator;
		var _local_5:Boolean;
		var _local_6:String;
		var _local_7:int;
		var _local_8:InPlaylistIndicator;
		var _local_9:LevelCountIndicator;
		var _local_10:VRIndicator;
		var _local_11:NoVRIndicator;
		var _local_12:String;
		var _local_13:FreeDlcIndicator;
		if (!this.m_tileView) {
			this.m_tileView = _arg_1;
		}

		if (!this.m_tileSize) {
			this.m_tileSize = _arg_3;
		}

		if (this.m_aboveBarcodeIndicator == null) {
			this.m_aboveBarcodeIndicator = new Sprite();
			this.m_tileView.addChild(this.m_aboveBarcodeIndicator);
		}

		this.m_icon = _arg_2.icon;
		this.m_hasDLCIssues = false;
		this.clearIndicators();
		if (_arg_2.availability.available) {
			_local_5 = this.setupArcadeTimer(_arg_2);
			if (!_local_5) {
				if (((_arg_2.locked) || (_arg_2.masterylocked))) {
					_local_6 = ((_arg_2.masterylocked) ? "masterylocked" : "locked");
					this.setContractState(_local_6);
					if (_arg_2.totallevels != null) {
						_local_4 = new EscalationLevelIndicator(this.m_tileSize, this.m_tileView.tileBg.height);
						this.m_indicatorUtil.add(this.EEscalationLevelIndicator, _local_4, this.m_tileView.indicator, _arg_2);
					}

					switch (this.m_tileSize) {
						case "large":
							this.m_infoIndicator = new InfoIndicatorLargeView();
							break;
						default:
							this.m_infoIndicator = new InfoIndicatorSmallView();
					}

					this.m_infoIndicator.alpha = 0;
					MenuUtils.setColor(this.m_infoIndicator.darkBg, MenuConstants.COLOR_MENU_TABS_BACKGROUND, true, MenuConstants.MenuElementBackgroundAlpha);
					this.m_infoIndicator.y = (this.m_tileView.tileBg.height - MenuConstants.ValueIndicatorYOffset);
					MenuUtils.setupText(this.m_infoIndicator.title, _arg_2.lockedreason, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
					if (this.m_infoIndicator.title.numLines > 2) {
						_local_7 = ((this.m_infoIndicator.title.numLines - 2) * 24);
						this.m_infoIndicator.darkBg.height = (this.m_infoIndicator.darkBg.height + _local_7);
						this.m_infoIndicator.y = (this.m_infoIndicator.y - _local_7);
					}

					MenuUtils.setupIcon(this.m_infoIndicator.valueIcon, "info", MenuConstants.COLOR_WHITE, true, false);
					this.m_tileView.indicator.addChild(this.m_infoIndicator);
					if (this.isElusive(_arg_2)) {
						this.parseElusiveData(_arg_2);
					}

					if (((!(_arg_2.completionstate == null)) && (_arg_2.completionstate.length > 0))) {
						CompletionStatusIndicatorUtil.addIndicator(this.m_tileView.indicator, _arg_2.completionstate);
					}

				} else {
					if (_arg_2.totallevels != null) {
						this.setContractState("available");
						_local_4 = new EscalationLevelIndicator(this.m_tileSize, this.m_tileView.tileBg.height);
						this.m_indicatorUtil.add(this.EEscalationLevelIndicator, _local_4, this.m_tileView.indicator, _arg_2);
						if (((!(_arg_2.completionstate == null)) && (_arg_2.completionstate.length > 0))) {
							CompletionStatusIndicatorUtil.addIndicator(this.m_tileView.indicator, _arg_2.completionstate);
						}

					} else {
						if (((_arg_2.totallevels == null) && ((!(_arg_2.completionstate == null)) && (_arg_2.completionstate.length > 0)))) {
							this.setContractState("available");
							if (((!(_arg_2.completionstate == null)) && (_arg_2.completionstate.length > 0))) {
								CompletionStatusIndicatorUtil.addIndicator(this.m_tileView.indicator, _arg_2.completionstate);
							}

						} else {
							this.setContractState("available");
							this.parseElusiveData(_arg_2);
						}

					}

				}

			}

			if (_arg_2.isInPlaylist === true) {
				_local_8 = new InPlaylistIndicator(this.m_tileView.tileBg.width, this.m_tileView.tileBg.height);
				this.m_indicatorUtil.add(this.EInPlaylistIndicator, _local_8, this.m_aboveBarcodeIndicator, _arg_2);
				if (_arg_2.isMarkedForDeletion != undefined) {
					_local_8.markForDeletion(_arg_2.isMarkedForDeletion);
				}

			}

			if (((!(_arg_2.levelcount == null)) && (!(_arg_2.levelcounttotal == null)))) {
				_local_9 = new LevelCountIndicator(this.m_tileView.tileBg.width, this.m_tileView.tileBg.height);
				this.m_indicatorUtil.add(this.ELevelCountIndicator, _local_9, this.m_tileView.indicator, _arg_2);
			}

			if (_arg_2.vr === true) {
				_local_10 = new VRIndicator(this.m_tileView.tileBg.width, this.m_tileView.tileBg.height);
				this.m_indicatorUtil.add(this.EVRIndicator, _local_10, this.m_tileView.indicator, _arg_2);
			} else {
				if (_arg_2.novr === true) {
					_local_11 = new NoVRIndicator(this.m_tileView.tileBg.width, this.m_tileView.tileBg.height);
					this.m_indicatorUtil.add(this.EVRIndicator, _local_11, this.m_tileView.indicator, _arg_2);
				}

			}

		} else {
			switch (this.m_tileSize) {
				case "large":
					this.m_valueIndicator = new ValueIndicatorLargeView();
					break;
				default:
					this.m_valueIndicator = new ValueIndicatorSmallView();
			}

			this.m_textTickerUtil.clearOnly();
			_local_12 = _arg_2.availability.unavailable_reason;
			if (_arg_2.freedlc === true) {
				_local_13 = new FreeDlcIndicator(this.m_tileSize);
				this.m_indicatorUtil.add(this.EFreeDlcIndicator, _local_13, this.m_tileView.indicator, _arg_2);
			}

			switch (_local_12) {
				case "entitlements_missing":
					this.setContractState("shop");
					this.m_valueIndicator.y = (this.m_tileView.tileBg.height - MenuConstants.ValueIndicatorYOffset);
					MenuUtils.setupText(this.m_valueIndicator.title, Localization.get("UI_DIALOG_DLC_PURCHASE"), 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
					MenuUtils.truncateTextfield(this.m_valueIndicator.header, 1);
					MenuUtils.truncateTextfield(this.m_valueIndicator.title, 1);
					MenuUtils.setupIcon(this.m_valueIndicator.valueIcon, "arrowright", MenuConstants.COLOR_GREY_DARK, false, true, MenuConstants.COLOR_WHITE, 1, 0, true);
					this.m_textTickerUtil.addTextTicker(this.m_valueIndicator.title, Localization.get("UI_DIALOG_DLC_PURCHASE"));
					break;
				case "dlc_not_owned":
					this.setContractState("shop");
					this.m_valueIndicator.y = (this.m_tileView.tileBg.height - MenuConstants.ValueIndicatorYOffset);
					MenuUtils.setupText(this.m_valueIndicator.title, Localization.get("UI_DIALOG_DLC_PURCHASE"), 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
					MenuUtils.truncateTextfield(this.m_valueIndicator.header, 1);
					MenuUtils.truncateTextfield(this.m_valueIndicator.title, 1);
					MenuUtils.setupIcon(this.m_valueIndicator.valueIcon, "arrowright", MenuConstants.COLOR_GREY_DARK, false, true, MenuConstants.COLOR_WHITE, 1, 0, true);
					this.m_textTickerUtil.addTextTicker(this.m_valueIndicator.title, Localization.get("UI_DIALOG_DLC_PURCHASE"));
					break;
				case "dlc_not_installed":
					this.setContractState("download");
					this.m_valueIndicator.y = (this.m_tileView.tileBg.height - MenuConstants.ValueIndicatorYOffset);
					MenuUtils.setupText(this.m_valueIndicator.title, Localization.get("UI_DIALOG_DLC_DOWNLOAD"), 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
					MenuUtils.truncateTextfield(this.m_valueIndicator.title, 1);
					MenuUtils.setupIcon(this.m_valueIndicator.valueIcon, "arrowright", MenuConstants.COLOR_GREY_DARK, false, true, MenuConstants.COLOR_WHITE, 1, 0, true);
					this.m_textTickerUtil.addTextTicker(this.m_valueIndicator.title, Localization.get("UI_DIALOG_DLC_DOWNLOAD"));
					break;
				case "dlc_update_required":
					this.setContractState("update");
					this.m_valueIndicator.y = (this.m_tileView.tileBg.height - MenuConstants.ValueIndicatorYOffset);
					MenuUtils.setupText(this.m_valueIndicator.valuetitle, Localization.get("UI_DIALOG_DLC_DOWNLOAD"), 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
					MenuUtils.truncateTextfield(this.m_valueIndicator.valuetitle, 1);
					MenuUtils.setupIcon(this.m_valueIndicator.valueIcon, "downloading", MenuConstants.COLOR_GREY_DARK, false, true, MenuConstants.COLOR_WHITE, 1, 0, true);
					this.m_textTickerUtil.addTextTicker(this.m_valueIndicator.valuetitle, Localization.get("UI_DIALOG_DLC_DOWNLOAD"));
					break;
				case "dlc_downloading":
					this.setContractState("downloading");
					this.m_valueIndicator.y = (this.m_tileView.tileBg.height - MenuConstants.ValueIndicatorYOffset);
					MenuUtils.setupText(this.m_valueIndicator.valuetitle, Localization.get("UI_DIALOG_DLC_DOWNLOADING"), 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
					MenuUtils.truncateTextfield(this.m_valueIndicator.valuetitle, 1);
					MenuUtils.setupIcon(this.m_valueIndicator.valueIcon, this.m_contractState, MenuConstants.COLOR_GREY_DARK, false, true, MenuConstants.COLOR_WHITE, 1, 0, true);
					this.m_textTickerUtil.addTextTicker(this.m_valueIndicator.valuetitle, Localization.get("UI_DIALOG_DLC_DOWNLOADING"));
					if (_arg_2.availability.percentage_complete >= 0) {
						MenuUtils.setupText(this.m_valueIndicator.value, (Math.round((_arg_2.availability.percentage_complete * 100)) + "%"), 32, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
					}

					break;
				case "dlc_installing":
					this.setContractState("installing");
					this.m_valueIndicator.y = (this.m_tileView.tileBg.height - MenuConstants.ValueIndicatorYOffset);
					MenuUtils.setupText(this.m_valueIndicator.valuetitle, Localization.get("UI_DIALOG_DLC_INSTALLING"), 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
					MenuUtils.truncateTextfield(this.m_valueIndicator.valuetitle, 1);
					MenuUtils.setupIcon(this.m_valueIndicator.valueIcon, "downloading", MenuConstants.COLOR_GREY_DARK, false, true, MenuConstants.COLOR_WHITE, 1, 0, true);
					this.m_textTickerUtil.addTextTicker(this.m_valueIndicator.valuetitle, Localization.get("UI_DIALOG_DLC_INSTALLING"));
					if (_arg_2.availability.percentage_complete >= 0) {
						MenuUtils.setupText(this.m_valueIndicator.value, (Math.round((_arg_2.availability.percentage_complete * 100)) + "%"), 32, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
					}

					break;
				case "dlc_unknown":
					this.setContractState("unknown");
					this.m_valueIndicator.y = (this.m_tileView.tileBg.height - MenuConstants.ValueIndicatorYOffset);
					MenuUtils.setupText(this.m_valueIndicator.title, Localization.get("UI_DIALOG_DLC_UNKNOWN"), 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
					MenuUtils.truncateTextfield(this.m_valueIndicator.title, 1);
					this.m_valueIndicator.valueIcon.visible = false;
					this.m_textTickerUtil.addTextTicker(this.m_valueIndicator.title, Localization.get("UI_DIALOG_DLC_UNKNOWN"));
					break;
				default:
					this.setContractState("unknown");
					this.m_valueIndicator.y = (this.m_tileView.tileBg.height - MenuConstants.ValueIndicatorYOffset);
					MenuUtils.setupText(this.m_valueIndicator.title, Localization.get("UI_DIALOG_DLC_STATE_UNKNOWN"), 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
					MenuUtils.truncateTextfield(this.m_valueIndicator.title, 1);
					this.m_valueIndicator.valueIcon.visible = false;
					this.m_textTickerUtil.addTextTicker(this.m_valueIndicator.title, Localization.get("UI_DIALOG_DLC_STATE_UNKNOWN"));
			}

			this.m_hasDLCIssues = true;
			this.m_tileView.indicator.addChild(this.m_valueIndicator);
			this.parseElusiveData(_arg_2);
		}

	}

	private function clearIndicators():void {
		this.m_indicatorUtil.clearIndicators();
		if (((this.m_tileView == null) || (this.m_tileView.indicator == null))) {
			return;
		}

		if (this.m_timeindicator) {
			this.m_tileView.indicator.removeChild(this.m_timeindicator);
			this.m_timeindicator = null;
		}

		if (this.m_infoIndicator) {
			this.m_tileView.indicator.removeChild(this.m_infoIndicator);
			this.m_infoIndicator = null;
		}

		if (this.m_valueIndicator) {
			this.m_tileView.indicator.removeChild(this.m_valueIndicator);
			this.m_valueIndicator = null;
		}

		if (this.m_ElusiveIndicator) {
			this.m_tileView.indicator.removeChild(this.m_ElusiveIndicator);
			this.m_ElusiveIndicator = null;
		}

		if (this.m_newIndicator) {
			this.m_tileView.indicator.removeChild(this.m_newIndicator);
			this.m_newIndicator = null;
		}

		CompletionStatusIndicatorUtil.removeIndicator(this.m_tileView.indicator);
	}

	private function parseElusiveData(_arg_1:Object):void {
		var _local_2:Boolean;
		var _local_3:Boolean;
		var _local_4:textTicker;
		var _local_5:Number;
		var _local_6:Number;
		var _local_7:Number;
		var _local_8:Number;
		var _local_9:Boolean;
		var _local_10:String;
		var _local_11:Boolean;
		var _local_12:String;
		if ((((_arg_1.elusivecontractstate) && (!(_arg_1.elusivecontractstate == null))) && (!(_arg_1.elusivecontractstate == "")))) {
			_local_2 = false;
			_local_3 = false;
			if (((((!(_arg_1.playableSince == null)) && (!(_arg_1.playableSince == ""))) && (!(_arg_1.lastPlayedAt == null))) && (!(_arg_1.lastPlayedAt == "")))) {
				_local_5 = DateTimeUtils.parseUTCTimeStamp(_arg_1.playableSince).getTime();
				_local_6 = DateTimeUtils.parseUTCTimeStamp(_arg_1.lastPlayedAt).getTime();
				if (_local_6 < _local_5) {
					_local_2 = true;
				}

				_local_7 = DateTimeUtils.getUTCClockNow().getTime();
				_local_8 = DateTimeUtils.parseUTCTimeStamp(_arg_1.playableUntil).getTime();
				if (_local_7 >= _local_8) {
					_local_3 = true;
				}

			}

			switch (_arg_1.elusivecontractstate) {
				case "not_completed":
					this.parseTimedData(_arg_1);
					break;
				case "time_ran_out":
					if (!this.m_hasDLCIssues) {
						this.setContractState("failed");
					}

					this.showTimeRanOut();
					break;
				case "completed":
					if (!this.m_hasDLCIssues) {
						this.setContractState("completed");
					}

					switch (this.m_tileSize) {
						case "large":
							this.m_ElusiveIndicator = new ValueIndicatorLargeView();
							break;
						default:
							this.m_ElusiveIndicator = new ValueIndicatorSmallView();
					}

					this.m_ElusiveIndicator.y = ((this.m_hasDLCIssues) ? ((this.m_tileView.tileBg.height - MenuConstants.ValueIndicatorYOffset) - MenuConstants.ValueIndicatorHeight) : (this.m_tileView.tileBg.height - MenuConstants.ValueIndicatorYOffset));
					_local_9 = ((_local_2) && (!(_local_3)));
					_local_10 = ((_local_9) ? Localization.get("UI_CONTRACT_ELUSIVE_STATE_COMPLETED_PREVIOUSLY") : Localization.get("UI_CONTRACT_ELUSIVE_STATE_COMPLETED"));
					if (_local_9) {
						MenuUtils.setupText(this.m_ElusiveIndicator.titlelarge, _local_10, 22, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
						this.m_ElusiveIndicator.titlelarge.y = (this.m_ElusiveIndicator.titlelarge.y + 10);
					} else {
						MenuUtils.setupText(this.m_ElusiveIndicator.titlelarge, _local_10, 38, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
					}

					this.m_textTickerUtil.addTextTickerHtml(this.m_ElusiveIndicator.titlelarge);
					MenuUtils.truncateTextfield(this.m_ElusiveIndicator.titlelarge, 1);
					MenuUtils.setupIcon(this.m_ElusiveIndicator.valueIcon, this.m_contractState, MenuConstants.COLOR_WHITE, true, true, MenuConstants.COLOR_MENU_TABS_BACKGROUND, MenuConstants.MenuElementBackgroundAlpha);
					this.m_tileView.indicator.addChild(this.m_ElusiveIndicator);
					break;
				case "failed":
				case "completed_but_died":
					if (!this.m_hasDLCIssues) {
						this.setContractState("failed");
					}

					switch (this.m_tileSize) {
						case "large":
							this.m_ElusiveIndicator = new ValueIndicatorLargeView();
							break;
						default:
							this.m_ElusiveIndicator = new ValueIndicatorSmallView();
					}

					this.m_ElusiveIndicator.y = ((this.m_hasDLCIssues) ? ((this.m_tileView.tileBg.height - MenuConstants.ValueIndicatorYOffset) - MenuConstants.ValueIndicatorHeight) : (this.m_tileView.tileBg.height - MenuConstants.ValueIndicatorYOffset));
					_local_11 = ((_local_2) && (!(_local_3)));
					_local_12 = ((_local_11) ? Localization.get("UI_CONTRACT_ELUSIVE_STATE_COMPLETED_BUT_DIED_PREVIOUSLY") : Localization.get("UI_CONTRACT_ELUSIVE_STATE_COMPLETED_BUT_DIED"));
					if (_local_11) {
						MenuUtils.setupText(this.m_ElusiveIndicator.titlelarge, _local_12, 22, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
						this.m_ElusiveIndicator.titlelarge.y = (this.m_ElusiveIndicator.titlelarge.y + 10);
					} else {
						MenuUtils.setupText(this.m_ElusiveIndicator.titlelarge, _local_12, 38, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
					}

					this.m_textTickerUtil.addTextTickerHtml(this.m_ElusiveIndicator.titlelarge);
					MenuUtils.truncateTextfield(this.m_ElusiveIndicator.titlelarge, 1);
					MenuUtils.setupIcon(this.m_ElusiveIndicator.valueIcon, this.m_contractState, MenuConstants.COLOR_WHITE, true, true, MenuConstants.COLOR_MENU_TABS_BACKGROUND, MenuConstants.MenuElementBackgroundAlpha);
					this.m_tileView.indicator.addChild(this.m_ElusiveIndicator);
					break;
				default:
					this.parseTimedData(_arg_1);
			}

		} else {
			this.parseTimedData(_arg_1);
		}

	}

	private function setupArcadeTimer(_arg_1:Object):Boolean {
		var _local_2:Number = DateTimeUtils.getUTCClockNow().getTime();
		if (((((_arg_1.type == "arcade") && (_arg_1.errorType == "ContractNotPlayableYet")) && (_arg_1.playableSince)) && (_local_2 <= DateTimeUtils.parseUTCTimeStamp(_arg_1.playableSince).getTime()))) {
			if (this.m_countDownTimer) {
				this.m_countDownTimer.stopCountDown();
				this.m_countDownTimer = null;
			}

			this.m_countDownTimer = new CountDownTimer();
			if (_arg_1.masterylocked) {
				this.setContractState("masterylocked");
			} else {
				if (this.m_hasDLCIssues) {
					this.setContractState("locked");
				} else {
					this.setContractState("failed");
				}

			}

			this.showTimer(_arg_1.playableSince, Localization.get("UI_CONTRACT_ARCADE_STATE_FAILED"));
			return (true);
		}

		return (false);
	}

	private function parseTimedData(_arg_1:Object):void {
		if (this.m_countDownTimer) {
			this.m_countDownTimer.stopCountDown();
			this.m_countDownTimer = null;
		}

		var _local_2:Number = DateTimeUtils.getUTCClockNow().getTime();
		var _local_3:* = "playable";
		if (((_arg_1.playableSince) && (_local_2 <= DateTimeUtils.parseUTCTimeStamp(_arg_1.playableSince).getTime()))) {
			_local_3 = "notplayable";
		}

		if (((_arg_1.playableUntil) && (_local_2 >= DateTimeUtils.parseUTCTimeStamp(_arg_1.playableUntil).getTime()))) {
			_local_3 = "gone";
		}

		switch (_local_3) {
			case "notplayable":
				if (!this.m_countDownTimer) {
					this.m_countDownTimer = new CountDownTimer();
				}

				if (!this.m_hasDLCIssues) {
					this.setContractState("locked");
				}

				this.showTimer(_arg_1.playableSince, Localization.get("UI_DIALOG_TARGET_ARRIVES"));
				return;
			case "playable":
				if (((_arg_1.playableUntil) && (!(this.m_countDownTimer)))) {
					this.m_countDownTimer = new CountDownTimer();
				}

				if (!this.m_hasDLCIssues) {
					this.setContractState("available");
				}

				if (_arg_1.playableUntil) {
					this.showTimer(_arg_1.playableUntil);
				}

				return;
			case "gone":
				this.m_textTickerUtil.clearOnly();
				if (this.m_countDownTimer) {
					this.m_countDownTimer.stopCountDown();
					this.m_countDownTimer = null;
				}

				if (!this.m_hasDLCIssues) {
					this.setContractState("failed");
				}

				this.showTimeRanOut();
				return;
		}

	}

	private function isElusive(_arg_1:Object):Boolean {
		return ((_arg_1.elusivecontractstate) && (!(_arg_1.elusivecontractstate == "")));
	}

	private function isPlayable(_arg_1:Object):Boolean {
		var _local_3:Number;
		var _local_4:Number;
		var _local_2:Number = DateTimeUtils.getUTCClockNow().getTime();
		if (_arg_1.playableSince) {
			_local_3 = DateTimeUtils.parseUTCTimeStamp(_arg_1.playableSince).getTime();
			if (_local_2 < _local_3) {
				return (false);
			}

		}

		if (_arg_1.playableUntil) {
			_local_4 = DateTimeUtils.parseUTCTimeStamp(_arg_1.playableUntil).getTime();
			if (_local_2 >= _local_4) {
				return (false);
			}

		}

		return (true);
	}

	private function isStartedContract(_arg_1:Object):Boolean {
		return ((!(_arg_1.playableSince)) || (DateTimeUtils.parseUTCTimeStamp(_arg_1.playableSince).getTime() <= DateTimeUtils.getUTCClockNow().getTime()));
	}

	private function showTimeRanOut():void {
		switch (this.m_tileSize) {
			case "large":
				this.m_ElusiveIndicator = new ValueIndicatorLargeView();
				break;
			default:
				this.m_ElusiveIndicator = new ValueIndicatorSmallView();
		}

		this.m_ElusiveIndicator.y = ((this.m_hasDLCIssues) ? ((this.m_tileView.tileBg.height - MenuConstants.ValueIndicatorYOffset) - MenuConstants.ValueIndicatorHeight) : (this.m_tileView.tileBg.height - MenuConstants.ValueIndicatorYOffset));
		MenuUtils.setupText(this.m_ElusiveIndicator.titlelarge, Localization.get("UI_CONTRACT_ELUSIVE_STATE_TIME_RAN_OUT"), 38, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		MenuUtils.truncateTextfield(this.m_ElusiveIndicator.titlelarge, 1);
		this.m_textTickerUtil.addTextTicker(this.m_ElusiveIndicator.titlelarge, Localization.get("UI_CONTRACT_ELUSIVE_STATE_TIME_RAN_OUT"));
		MenuUtils.setupIcon(this.m_ElusiveIndicator.valueIcon, "timed", MenuConstants.COLOR_WHITE, true, true, MenuConstants.COLOR_MENU_TABS_BACKGROUND, MenuConstants.MenuElementBackgroundAlpha);
		this.m_tileView.indicator.addChild(this.m_ElusiveIndicator);
	}

	private function showTimer(_arg_1:String, _arg_2:String = null):void {
		if (!this.m_timeindicator) {
			switch (this.m_tileSize) {
				case "large":
					this.m_timeindicator = new TimeIndicatorLargeView();
					break;
				default:
					this.m_timeindicator = new TimeIndicatorSmallView();
			}

			this.m_timeindicator.y = ((this.m_hasDLCIssues) ? ((this.m_tileView.tileBg.height - MenuConstants.ValueIndicatorYOffset) - MenuConstants.ValueIndicatorHeight) : (this.m_tileView.tileBg.height - MenuConstants.ValueIndicatorYOffset));
			MenuUtils.setupIcon(this.m_timeindicator.valueIcon, "timed", MenuConstants.COLOR_WHITE, true, true, MenuConstants.COLOR_MENU_TABS_BACKGROUND, MenuConstants.MenuElementBackgroundAlpha);
			this.m_tileView.indicator.addChild(this.m_timeindicator);
		}

		if (_arg_2) {
			MenuUtils.setupTextUpper(this.m_timeindicator.header, _arg_2, 18, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorGrey);
			this.m_countDownTimer.startCountDown(this.m_timeindicator.title, _arg_1, this, 24, MenuConstants.FontColorWhite);
		} else {
			this.m_countDownTimer.startCountDown(this.m_timeindicator.titlelarge, _arg_1, this, 38, MenuConstants.FontColorWhite);
		}

	}

	public function timerComplete():void {
		this.m_countDownTimer.stopCountDown();
		this.m_countDownTimer = null;
		this.m_tileView.indicator.removeChild(this.m_timeindicator);
		this.m_timeindicator = null;
		var _local_1:Object = getData();
		if (_local_1.type == "arcade") {
			this.setAvailablity(this.m_tileView, _local_1, this.m_tileSize);
		} else {
			if (!this.m_hasDLCIssues) {
				if (((((!(_local_1.locked)) && (this.isElusive(_local_1))) && (this.m_contractState == "locked")) && (this.isStartedContract(_local_1)))) {
					if (this.m_infoIndicator) {
						this.m_tileView.indicator.removeChild(this.m_infoIndicator);
					}

					this.setContractState("available");
					this.parseTimedData(_local_1);
					return;
				}

				this.setContractState("failed");
			}

			this.showTimeRanOut();
		}

	}

	public function setContractState(_arg_1:String):void {
		this.m_contractState = _arg_1;
		switch (_arg_1) {
			case "available":
				this.m_tileView.tileIcon.icons.gotoAndStop(this.m_icon);
				break;
			case "locked":
				this.m_tileView.tileIcon.icons.gotoAndStop(this.m_icon);
				break;
			case "masterylocked":
				this.m_tileView.tileIcon.icons.gotoAndStop("locked");
				break;
			case "shop":
				this.m_tileView.tileIcon.icons.gotoAndStop(this.m_icon);
				break;
			case "download":
				this.m_tileView.tileIcon.icons.gotoAndStop(this.m_icon);
				break;
			case "downloading":
				this.m_tileView.tileIcon.icons.gotoAndStop(this.m_icon);
				break;
			case "installing":
				this.m_tileView.tileIcon.icons.gotoAndStop(this.m_icon);
				break;
			case "unknown":
				this.m_tileView.tileIcon.icons.gotoAndStop(this.m_icon);
				break;
		}

		this.setOverlayColor();
	}

	public function setOverlayColor(_arg_1:Boolean = false):void {
		var _local_2:String;
		if (((this.m_tileView == null) || (this.m_tileView.image == null))) {
			return;
		}

		if (_arg_1) {
			MenuUtils.setColorFilter(this.m_tileView.image, "selected");
		} else {
			_local_2 = ((this.m_contractState) ? this.m_contractState : "");
			MenuUtils.setColorFilter(this.m_tileView.image, _local_2);
		}

	}

	override protected function handleSelectionChange():void {
		this.m_textTickerUtil.callTextTicker(m_isSelected);
		this.m_indicatorUtil.callTextTickers(m_isSelected);
	}

	override public function onUnregister():void {
		this.clearIndicators();
		if (((!(this.m_tileView == null)) && (!(this.m_aboveBarcodeIndicator == null)))) {
			this.m_tileView.removeChild(this.m_aboveBarcodeIndicator);
			this.m_aboveBarcodeIndicator = null;
		}

		if (this.m_countDownTimer) {
			this.m_countDownTimer.stopCountDown();
			this.m_countDownTimer = null;
		}

		this.m_textTickerUtil.onUnregister();
		this.m_textTickerUtil = null;
		super.onUnregister();
	}


}
}//package menu3

