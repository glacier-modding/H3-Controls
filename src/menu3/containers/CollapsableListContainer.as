// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.containers.CollapsableListContainer

package menu3.containers {
import common.menu.MenuConstants;

import flash.geom.Rectangle;

import menu3.MenuElementBase;

import flash.display.Sprite;
import flash.events.MouseEvent;

public dynamic class CollapsableListContainer extends ListContainer {

	public var m_collapsed:Boolean;
	protected var m_loading:Boolean = false;
	protected var m_mouseModeCollapsed:int = 1;
	protected var m_mouseModeUncollapsed:int = 3;

	public function CollapsableListContainer(_arg_1:Object) {
		super(_arg_1);
		m_mouseMode = this.m_mouseModeCollapsed;
		m_container.y = MenuConstants.CollapsableContainerElementOffsetY;
	}

	override public function onContextActivate():void {
		m_mouseMode = this.m_mouseModeUncollapsed;
	}

	override public function onContextDeactivate():void {
		m_mouseMode = this.m_mouseModeCollapsed;
	}

	public function onCollapsed():void {
		if (m_children) {
			this.m_collapsed = true;
			this.expandCollapseMenu(false);
		}

	}

	public function onUncollapsed():void {
		if (m_children) {
			this.m_collapsed = false;
			this.expandCollapseMenu(true);
		}

	}

	public function repositionElements(target:Sprite):void {
		var childBounds:Rectangle;
		var menuElem:MenuElementBase = (target as MenuElementBase);
		var bounds:Rectangle = getMenuElementBounds(menuElem, menuElem, function (_arg_1:MenuElementBase):Boolean {
			return (_arg_1.visible);
		});
		var indexChanged:int = m_children.indexOf(target);
		var offsetChild:Number = ((menuElem.y + bounds.height) + MenuConstants.CollapsableContainerElementOffsetY);
		var i:int = (indexChanged + 1);
		while (i < m_children.length) {
			m_children[i].y = offsetChild;
			childBounds = getMenuElementBounds(m_children[i], m_children[i], function (_arg_1:MenuElementBase):Boolean {
				return (_arg_1.visible);
			});
			offsetChild = (offsetChild + (childBounds.height + MenuConstants.CollapsableContainerElementOffsetY));
			i = (i + 1);
		}

	}

	public function expandCollapseMenu(_arg_1:Boolean):void {
		var _local_2:int;
		while (_local_2 < m_children.length) {
			m_children[_local_2].visible = _arg_1;
			_local_2++;
		}

		bubbleEvent("onEndChildBoundsChanged", this);
	}

	public function onItemLoadingStateChanged(_arg_1:Boolean):void {
		var _local_2:Boolean;
		if (_arg_1) {
			_local_2 = m_isSelected;
			setItemSelected(false);
			this.m_loading = true;
			m_isSelected = _local_2;
		} else {
			this.m_loading = false;
			setItemSelected(m_isSelected);
		}

	}

	override public function handleEvent(_arg_1:String, _arg_2:Sprite):Boolean {
		if (_arg_1 == "onEndChildBoundsChanged") {
			this.repositionElements(_arg_2);
			bubbleEvent("onEndChildBoundsChanged", this);
			return (true);
		}

		return (super.handleEvent(_arg_1, _arg_2));
	}

	override public function onChildrenChanged():void {
		var _local_1:int;
		while (_local_1 < m_children.length) {
			this.repositionElements(m_children[_local_1]);
			_local_1++;
		}

		this.expandCollapseMenu((!(this.m_collapsed)));
	}

	override public function handleMouseRollOut(_arg_1:Function, _arg_2:MouseEvent):void {
		super.handleMouseRollOut(_arg_1, _arg_2);
		if (stage.focus == this) {
			stage.focus = null;
		}

	}


}
}//package menu3.containers

