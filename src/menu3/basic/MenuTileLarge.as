package menu3.basic
{
	import common.Animate;
	import common.CommonUtils;
	import common.Localization;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.display.Sprite;
	import menu3.MenuElementLockableContentBase;
	import menu3.MenuImageLoader;
	
	public dynamic class MenuTileLarge extends MenuElementLockableContentBase
	{
		
		protected var m_view:MenuTileLargeView;
		
		private var m_loader:MenuImageLoader;
		
		private var m_pressable:Boolean = true;
		
		private var m_videoIndicator:VideoCutsceneIndicatorView;
		
		private var m_timeindicatorInfo:Array;
		
		private var m_iconLabel:String;
		
		private var m_currentImage:String;
		
		private var m_useBigHeader:Boolean;
		
		private const BIG_HEADER_Y_OFFSET:Number = 70;
		
		private var m_origBriefingHeaderY:Number = 0;
		
		private var m_origBriefingY:Number = 0;
		
		private var m_origBriefingHeight:Number = 0;
		
		public function MenuTileLarge(param1:Object)
		{
			super(param1);
			this.m_view = new MenuTileLargeView();
			this.m_view.tileBg.alpha = 0;
			this.m_view.tileDarkBg.alpha = 0.3;
			this.m_view.dropShadow.alpha = 0;
			this.m_origBriefingHeaderY = this.m_view.briefingheader.y;
			this.m_origBriefingY = this.m_view.briefing.y;
			this.m_origBriefingHeight = this.m_view.briefing.height;
			addChild(this.m_view);
		}
		
		override public function onSetData(param1:Object):void
		{
			super.onSetData(param1);
			this.m_useBigHeader = param1.useBigHeader != null ? Boolean(param1.useBigHeader) : false;
			MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_MENU_TABS_BACKGROUND, true, MenuConstants.MenuElementBackgroundAlpha);
			this.m_pressable = getNodeProp(this, "pressable");
			this.m_iconLabel = param1.icon;
			MenuUtils.setupIcon(this.m_view.tileIcon, this.m_iconLabel, this.m_pressable ? uint(MenuConstants.COLOR_WHITE) : uint(MenuConstants.COLOR_GREY), true, false);
			this.setupTextFields(param1.header, param1.title, param1.briefingheader, param1.briefing);
			this.changeTextColor(this.m_pressable ? uint(MenuConstants.COLOR_WHITE) : uint(MenuConstants.COLOR_GREY), this.m_pressable ? uint(MenuConstants.COLOR_WHITE) : uint(MenuConstants.COLOR_GREY));
			if (param1.image)
			{
				this.loadImage(param1.image);
			}
			if (param1.availability)
			{
				setAvailablity(this.m_view, param1, "large");
			}
			if (param1.video)
			{
				this.m_videoIndicator = new VideoCutsceneIndicatorView();
				this.m_videoIndicator.x = this.m_view.tileBg.width >> 1;
				this.m_videoIndicator.y = this.m_view.tileBg.height >> 1;
				this.m_videoIndicator.bg.alpha = 0.8;
				this.m_view.addChild(this.m_videoIndicator);
			}
			if (param1.profileStatistics)
			{
				this.showStatistics(param1.profile, param1.profileStatistics);
			}
			this.handleSelectionChange();
		}
		
		private function setupTextFields(param1:String, param2:String, param3:String = "", param4:String = ""):void
		{
			MenuUtils.setupTextUpper(this.m_view.header, param1, 14, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
			MenuUtils.setupTextUpper(this.m_view.title, param2, 26, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			MenuUtils.truncateTextfield(this.m_view.header, 1, MenuConstants.FontColorWhite, CommonUtils.changeFontToGlobalIfNeeded(this.m_view.header));
			MenuUtils.truncateTextfield(this.m_view.title, 1, MenuConstants.FontColorWhite, CommonUtils.changeFontToGlobalIfNeeded(this.m_view.title));
			this.m_view.briefing.autoSize = "none";
			this.m_view.briefing.width = 570;
			this.m_view.briefing.multiline = true;
			this.m_view.briefing.wordWrap = true;
			if (this.m_useBigHeader)
			{
				this.m_view.briefingheader.y = this.m_origBriefingHeaderY - this.BIG_HEADER_Y_OFFSET;
				this.m_view.briefing.y = this.m_origBriefingY - this.BIG_HEADER_Y_OFFSET;
				this.m_view.briefing.height = this.m_origBriefingHeight + this.BIG_HEADER_Y_OFFSET;
			}
			MenuUtils.setupTextUpper(this.m_view.briefingheader, param3, 48, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			MenuUtils.shrinkTextToFit(this.m_view.briefingheader, this.m_view.briefingheader.width, -1);
			MenuUtils.setupText(this.m_view.briefing, param4, 21, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
			MenuUtils.truncateTextfield(this.m_view.briefingheader, 1, MenuConstants.FontColorWhite);
			MenuUtils.truncateHTMLField(this.m_view.briefing, param4, null, CommonUtils.changeFontToGlobalIfNeeded(this.m_view.briefing));
		}
		
		private function changeTextColor(param1:uint, param2:uint):void
		{
			this.m_view.header.textColor = param1;
			this.m_view.title.textColor = param2;
		}
		
		private function showText(param1:Boolean):void
		{
			this.m_view.header.visible = param1;
			this.m_view.title.visible = param1;
		}
		
		private function loadImage(param1:String):void
		{
			var imagePath:String = param1;
			if (this.m_currentImage == imagePath)
			{
				return;
			}
			this.m_currentImage = imagePath;
			if (this.m_loader != null)
			{
				this.m_loader.cancelIfLoading();
				this.m_view.image.removeChild(this.m_loader);
				this.m_loader = null;
			}
			this.m_loader = new MenuImageLoader(ControlsMain.isVrModeActive());
			this.m_view.image.addChild(this.m_loader);
			this.m_loader.center = true;
			this.m_loader.loadImage(imagePath, function():void
			{
				Animate.legacyTo(m_view.tileDarkBg, 0.3, {"alpha": 0}, Animate.Linear);
				MenuUtils.trySetCacheAsBitmap(m_view.image, true);
				m_view.image.height = MenuConstants.MenuTileLargeHeight;
				m_view.image.scaleX = m_view.image.scaleY;
				if (m_view.image.width < MenuConstants.MenuTileLargeWidth)
				{
					m_view.image.width = MenuConstants.MenuTileLargeWidth;
					m_view.image.scaleY = m_view.image.scaleX;
				}
			});
		}
		
		override public function getView():Sprite
		{
			return this.m_view.tileBg;
		}
		
		private function showStatistics(param1:String, param2:Object):void
		{
			var _loc3_:ValueIndicatorLargeView = null;
			var _loc4_:int = 0;
			var _loc5_:String = null;
			if (!this.m_timeindicatorInfo)
			{
				this.m_timeindicatorInfo = [];
				_loc3_ = new ValueIndicatorLargeView();
				MenuUtils.setupTextUpper(_loc3_.header, Localization.get("UI_DIALOG_USER_NAME"), 18, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
				MenuUtils.setupTextUpper(_loc3_.value, param1, 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
				_loc3_.y = this.m_view.tileBg.height - MenuConstants.ValueIndicatorYOffset;
				addChild(_loc3_);
				this.m_timeindicatorInfo.push(_loc3_);
				_loc4_ = 1;
				for (_loc5_ in param2)
				{
					_loc3_ = new ValueIndicatorLargeView();
					MenuUtils.setupTextUpper(_loc3_.header, Localization.get(_loc5_), 18, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
					MenuUtils.setupTextUpper(_loc3_.value, param2[_loc5_], 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
					_loc3_.y = this.m_view.tileBg.height - MenuConstants.ValueIndicatorYOffset - 30 * _loc4_;
					addChild(_loc3_);
					this.m_timeindicatorInfo.push(_loc3_);
					_loc4_++;
				}
			}
		}
		
		override protected function handleSelectionChange():void
		{
			super.handleSelectionChange();
			Animate.complete(this.m_view);
			if (m_loading)
			{
				return;
			}
			if (m_isSelected)
			{
				setPopOutScale(this.m_view, true);
				Animate.to(this.m_view.dropShadow, 0.3, 0, {"alpha": 1}, Animate.ExpoOut);
				if (this.m_pressable)
				{
					MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_RED, true, MenuConstants.MenuElementSelectedAlpha);
					MenuUtils.setupIcon(this.m_view.tileIcon, this.m_iconLabel, MenuConstants.COLOR_RED, false, true, MenuConstants.COLOR_WHITE, 1, 0, true);
				}
			}
			else
			{
				setPopOutScale(this.m_view, false);
				Animate.kill(this.m_view.dropShadow);
				this.m_view.dropShadow.alpha = 0;
				if (this.m_pressable)
				{
					MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_MENU_TABS_BACKGROUND, true, MenuConstants.MenuElementBackgroundAlpha);
					MenuUtils.setupIcon(this.m_view.tileIcon, this.m_iconLabel, MenuConstants.COLOR_WHITE, true, false);
				}
			}
		}
		
		override public function onUnregister():void
		{
			if (this.m_view)
			{
				super.onUnregister();
				this.completeAnimations();
				if (this.m_loader)
				{
					this.m_loader.cancelIfLoading();
					this.m_view.image.removeChild(this.m_loader);
					this.m_loader = null;
				}
				removeChild(this.m_view);
				this.m_view = null;
			}
		}
		
		private function completeAnimations():void
		{
			Animate.complete(this.m_view.tileDarkBg);
			if (m_infoIndicator != null)
			{
				Animate.complete(m_infoIndicator);
			}
		}
	}
}
