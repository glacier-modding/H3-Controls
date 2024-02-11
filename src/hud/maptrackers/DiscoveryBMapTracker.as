// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.maptrackers.DiscoveryBMapTracker

package hud.maptrackers {
import common.Localization;

public class DiscoveryBMapTracker extends LevelCheckedMapTracker {

	private var m_view:minimapBlipDiscoveryBView;

	public function DiscoveryBMapTracker() {
		this.setupDiscoveryBMapTracker();
	}

	private function setupDiscoveryBMapTracker():void {
		this.m_view = new minimapBlipDiscoveryBView();
		setMainView(this.m_view);
	}

	override public function getTextForLegend():String {
		return (Localization.get("UI_MAP_OBJECTIVE"));
	}


}
}//package hud.maptrackers

