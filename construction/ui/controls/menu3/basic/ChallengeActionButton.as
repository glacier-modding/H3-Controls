package menu3.basic
{
	import common.Animate;
	import common.MouseUtil;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import common.menu.textTicker;
	import menu3.MenuElementTileBase;
	
	public dynamic class ChallengeActionButton extends MenuElementTileBase
	{
		
		private var m_view:ChallengeActionButtonView;
		
		private var m_icon:String;
		
		protected const STATE_DEFAULT:int = 0;
		
		protected const STATE_SELECTED:int = 1;
		
		protected var m_textTicker:textTicker;
		
		protected var m_textObj:Object;
		
		protected const ICON_UNDEFINED:int = 0;
		
		protected const ICON_NORMAL:int = 1;
		
		protected const ICON_CROSSED_OUT:int = 2;
		
		private var m_iconCrossOutState:int = 0;
		
		public function ChallengeActionButton(param1:Object)
		{
			this.m_textObj = new Object();
			super(param1);
			this.m_view = new ChallengeActionButtonView();
			this.m_view.tileSelect.alpha = 0;
			this.m_view.tileSelectPulsate.alpha = 0;
			this.m_view.tileBg.alpha = 0;
			this.m_view.tileDarkBg.alpha = 0;
			this.m_view.crossOutIcon.visible = false;
			addChild(this.m_view);
			this.m_view.y = -6;
			m_mouseMode = MouseUtil.MODE_ONOVER_SELECT_ONUP_CLICK;
		}
		
		override public function onSetData(param1:Object):void
		{
			super.onSetData(param1);
			this.m_icon = param1.icon;
			MenuUtils.setupIcon(this.m_view.tileIcon, this.m_icon, MenuConstants.COLOR_WHITE, true, false);
			var _loc2_:String = param1.hasOwnProperty("title") ? String(param1.title) : "";
			var _loc3_:String = param1.hasOwnProperty("header") ? String(param1.header) : "";
			this.setupTextFields(_loc3_, _loc2_);
			var _loc4_:int = m_isSelected ? this.STATE_SELECTED : this.STATE_DEFAULT;
			this.setSelectedAnimationState(_loc4_);
			Animate.kill(this.m_view.crossOutIcon);
			Animate.kill(this.m_view.tileIcon);
			var _loc5_:* = this.m_iconCrossOutState != this.ICON_UNDEFINED;
			this.m_view.crossOutIcon.visible = param1.crossouticon;
			if (param1.crossouticon && _loc5_ && this.m_iconCrossOutState == this.ICON_NORMAL)
			{
				this.m_view.crossOutIcon.alpha = 0;
				this.m_view.crossOutIcon.rotation = -90;
				Animate.legacyTo(this.m_view.crossOutIcon, 0.3, {"alpha": 1, "rotation": 0}, Animate.ExpoOut);
				this.m_view.tileIcon.rotation = -90;
				Animate.legacyTo(this.m_view.tileIcon, 0.3, {"rotation": 0}, Animate.ExpoOut);
			}
			else if (!param1.crossouticon && _loc5_ && this.m_iconCrossOutState == this.ICON_CROSSED_OUT)
			{
				this.m_view.crossOutIcon.alpha = 1;
				Animate.legacyTo(this.m_view.crossOutIcon, 0.3, {"alpha": 0}, Animate.ExpoOut);
			}
			else
			{
				this.m_view.tileIcon.rotation = 0;
			}
			this.m_iconCrossOutState = !!param1.crossouticon ? this.ICON_CROSSED_OUT : this.ICON_NORMAL;
		}
		
		override public function onUnregister():void
		{
			if (this.m_view)
			{
				if (this.m_textTicker)
				{
					this.m_textTicker.stopTextTicker(this.m_view.title, this.m_textObj.title);
					this.m_textTicker = null;
				}
				removeChild(this.m_view);
				this.m_view = null;
			}
			super.onUnregister();
		}
		
		private function setupTextFields(param1:String, param2:String):void
		{
			MenuUtils.setupText(this.m_view.header, param1, 18, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
			MenuUtils.setupText(this.m_view.title, param2, 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			this.m_textObj.title = this.m_view.title.htmlText;
			MenuUtils.truncateTextfield(this.m_view.header, 1, null);
			MenuUtils.truncateTextfield(this.m_view.title, 1, null);
		}
		
		protected function callTextTicker(param1:Boolean):void
		{
			if (param1)
			{
				if (!this.m_textTicker)
				{
					this.m_textTicker = new textTicker();
				}
				this.m_textTicker.startTextTicker(this.m_view.title, this.m_textObj.title);
			}
			else if (this.m_textTicker)
			{
				this.m_textTicker.stopTextTicker(this.m_view.title, this.m_textObj.title);
				MenuUtils.truncateTextfield(this.m_view.title, 1, null);
			}
		}
		
		private function changeTextColor(param1:uint):void
		{
			this.m_view.header.textColor = param1;
			this.m_view.title.textColor = param1;
			if (!this.m_textTicker)
			{
				this.m_textTicker = new textTicker();
			}
			this.m_textTicker.setTextColor(param1);
		}
		
		override protected function handleSelectionChange():void
		{
			super.handleSelectionChange();
			var _loc1_:int = m_isSelected ? this.STATE_SELECTED : this.STATE_DEFAULT;
			this.setSelectedAnimationState(_loc1_);
		}
		
		protected function setSelectedAnimationState(param1:int):void
		{
			if (param1 == this.STATE_SELECTED)
			{
				MenuUtils.setColor(this.m_view.tileSelected, MenuConstants.COLOR_RED, true, MenuConstants.MenuElementSelectedAlpha);
				MenuUtils.setupIcon(this.m_view.tileIcon, this.m_icon, MenuConstants.COLOR_RED, false, true, MenuConstants.COLOR_WHITE, 1, 0, true);
				MenuUtils.setColor(this.m_view.crossOutIcon, MenuConstants.COLOR_RED, false);
				this.callTextTicker(true);
			}
			else
			{
				MenuUtils.setColor(this.m_view.tileSelected, MenuConstants.COLOR_MENU_TABS_BACKGROUND, true, MenuConstants.MenuElementBackgroundAlpha);
				MenuUtils.setupIcon(this.m_view.tileIcon, this.m_icon, MenuConstants.COLOR_WHITE, true, false);
				MenuUtils.setColor(this.m_view.crossOutIcon, MenuConstants.COLOR_WHITE, false);
				this.callTextTicker(false);
			}
		}
	}
}
