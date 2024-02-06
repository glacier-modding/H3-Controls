package menu3
{
	import common.Animate;
	import common.CommonUtils;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import common.menu.textTicker;
	import flash.text.TextField;
	
	public dynamic class ButtonTileBase extends MenuElementTileBase
	{
		
		protected const STATE_DEFAULT:int = 0;
		
		protected const STATE_SELECTED:int = 1;
		
		protected const STATE_NOT_SELECTABLE:int = 2;
		
		protected const STATE_DISABLED:int = 3;
		
		protected const SUBSTATE_DEFAULT:String = "default";
		
		protected const SUBSTATE_IN_PROGRESS:String = "inprogress";
		
		protected const SUBSTATE_DONE:String = "done";
		
		protected var m_view:Object;
		
		protected var m_iconName:String;
		
		protected var m_GroupSelected:Boolean = false;
		
		protected var m_textTicker:textTicker;
		
		protected var m_textObj:Object;
		
		protected var m_infoText:String;
		
		protected var m_currentState:int = 0;
		
		protected var m_currentSubState:String = "default";
		
		private var m_title:String = "";
		
		private var m_titleChanged:Boolean = false;
		
		public function ButtonTileBase(param1:Object)
		{
			this.m_textObj = new Object();
			super(param1);
			this.m_iconName = param1.icon;
		}
		
		protected function initView():void
		{
			this.m_view.tileBg.alpha = 0;
			this.m_view.tileDarkBg.alpha = 0;
			this.m_view.dropShadow.alpha = 0;
		}
		
		override public function onSetData(param1:Object):void
		{
			var _loc2_:TextField = null;
			var _loc3_:String = null;
			var _loc4_:String = null;
			super.onSetData(param1);
			this.m_currentSubState = this.SUBSTATE_DEFAULT;
			if (param1.substate != null)
			{
				this.m_currentSubState = param1.substate;
			}
			this.m_infoText = "";
			if (param1.infoTitle != null)
			{
				this.m_infoText = param1.infoTitle;
			}
			MenuUtils.setupTextUpper(this.m_view.information, this.m_infoText, 22, MenuConstants.FONT_TYPE_MEDIUM);
			MenuUtils.truncateHTMLField(this.m_view.information, this.m_view.information.htmlText);
			if (param1.infoPlayer != null)
			{
				_loc2_ = new TextField();
				_loc2_.width = this.m_view.information.width;
				_loc2_.height = this.m_view.information.height;
				_loc3_ = String(param1.infoPlayer);
				MenuUtils.setupTextUpper(_loc2_, _loc3_, 20, MenuConstants.FONT_TYPE_NORMAL);
				CommonUtils.changeFontToGlobalIfNeeded(_loc2_);
				MenuUtils.truncateTextfieldWithCharLimit(_loc2_, 1, MenuConstants.PLAYERNAME_MIN_CHAR_COUNT);
				MenuUtils.shrinkTextToFit(_loc2_, _loc2_.width, -1);
				_loc4_ = _loc2_.htmlText;
				if (this.m_infoText.length > 0)
				{
					_loc4_ = this.m_view.information.htmlText + _loc4_;
				}
				this.m_view.information.htmlText = _loc4_;
			}
			this.m_currentState = m_isSelected ? this.STATE_SELECTED : this.STATE_DEFAULT;
			if (param1.hasOwnProperty("disabled") && param1.disabled == true)
			{
				this.m_currentState = this.STATE_DISABLED;
			}
			else if (getNodeProp(this, "selectable") == false)
			{
				this.m_currentState = this.STATE_NOT_SELECTABLE;
			}
			MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_MENU_BUTTON_TILE_DESELECTED, true, 1);
		}
		
		override protected function handleSelectionChange():void
		{
			if (this.m_currentState == this.STATE_DISABLED)
			{
				return;
			}
			this.m_currentState = m_isSelected ? this.STATE_SELECTED : this.STATE_DEFAULT;
			this.updateState();
		}
		
		public function setItemGroupSelected(param1:Boolean):void
		{
			if (this.m_GroupSelected != param1)
			{
				this.m_GroupSelected = param1;
				this.updateState();
			}
		}
		
		override public function setItemSelected(param1:Boolean):void
		{
			if (m_isSelected == param1)
			{
				return;
			}
			m_isSelected = param1;
			this.handleSelectionChange();
		}
		
		protected function updateState():void
		{
			this.setSelectedAnimationState(this.m_view, this.m_currentState);
		}
		
		protected function changeTextColor(param1:int):void
		{
			if (!m_isSelected)
			{
				if (this.m_currentSubState == this.SUBSTATE_IN_PROGRESS)
				{
					param1 = this.m_GroupSelected ? MenuConstants.COLOR_RED : MenuConstants.COLOR_RED;
				}
				else if (this.m_currentSubState == this.SUBSTATE_DONE)
				{
					param1 = MenuConstants.COLOR_GREEN;
				}
			}
			this.m_view.header.textColor = MenuConstants.COLOR_WHITE;
			this.m_view.title.textColor = param1;
			this.m_view.information.textColor = param1;
			if (this.m_textTicker)
			{
				this.m_textTicker.setTextColor(param1);
			}
		}
		
		protected function completeAnimations():void
		{
			Animate.kill(this.m_view.dropShadow);
		}
		
		protected function setSelectedAnimationState(param1:Object, param2:int):void
		{
			this.completeAnimations();
			if (m_loading)
			{
				return;
			}
			this.callTextTicker(m_isSelected);
			if (param2 == this.STATE_NOT_SELECTABLE || param2 == this.STATE_DISABLED)
			{
				setPopOutScale(param1, false);
				param1.dropShadow.alpha = 0;
				MenuUtils.setupIcon(param1.tileIcon, this.m_iconName, MenuConstants.COLOR_GREY, true, false);
				this.changeTextColor(param2 == this.STATE_DISABLED ? MenuConstants.COLOR_GREY : MenuConstants.COLOR_WHITE);
				if (param1.buttonnumber)
				{
					MenuUtils.setColor(param1.buttonnumber, MenuConstants.COLOR_GREY, false);
				}
			}
			else if (param2 == this.STATE_SELECTED)
			{
				setPopOutScale(param1, true);
				Animate.to(param1.dropShadow, 0.3, 0, {"alpha": 1}, Animate.ExpoOut);
				this.changeTextColor(MenuConstants.COLOR_WHITE);
				MenuUtils.setColor(param1.tileSelect, MenuConstants.COLOR_RED, true, 1);
				MenuUtils.setupIcon(param1.tileIcon, this.m_iconName, MenuConstants.COLOR_RED, false, true, MenuConstants.COLOR_WHITE, 1, 0, true);
				if (param1.buttonnumber)
				{
					MenuUtils.setColor(param1.buttonnumber, MenuConstants.COLOR_WHITE, false);
				}
			}
			else
			{
				setPopOutScale(param1, false);
				param1.dropShadow.alpha = 0;
				if (this.m_GroupSelected)
				{
					MenuUtils.setColor(param1.tileSelect, MenuConstants.COLOR_MENU_SOLID_BACKGROUND, false);
					MenuUtils.setupIcon(param1.tileIcon, this.m_iconName, MenuConstants.COLOR_MENU_SOLID_BACKGROUND, false, true, MenuConstants.COLOR_GREY);
					if (param1.buttonnumber)
					{
						MenuUtils.setColor(param1.buttonnumber, MenuConstants.COLOR_GREY, false);
					}
					this.changeTextColor(MenuConstants.COLOR_GREY);
				}
				else
				{
					this.changeTextColor(MenuConstants.COLOR_WHITE);
					MenuUtils.setColor(param1.tileSelect, MenuConstants.COLOR_MENU_BUTTON_TILE_DESELECTED, true, 1);
					MenuUtils.setupIcon(param1.tileIcon, this.m_iconName, MenuConstants.COLOR_RED, false, true, MenuConstants.COLOR_WHITE, 1, 0, true);
					if (param1.buttonnumber)
					{
						MenuUtils.setColor(param1.buttonnumber, MenuConstants.COLOR_WHITE, false);
					}
				}
			}
		}
		
		protected function callTextTicker(param1:Boolean):void
		{
			if (!this.m_textTicker)
			{
				this.m_textTicker = new textTicker();
			}
			if (param1)
			{
				if (this.m_titleChanged || !this.m_textTicker.isRunning())
				{
					this.m_textTicker.startTextTicker(this.m_view.title, this.m_textObj.title);
				}
			}
			else
			{
				this.m_textTicker.stopTextTicker(this.m_view.title, this.m_textObj.title);
				MenuUtils.truncateTextfield(this.m_view.title, 1, null);
			}
			this.m_titleChanged = false;
		}
		
		protected function setupTextFields(param1:String, param2:String):void
		{
			MenuUtils.setupTextUpper(this.m_view.header, param1, 14, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorGreyUltraLight);
			this.m_textObj.header = this.m_view.header.htmlText;
			MenuUtils.truncateTextfield(this.m_view.header, 1, null);
			if (this.m_title != param2)
			{
				this.m_title = param2;
				this.m_titleChanged = true;
				MenuUtils.setupTextUpper(this.m_view.title, param2, 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
				this.m_textObj.title = this.m_view.title.htmlText;
				MenuUtils.truncateTextfield(this.m_view.title, 1, null);
			}
		}
		
		protected function showText(param1:Boolean):void
		{
			this.m_view.header.visible = param1;
			this.m_view.title.visible = param1;
		}
		
		override public function onUnregister():void
		{
			if (this.m_textTicker)
			{
				this.m_textTicker.stopTextTicker(this.m_view.title, this.m_textObj.title);
				this.m_textTicker = null;
			}
			super.onUnregister();
		}
	}
}
