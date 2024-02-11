// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//basic.ImageBox

package basic {
import common.BaseControl;

import flash.display.Bitmap;
import flash.events.Event;

import common.ImageLoaderCache;

import flash.display.BitmapData;

public class ImageBox extends BaseControl {

	private var m_loader:Bitmap;
	private var m_center:Boolean;
	private var m_rid:String;
	private var m_isVisible:Boolean;
	private var m_isRegistered:Boolean = false;

	public function ImageBox() {
		this.m_loader = new Bitmap();
		addChild(this.m_loader);
		this.m_isVisible = true;
		this.addEventListener(Event.REMOVED_FROM_STAGE, this.onRemoved);
		this.addEventListener(Event.ADDED_TO_STAGE, this.onAdded);
	}

	private function onAdded(_arg_1:Event):void {
		this.loadImage(this.m_rid);
	}

	private function onRemoved(_arg_1:Event):void {
		this.unloadImage();
	}

	override public function onSetVisible(_arg_1:Boolean):void {
		if (this.m_isVisible == _arg_1) {
			return;
		}

		this.m_isVisible = _arg_1;
		if (!_arg_1) {
			this.unloadImage();
		} else {
			this.loadImage(this.m_rid);
		}

	}

	public function loadImage(_arg_1:String):void {
		if (((this.m_isRegistered) && (this.m_rid == _arg_1))) {
			return;
		}

		this.unloadImage();
		this.m_rid = _arg_1;
		if (((!(this.m_isVisible)) || (this.m_rid == null))) {
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
		if (this.m_center) {
			this.m_loader.x = (-(this.m_loader.width) / 2);
			this.m_loader.y = (-(this.m_loader.height) / 2);
		}

	}

	public function onSetData(_arg_1:Object):void {
		var _local_2:String = (_arg_1 as String);
		if (_local_2 != null) {
			this.loadImage(_local_2);
		}

	}

	public function set CenterImage(_arg_1:Boolean):void {
		this.m_center = _arg_1;
		this.applyCenter();
	}

	public function set ScaleX(_arg_1:Number):void {
		this.scaleX = _arg_1;
	}

	public function set ScaleY(_arg_1:Number):void {
		this.scaleY = _arg_1;
	}


}
}//package basic

