// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.maptrackers.EvergreenSuspectPrimeMapTracker

package hud.maptrackers {
import common.Localization;

public class EvergreenSuspectPrimeMapTracker extends LevelCheckedMapTracker {

	private var m_view:minimapBlipEvergreenSuspectPrimeView;

	public function EvergreenSuspectPrimeMapTracker() {
		this.setupEvergreenSuspectPrimeMapTracker();
	}

	private function setupEvergreenSuspectPrimeMapTracker():void {
		this.m_view = new minimapBlipEvergreenSuspectPrimeView();
		setMainView(this.m_view);
	}

	override public function getTextForLegend():String {
		return (Localization.get("UI_MAP_LEGEND_LABEL_EVERGREEN_PRIMESUSPECT"));
	}


}
}//package hud.maptrackers

