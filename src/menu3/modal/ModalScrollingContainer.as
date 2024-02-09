package menu3.modal
{
   import common.Animate;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   
   public class ModalScrollingContainer extends Sprite
   {
       
      
      private var m_container:Sprite;
      
      private var m_clickArea:Sprite;
      
      private var m_entries:Array;
      
      private var m_totalHeight:Number;
      
      private var m_visibleArea:Number;
      
      private var m_currentIndex:int;
      
      private var m_scrollBar:ModalDialogScrollIndicatorVerticalView;
      
      private var m_scrollBarSafeWidth:Number;
      
      private var m_useMask:Boolean = false;
      
      private var m_mask:Sprite = null;
      
      private var m_listGradientT:*;
      
      private var m_listGradientB:*;
      
      private var m_listWidth:Number;
      
      private var m_scrollDist:Number = 28.963;
      
      public var margin:Number = 60;
      
      private var m_gap:Number = 20;
      
      private var m_mouseDragPos:Point;
      
      private var m_isMouseDragActive:Boolean;
      
      private var m_dragAreaScrollBarV:Rectangle;
      
      private var m_clickAreaScrollBarV:Rectangle;
      
      public function ModalScrollingContainer(param1:Number, param2:Number, param3:Number = 0, param4:Boolean = false, param5:String = "default")
      {
         super();
         this.m_visibleArea = param2;
         this.m_listWidth = param1;
         this.m_scrollBarSafeWidth = param3;
         this.m_useMask = param4;
         if(param5 == "targetobjectives")
         {
            this.m_listGradientT = new ModalDialogScrollingListGradientTargetView();
            this.m_listGradientB = new ModalDialogScrollingListGradientTargetView();
         }
         else
         {
            this.m_listGradientT = new ModalDialogScrollingListGradientView();
            this.m_listGradientB = new ModalDialogScrollingListGradientView();
         }
         this.m_listGradientT.width = this.m_listGradientB.width = this.m_listWidth - this.m_scrollBarSafeWidth;
         this.m_listGradientT.height = this.m_listGradientB.height = this.m_scrollDist;
         this.m_listGradientT.y = -1;
         this.m_listGradientB.rotation = 180;
         this.m_listGradientB.x = this.m_listWidth - this.m_scrollBarSafeWidth;
         this.m_listGradientB.y = this.m_visibleArea + 1;
         this.m_listGradientT.alpha = this.m_listGradientB.alpha = 0;
         this.m_scrollBar = new ModalDialogScrollIndicatorVerticalView();
         this.m_scrollBar.x = param1 - 7;
         this.m_scrollBar.visible = false;
         MenuUtils.setColor(this.m_scrollBar.indicator,MenuConstants.COLOR_RED,true,MenuConstants.MenuElementSelectedAlpha);
         MenuUtils.setColor(this.m_scrollBar.indicatorbg,MenuConstants.COLOR_MENU_BUTTON_TILE_DESELECTED,true,MenuConstants.MenuElementBackgroundAlpha);
         this.m_entries = new Array();
         this.m_currentIndex = 0;
         this.m_container = new Sprite();
         addChild(this.m_container);
         this.m_clickArea = new Sprite();
         this.m_container.addChild(this.m_clickArea);
         addChild(this.m_listGradientT);
         addChild(this.m_listGradientB);
         addChild(this.m_scrollBar);
         this.m_totalHeight = 0;
         addEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseDown);
      }
      
      public function onUnregister() : void
      {
         if(this.m_isMouseDragActive)
         {
            this.handleDragEnd(new MouseEvent(MouseEvent.MOUSE_UP));
         }
         removeEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseDown);
      }
      
      public function addGap(param1:Number) : void
      {
         this.m_totalHeight += param1;
      }
      
      public function append(param1:DisplayObject, param2:Boolean, param3:Number, param4:Boolean) : void
      {
         var _loc5_:String = param4 ? "large" : "small";
         this.appendEntry(param1,param2,param3,_loc5_);
      }
      
      public function appendEntry(param1:DisplayObject, param2:Boolean, param3:Number, param4:String = "default", param5:String = "small") : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:* = false;
         if(param1)
         {
            this.m_container.addChild(param1);
            _loc6_ = !!param3 ? param3 : param1.height;
            _loc7_ = Math.ceil(_loc6_ / this.m_scrollDist) * this.m_scrollDist;
            if(param4 == "default")
            {
               param1.y = this.m_totalHeight;
               this.m_totalHeight += _loc6_;
            }
            else
            {
               param1.y = this.m_totalHeight + (_loc7_ - _loc6_) / 2;
               this.m_totalHeight += _loc7_;
            }
            _loc8_ = this.m_totalHeight > this.m_visibleArea;
            this.m_scrollBar.visible = _loc8_;
            this.setScrollPosition(this.getScrollPosition(),false,true);
            if(_loc8_ && this.m_useMask && this.m_mask == null)
            {
               this.createMask();
            }
            this.m_clickArea.graphics.clear();
            this.m_clickArea.graphics.beginFill(113407,0);
            this.m_clickArea.graphics.moveTo(0,0);
            this.m_clickArea.graphics.lineTo(this.m_listWidth,0);
            this.m_clickArea.graphics.lineTo(this.m_listWidth,this.m_totalHeight);
            this.m_clickArea.graphics.lineTo(0,this.m_totalHeight);
         }
      }
      
      public function setEntrySelected(param1:int, param2:Boolean) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Number = NaN;
         this.m_entries[param1].object.setItemSelected(param2);
         if(param2)
         {
            _loc3_ = this.m_entries[param1];
            if((_loc4_ = this.getScrollPosition()) > _loc3_.y - this.margin)
            {
               _loc4_ = _loc3_.y - this.margin;
            }
            else if(_loc4_ < _loc3_.y + _loc3_.height + this.margin - this.m_visibleArea)
            {
               _loc4_ = _loc3_.y + _loc3_.height + this.margin - this.m_visibleArea;
            }
            this.setScrollPosition(_loc4_,true,true);
         }
      }
      
      public function onEntryPressed(param1:int, param2:Boolean = false) : void
      {
         this.m_entries[param1].object.itemPressed(param2);
      }
      
      public function scroll(param1:Number, param2:Boolean) : void
      {
         this.setScrollPosition(this.getScrollPosition() - param1 * this.m_scrollDist,param2,true);
      }
      
      public function getScrollPosition() : Number
      {
         return -this.m_container.y;
      }
      
      public function setScrollPosition(param1:Number, param2:Boolean, param3:Boolean) : void
      {
         var _loc4_:Number;
         if((_loc4_ = this.m_totalHeight - this.m_visibleArea) <= 0)
         {
            return;
         }
         var _loc5_:Number = param3 ? this.m_scrollDist / 2 : 0;
         if(param1 < _loc5_)
         {
            param1 = 0;
         }
         else if(param1 > _loc4_ - _loc5_)
         {
            param1 = _loc4_;
         }
         this.showListGradientTop(param1 > 5);
         this.showListGradientBottom(param1 < _loc4_ - 5);
         if(param2)
         {
            Animate.legacyTo(this.m_container,0.25,{"y":-param1},Animate.SineOut);
         }
         else
         {
            Animate.kill(this.m_container);
            this.m_container.y = -param1;
         }
         this.m_scrollBar.indicatorbg.height = this.m_visibleArea;
         var _loc6_:Number = this.m_visibleArea / this.m_totalHeight * 100;
         this.m_scrollBar.indicator.height = _loc6_ * this.m_visibleArea / 100;
         var _loc7_:Number = param1 / this.m_visibleArea * this.m_scrollBar.indicator.height;
         if(param2)
         {
            Animate.legacyTo(this.m_scrollBar.indicator,0.25,{"y":_loc7_},Animate.SineOut);
         }
         else
         {
            Animate.kill(this.m_scrollBar.indicator);
            this.m_scrollBar.indicator.y = _loc7_;
         }
         this.updateScrollDargAndClickArea();
      }
      
      private function updateScrollDargAndClickArea() : void
      {
         this.m_dragAreaScrollBarV = this.m_scrollBar.indicator.getBounds(this);
         this.m_dragAreaScrollBarV.inflate(20,0);
         this.m_clickAreaScrollBarV = this.m_scrollBar.indicatorbg.getBounds(this);
         this.m_clickAreaScrollBarV.inflate(20,0);
      }
      
      public function getContentWidth() : Number
      {
         return this.m_listWidth - this.m_scrollBarSafeWidth;
      }
      
      public function getContentHeight() : Number
      {
         return this.m_totalHeight;
      }
      
      public function getScrollDist() : Number
      {
         return this.m_scrollDist;
      }
      
      public function onFadeInFinished() : void
      {
         var _loc2_:TextField = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.m_container.numChildren)
         {
            _loc2_ = this.m_container.getChildAt(_loc1_) as TextField;
            if(_loc2_ != null)
            {
               _loc2_.antiAliasType = AntiAliasType.ADVANCED;
            }
            _loc1_++;
         }
      }
      
      private function showListGradientTop(param1:Boolean) : void
      {
         Animate.kill(this.m_listGradientT);
         if(param1)
         {
            Animate.legacyTo(this.m_listGradientT,MenuConstants.HiliteTime,{"alpha":1},Animate.Linear);
         }
         else
         {
            Animate.legacyTo(this.m_listGradientT,MenuConstants.HiliteTime,{"alpha":0},Animate.Linear);
         }
      }
      
      private function showListGradientBottom(param1:Boolean) : void
      {
         Animate.kill(this.m_listGradientB);
         if(param1)
         {
            Animate.legacyTo(this.m_listGradientB,MenuConstants.HiliteTime,{"alpha":1},Animate.Linear);
         }
         else
         {
            Animate.legacyTo(this.m_listGradientB,MenuConstants.HiliteTime,{"alpha":0},Animate.Linear);
         }
      }
      
      private function createMask() : void
      {
         if(this.m_mask != null)
         {
            return;
         }
         this.m_mask = new Sprite();
         addChild(this.m_mask);
         this.mask = this.m_mask;
         this.m_mask.graphics.clear();
         this.m_mask.graphics.beginFill(113407,1);
         this.m_mask.graphics.moveTo(0,0);
         this.m_mask.graphics.lineTo(this.m_listWidth,0);
         this.m_mask.graphics.lineTo(this.m_listWidth,this.m_visibleArea);
         this.m_mask.graphics.lineTo(0,this.m_visibleArea);
         this.m_mask.graphics.endFill();
      }
      
      private function handleMouseDown(param1:MouseEvent) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if(!this.m_scrollBar.visible)
         {
            return;
         }
         var _loc2_:Point = new Point(param1.stageX,param1.stageY);
         var _loc3_:Point = globalToLocal(_loc2_);
         var _loc4_:Boolean = false;
         if(this.m_dragAreaScrollBarV.containsPoint(_loc3_))
         {
            param1.stopImmediatePropagation();
            _loc4_ = true;
         }
         else if(this.m_clickAreaScrollBarV.containsPoint(_loc3_))
         {
            param1.stopImmediatePropagation();
            _loc5_ = _loc3_.y < this.m_dragAreaScrollBarV.y ? -1 : 1;
            _loc6_ = this.m_visibleArea * _loc5_ * 0.9;
            this.setScrollPosition(this.getScrollPosition() + _loc6_,false,true);
            return;
         }
         if(_loc4_)
         {
            this.m_isMouseDragActive = true;
            stage.addEventListener(MouseEvent.MOUSE_MOVE,this.handleDragMouseMove,true);
            stage.addEventListener(MouseEvent.MOUSE_UP,this.handleDragEnd,true);
            stage.addEventListener(MouseEvent.MOUSE_DOWN,this.handleDragEnd,true);
            this.m_mouseDragPos = _loc2_;
            return;
         }
      }
      
      private function handleDragMouseMove(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         var _loc2_:Point = new Point(param1.stageX,param1.stageY);
         var _loc3_:Point = _loc2_.subtract(this.m_mouseDragPos);
         this.m_mouseDragPos = _loc2_;
         var _loc4_:Number = this.computeGlobalToLocalScale();
         var _loc5_:Number = this.m_totalHeight / this.m_visibleArea * _loc4_;
         this.setScrollPosition(this.getScrollPosition() + _loc3_.y * _loc5_,false,false);
      }
      
      private function handleDragEnd(param1:MouseEvent) : void
      {
         this.m_isMouseDragActive = false;
         param1.stopImmediatePropagation();
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.handleDragMouseMove,true);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.handleDragEnd,true);
         stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.handleDragEnd,true);
         this.setScrollPosition(this.getScrollPosition(),false,true);
      }
      
      private function computeGlobalToLocalScale() : Number
      {
         var _loc1_:Number = 100;
         var _loc2_:Point = new Point(0,0);
         var _loc3_:Point = new Point(0,_loc1_);
         var _loc4_:Point = globalToLocal(_loc2_);
         var _loc6_:Number;
         var _loc5_:Point;
         return (_loc6_ = (_loc5_ = globalToLocal(_loc3_)).subtract(_loc4_).length) / _loc1_;
      }
   }
}
