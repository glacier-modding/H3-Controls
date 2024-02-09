package menu3.basic
{
	import common.Animate;
	import common.CommonUtils;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.display.Sprite;
	import menu3.containers.CollapsableListContainer;
	
	public dynamic class OptionsListElementSmall extends CollapsableListContainer
	{
		
		private var m_view:OptionsListElementSmallView;
		
		private var m_textTickerUtil:TextTickerUtil;
		
		private var m_pressable:Boolean = true;
		
		private var m_selectable:Boolean = true;
		
		private var m_isTextScrollingEnabled:Boolean;
		
		private var m_solidStyle:Boolean = false;
		
		protected const STATE_DEFAULT:int = 0;
		
		protected const STATE_SELECTED:int = 1;
		
		protected const STATE_GROUP_SELECTED:int = 2;
		
		protected const STATE_HOVER:int = 3;
		
		public function OptionsListElementSmall(param1:Object)
		{
			this.m_textTickerUtil = new TextTickerUtil();
			super(param1);
			this.m_view = new OptionsListElementSmallView();
			this.m_view.tileSelect.alpha = 0;
			this.m_view.tileDarkBg.alpha = 0;
			this.m_view.tileBg.alpha = 0;
			addChild(this.m_view);
		}
		
		override public function onSetData(param1:Object):void
		{
			super.onSetData(param1);
			this.m_pressable = getNodeProp(this, "pressable");
			this.m_selectable = getNodeProp(this, "selectable");
			this.m_solidStyle = param1.solidstyle === true;
			this.setupTextField(param1.title);
			this.m_isTextScrollingEnabled = !!param1.force_scroll ? true : false;
			var _loc2_:int = m_isSelected ? this.STATE_SELECTED : this.STATE_DEFAULT;
			this.setSelectedAnimationState(_loc2_);
			if (this.m_selectable == false)
			{
				this.changeTextColor(MenuConstants.COLOR_GREY);
				if (this.m_solidStyle)
				{
					MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_MENU_SOLID_BACKGROUND, false);
					MenuUtils.removeDropShadowFilter(this.m_view.title);
					this.m_view.tileSelect.alpha = 1;
				}
				else
				{
					MenuUtils.addDropShadowFilter(this.m_view.title);
					this.m_view.tileSelect.alpha = 0;
				}
				if (this.m_isTextScrollingEnabled)
				{
					this.callTextTicker(true);
				}
			}
			else
			{
				setItemSelected(m_isSelected);
			}
		}
		
		override public function getView():Sprite
		{
			return this.m_view.tileBg;
		}
		
		private function setupTextField(param1:String):void
		{
			MenuUtils.setupTextUpper(this.m_view.title, param1, 26, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			CommonUtils.changeFontToGlobalIfNeeded(this.m_view.title);
			this.m_textTickerUtil.addTextTicker(this.m_view.title, this.m_view.title.htmlText);
			MenuUtils.truncateTextfield(this.m_view.title, 1, null, CommonUtils.changeFontToGlobalIfNeeded(this.m_view.title));
		}
		
		private function changeTextColor(param1:int):void
		{
			this.m_view.title.textColor = param1;
		}
		
		private function callTextTicker(param1:Boolean):void
		{
			this.m_textTickerUtil.callTextTicker(param1, this.m_view.title.textColor);
		}
		
		override public function addChild2(param1:Sprite, param2:int = -1):void
		{
			super.addChild2(param1, param2);
			if (getNodeProp(param1, "col") === undefined)
			{
				if (this.getData().direction != "horizontal" && this.getData().direction != "horizontalWrap")
				{
					param1.x = 32;
				}
			}
		}
		
		public function setItemHover(param1:Boolean):void
		{
			if (m_isSelected || m_isGroupSelected)
			{
				return;
			}
			var _loc2_:int = param1 ? this.STATE_HOVER : this.STATE_DEFAULT;
			this.setSelectedAnimationState(_loc2_);
		}
		
		override protected function handleSelectionChange():void
		{
			var _loc1_:int = this.STATE_DEFAULT;
			if (m_isSelected)
			{
				_loc1_ = this.STATE_SELECTED;
			}
			else if (m_isGroupSelected)
			{
				_loc1_ = this.STATE_GROUP_SELECTED;
			}
			this.setSelectedAnimationState(_loc1_);
		}
		
		protected function setSelectedAnimationState(param1:int):void
		{
			Animate.kill(this.m_view.tileSelect);
			if (m_loading)
			{
				return;
			}
			if (this.m_selectable == false)
			{
				return;
			}
			if (param1 == this.STATE_SELECTED)
			{
				if (this.m_pressable)
				{
					this.changeTextColor(MenuConstants.COLOR_WHITE);
					MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_RED, true, MenuConstants.MenuElementSelectedAlpha);
				}
				else
				{
					this.changeTextColor(MenuConstants.COLOR_GREY);
					MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_MENU_TABS_BACKGROUND, true, MenuConstants.MenuElementBackgroundAlpha);
				}
				MenuUtils.removeDropShadowFilter(this.m_view.title);
				this.callTextTicker(true);
			}
			else if (param1 == this.STATE_GROUP_SELECTED)
			{
				this.changeTextColor(MenuConstants.COLOR_GREY);
				MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_MENU_SOLID_BACKGROUND, true, 0);
				MenuUtils.removeDropShadowFilter(this.m_view.title);
				this.callTextTicker(true);
			}
			else if (param1 == this.STATE_HOVER)
			{
				if (this.m_pressable)
				{
					this.changeTextColor(MenuConstants.COLOR_WHITE);
					MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_RED, true, MenuConstants.MenuElementSelectedAlpha);
				}
				else
				{
					this.changeTextColor(MenuConstants.COLOR_GREY);
					MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_MENU_TABS_BACKGROUND, true, MenuConstants.MenuElementBackgroundAlpha);
				}
				MenuUtils.removeDropShadowFilter(this.m_view.title);
				this.callTextTicker(true);
			}
			else if (this.m_isTextScrollingEnabled)
			{
				this.callTextTicker(this.m_isTextScrollingEnabled);
			}
			else
			{
				if (this.m_solidStyle)
				{
					this.changeTextColor(MenuConstants.COLOR_WHITE);
					MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_MENU_SOLID_BACKGROUND, false);
					MenuUtils.removeDropShadowFilter(this.m_view.title);
					this.m_view.tileSelect.alpha = 1;
				}
				else
				{
					this.changeTextColor(MenuConstants.COLOR_WHITE);
					MenuUtils.addDropShadowFilter(this.m_view.title);
					this.m_view.tileSelect.alpha = 0;
				}
				this.callTextTicker(false);
			}
		}
		
		override public function onUnregister():void
		{
			super.onUnregister();
			if (this.m_view)
			{
				Animate.kill(this.m_view.tileSelect);
				this.m_textTickerUtil.onUnregister();
				this.m_textTickerUtil = null;
				removeChild(this.m_view);
				this.m_view = null;
			}
		}
	}
}
