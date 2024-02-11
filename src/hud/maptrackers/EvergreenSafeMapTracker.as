// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.maptrackers.EvergreenSafeMapTracker

package hud.maptrackers {
import common.Localization;

public class EvergreenSafeMapTracker extends LevelCheckedMapTracker {

	private var m_view:minimapBlipEvergreenSafeView;

	public function EvergreenSafeMapTracker() {
		this.setupEvergreenSafeMapTracker();
	}

	private function setupEvergreenSafeMapTracker():void {
		this.m_view = new minimapBlipEvergreenSafeView();
		setMainView(this.m_view);
	}

	override public function getTextForLegend():String {
		return (Localization.get("UI_MAP_LEGEND_LABEL_EVERGREEN_SAFE"));
	}


}
}//package hud.maptrackers

