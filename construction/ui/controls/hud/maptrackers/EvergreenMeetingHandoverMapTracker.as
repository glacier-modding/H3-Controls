package hud.maptrackers
{
	import common.Localization;
	
	public class EvergreenMeetingHandoverMapTracker extends LevelCheckedMapTracker
	{
		
		private var m_view:minimapBlipEvergreenMeetingHandoverView;
		
		public function EvergreenMeetingHandoverMapTracker()
		{
			super();
			this.setupEvergreenMeetingHandoverMapTracker();
		}
		
		private function setupEvergreenMeetingHandoverMapTracker():void
		{
			this.m_view = new minimapBlipEvergreenMeetingHandoverView();
			setMainView(this.m_view);
		}
		
		override public function getTextForLegend():String
		{
			return Localization.get("UI_MAP_LEGEND_LABEL_EVERGREEN_MEETING_HANDOVER");
		}
	}
}
