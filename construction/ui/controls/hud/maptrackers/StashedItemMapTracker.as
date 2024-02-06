package hud.maptrackers
{
	import common.Localization;
	
	public class StashedItemMapTracker extends LevelCheckedMapTracker
	{
		
		public function StashedItemMapTracker()
		{
			super();
			this.setupStashedItemMapTracker();
		}
		
		private function setupStashedItemMapTracker():void
		{
			var _loc1_:minimapBlipStashedItemView = new minimapBlipStashedItemView();
			setMainView(_loc1_);
		}
		
		override public function getTextForLegend():String
		{
			return Localization.get("UI_MAP_LEGEND_LABEL_HIDDEN_STASH");
		}
	}
}
