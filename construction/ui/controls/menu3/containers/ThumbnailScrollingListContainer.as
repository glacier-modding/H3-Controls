package menu3.containers
{
   import common.Log;
   import common.MouseUtil;
   import common.menu.MenuConstants;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.system.System;
   import menu3.MenuElementBase;
   import menu3.ScreenResizeEvent;
   import menu3.basic.ChallengeCategoryTile;
   import menu3.basic.IImageContainer;
   import menu3.basic.ThumbnailItemTile;
   import menu3.basic.ThumbnailSelectedltemTile;
   
   public dynamic class ThumbnailScrollingListContainer extends ScrollingListContainer
   {
       
      
      public var m_childrenOffset:Array;
      
      private var m_selectedItemTile:ThumbnailSelectedltemTile;
      
      private var m_scrollMaxBounds:Rectangle;
      
      private var m_elementIndex:int = 0;
      
      private var m_currentFocusedElement:ThumbnailItemTile = null;
      
      private var m_mouseEdgeScrollActivated:Boolean = false;
      
      private var m_nextElementIndexFromEdgeScroll:int = -1;
      
      private var m_currentHoverIndex:int = -1;
      
      private var m_visibleLocalWidth:Number;
      
      private var m_bValidContent:Boolean = true;
      
      private var m_emptyContainerFeedbackTile:ChallengeCategoryTile = null;
      
      private var m_prevNextHandles:ThumbnailPrevNextHandles = null;
      
      private var m_isDirty:Boolean = false;
      
      public function ThumbnailScrollingListContainer(param1:Object)
      {
         this.m_childrenOffset = [];
         this.m_visibleLocalWidth = MenuConstants.BaseWidth;
         super(param1);
         m_mouseMode = MouseUtil.MODE_ONOVER_HOVER_ONUP_SELECTCLICK;
         this.m_selectedItemTile = new ThumbnailSelectedltemTile(this);
         this.m_selectedItemTile.visible = false;
         addChild(this.m_selectedItemTile);
         m_alwaysClampToMaxBounds = false;
         if(m_mask != null)
         {
            m_mask.x += MenuConstants.GridUnitWidth;
            m_mask.width -= MenuConstants.GridUnitWidth / 2;
         }
         if(m_maskArea != null)
         {
            m_maskArea.x += MenuConstants.GridUnitWidth;
            m_maskArea.width -= MenuConstants.GridUnitWidth / 2;
         }
         if(m_visibilityArea != null)
         {
            m_visibilityArea.x += MenuConstants.GridUnitWidth;
            m_visibilityArea.width -= MenuConstants.GridUnitWidth / 2;
         }
      }
      
      public function get selectedTileView() : ThumbnailSelectedltemTile
      {
         return this.m_selectedItemTile;
      }
      
      public function get focusedElementIndex() : int
      {
         return this.m_elementIndex;
      }
      
      public function get emptyContainerFeedbackTile() : Sprite
      {
         return this.m_emptyContainerFeedbackTile;
      }
      
      public function hasValidContent() : Boolean
      {
         return this.m_bValidContent;
      }
      
      public function isEmptyContainerFeedbackTileActive() : Boolean
      {
         return this.m_emptyContainerFeedbackTile != null;
      }
      
      override public function onSetData(param1:Object) : void
      {
         super.onSetData(param1);
         if(!isNaN(param1.sizeX) && !isNaN(param1.sizeY))
         {
            this.updateVisibleWidth(param1.sizeX,param1.sizeY);
         }
         this.m_bValidContent = !param1.novalidcontent;
         this.m_selectedItemTile.visible = false;
         if(this.m_bValidContent)
         {
            this.SetFocusedElementIndex(this.focusedElementIndex);
         }
         this.deleteContainerEmptyFeedback();
         if(!this.m_bValidContent)
         {
            this.m_emptyContainerFeedbackTile = this.createContainerEmptyFeedback(param1.containeremptydata);
            if(this.m_emptyContainerFeedbackTile != null)
            {
               this.m_emptyContainerFeedbackTile.y = -1;
               addChild(this.m_emptyContainerFeedbackTile);
            }
         }
         if(ThumbnailPrevNextHandles.arePrevNextCategoryHandlesNeeded(param1) && this.m_prevNextHandles == null)
         {
            this.m_prevNextHandles = new ThumbnailPrevNextHandles(this);
         }
         if(this.m_prevNextHandles != null)
         {
            this.m_prevNextHandles.onSetData(param1);
         }
      }
      
      override public function onUnregister() : void
      {
         this.m_currentFocusedElement = null;
         if(this.m_prevNextHandles != null)
         {
            this.m_prevNextHandles.onUnregister();
            this.m_prevNextHandles = null;
         }
         if(this.m_selectedItemTile != null)
         {
            removeChild(this.m_selectedItemTile);
            this.m_selectedItemTile.onUnregister();
            this.m_selectedItemTile = null;
         }
         this.deleteContainerEmptyFeedback();
         super.onUnregister();
         if(!ControlsMain.isVrModeActive())
         {
            System.gc();
         }
      }
      
      private function createContainerEmptyFeedback(param1:Object) : ChallengeCategoryTile
      {
         if(param1 == null)
         {
            Log.error(Log.ChannelContainer,this,"data is null, not creating EmptyContainerFeedbackTile");
            return null;
         }
         var _loc2_:ChallengeCategoryTile = new ChallengeCategoryTile(param1);
         _loc2_.onSetData(param1);
         _loc2_.setSelectedState(true);
         return _loc2_;
      }
      
      private function deleteContainerEmptyFeedback() : void
      {
         if(this.m_emptyContainerFeedbackTile != null)
         {
            this.m_emptyContainerFeedbackTile.onUnregister();
            removeChild(this.m_emptyContainerFeedbackTile);
            this.m_emptyContainerFeedbackTile = null;
         }
      }
      
      public function onReloadData(param1:MenuElementBase, param2:Object) : void
      {
         if(!this.m_bValidContent)
         {
            return;
         }
         var _loc3_:int = m_children.indexOf(param1);
         if(_loc3_ == this.m_elementIndex)
         {
            Log.info(Log.ChannelContainer,this,"updating large tile data from element " + this.m_elementIndex);
            this.m_selectedItemTile.visible = true;
            this.m_selectedItemTile.onSetData(param2);
         }
      }
      
      public function onItemSelected(param1:Object, param2:BitmapData) : void
      {
         if(!this.m_bValidContent)
         {
            return;
         }
         this.m_selectedItemTile.visible = true;
         this.m_selectedItemTile.onItemSelectionChanged(param1,param2);
      }
      
      public function onImageLoaded(param1:BitmapData) : void
      {
         if(!this.m_bValidContent)
         {
            return;
         }
         this.m_selectedItemTile.setImageFrom(param1);
      }
      
      public function onItemUnselected() : void
      {
         if(!this.m_bValidContent)
         {
            return;
         }
         this.m_selectedItemTile.onItemUnselected();
      }
      
      public function onSelectedItemRollOver() : void
      {
         if(!this.m_bValidContent)
         {
            return;
         }
         this.selectChildWithMouseEvent(this.m_elementIndex);
      }
      
      override public function addChild2(param1:Sprite, param2:int = -1) : void
      {
         super.addChild2(param1,param2);
         this.m_childrenOffset.push(false);
      }
      
      override public function repositionChild(param1:Sprite) : void
      {
         super.repositionChild(param1);
         this.m_scrollMaxBounds = getVisibleContainerBounds();
      }
      
      override public function setFocusTarget(param1:Sprite) : void
      {
         var elementIndex:int;
         var scrollTime:Number;
         var elementWasOffset:Boolean;
         var menuElem:MenuElementBase;
         var targetBounds:Rectangle;
         var scrollBounds:Rectangle;
         var target:Sprite = param1;
         if(!this.m_bValidContent)
         {
            return;
         }
         elementIndex = m_children.indexOf(target);
         if(this.focusedElementIndex != elementIndex)
         {
            this.SetFocusedElementIndex(elementIndex);
         }
         scrollTime = MenuConstants.ScrollTime;
         if(this.m_nextElementIndexFromEdgeScroll >= 0 && this.m_nextElementIndexFromEdgeScroll == this.m_elementIndex)
         {
            scrollTime = MenuConstants.ChallengeEdgeScrollTime;
         }
         else
         {
            this.m_currentHoverIndex = -1;
         }
         this.m_nextElementIndexFromEdgeScroll = -1;
         elementWasOffset = Boolean(this.m_childrenOffset[this.m_elementIndex]);
         this.resetTileOffsets();
         menuElem = target as MenuElementBase;
         targetBounds = getMenuElementBounds(menuElem,this,function(param1:MenuElementBase):Boolean
         {
            return param1.visible;
         });
         if(this.m_prevNextHandles != null)
         {
            this.m_prevNextHandles.onSetFocusAfterChildren(targetBounds,this.m_scrollMaxBounds,scrollTime);
         }
         scrollBounds = getScrollBounds();
         if(isVertical())
         {
            targetBounds.height = scrollBounds.height;
         }
         else
         {
            targetBounds.width = scrollBounds.width;
         }
         scrollToBounds(targetBounds,scrollTime);
         this.setTileOffsets(this.m_elementIndex);
      }
      
      override protected function updateChildrenVisibility(param1:Boolean, param2:Rectangle = null) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         param2 = null;
         var _loc3_:Rectangle = null;
         if(m_visibilityArea != null)
         {
            _loc3_ = m_visibilityArea.clone();
         }
         else
         {
            _loc4_ = getWidth();
            _loc3_ = new Rectangle(0,0,_loc4_,getHeight());
            _loc5_ = Math.max((this.m_visibleLocalWidth - _loc4_) / 2,0);
            _loc3_.inflate(_loc5_,0);
         }
         if(!param1)
         {
            _loc3_.width -= MenuConstants.GridUnitWidth;
         }
         updateChildrenVisibiltyOnRect(_loc3_,param1,param2);
         if(this.m_isDirty)
         {
            this.m_isDirty = false;
            if(!ControlsMain.isVrModeActive())
            {
               System.gc();
            }
         }
      }
      
      override protected function setElementVisibility(param1:Boolean, param2:MenuElementBase, param3:Boolean) : void
      {
         super.setElementVisibility(param1,param2,param3);
         var _loc4_:IImageContainer;
         if((_loc4_ = param2 as IImageContainer) == null)
         {
            return;
         }
         if(_loc4_.isImageLoaded() == param3)
         {
            return;
         }
         this.m_isDirty = true;
         if(param3)
         {
            _loc4_.loadImage();
         }
         else
         {
            _loc4_.unloadImage();
         }
      }
      
      override public function handleEvent(param1:String, param2:Sprite) : Boolean
      {
         if(param1 == "itemHoverOn")
         {
            this.doMouseEdgeScroll(param2);
            return true;
         }
         return super.handleEvent(param1,param2);
      }
      
      override public function handleMouseUp(param1:Function, param2:MouseEvent) : void
      {
         var _loc4_:Boolean = false;
         Log.mouse(this,param2);
         if(this.m_prevNextHandles != null)
         {
            if(this.m_prevNextHandles.handleMouseUp(param1,param2))
            {
               return;
            }
         }
         var _loc3_:Sprite = this.hasValidContent() ? this.m_selectedItemTile : this.m_emptyContainerFeedbackTile;
         if(_loc3_ != null)
         {
            if(!(_loc4_ = _loc3_.hitTestPoint(param2.stageX,param2.stageY,false)))
            {
               return;
            }
         }
         super.handleMouseUp(param1,param2);
      }
      
      override public function handleMouseRollOver(param1:Function, param2:MouseEvent) : void
      {
         super.handleMouseRollOver(param1,param2);
         if(!this.m_mouseEdgeScrollActivated)
         {
            this.checkMouseEdgeScrollActivation();
         }
      }
      
      override public function handleMouseWheel(param1:Function, param2:MouseEvent) : void
      {
         if(param2.delta == 0)
         {
            return;
         }
         param2.stopImmediatePropagation();
         if(!this.m_bValidContent)
         {
            return;
         }
         var _loc3_:int = param2.delta > 0 ? this.m_elementIndex - 1 : this.m_elementIndex + 1;
         this.selectChildWithMouseEvent(_loc3_);
      }
      
      private function doMouseEdgeScroll(param1:Sprite) : void
      {
         var menuElem:MenuElementBase;
         var targetBounds:Rectangle;
         var scrollBounds:Rectangle;
         var hoverIndex:int;
         var target:Sprite = param1;
         if(m_sendEventWithValue == null)
         {
            return;
         }
         if(!this.m_bValidContent)
         {
            return;
         }
         if(!this.m_mouseEdgeScrollActivated)
         {
            this.checkMouseEdgeScrollActivation();
            return;
         }
         menuElem = target as MenuElementBase;
         targetBounds = getMenuElementBounds(menuElem,this,function(param1:MenuElementBase):Boolean
         {
            return param1.visible;
         });
         scrollBounds = getScrollBounds();
         targetBounds.y = scrollBounds.y;
         if(scrollBounds.containsRect(targetBounds))
         {
            return;
         }
         hoverIndex = m_children.indexOf(target);
         if(hoverIndex == this.m_currentHoverIndex)
         {
            return;
         }
         this.m_currentHoverIndex = hoverIndex;
         if(hoverIndex == this.m_elementIndex || hoverIndex < 0 || hoverIndex >= m_children.length)
         {
            return;
         }
         this.m_nextElementIndexFromEdgeScroll = hoverIndex > this.m_elementIndex ? this.m_elementIndex + 1 : this.m_elementIndex - 1;
         this.selectChildWithMouseEvent(this.m_nextElementIndexFromEdgeScroll);
      }
      
      public function selectChildWithMouseEvent(param1:int) : void
      {
         if(param1 < 0 || param1 >= m_children.length)
         {
            return;
         }
         var _loc2_:MenuElementBase = m_children[param1] as MenuElementBase;
         var _loc3_:MouseEvent = new MouseEvent(MouseEvent.MOUSE_UP);
         _loc2_.handleMouseUp(m_sendEventWithValue,_loc3_);
      }
      
      private function checkMouseEdgeScrollActivation() : void
      {
         if(this.m_mouseEdgeScrollActivated)
         {
            return;
         }
         var _loc1_:Point = new Point(stage.mouseX,stage.mouseY);
         var _loc2_:Rectangle = getScrollBounds();
         var _loc3_:Point = globalToLocal(_loc1_);
         if(_loc2_.containsPoint(_loc3_))
         {
            this.m_mouseEdgeScrollActivated = true;
         }
      }
      
      private function resetTileOffsets() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         _loc1_ = 0;
         while(_loc1_ < m_children.length)
         {
            if(this.m_childrenOffset[_loc1_])
            {
               _loc2_ = m_children[_loc1_];
               _loc2_.x -= MenuConstants.GridUnitWidth;
               this.m_childrenOffset[_loc1_] = false;
            }
            _loc1_++;
         }
      }
      
      private function setTileOffsets(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         _loc2_ = param1;
         while(_loc2_ < m_children.length)
         {
            if(!this.m_childrenOffset[_loc2_])
            {
               _loc3_ = m_children[_loc2_];
               _loc3_.x += MenuConstants.GridUnitWidth;
               this.m_childrenOffset[_loc2_] = true;
            }
            _loc2_++;
         }
      }
      
      override protected function onScreenResize(param1:ScreenResizeEvent) : void
      {
         super.onScreenResize(param1);
         this.updateVisibleWidth(param1.screenSize.sizeX,param1.screenSize.sizeY);
         this.updateChildrenVisibility(true);
      }
      
      private function updateVisibleWidth(param1:Number, param2:Number) : void
      {
         if(param2 <= 0)
         {
            param2 = 1;
         }
         var _loc3_:Number = MenuConstants.BaseHeight / param2;
         this.m_visibleLocalWidth = param1 * _loc3_;
      }
      
      private function SetFocusedElementIndex(param1:int) : void
      {
         var _loc2_:ThumbnailItemTile = m_children[param1] as ThumbnailItemTile;
         if(this.m_currentFocusedElement != _loc2_)
         {
            if(this.m_currentFocusedElement != null)
            {
               this.m_currentFocusedElement.setFocusedOnParentList(false);
            }
            if(_loc2_ != null)
            {
               _loc2_.setFocusedOnParentList(true);
            }
            this.m_currentFocusedElement = _loc2_;
         }
         this.m_elementIndex = param1;
      }
   }
}
