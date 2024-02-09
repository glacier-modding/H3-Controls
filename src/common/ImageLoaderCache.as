package common
{
	
	public class ImageLoaderCache
	{
		
		private static var s_instance:ImageLoaderCache;
		
		private var m_imageRegister:Object;
		
		public function ImageLoaderCache()
		{
			this.m_imageRegister = new Object();
			super();
		}
		
		public static function getGlobalInstance():ImageLoaderCache
		{
			if (s_instance == null)
			{
				s_instance = new ImageLoaderCache();
			}
			return s_instance;
		}
		
		public function registerLoadImage(param1:String, param2:Function = null, param3:Function = null):void
		{
			var _loc4_:ImageLoader_internal;
			if ((_loc4_ = this.m_imageRegister[param1] as ImageLoader_internal) == null)
			{
				(_loc4_ = new ImageLoader_internal()).loadImage(param1);
				this.m_imageRegister[param1] = _loc4_;
			}
			++_loc4_.m_referenceCount;
			if (_loc4_.isLoading())
			{
				if (param2 != null)
				{
					_loc4_.m_successCallbacks.push(param2);
				}
				if (param3 != null)
				{
					_loc4_.m_failedCallbacks.push(param3);
				}
			}
			else if (_loc4_.m_failed)
			{
				if (param3 != null)
				{
					param3();
				}
			}
			else if (param2 != null)
			{
				param2(_loc4_.m_bitmapData);
			}
		}
		
		public function unregisterLoadImage(param1:String, param2:Function = null, param3:Function = null):void
		{
			var _loc5_:int = 0;
			var _loc6_:int = 0;
			var _loc4_:ImageLoader_internal;
			--(_loc4_ = this.m_imageRegister[param1] as ImageLoader_internal).m_referenceCount;
			if (_loc4_.m_referenceCount <= 0)
			{
				_loc4_.cancelAndClearImage();
				this.m_imageRegister[param1] = null;
				return;
			}
			if (_loc4_.isLoading())
			{
				if (param2 != null)
				{
					_loc5_ = _loc4_.m_successCallbacks.indexOf(param2);
					_loc4_.m_successCallbacks.splice(_loc5_, 1);
				}
				if (param3 != null)
				{
					_loc6_ = _loc4_.m_failedCallbacks.indexOf(param3);
					_loc4_.m_failedCallbacks.splice(_loc6_, 1);
				}
			}
		}
	}
}

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Loader;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.external.ExternalInterface;
import flash.net.URLRequest;

class ImageLoader_internal extends Loader
{
	
	public var m_referenceCount:int = 0;
	
	public var m_successCallbacks:Vector.<Function>;
	
	public var m_failedCallbacks:Vector.<Function>;
	
	private var m_isLoading:Boolean = false;
	
	public var m_failed:Boolean = false;
	
	public var m_bitmapData:BitmapData = null;
	
	private var m_rid:String;
	
	private var m_toLoadUrl:String = null;
	
	public function ImageLoader_internal()
	{
		this.m_successCallbacks = new Vector.<Function>();
		this.m_failedCallbacks = new Vector.<Function>();
		super();
	}
	
	public function isLoading():Boolean
	{
		return this.m_isLoading;
	}
	
	public function loadImage(param1:String):void
	{
		if (this.m_isLoading)
		{
			this.cancel();
		}
		this.ClearImage();
		this.m_failed = false;
		this.m_isLoading = true;
		this.triggerRequestAsyncLoad(param1);
	}
	
	private function callCallbacks():void
	{
		var _loc1_:Function = null;
		for each (_loc1_ in this.m_successCallbacks)
		{
			_loc1_(this.m_bitmapData);
		}
		this.m_successCallbacks.length = 0;
		this.m_failedCallbacks.length = 0;
	}
	
	private function callFailedCallbacks():void
	{
		var _loc1_:Function = null;
		for each (_loc1_ in this.m_failedCallbacks)
		{
			_loc1_();
		}
		this.m_successCallbacks.length = 0;
		this.m_failedCallbacks.length = 0;
	}
	
	private function triggerRequestAsyncLoad(param1:String):void
	{
		this.m_toLoadUrl = "img://" + param1;
		ExternalInterface.call("RequestAsyncLoad", this.m_toLoadUrl, this);
	}
	
	public function cancel():void
	{
		if (this.m_isLoading)
		{
			this.close();
			this.ClearImage();
			this.closeRequest();
			this.callFailedCallbacks();
		}
	}
	
	public function cancelAndClearImage():void
	{
		if (this.m_isLoading)
		{
			this.cancel();
		}
		else
		{
			this.ClearImage();
		}
	}
	
	public function onResourceReady(param1:String):void
	{
		if (this.m_toLoadUrl != param1)
		{
			return;
		}
		this.RegisterLoaderListeners();
		var _loc2_:URLRequest = new URLRequest(param1);
		this.load(_loc2_);
	}
	
	public function onResourceFailed(param1:String):void
	{
		if (this.m_toLoadUrl != param1)
		{
			return;
		}
		this.m_failed = true;
		this.closeRequest();
		this.callFailedCallbacks();
	}
	
	private function onLoadingComplete(param1:Event):void
	{
		var _loc3_:Bitmap = null;
		this.closeRequest();
		var _loc2_:DisplayObject = content;
		if (_loc2_ is Bitmap)
		{
			_loc3_ = _loc2_ as Bitmap;
			this.m_bitmapData = _loc3_.bitmapData;
		}
		this.callCallbacks();
	}
	
	private function onLoadFailed(param1:IOErrorEvent):void
	{
		this.m_failed = true;
		this.closeRequest();
		this.callFailedCallbacks();
	}
	
	private function closeRequest():void
	{
		this.m_rid = null;
		this.m_toLoadUrl = null;
		this.m_isLoading = false;
		this.m_bitmapData = null;
		ExternalInterface.call("CloseAsyncRequest", this);
		this.UnregisterLoaderListeners();
	}
	
	private function RegisterLoaderListeners():void
	{
		this.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onLoadingComplete);
		this.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onLoadFailed);
	}
	
	private function UnregisterLoaderListeners():void
	{
		this.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.onLoadingComplete);
		this.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.onLoadFailed);
	}
	
	private function ClearImage():void
	{
		this.m_bitmapData = null;
		this.unload();
	}
}
