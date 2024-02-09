package hud.versus.markers
{
	
	public class OpponentMarkerElement extends BaseMarkerElement
	{
		
		public function OpponentMarkerElement()
		{
			super();
			m_view = new OpponentMarkerElementView();
			addChild(m_view);
			m_distanceView = new DistanceMarkerElement();
			addChild(m_distanceView);
			m_distanceView.markerHeight = m_view.bg.height;
		}
		
		public function onSetData(param1:Object):void
		{
			m_distanceView.onSetData({"distance": param1.distance, "direction": param1.direction});
		}
	}
}
