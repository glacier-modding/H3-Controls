package menu3.containers
{
   import basic.ButtonPromtUtil;
   import basic.IButtonPromptOwner;
   import common.Animate;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import menu3.MenuElementBase;
   import menu3.ScreenResizeEvent;
   import menu3.basic.ICategoryElement;
   import menu3.basic.TopNavigationHandler;
   
   public dynamic class ScrollingTabsContainer extends ListContainer implements IButtonPromptOwner
   {
       
      
      private const SUB_MENU_START_Y:Number = MenuConstants.TabsBgOffsetYPos + 76;
      
      private const SUB_MENU_HEIGHT:Number = 38;
      
      private var m_scrollBounds:Rectangle;
      
      private var m_mask:MaskView;
      
      private var m_tabBackground:Sprite;
      
      private var m_scrollMaxBounds:Rectangle;
      
      private var m_overflowScrollingFactor:Number = 0;
      
      private var m_topNavigation:TopNavigationHandler = null;
      
      private var m_isSubMenu:Boolean = false;
      
      private var m_screenWidth:Number;
      
      private var m_screenHeight:Number;
      
      private var m_safeAreaRatio:Number;
      
      private var m_originalBarPosX:Number;
      
      private var m_showLine:Boolean = false;
      
      private var m_previousVisibilityConfig:Object = null;
      
      public function ScrollingTabsContainer(param1:Object)
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         this.m_originalBarPosX = (MenuConstants.MenuWidth - MenuConstants.BaseWidth) * 0.5;
         super(param1);
         this.m_screenWidth = isNaN(param1.sizeX) ? MenuConstants.BaseWidth : Number(param1.sizeX);
         this.m_screenHeight = isNaN(param1.sizeY) ? MenuConstants.BaseHeight : Number(param1.sizeY);
         this.m_safeAreaRatio = isNaN(param1.safeAreaRatio) ? 1 : Number(param1.safeAreaRatio);
         this.m_isSubMenu = param1.submenu === true;
         var _loc2_:Number = Number(Number(param1.width) || MenuConstants.BaseWidth);
         var _loc3_:Number = Number(Number(param1.height) || MenuConstants.BaseHeight);
         this.m_scrollBounds = new Rectangle(0,0,_loc2_,_loc3_);
         if(param1.overflowscrolling)
         {
            this.m_overflowScrollingFactor = param1.overflowscrolling;
         }
         if(!this.m_isSubMenu)
         {
            this.m_previousVisibilityConfig = null;
            this.m_topNavigation = new TopNavigationHandler();
            this.m_topNavigation.onSetData(param1.topnavigation);
         }
         if(!this.m_isSubMenu)
         {
            this.updateButtonPrompts();
         }
         var _loc4_:Number = this.m_isSubMenu ? this.SUB_MENU_START_Y : MenuConstants.TabsBgOffsetYPos;
         var _loc5_:Number = this.m_isSubMenu ? this.SUB_MENU_HEIGHT : MenuConstants.TabsLineLowerYPos - MenuConstants.TabsLineMidYPos;
         this.m_tabBackground = new Sprite();
         this.m_tabBackground.graphics.clear();
         this.m_tabBackground.graphics.beginFill(MenuConstants.COLOR_MENU_TABS_BACKGROUND,MenuConstants.MenuElementBackgroundAlpha);
         this.m_tabBackground.graphics.drawRect(0,_loc4_,MenuConstants.BaseWidth,_loc5_);
         this.m_tabBackground.graphics.endFill();
         this.m_tabBackground.alpha = 0;
         addChildAt(this.m_tabBackground,0);
         this.m_tabBackground.x = this.m_originalBarPosX;
         if(ControlsMain.isVrModeActive())
         {
            _loc7_ = _loc6_ = MenuConstants.ScrollingList_VR_ExtendWidth;
            _loc8_ = _loc6_;
            _loc9_ = _loc6_;
            _loc10_ = _loc6_;
            this.m_mask = new MaskView();
            this.m_mask.x = this.m_scrollBounds.x - (MenuConstants.tileBorder + MenuConstants.tileGap) / 2 - _loc8_;
            this.m_mask.y = this.m_scrollBounds.y - (MenuConstants.tileBorder + MenuConstants.tileGap) / 2 - _loc7_;
            this.m_mask.width = this.m_scrollBounds.width + (MenuConstants.tileBorder + MenuConstants.tileGap) + _loc8_ + _loc9_;
            this.m_mask.height = this.m_scrollBounds.height + (MenuConstants.tileBorder + MenuConstants.tileGap) / 2 + _loc7_ + _loc10_;
            addChild(this.m_mask);
            getContainer().mask = this.m_mask;
         }
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      override public function onSetData(param1:Object) : void
      {
         super.onSetData(param1);
         if(!this.m_isSubMenu)
         {
            this.m_previousVisibilityConfig = null;
            this.m_topNavigation = new TopNavigationHandler();
            this.m_topNavigation.onSetData(param1.topnavigation);
         }
      }
      
      override public function addChild2(param1:Sprite, param2:int = -1) : void
      {
         var _loc3_:ICategoryElement = null;
         if(this.m_isSubMenu && getContainer().numChildren > 0)
         {
            _loc3_ = param1 as ICategoryElement;
            if(_loc3_ != null)
            {
               _loc3_.enableSpacer();
            }
         }
         super.addChild2(param1,param2);
      }
      
      override public function onUnregister() : void
      {
         if(this.m_topNavigation != null)
         {
            this.m_topNavigation.onUnregister();
            this.m_topNavigation = null;
            this.m_previousVisibilityConfig = null;
         }
         super.onUnregister();
      }
      
      public function updateButtonPromptVisibility(param1:Object) : void
      {
         var _loc3_:* = false;
         var _loc4_:Object = null;
         var _loc2_:Object = getData();
         if(_loc2_.buttonprompts)
         {
            if(!MenuUtils.isDataEqual(this.m_previousVisibilityConfig,param1))
            {
               this.m_previousVisibilityConfig = param1;
               _loc3_ = this.m_topNavigation != null;
               for each(_loc4_ in _loc2_.buttonprompts)
               {
                  this.replaceButtonPrompt(_loc4_.actiontype,"rb",{
                     "name":"rb",
                     "transparentPrompt":!param1.rb && !_loc3_,
                     "hidePrompt":!param1.rb && _loc3_
                  });
                  this.replaceButtonPrompt(_loc4_.actiontype,"lb",{
                     "name":"lb",
                     "transparentPrompt":!param1.lb && !_loc3_,
                     "hidePrompt":!param1.lb && _loc3_
                  });
               }
               this.updateButtonPrompts();
            }
         }
      }
      
      private function replaceButtonPrompt(param1:Object, param2:String, param3:Object) : void
      {
         var _loc5_:Object = null;
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            if((_loc5_ = param1[_loc4_]) is Array)
            {
               this.replaceButtonPrompt(_loc5_ as Array,param2,param3);
            }
            else if(_loc5_ is String)
            {
               if(_loc5_ == param2)
               {
                  param1[_loc4_] = param3;
               }
            }
            else if(_loc5_ is Object)
            {
               if(_loc5_["name"] == param2)
               {
                  param1[_loc4_] = param3;
               }
            }
            _loc4_++;
         }
      }
      
      public function updateButtonPrompts() : void
      {
         var _loc2_:Function = null;
         var _loc1_:Object = getData();
         if(_loc1_.buttonprompts)
         {
            _loc2_ = null;
            if(m_sendEventWithValue != null)
            {
               _loc2_ = this.handlePromptMouseEvent;
            }
            MenuUtils.parsePrompts(_loc1_,null,this.m_topNavigation.m_promptsContainer,true,_loc2_);
         }
      }
      
      private function handlePromptMouseEvent(param1:String) : void
      {
         var _loc2_:int = 0;
         if(m_sendEventWithValue == null)
         {
            return;
         }
         if(this["_nodedata"])
         {
            _loc2_ = this["_nodedata"]["id"] as int;
            if(param1 == "lb")
            {
               m_sendEventWithValue("onElementPagePrev",_loc2_);
            }
            else if(param1 == "rb")
            {
               m_sendEventWithValue("onElementPageNext",_loc2_);
            }
         }
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
      
      public function scrollToBounds(param1:Rectangle, param2:Number = -1) : void
      {
         var _loc7_:Rectangle = null;
         var _loc8_:Rectangle = null;
         var _loc9_:Number = NaN;
         if(param2 < 0)
         {
            param2 = MenuConstants.ScrollTime;
         }
         if(this.m_overflowScrollingFactor > 0)
         {
            (_loc7_ = param1.clone()).inflate(param1.width * this.m_overflowScrollingFactor,param1.height * this.m_overflowScrollingFactor);
            _loc7_.offset(getContainer().x * -1,getContainer().y * -1);
            (_loc7_ = _loc7_.intersection(this.m_scrollMaxBounds)).offset(getContainer().x,getContainer().y);
            param1 = _loc7_;
         }
         if(this.m_scrollBounds.containsRect(param1))
         {
            Animate.kill(getContainer());
            return;
         }
         var _loc3_:Object = new Object();
         var _loc4_:Number = 0;
         var _loc5_:Number = (this.m_scrollBounds.left + this.m_scrollBounds.right) * 0.5;
         var _loc6_:Number = (param1.left + param1.right) * 0.5;
         if(param1.width > this.m_scrollBounds.width)
         {
            _loc4_ = Math.abs(_loc6_ - _loc5_);
         }
         else
         {
            _loc4_ = (_loc8_ = this.m_scrollBounds.union(param1)).width - this.m_scrollBounds.width;
         }
         if(_loc4_ > 0)
         {
            _loc9_ = getContainer().x;
            if(_loc5_ > _loc6_)
            {
               _loc9_ += _loc4_;
            }
            else
            {
               _loc9_ -= _loc4_;
            }
            _loc3_["x"] = _loc9_;
         }
         if(_loc3_["x"] !== undefined)
         {
            Animate.kill(getContainer());
            if(_loc3_["x"] !== undefined)
            {
               Animate.legacyTo(getContainer(),param2,{"x":_loc3_["x"]},Animate.ExpoOut);
            }
         }
      }
      
      public function setFocusTarget(param1:Sprite) : void
      {
         this.setFocusTargetWithScrollTime(param1,MenuConstants.ScrollTime);
         if(this.m_topNavigation != null)
         {
            this.m_topNavigation.updateFrom(param1);
         }
      }
      
      public function setFocusTargetWithScrollTime(param1:Sprite, param2:Number) : void
      {
         var target:Sprite = param1;
         var scrollTime:Number = param2;
         var menuElem:MenuElementBase = target as MenuElementBase;
         var targetBounds:Rectangle = getMenuElementBounds(menuElem,this,function(param1:MenuElementBase):Boolean
         {
            return param1.visible;
         });
         this.scrollToBounds(targetBounds,scrollTime);
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
         this.m_scrollMaxBounds = getVisibleContainerBounds();
      }
      
      override public function handleEvent(param1:String, param2:Sprite) : Boolean
      {
         if(param1 == "categorySelected")
         {
            this.setFocusTarget(param2);
            bubbleEvent("scrollingListContainerScrolled",this);
         }
         else if(param1 == "itemSelected")
         {
            this.setFocusTarget(param2);
            bubbleEvent("scrollingListContainerScrolled",this);
         }
         else if(param1 == "itemHoverOn")
         {
            this.setFocusTargetWithScrollTime(param2,MenuConstants.TabsHoverScrollTime);
            bubbleEvent("scrollingListContainerScrolled",this);
         }
         return super.handleEvent(param1,param2);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         ButtonPromtUtil.registerButtonPromptOwner(this);
         if(!this.m_isSubMenu)
         {
            Animate.to(this.m_tabBackground,MenuConstants.PageOpenTime,0,{"alpha":1},Animate.Linear);
         }
         this.scaleBackground();
         stage.addEventListener(ScreenResizeEvent.SCREEN_RESIZED,this.onScreenResize,true,0,true);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         stage.removeEventListener(ScreenResizeEvent.SCREEN_RESIZED,this.onScreenResize,true);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         ButtonPromtUtil.unregisterButtonPromptOwner(this);
      }
      
      protected function onScreenResize(param1:ScreenResizeEvent) : void
      {
         var _loc2_:Object = param1.screenSize;
         this.m_screenWidth = _loc2_.sizeX;
         this.m_screenHeight = _loc2_.sizeY;
         this.m_safeAreaRatio = _loc2_.safeAreaRatio;
         this.scaleBackground();
      }
      
      private function scaleBackground() : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc1_:Number = MenuConstants.BaseWidth;
         var _loc2_:Number = 0;
         if(ControlsMain.isVrModeActive())
         {
            _loc1_ = MenuConstants.MenuWidth + MenuConstants.ScrollingList_VR_ExtendWidth * 2;
            _loc2_ = MenuConstants.ScrollingList_VR_ExtendWidth * -1;
         }
         else
         {
            _loc3_ = MenuUtils.getFillAspectScale(MenuConstants.BaseWidth,MenuConstants.BaseHeight,this.m_screenWidth,this.m_screenHeight) * this.m_safeAreaRatio;
            _loc1_ = _loc4_ = this.m_screenWidth / _loc3_;
            _loc2_ = this.m_originalBarPosX + (MenuConstants.BaseWidth - _loc1_) / 2;
         }
         this.m_tabBackground.width = _loc1_;
         this.m_tabBackground.x = _loc2_;
      }
   }
}
