// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//basic.PieChart

package basic {
import flash.display.Sprite;

public class PieChart extends Sprite {

	private const PI:Number = 3.14159265358979;


	protected function drawSlice(_arg_1:Sprite, _arg_2:Number, _arg_3:Number, _arg_4:uint = 0xFF0000, _arg_5:Number = 0):void {
		var _local_6:Number;
		var _local_7:Number;
		var _local_8:Number;
		var _local_9:Number;
		var _local_10:Number;
		var _local_11:Number;
		var _local_12:Number;
		var _local_13:Number;
		var _local_14:Number;
		var _local_15:Number;
		_arg_1.graphics.clear();
		_arg_1.graphics.beginFill(_arg_4, 1);
		_arg_1.graphics.moveTo(0, 0);
		if (Math.abs(_arg_3) > 360) {
			_arg_3 = 360;
		}
		;
		_local_9 = Math.ceil((Math.abs(_arg_3) / 45));
		_local_6 = (_arg_3 / _local_9);
		_local_6 = ((_local_6 / 180) * this.PI);
		_local_7 = ((_arg_5 / 180) * this.PI);
		_local_10 = (Math.cos(_local_7) * _arg_2);
		_local_11 = (Math.sin(-(_local_7)) * _arg_2);
		_arg_1.graphics.lineTo(_local_10, _local_11);
		var _local_16:int;
		while (_local_16 < _local_9) {
			_local_7 = (_local_7 + _local_6);
			_local_8 = (_local_7 - (_local_6 / 2));
			_local_12 = (Math.cos(_local_7) * _arg_2);
			_local_13 = (Math.sin(_local_7) * _arg_2);
			_local_14 = (Math.cos(_local_8) * (_arg_2 / Math.cos((_local_6 / 2))));
			_local_15 = (Math.sin(_local_8) * (_arg_2 / Math.cos((_local_6 / 2))));
			_arg_1.graphics.curveTo(_local_14, _local_15, _local_12, _local_13);
			_local_16++;
		}
		;
		_arg_1.graphics.lineTo(0, 0);
		_arg_1.graphics.endFill();
	}


}
}//package basic

