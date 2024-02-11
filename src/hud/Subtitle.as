// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.Subtitle

package hud {
import common.BaseControl;
import common.menu.MenuUtils;
import common.menu.MenuConstants;

public class Subtitle extends BaseControl {

	private var m_view:SubTitleView;

	public function Subtitle() {
		this.m_view = new SubTitleView();
		addChild(this.m_view);
	}

	override public function onSetSize(_arg_1:Number, _arg_2:Number):void {
		this.m_view.sub_txt.width = _arg_1;
		this.m_view.sub_txt.height = _arg_2;
	}

	public function onSetData(_arg_1:Object):void {
		var _local_2:String = (_arg_1 as String);
		if (_local_2 == "") {
			this.m_view.visible = false;
		} else {
			MenuUtils.setupText(this.m_view.sub_txt, _local_2, 22, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
			this.m_view.visible = true;
		}

	}


}
}//package hud

