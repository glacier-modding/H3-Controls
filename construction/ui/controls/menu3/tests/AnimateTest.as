package menu3.tests
{
   import common.Animate;
   import common.Log;
   import flash.display.Sprite;
   import menu3.MenuElementBase;
   
   public dynamic class AnimateTest extends MenuElementBase
   {
       
      
      private const OBJECT_COUNT:int = 10;
      
      private var m_objects:Array;
      
      public function AnimateTest(param1:Object)
      {
         this.m_objects = new Array();
         super(param1);
         var _loc2_:int = 0;
         while(_loc2_ < this.OBJECT_COUNT)
         {
            this.m_objects.push(this.createSpriteObject());
            _loc2_++;
         }
      }
      
      private static function setupEasingAnimation(param1:Sprite, param2:Boolean, param3:Number, param4:int) : void
      {
         var _loc5_:Number = 2;
         var _loc6_:Number = 0;
         var _loc7_:Number = param3 * (param2 ? 1 : -1);
         Animate.addOffset(param1,_loc5_,_loc6_,{"x":_loc7_},param4,setupEasingAnimation,param1,!param2,param3,param4);
      }
      
      private static function setupAlphaAnimation(param1:Sprite, param2:Boolean, param3:int) : void
      {
         var _loc4_:Number = 1;
         var _loc5_:Number = 0.8;
         var _loc6_:Number = param2 ? 1 : 0.5;
         var _loc7_:Number = param2 ? 0.3 : 1;
         Animate.addFromTo(param1,_loc4_,_loc5_,{"alpha":_loc6_},{"alpha":_loc7_},param3,setupAlphaAnimation,param1,!param2,param3);
      }
      
      override public function onSetData(param1:Object) : void
      {
         super.onSetData(param1);
         this.setupStartPosition();
         this.setupCallbackTest();
      }
      
      private function createSpriteObject() : Sprite
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.clear();
         _loc1_.graphics.beginFill(16711680,1);
         _loc1_.graphics.drawRect(-25,-25,50,50);
         _loc1_.graphics.endFill();
         addChild(_loc1_);
         return _loc1_;
      }
      
      private function setupStartPosition() : void
      {
         var _loc1_:Number = 0;
         var _loc2_:Number = 200;
         var _loc3_:Number = 10;
         var _loc4_:int = 0;
         while(_loc4_ < this.m_objects.length)
         {
            this.m_objects[_loc4_].x = _loc1_;
            this.m_objects[_loc4_].y = (this.m_objects[_loc4_].height + _loc3_) * _loc4_ + _loc2_;
            _loc4_++;
         }
      }
      
      private function killAnimations() : void
      {
         Animate.kill(this);
         var _loc1_:int = 0;
         while(_loc1_ < this.m_objects.length)
         {
            Animate.kill(this.m_objects[_loc1_]);
            _loc1_++;
         }
      }
      
      private function startAnimationGroup() : void
      {
         this.setupEasingTest();
         this.setupParallelTest();
         this.setupFromToTest();
      }
      
      private function setupEasingTest() : void
      {
         var _loc1_:Number = 1000;
         setupEasingAnimation(this.m_objects[0],true,_loc1_,Animate.Linear);
         setupEasingAnimation(this.m_objects[1],true,_loc1_,Animate.SineIn);
         setupEasingAnimation(this.m_objects[2],true,_loc1_,Animate.SineOut);
         setupEasingAnimation(this.m_objects[3],true,_loc1_,Animate.SineInOut);
         setupEasingAnimation(this.m_objects[4],true,_loc1_,Animate.ExpoIn);
         setupEasingAnimation(this.m_objects[5],true,_loc1_,Animate.ExpoOut);
         setupEasingAnimation(this.m_objects[6],true,_loc1_,Animate.ExpoInOut);
         setupEasingAnimation(this.m_objects[7],true,_loc1_,Animate.BackIn);
         setupEasingAnimation(this.m_objects[8],true,_loc1_,Animate.BackOut);
         setupEasingAnimation(this.m_objects[9],true,_loc1_,Animate.BackInOut);
      }
      
      private function setupFromToTest() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.m_objects.length)
         {
            setupAlphaAnimation(this.m_objects[_loc1_],true,Animate.Linear);
            _loc1_++;
         }
      }
      
      private function setupParallelTest() : void
      {
         this.setupParallelAnimation(0,Animate.Linear);
      }
      
      private function setupParallelAnimation(param1:int, param2:int) : void
      {
         if(param1 >= this.m_objects.length)
         {
            this.killAnimations();
            this.setupStartPosition();
            this.setupEasingTest();
            return;
         }
         var _loc3_:Number = 0.5;
         var _loc4_:Number = 0;
         Animate.addOffset(this.m_objects[param1],_loc3_,_loc4_,{"rotation":360},param2,this.setupParallelAnimation,param1 + 1,param2);
      }
      
      private function setupCallbackTest() : void
      {
         var text:String = null;
         Animate.delay(this.m_objects[0],0.1,this.simpleCallback);
         text = "Hello World!";
         Animate.delay(this.m_objects[0],0.2,this.callback,text);
         text = "Hello World2!";
         Animate.delay(this.m_objects[0],0.3,this.callback,text);
         text = "Hello World3!";
         Animate.delay(this.m_objects[0],0.4,this.nestedCallback,text);
         Animate.delay(this.m_objects[0],0.6,function():void
         {
            Log.info("debug",this,"simpleLambdaCallback");
         });
         text = "Hello World7!";
         Animate.delay(this.m_objects[0],0.7,function(param1:String):void
         {
            Log.info("debug",this,"lambdaCallback: " + param1);
         },text);
         text = "Hello World8!";
         Animate.delay(this.m_objects[0],0.8,function():void
         {
            Log.info("debug",this,"lambdaCallback: " + text);
         });
         text = "Hello World9!";
         Animate.delay(this,0.9,this.setupCallbackTest2);
      }
      
      private function simpleCallback() : void
      {
         Log.info("debug",this,"simpleCallback");
      }
      
      private function callback(param1:String) : void
      {
         Log.info("debug",this,"callback: " + param1);
      }
      
      private function nestedCallback(param1:String) : void
      {
         Log.info("debug",this,"nestedCallback: " + param1);
         Animate.delay(this.m_objects[5],0.1,this.callback,param1);
      }
      
      private function setupCallbackTest2() : void
      {
         var textObj:Object = null;
         textObj = new Object();
         textObj["Text"] = "Hello Object!";
         Animate.delay(this.m_objects[0],0.1,this.callbackObject,textObj);
         textObj["Text"] = "Hello Object2!";
         Animate.delay(this.m_objects[0],0.2,this.callbackObject,textObj);
         textObj["Text"] = "Hello Object3!";
         Animate.delay(this.m_objects[0],0.3,this.nestedCallbackObject,textObj);
         textObj["Text"] = "Hello Object7!";
         Animate.delay(this.m_objects[0],0.5,function(param1:Object):void
         {
            Log.info("debug",this,"lambdaCallback: " + param1["Text"]);
         },textObj);
         textObj["Text"] = "Hello Object8!";
         Animate.delay(this.m_objects[0],0.6,function():void
         {
            Log.info("debug",this,"lambdaCallback: " + textObj["Text"]);
         });
         textObj["Text"] = "Hello Object9!";
         Animate.delay(this,0.7,this.startAnimationGroup);
      }
      
      private function callbackObject(param1:Object) : void
      {
         Log.info("debug",this,"callbackObject: " + param1["Text"]);
      }
      
      private function nestedCallbackObject(param1:Object) : void
      {
         Log.info("debug",this,"nestedCallbackObject: " + param1["Text"]);
         Animate.delay(this.m_objects[0],0.1,this.callbackObject,param1);
      }
   }
}
