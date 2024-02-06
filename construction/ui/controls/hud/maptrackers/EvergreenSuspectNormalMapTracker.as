package hud.maptrackers
{
	import common.Localization;
	
	public class EvergreenSuspectNormalMapTracker extends LevelCheckedMapTracker
	{
		
		private var m_view:minimapBlipEvergreenSuspectNormalView;
		
		public function EvergreenSuspectNormalMapTracker()
		{
			super();
			this.setupEvergreenSuspectNormalMapTracker();
		}
		
		private function setupEvergreenSuspectNormalMapTracker():void
		{
			this.m_view = new minimapBlipEvergreenSuspectNormalView();
			setMainView(this.m_view);
		}
		
		override public function getTextForLegend():String
		{
			return Localization.get("UI_MAP_LEGEND_LABEL_EVERGREEN_SUSPECT");
		}
	}
}
