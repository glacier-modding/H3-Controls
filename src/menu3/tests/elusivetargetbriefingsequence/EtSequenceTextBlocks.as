// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.tests.elusivetargetbriefingsequence.EtSequenceTextBlocks

package menu3.tests.elusivetargetbriefingsequence {
import common.menu.MenuConstants;

import flash.text.TextField;

import common.menu.MenuUtils;

public class EtSequenceTextBlocks {

	public static var m_unitWidth:Number = (MenuConstants.BaseWidth / 10);
	public static var m_unitHeight:Number = (MenuConstants.BaseHeight / 6);


	public static function setupTimerBlock(_arg_1:Object, _arg_2:*, _arg_3:*):void {
		var _local_4:TextField = new TextField();
		_local_4.name = "timerBlockHeaderTextField";
		_local_4.autoSize = "left";
		_local_4.x = -4;
		_local_4.y = -70;
		MenuUtils.setupText(_local_4, _arg_1.header, 60, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorBlack);
		_arg_2.addChild(_local_4);
		var _local_5:TextField = new TextField();
		_local_5.name = "timerBlockTimeTextField";
		_local_5.autoSize = "left";
		_local_5.x = -4;
		_local_5.y = -32;
		MenuUtils.setupText(_local_5, "", 148, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorGreyUltraLight);
		_arg_2.addChild(_local_5);
		if (_arg_1.playableUntil) {
			_arg_3.startCountDownTimer(_arg_1.playableUntil, _local_5, 148);
		}

	}


}
}//package menu3.tests.elusivetargetbriefingsequence

