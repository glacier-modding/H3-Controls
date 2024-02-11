// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.MissionRewardPage

package menu3 {
import basic.InfoBoxWithBackground;

import flash.display.Sprite;

import common.menu.MenuConstants;
import common.menu.MenuUtils;
import common.Localization;
import common.Animate;

import flash.external.ExternalInterface;

public dynamic class MissionRewardPage extends MenuElementBase {

	private const IMAGE_REQUEST_MAX:Number = 3;
	private const TILE_WIDTH:Number = 232;
	private const TILE_HEIGHT:Number = 175;
	private const CONTENT_OFFSET_X:Number = 82;
	private const CONTENT_OFFSET_Y:Number = 370;
	private const START_ANIMATION_DELAY:Number = 0.5;
	private const TILE_ANIMATION_DELAY:Number = 1;

	private var m_view:MissionRewardPageView;
	private var m_infoView:InfoBoxWithBackground;
	private var m_opportunityTiles:Array = [];
	private var m_challengeTiles:Array = [];
	private var m_actionRewardTiles:Array = [];
	private var m_dropTiles:Array = [];
	private var m_opportunityTilesContainer:Sprite;
	private var m_challengeTilesContainer:Sprite;
	private var m_actionRewardTilesContainer:Sprite;
	private var m_dropTilesContainer:Sprite;
	private var m_loadImageQue:Array;
	private var m_showXP:Boolean;
	private var m_animationComplete:Boolean;
	private var m_maxTilesInRow:int = 7;
	private var m_rowCount:int = 0;
	private var m_horizontalTiles:Array = [];
	private var m_verticalTiles:Array = [];
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

	public function MissionRewardPage(_arg_1:Object) {
		super(_arg_1);
		this.m_animationComplete = false;
		this.m_infoView = new InfoBoxWithBackground();
		this.m_infoView.visible = false;
		this.m_infoView.x = -(MenuConstants.menuXOffset);
		this.m_infoView.y = 0;
		addChild(this.m_infoView);
		this.m_view = new MissionRewardPageView();
		this.m_view.visible = false;
		this.m_view.titleMc.mask = this.m_view.titleMask;
		this.m_view.titleMask.x = -(this.m_view.titleMask.width);
		addChild(this.m_view);
		this.m_locationMasteryBar = new MissionRewardBar(this.m_view.locationMastery);
		this.m_profileMasteryBar = new MissionRewardBar(this.m_view.profileMastery);
	}

	override public function onSetData(_arg_1:Object):void {
		var _local_16:Number;
		var _local_17:int;
		var _local_18:Object;
		var _local_19:int;
		var _local_20:int;
		var _local_21:Boolean;
		var _local_22:Boolean;
		super.onSetData(_arg_1);
		var _local_2:Object = _arg_1.LocationProgression;
		if (_local_2 == null) {
			_local_2 = new Object();
		}
		;
		var _local_3:Object = _arg_1.ProfileProgression;
		if (_local_3 == null) {
			_local_3 = new Object();
		}
		;
		if (_local_2.HideProgression != undefined) {
			this.m_showXP = (!(_local_2.HideProgression));
		} else {
			this.m_showXP = true;
		}
		;
		this.m_view.visible = true;
		MenuUtils.setupText(this.m_view.titleMc.label_txt, Localization.get("UI_MENU_PAGE_DEBRIEFING_SUCCESS"), 71, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorGreyDark);
		this.m_view.typeMc.visible = false;
		this.m_typeHeadlineStartPosY = this.m_view.typeMc.y;
		this.m_view.rewardDetailsMc.visible = false;
		this.m_locationMasteryBar.init(_local_2.LevelInfo);
		this.m_profileMasteryBar.init(_local_3.LevelInfo);
		if (_arg_1.loading) {
			return;
		}
		;
		Animate.legacyTo(this.m_view.titleMask, 0.5, {"x": 0}, Animate.ExpoIn);
		this.m_loadImageQue = [];
		if (_local_2.LevelInfo != undefined) {
			_local_16 = ((this.m_showXP) ? 0.78 : 0.4);
			Animate.delay(this.m_view, _local_16, this.initPage, null);
			if (this.m_showXP) {
				this.m_locationMasteryBar.animateShowBar();
				this.m_profileMasteryBar.animateShowBar();
			}
			;
		}
		;
		if (((_arg_1.OpportunityRewards) && (_arg_1.OpportunityRewards.length > 0))) {
			this.addOpportunityTiles(_arg_1.OpportunityRewards);
		}
		;
		var _local_4:Array = new Array();
		var _local_5:Array = new Array();
		if (((_arg_1.Challenges) && (_arg_1.Challenges.length > 0))) {
			_local_17 = 0;
			while (_local_17 < _arg_1.Challenges.length) {
				_local_18 = _arg_1.Challenges[_local_17];
				if (_local_18.IsActionReward === true) {
					_local_5.push(_local_18);
				} else {
					_local_4.push(_local_18);
				}
				;
				_local_17++;
			}
			;
		}
		;
		if (((!(_local_4 == null)) && (_local_4.length > 0))) {
			this.addChallengeTiles(_local_4);
		}
		;
		if (((!(_local_5 == null)) && (_local_5.length > 0))) {
			this.addActionRewardTiles(_local_5);
		}
		;
		if (((_arg_1.Drops) && (_arg_1.Drops.length > 0))) {
			this.addDropsTiles(_arg_1.Drops);
		}
		;
		var _local_6:int;
		while (_local_6 < Math.min(this.IMAGE_REQUEST_MAX, this.m_loadImageQue.length)) {
			this.loadImageFromQue();
			_local_6++;
		}
		;
		this.m_opportunityCountEnd = 0;
		this.m_opportunityCountMax = 0;
		if (_arg_1.OpportunityStatistics != undefined) {
			this.m_opportunityCountEnd = _arg_1.OpportunityStatistics.Completed;
			this.m_opportunityCountMax = _arg_1.OpportunityStatistics.Count;
		}
		;
		this.m_locationChallengeCountEnd = 0;
		this.m_locationChallengeCountMax = 0;
		if (_arg_1.ChallengeCompletion != undefined) {
			this.m_locationChallengeCountEnd = _arg_1.ChallengeCompletion.CompletedChallengesCount;
			this.m_locationChallengeCountMax = _arg_1.ChallengeCompletion.ChallengesCount;
		}
		;
		this.m_contractChallengeCountEnd = 0;
		this.m_contractChallengeCountMax = 0;
		if (_arg_1.ContractChallengeCompletion != undefined) {
			this.m_contractChallengeCountEnd = _arg_1.ContractChallengeCompletion.CompletedChallengesCount;
			this.m_contractChallengeCountMax = _arg_1.ContractChallengeCompletion.ChallengesCount;
		}
		;
		var _local_7:Number = 0;
		var _local_8:int;
		if (this.m_challengeTiles != null) {
			_local_19 = 0;
			while (_local_19 < this.m_challengeTiles.length) {
				if (this.m_challengeTiles[_local_19].XPGain != undefined) {
					_local_7 = (_local_7 + this.m_challengeTiles[_local_19].XPGain);
				}
				;
				if (!this.m_challengeTiles[_local_19].IsGlobal) {
					_local_8++;
				}
				;
				_local_19++;
			}
			;
		}
		;
		if (this.m_actionRewardTiles != null) {
			_local_20 = 0;
			while (_local_20 < this.m_actionRewardTiles.length) {
				if (this.m_actionRewardTiles[_local_20].XPGain != undefined) {
					_local_7 = (_local_7 + this.m_actionRewardTiles[_local_20].XPGain);
				}
				;
				_local_20++;
			}
			;
		}
		;
		this.m_locationChallengeCount = Math.max((this.m_locationChallengeCountEnd - _local_8), 0);
		this.m_contractChallengeCount = Math.max((this.m_contractChallengeCountEnd - _local_8), 0);
		var _local_9:int = ((this.m_opportunityTiles != null) ? this.m_opportunityTiles.length : 0);
		this.m_opportunityCount = Math.max((this.m_opportunityCountEnd - _local_9), 0);
		this.updateChallengeCountText();
		var _local_10:Number = 0;
		if (_local_2.XP != undefined) {
			_local_10 = _local_2.XP;
		}
		;
		var _local_11:Number = 0;
		if (_local_2.XPGain != undefined) {
			_local_11 = _local_2.XPGain;
		}
		;
		if (_local_10 > 0) {
			_local_21 = this.m_locationMasteryBar.isLevelMaxed(_local_10);
			if (((!(_local_21)) || (_local_11 >= _local_7))) {
				_local_11 = _local_7;
			}
			;
		}
		;
		var _local_12:Number = Math.max((_local_10 - _local_11), 0);
		this.m_locationMasteryBar.setXpValues(_local_12, _local_10, Localization.get("UI_MENU_PAGE_PROFILE_LOCATION_MASTERY"));
		var _local_13:Number = 0;
		if (_local_3.XP != undefined) {
			_local_13 = _local_3.XP;
		}
		;
		var _local_14:Number = 0;
		if (_local_3.XPGain != undefined) {
			_local_14 = _local_3.XPGain;
		}
		;
		if (_local_13 > 0) {
			_local_22 = this.m_profileMasteryBar.isLevelMaxed(_local_13);
			if (((!(_local_22)) || (_local_14 >= _local_7))) {
				_local_14 = _local_7;
			}
			;
		}
		;
		var _local_15:Number = Math.max((_local_13 - _local_14), 0);
		this.m_profileMasteryBar.setXpValues(_local_15, _local_13, Localization.get("UI_MENU_PAGE_PROFILE_PLAYER_MASTERY"));
	}

	private function updateChallengeCountText():void {
		var _local_3:String;
		var _local_1:String = ((((Localization.get("UI_MENU_PAGE_PROFILE_LOCATION_CHALLENGES") + " ") + String(this.m_contractChallengeCount)) + "/") + String(this.m_contractChallengeCountMax));
		var _local_2:String = ((((Localization.get("UI_MENU_PAGE_PROFILE_MISSION_CHALLENGES") + " ") + String(this.m_locationChallengeCount)) + "/") + String(this.m_locationChallengeCountMax));
		MenuUtils.setupText(this.m_view.missionChallengesTxt, _local_1, 28, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyDark);
		MenuUtils.setupText(this.m_view.locationChallengesTxt, _local_2, 28, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyDark);
		if ((((!(getData().OpportunityStatistics == null)) && (!(getData().OpportunityStatistics.Count == null))) && (getData().OpportunityStatistics.Count > 0))) {
			_local_3 = ((((Localization.get("UI_MENU_PAGE_PROFILE_STATISTICS_CATEGORY_PROFILE_COMPLETEDOPPORTUNITIES") + " ") + String(this.m_opportunityCount)) + "/") + String(this.m_opportunityCountMax));
			MenuUtils.setupText(this.m_view.opportunityTxt, _local_3, 28, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyDark);
		}
		;
	}

	private function getImagePath(_arg_1:Object):String {
		if (((_arg_1.image) && (_arg_1.image.length > 0))) {
			return (_arg_1.image);
		}
		;
		return (null);
	}

	private function createTilesContainer(_arg_1:Array):Sprite {
		var _local_4:Object;
		var _local_5:MissionRewardItem;
		var _local_6:String;
		var _local_2:Sprite = new Sprite();
		_local_2.x = this.CONTENT_OFFSET_X;
		_local_2.y = this.CONTENT_OFFSET_Y;
		_local_2.visible = false;
		this.m_view.addChild(_local_2);
		var _local_3:int;
		while (_local_3 < _arg_1.length) {
			_local_4 = _arg_1[_local_3];
			_local_5 = new MissionRewardItem();
			_local_5.visible = false;
			_local_6 = this.getImagePath(_local_4);
			if (((!(_local_6 == null)) && (_local_6.length > 0))) {
				this.m_loadImageQue.push({
					"view": _local_5,
					"path": _local_6
				});
			}
			;
			_arg_1[_local_3].view = _local_5;
			_local_2.addChild(_local_5);
			_local_3++;
		}
		;
		return (_local_2);
	}

	private function addOpportunityTiles(_arg_1:Array):void {
		this.m_opportunityTiles = _arg_1;
		this.m_opportunityTilesContainer = this.createTilesContainer(this.m_opportunityTiles);
	}

	private function addChallengeTiles(_arg_1:Array):void {
		this.m_challengeTiles = _arg_1;
		this.m_challengeTilesContainer = this.createTilesContainer(this.m_challengeTiles);
	}

	private function addActionRewardTiles(_arg_1:Array):void {
		this.m_actionRewardTiles = _arg_1;
		this.m_actionRewardTilesContainer = this.createTilesContainer(this.m_actionRewardTiles);
	}

	private function addDropsTiles(_arg_1:Array):void {
		this.m_dropTiles = _arg_1;
		this.m_dropTilesContainer = this.createTilesContainer(this.m_dropTiles);
	}

	private function initPage(_arg_1:*):void {
		Animate.delay(this.m_view, this.START_ANIMATION_DELAY, this.animateOpportunityTiles, 0);
	}

	private function updateXP(xpGain:Number):void {
		if (this.m_showXP) {
			this.m_locationMasteryBar.updateXPBar(xpGain);
			this.m_profileMasteryBar.updateXPBar(xpGain);
			this.m_view.rewardDetailsMc.visible = true;
			this.m_view.rewardDetailsMc.xpMc.alpha = 0;
			MenuUtils.setupText(this.m_view.rewardDetailsMc.xpMc.label_txt, String(("+" + xpGain)), 45, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyDark);
			this.m_view.rewardDetailsMc.xpMc.x = -40;
			this.m_view.rewardDetailsMc.xpMc.y = 20;
			Animate.legacyTo(this.m_view.rewardDetailsMc.xpMc, 0.2, {
				"alpha": 1,
				"x": 0
			}, Animate.ExpoOut);
			Animate.delay(this.m_view.rewardDetailsMc.xpMc, 0.1, function ():void {
				Animate.legacyTo(m_view.rewardDetailsMc.xpMc, 0.2, {
					"alpha": 0,
					"y": 60
				}, Animate.ExpoIn);
			});
		}
		;
	}

	private function checkTileVertical(_arg_1:Object):void {
		var _local_3:int;
		var _local_4:int;
		var _local_2:Number = 0;
		if (this.m_horizontalTiles.length == this.m_maxTilesInRow) {
			this.m_verticalTiles.unshift(this.m_horizontalTiles.concat());
			this.m_horizontalTiles = [];
			if (this.m_rowCount == 0) {
				Animate.legacyTo(this.m_view.typeMc, 0.3, {"y": (this.m_view.typeMc.y - this.TILE_HEIGHT)}, Animate.ExpoOut);
			}
			;
			_local_3 = (this.m_verticalTiles.length - 1);
			while (_local_3 >= 0) {
				_local_4 = 0;
				while (_local_4 < this.m_verticalTiles[_local_3].length) {
					Animate.delay(this.m_verticalTiles[_local_3][_local_4], _local_2, this.moveTileVertical, this.m_verticalTiles[_local_3][_local_4], _local_3);
					_local_2 = (_local_2 + 0.015);
					_local_4++;
				}
				;
				_local_3--;
			}
			;
			this.m_rowCount++;
		}
		;
		this.m_horizontalTiles.unshift((_arg_1.view as MissionRewardItem));
		if (this.m_horizontalTiles.length > 1) {
			_local_3 = 1;
			while (_local_3 < Math.min(this.m_horizontalTiles.length, this.m_maxTilesInRow)) {
				Animate.legacyTo(this.m_horizontalTiles[_local_3], 0.3, {"x": (this.TILE_WIDTH * _local_3)}, Animate.ExpoOut);
				_local_3++;
			}
			;
		}
		;
		Animate.delay(_arg_1.view, _local_2, _arg_1.view.animateIn, null);
	}

	public function moveTileVertical(_arg_1:MissionRewardItem, _arg_2:int):void {
		var _local_3:Number = -(this.TILE_HEIGHT * (_arg_2 + 1));
		if (_arg_2 > 0) {
			_arg_1.animateOut(null);
		} else {
			Animate.legacyTo(_arg_1, 0.15, {"y": _local_3}, Animate.ExpoOut);
		}
		;
	}

	private function animateSingleTile(tile:Object, type:String, header:String):void {
		this.m_view.rewardDetailsMc.visible = true;
		this.m_view.rewardDetailsMc.alpha = 1;
		MenuUtils.setupText(this.m_view.rewardDetailsMc.typeMc.label_txt, type, 18, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorGreyDark);
		MenuUtils.setupText(this.m_view.rewardDetailsMc.headerMc.label_txt, header, 26, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyDark);
		this.m_view.rewardDetailsMc.typeMc.alpha = 0;
		this.m_view.rewardDetailsMc.typeMc.x = (this.m_view.rewardDetailsMc.typeMc.x - 20);
		this.m_view.rewardDetailsMc.headerMc.alpha = 0;
		this.m_view.rewardDetailsMc.headerMc.x = (this.m_view.rewardDetailsMc.headerMc.x - 20);
		this.checkTileVertical(tile);
		Animate.delay(this.m_view.rewardDetailsMc.headerMc, 0.2, function ():void {
			Animate.legacyTo(m_view.rewardDetailsMc.typeMc, 0.3, {
				"alpha": 1,
				"x": (m_view.rewardDetailsMc.typeMc.x + 20)
			}, Animate.ExpoOut);
		});
		Animate.delay(this.m_view.rewardDetailsMc.headerMc, 0.25, function ():void {
			Animate.legacyTo(m_view.rewardDetailsMc.headerMc, 0.2, {
				"alpha": 1,
				"x": (m_view.rewardDetailsMc.headerMc.x + 20)
			}, Animate.ExpoOut);
		});
	}

	public function animateOpportunityTiles(currentTileNum:int):void {
		var currentTile:Object;
		if (((!(this.m_opportunityTiles)) || (this.m_opportunityTiles.length == 0))) {
			this.animateChallengeTiles(0);
			return;
		}
		;
		this.m_opportunityTilesContainer.visible = true;
		this.m_view.typeMc.visible = true;
		MenuUtils.setupText(this.m_view.typeMc.label_txt, Localization.get("UI_MENU_PAGE_PROFILE_STATISTICS_CATEGORY_PROFILE_COMPLETEDOPPORTUNITIES"), 45, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyDark);
		if (currentTileNum < this.m_opportunityTiles.length) {
			currentTile = this.m_opportunityTiles[currentTileNum];
			this.animateSingleTile(currentTile, Localization.get("UI_OPPORTUNITIES_COMPLETED_TEXT"), Localization.get(currentTile.OpportunityName));
			this.m_opportunityCount = Math.min((this.m_opportunityCount + 1), this.m_opportunityCountEnd);
			Animate.delay(this.m_view.rewardDetailsMc.xpMc, 0.3, this.updateChallengeCountText, null);
			this.playSound("ShowChallenge");
			Animate.delay(this.m_view, this.TILE_ANIMATION_DELAY, this.animateOpportunityTiles, (currentTileNum + 1));
		} else {
			this.m_view.typeMc.visible = false;
			this.m_view.typeMc.y = this.m_typeHeadlineStartPosY;
			Animate.kill(this.m_view);
			Animate.legacyTo(this.m_view.rewardDetailsMc, 0.5, {"alpha": 0}, Animate.ExpoOut, function ():void {
				m_horizontalTiles = [];
				m_verticalTiles = [];
				m_rowCount = 0;
				Animate.legacyTo(m_opportunityTilesContainer, 0.2, {"alpha": 0}, Animate.ExpoOut);
				Animate.delay(m_view, 0.2, animateChallengeTiles, 0);
			});
		}
		;
	}

	public function animateChallengeTiles(currentTileNum:int):void {
		var currentChallengeTile:Object;
		if (((!(this.m_challengeTiles)) || (this.m_challengeTiles.length == 0))) {
			this.animateActionRewardTiles(0);
			return;
		}
		;
		this.m_challengeTilesContainer.visible = true;
		this.m_view.typeMc.visible = true;
		MenuUtils.setupText(this.m_view.typeMc.label_txt, Localization.get("UI_MENU_PAGE_PROFILE_STATISTICS_CATEGORY_PROFILE_COMPLETEDCHALLENGES"), 45, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyDark);
		if (currentTileNum < this.m_challengeTiles.length) {
			currentChallengeTile = this.m_challengeTiles[currentTileNum];
			this.animateSingleTile(currentChallengeTile, Localization.get("UI_DIALOG_TITLE_CHALLENGE_COMPLETED"), Localization.get(currentChallengeTile.ChallengeName));
			if (currentChallengeTile.XPGain) {
				Animate.delay(this.m_view.rewardDetailsMc.xpMc, 0.3, this.updateXP, currentChallengeTile.XPGain);
			}
			;
			if (!currentChallengeTile.IsGlobal) {
				this.m_contractChallengeCount = Math.min((this.m_contractChallengeCount + 1), this.m_contractChallengeCountEnd);
				this.m_locationChallengeCount = Math.min((this.m_locationChallengeCount + 1), this.m_locationChallengeCountEnd);
				Animate.delay(this.m_view.rewardDetailsMc.xpMc, 0.3, this.updateChallengeCountText, null);
			}
			;
			this.playSound("ShowChallenge");
			Animate.delay(this.m_view, this.TILE_ANIMATION_DELAY, this.animateChallengeTiles, (currentTileNum + 1));
		} else {
			this.m_view.typeMc.visible = false;
			this.m_view.typeMc.y = this.m_typeHeadlineStartPosY;
			this.m_locationMasteryBar.showXPLeft();
			this.m_profileMasteryBar.showXPLeft();
			Animate.kill(this.m_view);
			Animate.legacyTo(this.m_view.rewardDetailsMc, 0.5, {"alpha": 0}, Animate.ExpoOut, function ():void {
				m_horizontalTiles = [];
				m_verticalTiles = [];
				m_rowCount = 0;
				Animate.legacyTo(m_challengeTilesContainer, 0.2, {"alpha": 0}, Animate.ExpoOut);
				Animate.delay(m_view, 0.2, animateActionRewardTiles, 0);
			});
		}
		;
	}

	public function animateActionRewardTiles(currentTileNum:int):void {
		var currentActionRewardTile:Object;
		if (((!(this.m_actionRewardTiles)) || (this.m_actionRewardTiles.length == 0))) {
			this.animateDropTiles(0);
			this.m_locationMasteryBar.showXPLeft();
			this.m_profileMasteryBar.showXPLeft();
			return;
		}
		;
		this.m_actionRewardTilesContainer.visible = true;
		this.m_view.typeMc.visible = true;
		MenuUtils.setupText(this.m_view.typeMc.label_txt, Localization.get("UI_MENU_ACTIONREWARD_CATEGORY_TITLE"), 45, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyDark);
		if (currentTileNum < this.m_actionRewardTiles.length) {
			currentActionRewardTile = this.m_actionRewardTiles[currentTileNum];
			this.animateSingleTile(currentActionRewardTile, Localization.get("UI_MENU_ACTIONREWARD_TITLE"), Localization.get(currentActionRewardTile.ChallengeName));
			if (currentActionRewardTile.XPGain) {
				Animate.delay(this.m_view.rewardDetailsMc.xpMc, 0.3, this.updateXP, currentActionRewardTile.XPGain);
			}
			;
			this.playSound("ShowChallenge");
			Animate.delay(this.m_view, this.TILE_ANIMATION_DELAY, this.animateActionRewardTiles, (currentTileNum + 1));
		} else {
			this.m_view.typeMc.visible = false;
			this.m_view.typeMc.y = this.m_typeHeadlineStartPosY;
			this.m_locationMasteryBar.showXPLeft();
			this.m_profileMasteryBar.showXPLeft();
			Animate.kill(this.m_view);
			Animate.legacyTo(this.m_view.rewardDetailsMc, 0.5, {"alpha": 0}, Animate.ExpoOut, function ():void {
				var _local_1:Number;
				if (((!(m_dropTiles == null)) && (m_dropTiles.length > 0))) {
					m_horizontalTiles = [];
					m_verticalTiles = [];
					m_rowCount = 0;
					Animate.legacyTo(m_actionRewardTilesContainer, 0.2, {"alpha": 0}, Animate.ExpoOut);
					_local_1 = 0.2;
					Animate.delay(m_view, _local_1, animateDropTiles, 0);
				}
				;
			});
		}
		;
	}

	public function animateDropTiles(_arg_1:int):void {
		var _local_2:Object;
		if (((!(this.m_dropTiles)) || (this.m_dropTiles.length == 0))) {
			this.m_animationComplete = true;
			return;
		}
		;
		this.m_dropTilesContainer.visible = true;
		this.m_view.rewardDetailsMc.visible = true;
		this.m_view.rewardDetailsMc.alpha = 1;
		this.m_view.typeMc.visible = true;
		MenuUtils.setupText(this.m_view.typeMc.label_txt, Localization.get("UI_MENU_PAGE_DEBRIEFING_DROPS"), 45, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyDark);
		if (_arg_1 < this.m_dropTiles.length) {
			_local_2 = this.m_dropTiles[_arg_1];
			this.animateSingleTile(_local_2, _local_2.type, _local_2.name);
			this.playSound("ShowDrop");
			Animate.delay(this.m_view, this.TILE_ANIMATION_DELAY, this.animateDropTiles, (_arg_1 + 1));
		} else {
			Animate.legacyTo(this.m_view.rewardDetailsMc, 1, {"alpha": 0}, Animate.ExpoOut);
			Animate.kill(this.m_view);
			this.m_animationComplete = true;
		}
		;
	}

	private function loadImageFromQue():void {
		var _local_1:Object;
		if (this.m_loadImageQue.length > 0) {
			_local_1 = this.m_loadImageQue.shift();
			_local_1.view.loadImage(_local_1.path, this.loadImageFromQue, this.loadImageFromQue);
		}
		;
	}

	public function playSound(_arg_1:String):void {
		ExternalInterface.call("PlaySound", _arg_1);
	}

	public function isAnimationComplete():Boolean {
		return (this.m_animationComplete);
	}

	override public function onUnregister():void {
		trace("MissionRewardPage, onUnregister, m_view:", this.m_view);
		if (this.m_view) {
			Animate.kill(this.m_view);
			if (this.m_locationMasteryBar != null) {
				this.m_locationMasteryBar.onUnregister();
				this.m_locationMasteryBar = null;
			}
			;
			if (this.m_profileMasteryBar != null) {
				this.m_profileMasteryBar.onUnregister();
				this.m_profileMasteryBar = null;
			}
			;
			trace("MissionRewardPage, onUnregister, rewardDetails:", this.m_view.rewardDetailsMc);
			if (this.m_view.rewardDetailsMc) {
				Animate.kill(this.m_view.rewardDetailsMc);
			}
			;
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
		;
	}

	private function clearTiles(_arg_1:Sprite, _arg_2:Array):void {
		var _local_3:int;
		var _local_4:Object;
		if (((!(_arg_2 == null)) && (!(_arg_1 == null)))) {
			_local_3 = 0;
			while (_local_3 < _arg_2.length) {
				_local_4 = _arg_2[_local_3];
				if (_local_4.view != null) {
					Animate.kill(_local_4.view);
					_arg_1.removeChild(_local_4.view);
				}
				;
				_local_3++;
			}
			;
			this.m_view.removeChild(_arg_1);
		}
		;
	}


}
}//package menu3

