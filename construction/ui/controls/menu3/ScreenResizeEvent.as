package menu3
{
   import flash.events.Event;
   
   public class ScreenResizeEvent extends Event
   {
      
      public static const SCREEN_RESIZED:String = "itSureDidResize";
       
      
      public var screenSize:Object;
      
      public function ScreenResizeEvent(param1:String, param2:Object, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.screenSize = param2;
      }
   }
}
