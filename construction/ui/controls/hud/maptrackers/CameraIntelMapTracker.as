package hud.maptrackers
{
	import common.Localization;
	
	public class CameraIntelMapTracker extends BaseMapTracker
	{
		
		private var m_view:minimapBlipCameraIntelView;
		
		public function CameraIntelMapTracker()
		{
			super();
			this.setupCameraIntelMapTracker();
		}
		
		private function setupCameraIntelMapTracker():void
		{
			this.m_view = new minimapBlipCameraIntelView();
			setMainView(this.m_view);
		}
		
		override public function getTextForLegend():String
		{
			return Localization.get("UI_MAP_LEGEND_LABEL_OPPORTUNITY_INTEL_CAMERA");
		}
	}
}
