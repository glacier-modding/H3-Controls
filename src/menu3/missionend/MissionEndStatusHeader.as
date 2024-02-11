// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.missionend.MissionEndStatusHeader

package menu3.missionend {
import menu3.MenuElementBase;

import common.menu.MenuUtils;
import common.menu.MenuConstants;

public dynamic class MissionEndStatusHeader extends MenuElementBase {

	private var m_view:MissionEndStatusHeaderView;

	public function MissionEndStatusHeader(_arg_1:Object) {
		super(_arg_1);
		this.m_view = new MissionEndStatusHeaderView();
		MenuUtils.addDropShadowFilter(this.m_view.title);
		MenuUtils.addDropShadowFilter(this.m_view.subtitle);
		addChild(this.m_view);
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		var _local_2:String = ((_arg_1.title) ? _arg_1.title : "");
		var _local_3:String = ((_arg_1.subtitle) ? _arg_1.subtitle : "");
		MenuUtils.setupTextUpper(this.m_view.title, _local_2, 70, MenuConstants.FONT_TYPE_MEDIUM, ((_arg_1.isFailed === true) ? MenuConstants.FontColorRed : MenuConstants.FontColorWhite));
		MenuUtils.setupTextUpper(this.m_view.subtitle, _local_3, 35, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
	}


}
}//package menu3.missionend

