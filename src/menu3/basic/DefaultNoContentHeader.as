// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.DefaultNoContentHeader

package menu3.basic {
import flash.geom.Point;
import flash.events.Event;

import common.menu.MenuConstants;

import menu3.MenuFrame;

import flash.geom.Rectangle;
import flash.display.DisplayObject;

public dynamic class DefaultNoContentHeader extends HeadlineElement {

	private var m_absoluteX:Number;
	private var m_absoluteY:Number;
	private var m_screenSize:Point;
	private var m_needsUpdate:Boolean = false;

	public function DefaultNoContentHeader(_arg_1:Object) {
		super(_arg_1);
		addEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler, false, 0, true);
	}

	override public function onSetData(_arg_1:Object):void {
		if (!_arg_1.typeicon) {
			_arg_1.typeicon = "info";
		}
		;
		super.onSetData(_arg_1);
		if (_arg_1.absolute_x) {
			this.m_absoluteX = _arg_1.absolute_x;
		} else {
			this.m_absoluteX = MenuConstants.HeadlineElementXPos;
		}
		;
		if (_arg_1.absolute_y) {
			this.m_absoluteY = _arg_1.absolute_y;
		} else {
			this.m_absoluteY = MenuConstants.HeadlineElementYPos;
		}
		;
		if (((!(isNaN(_arg_1.sizeX))) && (!(isNaN(_arg_1.sizeY))))) {
			this.m_screenSize = new Point(_arg_1.sizeX, _arg_1.sizeY);
		}
		;
		this.m_needsUpdate = true;
		this.updatePosition();
	}

	override public function onUnregister():void {
		super.onUnregister();
		if (hasEventListener(Event.ADDED_TO_STAGE)) {
			removeEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler, false);
		}
		;
	}

	private function addedToStageHandler():void {
		removeEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler, false);
		this.updatePosition();
	}

	public function updatePosition():void {
		var _local_3:MenuFrame;
		var _local_4:Rectangle;
		var _local_5:Rectangle;
		var _local_6:HeadlineElementView;
		if (!this.m_needsUpdate) {
			return;
		}
		;
		var _local_1:DisplayObject = this;
		var _local_2:DisplayObject;
		while (((!(_local_1 == null)) && (_local_2 == null))) {
			_local_3 = (_local_1.parent as MenuFrame);
			if (_local_3 != null) {
				_local_2 = _local_1;
			} else {
				_local_1 = _local_1.parent;
			}
			;
		}
		;
		if (_local_2 != null) {
			_local_4 = this.getBounds(this);
			_local_5 = this.getBounds(_local_2);
			_local_6 = getRootView();
			_local_6.x = (this.m_absoluteX - (_local_5.x - _local_4.x));
			_local_6.y = (this.m_absoluteY - (_local_5.y - _local_4.y));
			this.m_needsUpdate = false;
		}
		;
	}


}
}//package menu3.basic

