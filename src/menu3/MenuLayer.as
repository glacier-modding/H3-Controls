// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.MenuLayer

package menu3 {
import flash.display.Sprite;

import common.MouseUtil;
import common.menu.MenuConstants;

import flash.events.Event;
import flash.geom.Rectangle;
import flash.geom.Point;

public dynamic class MenuLayer extends MenuElementBase {

	private var m_background:Sprite = new Sprite();
	private var m_addedToStage:Boolean = false;
	private var m_element:Sprite = null;
	private var m_anchorBound:Object = null;
	private var m_positionSide:String;
	private var m_spaceX:int = 0;

	public function MenuLayer(_arg_1:Object) {
		super(_arg_1);
		m_mouseMode = MouseUtil.MODE_DISABLE;
		addChildAt(this.m_background, 0);
		this.m_background.graphics.clear();
		this.m_background.graphics.beginFill(0xFF0000, 0);
		this.m_background.graphics.drawRect(-100, -100, (MenuConstants.BaseWidth + 200), (MenuConstants.BaseHeight + 200));
		this.m_background.graphics.endFill();
		this.m_anchorBound = _arg_1.anchorbound;
		this.m_spaceX = ((_arg_1.spaceX != undefined) ? _arg_1.spaceX : 0);
		this.m_positionSide = ((_arg_1.positionSide != undefined) ? _arg_1.positionSide : "right");
		addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage, true, 0, true);
	}

	override public function addChild2(_arg_1:Sprite, _arg_2:int = -1):void {
		super.addChild2(_arg_1, _arg_2);
		this.m_element = _arg_1;
		if (this.m_addedToStage) {
			this.placeChild();
		}
		;
	}

	override public function onUnregister():void {
		removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage, true);
		super.onUnregister();
	}

	protected function onAddedToStage(_arg_1:Event):void {
		removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage, true);
		this.m_addedToStage = true;
		if (this.m_element != null) {
			this.placeChild();
		}
		;
	}

	private function placeChild():void {
		var _local_3:Rectangle;
		if (this.m_anchorBound == null) {
			return;
		}
		;
		var _local_1:Point = this.m_element.parent.globalToLocal(new Point(this.m_anchorBound.x, this.m_anchorBound.y));
		var _local_2:Point = this.m_element.parent.globalToLocal(new Point((this.m_anchorBound.x + this.m_anchorBound.width), (this.m_anchorBound.y + this.m_anchorBound.height)));
		this.m_element.y = _local_1.y;
		if (this.m_positionSide == "left") {
			_local_3 = this.m_element.getBounds(this.m_element.parent);
			this.m_element.x = ((_local_1.x - this.m_spaceX) - _local_3.width);
		} else {
			this.m_element.x = (_local_2.x + this.m_spaceX);
		}
		;
	}


}
}//package menu3

