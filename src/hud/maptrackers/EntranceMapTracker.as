// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.maptrackers.EntranceMapTracker

package hud.maptrackers {
import common.Localization;

public class EntranceMapTracker extends LevelCheckedMapTracker {

	private var m_view:minimapBlipEntranceView;

	public function EntranceMapTracker() {
		this.setupEntranceMapTracker();
	}

	private function setupEntranceMapTracker():void {
		this.m_view = new minimapBlipEntranceView();
		setMainView(this.m_view);
	}

	override public function getTextForLegend():String {
		return (Localization.get("UI_MAP_ENTRANCE"));
	}


}
}//package hud.maptrackers

