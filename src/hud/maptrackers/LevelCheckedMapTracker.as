package hud.maptrackers
{
	import flash.display.Sprite;
	import hud.HudConstants;
	
	public class LevelCheckedMapTracker extends BaseMapTracker
	{
		
		private var m_view_level_check_above:minimapBlipArrowAboveView;
		
		private var m_view_level_check_below:minimapBlipArrowBelowView;
		
		private var m_currentLevelCheckedMapTrackerView:Sprite;
		
		public function LevelCheckedMapTracker()
		{
			super();
			this.setupLevelCheckedMapTracker();
		}
		
		private function setupLevelCheckedMapTracker():void
		{
			this.m_currentLevelCheckedMapTrackerView = null;
			this.m_view_level_check_above = new minimapBlipArrowAboveView();
			this.m_view_level_check_below = new minimapBlipArrowBelowView();
		}
		
		public function onSetData(param1:Object):void
		{
			this.applyLevelCheckResult(m_mainView, param1.levelCheckResult);
		}
		
		protected function applyLevelCheckResult(param1:Sprite, param2:int):void
		{
			switch (param2)
			{
			case 0: 
				param1.alpha = 1;
				this.setLevelCheckedMapTrackerView(null);
				break;
			case 1: 
				param1.alpha = HudConstants.LayerDepthFadeOutFactor;
				this.setLevelCheckedMapTrackerView(this.m_view_level_check_above);
				break;
			case 2: 
				param1.alpha = HudConstants.LayerDepthFadeOutFactor;
				this.setLevelCheckedMapTrackerView(this.m_view_level_check_below);
				break;
			default: 
				param1.alpha = 1;
				this.setLevelCheckedMapTrackerView(null);
			}
		}
		
		private function setLevelCheckedMapTrackerView(param1:Sprite):void
		{
			if (this.m_currentLevelCheckedMapTrackerView == param1)
			{
				return;
			}
			if (this.m_currentLevelCheckedMapTrackerView != null)
			{
				removeChild(this.m_currentLevelCheckedMapTrackerView);
			}
			this.m_currentLevelCheckedMapTrackerView = param1;
			if (this.m_currentLevelCheckedMapTrackerView != null)
			{
				addChild(this.m_currentLevelCheckedMapTrackerView);
			}
		}
	}
}
