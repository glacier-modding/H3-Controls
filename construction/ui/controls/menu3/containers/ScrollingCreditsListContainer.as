package menu3.containers
{
   import common.Log;
   import common.menu.MenuConstants;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.getTimer;
   import menu3.Credits;
   import menu3.MenuElementBase;
   
   public dynamic class ScrollingCreditsListContainer extends ScrollingListContainer
   {
       
      
      private var m_bIsInitialsed:Boolean = false;
      
      private var m_lastFrameTime:int = 0;
      
      private var m_currentScrollSpeed:Number = 0;
      
      private var m_currentScrollDirection:int = 0;
      
      private var m_initialPosition:Number = 0;
      
      private var m_elements:Vector.<Credits>;
      
      private var m_bChildrenChanged:Boolean = true;
      
      private var m_visibleElements:Vector.<int>;
      
      private var m_height:int = -1;
      
      private var m_scrollPos:Number = 0;
      
      private var m_creditsMask:Sprite;
      
      private var m_clickArea:Sprite;
      
      private const SCROLL_SPEED_EPSILON:Number = 100;
      
      private const INITIAL_SCROLL_SPEED:Number = 100;
      
      private const SCROLL_ACCELERATION:Number = 100;
      
      private const SCROLL_SPEED_RANGE:Point = new Point(-1000,1000);
      
      private var m_counter:int = 0;
      
      public function ScrollingCreditsListContainer(param1:Object)
      {
         this.m_elements = new Vector.<Credits>();
         this.m_visibleElements = new Vector.<int>();
         this.m_creditsMask = new Sprite();
         this.m_clickArea = new Sprite();
         super(param1);
         m_alwaysClampToMaxBounds = false;
         this.m_currentScrollSpeed = this.INITIAL_SCROLL_SPEED;
         this.m_initialPosition = getScrollBounds().height;
         getContainer().y = this.m_initialPosition;
         addChild(this.m_clickArea);
      }
      
      override public function onSetData(param1:Object) : void
      {
         super.onSetData(param1);
         this.startAnim();
      }
      
      public function startAnim() : void
      {
         getContainer().addEventListener(Event.ENTER_FRAME,this.update);
         this.m_lastFrameTime = getTimer();
      }
      
      public function stopAnim() : void
      {
         getContainer().removeEventListener(Event.ENTER_FRAME,this.update);
      }
      
      private function update(param1:Event) : void
      {
         if(this.m_bChildrenChanged)
         {
            this.m_bChildrenChanged = false;
            this.collectAllCreditsElements(this,this.m_elements);
         }
         var _loc2_:int = getTimer();
         var _loc3_:Number = (_loc2_ - this.m_lastFrameTime) * 0.001;
         this.m_lastFrameTime = _loc2_;
         this.m_currentScrollSpeed += this.m_currentScrollDirection * this.SCROLL_ACCELERATION;
         if(this.m_currentScrollSpeed < this.SCROLL_SPEED_RANGE.x)
         {
            this.m_currentScrollSpeed = this.SCROLL_SPEED_RANGE.x;
         }
         if(this.m_currentScrollSpeed > this.SCROLL_SPEED_RANGE.y)
         {
            this.m_currentScrollSpeed = this.SCROLL_SPEED_RANGE.y;
         }
         if(this.m_currentScrollDirection == 0 && Math.abs(this.m_currentScrollSpeed) < this.SCROLL_SPEED_EPSILON)
         {
            this.m_currentScrollSpeed = 0;
         }
         this.m_currentScrollDirection = 0;
         var _loc4_:Sprite = getContainer();
         this.m_scrollPos -= _loc3_ * this.m_currentScrollSpeed;
         if(this.m_scrollPos < -this.m_height)
         {
            trace(this.m_scrollPos + " < " + -this.m_height);
            this.m_scrollPos = this.m_initialPosition;
         }
         if(this.m_scrollPos > this.m_initialPosition)
         {
            this.m_scrollPos = -this.m_height;
         }
         var _loc5_:Number = Math.round(this.m_scrollPos * 20) * 0.05;
         _loc4_.y = _loc5_ + 0.001;
         if(this.m_counter > 0)
         {
            --this.m_counter;
            return;
         }
         this.m_counter = 5;
         this.detectElementsVisibility();
      }
      
      private function detectElementsVisibility() : void
      {
         var _loc1_:int = 0;
         if(this.m_visibleElements.length == 0)
         {
            _loc1_ = 0;
            while(_loc1_ < this.m_elements.length)
            {
               if(this.trySetVisible(this.m_elements[_loc1_]))
               {
                  this.m_visibleElements.push(_loc1_);
               }
               _loc1_++;
            }
            return;
         }
         _loc1_ = this.m_visibleElements[0] > 0 ? this.m_visibleElements[0] - 1 : int(this.m_elements.length - 1);
         if(this.trySetVisible(this.m_elements[_loc1_]))
         {
            this.m_visibleElements.splice(0,0,_loc1_);
         }
         _loc1_ = this.m_visibleElements[this.m_visibleElements.length - 1] < this.m_elements.length - 1 ? this.m_visibleElements[this.m_visibleElements.length - 1] + 1 : 0;
         if(this.trySetVisible(this.m_elements[_loc1_]))
         {
            this.m_visibleElements.push(_loc1_);
         }
         _loc1_ = int(this.m_visibleElements.length - 1);
         while(_loc1_ >= 0)
         {
            if(!this.trySetVisible(this.m_elements[this.m_visibleElements[_loc1_]]))
            {
               this.m_visibleElements.splice(_loc1_,1);
            }
            _loc1_--;
         }
      }
      
      private function trySetVisible(param1:Credits) : Boolean
      {
         var _loc2_:Number = getContainer().y * -1;
         var _loc3_:Number = _loc2_;
         var _loc4_:Number = _loc3_ + MenuConstants.BaseHeight;
         var _loc5_:Number;
         var _loc6_:Number = (_loc5_ = param1.y) + param1.getCreditsHeight();
         var _loc7_:Boolean;
         if((_loc7_ = _loc5_ <= _loc4_ && _loc6_ >= _loc3_) != param1.visible)
         {
            param1.setCreditsVisible(_loc7_);
         }
         return _loc7_;
      }
      
      private function createClickArea() : void
      {
         this.m_clickArea.graphics.clear();
         this.m_clickArea.graphics.beginFill(16711680,0);
         this.m_clickArea.graphics.drawRect(0,0,getWidth(),getHeight());
         this.m_clickArea.graphics.endFill();
      }
      
      override protected function onAddedToStage(param1:Event) : void
      {
         super.onAddedToStage(param1);
         if(this.m_elements.length > 0)
         {
            return;
         }
         this.m_scrollPos = getContainer().y;
         this.createClickArea();
      }
      
      override public function onChildrenChanged() : void
      {
         this.m_bChildrenChanged = true;
      }
      
      private function collectAllCreditsElements(param1:MenuElementBase, param2:Vector.<Credits>) : void
      {
         var _loc4_:MenuElementBase = null;
         var _loc5_:Credits = null;
         this.m_height = 0;
         var _loc3_:int = 0;
         while(_loc3_ < param1.m_children.length)
         {
            if((_loc4_ = param1.m_children[_loc3_] as MenuElementBase) != null)
            {
               if((_loc5_ = _loc4_ as Credits) != null)
               {
                  param2.push(_loc5_);
                  _loc5_.y = this.m_height;
                  this.m_height += _loc5_.getCreditsHeight();
               }
               else
               {
                  trace("Non-credits child found in ScrollingCreditsListContainer");
               }
            }
            _loc3_++;
         }
         recalculateTotalBounds();
      }
      
      override protected function scrollToBoundsInternal(param1:Rectangle, param2:Number, param3:Boolean) : Boolean
      {
         return false;
      }
      
      override public function onScroll(param1:int) : void
      {
         super.onScroll(param1);
         this.m_currentScrollDirection = param1;
      }
      
      override public function onUnregister() : void
      {
         this.stopAnim();
      }
      
      override public function handleMouseWheel(param1:Function, param2:MouseEvent) : void
      {
         Log.mouse(this,param2);
         if(param2.delta == 0)
         {
            return;
         }
         param2.stopImmediatePropagation();
         var _loc3_:int = param2.delta > 0 ? -1 : 1;
         this.onScroll(_loc3_);
      }
      
      override public function addChild2(param1:Sprite, param2:int = -1) : void
      {
         param1.visible = false;
         super.addChild2(param1,param2);
      }
      
      override public function getVisibleContainerBounds() : Rectangle
      {
         return new Rectangle(0,0,1000,this.m_height);
      }
      
      override public function repositionChild(param1:Sprite) : void
      {
      }
   }
}
