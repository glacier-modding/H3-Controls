// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.BitmapTestClass

package menu3 {
import common.BaseControl;

import flash.display.BitmapData;
import flash.display.Bitmap;
import flash.geom.Point;
import flash.geom.Rectangle;

public class BitmapTestClass extends BaseControl {

	private var source:BitmapData;
	private var target:BitmapData;

	public function BitmapTestClass() {
		this.source = new BitmapData(300, 300, false);
		this.source.fillRect(this.source.rect, 0xFF0000);
		addChild(new Bitmap(this.source));
	}

	private function cropImage(_arg_1:BitmapData, _arg_2:Rectangle):BitmapData {
		var _local_3:BitmapData = new BitmapData(_arg_2.width, _arg_2.height, _arg_1.transparent);
		_local_3.copyPixels(_arg_1, _arg_2, new Point());
		return (_local_3);
	}


}
}//package menu3

