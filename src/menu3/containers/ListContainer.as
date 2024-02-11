// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.containers.ListContainer

package menu3.containers {
import common.MouseUtil;

import flash.display.Sprite;

import menu3.MenuElementBase;

import flash.geom.Rectangle;

import common.menu.MenuConstants;

public dynamic class ListContainer extends BaseContainer {

	protected var m_direction:String;
	protected var m_xOffset:Number = 0;
	protected var m_yOffset:Number = 0;

	public function ListContainer(_arg_1:Object) {
		super(_arg_1);
		m_mouseMode = MouseUtil.MODE_DISABLE;
		this.m_direction = ((_arg_1.direction) || ("vertical"));
		this.m_xOffset = ((_arg_1.offsetCol) || (0));
		this.m_yOffset = ((_arg_1.offsetRow) || (0));
	}

	override public function addChild2(_arg_1:Sprite, _arg_2:int = -1):void {
		super.addChild2(_arg_1, _arg_2);
		this.pausePopOutScale();
		this.repositionChild(_arg_1);
		this.resumePopOutScale();
	}

	override public function reorderChildren(_arg_1:Array):void {
		super.reorderChildren(_arg_1);
		this.repositionAllChildren();
	}

	private function repositionAllChildren():void {
		this.handleEvent("onChildBoundsChanged", this);
		bubbleEvent("onChildBoundsChanged", this);
	}

	override public function handleEvent(_arg_1:String, _arg_2:Sprite):Boolean {
		var _local_3:int;
		var _local_4:MenuElementBase;
		if (_arg_1 == "reload_node") {
			if (m_children.indexOf(_arg_2) >= 0) {
				this.repositionChild(_arg_2);
			}

		} else {
			if (_arg_1 == "onEndChildBoundsChanged") {
				if (m_children.length > 0) {
					this.pausePopOutScale();
					this.repositionChild(m_children[(m_children.length - 1)]);
					this.resumePopOutScale();
				}

			} else {
				if (_arg_1 == "onChildBoundsChanged") {
					if (m_children.length > 0) {
						this.pausePopOutScale();
						_local_3 = 0;
						while (_local_3 < m_children.length) {
							_local_4 = m_children[_local_3];
							this.repositionChild(_local_4);
							_local_3++;
						}

						this.resumePopOutScale();
					}

				}

			}

		}

		return (super.handleEvent(_arg_1, _arg_2));
	}

	override public function pausePopOutScale():void {
		var _local_2:MenuElementBase;
		super.pausePopOutScale();
		var _local_1:int;
		while (_local_1 < m_children.length) {
			_local_2 = m_children[_local_1];
			_local_2.pausePopOutScale();
			_local_1++;
		}

	}

	override public function resumePopOutScale():void {
		var _local_2:MenuElementBase;
		super.resumePopOutScale();
		var _local_1:int;
		while (_local_1 < m_children.length) {
			_local_2 = m_children[_local_1];
			_local_2.resumePopOutScale();
			_local_1++;
		}

	}

	public function repositionChild(element:Sprite):void {
		var elementIndex:int;
		var x:Number = element.x;
		var y:Number = element.y;
		var hasPropCol:Boolean = (!(getNodeProp(element, "col") === undefined));
		var hasPropRow:Boolean = (!(getNodeProp(element, "row") === undefined));
		elementIndex = m_children.indexOf(element);
		var containerBounds:Rectangle;
		var fetchBounds:Boolean;
		if (this.m_direction == "dual") {
			fetchBounds = true;
		} else {
			if (this.m_direction == "horizontal") {
				if (!hasPropCol) {
					fetchBounds = true;
				}

			} else {
				if (!hasPropRow) {
					fetchBounds = true;
				}

			}

		}

		if (fetchBounds) {
			containerBounds = getMenuElementBounds(this, this, function (_arg_1:MenuElementBase):Boolean {
				return ((_arg_1.visible) && (m_children.indexOf(_arg_1) < elementIndex));
			});
		}

		if (this.m_direction == "dual") {
			x = containerBounds.width;
			y = containerBounds.height;
		} else {
			if (this.m_direction == "horizontal") {
				if (!hasPropCol) {
					x = containerBounds.width;
				} else {
					x = (MenuConstants.GridUnitWidth * getNodeProp(element, "col"));
				}

			} else {
				if (!hasPropRow) {
					y = containerBounds.height;
				} else {
					y = (MenuConstants.GridUnitHeight * getNodeProp(element, "row"));
				}

			}

		}

		if (!hasPropCol) {
			element.x = (x + (this.m_xOffset * MenuConstants.GridUnitWidth));
		}

		if (!hasPropRow) {
			element.y = (y + (this.m_yOffset * MenuConstants.GridUnitHeight));
		}

	}


}
}//package menu3.containers

