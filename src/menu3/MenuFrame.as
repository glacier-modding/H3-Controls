// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.MenuFrame

package menu3 {
import common.BaseControl;

import flash.display.Sprite;
import flash.display.Shape;

import menu3.basic.ProfileElement;

import common.menu.textTicker;

import menu3.basic.MasteryElement;

import flash.geom.Matrix;

import common.menu.MenuConstants;

import flash.display.Graphics;
import flash.display.GradientType;
import flash.display.SpreadMethod;
import flash.display.InterpolationMethod;
import flash.text.TextFieldAutoSize;

import basic.ButtonPromtUtil;

import common.TaskletSequencer;

import flash.text.TextField;

import common.Animate;
import common.Localization;
import common.menu.MenuUtils;
import common.CommonUtils;
import common.Log;

import flash.display.DisplayObject;
import flash.geom.Point;
import flash.utils.*;

public class MenuFrame extends BaseControl {

	private const MENU_BG_COLOR:uint = 4211016;
	private const MENU_COLOR_OVERLAY:uint = 3753292;

	private var m_width:Number;
	private var m_height:Number;
	private var m_view:MenuFrameView;
	private var m_backgroundContainer:Sprite;
	private var m_background:Sprite;
	private var m_backgroundLayer:Sprite;
	private var m_foreground:Sprite;
	private var m_mapContainer:Sprite;
	private var m_overlayContainer:Sprite;
	private var m_container:Sprite;
	private var m_pageContent:Sprite;
	private var m_userLine:Sprite;
	private var m_greyBackground:Sprite;
	private var m_backgroundOverlay:Sprite;
	private var m_menuBackgroundInGame:MenuBackground;
	private var m_menuTopBottomOverlay:Shape;
	private var m_menuFullOverlay:Shape;
	private var m_greyGradientBackdropLevelEnd:Shape;
	private var m_darkBackdrop:Shape;
	private var m_darkBackdropLevelEnd:Shape;
	private var m_failedBackdrop:Shape;
	private var m_horizGradientOverlay:Shape;
	private var m_profileElement:ProfileElement;
	private var m_multiplayerProfileElement:ProfileElement;
	private var m_historyBar:MenuHistoryBarView;
	private var m_textTicker:textTicker;
	private var m_promptsContainer:Sprite;
	private var m_safeAreaRatio:Number = 1;
	private var m_profileName:String = "";
	private var m_profileLevel:int = 0;
	private var m_isOnline:Boolean;
	private var m_isMultiplayerConnected:Boolean = false;
	private var m_versionIndicator:MenuGameVersionView;
	private var m_masteryElement:MasteryElement;
	private var m_isUiInputActive:Boolean = false;
	private var m_isMouseActive:Boolean = false;
	private var m_backgroundImage:MenuFrameBackgroundImage;
	private var m_backgroundLayerImage:MenuFrameBackgroundImage;
	private var m_disableProfileIndicator:Boolean = false;
	private var m_isProfileIndicatorVisible:Boolean = true;
	private var m_previousButtonPromptsData:Object = null;
	private var m_updateTasklet:Boolean = false;
	private var m_HorizGradientOverlay_offsBegin:Number = 0;
	private var m_HorizGradientOverlay_offsEnd:Number = 0;
	private var m_HorizGradientOverlay_fAlphaBegin:Number = 0;
	private var m_HorizGradientOverlay_fAlphaEnd:Number = 0;
	private var m_HorizGradientOverlay_color:uint = 0;

	public function MenuFrame() {
		ControlsMain.setOnMouseActiveChangedCallback(this.onMouseActiveChanged);
		this.m_isMouseActive = ControlsMain.isMouseActive();
		this.m_backgroundContainer = new Sprite();
		this.m_backgroundContainer.name = "m_backgroundContainer";
		addChild(this.m_backgroundContainer);
		this.m_menuBackgroundInGame = new MenuBackground();
		this.m_menuBackgroundInGame.name = "m_menuBackgroundInGame";
		this.m_menuBackgroundInGame.drawIngameBackground();
		this.m_backgroundContainer.addChild(this.m_menuBackgroundInGame);
		var _local_1:Matrix = new Matrix();
		_local_1.createGradientBox(MenuConstants.BaseWidth, MenuConstants.BaseHeight, ((90 / 180) * Math.PI), 0, 0);
		this.m_greyGradientBackdropLevelEnd = new Shape();
		this.m_greyGradientBackdropLevelEnd.name = "m_greyGradientBackdropLevelEnd";
		var _local_2:Graphics = this.m_greyGradientBackdropLevelEnd.graphics;
		this.m_greyGradientBackdropLevelEnd.graphics.clear();
		_local_2.beginGradientFill(GradientType.LINEAR, [MenuConstants.COLOR_WHITE, MenuConstants.COLOR_WHITE], [1, 0.7], [0, 0xFF], _local_1, SpreadMethod.PAD, InterpolationMethod.RGB, 0);
		_local_2.drawRect(0, 0, MenuConstants.BaseWidth, MenuConstants.BaseHeight);
		this.m_backgroundContainer.addChild(this.m_greyGradientBackdropLevelEnd);
		this.m_darkBackdrop = new Shape();
		this.m_darkBackdrop.name = "m_darkBackdrop";
		this.m_darkBackdrop.graphics.clear();
		this.m_darkBackdrop.graphics.beginFill(MenuConstants.COLOR_BLACK, 1);
		this.m_darkBackdrop.graphics.drawRect(0, 0, MenuConstants.BaseWidth, MenuConstants.BaseHeight);
		this.m_darkBackdrop.graphics.endFill();
		this.m_darkBackdrop.alpha = 0;
		this.m_backgroundContainer.addChild(this.m_darkBackdrop);
		this.m_darkBackdropLevelEnd = new Shape();
		this.m_darkBackdropLevelEnd.name = "m_darkBackdropLevelEnd";
		this.m_darkBackdropLevelEnd.graphics.clear();
		this.m_darkBackdropLevelEnd.graphics.beginFill(MenuConstants.COLOR_BLACK, 1);
		this.m_darkBackdropLevelEnd.graphics.drawRect(0, 0, MenuConstants.BaseWidth, MenuConstants.BaseHeight);
		this.m_darkBackdropLevelEnd.graphics.endFill();
		this.m_darkBackdropLevelEnd.alpha = 0;
		this.m_backgroundContainer.addChild(this.m_darkBackdropLevelEnd);
		this.m_failedBackdrop = new Shape();
		this.m_failedBackdrop.name = "m_failedBackdrop";
		this.m_failedBackdrop.graphics.clear();
		this.m_failedBackdrop.graphics.beginFill(MenuConstants.COLOR_DARK_RED, 1);
		this.m_failedBackdrop.graphics.drawRect(0, 0, MenuConstants.BaseWidth, MenuConstants.BaseHeight);
		this.m_failedBackdrop.graphics.endFill();
		this.m_failedBackdrop.alpha = 0;
		this.m_backgroundContainer.addChild(this.m_failedBackdrop);
		this.m_greyBackground = new Sprite();
		this.m_greyBackground.name = "m_greyBackground";
		this.m_backgroundContainer.addChild(this.m_greyBackground);
		this.drawGreyBackground();
		this.m_mapContainer = new Sprite();
		this.m_mapContainer.name = "m_mapContainer";
		this.m_backgroundContainer.addChild(this.m_mapContainer);
		this.m_background = new Sprite();
		this.m_background.name = "m_background";
		this.m_backgroundContainer.addChild(this.m_background);
		this.m_backgroundImage = new MenuFrameBackgroundImage();
		this.m_backgroundImage.name = "m_backgroundImage";
		this.m_background.addChild(this.m_backgroundImage);
		this.m_backgroundLayer = new Sprite();
		this.m_backgroundLayer.name = "m_backgroundLayer";
		this.m_backgroundContainer.addChild(this.m_backgroundLayer);
		this.m_backgroundLayerImage = new MenuFrameBackgroundImage();
		this.m_backgroundLayerImage.name = "m_backgroundLayerImage";
		this.m_backgroundLayer.addChild(this.m_backgroundLayerImage);
		this.m_backgroundOverlay = new Sprite();
		this.m_backgroundOverlay.name = "m_backgroundOverlay";
		this.m_backgroundContainer.addChild(this.m_backgroundOverlay);
		this.m_menuTopBottomOverlay = new Shape();
		this.m_menuTopBottomOverlay.name = "m_menuTopBottomOverlay";
		var _local_3:Graphics = this.m_menuTopBottomOverlay.graphics;
		this.m_menuTopBottomOverlay.graphics.clear();
		_local_3.beginGradientFill(GradientType.LINEAR, [MenuConstants.COLOR_BLACK, MenuConstants.COLOR_BLACK, MenuConstants.COLOR_BLACK, MenuConstants.COLOR_BLACK, MenuConstants.COLOR_BLACK], [0.35, 0, 0, 0.3, 0.35], [0, 40, 175, 220, 0xFF], _local_1, SpreadMethod.PAD, InterpolationMethod.RGB, 0);
		_local_3.drawRect(-1, -1, (MenuConstants.BaseWidth + 2), (MenuConstants.BaseHeight + 2));
		this.m_backgroundOverlay.addChild(this.m_menuTopBottomOverlay);
		this.m_menuFullOverlay = new Shape();
		this.m_menuFullOverlay.name = "m_menuFullOverlay";
		this.m_menuFullOverlay.graphics.clear();
		this.m_menuFullOverlay.graphics.beginFill(MenuConstants.COLOR_BLACK, 0.5);
		this.m_menuFullOverlay.graphics.drawRect(-1, -1, (MenuConstants.BaseWidth + 2), (MenuConstants.BaseHeight + 2));
		this.m_menuFullOverlay.graphics.endFill();
		this.m_menuFullOverlay.alpha = 0;
		this.m_backgroundOverlay.addChild(this.m_menuFullOverlay);
		this.m_userLine = new Sprite();
		this.m_userLine.name = "m_userLine";
		addChild(this.m_userLine);
		this.m_container = new Sprite();
		this.m_container.name = "m_container";
		addChild(this.m_container);
		this.m_view = new MenuFrameView();
		this.m_view.name = "m_view";
		this.m_container.addChild(this.m_view);
		this.m_historyBar = new MenuHistoryBarView();
		this.m_historyBar.name = "m_historyBar";
		this.m_historyBar.current.height = MenuConstants.HistoryBarTextHeight;
		this.m_historyBar.x = (MenuConstants.menuXOffset + MenuConstants.HistoryBarXPos);
		this.m_historyBar.y = MenuConstants.HistoryBarYPos;
		this.m_historyBar.autoSize = TextFieldAutoSize.LEFT;
		this.m_historyBar.alpha = 0;
		this.m_view.addChild(this.m_historyBar);
		this.m_pageContent = new Sprite();
		this.m_pageContent.name = "m_pageContent";
		this.m_pageContent.x = MenuConstants.menuXOffset;
		this.m_pageContent.y = (MenuConstants.tileGap + MenuConstants.TabsLineUpperYPos);
		this.m_view.addChild(this.m_pageContent);
		var _local_4:Object = {};
		_local_4.name = "ProfileData";
		this.m_profileElement = new ProfileElement(_local_4);
		this.m_profileElement.name = "m_profileElement";
		this.m_profileElement.alpha = 0;
		this.m_profileElement.x = MenuConstants.ProfileElementXPos;
		this.m_profileElement.y = MenuConstants.ProfileElementYPos;
		this.m_profileElement.visible = (!(this.m_disableProfileIndicator));
		this.m_profileElement.setState(ProfileElement.STATE_OFFLINE);
		this.m_view.addChild(this.m_profileElement);
		var _local_5:Object = {};
		_local_5.name = "MultiplayerProfileData";
		this.m_multiplayerProfileElement = new ProfileElement(_local_5);
		this.m_multiplayerProfileElement.name = "m_multiplayerProfileElement";
		this.m_multiplayerProfileElement.alpha = 0;
		this.m_multiplayerProfileElement.x = MenuConstants.MultiplayerElementXPos;
		this.m_multiplayerProfileElement.y = MenuConstants.MultiplayerElementYPos;
		this.m_multiplayerProfileElement.visible = (!(this.m_disableProfileIndicator));
		this.m_multiplayerProfileElement.setState(ProfileElement.STATE_CONNECTED);
		this.m_view.addChild(this.m_multiplayerProfileElement);
		this.updateIndicatorPosAndVisibility();
		var _local_6:Object = this.prepareMasteryData(null);
		this.m_masteryElement = new MasteryElement(_local_6);
		this.m_masteryElement.name = "m_masteryElement";
		this.m_masteryElement.x = MenuConstants.ProfileElementXPos;
		this.m_masteryElement.y = MenuConstants.ProfileElementYPos;
		this.m_masteryElement.visible = false;
		this.m_view.addChild(this.m_masteryElement);
		this.setMasteryData(_local_6);
		this.m_foreground = new Sprite();
		this.m_foreground.name = "m_foreground";
		addChild(this.m_foreground);
		this.m_versionIndicator = new MenuGameVersionView();
		this.m_versionIndicator.name = "m_versionIndicator";
		this.m_versionIndicator.x = (MenuConstants.menuXOffset + 700);
		this.m_versionIndicator.y = MenuConstants.ButtonPromptsYPos;
		this.m_versionIndicator.indicator.visible = false;
		this.m_view.addChild(this.m_versionIndicator);
		this.m_textTicker = new textTicker();
		this.m_promptsContainer = new Sprite();
		this.m_promptsContainer.name = "m_promptsContainer";
		this.m_promptsContainer.x = MenuConstants.menuXOffset;
		this.m_promptsContainer.y = MenuConstants.ButtonPromptsYPos;
		this.m_view.addChild(this.m_promptsContainer);
	}

	public function updateButtonPromptOwners():void {
		ButtonPromtUtil.updateButtonPromptOwners();
	}

	public function setMasteryData(_arg_1:Object):void {
		if (this.m_masteryElement != null) {
			_arg_1 = this.prepareMasteryData(_arg_1);
			if (this.m_masteryElement.getVisiblityFromData(_arg_1)) {
				this.m_masteryElement.visible = true;
				this.m_masteryElement.onSetData(_arg_1);
			} else {
				this.m_masteryElement.visible = false;
			}

		}

	}

	private function prepareMasteryData(_arg_1:Object):Object {
		var _local_2:Object = _arg_1;
		if (_local_2 == null) {
			_local_2 = {};
		}

		if ((name in _local_2)) {
			return (_local_2);
		}

		_local_2.name = "MasteryData";
		return (_local_2);
	}

	public function setProfileIndicatorVisible(_arg_1:Boolean):void {
		this.m_isProfileIndicatorVisible = _arg_1;
		this.updateProfileIndicatorVisible();
	}

	private function updateProfileIndicatorVisible():void {
		this.m_profileElement.visible = ((this.m_isProfileIndicatorVisible) && (!(this.m_disableProfileIndicator)));
		this.m_multiplayerProfileElement.visible = ((this.m_isProfileIndicatorVisible) && (!(this.m_disableProfileIndicator)));
	}

	public function setProfileIndicator(data:Object):void {
		var chunk:Function = function ():void {
			m_profileName = "";
			m_profileLevel = 0;
			if (data.profile) {
				m_profileName = data.profile;
				m_profileLevel = data.profileLevel;
				m_profileElement.alpha = 1;
			}

			m_profileElement.setProfileName(m_profileName);
			m_profileElement.setProfileLevel(m_profileLevel);
			var _local_1:* = "";
			var _local_2:int;
			m_isMultiplayerConnected = false;
			if (((!(data.connectedProfiles == null)) && (data.connectedProfiles.length > 0))) {
				m_isMultiplayerConnected = true;
				_local_1 = data.connectedProfiles[0];
				_local_2 = data.connectedProfileLevels[0];
			}

			m_multiplayerProfileElement.setProfileName(_local_1);
			m_multiplayerProfileElement.setProfileLevel(_local_2);
			updateIndicatorPosAndVisibility();
		};
		TaskletSequencer.getGlobalInstance().addChunk(chunk);
	}

	private function updateIndicatorPosAndVisibility(_arg_1:Boolean = false):void {
		this.m_multiplayerProfileElement.alpha = (((this.m_isOnline) && (this.m_isMultiplayerConnected)) ? 1 : 0);
		var _local_2:int = ((this.m_isOnline) ? ProfileElement.STATE_ONLINE : ProfileElement.STATE_OFFLINE);
		if (_arg_1) {
			this.m_profileElement.setState(ProfileElement.STATE_UNDEFINED);
		}

		this.m_profileElement.setState(_local_2);
	}

	public function showUserLine(_arg_1:Boolean):void {
		this.m_userLine.visible = _arg_1;
	}

	public function showOnlineIndicator(_arg_1:Boolean):void {
		this.m_profileElement.alpha = 1;
		this.m_isOnline = _arg_1;
		this.updateIndicatorPosAndVisibility();
	}

	public function setTitle(_arg_1:String):void {
		var _local_2:TextField = this.m_historyBar.current;
		if (((_arg_1 == null) || (_arg_1.length == 0))) {
			Animate.kill(this.m_historyBar);
			this.m_historyBar.alpha = 0;
			return;
		}

		var _local_3:String = Localization.get("UI_TEXT_SEPARATOR");
		MenuUtils.setupText(_local_2, _arg_1, 28, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGrey);
		CommonUtils.changeFontToGlobalIfNeeded(_local_2);
		Animate.fromTo(this.m_historyBar, MenuConstants.PageOpenTime, 0, {"alpha": 0}, {"alpha": 1}, Animate.Linear);
	}

	override public function getContainer():Sprite {
		return (this.m_pageContent);
	}

	public function onOpenPage(_arg_1:Object):void {
		var _local_2:Object = {
			"sizeX": this.m_width,
			"sizeY": this.m_height,
			"safeAreaRatio": this.m_safeAreaRatio
		};
		dispatchEvent(new ScreenResizeEvent(ScreenResizeEvent.SCREEN_RESIZED, _local_2, true));
		this.showButtonPromts(true);
		Animate.legacyTo(this.m_pageContent, MenuConstants.PageOpenTime, {"alpha": 1}, Animate.Linear);
		this.updateIndicatorPosAndVisibility(true);
		if (this.m_masteryElement != null) {
			this.m_masteryElement.refreshLoca();
		}

		if (this.m_horizGradientOverlay != null) {
			Animate.fromTo(this.m_horizGradientOverlay, MenuConstants.PageOpenTime, 0, {"alpha": 0}, {"alpha": 1}, Animate.Linear);
		}

	}

	public function onClosePage(_arg_1:Boolean):void {
		this.showButtonPromts(false);
		Animate.legacyTo(this.m_pageContent, MenuConstants.PageCloseTime, {"alpha": 0}, Animate.Linear);
		if (this.m_horizGradientOverlay != null) {
			Animate.kill(this.m_horizGradientOverlay);
			this.m_horizGradientOverlay.alpha = 0;
		}

	}

	public function hideGameVersion():void {
		this.m_versionIndicator.indicator.visible = false;
		this.m_versionIndicator.gameversion.text = "";
		this.m_versionIndicator.serverversion.text = "";
	}

	public function displayGameVersion(_arg_1:Object):void {
		this.m_versionIndicator.indicator.visible = true;
		this.m_versionIndicator.gameversion.text = ((Localization.get("UI_MENU_PAGE_SETTINGS_GAMEVERSION") + ": ") + _arg_1.gameversion);
		if (_arg_1.buildname) {
			this.m_versionIndicator.x = (MenuConstants.menuXOffset + 400);
			this.m_versionIndicator.gameversion.width = 950;
			this.m_versionIndicator.gameversion.appendText(((" (" + _arg_1.buildname) + ")"));
		} else {
			if (_arg_1.buildid) {
				this.m_versionIndicator.gameversion.appendText(((" (ID" + _arg_1.buildid) + ")"));
			}

		}

		this.m_versionIndicator.gameversion.textColor = MenuConstants.COLOR_WHITE;
		if (_arg_1.serverversion) {
			this.m_versionIndicator.serverversion.text = ((Localization.get("UI_MENU_PAGE_SETTINGS_SERVERVERSION") + ": ") + _arg_1.serverversion);
			this.m_versionIndicator.serverversion.textColor = MenuConstants.COLOR_WHITE;
		}

	}

	public function setButtonPrompts(data:Object):void {
		var chunk:Function = function ():void {
			m_previousButtonPromptsData = MenuUtils.parsePrompts(data, m_previousButtonPromptsData, m_promptsContainer, false, handlePromptMouseEvent);
		};
		TaskletSequencer.getGlobalInstance().addChunk(chunk);
	}

	private function handlePromptMouseEvent(_arg_1:String):void {
		Log.info("mouse", this, ("Prompt action click: " + _arg_1));
		var _local_2:int = -1;
		if (_arg_1 == "cancel") {
			_local_2 = 0;
		}

		if (_arg_1 == "accept") {
			_local_2 = 1;
		}

		if (_arg_1 == "action-x") {
			_local_2 = 2;
		}

		if (_arg_1 == "action-y") {
			_local_2 = 3;
		}

		if (_arg_1 == "r") {
			_local_2 = 4;
		}

		if (_local_2 >= 0) {
			sendEventWithValue("onInputAction", _local_2);
		}

	}

	public function showButtonPromts(_arg_1:Boolean):void {
		this.m_promptsContainer.visible = _arg_1;
	}

	public function set showPageContent(_arg_1:Boolean):void {
		Animate.complete(this.m_pageContent);
		if (_arg_1) {
			Animate.legacyTo(this.m_pageContent, MenuConstants.PageOpenTime, {"alpha": 1}, Animate.Linear);
		} else {
			Animate.legacyTo(this.m_pageContent, MenuConstants.PageOpenTime, {"alpha": 0}, Animate.Linear);
		}

	}

	public function set showOverlay(_arg_1:Boolean):void {
	}

	public function set showWorldMap(_arg_1:Boolean):void {
	}

	public function set disableProfileIndicator(_arg_1:Boolean):void {
		this.m_disableProfileIndicator = _arg_1;
		this.updateProfileIndicatorVisible();
	}

	public function set showDarkBackdrop(_arg_1:Boolean):void {
		Animate.complete(this.m_darkBackdrop);
		if (_arg_1) {
			Animate.legacyTo(this.m_darkBackdrop, MenuConstants.PageOpenTime, {"alpha": 0.53}, Animate.Linear);
		} else {
			Animate.legacyTo(this.m_darkBackdrop, MenuConstants.PageOpenTime, {"alpha": 0}, Animate.Linear);
		}

	}

	public function set showDarkBackdropLevelEnd(_arg_1:Boolean):void {
		Animate.complete(this.m_darkBackdropLevelEnd);
		if (_arg_1) {
			Animate.legacyTo(this.m_darkBackdropLevelEnd, 1, {"alpha": 1}, Animate.Linear);
		} else {
			Animate.legacyTo(this.m_darkBackdropLevelEnd, MenuConstants.PageOpenTime, {"alpha": 0}, Animate.Linear);
		}

	}

	public function set showFailedBackdrop(_arg_1:Boolean):void {
		Log.xinfo(Log.ChannelMenuFrame, ("showFailedBackdrop: " + _arg_1));
		Animate.complete(this.m_failedBackdrop);
		if (_arg_1) {
			Animate.legacyTo(this.m_failedBackdrop, MenuConstants.PageOpenTime, {"alpha": 0.8}, Animate.Linear);
		} else {
			Animate.legacyTo(this.m_failedBackdrop, MenuConstants.PageOpenTime, {"alpha": 0}, Animate.Linear);
		}

	}

	public function set showRedBackdrop(_arg_1:Boolean):void {
		this.m_menuBackgroundInGame.alpha = ((_arg_1) ? 1 : 0);
	}

	public function set showRedBackdropLevelEnd(_arg_1:Boolean):void {
		Animate.complete(this.m_greyGradientBackdropLevelEnd);
		if (_arg_1) {
			Animate.legacyTo(this.m_greyGradientBackdropLevelEnd, 0.5, {"alpha": 1}, Animate.Linear);
		} else {
			Animate.legacyTo(this.m_greyGradientBackdropLevelEnd, MenuConstants.PageOpenTime, {"alpha": 0}, Animate.Linear);
		}

	}

	public function set showTabsLines(_arg_1:Boolean):void {
	}

	public function set showTabsUnderlay(_arg_1:Boolean):void {
	}

	public function set showBackground(_arg_1:Boolean):void {
		Animate.complete(this.m_background);
		Animate.complete(this.m_mapContainer);
		Animate.complete(this.m_greyBackground);
		Animate.complete(this.m_backgroundOverlay);
		if (_arg_1) {
			Animate.legacyTo(this.m_background, MenuConstants.PageOpenTime, {"alpha": 1}, Animate.Linear);
			Animate.legacyTo(this.m_mapContainer, MenuConstants.PageOpenTime, {"alpha": 1}, Animate.Linear);
			Animate.legacyTo(this.m_greyBackground, MenuConstants.PageOpenTime, {"alpha": 1}, Animate.Linear);
			Animate.legacyTo(this.m_backgroundOverlay, MenuConstants.PageOpenTime, {"alpha": 1}, Animate.Linear);
		} else {
			Animate.legacyTo(this.m_background, MenuConstants.PageOpenTime, {"alpha": 0}, Animate.Linear);
			Animate.legacyTo(this.m_mapContainer, MenuConstants.PageOpenTime, {"alpha": 0}, Animate.Linear);
			Animate.legacyTo(this.m_greyBackground, MenuConstants.PageOpenTime, {"alpha": 0}, Animate.Linear);
			Animate.legacyTo(this.m_backgroundOverlay, MenuConstants.PageOpenTime, {"alpha": 0}, Animate.Linear);
		}

	}

	public function showMenuPageContent(_arg_1:Boolean):void {
		this.showPageContent = _arg_1;
	}

	public function showMenuOverlay(_arg_1:Boolean):void {
		this.showOverlay = _arg_1;
	}

	public function showMenuWorldMap(_arg_1:Boolean):void {
		this.showWorldMap = _arg_1;
	}

	public function showMenuDarkBackdrop(_arg_1:Boolean):void {
		this.showRedBackdrop = _arg_1;
	}

	public function showMenuDarkBackdropLevelEnd(_arg_1:Boolean):void {
		this.showDarkBackdropLevelEnd = _arg_1;
	}

	public function showMenuFailedBackdrop(_arg_1:Boolean):void {
		this.showFailedBackdrop = _arg_1;
	}

	public function showMenuRedBackdrop(_arg_1:Boolean):void {
		this.showRedBackdrop = _arg_1;
	}

	public function showMenuRedBackdropLevelEnd(_arg_1:Boolean):void {
		this.showRedBackdropLevelEnd = _arg_1;
	}

	public function showMenuTabsLines(_arg_1:Boolean):void {
		this.showTabsLines = _arg_1;
	}

	public function showMenuTabsUnderlay(_arg_1:Boolean):void {
		this.showTabsUnderlay = _arg_1;
	}

	public function showMenuBackground(_arg_1:Boolean):void {
		this.showBackground = _arg_1;
	}

	public function showMenuBackgroundFullOverlay(_arg_1:Boolean):void {
		Animate.kill(this.m_menuFullOverlay);
		if (_arg_1) {
			Animate.legacyTo(this.m_menuFullOverlay, MenuConstants.PageOpenTime, {"alpha": 1}, Animate.Linear);
		} else {
			Animate.legacyTo(this.m_menuFullOverlay, MenuConstants.PageOpenTime, {"alpha": 0}, Animate.Linear);
		}

	}

	public function set showHorizGradientOverlay(_arg_1:Boolean):void {
		if (((!(_arg_1)) && (!(this.m_horizGradientOverlay == null)))) {
			this.m_backgroundContainer.removeChild(this.m_horizGradientOverlay);
			this.m_horizGradientOverlay = null;
		} else {
			if (((_arg_1) && (this.m_horizGradientOverlay == null))) {
				this.m_horizGradientOverlay = new Shape();
				this.m_horizGradientOverlay.name = "m_horizGradientOverlay";
				this.m_horizGradientOverlay.alpha = 0;
				this.m_backgroundContainer.addChild(this.m_horizGradientOverlay);
				MenuUtils.centerFillAspectFull(this.m_horizGradientOverlay, 100, 100, this.m_width, this.m_height);
				this.redrawHorizGradientOverlay();
			}

		}

	}

	[PROPERTY(CONSTRAINT="Editors(Slider) MinValue(-1) MaxValue(1) DecimalPlaces(2)")]
	public function set HorizGradientOverlay_OffsetBegin(_arg_1:Number):void {
		this.m_HorizGradientOverlay_offsBegin = _arg_1;
		this.redrawHorizGradientOverlay();
	}

	[PROPERTY(CONSTRAINT="Editors(Slider) MinValue(-1) MaxValue(1) DecimalPlaces(2)")]
	public function set HorizGradientOverlay_OffsetEnd(_arg_1:Number):void {
		this.m_HorizGradientOverlay_offsEnd = _arg_1;
		this.redrawHorizGradientOverlay();
	}

	[PROPERTY(CONSTRAINT="Editors(Slider) MinValue(0) MaxValue(1) DecimalPlaces(2)")]
	public function set HorizGradientOverlay_AlphaBegin(_arg_1:Number):void {
		this.m_HorizGradientOverlay_fAlphaBegin = _arg_1;
		this.redrawHorizGradientOverlay();
	}

	[PROPERTY(CONSTRAINT="Editors(Slider) MinValue(0) MaxValue(1) DecimalPlaces(2)")]
	public function set HorizGradientOverlay_AlphaEnd(_arg_1:Number):void {
		this.m_HorizGradientOverlay_fAlphaEnd = _arg_1;
		this.redrawHorizGradientOverlay();
	}

	[PROPERTY(HELPTEXT="Hexadecimal code, e.g. 'ff0000' for red")]
	public function set HorizGradientOverlay_color(_arg_1:String):void {
		this.m_HorizGradientOverlay_color = parseInt(_arg_1, 16);
		if (isNaN(this.m_HorizGradientOverlay_color)) {
			this.m_HorizGradientOverlay_color = 0;
		}

		this.redrawHorizGradientOverlay();
	}

	private function redrawHorizGradientOverlay():void {
		var fAspect16x9:Number;
		var fAspectCurrent:Number;
		var isStretchedHorizontally:Boolean;
		var offsLeftEdge:Number;
		var offsRightEdge:Number;
		if (this.m_horizGradientOverlay == null) {
			return;
		}

		var g:Graphics = this.m_horizGradientOverlay.graphics;
		g.clear();
		var matr:Matrix = new Matrix();
		matr.createGradientBox(100, 100, 0, 0, 0);
		fAspect16x9 = (MenuConstants.BaseWidth / MenuConstants.BaseHeight);
		fAspectCurrent = (this.m_width / this.m_height);
		isStretchedHorizontally = (fAspectCurrent > fAspect16x9);
		offsLeftEdge = ((isStretchedHorizontally) ? ((1 - (fAspect16x9 / fAspectCurrent)) / 2) : ((1 - fAspectCurrent) / 2));
		offsRightEdge = (1 - offsLeftEdge);
		var fRatioFromOffset:Function = function (_arg_1:Number):Number {
			return (offsLeftEdge + (((offsRightEdge - offsLeftEdge) * (_arg_1 + 1)) / 2));
		};
		var fRatioBegin:Number = fRatioFromOffset(this.m_HorizGradientOverlay_offsBegin);
		var fRatioEnd:Number = fRatioFromOffset(this.m_HorizGradientOverlay_offsEnd);
		g.beginGradientFill(GradientType.LINEAR, [this.m_HorizGradientOverlay_color, this.m_HorizGradientOverlay_color], [this.m_HorizGradientOverlay_fAlphaBegin, this.m_HorizGradientOverlay_fAlphaEnd], [(0xFF * fRatioBegin), (0xFF * fRatioEnd)], matr);
		g.drawRect(0, 0, 100, 100);
	}

	public function setMenuDifficultyMode(_arg_1:String):void {
	}

	public function setBackgroundData(_arg_1:Object):void {
		this.m_backgroundImage.setBackgroundData(_arg_1);
	}

	public function setBackground(_arg_1:String):void {
		this.m_backgroundImage.setBackground(_arg_1);
	}

	public function setBackgroundLayer(_arg_1:Object):void {
		var _local_2:String = ((_arg_1.image != null) ? _arg_1.image : "");
		var _local_3:Boolean = ((_arg_1.scalefull != null) ? _arg_1.scalefull : true);
		var _local_4:int = ((_arg_1.offsetX != null) ? _arg_1.offsetX : 0);
		var _local_5:int = ((_arg_1.offsetY != null) ? _arg_1.offsetY : 0);
		this.m_backgroundLayerImage.setBackground(_local_2, _local_3, _local_4, _local_5);
	}

	private function scaleRedBottom(_arg_1:Number, _arg_2:Number):void {
		var _local_3:Number = (Math.min((_arg_1 / MenuConstants.BaseWidth), (_arg_2 / MenuConstants.BaseHeight)) * this.m_safeAreaRatio);
		var _local_4:Number = (MenuConstants.BaseWidth * _local_3);
		var _local_5:Number = (MenuConstants.BaseHeight * _local_3);
		var _local_6:Number = ((_arg_1 - _local_4) / 2);
		var _local_7:Number = (_local_6 * (1 / _local_3));
		var _local_8:Number = (1 + ((_local_7 * 2) / MenuConstants.BaseWidth));
		var _local_9:Number = ((_arg_2 - _local_5) / 2);
		var _local_10:Number = (_local_9 * (1 / _local_3));
		var _local_11:Number = (1 + ((_local_10 * 2) / MenuConstants.BaseHeight));
	}

	private function drawGreyBackground():void {
		this.m_greyBackground.graphics.clear();
		this.m_greyBackground.graphics.beginFill(this.MENU_BG_COLOR, 1);
		if (ControlsMain.isVrModeActive()) {
			this.m_greyBackground.graphics.drawRect(1, 1, (MenuConstants.BaseWidth - 2), (MenuConstants.BaseHeight - 2));
		} else {
			this.m_greyBackground.graphics.drawRect(0, 0, MenuConstants.BaseWidth, MenuConstants.BaseHeight);
		}

	}

	private function drawUserLine(_arg_1:Number, _arg_2:Number):void {
	}

	private function bottomAlignMapContainer(_arg_1:Number, _arg_2:Number):void {
		this.m_mapContainer.y = (_arg_2 - this.m_mapContainer.height);
	}

	override public function onSetSize(_arg_1:Number, _arg_2:Number):void {
		this.m_width = _arg_1;
		this.m_height = _arg_2;
		this.drawGreyBackground();
		MenuUtils.centerFill(this.m_greyBackground, MenuConstants.BaseWidth, MenuConstants.BaseHeight, _arg_1, _arg_2);
		if (ControlsMain.isVrModeActive()) {
			MenuUtils.centerFill(this.m_backgroundContainer, MenuConstants.BaseWidth, MenuConstants.BaseHeight, MenuConstants.BaseWidth, MenuConstants.BaseHeight, 1.25);
			this.m_backgroundContainer.z = MenuUtils.toPixel(1);
		} else {
			MenuUtils.centerFill(this.m_backgroundContainer, MenuConstants.BaseWidth, MenuConstants.BaseHeight, MenuConstants.BaseWidth, MenuConstants.BaseHeight);
			this.m_backgroundContainer.z = 0;
			this.m_backgroundContainer.transform.matrix3D = null;
		}

		MenuUtils.centerFill(this.m_backgroundOverlay, MenuConstants.BaseWidth, MenuConstants.BaseHeight, _arg_1, _arg_2);
		MenuUtils.centerFill(this.m_menuBackgroundInGame, MenuConstants.BaseWidth, MenuConstants.BaseHeight, _arg_1, _arg_2);
		MenuUtils.centerFill(this.m_greyGradientBackdropLevelEnd, MenuConstants.BaseWidth, MenuConstants.BaseHeight, _arg_1, _arg_2);
		MenuUtils.centerFill(this.m_darkBackdrop, MenuConstants.BaseWidth, MenuConstants.BaseHeight, _arg_1, _arg_2);
		MenuUtils.centerFill(this.m_darkBackdropLevelEnd, MenuConstants.BaseWidth, MenuConstants.BaseHeight, _arg_1, _arg_2);
		MenuUtils.centerFill(this.m_failedBackdrop, MenuConstants.BaseWidth, MenuConstants.BaseHeight, _arg_1, _arg_2);
		MenuUtils.centerFill(this.m_mapContainer, MenuConstants.BaseWidth, MenuConstants.BaseHeight, _arg_1, _arg_2);
		MenuUtils.centerFillAspectFull(this.m_background, MenuConstants.BaseWidth, MenuConstants.BaseHeight, _arg_1, _arg_2);
		if (this.m_horizGradientOverlay != null) {
			MenuUtils.centerFillAspectFull(this.m_horizGradientOverlay, 100, 100, _arg_1, _arg_2);
			this.redrawHorizGradientOverlay();
		}

		if (ControlsMain.isVrModeActive()) {
			this.m_backgroundLayer.z = MenuUtils.toPixel(-0.4);
		} else {
			this.m_backgroundLayer.z = 0;
			this.m_backgroundLayer.transform.matrix3D = null;
		}

		MenuUtils.centerFillAspectHeight(this.m_backgroundLayer, MenuConstants.BaseWidth, MenuConstants.BaseHeight, _arg_1, _arg_2);
		MenuUtils.centerFillAspect(this.m_container, MenuConstants.BaseWidth, MenuConstants.BaseHeight, _arg_1, _arg_2);
		MenuUtils.centerFillAspect(this.m_foreground, MenuConstants.BaseWidth, MenuConstants.BaseHeight, _arg_1, _arg_2);
		this.drawUserLine(_arg_1, _arg_2);
		this.scaleRedBottom(_arg_1, _arg_2);
		if (ControlsMain.getDisplaySize() == ControlsMain.DISPLAY_SIZE_SMALL) {
			this.m_promptsContainer.scaleX = 1.35;
			this.m_promptsContainer.scaleY = 1.35;
			this.m_profileElement.scaleX = 1.5;
			this.m_profileElement.scaleY = 1.5;
			this.m_masteryElement.alpha = 0;
		} else {
			this.m_promptsContainer.scaleX = 1;
			this.m_promptsContainer.scaleY = 1;
			this.m_profileElement.scaleX = 1;
			this.m_profileElement.scaleY = 1;
			this.m_masteryElement.alpha = 1;
		}

		var _local_3:Object = {
			"sizeX": _arg_1,
			"sizeY": _arg_2,
			"safeAreaRatio": this.m_safeAreaRatio
		};
		dispatchEvent(new ScreenResizeEvent(ScreenResizeEvent.SCREEN_RESIZED, _local_3, true));
	}

	public function getMapContainerScale():Number {
		return (MenuUtils.getFillAspectScale(MenuConstants.BaseWidth, MenuConstants.BaseHeight, this.m_width, this.m_height));
	}

	override public function onSetViewport(_arg_1:Number, _arg_2:Number, _arg_3:Number):void {
		this.m_safeAreaRatio = _arg_3;
		this.m_view.scaleX = this.m_safeAreaRatio;
		this.m_view.scaleY = this.m_safeAreaRatio;
		this.m_view.x = ((MenuConstants.BaseWidth * (1 - this.m_safeAreaRatio)) / 2);
		this.m_view.y = ((MenuConstants.BaseHeight * (1 - this.m_safeAreaRatio)) / 2);
		this.drawUserLine(this.m_width, this.m_height);
		this.scaleRedBottom(this.m_width, this.m_height);
		var _local_4:Object = {
			"sizeX": this.m_width,
			"sizeY": this.m_height,
			"safeAreaRatio": this.m_safeAreaRatio
		};
		dispatchEvent(new ScreenResizeEvent(ScreenResizeEvent.SCREEN_RESIZED, _local_4, true));
	}

	public function setUiInputActive(_arg_1:Boolean):void {
		if (this.m_isUiInputActive == _arg_1) {
			return;
		}

		this.m_isUiInputActive = _arg_1;
		this.checkMouseState();
	}

	public function onMouseActiveChanged(_arg_1:Boolean):void {
		if (this.m_isMouseActive == _arg_1) {
			return;
		}

		this.m_isMouseActive = _arg_1;
		this.checkMouseState();
	}

	public function onVisibleFadeIn(_arg_1:Number):void {
		this.m_backgroundImage.onVisibleFadeIn(_arg_1);
	}

	private function checkMouseState():void {
		var _local_4:DisplayObject;
		var _local_5:MenuElementBase;
		var _local_6:DisplayObject;
		var _local_7:Boolean;
		var _local_8:int;
		if (((!(this.m_isMouseActive)) || (!(this.m_isUiInputActive)))) {
			return;
		}

		var _local_1:Point = new Point(stage.mouseX, stage.mouseY);
		var _local_2:Array = stage.getObjectsUnderPoint(_local_1);
		if (((_local_2 == null) || (_local_2.length <= 0))) {
			return;
		}

		var _local_3:Array = [];
		while (_local_2.length > 0) {
			_local_4 = (_local_2.pop() as DisplayObject);
			if (_local_4 != null) {
				_local_5 = null;
				_local_6 = _local_4;
				while (((!(_local_6 == null)) && (_local_5 == null))) {
					_local_5 = (_local_6 as MenuElementBase);
					_local_6 = _local_6.parent;
				}

				if (_local_5 != null) {
					_local_7 = false;
					_local_8 = 0;
					while (((_local_8 < _local_3.length) && (!(_local_7)))) {
						if (_local_3[_local_8] == _local_5) {
							_local_7 = true;
						}

						_local_8++;
					}

					if (!_local_7) {
						_local_5.triggerMouseRollOver();
						_local_3.unshift(_local_5);
					}

				}

			}

		}

	}


}
}//package menu3

