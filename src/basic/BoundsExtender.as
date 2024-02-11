// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//basic.BoundsExtender

package basic {
import common.BaseControl;

public class BoundsExtender extends BaseControl {

	public function BoundsExtender() {
		this.graphics.beginFill(0, 0);
		this.graphics.lineStyle(0, 0, 0);
		this.graphics.drawRect((-9999999 / 2), (-9999999 / 2), (9999999 * 2), (9999999 * 2));
		this.mouseEnabled = false;
	}

}
}//package basic

