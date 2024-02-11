// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//basic.ButtonPromtUtil

package basic {
import __AS3__.vec.Vector;
import __AS3__.vec.*;

public class ButtonPromtUtil {

	private static var s_buttonPromptOwners:Vector.<IButtonPromptOwner> = new Vector.<IButtonPromptOwner>();


	public static function registerButtonPromptOwner(_arg_1:IButtonPromptOwner):void {
		s_buttonPromptOwners.push(_arg_1);
	}

	public static function unregisterButtonPromptOwner(_arg_1:IButtonPromptOwner):void {
		var _local_2:int;
		while (_local_2 < s_buttonPromptOwners.length) {
			if (s_buttonPromptOwners[_local_2] == _arg_1) {
				s_buttonPromptOwners.splice(_local_2, 1);
			} else {
				_local_2++;
			}

		}

	}

	public static function updateButtonPromptOwners():void {
		var _local_1:IButtonPromptOwner;
		for each (_local_1 in s_buttonPromptOwners) {
			_local_1.updateButtonPrompts();
		}

	}

	public static function handlePromptMouseEvent(_arg_1:Function, _arg_2:String):void {
		var _local_3:int = -1;
		if (_arg_2 == "cancel") {
			_local_3 = 0;
		}

		if (_arg_2 == "accept") {
			_local_3 = 1;
		}

		if (_arg_2 == "action-x") {
			_local_3 = 2;
		}

		if (_arg_2 == "action-y") {
			_local_3 = 5;
		}

		if (_arg_2 == "r") {
			_local_3 = 4;
		}

		if (_local_3 >= 0) {
			(_arg_1("onInputAction", _local_3));
		}

	}


}
}//package basic

