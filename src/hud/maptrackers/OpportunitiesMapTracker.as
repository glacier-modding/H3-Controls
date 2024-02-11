// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.maptrackers.OpportunitiesMapTracker

package hud.maptrackers {
import common.Localization;

public class OpportunitiesMapTracker extends LevelCheckedMapTracker {

	private var m_view:minimapBlipOpportunitiesView;

	public function OpportunitiesMapTracker() {
		this.setupNorthIndicatorMapTracker();
	}

	private function setupNorthIndicatorMapTracker():void {
		this.m_view = new minimapBlipOpportunitiesView();
		setMainView(this.m_view);
	}

	override public function getTextForLegend():String {
		return (Localization.get("UI_MAP_TARGET"));
	}


}
}//package hud.maptrackers

