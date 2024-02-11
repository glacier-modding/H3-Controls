// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.missionend.MultiplayerScoreLineWithText

package menu3.missionend {
import menu3.MenuElementBase;

import common.menu.MenuUtils;
import common.menu.MenuConstants;

public dynamic class MultiplayerScoreLineWithText extends MenuElementBase {

	private var m_view:MultiplayerScoreLineWithTextView;
	private var m_listElements:Array;

	public function MultiplayerScoreLineWithText(_arg_1:Object) {
		super(_arg_1);
		this.m_view = new MultiplayerScoreLineWithTextView();
		addChild(this.m_view);
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		var _local_2:String = ((_arg_1.text != null) ? _arg_1.text : "");
		MenuUtils.setupTextUpper(this.m_view.text, _local_2, 170, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
	}

	override public function onUnregister():void {
		if (this.m_view) {
			removeChild(this.m_view);
			this.m_view = null;
		}
		;
		super.onUnregister();
	}


}
}//package menu3.missionend

