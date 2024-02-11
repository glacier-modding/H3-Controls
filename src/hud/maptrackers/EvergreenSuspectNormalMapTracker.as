// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.maptrackers.EvergreenSuspectNormalMapTracker

package hud.maptrackers {
import common.Localization;

public class EvergreenSuspectNormalMapTracker extends LevelCheckedMapTracker {

	private var m_view:minimapBlipEvergreenSuspectNormalView;

	public function EvergreenSuspectNormalMapTracker() {
		this.setupEvergreenSuspectNormalMapTracker();
	}

	private function setupEvergreenSuspectNormalMapTracker():void {
		this.m_view = new minimapBlipEvergreenSuspectNormalView();
		setMainView(this.m_view);
	}

	override public function getTextForLegend():String {
		return (Localization.get("UI_MAP_LEGEND_LABEL_EVERGREEN_SUSPECT"));
	}


}
}//package hud.maptrackers

