// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.ConnectionAlert

package hud {
import common.BaseControl;
import common.menu.MenuUtils;
import common.menu.MenuConstants;

public class ConnectionAlert extends BaseControl {

	private var m_view:ConnectionView;

	public function ConnectionAlert() {
		this.m_view = new ConnectionView();
		addChild(this.m_view);
	}

	public function onSetData(_arg_1:Object):void {
		this.SetText(_arg_1.string);
		this.m_view.typeIcon_mc.gotoAndStop(_arg_1.type);
	}

	public function HideBar():void {
		this.m_view.gotoAndPlay("HIDE");
	}

	public function SetText(_arg_1:String):void {
		this.m_view.visible = true;
		MenuUtils.setupText(this.m_view.label_mc.label_txt, _arg_1, 20, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorGreyUltraLight);
		this.m_view.typeIcon_mc.gotoAndStop(1);
		this.m_view.gotoAndPlay("SHOW");
	}


}
}//package hud

