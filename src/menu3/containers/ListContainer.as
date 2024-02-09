package menu3.containers
{
   import common.MouseUtil;
   import common.menu.MenuConstants;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import menu3.MenuElementBase;
   
   public dynamic class ListContainer extends BaseContainer
   {
       
      
      protected var m_direction:String;
      
      protected var m_xOffset:Number = 0;
      
      protected var m_yOffset:Number = 0;
      
      public function ListContainer(param1:Object)
      {
         super(param1);
         m_mouseMode = MouseUtil.MODE_DISABLE;
         this.m_direction = String(param1.direction) || "vertical";
         this.m_xOffset = Number(param1.offsetCol) || 0;
         this.m_yOffset = Number(param1.offsetRow) || 0;
      }
      
      override public function addChild2(param1:Sprite, param2:int = -1) : void
      {
         super.addChild2(param1,param2);
         this.pausePopOutScale();
         this.repositionChild(param1);
         this.resumePopOutScale();
      }
      
      override public function reorderChildren(param1:Array) : void
      {
         super.reorderChildren(param1);
         this.repositionAllChildren();
      }
      
      private function repositionAllChildren() : void
      {
         this.handleEvent("onChildBoundsChanged",this);
         bubbleEvent("onChildBoundsChanged",this);
      }
      
      override public function handleEvent(param1:String, param2:Sprite) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:MenuElementBase = null;
         if(param1 == "reload_node")
         {
            if(m_children.indexOf(param2) >= 0)
            {
               this.repositionChild(param2);
            }
         }
         else if(param1 == "onEndChildBoundsChanged")
         {
            if(m_children.length > 0)
            {
               this.pausePopOutScale();
               this.repositionChild(m_children[m_children.length - 1]);
               this.resumePopOutScale();
            }
         }
         else if(param1 == "onChildBoundsChanged")
         {
            if(m_children.length > 0)
            {
               this.pausePopOutScale();
               _loc3_ = 0;
               while(_loc3_ < m_children.length)
               {
                  _loc4_ = m_children[_loc3_];
                  this.repositionChild(_loc4_);
                  _loc3_++;
               }
               this.resumePopOutScale();
            }
         }
         return super.handleEvent(param1,param2);
      }
      
      override public function pausePopOutScale() : void
      {
         var _loc2_:MenuElementBase = null;
         super.pausePopOutScale();
         var _loc1_:int = 0;
         while(_loc1_ < m_children.length)
         {
            _loc2_ = m_children[_loc1_];
            _loc2_.pausePopOutScale();
            _loc1_++;
         }
      }
      
      override public function resumePopOutScale() : void
      {
         var _loc2_:MenuElementBase = null;
         super.resumePopOutScale();
         var _loc1_:int = 0;
         while(_loc1_ < m_children.length)
         {
            _loc2_ = m_children[_loc1_];
            _loc2_.resumePopOutScale();
            _loc1_++;
         }
      }
      
      public function repositionChild(param1:Sprite) : void
      {
         var elementIndex:int = 0;
         var element:Sprite = param1;
         var x:Number = element.x;
         var y:Number = element.y;
         var hasPropCol:Boolean = getNodeProp(element,"col") !== undefined;
         var hasPropRow:Boolean = getNodeProp(element,"row") !== undefined;
         elementIndex = m_children.indexOf(element);
         var containerBounds:Rectangle = null;
         var fetchBounds:Boolean = false;
         if(this.m_direction == "dual")
         {
            fetchBounds = true;
         }
         else if(this.m_direction == "horizontal")
         {
            if(!hasPropCol)
            {
               fetchBounds = true;
            }
         }
         else if(!hasPropRow)
         {
            fetchBounds = true;
         }
         if(fetchBounds)
         {
            containerBounds = getMenuElementBounds(this,this,function(param1:MenuElementBase):Boolean
            {
               return param1.visible && m_children.indexOf(param1) < elementIndex;
            });
         }
         if(this.m_direction == "dual")
         {
            x = containerBounds.width;
            y = containerBounds.height;
         }
         else if(this.m_direction == "horizontal")
         {
            if(!hasPropCol)
            {
               x = containerBounds.width;
            }
            else
            {
               x = MenuConstants.GridUnitWidth * getNodeProp(element,"col");
            }
         }
         else if(!hasPropRow)
         {
            y = containerBounds.height;
         }
         else
         {
            y = MenuConstants.GridUnitHeight * getNodeProp(element,"row");
         }
         if(!hasPropCol)
         {
            element.x = x + this.m_xOffset * MenuConstants.GridUnitWidth;
         }
         if(!hasPropRow)
         {
            element.y = y + this.m_yOffset * MenuConstants.GridUnitHeight;
         }
      }
   }
}
