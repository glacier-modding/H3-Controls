// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.indicator.ItemCountIndicator

package menu3.indicator {
import flash.text.TextField;

import common.menu.MenuConstants;

import flash.text.TextFieldAutoSize;

import common.menu.MenuUtils;

public class ItemCountIndicator extends IndicatorBase {

	private var m_tileWidth:Number = 0;

	public function ItemCountIndicator(_arg_1:Number) {
		this.m_tileWidth = _arg_1;
		var _local_2:TextField = new TextField();
		_local_2.y = MenuConstants.ItemCountIndicatorYOffset;
		_local_2.autoSize = TextFieldAutoSize.LEFT;
		m_indicatorView = _local_2;
	}

	override public function onSetData(_arg_1:*, _arg_2:Object):void {
		super.onSetData(_arg_1, _arg_2);
		this.setText(_arg_2.itemcount);
		var _local_3:TextField = (m_indicatorView as TextField);
		_local_3.x = ((this.m_tileWidth - MenuConstants.ItemCountIndicatorXOffset) - _local_3.width);
	}

	private function setText(_arg_1:int):void {
		var _local_2:String = ("x" + _arg_1);
		MenuUtils.setupText(m_indicatorView, _local_2, 36, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
	}


}
}//package menu3.indicator

