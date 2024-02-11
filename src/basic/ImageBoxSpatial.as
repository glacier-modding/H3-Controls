// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//basic.ImageBoxSpatial

package basic {
import common.BaseControl;

import flash.text.TextFormat;
import flash.display.Bitmap;
import flash.events.Event;

import common.ImageLoaderCache;

import flash.display.BitmapData;
import flash.utils.getQualifiedClassName;

public class ImageBoxSpatial extends BaseControl {

	private var m_txtFormat:TextFormat = new TextFormat();
	private var m_view:ImageBoxSpatialView;
	private var m_loader:Bitmap;
	private var m_center:Boolean;
	private var m_justification:int = 7;
	private var m_rid:String = null;
	private var m_isRegistered:Boolean = false;

	public function ImageBoxSpatial() {
		this.m_loader = new Bitmap();
		addChild(this.m_loader);
		this.m_view = new ImageBoxSpatialView();
		this.m_view.txt_info.height = (this.m_view.txt_info.height * 2);
		addChild(this.m_view);
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
		this.applyJustification();
	}

	private function applyCenter():void {
		if (this.m_center) {
			this.m_loader.x = (-(this.m_loader.width) / 2);
			this.m_loader.y = (-(this.m_loader.height) / 2);
		}

	}

	private function applyJustification():void {
		var _local_1:int = (this.m_justification % 3);
		var _local_2:int = int((this.m_justification / 3));
		if (_local_1 == 0) {
			this.m_txtFormat.align = "right";
			this.m_view.txt_info.x = (this.m_loader.x - this.m_view.txt_info.width);
		}

		if (_local_1 == 1) {
			this.m_txtFormat.align = "center";
			this.m_view.txt_info.x = ((this.m_loader.x + (this.m_loader.width / 2)) - (this.m_view.txt_info.width / 2));
		}

		if (_local_1 == 2) {
			this.m_txtFormat.align = "left";
			this.m_view.txt_info.x = (this.m_loader.x + this.m_loader.width);
		}

		if (_local_2 == 0) {
			this.m_view.txt_info.y = (this.m_loader.y - this.m_view.txt_info.textHeight);
		}

		if (_local_2 == 1) {
			this.m_view.txt_info.y = (-(this.m_view.txt_info.textHeight) / 2);
		}

		if (_local_2 == 2) {
			this.m_view.txt_info.y = (this.m_loader.y + this.m_loader.height);
		}

		this.m_view.txt_info.setTextFormat(this.m_txtFormat);
	}

	public function onSetData(_arg_1:Object):void {
		var _local_2:String;
		var _local_3:int;
		var _local_4:int;
		if (getQualifiedClassName(_arg_1) == "String") {
			_local_2 = (_arg_1 as String);
			if (_local_2) {
				this.loadImage(_local_2);
			}

		} else {
			if (_arg_1.id == "distance") {
				_local_3 = ((ControlsMain.getDisplaySize() == ControlsMain.DISPLAY_SIZE_SMALL) ? 24 : 12);
				this.m_txtFormat.size = _local_3;
				_local_4 = _arg_1.distance;
				this.m_view.txt_info.visible = ((_local_4 >= 0) ? true : false);
				this.m_view.txt_info.text = (_local_4.toString() + "m");
				this.m_view.txt_info.setTextFormat(this.m_txtFormat);
			}

		}

	}

	public function set CenterImage(_arg_1:Boolean):void {
		this.m_center = _arg_1;
		this.applyCenter();
		this.applyJustification();
	}

	public function set ScaleX(_arg_1:Number):void {
		this.scaleX = _arg_1;
	}

	public function set ScaleY(_arg_1:Number):void {
		this.scaleY = _arg_1;
	}

	public function set TextJustification(_arg_1:int):void {
		this.m_justification = _arg_1;
		this.applyJustification();
	}


}
}//package basic

