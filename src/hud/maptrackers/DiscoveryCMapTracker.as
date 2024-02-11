// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.maptrackers.DiscoveryCMapTracker

package hud.maptrackers {
import common.Localization;

public class DiscoveryCMapTracker extends LevelCheckedMapTracker {

	private var m_view:minimapBlipDiscoveryCView;

	public function DiscoveryCMapTracker() {
		this.setupDiscoveryCMapTracker();
	}

	private function setupDiscoveryCMapTracker():void {
		this.m_view = new minimapBlipDiscoveryCView();
		setMainView(this.m_view);
	}

	override public function getTextForLegend():String {
		return (Localization.get("UI_MAP_OBJECTIVE"));
	}


}
}//package hud.maptrackers

