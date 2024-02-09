package hud.maptrackers
{
	
	public class NorthIndicatorMapTracker extends BaseMapTracker
	{
		
		private var m_view:minimapBlipNorthView;
		
		public function NorthIndicatorMapTracker()
		{
			super();
			this.setupNorthIndicatorMapTracker();
		}
		
		private function setupNorthIndicatorMapTracker():void
		{
			this.m_view = new minimapBlipNorthView();
			setMainView(this.m_view);
		}
	}
}
