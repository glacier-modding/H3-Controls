// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.indicator.NoVRIndicator

package menu3.indicator {
import common.menu.MenuConstants;

public class NoVRIndicator extends IndicatorBase {

	public function NoVRIndicator(_arg_1:Number, _arg_2:Number) {
		m_indicatorView = new NoVRIndicatorView();
		m_indicatorView.x = (_arg_1 - MenuConstants.VRIndicatorXOffset);
		m_indicatorView.y = MenuConstants.VRIndicatorYOffset;
	}

}
}//package menu3.indicator

