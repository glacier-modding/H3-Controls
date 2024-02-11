// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.missionend.MissionEndMultiplayerScoreDuration

package menu3.missionend {
import menu3.MenuElementBase;

import basic.DottedLine;

import common.menu.MenuUtils;
import common.DateTimeUtils;
import common.menu.MenuConstants;

public dynamic class MissionEndMultiplayerScoreDuration extends MenuElementBase {

	private var m_view:MissionEndMultiplayerScoreDurationView;
	private var m_dottedline:DottedLine;

	public function MissionEndMultiplayerScoreDuration(_arg_1:Object) {
		super(_arg_1);
		this.m_view = new MissionEndMultiplayerScoreDurationView();
		addChild(this.m_view);
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		MenuUtils.setupTextUpper(this.m_view.value, DateTimeUtils.formatDurationHHMMSS((_arg_1.sessionduration * 1000)), 42, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		this.m_dottedline = new DottedLine(this.m_view.value.textWidth, MenuConstants.COLOR_GREY_LIGHT, DottedLine.TYPE_HORIZONTAL, 1, 2);
		this.m_dottedline.x = (this.m_view.value.textWidth / -2);
		this.m_dottedline.y = -35;
		this.m_view.addChild(this.m_dottedline);
	}

	override public function onUnregister():void {
		if (this.m_view) {
			super.onUnregister();
			this.m_view.removeChild(this.m_dottedline);
			removeChild(this.m_view);
			this.m_view = null;
		}

	}


}
}//package menu3.missionend

