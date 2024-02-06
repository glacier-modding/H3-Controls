package menu3
{
   import common.Animate;
   import common.AnimationContainerBase;
   import common.CalcUtil;
   import common.Log;
   import common.MouseUtil;
   import common.menu.MenuConstants;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public dynamic class MenuElementBase extends Sprite implements AnimationContainerBase
   {
       
      
      public var m_children:Array;
      
      public var m_parent:MenuElementBase;
      
      public var m_name:String;
      
      protected var m_mouseMode:int = 0;
      
      protected var m_mouseWheelMode:int = 0;
      
      private var m_data:Object;
      
      private var m_focusIndex:int = -1;
      
      private var m_activePopOutScaleViewElement:Object = null;
      
      private var m_activePopOutScaleViewElementPaused:Object = null;
      
      private var m_focusPlaceholder:Sprite;
      
      private var m_isPopOutScaleActive:Boolean = false;
      
      private var m_popOutOriginalScale:Point;
      
      private var m_popOutOriginalPos:Point;
      
      private var m_isPopOutScaleQueued:Boolean = false;
      
      public function MenuElementBase(param1:Object)
      {
         this.m_children = [];
         this.m_data = {};
         this.m_focusPlaceholder = new Sprite();
         super();
         this.m_data = param1;
         this.m_name = param1.name;
      }
      
      public static function getNodeProp(param1:Sprite, param2:String) : *
      {
         if(param1["_nodedata"])
         {
            return param1["_nodedata"][param2];
         }
         return undefined;
      }
      
      public static function getId(param1:Sprite) : int
      {
         if(param1["_nodedata"])
         {
            return param1["_nodedata"]["id"];
         }
         return -1;
      }
      
      public function getView() : Sprite
      {
         return this;
      }
      
      public function hasChildren() : Boolean
      {
         var _loc1_:Boolean = false;
         if(this.m_children.length >= 1)
         {
            _loc1_ = true;
         }
         return _loc1_;
      }
      
      public function getContainer() : Sprite
      {
         return this;
      }
      
      public function onSetData(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this.m_data = param1;
         this.m_name = param1.name;
         if(param1.mousemode != null)
         {
            _loc2_ = MouseUtil.getModeFromName(param1.mousemode);
            if(_loc2_ >= 0)
            {
               this.m_mouseMode = _loc2_;
            }
         }
         if(param1.mousewheelmode != null)
         {
            Log.info(Log.ChannelMouse,this,"Setting mouse wheel mode from data to " + param1.mousewheelmode);
            _loc3_ = MouseUtil.getWheelModeFromName(param1.mousewheelmode);
            if(_loc3_ >= 0)
            {
               this.m_mouseWheelMode = _loc3_;
            }
         }
      }
      
      public function onUnregister() : void
      {
         this.unsetFocusChild();
      }
      
      public function getPersistentReloadData() : Object
      {
         return null;
      }
      
      public function onPersistentReloadData(param1:Object) : void
      {
      }
      
      public function setX(param1:Number) : void
      {
         var _loc2_:Object = this.getNodeData();
         _loc2_.x = param1;
         this.updatePosX();
      }
      
      public function setY(param1:Number) : void
      {
         var _loc2_:Object = this.getNodeData();
         _loc2_.y = param1;
         this.updatePosY();
      }
      
      public function setCol(param1:Number) : void
      {
         Log.info(Log.ChannelDebug,this,"setCol:" + param1);
         var _loc2_:Object = this.getNodeData();
         _loc2_.col = param1;
         this.updatePosX();
      }
      
      public function setRow(param1:Number) : void
      {
         Log.info(Log.ChannelDebug,this,"setRow:" + param1);
         var _loc2_:Object = this.getNodeData();
         _loc2_.row = param1;
         this.updatePosY();
      }
      
      private function updatePosX() : void
      {
         var _loc1_:Object = this.getNodeData();
         if(_loc1_.x)
         {
            this.x = _loc1_.x;
         }
         else
         {
            this.x = _loc1_.col * MenuConstants.GridUnitWidth || 0;
         }
      }
      
      private function updatePosY() : void
      {
         var _loc1_:Object = this.getNodeData();
         if(_loc1_.y)
         {
            this.y = _loc1_.y;
         }
         else
         {
            this.y = _loc1_.row * MenuConstants.GridUnitHeight || 0;
         }
      }
      
      public function setWidth(param1:Number) : void
      {
      }
      
      public function setHeight(param1:Number) : void
      {
      }
      
      public function getWidth() : Number
      {
         return Number(this.m_data.width) || this.width;
      }
      
      public function getHeight() : Number
      {
         return Number(this.m_data.height) || this.height;
      }
      
      public function getData() : Object
      {
         return this.m_data;
      }
      
      public function clearChildren() : void
      {
         this.unsetFocusChild();
         this.m_children = [];
         while(this.getContainer().numChildren > 0)
         {
            this.getContainer().removeChildAt(0);
         }
      }
      
      public function addChild2(param1:Sprite, param2:int = -1) : void
      {
         var _loc3_:int = this.m_focusIndex;
         this.unsetFocusChild();
         if(param2 == -1)
         {
            this.m_children.push(param1);
            this.getContainer().addChild(param1);
         }
         else
         {
            this.m_children.splice(param2,0,param1);
            this.getContainer().addChildAt(param1,param2);
         }
         var _loc4_:MenuElementBase;
         if(_loc4_ = param1 as MenuElementBase)
         {
            _loc4_.m_parent = this;
            _loc4_.onAddedAsChild(_loc4_);
         }
         if(_loc3_ >= 0)
         {
            if(param2 == _loc3_)
            {
               _loc3_++;
            }
            this.setFocusChild(_loc3_);
         }
      }
      
      public function replaceChild2(param1:Sprite, param2:Sprite) : void
      {
         var _loc3_:int = this.m_focusIndex;
         this.unsetFocusChild();
         var _loc4_:int;
         if((_loc4_ = this.m_children.indexOf(param1)) >= 0)
         {
            this.removeChild2(param1);
            this.addChild2(param2,_loc4_);
         }
         var _loc5_:MenuElementBase;
         if(_loc5_ = param2 as MenuElementBase)
         {
            _loc5_.m_parent = this;
            _loc5_.onAddedAsChild(_loc5_);
         }
         if(_loc3_ >= 0 && _loc3_ != _loc4_)
         {
            this.setFocusChild(_loc3_);
         }
      }
      
      public function removeChild2(param1:Sprite) : void
      {
         var _loc2_:int = this.m_focusIndex;
         this.unsetFocusChild();
         var _loc3_:int = this.m_children.indexOf(param1);
         if(_loc3_ >= 0)
         {
            this.m_children.splice(_loc3_,1);
            this.getContainer().removeChild(param1);
         }
         if(_loc2_ >= 0 && _loc2_ != _loc3_)
         {
            if(_loc3_ < _loc2_)
            {
               _loc2_--;
            }
            this.setFocusChild(_loc2_);
         }
      }
      
      public function reorderChildren(param1:Array) : void
      {
         var _loc5_:MenuElementBase = null;
         var _loc6_:int = 0;
         Log.info(Log.ChannelDebug,this,"reorderChildren");
         var _loc2_:int = this.m_focusIndex;
         this.unsetFocusChild();
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc5_ = param1[_loc4_];
            if((_loc6_ = this.m_children.indexOf(_loc5_)) >= 0)
            {
               if(_loc6_ != _loc3_)
               {
                  this.m_children.splice(_loc6_,1);
                  this.m_children.splice(_loc3_,0,_loc5_);
                  if(this.m_focusIndex == _loc6_)
                  {
                     this.m_focusIndex = _loc3_;
                  }
                  this.getContainer().setChildIndex(_loc5_,_loc3_);
               }
               _loc3_++;
            }
            else
            {
               Log.error(Log.ChannelCommon,this,"reorderChildren: child not found");
            }
            _loc4_++;
         }
         if(_loc2_ >= 0)
         {
            this.setFocusChild(_loc2_);
         }
      }
      
      public function onAddedAsChild(param1:MenuElementBase) : void
      {
      }
      
      public function onChildrenChanged() : void
      {
      }
      
      public function onContextActivate() : void
      {
      }
      
      public function onContextDeactivate() : void
      {
      }
      
      public function getChildElementIndex(param1:MenuElementBase) : int
      {
         return this.m_children.indexOf(param1);
      }
      
      public function getChildElementCount() : int
      {
         return int(this.m_children.length);
      }
      
      public function bubbleEvent(param1:String, param2:MenuElementBase) : void
      {
         var _loc3_:MenuElementBase = param2.m_parent;
         var _loc4_:DynamicMenuPage = _loc3_ as DynamicMenuPage;
         while(_loc3_ && _loc4_ == null && (!_loc3_["handleEvent"] || !_loc3_["handleEvent"](param1,param2)))
         {
            _loc3_ = _loc3_.m_parent;
         }
      }
      
      public function getVisualBounds(param1:MenuElementBase) : Rectangle
      {
         var _loc2_:Sprite = this.getView();
         if(_loc2_ == null)
         {
            return new Rectangle();
         }
         return _loc2_.getBounds(param1);
      }
      
      public function getMenuElementBounds(param1:MenuElementBase, param2:MenuElementBase, param3:Function = null) : Rectangle
      {
         var _loc6_:MenuElementBase = null;
         if(!param1)
         {
            return new Rectangle();
         }
         var _loc4_:Rectangle = param1.getVisualBounds(param2);
         var _loc5_:int = 0;
         while(_loc5_ < param1.m_children.length)
         {
            _loc6_ = param1.m_children[_loc5_] as MenuElementBase;
            if(!(param3 != null && !param3(_loc6_)))
            {
               _loc4_ = _loc4_.union(this.getMenuElementBounds(_loc6_,param2,param3));
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      public function handleEvent(param1:String, param2:Sprite) : Boolean
      {
         return false;
      }
      
      public function setVisible(param1:Object) : void
      {
         var _loc2_:Boolean = Boolean(param1["visible"]);
         if(_loc2_ != this.visible)
         {
            this.visible = _loc2_;
            dispatchEvent(new VisibilityChangedEvent(VisibilityChangedEvent.VISIBILITY_CHANGED,_loc2_));
         }
      }
      
      private function getNodeData() : Object
      {
         return this["_nodedata"];
      }
      
      public function setEngineCallbacks(param1:Function, param2:Function) : void
      {
      }
      
      public function handleMouseDown(param1:Function, param2:MouseEvent) : void
      {
         Log.mouse(this,param2);
         param2.stopImmediatePropagation();
      }
      
      public function handleMouseUp(param1:Function, param2:MouseEvent) : void
      {
         MouseUtil.handleMouseUp(this.m_mouseMode,this,param1,param2);
      }
      
      public function handleMouseOver(param1:Function, param2:MouseEvent) : void
      {
      }
      
      public function handleMouseOut(param1:Function, param2:MouseEvent) : void
      {
         Log.mouse(this,param2);
      }
      
      public function handleMouseRollOver(param1:Function, param2:MouseEvent) : void
      {
         MouseUtil.handleMouseRollOver(this.m_mouseMode,this,param1,param2);
      }
      
      public function handleMouseRollOut(param1:Function, param2:MouseEvent) : void
      {
         MouseUtil.handleMouseRollOut(this.m_mouseMode,this,param1,param2);
      }
      
      public function handleMouseWheel(param1:Function, param2:MouseEvent) : void
      {
         MouseUtil.handleMouseWheel(this.m_mouseWheelMode,this,param1,param2);
      }
      
      public function triggerMouseRollOver() : void
      {
         Log.info(Log.ChannelMouse,this,"triggerMouseRollOver");
         var _loc1_:MouseEvent = new MouseEvent(MouseEvent.ROLL_OVER,true);
         this.dispatchEvent(_loc1_);
      }
      
      public function setFocus(param1:Boolean) : void
      {
         var _loc7_:MenuElementBase = null;
         var _loc2_:Boolean = true;
         var _loc3_:MenuElementBase = null;
         var _loc4_:DisplayObjectContainer = this;
         var _loc5_:MenuElementBase = this as MenuElementBase;
         var _loc6_:DisplayObjectContainer = this.parent;
         while(_loc6_ != null)
         {
            _loc3_ = _loc6_ as MenuElementBase;
            if((_loc7_ = _loc4_ as MenuElementBase) != null)
            {
               _loc5_ = _loc7_;
            }
            if(_loc3_ != null && _loc5_ != null)
            {
               if(param1)
               {
                  _loc3_.setFocusChildElement(_loc5_);
               }
               else
               {
                  _loc3_.unsetFocusChildElement(_loc5_);
               }
               if(!_loc2_)
               {
                  return;
               }
            }
            _loc6_ = (_loc4_ = _loc6_).parent;
         }
      }
      
      public function setFocusChildElement(param1:Sprite) : void
      {
         var _loc2_:int = this.m_children.indexOf(param1);
         if(_loc2_ >= 0)
         {
            this.setFocusChild(_loc2_);
         }
      }
      
      public function unsetFocusChildElement(param1:Sprite) : void
      {
         if(this.m_focusIndex >= 0 && this.getContainer().getChildAt(this.getContainer().numChildren - 1) == param1)
         {
            this.unsetFocusChild();
         }
      }
      
      private function setFocusChild(param1:int) : void
      {
         this.unsetFocusChild();
         if(param1 < 0 && param1 >= this.getContainer().numChildren)
         {
            return;
         }
         var _loc2_:Sprite = this.getContainer().getChildAt(param1) as Sprite;
         if(_loc2_ != null)
         {
            this.getContainer().setChildIndex(_loc2_,this.getContainer().numChildren - 1);
            this.getContainer().addChildAt(this.m_focusPlaceholder,param1);
            this.m_focusIndex = param1;
         }
      }
      
      private function unsetFocusChild() : void
      {
         var _loc1_:Sprite = null;
         if(this.m_focusIndex >= 0 && this.m_focusIndex < this.getContainer().numChildren - 1)
         {
            _loc1_ = this.getContainer().getChildAt(this.getContainer().numChildren - 1) as Sprite;
            if(_loc1_ != null)
            {
               this.getContainer().removeChildAt(this.m_focusIndex);
               this.getContainer().setChildIndex(_loc1_,this.m_focusIndex);
            }
         }
         this.m_focusIndex = -1;
      }
      
      public function pausePopOutScale() : void
      {
         if(this.m_activePopOutScaleViewElement == null)
         {
            return;
         }
         this.m_activePopOutScaleViewElementPaused = this.m_activePopOutScaleViewElement;
         this.setPopOutScale(this.m_activePopOutScaleViewElement,false,false);
      }
      
      public function resumePopOutScale() : void
      {
         if(this.m_activePopOutScaleViewElementPaused == null)
         {
            return;
         }
         this.setPopOutScale(this.m_activePopOutScaleViewElementPaused,true,false);
         this.m_activePopOutScaleViewElementPaused = null;
      }
      
      protected function setPopOutScale(param1:Object, param2:Boolean, param3:Boolean = true) : void
      {
         var viewElement:Object = param1;
         var active:Boolean = param2;
         var animate:Boolean = param3;
         var isQueuedOrActive:Boolean = this.m_isPopOutScaleQueued || this.m_isPopOutScaleActive;
         if(isQueuedOrActive == active)
         {
            return;
         }
         if(!active)
         {
            if(this.m_isPopOutScaleActive)
            {
               this.setPopOutScale_internal(viewElement,active,animate);
               return;
            }
            if(this.m_isPopOutScaleQueued)
            {
               Animate.kill(viewElement);
               this.m_isPopOutScaleQueued = false;
               return;
            }
         }
         this.m_isPopOutScaleQueued = true;
         Animate.delay(viewElement,0.1,function():void
         {
            m_isPopOutScaleQueued = false;
            setPopOutScale_internal(viewElement,active,animate);
         });
      }
      
      private function setPopOutScale_internal(param1:Object, param2:Boolean, param3:Boolean = true) : void
      {
         var bound:Rectangle = null;
         var width:Number = NaN;
         var height:Number = NaN;
         var localBounds:Rectangle = null;
         var localCoordScale:Number = NaN;
         var target_z:Number = NaN;
         var POPOUT_GAIN_MAX_WIDTH_VR:Number = NaN;
         var POPOUT_GAIN_MAX_HEIGHT_VR:Number = NaN;
         var animationVarsVr:Object = null;
         var POPOUT_GAIN_MAX_WIDTH:Number = NaN;
         var POPOUT_GAIN_MAX_HEIGHT:Number = NaN;
         var animationVars:Object = null;
         var viewElement:Object = param1;
         var active:Boolean = param2;
         var animate:Boolean = param3;
         if(this.m_isPopOutScaleActive == active)
         {
            return;
         }
         this.m_activePopOutScaleViewElement = active ? viewElement : null;
         this.setFocus(active);
         this.m_isPopOutScaleActive = active;
         if(active)
         {
            Animate.complete(viewElement);
            bound = this.getMenuElementBounds(this,this,function(param1:MenuElementBase):Boolean
            {
               return param1.visible;
            });
            width = bound.width;
            height = bound.height;
            this.m_popOutOriginalScale = new Point(viewElement.scaleX,viewElement.scaleY);
            this.m_popOutOriginalPos = new Point(viewElement.x,viewElement.y);
            localBounds = viewElement.getBounds(viewElement);
            if(ControlsMain.isVrModeActive())
            {
               localCoordScale = Math.min(localBounds.width,localBounds.height);
               target_z = localCoordScale * -0.1;
               POPOUT_GAIN_MAX_WIDTH_VR = 14;
               POPOUT_GAIN_MAX_HEIGHT_VR = 12;
               animationVarsVr = CalcUtil.createScalingAnimationParameters(this.m_popOutOriginalPos,this.m_popOutOriginalScale,localBounds,POPOUT_GAIN_MAX_WIDTH_VR,POPOUT_GAIN_MAX_HEIGHT_VR);
               animationVarsVr.z = target_z;
               if(animate)
               {
                  Animate.to(viewElement,0.3,0,animationVarsVr,Animate.ExpoOut);
               }
               else
               {
                  viewElement.scaleX = animationVarsVr.scaleX;
                  viewElement.scaleY = animationVarsVr.scaleY;
                  viewElement.x = animationVarsVr.x;
                  viewElement.y = animationVarsVr.y;
                  viewElement.z = animationVarsVr.z;
               }
            }
            else
            {
               POPOUT_GAIN_MAX_WIDTH = 28;
               POPOUT_GAIN_MAX_HEIGHT = 24;
               animationVars = CalcUtil.createScalingAnimationParameters(this.m_popOutOriginalPos,this.m_popOutOriginalScale,localBounds,POPOUT_GAIN_MAX_WIDTH,POPOUT_GAIN_MAX_HEIGHT);
               if(animate)
               {
                  Animate.to(viewElement,0.3,0,animationVars,Animate.ExpoOut);
               }
               else
               {
                  viewElement.scaleX = animationVars.scaleX;
                  viewElement.scaleY = animationVars.scaleY;
                  viewElement.x = animationVars.x;
                  viewElement.y = animationVars.y;
               }
            }
         }
         else
         {
            Animate.kill(viewElement);
            viewElement.scaleX = this.m_popOutOriginalScale.x;
            viewElement.scaleY = this.m_popOutOriginalScale.y;
            viewElement.x = this.m_popOutOriginalPos.x;
            viewElement.y = this.m_popOutOriginalPos.y;
            viewElement.z = 0;
         }
      }
   }
}
