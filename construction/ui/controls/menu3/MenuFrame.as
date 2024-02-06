package menu3
{
	import basic.ButtonPromtUtil;
	import common.Animate;
	import common.BaseControl;
	import common.CommonUtils;
	import common.Localization;
	import common.Log;
	import common.TaskletSequencer;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import common.menu.textTicker;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.InterpolationMethod;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.*;
	import menu3.basic.MasteryElement;
	import menu3.basic.ProfileElement;
	
	public class MenuFrame extends BaseControl
	{
		
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
		
		public function MenuFrame()
		{
			super();
			ControlsMain.setOnMouseActiveChangedCallback(this.onMouseActiveChanged);
			this.m_isMouseActive = ControlsMain.isMouseActive();
			this.m_backgroundContainer = new Sprite();
			this.m_backgroundContainer.name = "m_backgroundContainer";
			addChild(this.m_backgroundContainer);
			this.m_menuBackgroundInGame = new MenuBackground();
			this.m_menuBackgroundInGame.name = "m_menuBackgroundInGame";
			this.m_menuBackgroundInGame.drawIngameBackground();
			this.m_backgroundContainer.addChild(this.m_menuBackgroundInGame);
			var _loc1_:Matrix = new Matrix();
			_loc1_.createGradientBox(MenuConstants.BaseWidth, MenuConstants.BaseHeight, 90 / 180 * Math.PI, 0, 0);
			this.m_greyGradientBackdropLevelEnd = new Shape();
			this.m_greyGradientBackdropLevelEnd.name = "m_greyGradientBackdropLevelEnd";
			var _loc2_:Graphics = this.m_greyGradientBackdropLevelEnd.graphics;
			this.m_greyGradientBackdropLevelEnd.graphics.clear();
			_loc2_.beginGradientFill(GradientType.LINEAR, [MenuConstants.COLOR_WHITE, MenuConstants.COLOR_WHITE], [1, 0.7], [0, 255], _loc1_, SpreadMethod.PAD, InterpolationMethod.RGB, 0);
			_loc2_.drawRect(0, 0, MenuConstants.BaseWidth, MenuConstants.BaseHeight);
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
			var _loc3_:Graphics = this.m_menuTopBottomOverlay.graphics;
			this.m_menuTopBottomOverlay.graphics.clear();
			_loc3_.beginGradientFill(GradientType.LINEAR, [MenuConstants.COLOR_BLACK, MenuConstants.COLOR_BLACK, MenuConstants.COLOR_BLACK, MenuConstants.COLOR_BLACK, MenuConstants.COLOR_BLACK], [0.35, 0, 0, 0.3, 0.35], [0, 40, 175, 220, 255], _loc1_, SpreadMethod.PAD, InterpolationMethod.RGB, 0);
			_loc3_.drawRect(-1, -1, MenuConstants.BaseWidth + 2, MenuConstants.BaseHeight + 2);
			this.m_backgroundOverlay.addChild(this.m_menuTopBottomOverlay);
			this.m_menuFullOverlay = new Shape();
			this.m_menuFullOverlay.name = "m_menuFullOverlay";
			this.m_menuFullOverlay.graphics.clear();
			this.m_menuFullOverlay.graphics.beginFill(MenuConstants.COLOR_BLACK, 0.5);
			this.m_menuFullOverlay.graphics.drawRect(-1, -1, MenuConstants.BaseWidth + 2, MenuConstants.BaseHeight + 2);
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
			this.m_historyBar.x = MenuConstants.menuXOffset + MenuConstants.HistoryBarXPos;
			this.m_historyBar.y = MenuConstants.HistoryBarYPos;
			this.m_historyBar.autoSize = TextFieldAutoSize.LEFT;
			this.m_historyBar.alpha = 0;
			this.m_view.addChild(this.m_historyBar);
			this.m_pageContent = new Sprite();
			this.m_pageContent.name = "m_pageContent";
			this.m_pageContent.x = MenuConstants.menuXOffset;
			this.m_pageContent.y = MenuConstants.tileGap + MenuConstants.TabsLineUpperYPos;
			this.m_view.addChild(this.m_pageContent);
			var _loc4_:Object;
			(_loc4_ = new Object()).name = "ProfileData";
			this.m_profileElement = new ProfileElement(_loc4_);
			this.m_profileElement.name = "m_profileElement";
			this.m_profileElement.alpha = 0;
			this.m_profileElement.x = MenuConstants.ProfileElementXPos;
			this.m_profileElement.y = MenuConstants.ProfileElementYPos;
			this.m_profileElement.visible = !this.m_disableProfileIndicator;
			this.m_profileElement.setState(ProfileElement.STATE_OFFLINE);
			this.m_view.addChild(this.m_profileElement);
			var _loc5_:Object;
			(_loc5_ = new Object()).name = "MultiplayerProfileData";
			this.m_multiplayerProfileElement = new ProfileElement(_loc5_);
			this.m_multiplayerProfileElement.name = "m_multiplayerProfileElement";
			this.m_multiplayerProfileElement.alpha = 0;
			this.m_multiplayerProfileElement.x = MenuConstants.MultiplayerElementXPos;
			this.m_multiplayerProfileElement.y = MenuConstants.MultiplayerElementYPos;
			this.m_multiplayerProfileElement.visible = !this.m_disableProfileIndicator;
			this.m_multiplayerProfileElement.setState(ProfileElement.STATE_CONNECTED);
			this.m_view.addChild(this.m_multiplayerProfileElement);
			this.updateIndicatorPosAndVisibility();
			var _loc6_:Object = this.prepareMasteryData(null);
			this.m_masteryElement = new MasteryElement(_loc6_);
			this.m_masteryElement.name = "m_masteryElement";
			this.m_masteryElement.x = MenuConstants.ProfileElementXPos;
			this.m_masteryElement.y = MenuConstants.ProfileElementYPos;
			this.m_masteryElement.visible = false;
			this.m_view.addChild(this.m_masteryElement);
			this.setMasteryData(_loc6_);
			this.m_foreground = new Sprite();
			this.m_foreground.name = "m_foreground";
			addChild(this.m_foreground);
			this.m_versionIndicator = new MenuGameVersionView();
			this.m_versionIndicator.name = "m_versionIndicator";
			this.m_versionIndicator.x = MenuConstants.menuXOffset + 700;
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
		
		public function updateButtonPromptOwners():void
		{
			ButtonPromtUtil.updateButtonPromptOwners();
		}
		
		public function setMasteryData(param1:Object):void
		{
			if (this.m_masteryElement != null)
			{
				param1 = this.prepareMasteryData(param1);
				if (this.m_masteryElement.getVisiblityFromData(param1))
				{
					this.m_masteryElement.visible = true;
					this.m_masteryElement.onSetData(param1);
				}
				else
				{
					this.m_masteryElement.visible = false;
				}
			}
		}
		
		private function prepareMasteryData(param1:Object):Object
		{
			var _loc2_:Object = param1;
			if (_loc2_ == null)
			{
				_loc2_ = new Object();
			}
			if (name in _loc2_)
			{
				return _loc2_;
			}
			_loc2_.name = "MasteryData";
			return _loc2_;
		}
		
		public function setProfileIndicatorVisible(param1:Boolean):void
		{
			this.m_isProfileIndicatorVisible = param1;
			this.updateProfileIndicatorVisible();
		}
		
		private function updateProfileIndicatorVisible():void
		{
			this.m_profileElement.visible = this.m_isProfileIndicatorVisible && !this.m_disableProfileIndicator;
			this.m_multiplayerProfileElement.visible = this.m_isProfileIndicatorVisible && !this.m_disableProfileIndicator;
		}
		
		public function setProfileIndicator(param1:Object):void
		{
			var data:Object = param1;
			var chunk:Function = function():void
			{
				m_profileName = "";
				m_profileLevel = 0;
				if (data.profile)
				{
					m_profileName = data.profile;
					m_profileLevel = data.profileLevel;
					m_profileElement.alpha = 1;
				}
				m_profileElement.setProfileName(m_profileName);
				m_profileElement.setProfileLevel(m_profileLevel);
				var _loc1_:String = "";
				var _loc2_:int = 0;
				m_isMultiplayerConnected = false;
				if (data.connectedProfiles != null && data.connectedProfiles.length > 0)
				{
					m_isMultiplayerConnected = true;
					_loc1_ = String(data.connectedProfiles[0]);
					_loc2_ = int(data.connectedProfileLevels[0]);
				}
				m_multiplayerProfileElement.setProfileName(_loc1_);
				m_multiplayerProfileElement.setProfileLevel(_loc2_);
				updateIndicatorPosAndVisibility();
			};
			TaskletSequencer.getGlobalInstance().addChunk(chunk);
		}
		
		private function updateIndicatorPosAndVisibility(param1:Boolean = false):void
		{
			this.m_multiplayerProfileElement.alpha = this.m_isOnline && this.m_isMultiplayerConnected ? 1 : 0;
			var _loc2_:int = this.m_isOnline ? ProfileElement.STATE_ONLINE : ProfileElement.STATE_OFFLINE;
			if (param1)
			{
				this.m_profileElement.setState(ProfileElement.STATE_UNDEFINED);
			}
			this.m_profileElement.setState(_loc2_);
		}
		
		public function showUserLine(param1:Boolean):void
		{
			this.m_userLine.visible = param1;
		}
		
		public function showOnlineIndicator(param1:Boolean):void
		{
			this.m_profileElement.alpha = 1;
			this.m_isOnline = param1;
			this.updateIndicatorPosAndVisibility();
		}
		
		public function setTitle(param1:String):void
		{
			var _loc2_:TextField = this.m_historyBar.current;
			if (param1 == null || param1.length == 0)
			{
				Animate.kill(this.m_historyBar);
				this.m_historyBar.alpha = 0;
				return;
			}
			var _loc3_:String = Localization.get("UI_TEXT_SEPARATOR");
			MenuUtils.setupText(_loc2_, param1, 28, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGrey);
			CommonUtils.changeFontToGlobalIfNeeded(_loc2_);
			Animate.fromTo(this.m_historyBar, MenuConstants.PageOpenTime, 0, {"alpha": 0}, {"alpha": 1}, Animate.Linear);
		}
		
		override public function getContainer():Sprite
		{
			return this.m_pageContent;
		}
		
		public function onOpenPage(param1:Object):void
		{
			var _loc2_:Object = {"sizeX": this.m_width, "sizeY": this.m_height, "safeAreaRatio": this.m_safeAreaRatio};
			dispatchEvent(new ScreenResizeEvent(ScreenResizeEvent.SCREEN_RESIZED, _loc2_, true));
			this.showButtonPromts(true);
			Animate.legacyTo(this.m_pageContent, MenuConstants.PageOpenTime, {"alpha": 1}, Animate.Linear);
			this.updateIndicatorPosAndVisibility(true);
			if (this.m_masteryElement != null)
			{
				this.m_masteryElement.refreshLoca();
			}
			if (this.m_horizGradientOverlay != null)
			{
				Animate.fromTo(this.m_horizGradientOverlay, MenuConstants.PageOpenTime, 0, {"alpha": 0}, {"alpha": 1}, Animate.Linear);
			}
		}
		
		public function onClosePage(param1:Boolean):void
		{
			this.showButtonPromts(false);
			Animate.legacyTo(this.m_pageContent, MenuConstants.PageCloseTime, {"alpha": 0}, Animate.Linear);
			if (this.m_horizGradientOverlay != null)
			{
				Animate.kill(this.m_horizGradientOverlay);
				this.m_horizGradientOverlay.alpha = 0;
			}
		}
		
		public function hideGameVersion():void
		{
			this.m_versionIndicator.indicator.visible = false;
			this.m_versionIndicator.gameversion.text = "";
			this.m_versionIndicator.serverversion.text = "";
		}
		
		public function displayGameVersion(param1:Object):void
		{
			this.m_versionIndicator.indicator.visible = true;
			this.m_versionIndicator.gameversion.text = Localization.get("UI_MENU_PAGE_SETTINGS_GAMEVERSION") + ": " + param1.gameversion;
			if (param1.buildname)
			{
				this.m_versionIndicator.x = MenuConstants.menuXOffset + 400;
				this.m_versionIndicator.gameversion.width = 950;
				this.m_versionIndicator.gameversion.appendText(" (" + param1.buildname + ")");
			}
			else if (param1.buildid)
			{
				this.m_versionIndicator.gameversion.appendText(" (ID" + param1.buildid + ")");
			}
			this.m_versionIndicator.gameversion.textColor = MenuConstants.COLOR_WHITE;
			if (param1.serverversion)
			{
				this.m_versionIndicator.serverversion.text = Localization.get("UI_MENU_PAGE_SETTINGS_SERVERVERSION") + ": " + param1.serverversion;
				this.m_versionIndicator.serverversion.textColor = MenuConstants.COLOR_WHITE;
			}
		}
		
		public function setButtonPrompts(param1:Object):void
		{
			var data:Object = param1;
			var chunk:Function = function():void
			{
				m_previousButtonPromptsData = MenuUtils.parsePrompts(data, m_previousButtonPromptsData, m_promptsContainer, false, handlePromptMouseEvent);
			};
			TaskletSequencer.getGlobalInstance().addChunk(chunk);
		}
		
		private function handlePromptMouseEvent(param1:String):void
		{
			Log.info("mouse", this, "Prompt action click: " + param1);
			var _loc2_:int = -1;
			if (param1 == "cancel")
			{
				_loc2_ = 0;
			}
			if (param1 == "accept")
			{
				_loc2_ = 1;
			}
			if (param1 == "action-x")
			{
				_loc2_ = 2;
			}
			if (param1 == "action-y")
			{
				_loc2_ = 3;
			}
			if (param1 == "r")
			{
				_loc2_ = 4;
			}
			if (_loc2_ >= 0)
			{
				sendEventWithValue("onInputAction", _loc2_);
			}
		}
		
		public function showButtonPromts(param1:Boolean):void
		{
			this.m_promptsContainer.visible = param1;
		}
		
		public function set showPageContent(param1:Boolean):void
		{
			Animate.complete(this.m_pageContent);
			if (param1)
			{
				Animate.legacyTo(this.m_pageContent, MenuConstants.PageOpenTime, {"alpha": 1}, Animate.Linear);
			}
			else
			{
				Animate.legacyTo(this.m_pageContent, MenuConstants.PageOpenTime, {"alpha": 0}, Animate.Linear);
			}
		}
		
		public function set showOverlay(param1:Boolean):void
		{
		}
		
		public function set showWorldMap(param1:Boolean):void
		{
		}
		
		public function set disableProfileIndicator(param1:Boolean):void
		{
			this.m_disableProfileIndicator = param1;
			this.updateProfileIndicatorVisible();
		}
		
		public function set showDarkBackdrop(param1:Boolean):void
		{
			Animate.complete(this.m_darkBackdrop);
			if (param1)
			{
				Animate.legacyTo(this.m_darkBackdrop, MenuConstants.PageOpenTime, {"alpha": 0.53}, Animate.Linear);
			}
			else
			{
				Animate.legacyTo(this.m_darkBackdrop, MenuConstants.PageOpenTime, {"alpha": 0}, Animate.Linear);
			}
		}
		
		public function set showDarkBackdropLevelEnd(param1:Boolean):void
		{
			Animate.complete(this.m_darkBackdropLevelEnd);
			if (param1)
			{
				Animate.legacyTo(this.m_darkBackdropLevelEnd, 1, {"alpha": 1}, Animate.Linear);
			}
			else
			{
				Animate.legacyTo(this.m_darkBackdropLevelEnd, MenuConstants.PageOpenTime, {"alpha": 0}, Animate.Linear);
			}
		}
		
		public function set showFailedBackdrop(param1:Boolean):void
		{
			Log.xinfo(Log.ChannelMenuFrame, "showFailedBackdrop: " + param1);
			Animate.complete(this.m_failedBackdrop);
			if (param1)
			{
				Animate.legacyTo(this.m_failedBackdrop, MenuConstants.PageOpenTime, {"alpha": 0.8}, Animate.Linear);
			}
			else
			{
				Animate.legacyTo(this.m_failedBackdrop, MenuConstants.PageOpenTime, {"alpha": 0}, Animate.Linear);
			}
		}
		
		public function set showRedBackdrop(param1:Boolean):void
		{
			this.m_menuBackgroundInGame.alpha = param1 ? 1 : 0;
		}
		
		public function set showRedBackdropLevelEnd(param1:Boolean):void
		{
			Animate.complete(this.m_greyGradientBackdropLevelEnd);
			if (param1)
			{
				Animate.legacyTo(this.m_greyGradientBackdropLevelEnd, 0.5, {"alpha": 1}, Animate.Linear);
			}
			else
			{
				Animate.legacyTo(this.m_greyGradientBackdropLevelEnd, MenuConstants.PageOpenTime, {"alpha": 0}, Animate.Linear);
			}
		}
		
		public function set showTabsLines(param1:Boolean):void
		{
		}
		
		public function set showTabsUnderlay(param1:Boolean):void
		{
		}
		
		public function set showBackground(param1:Boolean):void
		{
			Animate.complete(this.m_background);
			Animate.complete(this.m_mapContainer);
			Animate.complete(this.m_greyBackground);
			Animate.complete(this.m_backgroundOverlay);
			if (param1)
			{
				Animate.legacyTo(this.m_background, MenuConstants.PageOpenTime, {"alpha": 1}, Animate.Linear);
				Animate.legacyTo(this.m_mapContainer, MenuConstants.PageOpenTime, {"alpha": 1}, Animate.Linear);
				Animate.legacyTo(this.m_greyBackground, MenuConstants.PageOpenTime, {"alpha": 1}, Animate.Linear);
				Animate.legacyTo(this.m_backgroundOverlay, MenuConstants.PageOpenTime, {"alpha": 1}, Animate.Linear);
			}
			else
			{
				Animate.legacyTo(this.m_background, MenuConstants.PageOpenTime, {"alpha": 0}, Animate.Linear);
				Animate.legacyTo(this.m_mapContainer, MenuConstants.PageOpenTime, {"alpha": 0}, Animate.Linear);
				Animate.legacyTo(this.m_greyBackground, MenuConstants.PageOpenTime, {"alpha": 0}, Animate.Linear);
				Animate.legacyTo(this.m_backgroundOverlay, MenuConstants.PageOpenTime, {"alpha": 0}, Animate.Linear);
			}
		}
		
		public function showMenuPageContent(param1:Boolean):void
		{
			this.showPageContent = param1;
		}
		
		public function showMenuOverlay(param1:Boolean):void
		{
			this.showOverlay = param1;
		}
		
		public function showMenuWorldMap(param1:Boolean):void
		{
			this.showWorldMap = param1;
		}
		
		public function showMenuDarkBackdrop(param1:Boolean):void
		{
			this.showRedBackdrop = param1;
		}
		
		public function showMenuDarkBackdropLevelEnd(param1:Boolean):void
		{
			this.showDarkBackdropLevelEnd = param1;
		}
		
		public function showMenuFailedBackdrop(param1:Boolean):void
		{
			this.showFailedBackdrop = param1;
		}
		
		public function showMenuRedBackdrop(param1:Boolean):void
		{
			this.showRedBackdrop = param1;
		}
		
		public function showMenuRedBackdropLevelEnd(param1:Boolean):void
		{
			this.showRedBackdropLevelEnd = param1;
		}
		
		public function showMenuTabsLines(param1:Boolean):void
		{
			this.showTabsLines = param1;
		}
		
		public function showMenuTabsUnderlay(param1:Boolean):void
		{
			this.showTabsUnderlay = param1;
		}
		
		public function showMenuBackground(param1:Boolean):void
		{
			this.showBackground = param1;
		}
		
		public function showMenuBackgroundFullOverlay(param1:Boolean):void
		{
			Animate.kill(this.m_menuFullOverlay);
			if (param1)
			{
				Animate.legacyTo(this.m_menuFullOverlay, MenuConstants.PageOpenTime, {"alpha": 1}, Animate.Linear);
			}
			else
			{
				Animate.legacyTo(this.m_menuFullOverlay, MenuConstants.PageOpenTime, {"alpha": 0}, Animate.Linear);
			}
		}
		
		public function set showHorizGradientOverlay(param1:Boolean):void
		{
			if (!param1 && this.m_horizGradientOverlay != null)
			{
				this.m_backgroundContainer.removeChild(this.m_horizGradientOverlay);
				this.m_horizGradientOverlay = null;
			}
			else if (param1 && this.m_horizGradientOverlay == null)
			{
				this.m_horizGradientOverlay = new Shape();
				this.m_horizGradientOverlay.name = "m_horizGradientOverlay";
				this.m_horizGradientOverlay.alpha = 0;
				this.m_backgroundContainer.addChild(this.m_horizGradientOverlay);
				MenuUtils.centerFillAspectFull(this.m_horizGradientOverlay, 100, 100, this.m_width, this.m_height);
				this.redrawHorizGradientOverlay();
			}
		}
		
		[PROPERTY(CONSTRAINT = "Editors(Slider) MinValue(-1) MaxValue(1) DecimalPlaces(2)")]
		public function set HorizGradientOverlay_OffsetBegin(param1:Number):void
		{
			this.m_HorizGradientOverlay_offsBegin = param1;
			this.redrawHorizGradientOverlay();
		}
		
		[PROPERTY(CONSTRAINT = "Editors(Slider) MinValue(-1) MaxValue(1) DecimalPlaces(2)")]
		public function set HorizGradientOverlay_OffsetEnd(param1:Number):void
		{
			this.m_HorizGradientOverlay_offsEnd = param1;
			this.redrawHorizGradientOverlay();
		}
		
		[PROPERTY(CONSTRAINT = "Editors(Slider) MinValue(0) MaxValue(1) DecimalPlaces(2)")]
		public function set HorizGradientOverlay_AlphaBegin(param1:Number):void
		{
			this.m_HorizGradientOverlay_fAlphaBegin = param1;
			this.redrawHorizGradientOverlay();
		}
		
		[PROPERTY(CONSTRAINT = "Editors(Slider) MinValue(0) MaxValue(1) DecimalPlaces(2)")]
		public function set HorizGradientOverlay_AlphaEnd(param1:Number):void
		{
			this.m_HorizGradientOverlay_fAlphaEnd = param1;
			this.redrawHorizGradientOverlay();
		}
		
		[PROPERTY(HELPTEXT = "Hexadecimal code, e.g. \'ff0000\' for red")]
		public function set HorizGradientOverlay_color(param1:String):void
		{
			this.m_HorizGradientOverlay_color = parseInt(param1, 16);
			if (isNaN(this.m_HorizGradientOverlay_color))
			{
				this.m_HorizGradientOverlay_color = 0;
			}
			this.redrawHorizGradientOverlay();
		}
		
		private function redrawHorizGradientOverlay():void
		{
			var g:Graphics;
			var matr:Matrix;
			var fRatioFromOffset:Function;
			var fRatioBegin:Number;
			var fRatioEnd:Number;
			var fAspect16x9:Number = NaN;
			var fAspectCurrent:Number = NaN;
			var isStretchedHorizontally:Boolean = false;
			var offsLeftEdge:Number = NaN;
			var offsRightEdge:Number = NaN;
			if (this.m_horizGradientOverlay == null)
			{
				return;
			}
			g = this.m_horizGradientOverlay.graphics;
			g.clear();
			matr = new Matrix();
			matr.createGradientBox(100, 100, 0, 0, 0);
			fAspect16x9 = MenuConstants.BaseWidth / MenuConstants.BaseHeight;
			fAspectCurrent = this.m_width / this.m_height;
			isStretchedHorizontally = fAspectCurrent > fAspect16x9;
			offsLeftEdge = isStretchedHorizontally ? (1 - fAspect16x9 / fAspectCurrent) / 2 : (1 - fAspectCurrent) / 2;
			offsRightEdge = 1 - offsLeftEdge;
			fRatioFromOffset = function(param1:Number):Number
			{
				return offsLeftEdge + (offsRightEdge - offsLeftEdge) * (param1 + 1) / 2;
			};
			fRatioBegin = fRatioFromOffset(this.m_HorizGradientOverlay_offsBegin);
			fRatioEnd = fRatioFromOffset(this.m_HorizGradientOverlay_offsEnd);
			g.beginGradientFill(GradientType.LINEAR, [this.m_HorizGradientOverlay_color, this.m_HorizGradientOverlay_color], [this.m_HorizGradientOverlay_fAlphaBegin, this.m_HorizGradientOverlay_fAlphaEnd], [255 * fRatioBegin, 255 * fRatioEnd], matr);
			g.drawRect(0, 0, 100, 100);
		}
		
		public function setMenuDifficultyMode(param1:String):void
		{
		}
		
		public function setBackgroundData(param1:Object):void
		{
			this.m_backgroundImage.setBackgroundData(param1);
		}
		
		public function setBackground(param1:String):void
		{
			this.m_backgroundImage.setBackground(param1);
		}
		
		public function setBackgroundLayer(param1:Object):void
		{
			var _loc2_:String = param1.image != null ? String(param1.image) : "";
			var _loc3_:Boolean = param1.scalefull != null ? Boolean(param1.scalefull) : true;
			var _loc4_:int = param1.offsetX != null ? int(param1.offsetX) : 0;
			var _loc5_:int = param1.offsetY != null ? int(param1.offsetY) : 0;
			this.m_backgroundLayerImage.setBackground(_loc2_, _loc3_, _loc4_, _loc5_);
		}
		
		private function scaleRedBottom(param1:Number, param2:Number):void
		{
			var _loc3_:Number = Math.min(param1 / MenuConstants.BaseWidth, param2 / MenuConstants.BaseHeight) * this.m_safeAreaRatio;
			var _loc4_:Number = MenuConstants.BaseWidth * _loc3_;
			var _loc5_:Number = MenuConstants.BaseHeight * _loc3_;
			var _loc6_:Number;
			var _loc7_:Number = (_loc6_ = (param1 - _loc4_) / 2) * (1 / _loc3_);
			var _loc8_:Number = 1 + _loc7_ * 2 / MenuConstants.BaseWidth;
			var _loc9_:Number;
			var _loc10_:Number = (_loc9_ = (param2 - _loc5_) / 2) * (1 / _loc3_);
			var _loc11_:Number = 1 + _loc10_ * 2 / MenuConstants.BaseHeight;
		}
		
		private function drawGreyBackground():void
		{
			this.m_greyBackground.graphics.clear();
			this.m_greyBackground.graphics.beginFill(this.MENU_BG_COLOR, 1);
			if (ControlsMain.isVrModeActive())
			{
				this.m_greyBackground.graphics.drawRect(1, 1, MenuConstants.BaseWidth - 2, MenuConstants.BaseHeight - 2);
			}
			else
			{
				this.m_greyBackground.graphics.drawRect(0, 0, MenuConstants.BaseWidth, MenuConstants.BaseHeight);
			}
		}
		
		private function drawUserLine(param1:Number, param2:Number):void
		{
		}
		
		private function bottomAlignMapContainer(param1:Number, param2:Number):void
		{
			this.m_mapContainer.y = param2 - this.m_mapContainer.height;
		}
		
		override public function onSetSize(param1:Number, param2:Number):void
		{
			this.m_width = param1;
			this.m_height = param2;
			this.drawGreyBackground();
			MenuUtils.centerFill(this.m_greyBackground, MenuConstants.BaseWidth, MenuConstants.BaseHeight, param1, param2);
			if (ControlsMain.isVrModeActive())
			{
				MenuUtils.centerFill(this.m_backgroundContainer, MenuConstants.BaseWidth, MenuConstants.BaseHeight, MenuConstants.BaseWidth, MenuConstants.BaseHeight, 1.25);
				this.m_backgroundContainer.z = MenuUtils.toPixel(1);
			}
			else
			{
				MenuUtils.centerFill(this.m_backgroundContainer, MenuConstants.BaseWidth, MenuConstants.BaseHeight, MenuConstants.BaseWidth, MenuConstants.BaseHeight);
				this.m_backgroundContainer.z = 0;
				this.m_backgroundContainer.transform.matrix3D = null;
			}
			MenuUtils.centerFill(this.m_backgroundOverlay, MenuConstants.BaseWidth, MenuConstants.BaseHeight, param1, param2);
			MenuUtils.centerFill(this.m_menuBackgroundInGame, MenuConstants.BaseWidth, MenuConstants.BaseHeight, param1, param2);
			MenuUtils.centerFill(this.m_greyGradientBackdropLevelEnd, MenuConstants.BaseWidth, MenuConstants.BaseHeight, param1, param2);
			MenuUtils.centerFill(this.m_darkBackdrop, MenuConstants.BaseWidth, MenuConstants.BaseHeight, param1, param2);
			MenuUtils.centerFill(this.m_darkBackdropLevelEnd, MenuConstants.BaseWidth, MenuConstants.BaseHeight, param1, param2);
			MenuUtils.centerFill(this.m_failedBackdrop, MenuConstants.BaseWidth, MenuConstants.BaseHeight, param1, param2);
			MenuUtils.centerFill(this.m_mapContainer, MenuConstants.BaseWidth, MenuConstants.BaseHeight, param1, param2);
			MenuUtils.centerFillAspectFull(this.m_background, MenuConstants.BaseWidth, MenuConstants.BaseHeight, param1, param2);
			if (this.m_horizGradientOverlay != null)
			{
				MenuUtils.centerFillAspectFull(this.m_horizGradientOverlay, 100, 100, param1, param2);
				this.redrawHorizGradientOverlay();
			}
			if (ControlsMain.isVrModeActive())
			{
				this.m_backgroundLayer.z = MenuUtils.toPixel(-0.4);
			}
			else
			{
				this.m_backgroundLayer.z = 0;
				this.m_backgroundLayer.transform.matrix3D = null;
			}
			MenuUtils.centerFillAspectHeight(this.m_backgroundLayer, MenuConstants.BaseWidth, MenuConstants.BaseHeight, param1, param2);
			MenuUtils.centerFillAspect(this.m_container, MenuConstants.BaseWidth, MenuConstants.BaseHeight, param1, param2);
			MenuUtils.centerFillAspect(this.m_foreground, MenuConstants.BaseWidth, MenuConstants.BaseHeight, param1, param2);
			this.drawUserLine(param1, param2);
			this.scaleRedBottom(param1, param2);
			if (ControlsMain.getDisplaySize() == ControlsMain.DISPLAY_SIZE_SMALL)
			{
				this.m_promptsContainer.scaleX = 1.35;
				this.m_promptsContainer.scaleY = 1.35;
				this.m_profileElement.scaleX = 1.5;
				this.m_profileElement.scaleY = 1.5;
				this.m_masteryElement.alpha = 0;
			}
			else
			{
				this.m_promptsContainer.scaleX = 1;
				this.m_promptsContainer.scaleY = 1;
				this.m_profileElement.scaleX = 1;
				this.m_profileElement.scaleY = 1;
				this.m_masteryElement.alpha = 1;
			}
			var _loc3_:Object = {"sizeX": param1, "sizeY": param2, "safeAreaRatio": this.m_safeAreaRatio};
			dispatchEvent(new ScreenResizeEvent(ScreenResizeEvent.SCREEN_RESIZED, _loc3_, true));
		}
		
		public function getMapContainerScale():Number
		{
			return MenuUtils.getFillAspectScale(MenuConstants.BaseWidth, MenuConstants.BaseHeight, this.m_width, this.m_height);
		}
		
		override public function onSetViewport(param1:Number, param2:Number, param3:Number):void
		{
			this.m_safeAreaRatio = param3;
			this.m_view.scaleX = this.m_safeAreaRatio;
			this.m_view.scaleY = this.m_safeAreaRatio;
			this.m_view.x = MenuConstants.BaseWidth * (1 - this.m_safeAreaRatio) / 2;
			this.m_view.y = MenuConstants.BaseHeight * (1 - this.m_safeAreaRatio) / 2;
			this.drawUserLine(this.m_width, this.m_height);
			this.scaleRedBottom(this.m_width, this.m_height);
			var _loc4_:Object = {"sizeX": this.m_width, "sizeY": this.m_height, "safeAreaRatio": this.m_safeAreaRatio};
			dispatchEvent(new ScreenResizeEvent(ScreenResizeEvent.SCREEN_RESIZED, _loc4_, true));
		}
		
		public function setUiInputActive(param1:Boolean):void
		{
			if (this.m_isUiInputActive == param1)
			{
				return;
			}
			this.m_isUiInputActive = param1;
			this.checkMouseState();
		}
		
		public function onMouseActiveChanged(param1:Boolean):void
		{
			if (this.m_isMouseActive == param1)
			{
				return;
			}
			this.m_isMouseActive = param1;
			this.checkMouseState();
		}
		
		public function onVisibleFadeIn(param1:Number):void
		{
			this.m_backgroundImage.onVisibleFadeIn(param1);
		}
		
		private function checkMouseState():void
		{
			var _loc4_:DisplayObject = null;
			var _loc5_:MenuElementBase = null;
			var _loc6_:DisplayObject = null;
			var _loc7_:Boolean = false;
			var _loc8_:int = 0;
			if (!this.m_isMouseActive || !this.m_isUiInputActive)
			{
				return;
			}
			var _loc1_:Point = new Point(stage.mouseX, stage.mouseY);
			var _loc2_:Array = stage.getObjectsUnderPoint(_loc1_);
			if (_loc2_ == null || _loc2_.length <= 0)
			{
				return;
			}
			var _loc3_:Array = new Array();
			while (_loc2_.length > 0)
			{
				if ((_loc4_ = _loc2_.pop() as DisplayObject) != null)
				{
					_loc5_ = null;
					_loc6_ = _loc4_;
					while (_loc6_ != null && _loc5_ == null)
					{
						_loc5_ = _loc6_ as MenuElementBase;
						_loc6_ = _loc6_.parent;
					}
					if (_loc5_ != null)
					{
						_loc7_ = false;
						_loc8_ = 0;
						while (_loc8_ < _loc3_.length && !_loc7_)
						{
							if (_loc3_[_loc8_] == _loc5_)
							{
								_loc7_ = true;
							}
							_loc8_++;
						}
						if (!_loc7_)
						{
							_loc5_.triggerMouseRollOver();
							_loc3_.unshift(_loc5_);
						}
					}
				}
			}
		}
	}
}
