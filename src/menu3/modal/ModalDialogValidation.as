// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.modal.ModalDialogValidation

package menu3.modal {
public class ModalDialogValidation {

	protected var message:String;
	protected var level:int;
	protected var minChars:int = 0;

	public function ModalDialogValidation(_arg_1:Object) {
		this.level = ((_arg_1.level == null) ? 0 : _arg_1.level);
		this.minChars = ((_arg_1.minChars == null) ? 0 : _arg_1.minChars);
		this.message = _arg_1.message;
	}

	public function getMessage():String {
		return (this.message);
	}

	public function getLevel():int {
		return (this.level);
	}

	public function validate(_arg_1:String):Boolean {
		if (((this.minChars == 0) && (_arg_1 == null))) {
			return (true);
		}

		if (_arg_1 == null) {
			return (false);
		}

		return (_arg_1.length >= this.minChars);
	}


}
}//package menu3.modal

