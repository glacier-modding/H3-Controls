package
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import scaleform.gfx.*;
	
	public class ControlsMain extends Sprite
	{
		
		private static var ms_invertEnabledChannels:Boolean = false;
		
		private static var ms_enabledChannels:Dictionary = new Dictionary();
		
		private static var ms_isMouseActive:Boolean = false;
		
		private static var ms_onMouseActiveChanged:Function = null;
		
		private static var ms_isVrModeActive:Boolean = false;
		
		private static var ms_activeLocale:String = "";
		
		private static var ms_controllerType:String = "";
		
		private static var ms_menuAcceptCancelLayout:int = 0;
		
		public static const DISPLAY_SIZE_NORMAL:int = 0;
		
		public static const DISPLAY_SIZE_SMALL:int = 1;
		
		private static var ms_displaySize:int = DISPLAY_SIZE_NORMAL;
		
		public static var ms_frameCount:int = -1;
		
		public static const MENUINPUTCAPABILITY_TEXTINPUT_VIA_PHYSICAL_KEYBOARD:int = 1 << 0;
		
		public static const MENUINPUTCAPABILITY_TEXTINPUT_VIA_VIRTUAL_KEYBOARD:int = 1 << 1;
		
		public static const MENUINPUTCAPABILITY_NAVIGATION_VIA_MOUSE:int = 1 << 2;
		
		public static const MENUINPUTCAPABILITY_NAVIGATION_VIA_PHYSICAL_KEYBOARD:int = 1 << 3;
		
		private static var ms_menuInputCapabilities:int = 0;
		
		public var OnLoadMovieDone:Function;
		
		private var m_loadedMovies:Dictionary;
		
		public function ControlsMain()
		{
			super();
			Extensions.enabled = true;
			Extensions.noInvisibleAdvance = true;
			this.m_loadedMovies = new Dictionary();
			this.SetupLogTraceChannels(true, ["mouse"]);
		}
		
		public static function isMouseActive():Boolean
		{
			return ms_isMouseActive;
		}
		
		public static function setOnMouseActiveChangedCallback(param1:Function):void
		{
			ms_onMouseActiveChanged = param1;
		}
		
		public static function isVrModeActive():Boolean
		{
			return ms_isVrModeActive;
		}
		
		public static function getControllerType():String
		{
			return ms_controllerType;
		}
		
		public static function getMenuAcceptCancelLayout():int
		{
			return ms_menuAcceptCancelLayout;
		}
		
		public static function getActiveLocale():String
		{
			return ms_activeLocale;
		}
		
		public static function getDisplaySize():int
		{
			return ms_displaySize;
		}
		
		public static function getMenuInputCapabilities():int
		{
			return ms_menuInputCapabilities;
		}
		
		public static function isLogChannelEnabled(param1:String):Boolean
		{
			if (ms_invertEnabledChannels)
			{
				if (!hasTraceChannels())
				{
					return false;
				}
				if (param1.toLowerCase() in ms_enabledChannels)
				{
					return false;
				}
			}
			else if (hasTraceChannels() && !(param1.toLowerCase() in ms_enabledChannels))
			{
				return false;
			}
			return true;
		}
		
		private static function hasTraceChannels():Boolean
		{
			var _loc1_:* = undefined;
			var _loc2_:int = 0;
			var _loc3_:* = ms_enabledChannels;
			for each (_loc1_ in _loc3_)
			{
				return true;
			}
			return false;
		}
		
		public static function getFrameCount():int
		{
			return ms_frameCount;
		}
		
		public function attachInstance(param1:Sprite, param2:String):Sprite
		{
			var _loc3_:Class = getDefinitionByName(param2) as Class;
			var _loc4_:Sprite = new _loc3_();
			param1.addChild(_loc4_);
			return _loc4_;
		}
		
		public function setInstanceDepth(param1:Sprite, param2:Sprite, param3:uint):void
		{
			param3 = Math.max(Math.min(param3, param1.numChildren - 1), 0);
			if (param3 >= 0)
			{
				param1.setChildIndex(param2, param3);
			}
		}
		
		public function LoadMovie(param1:String, param2:String):void
		{
			var urlReq:URLRequest;
			var loaderContext:LoaderContext;
			var loader:Loader = null;
			var swf:String = param1;
			var rid:String = param2;
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function():void
			{
				OnLoadMovieDone(rid, loader.content);
			});
			this.m_loadedMovies[swf] = loader;
			addChild(loader);
			urlReq = new URLRequest(swf);
			loaderContext = new LoaderContext(false, ApplicationDomain.currentDomain, null);
			loader.load(urlReq, loaderContext);
		}
		
		public function UnloadMovie(param1:String):void
		{
			var _loc2_:Loader = this.m_loadedMovies[param1];
			if (_loc2_ != null)
			{
				_loc2_.unload();
				removeChild(_loc2_);
				delete this.m_loadedMovies[param1];
			}
		}
		
		public function SetMouseActive(param1:Boolean):void
		{
			if (ms_isMouseActive == param1)
			{
				return;
			}
			trace("info | Mouse | SetMouseActive: " + param1);
			ms_isMouseActive = param1;
			if (ms_onMouseActiveChanged != null)
			{
				ms_onMouseActiveChanged(ms_isMouseActive);
			}
		}
		
		public function SetVrModeActive(param1:Boolean):void
		{
			ms_isVrModeActive = param1;
			trace("info | Mouse | SetVrModeActive: " + param1);
		}
		
		public function SetControllerType(param1:String):void
		{
			ms_controllerType = param1;
		}
		
		public function SetMenuAcceptCancelLayout(param1:int):void
		{
			ms_menuAcceptCancelLayout = param1;
		}
		
		public function SetActiveLocale(param1:String):void
		{
			ms_activeLocale = param1;
			trace("info | Locale | SetActiveLocale: " + param1);
		}
		
		public function SetDisplaySize(param1:int):void
		{
			if (ms_displaySize == param1)
			{
				return;
			}
			trace("info | SetDisplaySize: " + param1);
			ms_displaySize = param1;
		}
		
		public function SetMenuInputCapabilities(param1:int):void
		{
			ms_menuInputCapabilities = param1;
		}
		
		public function SetupLogTraceChannels(param1:Boolean, param2:Array):void
		{
			var _loc3_:String = null;
			trace("setTraceChannels: invert enabled channels: " + param1);
			ms_invertEnabledChannels = param1;
			ms_enabledChannels = new Dictionary();
			for each (_loc3_ in param2)
			{
				trace("setTraceChannels: " + (param1 ? "disabled" : "enabled") + " trace channel: " + _loc3_);
				ms_enabledChannels[_loc3_.toLowerCase()] = true;
			}
		}
	}
}
