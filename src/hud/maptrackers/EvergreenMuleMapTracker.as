// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.maptrackers.EvergreenMuleMapTracker

package hud.maptrackers {
import common.Localization;

public class EvergreenMuleMapTracker extends LevelCheckedMapTracker {

	private var m_view:minimapBlipEvergreenMuleView;

	public function EvergreenMuleMapTracker() {
		this.setupEvergreenMuleMapTracker();
	}

	private function setupEvergreenMuleMapTracker():void {
		this.m_view = new minimapBlipEvergreenMuleView();
		setMainView(this.m_view);
	}

	override public function getTextForLegend():String {
		return (Localization.get("UI_MAP_LEGEND_LABEL_EVERGREEN_MULE"));
	}


}
}//package hud.maptrackers

