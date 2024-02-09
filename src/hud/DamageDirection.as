package hud
{
	import common.BaseControl;
	
	public class DamageDirection extends BaseControl
	{
		
		private var m_view:HitIndicator;
		
		public function DamageDirection()
		{
			super();
			this.m_view = new HitIndicator();
			addChild(this.m_view);
		}
	}
}
