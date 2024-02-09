package menu3.basic
{
	import common.Animate;
	import common.CommonUtils;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.display.Sprite;
	import menu3.MenuElementLockableContentBase;
	import menu3.MenuImageLoader;
	import menu3.indicator.InPlaylistIndicator;
	
	public dynamic class MenuTileSmall extends MenuElementLockableContentBase
	{
		
		protected var m_view:MenuTileSmallView;
		
		private var m_loader:MenuImageLoader;
		
		private var m_pressable:Boolean = true;
		
		private var m_hidebarcode:Boolean;
		
		private var m_infoIndicatorWithTitle:InfoIndicatorWithTitleSmallView;
		
		private var m_iconLabel:String;
		
		private var m_currentImage:String;
		
		private var m_hadValidAgencyPickupData:Boolean = false;
		
		public function MenuTileSmall(param1:Object)
		{
			super(param1);
			this.m_view = new MenuTileSmallView();
			this.m_view.tileBg.alpha = 0;
			this.m_view.tileDarkBg.alpha = 0.3;
			this.m_view.dropShadow.alpha = 0;
			addChild(this.m_view);
		}
		
		override public function onSetData(param1:Object):void
		{
			var _loc3_:Boolean = false;
			var _loc4_:String = null;
			var _loc5_:String = null;
			var _loc6_:String = null;
			super.onSetData(param1);
			this.removeIndicators();
			MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_MENU_TABS_BACKGROUND, true, MenuConstants.MenuElementBackgroundAlpha);
			this.m_pressable = getNodeProp(this, "pressable");
			this.m_iconLabel = param1.icon;
			MenuUtils.setupIcon(this.m_view.tileIcon, this.m_iconLabel, this.m_pressable ? uint(MenuConstants.COLOR_WHITE) : uint(MenuConstants.COLOR_GREY), true, false);
			this.m_hidebarcode = param1.hidebarcode;
			var _loc2_:* = param1.agencypickup != null;
			if (!_loc2_ && this.m_hadValidAgencyPickupData)
			{
				setAgencyPickup(this.m_view, param1, "small");
			}
			this.m_hadValidAgencyPickupData = _loc2_;
			if (param1.image)
			{
				this.loadImage(param1.image);
			}
			if (param1.availability)
			{
				setAvailablity(this.m_view, param1, "small");
			}
			if (_loc2_)
			{
				setAgencyPickup(this.m_view, param1, "small");
			}
			if (param1.setassaveslotheader)
			{
				_loc3_ = false;
				_loc4_ = "";
				_loc5_ = "";
				_loc6_ = "";
				if (param1.saveslotheaderdata != null)
				{
					_loc3_ = param1.saveslotheaderdata.disable != undefined ? Boolean(param1.saveslotheaderdata.disable) : false;
					_loc4_ = param1.saveslotheaderdata.infotitle != undefined ? String(param1.saveslotheaderdata.infotitle) : "";
					_loc5_ = param1.saveslotheaderdata.infotext != undefined ? String(param1.saveslotheaderdata.infotext) : "";
					_loc6_ = param1.saveslotheaderdata.infoicon != undefined ? String(param1.saveslotheaderdata.infoicon) : "";
				}
				this.m_view.tileSelect.alpha = 0;
				this.m_view.dropShadow.alpha = 0;
				this.m_view.tileDarkBg.alpha = 1;
				MenuUtils.setColor(this.m_view.tileDarkBg, MenuConstants.COLOR_MENU_TABS_BACKGROUND, true, MenuConstants.MenuElementBackgroundAlpha);
				this.m_view.tileIcon.x = 317;
				MenuUtils.setupIcon(this.m_view.tileIcon, "arrowright", MenuConstants.COLOR_WHITE, false, false);
				this.m_view.title.width = 280;
				this.m_view.title.multiline = true;
				this.m_view.title.wordWrap = true;
				this.m_view.title.autoSize = "left";
				MenuUtils.setupTextUpper(this.m_view.header, param1.header, 14, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
				MenuUtils.setupTextUpper(this.m_view.title, param1.title, 26, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
				this.m_view.header.x = 14;
				this.m_view.header.y = 208 - 25 * (this.m_view.title.numLines - 1);
				this.m_view.title.x = 13;
				this.m_view.title.y = 220 - 25 * (this.m_view.title.numLines - 1);
				if (_loc5_.length > 0 || _loc4_.length > 0)
				{
					this.setupInfoIndicatorWithTitle(_loc4_, _loc5_, _loc6_);
				}
			}
			else
			{
				this.setupTextFields(param1.header, param1.title);
				this.changeTextColor(this.m_pressable ? uint(MenuConstants.COLOR_WHITE) : uint(MenuConstants.COLOR_GREY), this.m_pressable ? uint(MenuConstants.COLOR_WHITE) : uint(MenuConstants.COLOR_GREY));
			}
			this.handleSelectionChange();
		}
		
		private function removeIndicators():void
		{
			if (this.m_infoIndicatorWithTitle != null)
			{
				this.m_view.indicator.removeChild(this.m_infoIndicatorWithTitle);
				this.m_infoIndicatorWithTitle = null;
			}
		}
		
		private function setupTextFields(param1:String, param2:String):void
		{
			MenuUtils.setupTextUpper(this.m_view.header, param1, 14, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
			MenuUtils.setupTextUpper(this.m_view.title, param2, 26, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			MenuUtils.truncateTextfield(this.m_view.header, 1, MenuConstants.FontColorWhite, CommonUtils.changeFontToGlobalIfNeeded(this.m_view.header));
			MenuUtils.truncateTextfield(this.m_view.title, 1, MenuConstants.FontColorWhite, CommonUtils.changeFontToGlobalIfNeeded(this.m_view.title));
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
				m_view.image.height = MenuConstants.MenuTileSmallHeight;
				m_view.image.scaleX = m_view.image.scaleY;
				if (m_view.image.width < MenuConstants.MenuTileSmallWidth)
				{
					m_view.image.width = MenuConstants.MenuTileSmallWidth;
					m_view.image.scaleY = m_view.image.scaleX;
				}
			});
		}
		
		override public function getView():Sprite
		{
			return this.m_view.tileBg;
		}
		
		override protected function handleSelectionChange():void
		{
			var _loc1_:InPlaylistIndicator = null;
			super.handleSelectionChange();
			Animate.complete(this.m_view);
			if (!this.m_hidebarcode)
			{
				_loc1_ = getIndicator(EInPlaylistIndicator) as InPlaylistIndicator;
				if (_loc1_ != null)
				{
					_loc1_.setColorInvert(false);
				}
			}
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
					if (!this.m_hidebarcode)
					{
						_loc1_ = getIndicator(EInPlaylistIndicator) as InPlaylistIndicator;
						if (_loc1_ != null)
						{
							_loc1_.setColorInvert(true);
						}
					}
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
			super.onUnregister();
			if (this.m_view)
			{
				this.completeAnimations();
				if (this.m_loader)
				{
					this.m_loader.cancelIfLoading();
					this.m_view.image.removeChild(this.m_loader);
					this.m_loader = null;
				}
				this.removeIndicators();
				removeChild(this.m_view);
				this.m_view = null;
			}
		}
		
		private function completeAnimations():void
		{
			Animate.complete(this.m_view.tileDarkBg);
			if (!this.m_hidebarcode)
			{
				if (m_infoIndicator != null)
				{
					Animate.complete(m_infoIndicator);
				}
			}
		}
		
		private function setupInfoIndicatorWithTitle(param1:String, param2:String, param3:String):void
		{
			var _loc4_:int = 0;
			var _loc5_:int = 0;
			var _loc6_:int = 0;
			var _loc7_:Number = NaN;
			this.m_infoIndicatorWithTitle = new InfoIndicatorWithTitleSmallView();
			this.m_infoIndicatorWithTitle.y = 3;
			this.m_infoIndicatorWithTitle.title.x = 13;
			this.m_infoIndicatorWithTitle.title.y = 57;
			this.m_infoIndicatorWithTitle.text.x = 14;
			this.m_infoIndicatorWithTitle.text.y = 92;
			this.m_infoIndicatorWithTitle.title.width = 325;
			this.m_infoIndicatorWithTitle.text.width = 325;
			this.m_infoIndicatorWithTitle.darkBg.visible = false;
			this.m_infoIndicatorWithTitle.line.visible = false;
			MenuUtils.setupText(this.m_infoIndicatorWithTitle.title, param1, 28, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
			MenuUtils.shrinkTextToFit(this.m_infoIndicatorWithTitle.title, this.m_infoIndicatorWithTitle.title.width, 0);
			MenuUtils.setupText(this.m_infoIndicatorWithTitle.text, param2, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			if (param2.length > 0)
			{
				this.m_infoIndicatorWithTitle.text.multiline = true;
				this.m_infoIndicatorWithTitle.text.wordWrap = true;
				this.m_infoIndicatorWithTitle.text.autoSize = "left";
				_loc4_ = 24;
				_loc5_ = 5;
				_loc6_ = Math.min(this.m_infoIndicatorWithTitle.text.numLines, _loc5_);
				_loc7_ = 5;
				MenuUtils.truncateTextfield(this.m_infoIndicatorWithTitle.text, _loc5_);
			}
			if (param3.length > 0)
			{
				MenuUtils.setupIcon(this.m_infoIndicatorWithTitle.icon, param3, MenuConstants.COLOR_WHITE, true, false);
			}
			else
			{
				this.m_infoIndicatorWithTitle.icon.visible = false;
			}
			this.m_view.indicator.addChild(this.m_infoIndicatorWithTitle);
		}
	}
}
