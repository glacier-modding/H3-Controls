// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.maptrackers.DiscoveryMapTracker

package hud.maptrackers {
import common.Localization;

public class DiscoveryMapTracker extends LevelCheckedMapTracker {

	private var m_view:minimapBlipDiscoveryView;

	public function DiscoveryMapTracker() {
		this.setupDiscoveryMapTracker();
	}

	private function setupDiscoveryMapTracker():void {
		this.m_view = new minimapBlipDiscoveryView();
		setMainView(this.m_view);
	}

	override public function getTextForLegend():String {
		return (Localization.get("UI_MAP_OBJECTIVE"));
	}


}
}//package hud.maptrackers

