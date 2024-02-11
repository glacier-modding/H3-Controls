// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.maptrackers.ExitFailMapTracker

package hud.maptrackers {
import common.Localization;

public class ExitFailMapTracker extends LevelCheckedMapTracker {

	private var m_view:minimapBlipExitFailView;

	public function ExitFailMapTracker() {
		this.setupExitFailMapTracker();
	}

	private function setupExitFailMapTracker():void {
		this.m_view = new minimapBlipExitFailView();
		setMainView(this.m_view);
	}

	override public function getTextForLegend():String {
		return (Localization.get("UI_EVERGREEN_MISSION_EXITLEVEL_FAILMISSION_PROMPT"));
	}


}
}//package hud.maptrackers

