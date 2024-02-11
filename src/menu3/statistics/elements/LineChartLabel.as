// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.statistics.elements.LineChartLabel

package menu3.statistics.elements {
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

import common.menu.MenuUtils;
import common.menu.MenuConstants;

public class LineChartLabel extends Sprite {

	public static const TEXT_ORIENTATION_LEFT:String = "left";
	public static const TEXT_ORIENTATION_CENTER:String = "center";
	public static const TEXT_ORIENTATION_RIGHT:String = "right";

	private var m_title:String;
	private var m_icon:Sprite;
	private var m_useIcon:Boolean;
	private var m_iconColor:uint;
	private var m_textOrientation:String;

	public function LineChartLabel(_arg_1:String, _arg_2:Boolean, _arg_3:uint, _arg_4:String = "left") {
		this.m_title = _arg_1;
		this.m_useIcon = _arg_2;
		this.m_iconColor = _arg_3;
		this.m_textOrientation = _arg_4;
		if (_arg_2) {
			this.drawIcon();
		}
		;
		this.setTitle();
	}

	private function drawIcon():void {
		this.m_icon = new Sprite();
		this.m_icon.graphics.clear();
		this.m_icon.graphics.beginFill(this.m_iconColor, 1);
		this.m_icon.graphics.drawCircle(0, 0, 6);
		this.m_icon.graphics.endFill();
		addChild(this.m_icon);
	}

	private function setTitle():void {
		var _local_1:TextField = new TextField();
		_local_1.autoSize = TextFieldAutoSize.LEFT;
		MenuUtils.setupTextUpper(_local_1, this.m_title, 14, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		if (this.m_textOrientation == TEXT_ORIENTATION_LEFT) {
			if (this.m_useIcon) {
				_local_1.x = (this.m_icon.x + this.m_icon.width);
			}
			;
		} else {
			if (this.m_textOrientation == TEXT_ORIENTATION_RIGHT) {
				if (this.m_useIcon) {
					_local_1.x = ((this.m_icon.x - this.m_icon.width) - _local_1.width);
				} else {
					_local_1.x = -(_local_1.width);
				}
				;
			} else {
				if (this.m_textOrientation == TEXT_ORIENTATION_CENTER) {
					_local_1.x = -(_local_1.width / 2);
				}
				;
			}
			;
		}
		;
		_local_1.y = (-(_local_1.height) / 2);
		addChild(_local_1);
	}


}
}//package menu3.statistics.elements

