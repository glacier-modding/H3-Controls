// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//basic.Gradient

package basic {
import common.BaseControl;

public class Gradient extends BaseControl {

	private var m_view:GradientView;

	public function Gradient() {
		this.m_view = new GradientView();
		this.m_view.alpha = 0.5;
		this.m_view.gotoAndStop(1);
		addChild(this.m_view);
	}

	override public function onSetSize(_arg_1:Number, _arg_2:Number):void {
		this.m_view.width = _arg_1;
		this.m_view.height = _arg_2;
	}


}
}//package basic

