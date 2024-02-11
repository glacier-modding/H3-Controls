// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.MenuElementRender3D

package menu3.basic {
import menu3.MenuElementBase;

import flash.display.Shape;
import flash.geom.Rectangle;
import flash.events.Event;

import menu3.ScreenResizeEvent;
import menu3.VisibilityChangedEvent;

import flash.geom.Point;

import common.Log;

import flash.external.ExternalInterface;
import flash.display.DisplayObject;

public dynamic class MenuElementRender3D extends MenuElementBase {

	private var m_rectangle:Shape;
	private var m_GUIGroupName:String;
	private var m_localBounds:Rectangle = null;
	private var m_isVisibleOnScreen:Boolean = false;

	public function MenuElementRender3D(_arg_1:Object) {
		super(_arg_1);
		addEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler, false, 0, true);
		this.m_rectangle = new Shape();
		addChild(this.m_rectangle);
	}

	override public function onUnregister():void {
		if (hasEventListener(Event.ADDED_TO_STAGE)) {
			removeEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler, false);
		}
		;
		this.nodeUpdate(0, 0, 0, 0, false);
		super.onUnregister();
	}

	override public function onSetData(_arg_1:Object):void {
		this.m_GUIGroupName = _arg_1.guiGroupName;
		this.m_rectangle.graphics.clear();
		this.m_rectangle.graphics.lineStyle(1, 0xFF0000);
		this.m_rectangle.graphics.drawRect(0, 0, _arg_1.width, _arg_1.height);
		this.m_localBounds = this.getBounds(this);
		if (_arg_1.showBorder !== true) {
			this.m_rectangle.graphics.clear();
		}
		;
	}

	private function addedToStageHandler():void {
		removeEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler, false);
		this.m_isVisibleOnScreen = false;
		this.updateVisibilityAndNotifySize();
		stage.addEventListener(ScreenResizeEvent.SCREEN_RESIZED, this.screenResizeEventHandler, true, 0, true);
		this.addVisibilityChangedEventListener();
		addEventListener(Event.REMOVED_FROM_STAGE, this.removedFromStageHandler, false);
	}

	private function removedFromStageHandler(_arg_1:Event):void {
		removeEventListener(Event.REMOVED_FROM_STAGE, this.removedFromStageHandler, false);
		this.removeVisibilityChangedEventListener();
		stage.removeEventListener(ScreenResizeEvent.SCREEN_RESIZED, this.screenResizeEventHandler, true);
	}

	private function screenResizeEventHandler(_arg_1:ScreenResizeEvent):void {
		this.updateNotifySize();
	}

	private function visibilityChangedHandler(_arg_1:VisibilityChangedEvent):void {
		this.updateVisibilityAndNotifySize();
	}

	private function updateVisibilityAndNotifySize():void {
		var _local_1:Boolean = this.getVisibilityOnScreen();
		if (this.m_isVisibleOnScreen == _local_1) {
			return;
		}
		;
		this.m_isVisibleOnScreen = _local_1;
		this.updateNotifySize();
	}

	private function updateNotifySize():void {
		if (this.m_localBounds == null) {
			return;
		}
		;
		var _local_1:Point = new Point(this.m_localBounds.x, this.m_localBounds.y);
		var _local_2:Point = _local_1.add(new Point(this.m_localBounds.width, this.m_localBounds.height));
		var _local_3:Point = this.localToGlobal(_local_1);
		var _local_4:Point = this.localToGlobal(_local_2);
		var _local_5:Point = _local_4.subtract(_local_3);
		var _local_6:Rectangle = new Rectangle(_local_3.x, _local_3.y, _local_5.x, _local_5.y);
		this.nodeUpdate(_local_6.x, _local_6.y, _local_6.width, _local_6.height, this.m_isVisibleOnScreen);
	}

	private function nodeUpdate(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Boolean):void {
		if (((!(this.m_GUIGroupName == null)) && (this.m_GUIGroupName.length > 0))) {
			Log.info(Log.ChannelDebug, this, ((((((((((("Render3DNodeUpdate: " + this.m_GUIGroupName) + " x=") + _arg_1) + " y=") + _arg_2) + " width=") + _arg_3) + " height=") + _arg_4) + " visible=") + _arg_5));
			ExternalInterface.call("Render3DNodeUpdate", this.m_GUIGroupName, _arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
		}
		;
	}

	private function getVisibilityOnScreen():Boolean {
		var _local_1:DisplayObject = this;
		while (_local_1 != null) {
			if (_local_1.visible == false) {
				return (false);
			}
			;
			_local_1 = _local_1.parent;
		}
		;
		return (true);
	}

	private function addVisibilityChangedEventListener():void {
		var _local_1:DisplayObject = this;
		while (_local_1 != null) {
			_local_1.addEventListener(VisibilityChangedEvent.VISIBILITY_CHANGED, this.visibilityChangedHandler, false, 0, true);
			_local_1 = _local_1.parent;
		}
		;
	}

	private function removeVisibilityChangedEventListener():void {
		var _local_1:DisplayObject = this;
		while (_local_1 != null) {
			_local_1.removeEventListener(VisibilityChangedEvent.VISIBILITY_CHANGED, this.visibilityChangedHandler, false);
			_local_1 = _local_1.parent;
		}
		;
	}


}
}//package menu3.basic

