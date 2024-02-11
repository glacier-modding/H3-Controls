// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.indicator.CompletionStatusIndicatorUtil

package menu3.indicator {
import flash.display.MovieClip;

import common.menu.MenuUtils;
import common.menu.MenuConstants;

public class CompletionStatusIndicatorUtil {

	public static const StatusIndicatorOffset:Number = 36;


	public static function removeIndicator(_arg_1:Object):void {
		if (!_arg_1.hasOwnProperty("completionStatusIndicator")) {
			return;
		}

		if (_arg_1.completionStatusIndicator == null) {
			return;
		}

		_arg_1.removeChild(_arg_1.completionStatusIndicator);
		_arg_1.completionStatusIndicator = null;
	}

	public static function addIndicator(_arg_1:Object, _arg_2:String, _arg_3:int = -1, _arg_4:int = -1):void {
		removeIndicator(_arg_1);
		var _local_5:MovieClip = new iconsAll40x40View();
		MenuUtils.setupIcon(_local_5, _arg_2, MenuConstants.COLOR_GREY_DARK, false, true, MenuConstants.COLOR_WHITE);
		_local_5.x = ((_arg_3 == -1) ? StatusIndicatorOffset : _arg_3);
		_local_5.y = ((_arg_4 == -1) ? StatusIndicatorOffset : _arg_4);
		_arg_1.completionStatusIndicator = _local_5;
		_arg_1.addChild(_local_5);
	}


}
}//package menu3.indicator

