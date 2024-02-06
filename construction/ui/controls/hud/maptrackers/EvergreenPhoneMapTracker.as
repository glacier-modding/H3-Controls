package hud.maptrackers
{
	import common.Localization;
	
	public class EvergreenPhoneMapTracker extends LevelCheckedMapTracker
	{
		
		private var m_view:minimapBlipEvergreenPhoneView;
		
		public function EvergreenPhoneMapTracker()
		{
			super();
			this.setupEvergreenPhoneMapTracker();
		}
		
		private function setupEvergreenPhoneMapTracker():void
		{
			this.m_view = new minimapBlipEvergreenPhoneView();
			setMainView(this.m_view);
		}
		
		override public function getTextForLegend():String
		{
			return Localization.get("UI_MAP_LEGEND_LABEL_EVERGREEN_PHONE");
		}
	}
}
