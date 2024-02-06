package hud.maptrackers
{
	import common.Localization;
	
	public class EvergreenMeetingSecretMapTracker extends LevelCheckedMapTracker
	{
		
		private var m_view:minimapBlipEvergreenMeetingSecretView;
		
		public function EvergreenMeetingSecretMapTracker()
		{
			super();
			this.setupEvergreenMeetingSecretMapTracker();
		}
		
		private function setupEvergreenMeetingSecretMapTracker():void
		{
			this.m_view = new minimapBlipEvergreenMeetingSecretView();
			setMainView(this.m_view);
		}
		
		override public function getTextForLegend():String
		{
			return Localization.get("UI_MAP_LEGEND_LABEL_EVERGREEN_MEETING_SECRET");
		}
	}
}
