// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.notification.ActionXpBarVr

package hud.notification {
import common.BaseControl;

import flash.display.Sprite;

import common.menu.MenuUtils;
import common.menu.MenuConstants;

import flash.text.TextField;

public class ActionXpBarVr extends BaseControl {

	private var m_container:Sprite;
	private var m_view:ActionXpBarView;

	public function ActionXpBarVr() {
		this.m_container = new Sprite();
		addChild(this.m_container);
		this.m_view = new ActionXpBarView();
		MenuUtils.setupText(this.m_view.header, "", 20, MenuConstants.FONT_TYPE_MEDIUM);
		MenuUtils.setTextColor(this.m_view.header, MenuConstants.COLOR_RED);
		this.m_view.visible = true;
		this.m_view.header.visible = true;
		this.m_view.value.visible = false;
		this.m_view.bg.visible = false;
		this.m_container.addChild(this.m_view);
	}

	public function GetTextField():TextField {
		return ((this.m_view != null) ? this.m_view.header : null);
	}


}
}//package hud.notification

