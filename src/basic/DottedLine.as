// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//basic.DottedLine

package basic {
import flash.display.Shape;
import flash.display.BitmapData;
import flash.geom.Rectangle;

public class DottedLine extends Shape {

	public static const TYPE_VERTICAL:String = "vertical";
	public static const TYPE_HORIZONTAL:String = "horizontal";

	private var size:Number;
	private var color:uint;
	private var type:String;
	private var dotSize:Number;
	private var dotSpacing:Number;

	public function DottedLine(_arg_1:Number = 100, _arg_2:uint = 0xFF00FF, _arg_3:String = "horizontal", _arg_4:Number = 1, _arg_5:Number = 1) {
		this.size = _arg_1;
		this.color = _arg_2;
		this.type = _arg_3;
		this.dotSize = _arg_4;
		this.dotSpacing = _arg_5;
		if (_arg_3 == TYPE_HORIZONTAL) {
			this.drawHorizontal();
		} else {
			if (_arg_3 == TYPE_VERTICAL) {
				this.drawVertical();
			}

		}

	}

	private function drawHorizontal():void {
		graphics.clear();
		var _local_1:BitmapData = new BitmapData((this.dotSize + this.dotSpacing), this.dotSize);
		var _local_2:Rectangle = new Rectangle(0, 0, this.dotSize, this.dotSize);
		var _local_3:Rectangle = new Rectangle(this.dotSize, 0, this.dotSpacing, this.dotSize);
		var _local_4:uint = this.returnARGB(this.color, 0xFF);
		_local_1.fillRect(_local_2, _local_4);
		_local_1.fillRect(_local_3, 0);
		graphics.beginBitmapFill(_local_1);
		graphics.drawRect(0, 0, this.size, this.dotSize);
		graphics.endFill();
	}

	private function drawVertical():void {
		graphics.clear();
		var _local_1:BitmapData = new BitmapData(this.dotSize, (this.dotSize + this.dotSpacing));
		var _local_2:Rectangle = new Rectangle(0, 0, this.dotSize, this.dotSize);
		var _local_3:Rectangle = new Rectangle(0, this.dotSize, this.dotSize, this.dotSpacing);
		var _local_4:uint = this.returnARGB(this.color, 0xFF);
		_local_1.fillRect(_local_2, _local_4);
		_local_1.fillRect(_local_3, 0);
		graphics.beginBitmapFill(_local_1);
		graphics.drawRect(0, 0, this.dotSize, this.size);
		graphics.endFill();
	}

	private function returnARGB(_arg_1:uint, _arg_2:uint):uint {
		var _local_3:uint;
		_local_3 = (_local_3 + (_arg_2 << 24));
		return (_local_3 + _arg_1);
	}


}
}//package basic

