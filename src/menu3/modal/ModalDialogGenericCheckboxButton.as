// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.modal.ModalDialogGenericCheckboxButton

package menu3.modal {
import common.menu.MenuUtils;
import common.menu.MenuConstants;

public dynamic class ModalDialogGenericCheckboxButton extends ModalDialogGenericButton implements ISubmitValidator {

	private var m_updateSubmitEnabled:Function;
	private var m_isChecked:Boolean = false;

	public function ModalDialogGenericCheckboxButton(_arg_1:Object) {
		super(_arg_1);
	}

	public function setModalCallbacks(_arg_1:Function):void {
		this.m_updateSubmitEnabled = _arg_1;
	}

	override public function onCreationDone():void {
		super.onCreationDone();
		this.updateState();
	}

	override public function onPressed():void {
		super.onPressed();
		this.m_isChecked = (!(this.m_isChecked));
		this.updateState();
	}

	override public function onUnregister():void {
		super.onUnregister();
	}

	override public function setSelectedAnimationState(_arg_1:int):void {
		super.setSelectedAnimationState(_arg_1);
		if (((m_isSelected) && (!(this.m_isChecked)))) {
			MenuUtils.setupIcon(m_view.tileIcon, m_iconLabel, MenuConstants.COLOR_WHITE, true, false);
		}

		m_view.tileIcon.icons.visible = this.m_isChecked;
	}

	public function isSubmitValid():Boolean {
		return (this.m_isChecked);
	}

	private function updateState():void {
		var _local_1:int = STATE_DEFAULT;
		if (m_isSelected) {
			_local_1 = STATE_SELECTED;
		}

		this.setSelectedAnimationState(_local_1);
		if (this.m_updateSubmitEnabled != null) {
			this.m_updateSubmitEnabled();
		}

	}


}
}//package menu3.modal

