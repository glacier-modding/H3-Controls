// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.statistics.elements.RadarChartLabel

package menu3.statistics.elements {
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;

import menu3.statistics.shapes.Trapezoid;

import flash.geom.Point;

import common.menu.MenuUtils;

import flash.text.TextFieldAutoSize;

import common.menu.MenuConstants;

public class RadarChartLabel extends Sprite {

	private var tf:TextField;
	private var tfContainer:Sprite;
	private var tfm:TextFormat;
	private var m_bgShape:Trapezoid;
	private var m_bgColor:uint = 0xFA000E;
	private var m_title:String;
	private var m_titleRotation:Number;
	private var m_labelHeight:Number;
	private var m_labelSpacing:Number = 0;
	private var m_isPlayerValue:Boolean;
	private var m_baseLength:Number;
	private var m_apothem:Number;
	private var m_centralAngle:Number;

	public function RadarChartLabel(_arg_1:String, _arg_2:Number, _arg_3:Number, _arg_4:Boolean, _arg_5:Number, _arg_6:Number, _arg_7:Number) {
		this.m_title = _arg_1;
		this.m_titleRotation = _arg_2;
		this.m_labelHeight = _arg_3;
		this.m_isPlayerValue = _arg_4;
		this.m_baseLength = _arg_5;
		this.m_apothem = _arg_6;
		this.m_centralAngle = _arg_7;
		if (_arg_4) {
			this.drawBackground();
		}

		this.setTitle();
	}

	private function drawBackground():void {
		var _local_1:Point = new Point();
		_local_1.x = (-(this.m_baseLength / 2) + this.m_labelSpacing);
		_local_1.y = -(this.m_apothem + 2);
		var _local_2:Point = new Point();
		_local_2.x = ((this.m_baseLength / 2) - this.m_labelSpacing);
		_local_2.y = _local_1.y;
		var _local_3:Point = new Point();
		_local_3.x = ((_local_1.x - (this.m_labelHeight * Math.tan(MenuUtils.toRadians((this.m_centralAngle / 2))))) + this.m_labelSpacing);
		_local_3.y = (_local_1.y - this.m_labelHeight);
		var _local_4:Point = new Point();
		_local_4.x = ((_local_2.x + (this.m_labelHeight * Math.tan(MenuUtils.toRadians((this.m_centralAngle / 2))))) - this.m_labelSpacing);
		_local_4.y = (_local_2.y - this.m_labelHeight);
		this.m_bgShape = new Trapezoid(_local_1, _local_3, _local_4, _local_2, this.m_bgColor);
		addChild(this.m_bgShape);
	}

	private function setTitle():void {
		this.tf = new TextField();
		this.tf.autoSize = TextFieldAutoSize.LEFT;
		MenuUtils.setupTextUpper(this.tf, this.m_title, 16, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
		this.tf.x = (-(this.tf.width) / 2);
		this.tf.y = (-(this.tf.height) / 2);
		this.tfContainer = new Sprite();
		this.tfContainer.x = 0;
		this.tfContainer.y = -((this.m_apothem + (this.m_labelHeight / 2)) + 2);
		var _local_1:Boolean = (((MenuUtils.actualDegrees(this.m_titleRotation) > 90) && (MenuUtils.actualDegrees(this.m_titleRotation) < 270)) ? true : false);
		if (_local_1) {
			this.tfContainer.rotation = 180;
		}

		this.tfContainer.addChild(this.tf);
		addChild(this.tfContainer);
	}


}
}//package menu3.statistics.elements

