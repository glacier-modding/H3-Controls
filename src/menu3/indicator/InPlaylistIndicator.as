// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.indicator.InPlaylistIndicator

package menu3.indicator {
public class InPlaylistIndicator extends IndicatorBase {

	public function InPlaylistIndicator(_arg_1:Number, _arg_2:Number) {
		m_indicatorView = new InPlaylistIndicatorView();
		m_indicatorView.x = (_arg_1 - 52);
		m_indicatorView.y = 0;
	}

	public function markForDeletion(_arg_1:Boolean):void {
		if (_arg_1) {
			m_indicatorView.icon.gotoAndStop(2);
			m_indicatorView.bg.gotoAndStop(2);
		} else {
			m_indicatorView.icon.gotoAndStop(1);
			m_indicatorView.bg.gotoAndStop(1);
		}

	}

	public function setColorInvert(_arg_1:Boolean):void {
	}


}
}//package menu3.indicator

