package menu3.indicator
{
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.MovieClip;
   
   public class CompletionStatusIndicatorUtil
   {
      
      public static const StatusIndicatorOffset:Number = 36;
       
      
      public function CompletionStatusIndicatorUtil()
      {
         super();
      }
      
      public static function removeIndicator(param1:Object) : void
      {
         if(!param1.hasOwnProperty("completionStatusIndicator"))
         {
            return;
         }
         if(param1.completionStatusIndicator == null)
         {
            return;
         }
         param1.removeChild(param1.completionStatusIndicator);
         param1.completionStatusIndicator = null;
      }
      
      public static function addIndicator(param1:Object, param2:String, param3:int = -1, param4:int = -1) : void
      {
         removeIndicator(param1);
         var _loc5_:MovieClip = new iconsAll40x40View();
         MenuUtils.setupIcon(_loc5_,param2,MenuConstants.COLOR_GREY_DARK,false,true,MenuConstants.COLOR_WHITE);
         _loc5_.x = param3 == -1 ? StatusIndicatorOffset : param3;
         _loc5_.y = param4 == -1 ? StatusIndicatorOffset : param4;
         param1.completionStatusIndicator = _loc5_;
         param1.addChild(_loc5_);
      }
   }
}
