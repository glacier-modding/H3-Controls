// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.containers.BaseContainer

package menu3.containers {
import menu3.MenuElementBase;

import flash.display.Sprite;
import flash.geom.Rectangle;

public dynamic class BaseContainer extends MenuElementBase {

	protected var m_emptyView:Sprite;
	protected var m_container:Sprite;
	protected var m_isSelected:Boolean = false;
	protected var m_isGroupSelected:Boolean = false;
	protected var m_isChildSelected:Boolean = false;
	protected var m_sendEvent:Function = null;
	protected var m_sendEventWithValue:Function = null;

	public function BaseContainer(_arg_1:Object) {
		super(_arg_1);
		this.m_emptyView = new Sprite();
		addChild(this.m_emptyView);
		this.m_container = new Sprite();
		addChild(this.m_container);
	}

	override public function setEngineCallbacks(_arg_1:Function, _arg_2:Function):void {
		this.m_sendEvent = _arg_1;
		this.m_sendEventWithValue = _arg_2;
	}

	public function onScroll(_arg_1:int):void {
	}

	override public function getView():Sprite {
		return (this.m_emptyView);
	}

	override public function getContainer():Sprite {
		return (this.m_container);
	}

	public function getVisibleContainerBounds():Rectangle {
		return (getMenuElementBounds(this, this, function (_arg_1:MenuElementBase):Boolean {
			return (_arg_1.visible);
		}));
	}

	public function setItemSelected(_arg_1:Boolean):void {
		if (this.m_isSelected == _arg_1) {
			return;
		}
		;
		this.m_isSelected = _arg_1;
		this.handleSelectionChange();
	}

	public function setItemGroupSelected(_arg_1:Boolean):void {
		if (this.m_isGroupSelected == _arg_1) {
			return;
		}
		;
		this.m_isGroupSelected = _arg_1;
		this.handleSelectionChange();
	}

	public function setChildSelected(_arg_1:Boolean):void {
		if (this.m_isChildSelected == _arg_1) {
			return;
		}
		;
		this.m_isChildSelected = _arg_1;
		this.handleChildSelectionChange();
	}

	public function isSelected():Boolean {
		return (this.m_isSelected);
	}

	protected function handleSelectionChange():void {
	}

	protected function handleChildSelectionChange():void {
	}


}
}//package menu3.containers

