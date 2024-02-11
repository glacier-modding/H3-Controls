// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.modal.ModalDialogRegexValidation

package menu3.modal {
public class ModalDialogRegexValidation extends ModalDialogValidation {

	public var regEx:RegExp;

	public function ModalDialogRegexValidation(_arg_1:Object, _arg_2:Object):void {
		super(_arg_1);
		this.regEx = new RegExp(_arg_2.source, _arg_2.flags);
	}

	override public function validate(_arg_1:String):Boolean {
		if (!super.validate(_arg_1)) {
			return (false);
		}
		;
		this.regEx.lastIndex = 0;
		return (this.regEx.test(_arg_1));
	}


}
}//package menu3.modal

