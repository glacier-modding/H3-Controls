// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.indicator.IndicatorUtil

package menu3.indicator {
import flash.utils.Dictionary;

public class IndicatorUtil {

	private var m_indicators:Dictionary = new Dictionary();


	public function getIndicator(_arg_1:int):IIndicator {
		if ((_arg_1 in this.m_indicators)) {
			return (this.m_indicators[_arg_1]);
		}
		;
		return (null);
	}

	public function add(_arg_1:int, _arg_2:IIndicator, _arg_3:*, _arg_4:Object):void {
		_arg_2.onSetData(_arg_3, _arg_4);
		this.m_indicators[_arg_1] = _arg_2;
	}

	public function clearIndicators():void {
		var _local_1:IIndicator;
		for each (_local_1 in this.m_indicators) {
			_local_1.onUnregister();
		}
		;
		this.m_indicators = new Dictionary();
	}

	public function callTextTickers(_arg_1:Boolean):void {
		var _local_2:IIndicator;
		for each (_local_2 in this.m_indicators) {
			_local_2.callTextTicker(_arg_1);
		}
		;
	}


}
}//package menu3.indicator

