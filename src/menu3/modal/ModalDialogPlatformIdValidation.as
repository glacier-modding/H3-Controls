// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.modal.ModalDialogPlatformIdValidation

package menu3.modal {
import common.Log;

public class ModalDialogPlatformIdValidation extends ModalDialogValidation {

	private var m_platformId:String = "0";

	public function ModalDialogPlatformIdValidation(_arg_1:Object, _arg_2:String) {
		super(_arg_1);
		this.m_platformId = _arg_2;
		Log.xinfo(Log.ChannelModal, (("using platformid " + _arg_2) + " for validation"));
	}

	override public function validate(_arg_1:String):Boolean {
		if (!super.validate(_arg_1)) {
			return (false);
		}
		;
		if (((_arg_1 == null) || (_arg_1.length == 0))) {
			return (true);
		}
		;
		return (_arg_1.substr(0, 1) == this.m_platformId);
	}


}
}//package menu3.modal

