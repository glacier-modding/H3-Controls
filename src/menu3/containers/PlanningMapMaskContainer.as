// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.containers.PlanningMapMaskContainer

package menu3.containers {
import flash.display.Sprite;
import flash.events.Event;

import common.menu.MenuConstants;

import flash.events.MouseEvent;

import menu3.ScreenResizeEvent;

import flash.utils.getQualifiedClassName;

public dynamic class PlanningMapMaskContainer extends BaseContainer {

	private var m_view:Sprite;

	public function PlanningMapMaskContainer(_arg_1:Object) {
		super(_arg_1);
		addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage, true, 0, true);
		var _local_2:int = MenuConstants.menuXOffset;
		var _local_3:int = ((MenuConstants.tileGap + MenuConstants.TabsLineUpperYPos) + MenuConstants.GridUnitHeight);
		this.m_view = new Sprite();
		this.m_view.x = (0 - _local_2);
		this.m_view.y = (0 - _local_3);
		addChild(this.m_view);
		this.scaleMask(_arg_1.sizeX, _arg_1.sizeY);
		getContainer().mask = this.m_view;
		if (ControlsMain.isVrModeActive()) {
			this.z = MenuConstants.VRNotebookMapZOffset;
		}
		;
	}

	private function onAddedToStage(_arg_1:Event):void {
		removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage, true);
		addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage, false);
		stage.addEventListener(MouseEvent.MOUSE_UP, this.handleStageMouseUp, true);
		stage.addEventListener(ScreenResizeEvent.SCREEN_RESIZED, this.screenResizeEventHandler, true, 0, true);
	}

	private function onRemovedFromStage(_arg_1:Event):void {
		removeEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage, false);
		stage.removeEventListener(MouseEvent.MOUSE_UP, this.handleStageMouseUp, true);
		stage.removeEventListener(ScreenResizeEvent.SCREEN_RESIZED, this.screenResizeEventHandler, true);
		if (m_sendEvent != null) {
			m_sendEvent("onDragEnd");
		}
		;
	}

	private function scaleMask(_arg_1:Number, _arg_2:Number):void {
		var _local_3:Number = Math.min((_arg_1 / MenuConstants.BaseWidth), (_arg_2 / MenuConstants.BaseHeight));
		var _local_4:Number = (MenuConstants.BaseWidth * _local_3);
		var _local_5:Number = (MenuConstants.BaseHeight * _local_3);
		var _local_6:Number = ((_arg_1 - _local_4) / 2);
		var _local_7:Number = (_local_6 * (1 / _local_3));
		var _local_8:Number = (1 + ((_local_7 * 2) / MenuConstants.BaseWidth));
		var _local_9:Number = ((_arg_2 - _local_5) / 2);
		var _local_10:Number = (_local_9 * (1 / _local_3));
		var _local_11:Number = (1 + ((_local_10 * 2) / MenuConstants.BaseHeight));
		var _local_12:Number = (MenuConstants.BaseWidth * _local_8);
		this.m_view.graphics.clear();
		this.m_view.graphics.beginFill(16741183, 1);
		this.m_view.graphics.moveTo((0 - _local_7), MenuConstants.TabsLineLowerYPos);
		this.m_view.graphics.lineTo(_local_12, MenuConstants.TabsLineLowerYPos);
		this.m_view.graphics.lineTo(_local_12, MenuConstants.UserLineUpperYPos);
		this.m_view.graphics.lineTo((0 - _local_7), MenuConstants.UserLineUpperYPos);
		this.m_view.graphics.endFill();
	}

	public function screenResizeEventHandler(_arg_1:ScreenResizeEvent):void {
		var _local_2:Object = _arg_1.screenSize;
		this.scaleMask(_local_2.sizeX, _local_2.sizeY);
	}

	override public function handleMouseDown(_arg_1:Function, _arg_2:MouseEvent):void {
		var _local_3:int;
		trace(((((getQualifiedClassName(this) + ": mousedown ") + name) + " mousedowntarget ") + ((_arg_2.target == null) ? "" : _arg_2.target.name)));
		_arg_2.stopImmediatePropagation();
		if (stage.focus == this) {
			return;
		}
		;
		if (this["_nodedata"]) {
			_local_3 = (this["_nodedata"]["id"] as int);
			(_arg_1("onElementSelect", _local_3));
			(_arg_1("onElementClick", _local_3));
		}
		;
	}

	override public function handleMouseUp(_arg_1:Function, _arg_2:MouseEvent):void {
		trace(((((getQualifiedClassName(this) + ": mouseup ") + name) + " mouseuptarget ") + ((_arg_2.target == null) ? "" : _arg_2.target.name)));
		_arg_2.stopImmediatePropagation();
	}

	private function handleStageMouseUp(_arg_1:MouseEvent):void {
		trace(((((getQualifiedClassName(this) + ": stage mouseup ") + name) + " mouseuptarget ") + ((_arg_1.target == null) ? "" : _arg_1.target.name)));
		if (m_sendEvent != null) {
			m_sendEvent("onDragEnd");
		}
		;
	}


}
}//package menu3.containers

