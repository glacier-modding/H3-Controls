package menu3
{
	import common.Animate;
	import common.menu.MenuConstants;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import menu3.containers.CollapsableListContainer;
	import menu3.containers.ScrollingListContainer;
	
	public dynamic class MenuElementRoot extends CollapsableListContainer
	{
		
		private var m_rootBounds:Rectangle;
		
		public function MenuElementRoot(param1:Object)
		{
			super(param1);
			this.m_rootBounds = new Rectangle();
			this.m_rootBounds.x = MenuConstants.MenuElementRootCol * MenuConstants.GridUnitWidth;
			this.m_rootBounds.y = MenuConstants.MenuElementRootRow * MenuConstants.GridUnitHeight;
			this.m_rootBounds.width = MenuConstants.MenuElementRootNCol * MenuConstants.GridUnitWidth;
			this.m_rootBounds.height = MenuConstants.MenuElementRootNRow * MenuConstants.GridUnitHeight;
		}
		
		override public function onUnregister():void
		{
			Animate.complete(getContainer());
			super.onUnregister();
			this.m_rootBounds = null;
		}
		
		override public function onSetData(param1:Object):void
		{
			this.handleBoundsChanged(getVisibleContainerBounds(), 0);
		}
		
		public function handleScrollingListContainerScrolled(param1:ScrollingListContainer):void
		{
			var targetBounds:Rectangle;
			var targetY:Number;
			var alphaCountdown:Number;
			var i:int;
			var maxY:Number = NaN;
			var scrollingListContainer:ScrollingListContainer = param1;
			Animate.complete(getContainer());
			targetBounds = getMenuElementBounds(scrollingListContainer, this, function(param1:MenuElementBase):Boolean
			{
				return param1.visible;
			});
			targetBounds.height = Math.min(targetBounds.height, scrollingListContainer.getScrollBounds().height - scrollingListContainer.getContainer().y);
			targetY = this.m_rootBounds.bottom - MenuConstants.MenuElementRootPivotBottomOffset * MenuConstants.GridUnitHeight - (targetBounds.y + targetBounds.height) + getContainer().y;
			if (targetY < getView().getBounds(getView()).height)
			{
				targetY = getView().getBounds(getView()).height;
			}
			Animate.legacyTo(getContainer(), MenuConstants.ScrollTime, {"y": targetY}, Animate.ExpoOut);
			alphaCountdown = 1;
			i = 0;
			while (i < m_children.length)
			{
				maxY = m_children[i].y + targetY;
				if (maxY > 800)
				{
					alphaCountdown -= 0.3;
					m_children[i].alpha = alphaCountdown;
				}
				i++;
			}
		}
		
		public function handleBoundsChanged(param1:Rectangle, param2:Number):void
		{
			var _loc3_:int = 0;
			while (_loc3_ < m_children.length)
			{
				m_children[_loc3_].alpha = 1;
				_loc3_++;
			}
			Animate.complete(getContainer());
			var _loc4_:Number;
			if ((_loc4_ = this.m_rootBounds.bottom - MenuConstants.MenuElementRootPivotBottomOffset * MenuConstants.GridUnitHeight - param1.height) < getView().getBounds(getView()).height)
			{
				_loc4_ = getView().getBounds(getView()).height;
			}
			Animate.legacyTo(getContainer(), param2, {"y": _loc4_}, Animate.ExpoOut);
		}
		
		override public function handleEvent(param1:String, param2:Sprite):Boolean
		{
			var _loc3_:MenuElementBase = param2 as MenuElementBase;
			var _loc4_:Boolean = false;
			if (param1 == "onEndChildBoundsChanged")
			{
				super.handleEvent(param1, param2);
				this.handleBoundsChanged(getVisibleContainerBounds(), MenuConstants.ScrollTime);
				_loc4_ = true;
			}
			if (param1 == "scrollingListContainerScrolled")
			{
				this.handleScrollingListContainerScrolled(param2 as ScrollingListContainer);
				_loc4_ = true;
			}
			if (!_loc4_)
			{
				return super.handleEvent(param1, param2);
			}
			return false;
		}
	}
}
