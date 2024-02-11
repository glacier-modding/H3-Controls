// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.maptrackers.StairDownMapTracker

package hud.maptrackers {
public class StairDownMapTracker extends BaseMapTracker {

	private var m_view:minimapBlipStairDownView;

	public function StairDownMapTracker() {
		this.setupStairDownMapTracker();
	}

	private function setupStairDownMapTracker():void {
		this.m_view = new minimapBlipStairDownView();
		setMainView(this.m_view);
	}


}
}//package hud.maptrackers

