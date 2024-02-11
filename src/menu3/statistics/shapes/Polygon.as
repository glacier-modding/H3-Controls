// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.statistics.shapes.Polygon

package menu3.statistics.shapes {
import flash.display.Sprite;

import common.menu.MenuUtils;

public class Polygon extends Sprite {

	public function Polygon(_arg_1:Number = 100, _arg_2:Number = 5, _arg_3:uint = 0xFF6600, _arg_4:uint = 153, _arg_5:Number = 1) {
		this.draw(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
	}

	protected function draw(_arg_1:Number, _arg_2:Number, _arg_3:uint, _arg_4:uint, _arg_5:Number):void {
		var _local_9:Number;
		var _local_10:Number;
		var _local_11:Number;
		var _local_6:Array = [];
		var _local_7:Number = (360 / _arg_2);
		var _local_8:Number = 0;
		graphics.clear();
		graphics.beginFill(_arg_3, 0);
		graphics.lineStyle(_arg_5, _arg_4, 0.5);
		var _local_12:Number = 0;
		while (_local_12 <= 360) {
			_local_9 = MenuUtils.toRadians(_local_12);
			_local_10 = (Math.sin(_local_9) * _arg_1);
			_local_11 = (Math.cos(_local_9) * _arg_1);
			_local_6[_local_8] = [_local_10, _local_11];
			if (_local_8 >= 1) {
				graphics.lineTo(_local_10, _local_11);
			} else {
				graphics.moveTo(_local_10, _local_11);
			}

			_local_8++;
			_local_12 = (_local_12 + _local_7);
		}

		graphics.endFill();
	}


}
}//package menu3.statistics.shapes

