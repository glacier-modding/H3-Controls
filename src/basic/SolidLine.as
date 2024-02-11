// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//basic.SolidLine

package basic {
import flash.display.Shape;

public class SolidLine extends Shape {

	public static const TYPE_VERTICAL:String = "vertical";
	public static const TYPE_HORIZONTAL:String = "horizontal";

	private var size:Number;
	private var color:uint;
	private var thickness:Number;
	private var type:String;

	public function SolidLine(_arg_1:Number = 100, _arg_2:uint = 0xFF00FF, _arg_3:Number = 1, _arg_4:String = "horizontal") {
		this.size = _arg_1;
		this.color = _arg_2;
		this.thickness = _arg_3;
		this.type = _arg_4;
		if (_arg_4 == TYPE_HORIZONTAL) {
			this.drawHorizontal();
		} else {
			if (_arg_4 == TYPE_VERTICAL) {
				this.drawVertical();
			}

		}

	}

	private function drawHorizontal():void {
		graphics.clear();
		graphics.beginFill(this.color, 1);
		graphics.drawRect(0, 0, this.size, this.thickness);
		graphics.endFill();
	}

	private function drawVertical():void {
		graphics.clear();
		graphics.beginFill(this.color, 1);
		graphics.drawRect(0, 0, this.thickness, this.size);
		graphics.endFill();
	}


}
}//package basic

