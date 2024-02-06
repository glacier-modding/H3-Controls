package common
{
	import flash.external.ExternalInterface;
	import flash.utils.getTimer;
	
	public class DateTimeUtils
	{
		
		private static const DEFAULT_MONTH_ABBREVIATIONS:Array = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];
		
		private static const DEFAULT_DATE_ABBREVIATION_FORMAT:String = "{MONTH} {DAY}, {YEAR}";
		
		private static var m_isInitialized:Boolean = false;
		
		private static var m_serverUTCTimeAtStartup:Date;
		
		private static var m_localUTCTimeAtStartup:Number;
		
		private static var s_currentLocale:String;
		
		private static var s_monthAbbreviationArray:Array;
		
		private static var s_dateAbbreviationFormat:String;
		
		public function DateTimeUtils()
		{
			super();
		}
		
		public static function initializeUtcClock(param1:Date):void
		{
			m_serverUTCTimeAtStartup = param1;
			m_localUTCTimeAtStartup = getTimer();
			m_isInitialized = true;
		}
		
		public static function getUTCClockNow():Date
		{
			var _loc3_:String = null;
			var _loc1_:Number = getTimer();
			if (!m_isInitialized)
			{
				_loc3_ = ExternalInterface.call("CommonUtilsGetServerTimeAsAs3Date");
				DateTimeUtils.initializeUtcClock(DateTimeUtils.parseUTCTimeStamp(_loc3_));
			}
			var _loc2_:Date = new Date();
			_loc2_.setTime(m_serverUTCTimeAtStartup.getTime() + (_loc1_ - m_localUTCTimeAtStartup));
			return _loc2_;
		}
		
		public static function parseUTCTimeStamp(param1:String):Date
		{
			var _loc2_:Array = param1.split(",");
			var _loc3_:Date = new Date(0);
			if (_loc2_.length == 6)
			{
				_loc3_.setUTCFullYear(_loc2_[0], _loc2_[1], _loc2_[2]);
				_loc3_.setUTCHours(_loc2_[3], _loc2_[4], _loc2_[5]);
			}
			else
			{
				trace("DateTimeUtils: Warning, parseUTCTimeStamp() failed, invalid date string " + param1 + " " + _loc2_);
			}
			return _loc3_;
		}
		
		public static function parseSqlUTCTimeStamp(param1:String):Date
		{
			var _loc2_:Array = param1.split("T");
			if (_loc2_.length != 2)
			{
				trace("DateTimeUtils: Warning, parseSqlUTCTimeStamp() failed, invalid date string: " + param1);
			}
			var _loc3_:Array = _loc2_[0].split("-");
			if (_loc3_.length != 3)
			{
				trace("DateTimeUtils: Warning, parseSqlUTCTimeStamp() failed, invalid ymd string: " + _loc2_[0]);
			}
			var _loc4_:Array;
			if ((_loc4_ = _loc2_[1].split(":")).length != 3)
			{
				trace("DateTimeUtils: Warning, parseSqlUTCTimeStamp() failed, invalid hms string: " + _loc2_[1]);
			}
			var _loc5_:Array;
			if ((_loc5_ = _loc4_[2].split(".")).length != 2)
			{
				trace("DateTimeUtils: Warning, parseSqlUTCTimeStamp() failed, invalid hms string: " + _loc5_[2]);
			}
			var _loc6_:Date = new Date(0);
			var _loc7_:int = _loc3_[1] - 1;
			_loc6_.setUTCFullYear(_loc3_[0], _loc7_, _loc3_[2]);
			_loc6_.setUTCHours(_loc4_[0], _loc4_[1], _loc5_[0]);
			return _loc6_;
		}
		
		public static function parseLocalTimeStamp(param1:String):Date
		{
			var _loc2_:Array = param1.split(",");
			var _loc3_:Date = new Date(0);
			if (_loc2_.length == 6)
			{
				_loc3_.setFullYear(_loc2_[0], _loc2_[1], _loc2_[2]);
				_loc3_.setHours(_loc2_[3], _loc2_[4], _loc2_[5]);
			}
			else
			{
				trace("DateTimeUtils: Warning, parseTimeStamp() failed, invalid date string");
			}
			return _loc3_;
		}
		
		public static function parseUTCMilliseconds(param1:Number):Date
		{
			var _loc2_:Date = new Date();
			_loc2_.setTime(param1);
			return _loc2_;
		}
		
		public static function formatDurationHHMMSS(param1:Number):String
		{
			var _loc2_:Number = Math.floor(param1 / 1000);
			var _loc3_:Number = Math.floor(_loc2_ / (60 * 60 * 24));
			if (_loc3_ >= 4)
			{
				_loc2_ -= _loc3_ * (60 * 60 * 24);
			}
			var _loc4_:Number = Math.floor(_loc2_ / (60 * 60));
			_loc2_ -= _loc4_ * (60 * 60);
			var _loc5_:Number = Math.floor(_loc2_ / 60) % 60;
			_loc2_ -= _loc5_ * 60;
			var _loc6_:Number = _loc2_ % 60;
			var _loc7_:String = _loc3_ == 0 ? "" : _loc3_ + " " + Localization.get("UI_DIALOG_DAYS");
			var _loc8_:String = _loc4_ == 0 ? "00:" : padLeft(_loc4_.toString(), "0", 2) + ":";
			var _loc9_:String = _loc4_ == 0 && _loc5_ == 0 ? "00:" : padLeft(_loc5_.toString(), "0", 2) + ":";
			var _loc10_:String = padLeft(_loc6_.toString(), "0", 2);
			return _loc3_ >= 4 ? _loc7_ : _loc8_ + _loc9_ + _loc10_;
		}
		
		public static function formatDateToLocalTimeZone(param1:Date):String
		{
			updateLocalization();
			var _loc2_:Date = getTimezoneCorrectedUTCTime(param1);
			var _loc3_:String = padLeft(_loc2_.getUTCDate().toString(), "0", 2);
			var _loc4_:String = String(s_monthAbbreviationArray[_loc2_.getUTCMonth()]);
			var _loc5_:String = _loc2_.getUTCFullYear().toString();
			var _loc6_:String = padLeft(_loc2_.getUTCHours().toString(), "0", 2);
			var _loc7_:String = padLeft(_loc2_.getUTCMinutes().toString(), "0", 2);
			return _loc3_ + _loc4_ + _loc5_ + " - " + _loc6_ + ":" + _loc7_;
		}
		
		public static function formatDateToLocalTimeZoneLocalized(param1:Date):String
		{
			updateLocalization();
			var _loc2_:Date = getTimezoneCorrectedUTCTime(param1);
			var _loc3_:String = padLeft(_loc2_.getUTCDate().toString(), "0", 2);
			var _loc4_:String = String(s_monthAbbreviationArray[_loc2_.getUTCMonth()]);
			var _loc5_:String = _loc2_.getUTCFullYear().toString();
			return formatLocalizedAbbeviateDate(_loc3_, _loc4_, _loc5_);
		}
		
		public static function formatDateToLocalTimeZoneHM(param1:Date):String
		{
			var _loc2_:Date = getTimezoneCorrectedUTCTime(param1);
			var _loc3_:String = padLeft(_loc2_.getUTCHours().toString(), "0", 2);
			var _loc4_:String = padLeft(_loc2_.getUTCMinutes().toString(), "0", 2);
			return _loc3_ + ":" + _loc4_;
		}
		
		public static function formatLocalDateLocalized(param1:Date):String
		{
			updateLocalization();
			var _loc2_:String = padLeft(param1.getDate().toString(), "0", 2);
			var _loc3_:String = String(s_monthAbbreviationArray[param1.getMonth()]);
			var _loc4_:String = param1.getFullYear().toString();
			return formatLocalizedAbbeviateDate(_loc2_, _loc3_, _loc4_);
		}
		
		public static function formatLocalDateHM(param1:Date):String
		{
			var _loc2_:String = padLeft(param1.getHours().toString(), "0", 2);
			var _loc3_:String = padLeft(param1.getMinutes().toString(), "0", 2);
			return _loc2_ + ":" + _loc3_;
		}
		
		public static function getNowInLocalTime():Date
		{
			var _loc1_:Date = null;
			var _loc2_:Date = null;
			var _loc3_:Number = NaN;
			var _loc4_:Number = NaN;
			var _loc5_:Number = NaN;
			var _loc6_:Number = NaN;
			var _loc7_:Date = null;
			if (CommonUtils.getPlatformString() == CommonUtils.PLATFORM_ORBIS)
			{
				_loc1_ = new Date();
				_loc2_ = new Date();
				_loc2_.setHours(0, 0, 0, 0);
				_loc3_ = _loc1_.timezoneOffset - _loc2_.timezoneOffset;
				_loc5_ = (_loc4_ = _loc1_.timezoneOffset - 2 * _loc3_) * 2 * 60 * 1000;
				_loc6_ = _loc1_.getTime() + _loc5_;
				return new Date(_loc6_);
			}
			return new Date();
		}
		
		private static function getTimezoneCorrectedUTCTime(param1:Date):Date
		{
			var _loc2_:Number = param1.getTime();
			if (CommonUtils.getPlatformString() == CommonUtils.PLATFORM_ORBIS)
			{
				_loc2_ += param1.timezoneOffset * 60 * 1000;
			}
			else
			{
				_loc2_ -= param1.timezoneOffset * 60 * 1000;
			}
			return new Date(_loc2_);
		}
		
		private static function padLeft(param1:String, param2:String, param3:uint):String
		{
			while (param1.length < param3)
			{
				param1 = param2 + param1;
			}
			return param1;
		}
		
		private static function formatLocalizedAbbeviateDate(param1:String, param2:String, param3:String):String
		{
			var _loc4_:String;
			return (_loc4_ = (_loc4_ = (_loc4_ = s_dateAbbreviationFormat).replace("{DAY}", param1)).replace("{MONTH}", param2)).replace("{YEAR}", param3);
		}
		
		private static function updateLocalization():void
		{
			var _loc1_:String = ControlsMain.getActiveLocale();
			if (_loc1_ != s_currentLocale || s_dateAbbreviationFormat == null || s_monthAbbreviationArray == null)
			{
				s_currentLocale = _loc1_;
				s_monthAbbreviationArray = Localization.get("UI_MONTH_ABBREVIATIONS").split(",");
				s_dateAbbreviationFormat = Localization.get("UI_DATE_ABBREVIATION_FORMAT");
				if (s_monthAbbreviationArray == null || s_monthAbbreviationArray.length != 12)
				{
					s_monthAbbreviationArray = DEFAULT_MONTH_ABBREVIATIONS;
				}
				if (s_dateAbbreviationFormat == null || s_dateAbbreviationFormat.length == 0)
				{
					s_dateAbbreviationFormat = DEFAULT_DATE_ABBREVIATION_FORMAT;
				}
			}
		}
	}
}
