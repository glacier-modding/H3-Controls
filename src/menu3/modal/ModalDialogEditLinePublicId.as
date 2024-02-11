// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.modal.ModalDialogEditLinePublicId

package menu3.modal {
import common.Log;

public class ModalDialogEditLinePublicId extends ModalDialogGenericEditLine {

	private const PUBLICID_DEFAULT_LENGTH:int = 12;

	private var m_failedValidation:ModalDialogValidation = null;
	private var m_publicIdLength:int = 12;
	private var m_unformattedInput:String = "";

	public function ModalDialogEditLinePublicId(_arg_1:Object) {
		super(_arg_1);
	}

	override public function onSetData(_arg_1:Object):void {
		this.m_publicIdLength = this.PUBLICID_DEFAULT_LENGTH;
		var _local_2:int = this.m_publicIdLength;
		_local_2 = (_local_2 + 3);
		_arg_1.maxChars = _local_2;
		super.onSetData(_arg_1);
	}

	override public function setButtonData(_arg_1:Array):void {
		super.setButtonData(_arg_1);
		this.updateState();
	}

	override protected function onTextInputChange():void {
		this.updateState();
		var _local_1:Boolean = checkSubmitValidators();
		if (((_local_1) && (!(getSubmitButton() == null)))) {
			m_callbackSendEvent("onElementDown");
		}
		;
	}

	private function updateState():void {
		this.m_unformattedInput = this.getDescriptionText();
		var _local_1:String = this.formatInputString(this.m_unformattedInput);
		Log.xinfo(Log.ChannelModal, (((((("formatInputString: rawInput='" + super.getDescriptionText()) + "' unformatted='") + this.m_unformattedInput) + "' formatted='") + _local_1) + "'"));
		updateInputField(_local_1);
		super.onTextInputChange();
	}

	override protected function updateTitle():void {
		setTitle(((((((getOriginalTitle() + " ") + "[") + this.m_unformattedInput.length) + "/") + this.m_publicIdLength) + "]"));
	}

	override protected function getDescriptionText():String {
		var _local_1:String = super.getDescriptionText();
		var _local_2:RegExp = /[^0-9]/g;
		return (_local_1.replace(_local_2, "").substr(0, this.m_publicIdLength));
	}

	private function formatInputString(_arg_1:String):String {
		var _local_4:int;
		var _local_2:* = "";
		var _local_3:* = "-";
		_local_4 = 0;
		while (_local_4 < this.m_unformattedInput.length) {
			if ((((_local_4 == 1) || (_local_4 == 3)) || (_local_4 == 10))) {
				_local_2 = (_local_2 + _local_3);
			}
			;
			_local_2 = (_local_2 + this.m_unformattedInput.charAt(_local_4));
			_local_4++;
		}
		;
		return (_local_2);
	}

	override protected function setErrorMessage(_arg_1:ModalDialogValidation):void {
		super.setErrorMessage(_arg_1);
		this.m_failedValidation = _arg_1;
	}

	override protected function validate(_arg_1:String):void {
		super.validate(_arg_1);
		if (m_isValid) {
			m_isValid = (this.m_unformattedInput.length == this.m_publicIdLength);
		}
		;
	}


}
}//package menu3.modal

