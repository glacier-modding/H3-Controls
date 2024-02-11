// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.maptrackers.EvergreenMeetingBusinessMapTracker

package hud.maptrackers {
import common.Localization;

public class EvergreenMeetingBusinessMapTracker extends LevelCheckedMapTracker {

	private var m_view:minimapBlipEvergreenMeetingBusinessView;

	public function EvergreenMeetingBusinessMapTracker() {
		this.setupEvergreenMeetingBusinessMapTracker();
	}

	private function setupEvergreenMeetingBusinessMapTracker():void {
		this.m_view = new minimapBlipEvergreenMeetingBusinessView();
		setMainView(this.m_view);
	}

	override public function getTextForLegend():String {
		return (Localization.get("UI_MAP_LEGEND_LABEL_EVERGREEN_MEETING_BUSINESS"));
	}


}
}//package hud.maptrackers

