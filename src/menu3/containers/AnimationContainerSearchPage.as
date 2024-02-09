package menu3.containers
{
   import common.Animate;
   import common.Log;
   import common.menu.MenuConstants;
   import flash.display.Sprite;
   import flash.geom.Point;
   import menu3.MenuElementBase;
   
   public dynamic class AnimationContainerSearchPage extends BaseContainer
   {
       
      
      private const ANIMATION_MOVE_NAME:String = "move";
      
      private const ANIMATION_BLENDOUT_NAME:String = "blendout";
      
      private var m_moveElements:Array;
      
      private var m_moveElementsStartPositions:Array;
      
      private var m_blendoutElements:Array;
      
      private var m_movement:Point;
      
      private var m_moveDuration:Number = 0;
      
      private var m_blendoutDuration:Number = 0;
      
      private var m_forwardCallbackAction:String;
      
      private var m_reverseCallbackAction:String;
      
      public function AnimationContainerSearchPage(param1:Object)
      {
         this.m_moveElements = new Array();
         this.m_moveElementsStartPositions = new Array();
         this.m_blendoutElements = new Array();
         super(param1);
      }
      
      override public function onSetData(param1:Object) : void
      {
         super.onSetData(param1);
         var _loc2_:Number = param1.move_col * MenuConstants.GridUnitHeight;
         var _loc3_:Number = param1.move_row * MenuConstants.GridUnitHeight;
         this.m_movement = new Point(_loc2_,_loc3_);
         this.m_moveDuration = param1.moveduration != undefined ? Number(param1.moveduration) : 0;
         this.m_blendoutDuration = param1.blendoutduration != undefined ? Number(param1.blendoutduration) : 0;
         this.m_forwardCallbackAction = param1.callback_forward;
         this.m_reverseCallbackAction = param1.callback_reverse;
      }
      
      override public function addChild2(param1:Sprite, param2:int = -1) : void
      {
         var _loc5_:Point = null;
         super.addChild2(param1,param2);
         var _loc3_:MenuElementBase = param1 as MenuElementBase;
         if(_loc3_ == null)
         {
            return;
         }
         var _loc4_:Object;
         if((_loc4_ = _loc3_.getData()) == null)
         {
            return;
         }
         if("animation" in _loc4_)
         {
            if(_loc4_["animation"] == this.ANIMATION_MOVE_NAME)
            {
               this.m_moveElements.push(_loc3_);
               _loc5_ = new Point(_loc3_.x,_loc3_.y);
               this.m_moveElementsStartPositions.push(_loc5_);
            }
            else if(_loc4_["animation"] == this.ANIMATION_BLENDOUT_NAME)
            {
               this.m_blendoutElements.push(_loc3_);
            }
         }
      }
      
      override public function removeChild2(param1:Sprite) : void
      {
         var _loc3_:int = 0;
         var _loc2_:MenuElementBase = param1 as MenuElementBase;
         if(_loc2_ != null)
         {
            _loc3_ = this.m_moveElements.indexOf(_loc2_);
            if(_loc3_ >= 0)
            {
               this.m_moveElements.splice(_loc3_,1);
               this.m_moveElementsStartPositions.splice(_loc3_,1);
            }
            _loc3_ = this.m_blendoutElements.indexOf(_loc2_);
            if(_loc3_ >= 0)
            {
               this.m_blendoutElements.splice(_loc3_,1);
            }
         }
         super.removeChild2(param1);
      }
      
      public function startAnimation(param1:Boolean) : void
      {
         Log.info(Log.ChannelAni,this,"start animation forward=" + param1);
         var _loc2_:Array = new Array();
         var _loc3_:Array = new Array();
         _loc2_.push(this.startBlendoutAnimation);
         _loc3_.push(this.m_blendoutDuration);
         _loc2_.push(this.startMoveAnimation);
         _loc3_.push(this.m_moveDuration);
         if(!param1)
         {
            _loc2_ = _loc2_.reverse();
            _loc3_ = _loc3_.reverse();
         }
         this.callAnimation(_loc2_,_loc3_,param1,0);
      }
      
      private function callAnimation(param1:Array, param2:Array, param3:Boolean, param4:int) : void
      {
         var animationFunction:Function;
         var duration:Number;
         var callbackAction:String = null;
         var animationFunctions:Array = param1;
         var durations:Array = param2;
         var forward:Boolean = param3;
         var index:int = param4;
         Log.info(Log.ChannelAni,this,"callAnimation index=" + index + " animationFunctions.length()=" + animationFunctions.length);
         if(animationFunctions == null || durations == null || index < 0)
         {
            return;
         }
         if(index >= animationFunctions.length || index >= durations.length)
         {
            return;
         }
         animationFunction = animationFunctions[index];
         duration = Number(durations[index]);
         Log.info(Log.ChannelAni,this,"callAnimation animationFunction=" + animationFunction + " duration=" + duration);
         if(animationFunction != null)
         {
            animationFunction(duration,forward);
         }
         index += 1;
         if(index < animationFunctions.length)
         {
            Log.info(Log.ChannelAni,this,"callAnimation queue next animation index=" + index);
            Animate.delay(this,duration,function():void
            {
               callAnimation(animationFunctions,durations,forward,index);
            });
         }
         else
         {
            Log.info(Log.ChannelAni,this,"callAnimation queue callback");
            callbackAction = forward ? this.m_forwardCallbackAction : this.m_reverseCallbackAction;
            Animate.delay(this,duration,function():void
            {
               animationFinished(callbackAction);
            });
         }
      }
      
      private function startBlendoutAnimation(param1:Number, param2:Boolean) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < this.m_blendoutElements.length)
         {
            this.startBlendoutAnimationOnElement(this.m_blendoutElements[_loc3_],param2,param1);
            _loc3_++;
         }
      }
      
      private function startMoveAnimation(param1:Number, param2:Boolean) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < this.m_moveElements.length)
         {
            this.startMoveAnimationOnElement(this.m_moveElements[_loc3_],this.m_moveElementsStartPositions[_loc3_],param2,param1);
            _loc3_++;
         }
      }
      
      private function startBlendoutAnimationOnElement(param1:MenuElementBase, param2:Boolean, param3:Number) : void
      {
         var startAlpha:Number;
         var endAlpha:Number = NaN;
         var element:MenuElementBase = param1;
         var forward:Boolean = param2;
         var duration:Number = param3;
         if(element == null)
         {
            return;
         }
         Animate.complete(element);
         startAlpha = forward ? 1 : 0;
         endAlpha = forward ? 0 : 1;
         element.alpha = startAlpha;
         element.visible = true;
         Animate.legacyTo(element,duration,{"alpha":endAlpha},Animate.ExpoOut,function():void
         {
            element.visible = endAlpha == 1;
         });
      }
      
      private function startMoveAnimationOnElement(param1:MenuElementBase, param2:Point, param3:Boolean, param4:Number) : void
      {
         if(param1 == null)
         {
            return;
         }
         Animate.complete(param1);
         var _loc5_:Point;
         (_loc5_ = param2.clone()).offset(this.m_movement.x,this.m_movement.y);
         var _loc6_:Number = param3 ? 1 : -1;
         var _loc7_:Point = param3 ? param2 : _loc5_;
         var _loc8_:Point = param3 ? _loc5_ : param2;
         param1.x = _loc7_.x;
         param1.y = _loc7_.y;
         Animate.legacyTo(param1,param4,{
            "x":_loc8_.x,
            "y":_loc8_.y
         },Animate.ExpoOut);
      }
      
      private function animationFinished(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         if(Boolean(this["_nodedata"]) && m_sendEventWithValue != null)
         {
            Log.info(Log.ChannelAni,this,"Animation finished. Call json action: " + param1);
            _loc2_ = this["_nodedata"]["id"] as int;
            _loc3_ = new Array(_loc2_,param1);
            m_sendEventWithValue("onTriggerAction",_loc3_);
         }
      }
   }
}
