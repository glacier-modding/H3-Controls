// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.maptrackers.EvergreenStashMapTracker

package hud.maptrackers {
import common.Localization;

public class EvergreenStashMapTracker extends LevelCheckedMapTracker {

	private var m_view:minimapBlipEvergreenStashView;

	public function EvergreenStashMapTracker() {
		this.setupEvergreenStashMapTracker();
	}

	private function setupEvergreenStashMapTracker():void {
		this.m_view = new minimapBlipEvergreenStashView();
		setMainView(this.m_view);
	}

	override public function getTextForLegend():String {
		return (Localization.get("UI_MAP_LEGEND_LABEL_EVERGREEN_STASH"));
	}


}
}//package hud.maptrackers

