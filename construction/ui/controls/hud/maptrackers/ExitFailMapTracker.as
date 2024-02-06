package hud.maptrackers
{
	import common.Localization;
	
	public class ExitFailMapTracker extends LevelCheckedMapTracker
	{
		
		private var m_view:minimapBlipExitFailView;
		
		public function ExitFailMapTracker()
		{
			super();
			this.setupExitFailMapTracker();
		}
		
		private function setupExitFailMapTracker():void
		{
			this.m_view = new minimapBlipExitFailView();
			setMainView(this.m_view);
		}
		
		override public function getTextForLegend():String
		{
			return Localization.get("UI_EVERGREEN_MISSION_EXITLEVEL_FAILMISSION_PROMPT");
		}
	}
}
