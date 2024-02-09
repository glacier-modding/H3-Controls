package hud.maptrackers
{
	
	public class StairUpMapTracker extends BaseMapTracker
	{
		
		private var m_view:minimapBlipStairUpView;
		
		public function StairUpMapTracker()
		{
			super();
			this.setupStairUpMapTracker();
		}
		
		private function setupStairUpMapTracker():void
		{
			this.m_view = new minimapBlipStairUpView();
			setMainView(this.m_view);
		}
	}
}
