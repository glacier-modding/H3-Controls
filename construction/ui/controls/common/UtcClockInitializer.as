package common
{
   import flash.external.ExternalInterface;
   import menu3.MenuElementBase;
   
   public dynamic class UtcClockInitializer extends MenuElementBase
   {
       
      
      public function UtcClockInitializer(param1:Object)
      {
         super(param1);
      }
      
      override public function onSetData(param1:Object) : void
      {
         var _loc2_:String = ExternalInterface.call("CommonUtilsGetServerTimeAsAs3Date");
         Log.xinfo(Log.ChannelCommon,"server utctimestamp " + _loc2_ + " - parsed: " + DateTimeUtils.parseUTCTimeStamp(_loc2_));
         DateTimeUtils.initializeUtcClock(DateTimeUtils.parseUTCTimeStamp(_loc2_));
      }
   }
}
