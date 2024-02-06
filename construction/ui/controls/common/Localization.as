package common
{
	import flash.external.ExternalInterface;
	
	public class Localization
	{
		
		public function Localization()
		{
			super();
		}
		
		public static function get(param1:String):String
		{
			if (param1 == null)
			{
				Log.xerror(Log.ChannelCommon, "Localization.get Error: key = null");
				return "";
			}
			return ExternalInterface.call("LocalizationGet", param1);
		}
	}
}
