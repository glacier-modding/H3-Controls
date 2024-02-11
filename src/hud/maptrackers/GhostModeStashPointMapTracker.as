// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.maptrackers.GhostModeStashPointMapTracker

package hud.maptrackers {
import common.Localization;

public class GhostModeStashPointMapTracker extends LevelCheckedMapTracker {

	private var m_view_outfit_crate:minimapBlipStashpointOutfitView;
	private var m_view_melee_crate:minimapBlipStashpointMeleeView;
	private var m_view_firearm_crate:minimapBlipStashpointFirearmView;
	private var m_view_ghost_crate:minimapBlipStashpointGhostView;
	private var m_view_special_crate:minimapBlipStashpointSpecialView;

	public function GhostModeStashPointMapTracker() {
		this.setupStashPointMapTrackers();
	}

	private function setupStashPointMapTrackers():void {
		this.m_view_firearm_crate = new minimapBlipStashpointFirearmView();
		this.m_view_melee_crate = new minimapBlipStashpointMeleeView();
		this.m_view_outfit_crate = new minimapBlipStashpointOutfitView();
		this.m_view_special_crate = new minimapBlipStashpointSpecialView();
		this.m_view_ghost_crate = new minimapBlipStashpointGhostView();
		var _local_1:minimapBlipStashpointGhostGenericView = new minimapBlipStashpointGhostGenericView();
		setMainView(_local_1);
	}

	override public function onSetData(_arg_1:Object):void {
		switch (_arg_1.iconType) {
			case 0:
				setMainView(this.m_view_outfit_crate);
				return;
			case 1:
				setMainView(this.m_view_melee_crate);
				return;
			case 2:
				setMainView(this.m_view_firearm_crate);
				return;
			case 3:
				setMainView(this.m_view_ghost_crate);
				return;
			case 4:
				setMainView(this.m_view_special_crate);
				return;
		}
		;
	}

	override public function getTextForLegend():String {
		return (Localization.get("UI_MAP_LEGEND_LABEL_CRATE"));
	}


}
}//package hud.maptrackers

