package menu3
{
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	
	public dynamic class OpportunityItemDetailTile extends MenuElementBase
	{
		
		private var m_view:OpportunityItemDetailsView;
		
		public function OpportunityItemDetailTile(param1:Object)
		{
			super(param1);
		}
		
		override public function onSetData(param1:Object):void
		{
			if (this.m_view)
			{
				removeChild(this.m_view);
			}
			this.m_view = new OpportunityItemDetailsView();
			this.setupHeader(param1.header, param1.title, param1.icon, param1.completed);
			this.setupBody(param1.descriptiontitle, param1.description);
			addChild(this.m_view);
		}
		
		override public function onUnregister():void
		{
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
			MenuUtils.setupIcon(this.m_view.Header.icon, param3, MenuConstants.COLOR_WHITE, true, false);
		}
		
		private function setupBody(param1:String, param2:String):void
		{
			MenuUtils.setupText(this.m_view.Body.title, param1, 28, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			MenuUtils.setupText(this.m_view.Body.description, param2, 18, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
		}
	}
}
