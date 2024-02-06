package menu3.basic
{
	import common.Animate;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import common.menu.textTicker;
	import menu3.MenuElementTileBase;
	import menu3.MenuImageLoader;
	
	public dynamic class InfoTile extends MenuElementTileBase
	{
		
		protected var m_view:InfoTileView;
		
		private var m_loader:MenuImageLoader;
		
		private var m_textObj:Object;
		
		private var m_textTicker:textTicker;
		
		private var m_alwaysTicker:Boolean = false;
		
		private var m_imagePath:String = null;
		
		public function InfoTile(param1:Object)
		{
			this.m_textObj = new Object();
			super(param1);
			this.m_view = this.createView();
			this.m_view.tileSelect.alpha = 0;
			this.m_view.tileSelectPulsate.alpha = 0;
			this.m_view.tileBg.alpha = 1;
			this.m_view.tileDarkBg.visible = false;
			this.m_view.dropShadow.alpha = 0;
			addChild(this.m_view);
		}
		
		protected function createView():*
		{
			return new InfoTileView();
		}
		
		override public function onSetData(param1:Object):void
		{
			super.onSetData(param1);
			if (getNodeProp(this, "pressable") == false)
			{
				MenuUtils.setTintColor(this.m_view.tileSelect, MenuUtils.TINT_COLOR_GREY, false);
				MenuUtils.setTintColor(this.m_view.tileSelectPulsate, MenuUtils.TINT_COLOR_GREY, false);
			}
			this.setupTextFields(param1.title, param1.description);
			this.m_alwaysTicker = param1.alwaysTicker === true;
			if (this.m_alwaysTicker)
			{
				this.callTextTicker(true);
			}
			this.handleSelectionChange();
		}
		
		private function setupTextFields(param1:String, param2:String):void
		{
			MenuUtils.setupTextUpper(this.m_view.title, param1, 30, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorGreyUltraDark);
			this.m_textObj.title = this.m_view.title.htmlText;
			MenuUtils.setupText(this.m_view.description, param2, 22, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorGreyUltraDark);
			MenuUtils.truncateTextfield(this.m_view.title, 1, MenuConstants.FontColorGreyUltraDark);
			MenuUtils.truncateHTMLField(this.m_view.description, this.m_view.description.htmlText);
		}
		
		private function callTextTicker(param1:Boolean):void
		{
			if (!this.m_textTicker)
			{
				this.m_textTicker = new textTicker();
			}
			if (param1)
			{
				this.m_textTicker.startTextTickerHtml(this.m_view.title, this.m_textObj.title);
			}
			else
			{
				this.m_textTicker.stopTextTicker(this.m_view.title, this.m_textObj.title);
				MenuUtils.truncateTextfield(this.m_view.title, 1, MenuConstants.FontColorGreyUltraDark);
			}
		}
		
		override protected function handleSelectionChange():void
		{
			super.handleSelectionChange();
			Animate.complete(this.m_view.tileSelect);
			MenuUtils.pulsate(this.m_view.tileSelectPulsate, false);
			if (m_loading)
			{
				return;
			}
			if (m_isSelected)
			{
				setPopOutScale(this.m_view, true);
				Animate.to(this.m_view.dropShadow, 0.3, 0, {"alpha": 1}, Animate.ExpoOut);
				Animate.legacyTo(this.m_view.tileSelect, MenuConstants.HiliteTime, {"alpha": 1}, Animate.Linear);
				MenuUtils.pulsate(this.m_view.tileSelectPulsate, true);
			}
			else
			{
				setPopOutScale(this.m_view, false);
				Animate.kill(this.m_view.dropShadow);
				this.m_view.dropShadow.alpha = 0;
				this.m_view.tileSelect.alpha = 0;
				MenuUtils.pulsate(this.m_view.tileSelectPulsate, false);
			}
			if (!this.m_alwaysTicker)
			{
				this.callTextTicker(m_isSelected);
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
				removeChild(this.m_view);
				this.m_view = null;
			}
		}
		
		private function completeAnimations():void
		{
			Animate.complete(this.m_view.tileSelect);
			MenuUtils.pulsate(this.m_view.tileSelectPulsate, false);
		}
	}
}
