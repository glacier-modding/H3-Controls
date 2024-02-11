// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.maptrackers.StashPointMapTracker

package hud.maptrackers {
import common.Localization;

public class StashPointMapTracker extends LevelCheckedMapTracker {

	private var m_view:minimapBlipStashpointView;

	public function StashPointMapTracker() {
		this.setupStashPointMapTracker();
	}

	private function setupStashPointMapTracker():void {
		this.m_view = new minimapBlipStashpointView();
		setMainView(this.m_view);
	}

	override public function getTextForLegend():String {
		return (Localization.get("UI_MAP_LEGEND_LABEL_STASHPOINT"));
	}


}
}//package hud.maptrackers

