package hud.maptrackers
{
	import common.Localization;
	
	public class EvergreenStashMapTracker extends LevelCheckedMapTracker
	{
		
		private var m_view:minimapBlipEvergreenStashView;
		
		public function EvergreenStashMapTracker()
		{
			super();
			this.setupEvergreenStashMapTracker();
		}
		
		private function setupEvergreenStashMapTracker():void
		{
			this.m_view = new minimapBlipEvergreenStashView();
			setMainView(this.m_view);
		}
		
		override public function getTextForLegend():String
		{
			return Localization.get("UI_MAP_LEGEND_LABEL_EVERGREEN_STASH");
		}
	}
}
