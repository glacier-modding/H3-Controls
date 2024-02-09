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
		
		override public function onSetData(param1:Object):void
		{
			var utctimestamp:String = ExternalInterface.call("CommonUtilsGetServerTimeAsAs3Date");
			Log.xinfo(Log.ChannelCommon, "server utctimestamp " + utctimestamp + " - parsed: " + DateTimeUtils.parseUTCTimeStamp(utctimestamp));
			DateTimeUtils.initializeUtcClock(DateTimeUtils.parseUTCTimeStamp(utctimestamp));
		}
	}
}
