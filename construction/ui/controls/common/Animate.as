package common
{
   import flash.display.DisplayObject;
   import flash.external.ExternalInterface;
   
   public class Animate
   {
      
      public static var Linear:int = 0;
      
      public static var SineIn:int = 1;
      
      public static var SineOut:int = 2;
      
      public static var SineInOut:int = 3;
      
      public static var ExpoIn:int = 4;
      
      public static var ExpoOut:int = 5;
      
      public static var ExpoInOut:int = 6;
      
      public static var BackIn:int = 7;
      
      public static var BackOut:int = 8;
      
      public static var BackInOut:int = 9;
      
      private static var To:int = 1;
      
      private static var From:int = 2;
      
      private static var Offset:int = 3;
      
      private static var FromTo:int = 4;
      
      private static var AddTo:int = 5;
      
      private static var AddFrom:int = 6;
      
      private static var AddOffset:int = 7;
      
      private static var AddFromTo:int = 8;
      
      private static var AddFromToExtended:int = 9;
      
      private static var Kill:int = 10;
      
      private static var Complete:int = 11;
      
      private static var Delay:int = 12;
       
      
      public function Animate()
      {
         super();
      }
      
      public static function to(param1:Object, param2:Number, param3:Number, param4:Object, param5:int, param6:Function = null, ... rest) : void
      {
         ExternalInterface.call("AnimateNative",To,param1,param2,param3,param4,param5,param6,rest);
      }
      
      public static function from(param1:DisplayObject, param2:Number, param3:Number, param4:Object, param5:int, param6:Function = null, ... rest) : void
      {
         ExternalInterface.call("AnimateNative",From,param1,param2,param3,param4,param5,param6,rest);
      }
      
      public static function offset(param1:DisplayObject, param2:Number, param3:Number, param4:Object, param5:int, param6:Function = null, ... rest) : void
      {
         ExternalInterface.call("AnimateNative",Offset,param1,param2,param3,param4,param5,param6,rest);
      }
      
      public static function fromTo(param1:DisplayObject, param2:Number, param3:Number, param4:Object, param5:Object, param6:int, param7:Function = null, ... rest) : void
      {
         ExternalInterface.call("AnimateNative",FromTo,param1,param2,param3,param4,param5,param6,param7,rest);
      }
      
      public static function addTo(param1:DisplayObject, param2:Number, param3:Number, param4:Object, param5:int, param6:Function = null, ... rest) : void
      {
         ExternalInterface.call("AnimateNative",AddTo,param1,param2,param3,param4,param5,param6,rest);
      }
      
      public static function addFrom(param1:DisplayObject, param2:Number, param3:Number, param4:Object, param5:int, param6:Function = null, ... rest) : void
      {
         ExternalInterface.call("AnimateNative",AddFrom,param1,param2,param3,param4,param5,param6,rest);
      }
      
      public static function addOffset(param1:DisplayObject, param2:Number, param3:Number, param4:Object, param5:int, param6:Function = null, ... rest) : void
      {
         ExternalInterface.call("AnimateNative",AddOffset,param1,param2,param3,param4,param5,param6,rest);
      }
      
      public static function addFromTo(param1:DisplayObject, param2:Number, param3:Number, param4:Object, param5:Object, param6:int, param7:Function = null, ... rest) : void
      {
         ExternalInterface.call("AnimateNative",AddFromTo,param1,param2,param3,param4,param5,param6,param7,rest);
      }
      
      public static function addFromToExtended(param1:DisplayObject, param2:Number, param3:Number, param4:Object, param5:Object, param6:int, param7:String, param8:String, param9:Function = null, ... rest) : void
      {
         ExternalInterface.call("AnimateNative",AddFromToExtended,param1,param2,param3,param4,param5,param6,param7,param8,param9,rest);
      }
      
      public static function legacyTo(param1:DisplayObject, param2:Number, param3:Object, param4:int, param5:Function = null, ... rest) : void
      {
         ExternalInterface.call("AnimateNative",To,param1,param2,0,param3,param4,param5,rest);
      }
      
      public static function legacyFrom(param1:DisplayObject, param2:Number, param3:Object, param4:int, param5:Function = null, ... rest) : void
      {
         ExternalInterface.call("AnimateNative",From,param1,param2,0,param3,param4,param5,rest);
      }
      
      public static function kill(param1:Object) : void
      {
         ExternalInterface.call("AnimateNative",Kill,param1);
      }
      
      public static function complete(param1:Object) : void
      {
         ExternalInterface.call("AnimateNative",Complete,param1);
      }
      
      public static function delay(param1:Object, param2:Number, param3:Function, ... rest) : void
      {
         ExternalInterface.call("AnimateNative",Delay,param1,param2,param3,rest);
      }
   }
}
