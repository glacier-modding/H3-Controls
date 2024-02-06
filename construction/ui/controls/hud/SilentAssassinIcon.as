package hud
{
	import common.BaseControl;
	
	public class SilentAssassinIcon extends BaseControl
	{
		
		private var m_view:SAIconView;
		
		public function SilentAssassinIcon()
		{
			super();
			this.m_view = new SAIconView();
			this.m_view.bg.alpha = 0.5;
			this.m_view.gotoAndStop("active");
			addChild(this.m_view);
		}
		
		public function onSAStatusChanged(param1:Boolean, param2:Boolean):void
		{
			this.m_view.iconMc.gotoAndStop(param1 ? "inactive" : (param2 ? "recovery_recorded" : "active"));
		}
	}
}
