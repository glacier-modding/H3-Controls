// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//basic.ButtonPromptContainer

package basic {
import flash.display.Sprite;

import common.Log;
import common.menu.MenuConstants;

public class ButtonPromptContainer extends Sprite {

	public function ButtonPromptContainer(_arg_1:Object, _arg_2:Boolean = false, _arg_3:Function = null) {
		if (_arg_2) {
			this.addTabNavigationLayout(_arg_1, _arg_3);
		} else {
			this.addRegularButtonPrompts(_arg_1, _arg_3);
		}

	}

	private function addTabNavigationLayout(_arg_1:Object, _arg_2:Function):void {
		var _local_5:Object;
		var _local_6:ActionType;
		var _local_7:int;
		var _local_8:Object;
		var _local_9:Object;
		var _local_10:Number;
		var _local_3:Number = 0;
		var _local_4:int;
		while (_local_4 < _arg_1.buttonprompts.length) {
			_local_5 = _arg_1.buttonprompts[_local_4];
			_local_6 = this.getActionType(_local_5);
			if (_local_6.actionTypes == null) {
				Log.xerror(Log.ChannelButtonPrompt, "TabNav: no action types found ...");
			} else {
				_local_7 = 0;
				while (_local_7 < _local_6.actionTypes.length) {
					_local_8 = _local_6.actionTypes[_local_7];
					_local_3 = (_local_3 - 62);
					_local_9 = {
						"actiontype": _local_8.name,
						"hidePrompt": _local_8.hidePrompt,
						"actionlabel": "",
						"transparentPrompt": _local_8.transparentPrompt,
						"disabledPrompt": _local_8.disabledPrompt
					};
					_local_10 = this.addTabPrompt(_local_3, _local_9, _arg_2);
					_local_3 = (_local_3 + Math.ceil(((MenuConstants.CategoryElementWidth + (2 * 62)) + 10)));
					_local_7++;
				}

			}

			_local_4++;
		}

	}

	private function addRegularButtonPrompts(_arg_1:Object, _arg_2:Function):void {
		var _local_4:Number;
		var _local_6:Object;
		var _local_7:ActionType;
		var _local_8:int;
		var _local_9:Object;
		var _local_10:Boolean;
		var _local_11:Object;
		var _local_3:Number = 0;
		var _local_5:int;
		while (_local_5 < _arg_1.buttonprompts.length) {
			_local_6 = _arg_1.buttonprompts[_local_5];
			if (!ButtonPrompt.shouldSkipPrompt(_local_6)) {
				_local_7 = this.getActionType(_local_6);
				if (_local_7.actionType != null) {
					_local_4 = this.addPrompt(_local_3, _local_6, _arg_2);
					_local_3 = (_local_3 + Math.ceil((_local_4 + MenuConstants.ButtonPromptsXOffset)));
				} else {
					if (_local_7.actionTypes != null) {
						_local_8 = 0;
						while (_local_8 < _local_7.actionTypes.length) {
							_local_9 = _local_7.actionTypes[_local_8];
							_local_10 = (_local_8 == (_local_7.actionTypes.length - 1));
							_local_11 = {
								"actiontype": _local_9.name,
								"hidePrompt": _local_9.hidePrompt,
								"actionlabel": ((_local_10) ? _local_6.actionlabel : ""),
								"transparentPrompt": _local_9.transparentPrompt,
								"disabledPrompt": _local_9.disabledPrompt
							};
							_local_4 = this.addPrompt(_local_3, _local_11, _arg_2);
							_local_3 = (_local_3 + Math.ceil((_local_4 + MenuConstants.ButtonPromptsXOffset)));
							_local_8++;
						}

					}

				}

			}

			_local_5++;
		}

	}

	private function addPrompt(_arg_1:Number, _arg_2:Object, _arg_3:Function):Number {
		var _local_4:ButtonPrompt = new ButtonPrompt(_arg_2, false, _arg_3, _arg_1, true);
		addChild(_local_4);
		return (_local_4.getWidth());
	}

	private function addTabPrompt(_arg_1:Number, _arg_2:Object, _arg_3:Function):Number {
		var _local_4:ButtonPrompt = new ButtonPrompt(_arg_2, true, _arg_3, _arg_1);
		addChild(_local_4);
		return (_local_4.getWidth());
	}

	private function getActionType(_arg_1:Object):ActionType {
		var _local_3:Object;
		var _local_2:ActionType = new ActionType();
		if (((_arg_1 == null) || (_arg_1.actiontype == null))) {
			return (_local_2);
		}

		if (typeof (_arg_1.actiontype) == "string") {
			_local_2.actionType = _arg_1.actiontype;
		} else {
			if (typeof (_arg_1.actiontype) == "object") {
				_local_2.actionTypes = [];
				for each (_local_3 in _arg_1.actiontype) {
					if ((_local_3 is String)) {
						_local_2.actionTypes.push({
							"name": (_local_3 as String),
							"hidePrompt": false
						});
					} else {
						_local_2.actionTypes.push(_local_3);
					}

				}

			}

		}

		return (_local_2);
	}

	public function onUnregister():void {
		var _local_1:ButtonPrompt;
		while (numChildren > 0) {
			_local_1 = (getChildAt(0) as ButtonPrompt);
			if (_local_1 != null) {
				_local_1.onUnregister();
			}

			removeChildAt(0);
		}

	}


}
}//package basic

class ActionType {

	public var actionType:String = null;
	public var actionTypes:Array = null;


}


