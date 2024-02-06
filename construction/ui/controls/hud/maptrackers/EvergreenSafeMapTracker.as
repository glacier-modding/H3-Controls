package hud.maptrackers
{
	import common.Localization;
	
	public class EvergreenSafeMapTracker extends LevelCheckedMapTracker
	{
		
		private var m_view:minimapBlipEvergreenSafeView;
		
		public function EvergreenSafeMapTracker()
		{
			super();
			this.setupEvergreenSafeMapTracker();
		}
		
		private function setupEvergreenSafeMapTracker():void
		{
			this.m_view = new minimapBlipEvergreenSafeView();
			setMainView(this.m_view);
		}
		
		override public function getTextForLegend():String
		{
			return Localization.get("UI_MAP_LEGEND_LABEL_EVERGREEN_SAFE");
		}
	}
}
