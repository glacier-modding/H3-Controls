// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.indicator.ValueIndicatorBase

package menu3.indicator {
import common.menu.MenuConstants;

public class ValueIndicatorBase extends IndicatorBase {

	public function ValueIndicatorBase(_arg_1:String, _arg_2:Number) {
		switch (_arg_1) {
			case "large":
				m_indicatorView = new ValueIndicatorLargeView();
				break;
			default:
				m_indicatorView = new ValueIndicatorSmallView();
		}
		;
		m_indicatorView.y = (_arg_2 - MenuConstants.ValueIndicatorYOffset);
	}

}
}//package menu3.indicator

