// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.maptrackers.NorthIndicatorMapTracker

package hud.maptrackers {
public class NorthIndicatorMapTracker extends BaseMapTracker {

	private var m_view:minimapBlipNorthView;

	public function NorthIndicatorMapTracker() {
		this.setupNorthIndicatorMapTracker();
	}

	private function setupNorthIndicatorMapTracker():void {
		this.m_view = new minimapBlipNorthView();
		setMainView(this.m_view);
	}


}
}//package hud.maptrackers

