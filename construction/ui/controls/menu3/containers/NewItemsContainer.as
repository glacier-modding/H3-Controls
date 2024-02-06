package menu3.containers
{
   import common.Animate;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.external.ExternalInterface;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import menu3.MenuElementBase;
   import menu3.basic.ObjectiveTile;
   
   public dynamic class NewItemsContainer extends ListContainer
   {
       
      
      private const ANI_STATE_STOP:int = -1;
      
      private const ANI_STATE_START:int = 0;
      
      private const ANI_STATE_WAIT:int = 1;
      
      private const ANI_STATE_MOVE_OLD_ITEMS:int = 2;
      
      private const ANI_STATE_FADE_NEW_ITEMS:int = 3;
      
      private var m_itemNewFlagPropertyName:String;
      
      private var m_startDelay:Number = 0;
      
      private var m_newItems:Array;
      
      private var m_newItemsBound:Array;
      
      private var m_currentAnimationState:int = -1;
      
      private var m_lastAnimationState:int = -1;
      
      private var m_fadeInAscending:Boolean = false;
      
      private var m_animate:Boolean = true;
      
      private var m_doMoveAnimationChildIndex:Array;
      
      private var m_originalPositions:Array;
      
      private var m_originalContainerPlaceholder:Sprite = null;
      
      private var delayCount:Number = 0;
      
      public function NewItemsContainer(param1:Object)
      {
         this.m_newItems = new Array();
         this.m_newItemsBound = new Array();
         this.m_doMoveAnimationChildIndex = new Array();
         this.m_originalPositions = new Array();
         super(param1);
         if(param1.itemNewFlagPropertyName != null)
         {
            this.m_itemNewFlagPropertyName = param1.itemNewFlagPropertyName;
         }
         if(param1.startDelay != null)
         {
            this.m_startDelay = param1.startDelay;
         }
         if(param1.fadeInOrder == "ascending")
         {
            this.m_fadeInAscending = true;
         }
         if(param1.animate != null)
         {
            this.m_animate = param1.animate;
         }
      }
      
      override public function onUnregister() : void
      {
         var _loc1_:int = 0;
         if(this.m_currentAnimationState != this.ANI_STATE_STOP)
         {
            this.stopAnim();
            Animate.kill(this);
            _loc1_ = 0;
            while(_loc1_ < m_children.length)
            {
               Animate.kill(m_children[_loc1_]);
               _loc1_++;
            }
            _loc1_ = 0;
            while(_loc1_ < this.m_newItems.length)
            {
               Animate.kill(this.m_newItems[_loc1_]);
               _loc1_++;
            }
         }
         super.onUnregister();
      }
      
      override public function addChild2(param1:Sprite, param2:int = -1) : void
      {
         var menuElement:MenuElementBase;
         var elementData:Object;
         var elementBounds:Rectangle = null;
         var isNew:Boolean = false;
         var element:Sprite = param1;
         var index:int = param2;
         super.addChild2(element,index);
         if(this.m_animate)
         {
            element.alpha = 0;
         }
         menuElement = element as MenuElementBase;
         if(menuElement == null)
         {
            return;
         }
         elementData = menuElement.getData();
         if(elementData == null)
         {
            return;
         }
         if(this.m_itemNewFlagPropertyName != null && this.m_itemNewFlagPropertyName.length > 0)
         {
            if(this.m_itemNewFlagPropertyName in elementData)
            {
               isNew = Boolean(elementData[this.m_itemNewFlagPropertyName]);
               if(isNew)
               {
                  if(!this.m_animate)
                  {
                     this.onComplete(menuElement);
                  }
                  if(this.m_fadeInAscending)
                  {
                     this.m_newItems.push(menuElement);
                  }
                  else
                  {
                     this.m_newItems.unshift(menuElement);
                  }
                  elementBounds = getMenuElementBounds(menuElement,this,function(param1:MenuElementBase):Boolean
                  {
                     return param1.visible;
                  });
                  if(this.m_fadeInAscending)
                  {
                     this.m_newItemsBound.push(elementBounds);
                  }
                  else
                  {
                     this.m_newItemsBound.unshift(elementBounds);
                  }
               }
            }
         }
      }
      
      override public function onChildrenChanged() : void
      {
         var _loc1_:Rectangle = null;
         super.onChildrenChanged();
         if(this.m_animate)
         {
            _loc1_ = getVisibleContainerBounds();
            if(this.m_originalContainerPlaceholder == null)
            {
               this.m_originalContainerPlaceholder = new Sprite();
               getView().addChild(this.m_originalContainerPlaceholder);
            }
            else
            {
               this.m_originalContainerPlaceholder.graphics.clear();
            }
            this.m_originalContainerPlaceholder.graphics.beginFill(0,0);
            this.m_originalContainerPlaceholder.graphics.lineStyle(0,0,0);
            this.m_originalContainerPlaceholder.graphics.drawRect(_loc1_.x,_loc1_.y,_loc1_.width,_loc1_.height);
            if(this.m_currentAnimationState != this.ANI_STATE_START)
            {
               this.startAnim();
            }
         }
         else if(this.m_originalContainerPlaceholder != null)
         {
            getView().removeChild(this.m_originalContainerPlaceholder);
            this.m_originalContainerPlaceholder = null;
         }
      }
      
      private function startAnim() : void
      {
         getContainer().addEventListener(Event.ENTER_FRAME,this.updateAnimation);
         this.setAnimationState(this.ANI_STATE_START);
      }
      
      private function stopAnim() : void
      {
         getContainer().removeEventListener(Event.ENTER_FRAME,this.updateAnimation);
      }
      
      private function setAnimationState(param1:int, param2:Number = 0) : void
      {
         var state:int = param1;
         var delay:Number = param2;
         if(delay <= 0)
         {
            this.m_currentAnimationState = state;
            return;
         }
         Animate.kill(this);
         Animate.delay(this,delay,function():void
         {
            m_currentAnimationState = state;
         });
      }
      
      private function updateAnimation(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:MenuElementBase = null;
         var _loc8_:Number = NaN;
         var _loc9_:int = 0;
         var _loc10_:Number = NaN;
         var _loc11_:MenuElementBase = null;
         if(this.m_currentAnimationState == this.m_lastAnimationState)
         {
            return;
         }
         this.m_lastAnimationState = this.m_currentAnimationState;
         if(this.m_currentAnimationState == this.ANI_STATE_START)
         {
            this.initializeAnimation();
            this.setAnimationState(this.ANI_STATE_WAIT,this.m_startDelay);
         }
         else if(this.m_currentAnimationState == this.ANI_STATE_WAIT)
         {
            _loc2_ = 0.5;
            this.setAnimationState(this.ANI_STATE_MOVE_OLD_ITEMS,_loc2_);
         }
         else if(this.m_currentAnimationState == this.ANI_STATE_MOVE_OLD_ITEMS)
         {
            _loc3_ = 0.5;
            _loc4_ = 0;
            while(_loc4_ < this.m_doMoveAnimationChildIndex.length)
            {
               _loc6_ = int(this.m_doMoveAnimationChildIndex[_loc4_]);
               _loc7_ = m_children[_loc6_];
               this.startMoveAnimation(_loc7_,this.m_originalPositions[_loc6_],_loc3_);
               _loc4_++;
            }
            _loc5_ = this.m_doMoveAnimationChildIndex.length > 0 ? _loc3_ - 0.25 : 0;
            this.setAnimationState(this.ANI_STATE_FADE_NEW_ITEMS,_loc5_);
         }
         else if(this.m_currentAnimationState == this.ANI_STATE_FADE_NEW_ITEMS)
         {
            _loc8_ = 0.5;
            _loc9_ = 0;
            while(_loc9_ < this.m_newItems.length)
            {
               _loc11_ = this.m_newItems[_loc9_];
               this.startFadeInAnimation(_loc11_,this.m_newItemsBound[_loc9_],_loc8_ - 0.2);
               _loc9_++;
            }
            _loc10_ = this.m_newItems.length > 0 ? _loc8_ : 0;
            this.setAnimationState(this.ANI_STATE_STOP,_loc10_);
         }
         else if(this.m_currentAnimationState == this.ANI_STATE_STOP)
         {
            this.stopAnim();
         }
      }
      
      private function initializeAnimation() : void
      {
         var _loc3_:Sprite = null;
         var _loc4_:int = 0;
         var _loc5_:* = false;
         var _loc6_:MenuElementBase = null;
         var _loc7_:Rectangle = null;
         var _loc1_:Point = new Point();
         var _loc2_:int = 0;
         while(_loc2_ < m_children.length)
         {
            _loc3_ = m_children[_loc2_];
            this.m_originalPositions.push(new Point(_loc3_.x,_loc3_.y));
            if(_loc5_ = (_loc4_ = this.m_newItems.indexOf(_loc3_)) >= 0)
            {
               _loc3_.alpha = 0;
               _loc6_ = this.m_newItems[_loc4_];
               _loc7_ = this.m_newItemsBound[_loc4_];
               if(this.isDirectionHorizontal())
               {
                  _loc1_.x += _loc7_.width;
               }
               else
               {
                  _loc1_.y += _loc7_.height;
               }
            }
            else
            {
               _loc3_.alpha = 1;
            }
            if(!_loc5_ && (_loc1_.x > 0 || _loc1_.y > 0))
            {
               _loc3_.x -= _loc1_.x;
               _loc3_.y -= _loc1_.y;
               this.m_doMoveAnimationChildIndex.push(_loc2_);
            }
            _loc2_++;
         }
      }
      
      private function startMoveAnimation(param1:MenuElementBase, param2:Point, param3:Number) : void
      {
         Animate.kill(param1);
         Animate.legacyTo(param1,param3,{
            "x":param2.x,
            "y":param2.y
         },Animate.ExpoInOut);
      }
      
      private function startFadeInAnimation(param1:MenuElementBase, param2:Rectangle, param3:Number) : void
      {
         var xEndPos:Number = NaN;
         var yEndPos:Number = NaN;
         var menuElement:MenuElementBase = param1;
         var elementBounds:Rectangle = param2;
         var animationDuration:Number = param3;
         var SCALE_FACTOR:Number = 0.1;
         var xOffset:Number = (elementBounds.width * SCALE_FACTOR - elementBounds.width) / 2;
         var yOffset:Number = (elementBounds.height * SCALE_FACTOR - elementBounds.height) / 2;
         xEndPos = elementBounds.x;
         yEndPos = elementBounds.y;
         menuElement.scaleX = SCALE_FACTOR;
         menuElement.scaleY = SCALE_FACTOR;
         menuElement.x = xEndPos - xOffset;
         menuElement.y = yEndPos - yOffset;
         Animate.delay(menuElement,this.delayCount,function():void
         {
            playSound("Objectives_PopUp");
            Animate.to(menuElement,animationDuration,0,{
               "x":xEndPos,
               "y":yEndPos,
               "scaleX":1,
               "scaleY":1,
               "alpha":1
            },Animate.ExpoOut,onComplete,menuElement);
         });
         this.delayCount += 0.15;
      }
      
      public function playSound(param1:String) : void
      {
         ExternalInterface.call("PlaySound",param1);
      }
      
      private function onComplete(param1:Object) : void
      {
         ObjectiveTile(param1).showConditions(ObjectiveTile.TILETYPE_NEW);
      }
      
      private function isDirectionHorizontal() : Boolean
      {
         return m_direction == "horizontal";
      }
   }
}
