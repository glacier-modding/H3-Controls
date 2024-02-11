// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.modal.ModalDialogFrameEdit

package menu3.modal {
import flash.text.TextField;

import common.InputTextFieldSpecialCharacterHandler;

import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.Event;
import flash.external.ExternalInterface;

import common.CommonUtils;
import common.Log;
import common.menu.MenuConstants;

public class ModalDialogFrameEdit extends ModalDialogFrameInformation implements ISubmitValidator {

	protected var m_isValid:Boolean = true;
	private var m_originalTitle:String;
	private var m_defaultString:String;
	private var m_defaultStringUnformatted:String;
	private var m_errorMessage:String;
	private var m_validator:ModalDialogValidator;
	private var m_bUseHTMLText:Boolean;
	private var m_inputField:TextField;
	private var m_specialCharacterHandler:InputTextFieldSpecialCharacterHandler;

	public function ModalDialogFrameEdit(_arg_1:Object) {
		super(_arg_1);
		m_dialogInformation.CanSelectContent = true;
		m_dialogInformation.ContentIsTextEdit = true;
	}

	public function isSubmitValid():Boolean {
		return (this.m_isValid);
	}

	protected function setInputTextField(_arg_1:TextField):void {
		this.m_inputField = _arg_1;
		this.m_specialCharacterHandler = new InputTextFieldSpecialCharacterHandler(this.m_inputField);
		this.m_specialCharacterHandler.setActive(true);
		this.m_inputField.addEventListener(KeyboardEvent.KEY_DOWN, this.checkTextInputDone);
		this.m_inputField.addEventListener(MouseEvent.MOUSE_OVER, this.contentMouseEvent);
		this.m_inputField.addEventListener(MouseEvent.MOUSE_DOWN, this.contentMouseEvent);
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		m_selectableElements.push(this);
		m_submitValidators.push(this);
		this.m_bUseHTMLText = _arg_1.usehtmltext;
		this.m_inputField.maxChars = ((_arg_1.maxChars > 0) ? _arg_1.maxChars : 4000);
		this.m_inputField.restrict = ((_arg_1.restrict != null) ? _arg_1.restrict : null);
		this.m_inputField.multiline = ((_arg_1.multiline != null) ? _arg_1.multiline : true);
		if (_arg_1.subtitle) {
			this.m_originalTitle = _arg_1.subtitle;
		} else {
			if (_arg_1.title) {
				this.m_originalTitle = _arg_1.title;
			}

		}

		if (_arg_1.description) {
			this.setDescription(_arg_1.description);
		} else {
			if (_arg_1.placeholder) {
				this.setDescription(_arg_1.placeholder);
				this.m_defaultString = this.getDescriptionText();
				this.m_defaultStringUnformatted = _arg_1.placeholder;
			} else {
				this.setDescription("");
			}

		}

		this.m_validator = new ModalDialogValidator(_arg_1.validation);
		this.setErrorMessage(null);
		this.onTextInputChange();
		this.m_inputField.addEventListener(Event.CHANGE, this.textInputChange);
	}

	protected function getOriginalTitle():String {
		return (this.m_originalTitle);
	}

	override public function hide():void {
		var _local_1:* = "";
		if (((this.m_errorMessage == null) || (this.m_errorMessage.length == 0))) {
			_local_1 = ((this.getDescriptionText() == this.m_defaultString) ? this.m_defaultStringUnformatted : this.m_inputField.text);
		}

		ExternalInterface.call("ModalDialogHide", _local_1);
	}

	public function setDescription(_arg_1:String):void {
		this.setInputFieldText(_arg_1);
		CommonUtils.changeFontToGlobalIfNeeded(this.m_inputField);
		this.onTextInputChange();
	}

	protected function updateInputField(_arg_1:String):void {
		var _local_2:int = this.m_inputField.length;
		this.m_inputField.text = _arg_1;
		if (this.m_inputField.caretIndex >= _local_2) {
			this.m_inputField.setSelection(_arg_1.length, _arg_1.length);
		}

	}

	override protected function setItemSelected(_arg_1:Boolean):void {
		super.setItemSelected(_arg_1);
		if (_arg_1) {
			this.setDescriptionStageFocusDelayed();
			if (this.getDescriptionText() == this.m_defaultString) {
				this.m_inputField.setSelection(0, this.m_inputField.text.length);
			} else {
				this.m_inputField.setSelection(this.m_inputField.text.length, this.m_inputField.text.length);
			}

			ExternalInterface.call("ModalDialogTextFieldSelected", true, this.getDescriptionText(), this.m_defaultStringUnformatted);
		} else {
			this.removeDescriptionStageFocus();
			ExternalInterface.call("ModalDialogTextFieldSelected", false);
		}

	}

	public function onTextFieldEdited(_arg_1:String):void {
		m_callbackSendEvent("onElementDown");
		this.setDescription(_arg_1);
	}

	private function textInputChange(_arg_1:Event):void {
		CommonUtils.changeFontToGlobalIfNeeded(this.m_inputField);
		this.onTextInputChange();
	}

	protected function onTextInputChange():void {
		this.updateTitle();
		this.validate(this.m_inputField.text);
	}

	protected function updateTitle():void {
		this.setTitle(((((((this.m_originalTitle + " ") + "[") + this.m_inputField.text.length) + "/") + this.m_inputField.maxChars) + "]"));
	}

	protected function getDescriptionText():String {
		return (this.m_inputField.text);
	}

	private function setDescriptionStageFocusDelayed():void {
		this.m_inputField.addEventListener(Event.ENTER_FRAME, this.onSetDescriptionStageFocus);
	}

	private function removeDescriptionStageFocus():void {
		if (this.m_inputField.hasEventListener(Event.ENTER_FRAME)) {
			this.m_inputField.removeEventListener(Event.ENTER_FRAME, this.onSetDescriptionStageFocus);
		}

		stage.focus = null;
	}

	private function onSetDescriptionStageFocus(_arg_1:Event):void {
		this.m_inputField.removeEventListener(Event.ENTER_FRAME, this.onSetDescriptionStageFocus);
		stage.focus = this.m_inputField;
	}

	protected function setTitle(_arg_1:String):void {
	}

	protected function setInputFieldText(_arg_1:String):void {
	}

	protected function setErrorMessage(_arg_1:ModalDialogValidation):void {
		if (_arg_1 == null) {
			this.m_errorMessage = "";
		} else {
			this.m_errorMessage = _arg_1.getMessage();
		}

	}

	protected function validate(_arg_1:String):void {
		this.m_isValid = true;
		if (this.m_validator == null) {
			return;
		}

		var _local_2:ModalDialogValidation = this.m_validator.validate(_arg_1);
		this.setErrorMessage(_local_2);
		this.m_isValid = (_local_2 == null);
		updateSubmitEnabled();
	}

	private function checkTextInputDone(_arg_1:KeyboardEvent):void {
		Log.xinfo(Log.ChannelModal, ("ModalDialog checkTextInputDone: keyCode=" + _arg_1.keyCode));
		if (m_buttonCount <= 0) {
			return;
		}

		if (!this.m_inputField.multiline) {
			if (_arg_1.keyCode == MenuConstants.KEYCODE_ENTER) {
				_arg_1.stopImmediatePropagation();
				if (this.isSubmitValid()) {
					m_callbackSendEvent("onElementDown");
				}

				return;
			}

		}

		if (((_arg_1.keyCode == MenuConstants.KEYCODE_RIGHT) || (_arg_1.keyCode == MenuConstants.KEYCODE_DOWN))) {
			if (((this.m_inputField.caretIndex >= this.m_inputField.length) && (!(_arg_1.shiftKey)))) {
				_arg_1.stopImmediatePropagation();
				m_callbackSendEvent("onElementDown");
			}

		} else {
			if (((_arg_1.keyCode == MenuConstants.KEYCODE_ESC) || ((CommonUtils.getPlatformString() == CommonUtils.PLATFORM_STADIA) && (_arg_1.keyCode == MenuConstants.KEYCODE_TAB)))) {
				_arg_1.stopImmediatePropagation();
				m_callbackSendEventWithValue("onElementOver", m_cancelButtonIndex);
			}

		}

	}

	private function contentMouseEvent(_arg_1:MouseEvent):void {
		_arg_1.stopImmediatePropagation();
		m_callbackSendEventWithValue("onElementOver", -1);
	}


}
}//package menu3.modal

