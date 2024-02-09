package menu3.containers
{
   import common.menu.MenuConstants;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import menu3.MenuElementBase;
   
   public dynamic class CollapsableListContainer extends ListContainer
   {
       
      
      public var m_collapsed:Boolean;
      
      protected var m_loading:Boolean = false;
      
      protected var m_mouseModeCollapsed:int = 1;
      
      protected var m_mouseModeUncollapsed:int = 3;
      
      public function CollapsableListContainer(param1:Object)
      {
         super(param1);
         m_mouseMode = this.m_mouseModeCollapsed;
         m_container.y = MenuConstants.CollapsableContainerElementOffsetY;
      }
      
      override public function onContextActivate() : void
      {
         m_mouseMode = this.m_mouseModeUncollapsed;
      }
      
      override public function onContextDeactivate() : void
      {
         m_mouseMode = this.m_mouseModeCollapsed;
      }
      
      public function onCollapsed() : void
      {
         if(m_children)
         {
            this.m_collapsed = true;
            this.expandCollapseMenu(false);
         }
      }
      
      public function onUncollapsed() : void
      {
         if(m_children)
         {
            this.m_collapsed = false;
            this.expandCollapseMenu(true);
         }
      }
      
      public function repositionElements(param1:Sprite) : void
      {
         var childBounds:Rectangle = null;
         var target:Sprite = param1;
         var menuElem:MenuElementBase = target as MenuElementBase;
         var bounds:Rectangle = getMenuElementBounds(menuElem,menuElem,function(param1:MenuElementBase):Boolean
         {
            return param1.visible;
         });
         var indexChanged:int = m_children.indexOf(target);
         var offsetChild:Number = menuElem.y + bounds.height + MenuConstants.CollapsableContainerElementOffsetY;
         var i:int = indexChanged + 1;
         while(i < m_children.length)
         {
            m_children[i].y = offsetChild;
            childBounds = getMenuElementBounds(m_children[i],m_children[i],function(param1:MenuElementBase):Boolean
            {
               return param1.visible;
            });
            offsetChild += childBounds.height + MenuConstants.CollapsableContainerElementOffsetY;
            i++;
         }
      }
      
      public function expandCollapseMenu(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < m_children.length)
         {
            m_children[_loc2_].visible = param1;
            _loc2_++;
         }
         bubbleEvent("onEndChildBoundsChanged",this);
      }
      
      public function onItemLoadingStateChanged(param1:Boolean) : void
      {
         var _loc2_:Boolean = false;
         if(param1)
         {
            _loc2_ = m_isSelected;
            setItemSelected(false);
            this.m_loading = true;
            m_isSelected = _loc2_;
         }
         else
         {
            this.m_loading = false;
            setItemSelected(m_isSelected);
         }
      }
      
      override public function handleEvent(param1:String, param2:Sprite) : Boolean
      {
         if(param1 == "onEndChildBoundsChanged")
         {
            this.repositionElements(param2);
            bubbleEvent("onEndChildBoundsChanged",this);
            return true;
         }
         return super.handleEvent(param1,param2);
      }
      
      override public function onChildrenChanged() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < m_children.length)
         {
            this.repositionElements(m_children[_loc1_]);
            _loc1_++;
         }
         this.expandCollapseMenu(!this.m_collapsed);
      }
      
      override public function handleMouseRollOut(param1:Function, param2:MouseEvent) : void
      {
         super.handleMouseRollOut(param1,param2);
         if(stage.focus == this)
         {
            stage.focus = null;
         }
      }
   }
}
