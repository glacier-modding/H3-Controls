// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.maptrackers.TutorialMapTracker

package hud.maptrackers {
import common.Localization;

public class TutorialMapTracker extends LevelCheckedMapTracker {

	private var m_view:minimapBlipTutorialView;

	public function TutorialMapTracker() {
		this.setupTutorialMapTracker();
	}

	private function setupTutorialMapTracker():void {
		this.m_view = new minimapBlipTutorialView();
		setMainView(this.m_view);
	}

	override public function getTextForLegend():String {
		return (Localization.get("UI_MAP_LEGEND_LABEL_WAYPOINT"));
	}


}
}//package hud.maptrackers

