// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.maptrackers.StairUpMapTracker

package hud.maptrackers {
public class StairUpMapTracker extends BaseMapTracker {

	private var m_view:minimapBlipStairUpView;

	public function StairUpMapTracker() {
		this.setupStairUpMapTracker();
	}

	private function setupStairUpMapTracker():void {
		this.m_view = new minimapBlipStairUpView();
		setMainView(this.m_view);
	}


}
}//package hud.maptrackers

