package menu3.basic
{
	import common.Animate;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import common.menu.textTicker;
	import flash.display.Sprite;
	import menu3.MenuElementLockableContentBase;
	import menu3.MenuImageLoader;
	
	public dynamic class DestinationCategoryTile extends MenuElementLockableContentBase
	{
		
		private var m_view:DestinationCategoryTileView;
		
		private var m_loader:MenuImageLoader;
		
		private var m_textObj:Object;
		
		private var m_textTicker:textTicker;
		
		private var m_pressable:Boolean = true;
		
		private var m_alwaysDisplaySelectedState:Boolean = false;
		
		private var m_enableInfo:Boolean = false;
		
		private const HEADER_Y_START_POS:Number = 394;
		
		private const HEADER_Y_END_POS:Number = 385;
		
		private const TITLE_Y_START_POS:Number = 409;
		
		private const TITLE_Y_END_POS:Number = 398;
		
		private const TITLE_START_SCALE:Number = 0.8;
		
		private const TITLE_END_SCALE:Number = 1;
		
		private const TILEICON_Y_START_POS:Number = 373;
		
		private const TILEICON_Y_END_POS:Number = 364;
		
		public function DestinationCategoryTile(param1:Object)
		{
			this.m_textObj = new Object();
			super(param1);
			this.m_view = new DestinationCategoryTileView();
			MenuUtils.setColorFilter(this.m_view.image, "desaturated");
			MenuUtils.setupIcon(this.m_view.tileIcon, param1.icon, MenuConstants.COLOR_GREY_DARK, false, true, MenuConstants.COLOR_WHITE);
			this.m_view.tileIcon.alpha = 0;
			this.m_view.tileIcon.y = this.TILEICON_Y_START_POS;
			this.m_view.tileSelect.alpha = 0;
			this.m_view.tileSelectPulsate.alpha = 0;
			this.m_view.tileBg.alpha = 0;
			this.m_view.tileDarkBg.alpha = 0.3;
			this.m_view.informationBg.alpha = 0;
			this.m_view.informationBg.height = 55;
			this.m_view.informationBg.y = 495;
			this.m_view.info.y += 5;
			this.m_view.info.alpha = 0;
			this.m_view.info.completionheader.y += 1;
			this.m_view.info.completionvalue.y += 3;
			MenuUtils.setTintColor(this.m_view.info.completionheader, MenuUtils.TINT_COLOR_GREY, false);
			MenuUtils.setTintColor(this.m_view.info.completionvalue, MenuUtils.TINT_COLOR_GREY, false);
			this.m_view.header.y = this.HEADER_Y_START_POS;
			this.m_view.title.y = this.TITLE_Y_START_POS;
			this.m_view.title.scaleX = this.m_view.title.scaleY = this.TITLE_START_SCALE;
			addChild(this.m_view);
		}
		
		override public function onSetData(param1:Object):void
		{
			super.onSetData(param1);
			if (getNodeProp(this, "pressable") == false)
			{
				MenuUtils.setTintColor(this.m_view.tileSelect, MenuUtils.TINT_COLOR_GREY, false);
				MenuUtils.setTintColor(this.m_view.tileSelectPulsate, MenuUtils.TINT_COLOR_GREY, false);
				this.m_view.informationBg.visible = false;
			}
			this.m_enableInfo = true;
			if (param1.hasOwnProperty("enableinfo"))
			{
				this.m_enableInfo = param1.enableinfo;
			}
			this.m_alwaysDisplaySelectedState = false;
			if (param1.hasOwnProperty("alwaysdisplayselectedstate"))
			{
				this.m_alwaysDisplaySelectedState = param1.alwaysdisplayselectedstate;
			}
			if (this.m_alwaysDisplaySelectedState)
			{
				this.m_view.tileIcon.alpha = 1;
				this.m_view.tileIcon.y = this.TILEICON_Y_END_POS;
				if (this.m_enableInfo)
				{
					this.m_view.informationBg.visible = true;
					this.m_view.informationBg.alpha = 1;
					this.m_view.info.alpha = 1;
					this.m_view.header.y = this.HEADER_Y_END_POS;
					this.m_view.title.scaleX = this.m_view.title.scaleY = this.TITLE_END_SCALE;
					this.m_view.title.y = this.TITLE_Y_END_POS;
				}
			}
			this.setupTextFields(param1.header, param1.title);
			if (this.m_enableInfo)
			{
				this.setupInfo(param1.timeheader, param1.timevalue, param1.completionheader, param1.completionvalue);
			}
			else
			{
				this.setupInfo("", "", "", "");
			}
			if (param1.image)
			{
				this.loadImage(param1.image);
			}
			if (param1.availability)
			{
				setAvailablity(this.m_view, param1, "small");
			}
		}
		
		private function setupTextFields(param1:String, param2:String):void
		{
			this.m_textObj.header = param1;
			this.m_textObj.title = param2;
			MenuUtils.setupText(this.m_view.header, param1, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
			MenuUtils.setupText(this.m_view.title, param2, 50, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorGreyUltraLight);
			MenuUtils.truncateTextfield(this.m_view.header, 1);
			MenuUtils.truncateTextfield(this.m_view.title, 1);
		}
		
		private function callTextTicker(param1:Boolean):void
		{
			if (!this.m_textTicker)
			{
				this.m_textTicker = new textTicker();
			}
			if (param1)
			{
				this.m_textTicker.startTextTicker(this.m_view.title, this.m_textObj.title);
			}
			else
			{
				this.m_textTicker.stopTextTicker(this.m_view.title, this.m_textObj.title);
				MenuUtils.truncateTextfield(this.m_view.title, 1, MenuConstants.FontColorWhite);
			}
		}
		
		private function changeTextColor(param1:uint):void
		{
			this.m_view.header.textColor = param1;
			this.m_view.title.textColor = param1;
		}
		
		private function showText(param1:Boolean):void
		{
			this.m_view.header.visible = param1;
			this.m_view.title.visible = param1;
		}
		
		private function setupInfo(param1:String, param2:String, param3:String, param4:String):void
		{
			MenuUtils.setupText(this.m_view.info.completionheader, param3, 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
			MenuUtils.setupText(this.m_view.info.completionvalue, param4, 16, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorGreyUltraLight);
			MenuUtils.truncateTextfield(this.m_view.info.completionheader, 1);
			MenuUtils.truncateTextfield(this.m_view.info.completionvalue, 1);
		}
		
		private function loadImage(param1:String):void
		{
			var imagePath:String = param1;
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
				if (m_view.image.width < MenuConstants.MenuTileTallWidth)
				{
					m_view.image.width = MenuConstants.MenuTileTallWidth;
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
			super.handleSelectionChange();
			Animate.complete(this.m_view.tileSelect);
			MenuUtils.pulsate(this.m_view.tileSelectPulsate, false);
			Animate.complete(this.m_view.informationBg);
			Animate.complete(this.m_view.tileIcon);
			Animate.complete(this.m_view.info);
			Animate.complete(this.m_view.header);
			Animate.complete(this.m_view.title);
			if (m_loading)
			{
				return;
			}
			if (m_isSelected)
			{
				Animate.legacyTo(this.m_view.tileSelect, MenuConstants.HiliteTime, {"alpha": 1}, Animate.Linear);
				MenuUtils.pulsate(this.m_view.tileSelectPulsate, true);
				MenuUtils.setColorFilter(this.m_view.image);
				if (!this.m_alwaysDisplaySelectedState)
				{
					Animate.legacyTo(this.m_view.tileIcon, MenuConstants.HiliteTime, {"alpha": 1, "y": this.TILEICON_Y_END_POS}, Animate.Linear);
					if (this.m_enableInfo)
					{
						Animate.legacyTo(this.m_view.informationBg, MenuConstants.HiliteTime, {"alpha": 1}, Animate.Linear);
						Animate.legacyTo(this.m_view.info, MenuConstants.HiliteTime, {"alpha": 1}, Animate.Linear);
					}
				}
				Animate.legacyTo(this.m_view.header, MenuConstants.HiliteTime, {"y": this.HEADER_Y_END_POS}, Animate.Linear);
				Animate.legacyTo(this.m_view.title, MenuConstants.HiliteTime, {"scaleX": this.TITLE_END_SCALE, "scaleY": this.TITLE_END_SCALE, "y": this.TITLE_Y_END_POS}, Animate.Linear);
			}
			else
			{
				this.m_view.tileSelect.alpha = 0;
				MenuUtils.pulsate(this.m_view.tileSelectPulsate, false);
				MenuUtils.setColorFilter(this.m_view.image, "desaturated");
				if (!this.m_alwaysDisplaySelectedState)
				{
					this.m_view.tileIcon.alpha = 0;
					this.m_view.tileIcon.y = this.TILEICON_Y_START_POS;
					if (this.m_enableInfo)
					{
						this.m_view.informationBg.alpha = 0;
						this.m_view.info.alpha = 0;
					}
				}
				this.m_view.header.y = this.HEADER_Y_START_POS;
				this.m_view.title.y = this.TITLE_Y_START_POS;
				this.m_view.title.scaleX = this.m_view.title.scaleY = this.TITLE_START_SCALE;
			}
		}
		
		override public function onUnregister():void
		{
			if (this.m_view)
			{
				super.onUnregister();
				this.completeAnimations();
				if (this.m_textTicker)
				{
					this.m_textTicker.stopTextTicker(this.m_view.title, this.m_textObj.title);
					this.m_textTicker = null;
				}
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
			Animate.complete(this.m_view.tileSelect);
			MenuUtils.pulsate(this.m_view.tileSelectPulsate, false);
			Animate.complete(this.m_view.informationBg);
			Animate.complete(this.m_view.tileIcon);
			Animate.complete(this.m_view.info);
			if (m_infoIndicator != null)
			{
				Animate.complete(m_infoIndicator);
			}
			Animate.complete(this.m_view.header);
			Animate.complete(this.m_view.title);
		}
	}
}
