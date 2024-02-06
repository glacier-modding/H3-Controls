package basic
{
	import common.Animate;
	import common.BaseControl;
	import common.CommonUtils;
	import common.Log;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	
	public class GameChatIndicator extends BaseControl
	{
		
		private var m_view:GameChatIndicatorView;
		
		private var m_aStatusArray:Array;
		
		public function GameChatIndicator()
		{
			this.m_aStatusArray = new Array("TALKING", "NON_TALKING", "MUTED", "RESTRICTED");
			super();
			this.m_view = new GameChatIndicatorView();
			this.m_view.bg.alpha = 0.6;
			addChild(this.m_view);
			this.m_view.visible = false;
		}
		
		public function onSetData(param1:Object):void
		{
			Log.debugData(this, param1);
			this.hideGameChat();
			if (Boolean(param1) && param1 != null)
			{
				this.showGameChat(param1.name, param1.status);
			}
		}
		
		private function showGameChat(param1:String, param2:String):void
		{
			MenuUtils.setupText(this.m_view.profilename, param1, 22, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGrey);
			CommonUtils.changeFontToGlobalIfNeeded(this.m_view.profilename);
			MenuUtils.truncateTextfieldWithCharLimit(this.m_view.profilename, 1, MenuConstants.PLAYERNAME_MIN_CHAR_COUNT);
			MenuUtils.shrinkTextToFit(this.m_view.profilename, this.m_view.profilename.width, -1);
			this.m_view.bg.width = 45 + this.m_view.profilename.textWidth + 5;
			MenuUtils.removeTint(this.m_view.icon);
			this.m_view.icon.gotoAndStop(param2);
			switch (param2)
			{
			case "TALKING": 
				this.m_view.visible = true;
				break;
			case "NON_TALKING": 
				this.m_view.visible = true;
				Animate.delay(this, 2, this.hideGameChat);
				break;
			case "MUTED": 
				MenuUtils.setTintColor(this.m_view.icon, MenuUtils.TINT_COLOR_COLOR_GREY_GOTY, false);
				this.m_view.visible = true;
				Animate.delay(this, 2, this.hideGameChat);
				break;
			case "RESTRICTED": 
				MenuUtils.setTintColor(this.m_view.icon, MenuUtils.TINT_COLOR_REAL_RED, false);
				this.m_view.visible = true;
				Animate.delay(this, 2, this.hideGameChat);
				break;
			default: 
				this.hideGameChat();
			}
		}
		
		private function hideGameChat():void
		{
			Animate.kill(this);
			this.m_view.visible = false;
		}
		
		public function showTestChat():void
		{
			this.showGameChat("Profile_Name_Test_String", this.m_aStatusArray[MenuUtils.getRandomInRange(0, 3)]);
		}
	}
}
