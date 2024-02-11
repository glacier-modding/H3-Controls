// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.WorldUIImage

package hud {
import common.BaseControl;

import flash.display.Bitmap;
import flash.events.Event;

import common.ImageLoaderCache;

import flash.display.BitmapData;

public class WorldUIImage extends BaseControl {

	private var m_loader:Bitmap;
	private var m_rid:String;
	private var m_isRegistered:Boolean = false;

	public function WorldUIImage() {
		this.m_loader = new Bitmap();
		addChild(this.m_loader);
		this.addEventListener(Event.REMOVED_FROM_STAGE, this.onRemoved);
		this.addEventListener(Event.ADDED_TO_STAGE, this.onAdded);
	}

	private function onAdded(_arg_1:Event):void {
		this.loadImage(this.m_rid);
	}

	private function onRemoved(_arg_1:Event):void {
		this.unloadImage();
	}

	public function loadImage(_arg_1:String):void {
		if (((this.m_isRegistered) && (this.m_rid == _arg_1))) {
			return;
		}

		this.unloadImage();
		this.m_rid = _arg_1;
		if (this.m_rid == null) {
			return;
		}

		var _local_2:ImageLoaderCache = ImageLoaderCache.getGlobalInstance();
		this.m_isRegistered = true;
		_local_2.registerLoadImage(this.m_rid, this.onSuccess, null);
	}

	private function unloadImage():void {
		var _local_1:ImageLoaderCache;
		if (this.m_isRegistered) {
			_local_1 = ImageLoaderCache.getGlobalInstance();
			_local_1.unregisterLoadImage(this.m_rid, this.onSuccess, null);
			this.m_isRegistered = false;
		}

		this.m_loader.bitmapData = null;
	}

	private function onSuccess(_arg_1:BitmapData):void {
		this.m_loader.bitmapData = _arg_1;
		this.applyCenter();
	}

	private function applyCenter():void {
		this.m_loader.x = (-(this.m_loader.width) / 2);
		this.m_loader.y = (-(this.m_loader.height) / 2);
	}

	public function onSetData(_arg_1:Object):void {
		var _local_2:String = (_arg_1 as String);
		if (_local_2) {
			this.loadImage(_local_2);
		}

	}


}
}//package hud

