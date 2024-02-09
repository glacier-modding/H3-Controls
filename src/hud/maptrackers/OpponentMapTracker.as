package hud.maptrackers
{
	import common.Localization;
	
	public class OpponentMapTracker extends LevelCheckedMapTracker
	{
		
		private var m_view:minimapBlipOpponentView;
		
		public function OpponentMapTracker()
		{
			super();
			this.setupOpponentMapTracker();
		}
		
		private function setupOpponentMapTracker():void
		{
			this.m_view = new minimapBlipOpponentView();
			setMainView(this.m_view);
		}
		
		override public function getTextForLegend():String
		{
			return Localization.get("UI_MAP_OPPONENT");
		}
	}
}
