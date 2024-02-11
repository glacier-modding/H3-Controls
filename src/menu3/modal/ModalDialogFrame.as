// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.modal.ModalDialogFrame

package menu3.modal {
import __AS3__.vec.Vector;

import common.menu.MenuConstants;
import common.Log;

import __AS3__.vec.*;

public class ModalDialogFrame extends ModalDialogContainerBase {

	protected var m_dialogWidth:Number;
	protected var m_dialogHeight:Number;
	protected var m_selectableElements:Array;
	protected var m_buttonCount:int = 0;
	protected var m_submitButtonIndex:int = 0;
	protected var m_cancelButtonIndex:int = 0;
	protected var m_submitValidators:Vector.<ISubmitValidator> = new Vector.<ISubmitValidator>();
	private var m_submitButton:ModalDialogGenericButton = null;
	private var m_fixedHeight:Number = -1;

	public function ModalDialogFrame(_arg_1:Object) {
		super(_arg_1);
		this.m_dialogWidth = _arg_1.dialogWidth;
		this.m_dialogHeight = _arg_1.dialogHeight;
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		this.m_selectableElements = new Array();
		this.m_submitValidators.length = 0;
		if (_arg_1.fixedheight) {
			this.m_fixedHeight = _arg_1.fixedheight;
		}
		;
	}

	override public function setButtonData(_arg_1:Array):void {
		super.setButtonData(_arg_1);
		var _local_2:Number = ((this.m_dialogHeight + MenuConstants.tileBorder) + (MenuConstants.tileGap * 12));
		var _local_3:Number = this.placeButtons(_arg_1, _local_2);
		if (_local_3 > 0) {
			this.m_dialogHeight = _local_3;
		}
		;
		this.updateSubmitEnabled();
	}

	override public function onButtonPressed(_arg_1:Number):void {
		super.onButtonPressed(_arg_1);
		if (this.m_selectableElements.length > _arg_1) {
			this.m_selectableElements[_arg_1].onPressed();
		}
		;
	}

	protected function onPressed():void {
	}

	override public function getModalHeight():Number {
		return (this.m_dialogHeight);
	}

	override public function getModalWidth():Number {
		return (this.m_dialogWidth);
	}

	override public function onSetItemSelected(_arg_1:int, _arg_2:Boolean):void {
		super.onSetItemSelected(_arg_1, _arg_2);
		if (this.m_selectableElements.length > _arg_1) {
			this.m_selectableElements[_arg_1].setItemSelected(_arg_2);
		}
		;
	}

	protected function setItemSelected(_arg_1:Boolean):void {
	}

	protected function updateDialogHeight(_arg_1:Number, _arg_2:Number, _arg_3:Number):Number {
		var _local_4:Number = 0;
		if (this.m_fixedHeight >= 0) {
			Log.xinfo(Log.ChannelModal, ("fixed height: " + this.m_fixedHeight));
			_local_4 = this.m_fixedHeight;
		} else {
			_local_4 = Math.ceil(_arg_1);
			_local_4 = Math.max(_local_4, _arg_2);
			_local_4 = Math.min(_local_4, _arg_3);
			Log.xinfo(Log.ChannelModal, ("dialogHeight height: " + _local_4));
		}
		;
		return (_local_4);
	}

	protected function getSubmitButton():ModalDialogGenericButton {
		return (this.m_submitButton);
	}

	public function updateSubmitEnabled():void {
		var _local_1:Boolean = this.checkSubmitValidators();
		this.setSubmitEnabled(_local_1);
	}

	protected function checkSubmitValidators():Boolean {
		var _local_1:Boolean = true;
		var _local_2:int;
		while (_local_2 < this.m_submitValidators.length) {
			_local_1 = ((_local_1) && (this.m_submitValidators[_local_2].isSubmitValid()));
			_local_2++;
		}
		;
		return (_local_1);
	}

	private function setSubmitEnabled(_arg_1:Boolean):void {
		var _local_2:ModalDialogGenericButton = this.getSubmitButton();
		if (_local_2 != null) {
			_local_2.setPressable(_arg_1);
		} else {
			Log.xinfo(Log.ChannelModal, "no submit button to update");
		}
		;
		m_callbackSendEventWithValue("onSubmitAllowedChanged", _arg_1);
	}

	private function placeButtons(_arg_1:Array, _arg_2:Number):Number {
		var _local_5:Object;
		var _local_6:ModalDialogGenericButton;
		var _local_7:ModalDialogGenericCheckboxButton;
		this.m_buttonCount = 0;
		if (((_arg_1 == null) || (_arg_1.length <= 0))) {
			Log.xinfo(Log.ChannelModal, "ModalDialogFrame: no button data found");
			return (-1);
		}
		;
		var _local_3:int;
		while (_local_3 < _arg_1.length) {
			_local_5 = _arg_1[_local_3];
			Log.xinfo(Log.ChannelModal, ("ModalDialogFrame: button: " + _local_5.title));
			_local_5.dialogWidth = this.m_dialogWidth;
			if (_local_5.type == "checkbox") {
				_local_7 = new ModalDialogGenericCheckboxButton(_local_5);
				_local_7.setModalCallbacks(this.updateSubmitEnabled);
				this.m_submitValidators.push(_local_7);
				_local_6 = _local_7;
			} else {
				_local_6 = new ModalDialogGenericButton(_local_5);
			}
			;
			_local_6.onSetData(_local_5);
			_local_6.x = -(MenuConstants.tileBorder);
			_local_6.y = _arg_2;
			addMouseEventListenersOnButton(_local_6, _local_3);
			this.m_selectableElements.push(_local_6);
			addChild(_local_6);
			_arg_2 = (_arg_2 + (_local_6.getView().height + (MenuConstants.tileGap * 10)));
			if (_local_5.type) {
				if (_local_5.type == "ok") {
					this.m_submitButtonIndex = _local_3;
					this.m_submitButton = _local_6;
				} else {
					if (_local_5.type == "cancel") {
						this.m_cancelButtonIndex = _local_3;
					}
					;
				}
				;
			}
			;
			_local_3++;
		}
		;
		this.m_buttonCount = _arg_1.length;
		var _local_4:int = (this.m_selectableElements.length - this.m_buttonCount);
		while (_local_4 < this.m_selectableElements.length) {
			this.m_selectableElements[_local_4].onCreationDone();
			_local_4++;
		}
		;
		return (_arg_2);
	}


}
}//package menu3.modal

