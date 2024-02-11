// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.maptrackers.CustomObjectiveMapTracker

package hud.maptrackers {
import common.Localization;

public class CustomObjectiveMapTracker extends LevelCheckedMapTracker {

	private var m_view:minimapBlipObjectiveView;

	public function CustomObjectiveMapTracker() {
		this.setupCustomObjectiveMapTracker();
	}

	private function setupCustomObjectiveMapTracker():void {
		this.m_view = new minimapBlipObjectiveView();
		setMainView(this.m_view);
	}

	override public function getTextForLegend():String {
		return (Localization.get("UI_MAP_OBJECTIVE"));
	}


}
}//package hud.maptrackers

