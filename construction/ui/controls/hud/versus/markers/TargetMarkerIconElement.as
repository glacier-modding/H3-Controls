package hud.versus.markers
{
	
	public class TargetMarkerIconElement extends BaseMarkerElement
	{
		
		public function TargetMarkerIconElement()
		{
			super();
			m_view = new TargetMarkerIconElementView();
			addChild(m_view);
		}
	}
}
