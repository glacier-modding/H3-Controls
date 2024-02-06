package hud.maptrackers
{
	import common.Localization;
	
	public class EvergreenSuspectNotMapTracker extends LevelCheckedMapTracker
	{
		
		private var m_view:minimapBlipEvergreenSuspectNotView;
		
		public function EvergreenSuspectNotMapTracker()
		{
			super();
			this.setupEvergreenSuspectNotMapTracker();
		}
		
		private function setupEvergreenSuspectNotMapTracker():void
		{
			this.m_view = new minimapBlipEvergreenSuspectNotView();
			setMainView(this.m_view);
		}
		
		override public function getTextForLegend():String
		{
			return Localization.get("UI_MAP_LEGEND_LABEL_EVERGREEN_NOTSUSPECT");
		}
	}
}
