// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.indicator.IndicatorBase

package menu3.indicator {
import menu3.basic.TextTickerUtil;

import common.Animate;
import common.menu.MenuConstants;

public class IndicatorBase implements IIndicator {

	protected var m_indicatorView:* = null;
	protected var m_textTickerUtil:TextTickerUtil = new TextTickerUtil();


	public function onSetData(_arg_1:*, _arg_2:Object):void {
		_arg_1.addChild(this.m_indicatorView);
	}

	public function onUnregister():void {
		if (this.m_textTickerUtil != null) {
			this.m_textTickerUtil.onUnregister();
			this.m_textTickerUtil = null;
		}
		;
		if (this.m_indicatorView == null) {
			return;
		}
		;
		if (this.m_indicatorView.parent != null) {
			this.m_indicatorView.parent.removeChild(this.m_indicatorView);
		}
		;
		this.m_indicatorView = null;
	}

	public function callTextTicker(_arg_1:Boolean):void {
		this.m_textTickerUtil.callTextTicker(_arg_1);
	}

	public function setVisible(_arg_1:Boolean):void {
		Animate.kill(this.m_indicatorView);
		this.m_indicatorView.alpha = 0;
		if (_arg_1) {
			Animate.to(this.m_indicatorView, MenuConstants.HiliteTime, 0, {"alpha": 1}, Animate.Linear);
		}
		;
	}


}
}//package menu3.indicator

