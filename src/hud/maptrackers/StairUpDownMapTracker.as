package hud.maptrackers
{
	
	public class StairUpDownMapTracker extends BaseMapTracker
	{
		
		private var m_view:minimapBlipStairUpDownView;
		
		public function StairUpDownMapTracker()
		{
			super();
			this.setupStairUpDownMapTracker();
		}
		
		private function setupStairUpDownMapTracker():void
		{
			this.m_view = new minimapBlipStairUpDownView();
			setMainView(this.m_view);
		}
	}
}
