package hud.maptrackers
{
	
	public class StairDownMapTracker extends BaseMapTracker
	{
		
		private var m_view:minimapBlipStairDownView;
		
		public function StairDownMapTracker()
		{
			super();
			this.setupStairDownMapTracker();
		}
		
		private function setupStairDownMapTracker():void
		{
			this.m_view = new minimapBlipStairDownView();
			setMainView(this.m_view);
		}
	}
}
