// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.maptrackers.OpponentMapTracker

package hud.maptrackers {
import common.Localization;

public class OpponentMapTracker extends LevelCheckedMapTracker {

	private var m_view:minimapBlipOpponentView;

	public function OpponentMapTracker() {
		this.setupOpponentMapTracker();
	}

	private function setupOpponentMapTracker():void {
		this.m_view = new minimapBlipOpponentView();
		setMainView(this.m_view);
	}

	override public function getTextForLegend():String {
		return (Localization.get("UI_MAP_OPPONENT"));
	}


}
}//package hud.maptrackers

