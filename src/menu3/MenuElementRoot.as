// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.MenuElementRoot

package menu3 {
import menu3.containers.CollapsableListContainer;

import flash.geom.Rectangle;

import common.menu.MenuConstants;
import common.Animate;

import menu3.containers.ScrollingListContainer;

import flash.display.Sprite;

public dynamic class MenuElementRoot extends CollapsableListContainer {

	private var m_rootBounds:Rectangle;

	public function MenuElementRoot(_arg_1:Object) {
		super(_arg_1);
		this.m_rootBounds = new Rectangle();
		this.m_rootBounds.x = (MenuConstants.MenuElementRootCol * MenuConstants.GridUnitWidth);
		this.m_rootBounds.y = (MenuConstants.MenuElementRootRow * MenuConstants.GridUnitHeight);
		this.m_rootBounds.width = (MenuConstants.MenuElementRootNCol * MenuConstants.GridUnitWidth);
		this.m_rootBounds.height = (MenuConstants.MenuElementRootNRow * MenuConstants.GridUnitHeight);
	}

	override public function onUnregister():void {
		Animate.complete(getContainer());
		super.onUnregister();
		this.m_rootBounds = null;
	}

	override public function onSetData(_arg_1:Object):void {
		this.handleBoundsChanged(getVisibleContainerBounds(), 0);
	}

	public function handleScrollingListContainerScrolled(scrollingListContainer:ScrollingListContainer):void {
		var maxY:Number;
		Animate.complete(getContainer());
		var targetBounds:Rectangle = getMenuElementBounds(scrollingListContainer, this, function (_arg_1:MenuElementBase):Boolean {
			return (_arg_1.visible);
		});
		targetBounds.height = Math.min(targetBounds.height, (scrollingListContainer.getScrollBounds().height - scrollingListContainer.getContainer().y));
		var targetY:Number = (((this.m_rootBounds.bottom - (MenuConstants.MenuElementRootPivotBottomOffset * MenuConstants.GridUnitHeight)) - (targetBounds.y + targetBounds.height)) + getContainer().y);
		if (targetY < getView().getBounds(getView()).height) {
			targetY = getView().getBounds(getView()).height;
		}

		Animate.legacyTo(getContainer(), MenuConstants.ScrollTime, {"y": targetY}, Animate.ExpoOut);
		var alphaCountdown:Number = 1;
		var i:int;
		while (i < m_children.length) {
			maxY = (m_children[i].y + targetY);
			if (maxY > 800) {
				alphaCountdown = (alphaCountdown - 0.3);
				m_children[i].alpha = alphaCountdown;
			}

			i = (i + 1);
		}

	}

	public function handleBoundsChanged(_arg_1:Rectangle, _arg_2:Number):void {
		var _local_3:int;
		while (_local_3 < m_children.length) {
			m_children[_local_3].alpha = 1;
			_local_3++;
		}

		Animate.complete(getContainer());
		var _local_4:Number = ((this.m_rootBounds.bottom - (MenuConstants.MenuElementRootPivotBottomOffset * MenuConstants.GridUnitHeight)) - _arg_1.height);
		if (_local_4 < getView().getBounds(getView()).height) {
			_local_4 = getView().getBounds(getView()).height;
		}

		Animate.legacyTo(getContainer(), _arg_2, {"y": _local_4}, Animate.ExpoOut);
	}

	override public function handleEvent(_arg_1:String, _arg_2:Sprite):Boolean {
		var _local_3:MenuElementBase = (_arg_2 as MenuElementBase);
		var _local_4:Boolean;
		if (_arg_1 == "onEndChildBoundsChanged") {
			super.handleEvent(_arg_1, _arg_2);
			this.handleBoundsChanged(getVisibleContainerBounds(), MenuConstants.ScrollTime);
			_local_4 = true;
		}

		if (_arg_1 == "scrollingListContainerScrolled") {
			this.handleScrollingListContainerScrolled((_arg_2 as ScrollingListContainer));
			_local_4 = true;
		}

		if (!_local_4) {
			return (super.handleEvent(_arg_1, _arg_2));
		}

		return (false);
	}


}
}//package menu3

