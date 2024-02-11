// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.HintBox

package hud {
import common.BaseControl;
import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.Animate;

public class HintBox extends BaseControl {

	private var m_view:HintBoxView;

	public function HintBox() {
		this.m_view = new HintBoxView();
		this.m_view.hintbox_mc.x = (this.m_view.hintbox_mc.y = 0);
		addChild(this.m_view);
	}

	public function showText(_arg_1:String, _arg_2:String):void {
		MenuUtils.setupText(this.m_view.hintbox_mc.title_text, _arg_1, 18, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorGreyUltraLight);
		MenuUtils.setupText(this.m_view.hintbox_mc.body_text, _arg_2, 18, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorGreyUltraLight);
		this.m_view.hintbox_mc.background_mc.height = (this.m_view.hintbox_mc.body_text.textHeight + 55);
		this.onSetVisible(true);
	}

	public function hideText():void {
		this.m_view.visible = false;
	}

	public function onSetData(_arg_1:Object):void {
		this.showText(_arg_1.title, _arg_1.body);
	}

	override public function onSetVisible(_arg_1:Boolean):void {
		this.m_view.visible = _arg_1;
		if (_arg_1) {
			this.m_view.y = 30;
			Animate.legacyTo(this.m_view, 1, {"y": 0}, Animate.ExpoOut);
		}
		;
	}


}
}//package hud

