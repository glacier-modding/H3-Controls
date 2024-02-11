// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.maptrackers.AreaUndiscoveredMapTracker

package hud.maptrackers {
import common.Localization;

public class AreaUndiscoveredMapTracker extends BaseMapTracker {

	private var m_view:minimapBlipAreaUndiscoveredView;

	public function AreaUndiscoveredMapTracker() {
		this.setupAreaUndiscoveredMapTracker();
	}

	private function setupAreaUndiscoveredMapTracker():void {
		this.m_view = new minimapBlipAreaUndiscoveredView();
		setMainView(this.m_view);
	}

	override public function getTextForLegend():String {
		return (("DIVIDERLINE" + ";") + Localization.get("UI_MAP_LEGEND_LABEL_GENERAL_AREAUNDISCOVERED"));
	}


}
}//package hud.maptrackers

