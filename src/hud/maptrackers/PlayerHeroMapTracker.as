﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.maptrackers.PlayerHeroMapTracker

package hud.maptrackers {
import common.Localization;

public class PlayerHeroMapTracker extends BaseMapTracker {

	private var m_view:minimapBlipPlayerView;

	public function PlayerHeroMapTracker() {
		this.setupPlayerHeroMapTracker();
	}

	private function setupPlayerHeroMapTracker():void {
		this.m_view = new minimapBlipPlayerView();
		setMainView(this.m_view);
	}

	override public function getTextForLegend():String {
		return (("DIVIDERLINE" + ";") + Localization.get("UI_MAP_LEGEND_LABEL_PLAYER"));
	}


}
}//package hud.maptrackers

