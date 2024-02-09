package common
{
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	
	public class Log
	{
		
		public static const ChannelMem:String = "Memory";
		
		public static const ChannelVideo:String = "Video";
		
		public static const ChannelImage:String = "Image";
		
		public static const ChannelLoca:String = "Loca";
		
		public static const ChannelScale:String = "Scaling";
		
		public static const ChannelMouse:String = "Mouse";
		
		public static const ChannelDebug:String = "Debug";
		
		public static const ChannelModal:String = "ModalDialog";
		
		public static const ChannelAni:String = "Animation";
		
		public static const ChannelContainer:String = "Container";
		
		public static const ChannelButtonPrompt:String = "ButtonPrompt";
		
		public static const ChannelCommon:String = "Common";
		
		public static const ChannelMenuFrame:String = "MenuFrame";
		
		public function Log()
		{
			super();
		}
		
		public static function error(param1:String, param2:Object, param3:String):void
		{
			logMessage("ERROR", param1, param2, param3);
		}
		
		public static function xerror(param1:String, param2:String):void
		{
			error(param1, null, param2);
		}
		
		public static function warning(param1:String, param2:Object, param3:String):void
		{
			logMessage("warning", param1, param2, param3);
		}
		
		public static function xwarning(param1:String, param2:String):void
		{
			warning(param1, null, param2);
		}
		
		public static function info(param1:String, param2:Object, param3:String):void
		{
			logMessage("info", param1, param2, param3);
		}
		
		public static function xinfo(param1:String, param2:String):void
		{
			info(param1, null, param2);
		}
		
		public static function mouse(param1:Object, param2:MouseEvent, param3:String = null):void
		{
			var _loc4_:String = "event null";
			if (param2)
			{
				_loc4_ = "type: " + param2.type + " - target: " + (param2.target == null ? "<none>" : param2.target.name) + (param3 == null ? "" : " - " + param3);
			}
			logMessage("info", ChannelMouse, param1, _loc4_);
		}
		
		public static function debugData(param1:Object, param2:Object):void
		{
			var _loc3_:int = 0;
			debugDataRecursive(_loc3_, param2, param1);
		}
		
		private static function debugDataRecursive(param1:int, param2:Object, param3:Object):void
		{
			var _loc5_:String = null;
			var _loc6_:int = 0;
			var _loc4_:String = "Key";
			if (param1 > 0)
			{
				_loc4_ = ">";
				_loc6_ = 0;
				while (_loc6_ < param1 + 1)
				{
					_loc4_ = "--" + _loc4_;
					_loc6_++;
				}
			}
			for (_loc5_ in param2)
			{
				info(ChannelDebug, param3, "| " + _loc4_ + " : " + _loc5_ + ": " + param2[_loc5_]);
				debugDataRecursive(param1 + 1, param2[_loc5_], param3);
			}
		}
		
		public static function dumpData(param1:Object, param2:Object):void
		{
			var _loc3_:int = 0;
			var _loc4_:String = "";
			_loc4_ = dumpDataRecursive(_loc4_, param2, false);
			info(ChannelDebug, param1, _loc4_);
		}
		
		private static function dumpDataRecursive(param1:String, param2:Object, param3:Boolean):String
		{
			var _loc5_:* = undefined;
			var _loc6_:* = undefined;
			if (param2 == null)
			{
				return param1 + "null";
			}
			if (param3)
			{
				param1 += "[";
			}
			else
			{
				param1 += "{";
			}
			var _loc4_:Boolean = true;
			for (_loc5_ in param2)
			{
				if (!_loc4_)
				{
					param1 += ",";
				}
				_loc6_ = param2[_loc5_];
				if (!param3)
				{
					param1 += "\"" + _loc5_ + "\":";
				}
				if (_loc6_ == null)
				{
					param1 += "null";
				}
				else if (_loc6_ is Number || _loc6_ is Boolean)
				{
					param1 += _loc6_;
				}
				else if (_loc6_ is String)
				{
					param1 += "\"" + _loc6_ + "\"";
				}
				else if (_loc6_ is Array)
				{
					param1 = dumpDataRecursive(param1, _loc6_, true);
				}
				else if (_loc6_ is Object)
				{
					param1 = dumpDataRecursive(param1, _loc6_, false);
				}
				else
				{
					param1 += "\"" + _loc6_ + "\"";
				}
				_loc4_ = false;
			}
			if (param3)
			{
				param1 += "]";
			}
			else
			{
				param1 += "}";
			}
			return param1;
		}
		
		private static function logMessage(param1:String, param2:String, param3:Object, param4:String):void
		{
			if (!ControlsMain.isLogChannelEnabled(param2))
			{
				return;
			}
			if (param3)
			{
				trace(param1 + " | " + param2 + " | " + getQualifiedClassName(param3) + "(" + param3.name + "): " + param4);
			}
			else
			{
				trace(param1 + " | " + param2 + ": " + param4);
			}
		}
	}
}
