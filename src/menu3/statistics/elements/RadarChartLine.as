// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.statistics.elements.RadarChartLine

package menu3.statistics.elements {
import flash.display.Sprite;
import flash.display.LineScaleMode;
import flash.display.CapsStyle;
import flash.display.JointStyle;

public class RadarChartLine extends Sprite {

	private var size:Number = 0;

	public function RadarChartLine(_arg_1:Number) {
		this.size = _arg_1;
		graphics.lineStyle(1, 0xFFFFFF, 0.5, true, LineScaleMode.NONE, CapsStyle.NONE, JointStyle.MITER, 10);
		graphics.moveTo(0, -10);
		graphics.lineTo(0, -(_arg_1));
	}

}
}//package menu3.statistics.elements

