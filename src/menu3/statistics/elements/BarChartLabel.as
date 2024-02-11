// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.statistics.elements.BarChartLabel

package menu3.statistics.elements {
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

import common.menu.MenuUtils;
import common.menu.MenuConstants;

public class BarChartLabel extends Sprite {

	private var m_title:String;
	private var m_maxWidth:Number;

	public function BarChartLabel(_arg_1:String, _arg_2:Number) {
		this.m_title = _arg_1;
		this.m_maxWidth = _arg_2;
		this.setTitle();
	}

	private function setTitle():void {
		var _local_1:TextField = new TextField();
		_local_1.width = this.m_maxWidth;
		_local_1.multiline = true;
		_local_1.wordWrap = true;
		_local_1.autoSize = TextFieldAutoSize.LEFT;
		MenuUtils.setupTextUpper(_local_1, this.m_title, 14, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		addChild(_local_1);
	}


}
}//package menu3.statistics.elements

