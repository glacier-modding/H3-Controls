// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.modal.ModalDialogValidator

package menu3.modal {
import common.Log;

public class ModalDialogValidator {

	private var m_validators:Array = [];

	public function ModalDialogValidator(_arg_1:Array) {
		var _local_2:Object;
		var _local_3:String;
		var _local_4:ModalDialogValidation;
		var _local_5:Object;
		var _local_6:String;
		super();
		if (_arg_1 == null) {
			Log.info(Log.ChannelModal, this, "No validation data - dialog Validation disabled");
			return;
		}

		Log.info(Log.ChannelModal, this, "Found a validation array");
		for each (_local_2 in _arg_1) {
			_local_3 = _local_2.type;
			if (((_local_3 == null) || (_local_3.length == 0))) {
				_local_3 = "regex";
			}

			_local_4 = null;
			switch (_local_3) {
				case "regex":
					_local_5 = _local_2.regEx;
					if ((((!(_local_5 == null)) && (!(_local_5.source == undefined))) && (!(_local_5.flags == undefined)))) {
						_local_4 = new ModalDialogRegexValidation(_local_2, _local_5);
					} else {
						Log.xerror(Log.ChannelModal, "regex validator definition not valid");
						Log.debugData(this, _local_2);
					}

					break;
				case "platformid":
					_local_6 = _local_2.platformid;
					if (_local_6 != null) {
						_local_4 = new ModalDialogPlatformIdValidation(_local_2, _local_6);
					} else {
						Log.xerror(Log.ChannelModal, "platformid validator definition not valid");
						Log.debugData(this, _local_2);
					}

					break;
			}

			if (_local_4 != null) {
				this.m_validators.push(_local_4);
			}

		}

	}

	public function validate(_arg_1:String):ModalDialogValidation {
		var _local_3:ModalDialogValidation;
		var _local_2:ModalDialogValidation;
		for each (_local_3 in this.m_validators) {
			if (!_local_3.validate(_arg_1)) {
				if (((_local_2 == null) || (_local_2.getLevel() < _local_3.getLevel()))) {
					_local_2 = _local_3;
				}

			}

		}

		if (_local_2 != null) {
			Log.xinfo(Log.ChannelModal, (((((("returning validator that failed on '" + _arg_1) + "' level=") + _local_2.getLevel()) + " message='") + _local_2.getMessage()) + "'"));
		}

		return (_local_2);
	}


}
}//package menu3.modal

