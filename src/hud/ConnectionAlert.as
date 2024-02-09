package hud
{
	import common.BaseControl;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	
	public class ConnectionAlert extends BaseControl
	{
		
		private var m_view:ConnectionView;
		
		public function ConnectionAlert()
		{
			super();
			this.m_view = new ConnectionView();
			addChild(this.m_view);
		}
		
		public function onSetData(param1:Object):void
		{
			this.SetText(param1.string);
			this.m_view.typeIcon_mc.gotoAndStop(param1.type);
		}
		
		public function HideBar():void
		{
			this.m_view.gotoAndPlay("HIDE");
		}
		
		public function SetText(param1:String):void
		{
			this.m_view.visible = true;
			MenuUtils.setupText(this.m_view.label_mc.label_txt, param1, 20, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorGreyUltraLight);
			this.m_view.typeIcon_mc.gotoAndStop(1);
			this.m_view.gotoAndPlay("SHOW");
		}
	}
}
