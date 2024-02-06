package menu3.containers
{
   import common.Animate;
   import common.Log;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import menu3.IScreenVisibilityReceiver;
   import menu3.MenuElementBase;
   import menu3.ScreenResizeEvent;
   
   public dynamic class ScrollingListContainer extends ListContainer
   {
       
      
      protected var m_alwaysClampToMaxBounds:Boolean = true;
      
      private var m_scrollBarVertical:scrollIndicatorVerticalView;
      
      private var m_scrollBarHorizontal:scrollIndicatorHorizontalView;
      
      private var m_scrollBounds:Rectangle;
      
      private var m_scrollMaxBounds:Rectangle;
      
      protected var m_mask:MaskView;
      
      protected var m_maskArea:Rectangle;
      
      protected var m_visibilityArea:Rectangle;
      
      private var m_maskStartLeftOffset:Number;
      
      private var m_isStartMaskActive:Boolean = false;
      
      private var m_scrollingDisabled:Boolean;
      
      private var m_hideScrollBar:Boolean;
      
      private var m_overflowScrollingFactor:Number = 0;
      
      private var m_reverseStartPos:Boolean = false;
      
      private var m_mouseWheelStepSizeX:Number = 240;
      
      private var m_mouseWheelStepSizeY:Number = 120;
      
      private var m_sliderDragIsHorizontal:Boolean = false;
      
      private var m_mouseDragPos:Point;
      
      private var m_isMouseDragActive:Boolean;
      
      private var m_useMaskScrolling:Boolean = false;
      
      private var m_maskScrollingIsActive:Boolean = false;
      
      private var m_maskLastMousePos:Point;
      
      private var m_maskLastTargetBoundsRelativeToContainer:Rectangle;
      
      private var m_lastScrollWasTriggeredByMask:Boolean = false;
      
      private var m_dragAreaScrollBarH:Rectangle;
      
      private var m_dragAreaScrollBarV:Rectangle;
      
      private var m_clickAreaScrollBarH:Rectangle;
      
      private var m_clickAreaScrollBarV:Rectangle;
      
      private var m_screenScale:Number = 1;
      
      private var m_indicatorHandler:IndicatorHandler = null;
      
      private var m_clickArea:Sprite;
      
      private var m_mouseWheelScrollActive:Boolean;
      
      private var m_instantFirstScroll:Boolean = false;
      
      private var m_usePersistentReloadData:Boolean = false;
      
      private var m_debug:Boolean = false;
      
      private var m_experimentalFastMode:Boolean = false;
      
      public function ScrollingListContainer(param1:Object)
      {
         var _loc12_:Number = NaN;
         super(param1);
         this.updateScreenScale(param1.sizeY);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage,true,0,true);
         var _loc2_:Number = Number(Number(param1.width) || MenuConstants.BaseWidth);
         var _loc3_:Number = Number(Number(param1.height) || MenuConstants.BaseHeight);
         var _loc4_:Number = param1.offsetCol != undefined ? param1.offsetCol * MenuConstants.GridUnitWidth : 0;
         var _loc5_:Number = param1.offsetRow != undefined ? param1.offsetRow * MenuConstants.GridUnitHeight : 0;
         _loc2_ -= _loc4_;
         _loc3_ -= _loc5_;
         this.m_scrollBounds = new Rectangle(_loc4_,_loc5_,_loc2_ + MenuConstants.tileGap,_loc3_ + MenuConstants.tileGap);
         this.setupIndicatorHandler(param1);
         this.m_scrollingDisabled = Boolean(param1.scrollingdisabled) || Boolean(param1.novalidcontent);
         this.m_hideScrollBar = Boolean(param1.hidescrollbar) || this.m_scrollingDisabled;
         this.m_scrollBarVertical = new scrollIndicatorVerticalView();
         this.m_scrollBarVertical.x = this.m_scrollBounds.width + MenuConstants.verticalScrollGapRight;
         this.m_scrollBarVertical.visible = false;
         addChild(this.m_scrollBarVertical);
         this.m_scrollBarHorizontal = new scrollIndicatorHorizontalView();
         this.m_scrollBarHorizontal.y = MenuConstants.MenuTileLargeHeight + 4;
         this.m_scrollBarHorizontal.visible = false;
         addChild(this.m_scrollBarHorizontal);
         this.setScrollIndicatorColors();
         this.m_scrollBarHorizontal.x += _loc4_;
         this.m_scrollBarVertical.y += _loc5_;
         if(param1.scrollbarspaceoffset)
         {
            this.m_scrollBarVertical.x += param1.scrollbarspaceoffset;
            this.m_scrollBarHorizontal.y += param1.scrollbarspaceoffset;
         }
         var _loc6_:Number = Number(Number(param1.masktopoffset) || 0);
         var _loc7_:Number = Number(Number(param1.maskleftoffset) || 0);
         var _loc8_:Number = Number(Number(param1.maskwidthoffset) || 0);
         var _loc9_:Number = Number(Number(param1.maskheightoffset) || 0);
         var _loc10_:Number = Number(Number(param1.maskstartleftoffset) || 0);
         this.m_useMaskScrolling = false;
         var _loc11_:*;
         if(!(_loc11_ = param1.forceMask === true) && this.isHorizontal() && ControlsMain.isVrModeActive())
         {
            _loc11_ = true;
            if(_loc8_ == 0 && _loc7_ == 0)
            {
               _loc7_ = _loc12_ = MenuConstants.ScrollingList_VR_ExtendWidth;
               _loc8_ = _loc12_;
               _loc6_ = _loc12_;
               _loc9_ = _loc12_;
            }
         }
         if(!param1.novalidcontent && (this.isVertical() || _loc11_))
         {
            this.m_maskStartLeftOffset = _loc10_;
            this.m_mask = new MaskView();
            this.m_mask.x = this.m_scrollBounds.x - (MenuConstants.tileBorder + MenuConstants.tileGap) / 2 - _loc7_;
            this.m_mask.y = this.m_scrollBounds.y - (MenuConstants.tileBorder + MenuConstants.tileGap) / 2 - _loc6_;
            this.m_mask.width = this.m_scrollBounds.width + (MenuConstants.tileBorder + MenuConstants.tileGap) + _loc7_ + _loc8_;
            this.m_mask.height = this.m_scrollBounds.height + (MenuConstants.tileBorder + MenuConstants.tileGap) / 2 + _loc6_ + _loc9_;
            addChild(this.m_mask);
            getContainer().mask = this.m_mask;
            this.m_maskArea = new Rectangle(this.m_mask.x,this.m_mask.y,this.m_mask.width,this.m_mask.height);
            if(this.isHorizontal() && (ControlsMain.isVrModeActive() || param1.usemaskvisibilitycheck === true))
            {
               this.m_visibilityArea = this.m_maskArea.clone();
            }
            if(param1.outsidemaskscrolling)
            {
               this.m_useMaskScrolling = param1.outsidemaskscrolling;
            }
         }
         if(param1.overflowscrolling)
         {
            this.m_overflowScrollingFactor = param1.overflowscrolling;
         }
         if(param1.mousewheelstepsize)
         {
            this.m_mouseWheelStepSizeX = param1.mousewheelstepsize;
            this.m_mouseWheelStepSizeY = param1.mousewheelstepsize;
         }
         this.m_reverseStartPos = param1.reversestartpos === true;
         this.m_instantFirstScroll = param1.instantfirstscroll === true;
         this.m_usePersistentReloadData = param1.usepersistentreloaddata === true;
         this.m_experimentalFastMode = param1.experimentalfastmode === true;
         this.checkMaskScrolling();
         this.m_clickArea = new Sprite();
         addChildAt(this.m_clickArea,0);
         this.m_clickArea.graphics.clear();
         this.m_clickArea.graphics.beginFill(16711680,0);
         this.m_clickArea.graphics.drawRect(0,0,getWidth(),getHeight());
         this.m_clickArea.graphics.endFill();
      }
      
      override public function onUnregister() : void
      {
         this.disableMaskScrolling();
         if(this.m_isMouseDragActive)
         {
            this.handleDragEnd(new MouseEvent(MouseEvent.MOUSE_UP));
         }
         if(this.m_indicatorHandler)
         {
            this.m_indicatorHandler.destroy();
            this.m_indicatorHandler = null;
         }
         if(this.m_clickArea)
         {
            removeChild(this.m_clickArea);
            this.m_clickArea = null;
         }
         super.onUnregister();
      }
      
      override public function getPersistentReloadData() : Object
      {
         var _loc1_:Object = super.getPersistentReloadData();
         if(_loc1_ == null)
         {
            _loc1_ = new Object();
         }
         var _loc2_:Sprite = getContainer();
         var _loc3_:Rectangle = this.getScrollBounds();
         _loc3_.offset(-_loc2_.x,-_loc2_.y);
         _loc1_["scrollbounds"] = _loc3_;
         return _loc1_;
      }
      
      override public function onPersistentReloadData(param1:Object) : void
      {
         super.onPersistentReloadData(param1);
         if(!this.m_usePersistentReloadData || param1 == null || m_children == null || m_children.length <= 0)
         {
            return;
         }
         var _loc2_:Rectangle = param1.scrollbounds;
         if(_loc2_ != null)
         {
            this.scrollToBoundsInternal(_loc2_,0,false);
         }
      }
      
      override public function setEngineCallbacks(param1:Function, param2:Function) : void
      {
         super.setEngineCallbacks(param1,param2);
         this.m_indicatorHandler.setEngineCallback(param2);
         this.checkMaskScrolling();
      }
      
      public function getScrollBounds() : Rectangle
      {
         return this.m_scrollBounds;
      }
      
      public function isHorizontal() : Boolean
      {
         return m_direction == "horizontal";
      }
      
      public function isVertical() : Boolean
      {
         return m_direction == "vertical";
      }
      
      public function isDual() : Boolean
      {
         return m_direction == "dual";
      }
      
      public function updateScrollBar() : void
      {
         pausePopOutScale();
         this.recalculateTotalBounds();
         resumePopOutScale();
      }
      
      public function finishScrollingNow() : void
      {
         Animate.complete(getContainer());
         Animate.complete(this.m_scrollBarHorizontal.indicator);
         Animate.complete(this.m_scrollBarVertical.indicator);
      }
      
      public function getPositionX() : Number
      {
         return getContainer().x;
      }
      
      public function scrollToBounds(param1:Rectangle, param2:Number = -1) : void
      {
         if(param2 < 0)
         {
            param2 = MenuConstants.ScrollTime;
         }
         var _loc3_:Boolean = true;
         this.scrollToBoundsInternal(param1,param2,_loc3_);
      }
      
      private function setupIndicatorHandler(param1:Object) : void
      {
         this.m_indicatorHandler = new IndicatorHandler(this,param1);
      }
      
      private function scrollToMouseWheelTarget(param1:Rectangle) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = this.scrollToBoundsInternal(param1,MenuConstants.ScrollTime,_loc2_);
         if(!_loc3_)
         {
            this.m_mouseWheelScrollActive = false;
         }
      }
      
      protected function scrollToBoundsInternal(param1:Rectangle, param2:Number, param3:Boolean) : Boolean
      {
         var clampToMaxBounds:Boolean;
         var scrollCheckResult:Object;
         var overflowTargetBound:Rectangle = null;
         var scrollOffsetX:Number = NaN;
         var centerX:Number = NaN;
         var centerTargetX:Number = NaN;
         var rectUnionX:Rectangle = null;
         var currentX:Number = NaN;
         var scrollOffsetY:Number = NaN;
         var centerY:Number = NaN;
         var centerTargetY:Number = NaN;
         var rectUnionY:Rectangle = null;
         var currentY:Number = NaN;
         var targetIsTopLeft:Boolean = false;
         var scrollAnimationTime:Number = NaN;
         var targetBounds:Rectangle = param1;
         var scrollTime:Number = param2;
         var useOverflowScrolling:Boolean = param3;
         if(this.m_scrollingDisabled)
         {
            return false;
         }
         this.m_lastScrollWasTriggeredByMask = false;
         clampToMaxBounds = this.m_alwaysClampToMaxBounds;
         if(useOverflowScrolling && this.m_overflowScrollingFactor > 0)
         {
            overflowTargetBound = targetBounds.clone();
            overflowTargetBound.inflate(targetBounds.width * this.m_overflowScrollingFactor,targetBounds.height * this.m_overflowScrollingFactor);
            targetBounds = overflowTargetBound;
            clampToMaxBounds = true;
         }
         if(this.m_debug)
         {
            Log.info(Log.ChannelDebug,this,"scrollBounds: x=" + this.m_scrollBounds.x + " y=" + this.m_scrollBounds.y + " w=" + this.m_scrollBounds.width + " h=" + this.m_scrollBounds.height);
            Log.info(Log.ChannelDebug,this,"targetBounds: x=" + targetBounds.x + " y=" + targetBounds.y + " w=" + targetBounds.width + " h=" + targetBounds.height);
         }
         if(clampToMaxBounds)
         {
            targetBounds = this.clampTargetBoundsToMaxScrollBounds(targetBounds);
            if(this.m_debug)
            {
               Log.info(Log.ChannelDebug,this,"clamped targetBounds: x=" + targetBounds.x + " y=" + targetBounds.y + " w=" + targetBounds.width + " h=" + targetBounds.height);
            }
         }
         if(this.m_scrollBounds.containsRect(targetBounds))
         {
            Animate.kill(getContainer());
            Animate.kill(this.m_scrollBarHorizontal.indicator);
            Animate.kill(this.m_scrollBarVertical.indicator);
            return false;
         }
         scrollCheckResult = new Object();
         if(this.isHorizontal() || this.isDual())
         {
            scrollOffsetX = 0;
            centerX = (this.m_scrollBounds.left + this.m_scrollBounds.right) * 0.5;
            centerTargetX = (targetBounds.left + targetBounds.right) * 0.5;
            if(targetBounds.width > this.m_scrollBounds.width)
            {
               scrollOffsetX = Math.abs(centerTargetX - centerX);
            }
            else
            {
               rectUnionX = this.m_scrollBounds.union(targetBounds);
               scrollOffsetX = rectUnionX.width - this.m_scrollBounds.width;
            }
            if(scrollOffsetX > 0)
            {
               currentX = getContainer().x;
               if(centerX > centerTargetX)
               {
                  currentX += scrollOffsetX;
                  scrollCheckResult.dirX = 1;
               }
               else
               {
                  currentX -= scrollOffsetX;
                  scrollCheckResult.dirX = -1;
               }
               scrollCheckResult["x"] = currentX;
            }
         }
         if(this.isVertical() || this.isDual())
         {
            scrollOffsetY = 0;
            centerY = (this.m_scrollBounds.top + this.m_scrollBounds.bottom) * 0.5;
            centerTargetY = (targetBounds.top + targetBounds.bottom) * 0.5;
            if(targetBounds.height > this.m_scrollBounds.height)
            {
               scrollOffsetY = Math.abs(centerTargetY - centerY);
            }
            else
            {
               rectUnionY = this.m_scrollBounds.union(targetBounds);
               scrollOffsetY = rectUnionY.height - this.m_scrollBounds.height;
            }
            if(scrollOffsetY > 0)
            {
               currentY = getContainer().y;
               if(centerY > centerTargetY)
               {
                  currentY += scrollOffsetY;
                  scrollCheckResult.dirY = 1;
               }
               else
               {
                  currentY -= scrollOffsetY;
                  scrollCheckResult.dirY = -1;
               }
               scrollCheckResult["y"] = currentY;
            }
         }
         if(scrollCheckResult["x"] !== undefined || scrollCheckResult["y"] !== undefined)
         {
            targetIsTopLeft = true;
            scrollAnimationTime = MenuConstants.SwipeInTime;
            if(scrollTime == 0)
            {
               scrollAnimationTime = 0;
            }
            Animate.kill(getContainer());
            if(scrollCheckResult["x"] !== undefined)
            {
               if(scrollCheckResult["x"] < -0.01)
               {
                  targetIsTopLeft = false;
               }
               if(scrollTime != 0)
               {
                  Animate.legacyTo(getContainer(),scrollTime,{"x":scrollCheckResult["x"]},Animate.ExpoOut,function():void
                  {
                     onScrollComplete();
                  });
               }
               else
               {
                  getContainer().x = scrollCheckResult["x"];
               }
               if(this.m_scrollBarHorizontal.visible)
               {
                  this.updateHorizontalScrollIndicator(scrollCheckResult["x"],scrollAnimationTime);
               }
            }
            if(scrollCheckResult["y"] !== undefined)
            {
               if(scrollCheckResult["y"] < -0.01)
               {
                  targetIsTopLeft = false;
               }
               if(scrollTime != 0)
               {
                  Animate.legacyTo(getContainer(),scrollTime,{"y":scrollCheckResult["y"]},Animate.ExpoOut,function():void
                  {
                     onScrollComplete();
                  });
               }
               else
               {
                  getContainer().y = scrollCheckResult["y"];
               }
               if(this.m_scrollBarVertical.visible)
               {
                  this.updateVerticalScrollIndicator(scrollCheckResult["y"],scrollAnimationTime);
               }
            }
            if(this.m_mask != null && this.m_maskStartLeftOffset != 0)
            {
               this.setStartMaskActive(targetIsTopLeft,scrollTime / 2);
            }
            this.updateChildrenVisibility(false,targetBounds);
         }
         else
         {
            scrollTime = 0;
         }
         if(scrollTime == 0)
         {
            Animate.delay(getContainer(),scrollTime,function():void
            {
               onScrollComplete();
            });
         }
         return true;
      }
      
      protected function onScrollComplete() : void
      {
         this.m_mouseWheelScrollActive = false;
         this.updateChildrenVisibility(true);
      }
      
      override public function onChildrenChanged() : void
      {
         super.onChildrenChanged();
         if(this.m_experimentalFastMode)
         {
            this.recalculateTotalBounds();
         }
         this.updateChildrenVisibility(true);
      }
      
      protected function updateChildrenVisibility(param1:Boolean, param2:Rectangle = null) : void
      {
         if(this.m_visibilityArea == null)
         {
            return;
         }
         this.updateChildrenVisibiltyOnRect(this.m_visibilityArea,param1,param2);
      }
      
      protected function updateChildrenVisibiltyOnRect(param1:Rectangle, param2:Boolean, param3:Rectangle = null) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc4_:Rectangle = param1.clone();
         if(param3 != null)
         {
            _loc4_ = _loc4_.union(param3);
            if(this.m_debug)
            {
               Log.info(Log.ChannelDebug,this,"updateChildrenVisibilty: targetBounds: " + param3);
               Log.info(Log.ChannelDebug,this,"updateChildrenVisibilty: Visible Area0: " + param1);
            }
         }
         _loc4_.inflate(MenuConstants.GridUnitWidth,0);
         if(this.m_debug)
         {
            Log.info(Log.ChannelDebug,this,"updateChildrenVisibilty: Visible Area: " + param1);
         }
         this.updateContainerElementVisibility(param2,_loc4_,this);
      }
      
      private function updateContainerElementVisibility(param1:Boolean, param2:Rectangle, param3:BaseContainer) : void
      {
         var _loc7_:Rectangle = null;
         var _loc4_:BaseContainer = null;
         var _loc5_:MenuElementBase = null;
         var _loc6_:int = 0;
         while(_loc6_ < param3.m_children.length)
         {
            if((_loc5_ = param3.m_children[_loc6_] as MenuElementBase) != null)
            {
               _loc7_ = _loc5_.getBounds(this);
               if(param2.intersects(_loc7_))
               {
                  if(this.m_debug)
                  {
                     Log.info(Log.ChannelDebug,this,"updateChildrenVisibilty: Child " + _loc6_ + " bounds = " + _loc7_ + " in visible area");
                  }
                  this.setElementVisibility(param1,_loc5_,true);
                  if((_loc4_ = _loc5_ as BaseContainer) != null)
                  {
                     this.updateContainerElementVisibility(param1,param2,_loc4_);
                  }
               }
               else
               {
                  if(this.m_debug)
                  {
                     Log.info(Log.ChannelDebug,this,"updateChildrenVisibilty: Child " + _loc6_ + " bounds = " + _loc7_);
                  }
                  this.setElementVisibility(param1,_loc5_,false);
               }
            }
            _loc6_++;
         }
      }
      
      protected function setElementVisibility(param1:Boolean, param2:MenuElementBase, param3:Boolean) : void
      {
         param2.alpha = param3 ? 1 : 0;
         var _loc4_:IScreenVisibilityReceiver;
         if((_loc4_ = param2 as IScreenVisibilityReceiver) != null)
         {
            _loc4_.setVisibleOnScreen(param3);
         }
      }
      
      private function setStartMaskActive(param1:Boolean, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(getContainer().mask != this.m_mask || this.m_mask == null)
         {
            return;
         }
         if(this.m_isStartMaskActive == param1)
         {
            return;
         }
         this.m_isStartMaskActive = param1;
         if(param1)
         {
            _loc3_ = this.m_maskArea.x - this.m_maskStartLeftOffset;
            _loc4_ = this.m_maskArea.width + this.m_maskStartLeftOffset;
            if(ControlsMain.isVrModeActive())
            {
               Animate.kill(this.m_mask);
               this.m_mask.x = _loc3_;
               this.m_mask.width = _loc4_;
            }
            else
            {
               Animate.to(this.m_mask,param2,0,{
                  "x":_loc3_,
                  "width":_loc4_
               },Animate.Linear);
            }
         }
         else
         {
            Animate.kill(this.m_mask);
            this.m_mask.x = this.m_maskArea.x;
            this.m_mask.width = this.m_maskArea.width;
         }
      }
      
      protected function setScrollIndicatorColors() : void
      {
         if(this.m_scrollBarVertical != null)
         {
            MenuUtils.setColor(this.m_scrollBarVertical.indicator,MenuConstants.COLOR_RED,true,MenuConstants.MenuElementSelectedAlpha);
            MenuUtils.setColor(this.m_scrollBarVertical.indicatorbg,MenuConstants.COLOR_MENU_TABS_BACKGROUND,true,MenuConstants.MenuElementBackgroundAlpha);
         }
         if(this.m_scrollBarHorizontal != null)
         {
            MenuUtils.setColor(this.m_scrollBarHorizontal.indicator,MenuConstants.COLOR_RED,true,MenuConstants.MenuElementSelectedAlpha);
            MenuUtils.setColor(this.m_scrollBarHorizontal.indicatorbg,MenuConstants.COLOR_MENU_TABS_BACKGROUND,true,MenuConstants.MenuElementBackgroundAlpha);
         }
      }
      
      private function setScrollIndicator(param1:Number, param2:Number, param3:Boolean) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(param3)
         {
            this.m_scrollBarVertical.indicatorbg.height = param1;
            this.m_scrollBarVertical.arrowup.alpha = 0;
            this.m_scrollBarVertical.arrowdown.alpha = 0;
            this.m_scrollBarVertical.arrowdown.y = param1;
            _loc4_ = param1 / param2 * 100;
            this.m_scrollBarVertical.indicator.height = _loc4_ * param1 / 100;
            this.m_scrollBarVertical.visible = true;
            this.m_dragAreaScrollBarV = this.m_scrollBarVertical.indicator.getBounds(this);
            this.m_dragAreaScrollBarV.inflate(20,0);
            this.m_clickAreaScrollBarV = this.m_scrollBarVertical.indicatorbg.getBounds(this);
            this.m_clickAreaScrollBarV.inflate(20,0);
         }
         else
         {
            this.m_scrollBarHorizontal.indicatorbg.width = param1;
            this.m_scrollBarHorizontal.arrowleft.alpha = 0;
            this.m_scrollBarHorizontal.arrowright.alpha = 0;
            this.m_scrollBarHorizontal.arrowright.x = param1;
            _loc5_ = param1 / param2 * 100;
            this.m_scrollBarHorizontal.indicator.width = _loc5_ * param1 / 100;
            this.m_scrollBarHorizontal.visible = true;
            this.m_dragAreaScrollBarH = this.m_scrollBarHorizontal.indicator.getBounds(this);
            this.m_dragAreaScrollBarH.inflate(0,20);
            this.m_clickAreaScrollBarH = this.m_scrollBarHorizontal.indicatorbg.getBounds(this);
            this.m_clickAreaScrollBarH.inflate(0,20);
         }
      }
      
      private function updateVerticalScrollIndicator(param1:int, param2:Number) : void
      {
         var _loc3_:Number = param1 / this.m_scrollBounds.height * this.m_scrollBarVertical.indicator.height;
         if(param2 > 0)
         {
            Animate.legacyTo(this.m_scrollBarVertical.indicator,param2,{"y":-_loc3_},Animate.ExpoOut);
         }
         else
         {
            this.m_scrollBarVertical.indicator.y = -_loc3_;
         }
         this.m_dragAreaScrollBarV.y = -_loc3_;
      }
      
      private function updateHorizontalScrollIndicator(param1:int, param2:Number) : void
      {
         var _loc3_:Number = param1 / this.m_scrollBounds.width * this.m_scrollBarHorizontal.indicator.width;
         if(param2 > 0)
         {
            Animate.legacyTo(this.m_scrollBarHorizontal.indicator,param2,{"x":-_loc3_},Animate.ExpoOut);
         }
         else
         {
            this.m_scrollBarHorizontal.indicator.x = -_loc3_;
         }
         this.m_dragAreaScrollBarH.x = -_loc3_;
      }
      
      protected function recalculateTotalBounds() : void
      {
         var _loc9_:Rectangle = null;
         var _loc10_:Rectangle = null;
         var _loc1_:Rectangle = getVisibleContainerBounds();
         this.m_scrollMaxBounds = _loc1_.clone();
         var _loc2_:Sprite = getContainer();
         if(_loc2_ != null)
         {
            this.m_scrollMaxBounds.x -= _loc2_.x;
            this.m_scrollMaxBounds.y -= _loc2_.y;
         }
         this.m_scrollBarVertical.visible = false;
         this.m_scrollBarHorizontal.visible = false;
         if((this.isVertical() || this.isDual()) && !this.m_hideScrollBar && Math.floor(this.m_scrollMaxBounds.height) > this.m_scrollBounds.height)
         {
            this.setScrollIndicator(this.m_scrollBounds.height,this.m_scrollMaxBounds.height,true);
            this.updateVerticalScrollIndicator(getContainer().y,0);
         }
         if((this.isHorizontal() || this.isDual()) && !this.m_hideScrollBar && Math.floor(this.m_scrollMaxBounds.width) > this.m_scrollBounds.width)
         {
            this.setScrollIndicator(this.m_scrollBounds.width,this.m_scrollMaxBounds.width,false);
            this.updateHorizontalScrollIndicator(getContainer().x,0);
         }
         var _loc3_:Number = getContainer().x * -1;
         var _loc4_:Number = getContainer().y * -1;
         var _loc5_:Number = Math.max(_loc3_ + this.m_scrollBounds.width - this.m_scrollMaxBounds.width,0);
         var _loc6_:Number = Math.max(_loc4_ + this.m_scrollBounds.height - this.m_scrollMaxBounds.height,0);
         var _loc7_:Number = Math.min(_loc5_,_loc3_) * -1;
         var _loc8_:Number = Math.min(_loc6_,_loc4_) * -1;
         if(this.m_debug)
         {
            Log.info(Log.ChannelDebug,this,"xPos: " + _loc3_ + " yPos:" + _loc4_);
            Log.info(Log.ChannelDebug,this,"m_scrollMaxBounds width: " + this.m_scrollMaxBounds.width + " height:" + this.m_scrollMaxBounds.height);
            Log.info(Log.ChannelDebug,this,"m_scrollBounds width: " + this.m_scrollBounds.width + " height:" + this.m_scrollBounds.height);
            Log.info(Log.ChannelDebug,this,"offsetX: " + _loc7_ + " offsetY:" + _loc8_);
         }
         if(_loc7_ < 0 || _loc8_ < 0)
         {
            _loc9_ = this.getScrollTargetFromOffset(_loc7_,_loc8_);
            this.scrollToBounds(_loc9_,0);
         }
         if(this.m_reverseStartPos)
         {
            _loc10_ = new Rectangle(_loc1_.x + _loc1_.width - 1,_loc1_.y + _loc1_.height - 1,1,1);
            this.scrollToBounds(_loc10_,0);
         }
      }
      
      public function setFocusTarget(param1:Sprite) : void
      {
         var menuElem:MenuElementBase;
         var targetBounds:Rectangle;
         var target:Sprite = param1;
         if(this.m_mouseWheelScrollActive)
         {
            return;
         }
         menuElem = target as MenuElementBase;
         if(this.m_debug && menuElem != null)
         {
            Log.info(Log.ChannelDebug,this,"setFocusTarget: " + menuElem.name);
            Log.info(Log.ChannelDebug,menuElem,"y: " + menuElem.y);
         }
         targetBounds = getMenuElementBounds(menuElem,this,function(param1:MenuElementBase):Boolean
         {
            return param1.visible;
         });
         if(this.m_instantFirstScroll)
         {
            this.m_instantFirstScroll = false;
            this.scrollToBounds(targetBounds,0);
         }
         else
         {
            this.scrollToBounds(targetBounds);
         }
      }
      
      override protected function handleSelectionChange() : void
      {
         if(m_isSelected)
         {
            bubbleEvent("scrollingListContainerSelected",this);
         }
      }
      
      override public function repositionChild(param1:Sprite) : void
      {
         super.repositionChild(param1);
         if(!this.m_experimentalFastMode)
         {
            this.recalculateTotalBounds();
         }
      }
      
      override public function handleEvent(param1:String, param2:Sprite) : Boolean
      {
         if(param1 == "itemSelected")
         {
            this.setFocusTarget(param2);
            bubbleEvent("scrollingListContainerScrolled",this);
         }
         if(param1 == "itemHoverOn")
         {
            this.setFocusTarget(param2);
            bubbleEvent("scrollingListContainerScrolled",this);
         }
         return super.handleEvent(param1,param2);
      }
      
      override public function handleMouseDown(param1:Function, param2:MouseEvent) : void
      {
         var _loc3_:Point = null;
         var _loc4_:Point = null;
         var _loc5_:Boolean = false;
         var _loc6_:Number = NaN;
         var _loc7_:Rectangle = null;
         var _loc8_:Number = NaN;
         var _loc9_:Rectangle = null;
         if(this.m_scrollBarVertical.visible || this.m_scrollBarHorizontal.visible)
         {
            _loc3_ = new Point(param2.stageX,param2.stageY);
            _loc4_ = globalToLocal(_loc3_);
            _loc5_ = false;
            if(this.m_scrollBarVertical.visible)
            {
               if(this.m_dragAreaScrollBarV.containsPoint(_loc4_))
               {
                  param2.stopImmediatePropagation();
                  _loc5_ = true;
                  this.m_sliderDragIsHorizontal = false;
               }
               else if(this.m_clickAreaScrollBarV.containsPoint(_loc4_))
               {
                  param2.stopImmediatePropagation();
                  _loc6_ = _loc4_.y < this.m_dragAreaScrollBarV.y ? -1 : 1;
                  _loc7_ = this.getScrollTargetFromOffset(0,this.m_scrollBounds.height * _loc6_);
                  this.scrollToMouseWheelTarget(_loc7_);
                  bubbleEvent("scrollingListContainerScrolled",this);
                  return;
               }
            }
            if(!_loc5_ && this.m_scrollBarHorizontal.visible)
            {
               if(this.m_dragAreaScrollBarH.containsPoint(_loc4_))
               {
                  param2.stopImmediatePropagation();
                  _loc5_ = true;
                  this.m_sliderDragIsHorizontal = true;
               }
               else if(this.m_clickAreaScrollBarH.containsPoint(_loc4_))
               {
                  param2.stopImmediatePropagation();
                  _loc8_ = _loc4_.x < this.m_dragAreaScrollBarH.x ? -1 : 1;
                  _loc9_ = this.getScrollTargetFromOffset(this.m_scrollBounds.width * _loc8_,0);
                  this.scrollToMouseWheelTarget(_loc9_);
                  bubbleEvent("scrollingListContainerScrolled",this);
                  return;
               }
            }
            if(_loc5_)
            {
               this.m_isMouseDragActive = true;
               stage.addEventListener(MouseEvent.MOUSE_MOVE,this.handleDragMouseMove,true);
               stage.addEventListener(MouseEvent.MOUSE_UP,this.handleDragEnd,true);
               stage.addEventListener(MouseEvent.MOUSE_DOWN,this.handleDragEnd,true);
               this.m_mouseDragPos = _loc3_;
               return;
            }
         }
         super.handleMouseDown(param1,param2);
      }
      
      public function handleDragMouseMove(param1:MouseEvent) : void
      {
         var _loc7_:Rectangle = null;
         param1.stopImmediatePropagation();
         var _loc2_:Point = new Point(param1.stageX,param1.stageY);
         var _loc3_:Point = _loc2_.subtract(this.m_mouseDragPos);
         this.m_mouseDragPos = _loc2_;
         var _loc4_:Number = this.m_scrollMaxBounds.width / this.m_scrollBounds.width * this.m_screenScale;
         var _loc5_:Number = this.m_scrollMaxBounds.height / this.m_scrollBounds.height * this.m_screenScale;
         var _loc6_:Point = new Point(_loc3_.x * _loc4_,_loc3_.y * _loc5_);
         if(this.m_sliderDragIsHorizontal)
         {
            _loc7_ = this.getScrollTargetFromOffset(_loc6_.x,0);
         }
         else
         {
            _loc7_ = this.getScrollTargetFromOffset(0,_loc6_.y);
         }
         var _loc8_:Number = 0;
         var _loc9_:Boolean = false;
         this.scrollToBoundsInternal(_loc7_,_loc8_,_loc9_);
         bubbleEvent("scrollingListContainerScrolled",this);
      }
      
      private function handleDragEnd(param1:MouseEvent) : void
      {
         this.m_isMouseDragActive = false;
         param1.stopImmediatePropagation();
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.handleDragMouseMove,true);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.handleDragEnd,true);
         stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.handleDragEnd,true);
      }
      
      override public function handleMouseWheel(param1:Function, param2:MouseEvent) : void
      {
         if(param2.delta == 0)
         {
            return;
         }
         if(this.m_mouseWheelStepSizeX == 0 && this.m_mouseWheelStepSizeY == 0)
         {
            return;
         }
         param2.stopImmediatePropagation();
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         if(this.isHorizontal())
         {
            _loc3_ = -param2.delta * this.m_mouseWheelStepSizeX;
         }
         else
         {
            _loc4_ = -param2.delta * this.m_mouseWheelStepSizeY;
         }
         var _loc5_:Rectangle = this.getScrollTargetFromOffset(_loc3_,_loc4_);
         this.m_mouseWheelScrollActive = true;
         this.scrollToMouseWheelTarget(_loc5_);
         bubbleEvent("scrollingListContainerScrolled",this);
      }
      
      private function getScrollTargetFromOffset(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Rectangle = this.m_scrollBounds.clone();
         _loc3_.offset(this.m_scrollMaxBounds.x,this.m_scrollMaxBounds.y);
         _loc3_.offset(param1,param2);
         return this.clampTargetBoundsToMaxScrollBounds(_loc3_);
      }
      
      private function clampTargetBoundsToMaxScrollBounds(param1:Rectangle) : Rectangle
      {
         if(this.m_scrollMaxBounds != null)
         {
            param1.offset(getContainer().x * -1,getContainer().y * -1);
            param1 = param1.intersection(this.m_scrollMaxBounds);
            param1.offset(getContainer().x,getContainer().y);
         }
         return param1;
      }
      
      protected function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage,true);
         stage.addEventListener(ScreenResizeEvent.SCREEN_RESIZED,this.onScreenResize,true,0,true);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage,false);
      }
      
      protected function onRemovedFromStage(param1:Event) : void
      {
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage,false);
         stage.removeEventListener(ScreenResizeEvent.SCREEN_RESIZED,this.onScreenResize,true);
      }
      
      protected function onScreenResize(param1:ScreenResizeEvent) : void
      {
         var _loc2_:Object = param1.screenSize;
         this.updateScreenScale(_loc2_.sizeY);
      }
      
      private function updateScreenScale(param1:Number) : void
      {
         if(param1 <= 0)
         {
            param1 = 1;
         }
         this.m_screenScale = MenuConstants.BaseHeight / param1;
      }
      
      private function checkMaskScrolling() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:* = m_sendEventWithValue != null;
         if(this.m_useMaskScrolling && _loc2_)
         {
            _loc1_ = true;
         }
         if(_loc1_ == this.m_maskScrollingIsActive)
         {
            return;
         }
         if(_loc1_)
         {
            this.enableMaskScrolling();
         }
         else
         {
            this.disableMaskScrolling();
         }
      }
      
      private function enableMaskScrolling() : void
      {
         if(!this.m_maskScrollingIsActive)
         {
            this.m_maskScrollingIsActive = true;
            getContainer().addEventListener(Event.ENTER_FRAME,this.updateMaskScrolling);
         }
      }
      
      private function disableMaskScrolling() : void
      {
         if(this.m_maskScrollingIsActive)
         {
            this.m_maskScrollingIsActive = false;
            getContainer().removeEventListener(Event.ENTER_FRAME,this.updateMaskScrolling);
         }
      }
      
      private function updateMaskScrolling() : void
      {
         if(!this.m_maskScrollingIsActive || stage == null)
         {
            return;
         }
         var _loc1_:Point = new Point(stage.mouseX,stage.mouseY);
         if(this.m_maskLastMousePos != null && this.m_maskLastMousePos.equals(_loc1_) && !this.m_lastScrollWasTriggeredByMask)
         {
            this.m_maskLastTargetBoundsRelativeToContainer = null;
            return;
         }
         this.m_maskLastMousePos = _loc1_;
         var _loc2_:Point = globalToLocal(_loc1_);
         if(this.m_maskArea.containsPoint(_loc2_))
         {
            return;
         }
         var _loc3_:Rectangle = this.m_scrollMaxBounds.clone();
         var _loc4_:Sprite = getContainer();
         _loc3_.x += _loc4_.x;
         _loc3_.y += _loc4_.y;
         if(!_loc3_.containsPoint(_loc2_))
         {
            return;
         }
         var _loc5_:Rectangle = null;
         var _loc6_:Rectangle;
         if((_loc6_ = this.getLeafElementBounds(m_children,_loc2_)) != null)
         {
            (_loc5_ = _loc6_.clone()).offset(-_loc4_.x,-_loc4_.y);
            _loc5_.inflate(-10,-10);
            if(this.m_maskLastTargetBoundsRelativeToContainer == null || !this.m_maskLastTargetBoundsRelativeToContainer.intersects(_loc5_))
            {
               this.scrollToBounds(_loc6_);
               this.m_lastScrollWasTriggeredByMask = true;
            }
         }
         this.m_maskLastTargetBoundsRelativeToContainer = _loc5_;
      }
      
      private function getLeafElementBounds(param1:Array, param2:Point) : Rectangle
      {
         var element:MenuElementBase = null;
         var elementBounds:Rectangle = null;
         var bounds:Rectangle = null;
         var m_children:Array = param1;
         var pos:Point = param2;
         var i:int = 0;
         while(i < m_children.length)
         {
            element = m_children[i] as MenuElementBase;
            if(element != null)
            {
               elementBounds = getMenuElementBounds(element,this,function(param1:MenuElementBase):Boolean
               {
                  return param1.visible;
               });
               if(elementBounds.containsPoint(pos))
               {
                  if(element.m_children.length > 0)
                  {
                     bounds = this.getLeafElementBounds(element.m_children,pos);
                     return bounds;
                  }
                  return elementBounds;
               }
            }
            i++;
         }
         return null;
      }
   }
}
