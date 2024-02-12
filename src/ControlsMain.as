// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ControlsMain

package {
import flash.display.Sprite;
import flash.utils.Dictionary;

import scaleform.gfx.Extensions;

import flash.utils.getDefinitionByName;
import flash.display.Loader;
import flash.events.Event;
import flash.net.URLRequest;
import flash.system.LoaderContext;
import flash.system.ApplicationDomain;

import scaleform.gfx.*;

[SWF(frameRate="60", width="500", height="375")]
public class ControlsMain extends Sprite {

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
	private static var ms_displaySize:int = DISPLAY_SIZE_NORMAL;//0
	public static var ms_frameCount:int = -1;
	public static const MENUINPUTCAPABILITY_TEXTINPUT_VIA_PHYSICAL_KEYBOARD:int = (1 << 0);
	public static const MENUINPUTCAPABILITY_TEXTINPUT_VIA_VIRTUAL_KEYBOARD:int = (1 << 1);
	public static const MENUINPUTCAPABILITY_NAVIGATION_VIA_MOUSE:int = (1 << 2);
	public static const MENUINPUTCAPABILITY_NAVIGATION_VIA_PHYSICAL_KEYBOARD:int = (1 << 3);
	private static var ms_menuInputCapabilities:int = 0;

	public var OnLoadMovieDone:Function;
	private var m_loadedMovies:Dictionary;

	public function ControlsMain() {
		Extensions.enabled = true;
		Extensions.noInvisibleAdvance = true;
		this.m_loadedMovies = new Dictionary();
		this.SetupLogTraceChannels(true, ["mouse"]);
	}

	public static function isMouseActive():Boolean {
		return (ms_isMouseActive);
	}

	public static function setOnMouseActiveChangedCallback(_arg_1:Function):void {
		ms_onMouseActiveChanged = _arg_1;
	}

	public static function isVrModeActive():Boolean {
		return (ms_isVrModeActive);
	}

	public static function getControllerType():String {
		return (ms_controllerType);
	}

	public static function getMenuAcceptCancelLayout():int {
		return (ms_menuAcceptCancelLayout);
	}

	public static function getActiveLocale():String {
		return (ms_activeLocale);
	}

	public static function getDisplaySize():int {
		return (ms_displaySize);
	}

	public static function getMenuInputCapabilities():int {
		return (ms_menuInputCapabilities);
	}

	public static function isLogChannelEnabled(_arg_1:String):Boolean {
		if (ms_invertEnabledChannels) {
			if (!hasTraceChannels()) {
				return (false);
			}

			if ((_arg_1.toLowerCase() in ms_enabledChannels)) {
				return (false);
			}

		} else {
			if (((hasTraceChannels()) && (!(_arg_1.toLowerCase() in ms_enabledChannels)))) {
				return (false);
			}

		}

		return (true);
	}

	private static function hasTraceChannels():Boolean {
		var _local_1:*;
		for each (_local_1 in ms_enabledChannels) {
			return (true);
		}

		return (false);
	}

	public static function getFrameCount():int {
		return (ms_frameCount);
	}


	public function attachInstance(_arg_1:Sprite, _arg_2:String):Sprite {
		var _local_3:Class = (getDefinitionByName(_arg_2) as Class);
		var _local_4:Sprite = new (_local_3)();
		_arg_1.addChild(_local_4);
		return (_local_4);
	}

	public function setInstanceDepth(_arg_1:Sprite, _arg_2:Sprite, _arg_3:uint):void {
		_arg_3 = Math.max(Math.min(_arg_3, (_arg_1.numChildren - 1)), 0);
		if (_arg_3 >= 0) {
			_arg_1.setChildIndex(_arg_2, _arg_3);
		}

	}

	public function LoadMovie(swf:String, rid:String):void {
		var loader:Loader;
		loader = new Loader();
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function ():void {
			OnLoadMovieDone(rid, loader.content);
		});
		this.m_loadedMovies[swf] = loader;
		addChild(loader);
		var urlReq:URLRequest = new URLRequest(swf);
		var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain, null);
		loader.load(urlReq, loaderContext);
	}

	public function UnloadMovie(_arg_1:String):void {
		var _local_2:Loader = this.m_loadedMovies[_arg_1];
		if (_local_2 != null) {
			_local_2.unload();
			removeChild(_local_2);
			delete this.m_loadedMovies[_arg_1];
		}

	}

	public function SetMouseActive(_arg_1:Boolean):void {
		if (ms_isMouseActive == _arg_1) {
			return;
		}

		trace(("info | Mouse | SetMouseActive: " + _arg_1));
		ms_isMouseActive = _arg_1;
		if (ms_onMouseActiveChanged != null) {
			ms_onMouseActiveChanged(ms_isMouseActive);
		}

	}

	public function SetVrModeActive(_arg_1:Boolean):void {
		ms_isVrModeActive = _arg_1;
		trace(("info | Mouse | SetVrModeActive: " + _arg_1));
	}

	public function SetControllerType(_arg_1:String):void {
		ms_controllerType = _arg_1;
	}

	public function SetMenuAcceptCancelLayout(_arg_1:int):void {
		ms_menuAcceptCancelLayout = _arg_1;
	}

	public function SetActiveLocale(_arg_1:String):void {
		ms_activeLocale = _arg_1;
		trace(("info | Locale | SetActiveLocale: " + _arg_1));
	}

	public function SetDisplaySize(_arg_1:int):void {
		if (ms_displaySize == _arg_1) {
			return;
		}

		trace(("info | SetDisplaySize: " + _arg_1));
		ms_displaySize = _arg_1;
	}

	public function SetMenuInputCapabilities(_arg_1:int):void {
		ms_menuInputCapabilities = _arg_1;
	}

	public function SetupLogTraceChannels(_arg_1:Boolean, _arg_2:Array):void {
		var _local_3:String;
		trace(("setTraceChannels: invert enabled channels: " + _arg_1));
		ms_invertEnabledChannels = _arg_1;
		ms_enabledChannels = new Dictionary();
		for each (_local_3 in _arg_2) {
			trace(((("setTraceChannels: " + ((_arg_1) ? "disabled" : "enabled")) + " trace channel: ") + _local_3));
			ms_enabledChannels[_local_3.toLowerCase()] = true;
		}

	}


}
}//package 

