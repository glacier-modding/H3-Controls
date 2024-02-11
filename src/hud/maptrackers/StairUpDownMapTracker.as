// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.maptrackers.StairUpDownMapTracker

package hud.maptrackers {
public class StairUpDownMapTracker extends BaseMapTracker {

	private var m_view:minimapBlipStairUpDownView;

	public function StairUpDownMapTracker() {
		this.setupStairUpDownMapTracker();
	}

	private function setupStairUpDownMapTracker():void {
		this.m_view = new minimapBlipStairUpDownView();
		setMainView(this.m_view);
	}


}
}//package hud.maptrackers

