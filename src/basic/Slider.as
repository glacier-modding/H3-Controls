// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//basic.Slider

package basic {
import common.BaseControl;

public class Slider extends BaseControl {

	private var m_view:SliderView;

	public function Slider() {
		this.m_view = new SliderView();
		addChild(this.m_view);
	}

	override public function onSetSize(_arg_1:Number, _arg_2:Number):void {
		this.m_view.track_mc.width = _arg_1;
	}

	public function onSetValue(_arg_1:Number):void {
		this.m_view.thumb_mc.x = (_arg_1 * this.m_view.track_mc.width);
	}

	public function onSetData(_arg_1:Number):void {
		this.onSetValue(_arg_1);
	}


}
}//package basic

