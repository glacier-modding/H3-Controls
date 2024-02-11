// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.SilentAssassinIcon

package hud {
import common.BaseControl;

public class SilentAssassinIcon extends BaseControl {

	private var m_view:SAIconView;

	public function SilentAssassinIcon() {
		this.m_view = new SAIconView();
		this.m_view.bg.alpha = 0.5;
		this.m_view.gotoAndStop("active");
		addChild(this.m_view);
	}

	public function onSAStatusChanged(_arg_1:Boolean, _arg_2:Boolean):void {
		this.m_view.iconMc.gotoAndStop(((_arg_1) ? "inactive" : ((_arg_2) ? "recovery_recorded" : "active")));
	}


}
}//package hud

