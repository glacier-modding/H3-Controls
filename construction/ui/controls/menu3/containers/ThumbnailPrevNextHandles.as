package menu3.containers
{
   import common.Animate;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import menu3.basic.IConfigurableMenuResource;
   import menu3.basic.ThumbnailItemTile;
   
   public dynamic class ThumbnailPrevNextHandles implements IConfigurableMenuResource
   {
      
      private static var PreviousNextScopeOffset:int = 40;
       
      
      private var m_PreviousScope:ChallengePreviousScope;
      
      private var m_NextScope:ChallengeNextScope;
      
      private var m_pageHasPrevious:Boolean;
      
      private var m_pagePreviousIcon:String;
      
      private var m_pageHasNext:Boolean;
      
      private var m_pageNextIcon:String;
      
      private var m_thumbnailScrollingList:ThumbnailScrollingListContainer;
      
      public function ThumbnailPrevNextHandles(param1:ThumbnailScrollingListContainer)
      {
         super();
         this.m_thumbnailScrollingList = param1;
      }
      
      public static function arePrevNextCategoryHandlesNeeded(param1:Object) : Boolean
      {
         var _loc2_:Boolean = param1.hasOwnProperty("hasprevious") && param1["hasprevious"] == true;
         var _loc3_:Boolean = param1.hasOwnProperty("hasnext") && param1["hasnext"] == true;
         return _loc2_ || _loc3_;
      }
      
      public function onSetData(param1:Object) : void
      {
         this.m_PreviousScope = new ChallengePreviousScope();
         this.m_PreviousScope.x = -40;
         this.m_thumbnailScrollingList.addChild(this.m_PreviousScope);
         this.m_NextScope = new ChallengeNextScope();
         this.m_NextScope.x = MenuConstants.GridUnitWidth * 2 + 40;
         this.m_thumbnailScrollingList.addChild(this.m_NextScope);
         this.m_pageHasPrevious = param1.hasOwnProperty("hasprevious") && param1["hasprevious"] == true;
         this.m_pagePreviousIcon = param1.hasOwnProperty("previousicon") && param1["previousicon"].toString().length > 0 ? String(param1["previousicon"]) : "";
         this.m_pageHasNext = param1.hasOwnProperty("hasnext") && param1["hasnext"] == true;
         this.m_pageNextIcon = param1.hasOwnProperty("nexticon") && param1["nexticon"].toString().length > 0 ? String(param1["nexticon"]) : "";
         if(this.m_thumbnailScrollingList.hasValidContent() || !this.m_thumbnailScrollingList.isEmptyContainerFeedbackTileActive())
         {
            this.m_PreviousScope.visible = false;
            this.m_NextScope.visible = false;
         }
         else if(this.m_thumbnailScrollingList.isEmptyContainerFeedbackTileActive())
         {
            this.setPrevNextIcon(this.m_PreviousScope,this.m_pagePreviousIcon);
            this.setPrevNextIcon(this.m_NextScope,this.m_pageNextIcon);
            this.m_PreviousScope.visible = this.m_pageHasPrevious;
            this.m_NextScope.visible = this.m_pageHasNext;
         }
      }
      
      public function onUnregister() : void
      {
         if(this.m_PreviousScope != null)
         {
            Animate.kill(this.m_PreviousScope);
            this.m_thumbnailScrollingList.removeChild(this.m_PreviousScope);
            this.m_PreviousScope = null;
         }
         if(this.m_NextScope != null)
         {
            Animate.kill(this.m_NextScope);
            this.m_thumbnailScrollingList.removeChild(this.m_NextScope);
            this.m_NextScope = null;
         }
      }
      
      private function setPrevNextIcon(param1:Sprite, param2:String) : void
      {
         var _loc3_:MovieClip = param1["icon"];
         _loc3_.visible = Boolean(param2) && param2.length > 0;
         if(_loc3_.visible)
         {
            MenuUtils.setupIcon(_loc3_,param2,MenuConstants.COLOR_GREY_MEDIUM,false,true,MenuConstants.COLOR_GREY);
         }
      }
      
      public function onSetFocusAfterChildren(param1:Rectangle, param2:Rectangle, param3:Number) : void
      {
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc4_:Boolean = this.m_thumbnailScrollingList.m_children.length > 0 && this.m_thumbnailScrollingList.m_children[0] is ThumbnailItemTile;
         var _loc5_:Number = this.m_thumbnailScrollingList.getContainer().x;
         var _loc6_:Boolean;
         if((_loc6_ = this.m_pageHasPrevious && _loc4_ && this.m_thumbnailScrollingList.focusedElementIndex == 0) && !this.m_PreviousScope.visible)
         {
            this.setPrevNextIcon(this.m_PreviousScope,this.m_pagePreviousIcon);
            this.m_PreviousScope.x = _loc5_ - PreviousNextScopeOffset;
         }
         this.m_PreviousScope.visible = _loc6_;
         if(this.m_PreviousScope.visible)
         {
            _loc9_ = _loc5_ - PreviousNextScopeOffset - param1.x;
            Animate.kill(this.m_PreviousScope);
            Animate.legacyTo(this.m_PreviousScope,param3,{"x":_loc9_},Animate.ExpoOut);
         }
         var _loc7_:int = 10;
         var _loc8_:Boolean;
         if((_loc8_ = this.m_pageHasNext && _loc4_ && this.m_thumbnailScrollingList.focusedElementIndex > this.m_thumbnailScrollingList.m_children.length - _loc7_) && !this.m_NextScope.visible)
         {
            this.setPrevNextIcon(this.m_NextScope,this.m_pageNextIcon);
            this.m_NextScope.x = _loc5_ + param2.width + MenuConstants.GridUnitWidth + PreviousNextScopeOffset;
         }
         this.m_NextScope.visible = _loc8_;
         if(this.m_NextScope.visible)
         {
            _loc10_ = _loc5_ + param2.width + MenuConstants.GridUnitWidth + PreviousNextScopeOffset - param1.x;
            Animate.kill(this.m_NextScope);
            Animate.legacyTo(this.m_NextScope,param3,{"x":_loc10_},Animate.ExpoOut);
         }
      }
      
      public function handleMouseUp(param1:Function, param2:MouseEvent) : Boolean
      {
         var _loc5_:Rectangle = null;
         var _loc3_:Point = new Point(param2.stageX,param2.stageY);
         var _loc4_:Point = this.m_thumbnailScrollingList.globalToLocal(_loc3_);
         if(this.m_PreviousScope.visible)
         {
            if((_loc5_ = this.m_PreviousScope.getBounds(this.m_thumbnailScrollingList)).containsPoint(_loc4_))
            {
               param2.stopImmediatePropagation();
               if(this.m_thumbnailScrollingList.hasValidContent())
               {
                  this.m_thumbnailScrollingList.selectChildWithMouseEvent(0);
               }
               this.sendEventWithId(param1,"onElementPrev");
               return true;
            }
         }
         if(this.m_NextScope.visible)
         {
            if((_loc5_ = this.m_NextScope.getBounds(this.m_thumbnailScrollingList)).containsPoint(_loc4_))
            {
               param2.stopImmediatePropagation();
               if(this.m_thumbnailScrollingList.hasValidContent())
               {
                  this.m_thumbnailScrollingList.selectChildWithMouseEvent(this.m_thumbnailScrollingList.m_children.length - 1);
               }
               this.sendEventWithId(param1,"onElementNext");
               return true;
            }
         }
         return false;
      }
      
      private function sendEventWithId(param1:Function, param2:String) : void
      {
         var _loc3_:int = 0;
         if(this.m_thumbnailScrollingList["_nodedata"])
         {
            _loc3_ = this.m_thumbnailScrollingList["_nodedata"]["id"] as int;
            param1(param2,_loc3_);
         }
      }
   }
}
