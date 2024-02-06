package menu3
{
	import common.Log;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import common.menu.textTicker;
	
	public dynamic class QuestItemDetailTile extends MenuElementBase
	{
		
		private var m_view:QuestItemDetailsView;
		
		private var m_textObj:Object;
		
		private var m_textTickerTitle:textTicker;
		
		public function QuestItemDetailTile(param1:Object)
		{
			super(param1);
		}
		
		override public function onSetData(param1:Object):void
		{
			if (this.m_view)
			{
				removeChild(this.m_view);
			}
			Log.debugData(this, param1);
			this.m_view = new QuestItemDetailsView();
			this.m_textObj = {};
			this.setupHeader(param1.header, param1.title, param1.icon, param1.completed);
			this.setupBody(param1.description);
			addChild(this.m_view);
		}
		
		override public function onUnregister():void
		{
			if (this.m_textTickerTitle)
			{
				this.m_textTickerTitle.stopTextTicker(this.m_view.Header.title, this.m_textObj.title);
				this.m_textTickerTitle = null;
			}
			if (this.m_view)
			{
				removeChild(this.m_view);
				this.m_view = null;
			}
		}
		
		private function setupHeader(param1:String, param2:String, param3:String, param4:Boolean):void
		{
			MenuUtils.setupText(this.m_view.Header.header, param1, 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			MenuUtils.setupText(this.m_view.Header.title, param2, 60, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
			this.m_textObj.title = this.m_view.Header.title.htmlText;
			MenuUtils.setupIcon(this.m_view.Header.icon, param3, MenuConstants.COLOR_WHITE, true, false);
			this.callTextTicker(true);
		}
		
		private function setupBody(param1:String):void
		{
			var _loc2_:int = 18;
			if (ControlsMain.getDisplaySize() == ControlsMain.DISPLAY_SIZE_SMALL)
			{
				_loc2_ = 22;
				this.m_view.Body.description.width = 1000;
			}
			MenuUtils.setupText(this.m_view.Body.description, param1, _loc2_, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
		}
		
		private function callTextTicker(param1:Boolean):void
		{
			if (!this.m_textTickerTitle)
			{
				this.m_textTickerTitle = new textTicker();
			}
			if (param1)
			{
				this.m_textTickerTitle.startTextTicker(this.m_view.Header.title, this.m_textObj.title);
			}
			else
			{
				this.m_textTickerTitle.stopTextTicker(this.m_view.Header.title, this.m_textObj.title);
				MenuUtils.truncateTextfield(this.m_view.Header.title, 1, MenuConstants.FontColorWhite);
			}
		}
	}
}
