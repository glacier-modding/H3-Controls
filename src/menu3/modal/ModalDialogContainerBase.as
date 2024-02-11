// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.modal.ModalDialogContainerBase

package menu3.modal {
import menu3.MenuElementBase;

import flash.events.MouseEvent;
import flash.display.Sprite;

public class ModalDialogContainerBase extends MenuElementBase {

	protected var m_callbackSendEvent:Function;
	protected var m_callbackSendEventWithValue:Function;
	protected var m_dialogInformation:DialogInformation = new DialogInformation();
	protected var m_taskManagerEnqueue:Function = null;

	public function ModalDialogContainerBase(_arg_1:Object) {
		super(_arg_1);
	}

	override public function setEngineCallbacks(_arg_1:Function, _arg_2:Function):void {
		super.setEngineCallbacks(_arg_1, _arg_2);
		this.m_callbackSendEvent = _arg_1;
		this.m_callbackSendEventWithValue = _arg_2;
	}

	public function setTaskManagerEnqueue(_arg_1:Function):void {
		this.m_taskManagerEnqueue = _arg_1;
	}

	public function getDialogInformation():Object {
		return (this.m_dialogInformation);
	}

	public function setButtonData(_arg_1:Array):void {
	}

	public function getModalHeight():Number {
		return (0);
	}

	public function getModalWidth():Number {
		return (0);
	}

	public function onSetItemSelected(_arg_1:int, _arg_2:Boolean):void {
	}

	public function onScroll(_arg_1:Number, _arg_2:Boolean):void {
	}

	public function onButtonPressed(_arg_1:Number):void {
	}

	public function updateButtonPrompts():void {
	}

	public function hide():void {
	}

	public function onFadeInFinished():void {
	}

	protected function addMouseEventListenersOnButton(button:ModalDialogGenericButton, i:int):void {
		button.addEventListener(MouseEvent.MOUSE_UP, function (_arg_1:MouseEvent):void {
			_arg_1.stopImmediatePropagation();
			if (button.isPressable()) {
				m_callbackSendEventWithValue("onElementClick", i);
			}

		});
		button.addEventListener(MouseEvent.MOUSE_OVER, function (_arg_1:MouseEvent):void {
			_arg_1.stopImmediatePropagation();
			if (button.isPressable()) {
				m_callbackSendEventWithValue("onElementOver", i);
			}

		});
	}

	protected function addMouseEventListeners(element:Sprite, i:int):void {
		element.addEventListener(MouseEvent.MOUSE_UP, function (_arg_1:MouseEvent):void {
			_arg_1.stopImmediatePropagation();
			m_callbackSendEventWithValue("onElementClick", i);
		});
		element.addEventListener(MouseEvent.MOUSE_OVER, function (_arg_1:MouseEvent):void {
			_arg_1.stopImmediatePropagation();
			m_callbackSendEventWithValue("onElementOver", i);
		});
	}

	protected function addMouseWheelEventListener(_arg_1:Sprite):void {
		_arg_1.addEventListener(MouseEvent.MOUSE_WHEEL, this.handleMouseWheelModal, false, 0, false);
	}

	private function handleMouseWheelModal(_arg_1:MouseEvent):void {
		trace(("ModalDialog mouseEvent: " + _arg_1.type));
		var _local_2:Number = _arg_1.delta;
		var _local_3:Array = [-1, _local_2];
		this.m_callbackSendEventWithValue("onElementScrollVertical", _local_3);
	}


}
}//package menu3.modal

class DialogInformation {

	public var CanSelectContent:Boolean = false;
	public var ContentIsTextEdit:Boolean = false;
	public var IsButtonSelectionEnabled:Boolean = true;
	public var AllButtonsClose:Boolean = true;


}


