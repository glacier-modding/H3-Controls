// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.statistics.shapes.Trapezoid

package menu3.statistics.shapes {
import flash.display.Sprite;
import flash.geom.Point;

public class Trapezoid extends Sprite {

	public function Trapezoid(_arg_1:Point, _arg_2:Point, _arg_3:Point, _arg_4:Point, _arg_5:uint = 0xFF003C) {
		graphics.beginFill(_arg_5);
		graphics.moveTo(_arg_1.x, _arg_1.y);
		graphics.lineTo(_arg_2.x, _arg_2.y);
		graphics.lineTo(_arg_3.x, _arg_3.y);
		graphics.lineTo(_arg_4.x, _arg_4.y);
		graphics.lineTo(_arg_1.x, _arg_1.y);
		graphics.endFill();
	}

}
}//package menu3.statistics.shapes

