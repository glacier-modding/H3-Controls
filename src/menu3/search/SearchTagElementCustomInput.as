// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.search.SearchTagElementCustomInput

package menu3.search {
import common.InputTextFieldSpecialCharacterHandler;
import common.CommonUtils;

import flash.text.TextFieldType;
import flash.events.Event;
import flash.events.MouseEvent;

import mx.utils.StringUtil;

import common.Log;
import common.menu.MenuConstants;

import flash.events.KeyboardEvent;

public dynamic class SearchTagElementCustomInput extends SearchTagElementCustom {

	private var m_currentState:int = 0;
	private var m_sendEventWithValue:Function = null;
	private var m_allowKeyboardInput:Boolean = false;
	private var m_specialCharacterHandler:InputTextFieldSpecialCharacterHandler;

	public function SearchTagElementCustomInput(_arg_1:Object) {
		super(_arg_1);
		this.m_specialCharacterHandler = new InputTextFieldSpecialCharacterHandler(InputTextField);
	}

	private static function isRequiredExplicitTextFocus():Boolean {
		var _local_1:int;
		_local_1 = ControlsMain.getMenuInputCapabilities();
		var _local_2:Boolean = Boolean((_local_1 & ControlsMain.MENUINPUTCAPABILITY_TEXTINPUT_VIA_PHYSICAL_KEYBOARD));
		var _local_3:Boolean = Boolean((_local_1 & ControlsMain.MENUINPUTCAPABILITY_TEXTINPUT_VIA_VIRTUAL_KEYBOARD));
		return (((_local_2) && (_local_3)) && (!(ControlsMain.getControllerType() == CommonUtils.CONTROLLER_TYPE_KEY)));
	}


	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		m_isElementActive = false;
		this.updateState();
	}

	override public function onUnregister():void {
		this.m_allowKeyboardInput = false;
		this.removeDescriptionStageFocus();
		this.m_specialCharacterHandler.onUnregister();
		super.onUnregister();
	}

	override protected function setupInputTextField(_arg_1:Object):void {
		super.setupInputTextField(_arg_1);
		this.m_allowKeyboardInput = false;
		this.captureKeyboardInput(false);
		if (getNodeProp(this, "pressable") == true) {
			trace("SearchTagElementCustomInput INPUT");
			InputTextField.selectable = true;
			InputTextField.type = TextFieldType.INPUT;
			this.m_allowKeyboardInput = true;
		}
		;
		InputTextField.text = "";
		if (_arg_1.maxchars != undefined) {
			InputTextField.maxChars = _arg_1.maxchars;
		}
		;
		InputTextField.addEventListener(Event.CHANGE, this.textInputChange);
	}

	override protected function setState(_arg_1:int):void {
		if (this.m_currentState != _arg_1) {
			this.m_currentState = _arg_1;
			if (((isRequiredExplicitTextFocus()) || (!((_arg_1 == STATE_SELECT) || (_arg_1 == STATE_ACTIVE_SELECT))))) {
				this.removeDescriptionStageFocus();
			} else {
				this.setDescriptionStageFocusDelayed();
			}
			;
		}
		;
		super.setState(_arg_1);
	}

	override protected function setupTitleTextField(_arg_1:String):void {
	}

	override public function setEngineCallbacks(_arg_1:Function, _arg_2:Function):void {
		this.m_sendEventWithValue = _arg_2;
	}

	override public function handleMouseUp(_arg_1:Function, _arg_2:MouseEvent):void {
		trace(("handleMouseUp InputTextField: " + InputTextField.type));
		if (((this.m_currentState == STATE_SELECT) || (this.m_currentState == STATE_ACTIVE_SELECT))) {
			stage.focus = InputTextField;
		}
		;
	}

	public function doTextFieldAccept():void {
		if (((isRequiredExplicitTextFocus()) && (!(stage.focus == InputTextField)))) {
			this.setDescriptionStageFocusDelayed();
		} else {
			this.onTextFieldEdited(InputTextField.text);
		}
		;
	}

	public function onTextFieldEdited(_arg_1:String):void {
		var _local_4:Array;
		if (!this.m_allowKeyboardInput) {
			return;
		}
		;
		if (!this["_nodedata"]) {
			return;
		}
		;
		if (this.m_sendEventWithValue == null) {
			return;
		}
		;
		var _local_2:int = (this["_nodedata"]["id"] as int);
		var _local_3:String = StringUtil.trim(_arg_1.replace(/[\r\n\x08]+/g, ""));
		if (_local_3.length <= 0) {
			this.m_sendEventWithValue("onElementDown", _local_2);
		} else {
			_local_4 = new Array(_local_2, _local_3);
			Log.info(Log.ChannelDebug, this, ("sending input " + _local_3));
			this.m_sendEventWithValue("onInputEntered", _local_4);
		}
		;
		InputTextField.text = "";
	}

	override protected function updateState():void {
		if (!this.m_allowKeyboardInput) {
			this.setState(STATE_DISABLED);
		} else {
			super.updateState();
		}
		;
	}

	override public function onAcceptPressed():void {
	}

	override public function onCancelPressed():void {
	}

	private function setDescriptionStageFocusDelayed():void {
		if (InputTextField.hasEventListener(Event.ENTER_FRAME)) {
			return;
		}
		;
		InputTextField.addEventListener(Event.ENTER_FRAME, this.onSetDescriptionStageFocus);
	}

	private function removeDescriptionStageFocus():void {
		if (InputTextField.hasEventListener(Event.ENTER_FRAME)) {
			InputTextField.removeEventListener(Event.ENTER_FRAME, this.onSetDescriptionStageFocus);
		}
		;
		if (stage) {
			stage.focus = null;
		}
		;
		this.captureKeyboardInput(false);
	}

	private function onSetDescriptionStageFocus(_arg_1:Event):void {
		InputTextField.removeEventListener(Event.ENTER_FRAME, this.onSetDescriptionStageFocus);
		stage.focus = InputTextField;
		if (this.m_allowKeyboardInput) {
			this.captureKeyboardInput(true);
		}
		;
	}

	private function textInputChange(_arg_1:Event):void {
		CommonUtils.changeFontToGlobalIfNeeded(InputTextField);
	}

	private function onKeyDownHandler(_arg_1:KeyboardEvent):void {
		var _local_3:Array;
		if (!this["_nodedata"]) {
			return;
		}
		;
		if (this.m_sendEventWithValue == null) {
			return;
		}
		;
		var _local_2:int = (this["_nodedata"]["id"] as int);
		if (_arg_1.keyCode == MenuConstants.KEYCODE_ESC) {
			this.m_sendEventWithValue("onElementCancel", _local_2);
			if (isRequiredExplicitTextFocus()) {
				this.removeDescriptionStageFocus();
			}
			;
			return;
		}
		;
		if (_arg_1.keyCode == MenuConstants.KEYCODE_F1) {
			_local_3 = new Array(_local_2, "action-select");
			this.m_sendEventWithValue("onTriggerAction", _local_3);
			return;
		}
		;
		if (((_arg_1.keyCode == MenuConstants.KEYCODE_RIGHT) || (_arg_1.keyCode == MenuConstants.KEYCODE_DOWN))) {
			if (((InputTextField.caretIndex >= InputTextField.length) && (!(_arg_1.shiftKey)))) {
				if (_arg_1.keyCode == MenuConstants.KEYCODE_RIGHT) {
					this.m_sendEventWithValue("onElementNext", _local_2);
				} else {
					this.m_sendEventWithValue("onElementDown", _local_2);
				}
				;
				return;
			}
			;
		}
		;
		if (_arg_1.keyCode == MenuConstants.KEYCODE_ENTER) {
			this.doTextFieldAccept();
		}
		;
	}

	private function captureKeyboardInput(_arg_1:Boolean):void {
		this.m_sendEventWithValue("enableKeyboardInput", (!(_arg_1)));
		this.m_specialCharacterHandler.setActive(_arg_1);
		if (_arg_1) {
			InputTextField.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDownHandler);
		} else {
			InputTextField.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDownHandler);
		}
		;
	}


}
}//package menu3.search

