// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.maptrackers.StashedItemMapTracker

package hud.maptrackers {
import common.Localization;

public class StashedItemMapTracker extends LevelCheckedMapTracker {

	public function StashedItemMapTracker() {
		this.setupStashedItemMapTracker();
	}

	private function setupStashedItemMapTracker():void {
		var _local_1:minimapBlipStashedItemView = new minimapBlipStashedItemView();
		setMainView(_local_1);
	}

	override public function getTextForLegend():String {
		return (Localization.get("UI_MAP_LEGEND_LABEL_HIDDEN_STASH"));
	}


}
}//package hud.maptrackers

