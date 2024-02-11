// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.versus.markers.TargetMarkerElement

package hud.versus.markers {
public class TargetMarkerElement extends BaseMarkerElement {

	public function TargetMarkerElement() {
		m_view = new TargetMarkerElementView();
		addChild(m_view);
		m_distanceView = new DistanceMarkerElement();
		addChild(m_distanceView);
		m_distanceView.markerHeight = m_view.bg.height;
	}

	public function onSetData(_arg_1:Object):void {
		m_distanceView.onSetData({
			"distance": _arg_1.distance,
			"direction": _arg_1.direction
		});
	}


}
}//package hud.versus.markers

