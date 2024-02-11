// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.maptrackers.SuitcaseMapTracker

package hud.maptrackers {
import common.Localization;

public class SuitcaseMapTracker extends LevelCheckedMapTracker {

	private var m_view:minimapBlipSuitcaseView;

	public function SuitcaseMapTracker() {
		this.setupSuitcaseMapTracker();
	}

	private function setupSuitcaseMapTracker():void {
		this.m_view = new minimapBlipSuitcaseView();
		setMainView(this.m_view);
	}

	override public function getTextForLegend():String {
		return (Localization.get("UI_ITEM_SUBTYPE_SUITCASE"));
	}


}
}//package hud.maptrackers

