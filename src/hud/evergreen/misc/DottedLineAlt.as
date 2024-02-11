// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.evergreen.misc.DottedLineAlt

package hud.evergreen.misc {
import flash.display.Sprite;
import flash.text.TextField;

import common.menu.MenuUtils;
import common.menu.MenuConstants;

import flash.text.TextFieldAutoSize;

public class DottedLineAlt extends Sprite {

	private var m_txt:TextField = new TextField();
	private var m_pxDotSize:Number;

	public function DottedLineAlt(_arg_1:int) {
		this.m_pxDotSize = _arg_1;
		MenuUtils.setupText(this.m_txt, ".", (_arg_1 * 15), MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		this.m_txt.autoSize = TextFieldAutoSize.LEFT;
		addChild(this.m_txt);
		this.m_txt.x = -4;
		this.m_txt.y = (-(_arg_1) * 13.333333);
	}

	public function updateLineLength(_arg_1:int):void {
		this.m_txt.text = ".";
		while (this.m_txt.textWidth < _arg_1) {
			this.m_txt.appendText(" .");
		}
		;
	}

	public function get dottedLineLength():Number {
		return (this.m_txt.textWidth);
	}

	public function get dottedLineThickness():Number {
		return (this.m_pxDotSize);
	}


}
}//package hud.evergreen.misc

