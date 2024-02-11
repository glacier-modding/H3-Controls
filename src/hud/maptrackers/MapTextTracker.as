// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.maptrackers.MapTextTracker

package hud.maptrackers {
import basic.TextBox;

import common.menu.MenuUtils;

public class MapTextTracker extends TextBox {


	override public function onSetSize(_arg_1:Number, _arg_2:Number):void {
	}

	override public function onAttached():void {
		super.onAttached();
		this.applyFormat();
		m_textfield.autoSize = "center";
		m_textfield.width = 3000;
		m_textfield.multiline = true;
		m_textfield.wordWrap = true;
		MenuUtils.addDropShadowFilter(m_textfield);
	}

	override protected function applyFormat():void {
		super.applyFormat();
		m_textfield.x = (-(m_textfield.width) / 2);
		m_textfield.y = (-(m_textfield.height) / 2);
	}


}
}//package hud.maptrackers

