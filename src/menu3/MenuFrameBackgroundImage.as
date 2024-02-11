// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.MenuFrameBackgroundImage

package menu3 {
import flash.display.Sprite;

import __AS3__.vec.Vector;

import common.Animate;

import flash.display.BitmapData;

import common.menu.MenuConstants;
import common.Log;

import flash.geom.Point;
import flash.geom.Rectangle;
import flash.display.Bitmap;

import common.menu.MenuUtils;

import __AS3__.vec.*;

public class MenuFrameBackgroundImage extends Sprite {

	private const MAX_FRAMES:int = 2;

	private var m_currentData:BackgroundImageData = new BackgroundImageData();
	private var m_overflow:Number = 0;
	private var m_imageLoaders:Vector.<MenuImageLoader> = new Vector.<MenuImageLoader>();
	private var m_bgImages:Vector.<BackgroundImage> = new Vector.<BackgroundImage>();
	private var m_currentBackgroundImageObj:Sprite;
	private var m_currentBackgroundInnerImageObj:Sprite;
	private var m_frameCount:int = 0;
	private var m_activeFrame:int = -1;
	private var m_imagesNeeded:int = 0;

	public function MenuFrameBackgroundImage() {
		this.m_imageLoaders.length = this.MAX_FRAMES;
	}

	public function onVisibleFadeIn(_arg_1:Number):void {
		if (this.m_bgImages.length > 0) {
			Animate.fromTo(this.m_bgImages[0].m_bitmap, _arg_1, 0, {"alpha": 0.95}, {"alpha": 1}, Animate.Linear);
		}

	}

	public function setBackgroundData(_arg_1:Object):void {
		var _local_2:BackgroundImageData = new BackgroundImageData();
		_local_2.setData(_arg_1);
		this.setBackgroundData_internal(_local_2);
	}

	public function setBackground(_arg_1:String, _arg_2:Boolean = true, _arg_3:int = 0, _arg_4:int = 0):void {
		var _local_5:BackgroundImageData = new BackgroundImageData();
		_local_5.setSimpleImage(_arg_1, _arg_2, _arg_3, _arg_4);
		this.setBackgroundData_internal(_local_5);
	}

	private function setBackgroundData_internal(_arg_1:BackgroundImageData):void {
		if (this.m_currentData.isEqual(_arg_1)) {
			if (this.m_bgImages.length > 0) {
				this.m_bgImages[0].m_bitmap.alpha = 0;
				this.m_bgImages[0].m_bitmap.alpha = 1;
			}

			return;
		}

		this.m_currentData = _arg_1;
		var _local_2:int;
		while (_local_2 < this.m_imageLoaders.length) {
			if (this.m_imageLoaders[_local_2] != null) {
				this.m_imageLoaders[_local_2].clearCallbacks();
				this.m_imageLoaders[_local_2].cancelIfLoading();
				this.m_imageLoaders[_local_2] = null;
			}

			_local_2++;
		}

		if (this.m_currentData.m_imgResourceIds.length == 0) {
			this.removeImages();
			return;
		}

		this.m_imageLoaders[0] = new MenuImageLoader();
		this.m_imageLoaders[0].center = false;
		this.m_imageLoaders[0].loadImage(this.m_currentData.m_imgResourceIds[0], this.loadMainImageSuccess, this.loadMainImageFailed);
	}

	private function loadMainImageSuccess():void {
		var _local_1:BitmapData = this.m_imageLoaders[0].getImageData();
		this.setNewMainImage(_local_1);
		this.m_imageLoaders[0] = null;
	}

	private function loadMainImageFailed():void {
		this.removeImages();
		this.m_activeFrame = -1;
		this.m_imageLoaders[0] = null;
	}

	private function setNewMainImage(bitmapData:BitmapData):void {
		var prevBgImage:BackgroundImage;
		var/*const*/ targetScale:Number = NaN;
		var newWidth:Number;
		var posX:Number;
		var newHeight:Number;
		var posY:Number;
		var/*const*/ blendInAnimationDuration:Number = NaN;
		var bgImage:BackgroundImage;
		for each (prevBgImage in this.m_bgImages) {
			Animate.kill(prevBgImage.m_root);
			Animate.to(prevBgImage.m_bitmap, MenuConstants.PageOpenTime, 0, {"alpha": 0}, Animate.ExpoInOut, function (_arg_1:BackgroundImage):void {
				_arg_1.setParent(null);
				_arg_1.onUnregister();
			}, prevBgImage);
		}

		this.m_bgImages.length = 0;
		this.createBackgroundImages(bitmapData);
		targetScale = 1.02;
		newWidth = (MenuConstants.BaseWidth * targetScale);
		posX = ((MenuConstants.BaseWidth - newWidth) / 2);
		newHeight = (MenuConstants.BaseHeight * targetScale);
		posY = ((MenuConstants.BaseHeight - newHeight) / 2);
		blendInAnimationDuration = 5;
		for each (bgImage in this.m_bgImages) {
			bgImage.setParent(this);
			bgImage.m_bitmap.alpha = 0;
			Animate.fromTo(bgImage.m_bitmap, MenuConstants.PageOpenTime, 0, {"alpha": 0}, {"alpha": bgImage.m_targetAlpha}, Animate.ExpoOut);
			if (((!(ControlsMain.isVrModeActive())) && (this.m_currentData.m_blendinMode == BackgroundImageData.BLENDIN_MODE_ZOOMOUT))) {
				Animate.fromTo(bgImage.m_root, blendInAnimationDuration, 0, {
					"scaleX": targetScale,
					"scaleY": targetScale,
					"x": posX,
					"y": posY
				}, {
					"scaleX": 1,
					"scaleY": 1,
					"x": 0,
					"y": 0
				}, Animate.ExpoOut);
			}

		}

		if (((this.m_bgImages.length > 0) && (this.m_currentData.m_imgResourceIds.length > 1))) {
			Log.xinfo(Log.ChannelDebug, "delay loadAdditionalFrames");
			Animate.delay(this.m_bgImages[0].m_root, blendInAnimationDuration, this.loadAdditionalFrames);
		}

	}

	private function removeImages():void {
		var _local_1:BackgroundImage;
		for each (_local_1 in this.m_bgImages) {
			Animate.kill(_local_1.m_root);
			Animate.kill(_local_1.m_bitmap);
			_local_1.setParent(null);
			_local_1.onUnregister();
		}

		this.m_bgImages.length = 0;
	}

	private function loadAdditionalFrames():void {
		Log.xinfo(Log.ChannelDebug, "loadAdditionalFrames");
		if (this.m_currentData.m_imgResourceIds.length <= 1) {
			return;
		}

		var _local_1:int = Math.min(this.m_imageLoaders.length, this.m_currentData.m_imgResourceIds.length);
		this.m_imagesNeeded = (_local_1 - 1);
		Log.xinfo(Log.ChannelDebug, ((("loadAdditionalFrames frameCount=" + _local_1) + " m_imagesNeeded=") + this.m_imagesNeeded));
		if (this.m_imagesNeeded <= 0) {
			return;
		}

		var _local_2:int = 1;
		while (_local_2 < _local_1) {
			this.m_imageLoaders[_local_2] = new MenuImageLoader();
			this.m_imageLoaders[_local_2].center = false;
			this.m_imageLoaders[_local_2].loadImage(this.m_currentData.m_imgResourceIds[_local_2], this.loadImageSuccess, this.loadImageFailed);
			_local_2++;
		}

	}

	private function loadImageSuccess():void {
		this.m_imagesNeeded--;
		Log.xinfo(Log.ChannelDebug, ("loadImageSuccess m_imagesNeeded=" + this.m_imagesNeeded));
		if (this.m_imagesNeeded <= 0) {
			this.prepareFrames();
		}

	}

	private function loadImageFailed():void {
		Log.xinfo(Log.ChannelDebug, "loadImageFailed");
	}

	private function prepareFrames():void {
		var _local_2:BitmapData;
		Log.xinfo(Log.ChannelDebug, "prepareFrames");
		this.m_frameCount = Math.min(this.m_imageLoaders.length, this.m_currentData.m_imgResourceIds.length);
		var _local_1:int = 1;
		while (_local_1 < this.m_frameCount) {
			_local_2 = this.m_imageLoaders[_local_1].getImageData();
			this.createBackgroundImages(_local_2);
			this.m_bgImages[_local_1].m_bitmap.alpha = 0;
			this.m_bgImages[_local_1].setParent(this);
			this.m_imageLoaders[_local_1] = null;
			_local_1++;
		}

		this.m_activeFrame = 0;
		this.triggerFrameAnimation();
	}

	private function triggerFrameAnimation():void {
		var _local_1:int;
		var _local_2:int;
		var _local_3:Number;
		var _local_4:Number;
		Log.xinfo(Log.ChannelDebug, "startFrameAnimation");
		if (this.m_currentData.m_frameMode == BackgroundImageData.FRAME_MODE_SLOWBLEND) {
			_local_1 = this.m_activeFrame;
			this.m_activeFrame = ((this.m_activeFrame + 1) % this.m_frameCount);
			_local_2 = 1;
			Animate.kill(this.m_bgImages[_local_2].m_bitmap);
			_local_3 = this.randomNumber(10, 20);
			_local_4 = this.randomNumber(2, 12);
			if (this.m_activeFrame == 1) {
				Animate.to(this.m_bgImages[_local_2].m_bitmap, _local_3, 0, {"alpha": 1}, Animate.ExpoOut);
				Animate.delay(this.m_bgImages[_local_2].m_bitmap, _local_4, this.triggerFrameAnimation);
			} else {
				if (this.m_activeFrame == 0) {
					Animate.to(this.m_bgImages[_local_2].m_bitmap, _local_3, 0, {"alpha": 0}, Animate.ExpoOut);
					Animate.delay(this.m_bgImages[_local_2].m_bitmap, _local_4, this.triggerFrameAnimation);
				}

			}

		}

	}

	private function randomNumber(_arg_1:Number, _arg_2:Number):Number {
		var _local_3:Number = Math.random();
		var _local_4:Number = (_arg_2 - _arg_1);
		return ((_local_3 * _local_4) + _arg_1);
	}

	private function createBackgroundImages(_arg_1:BitmapData):void {
		var _local_2:int = _arg_1.width;
		var _local_3:int = _arg_1.height;
		var _local_4:Point = new Point();
		var _local_5:Rectangle = new Rectangle(0, 0, _local_2, _local_3);
		var _local_6:Bitmap = new Bitmap(_arg_1);
		MenuUtils.trySetCacheAsBitmap(_local_6, true);
		var _local_7:Number = 1;
		var _local_8:BackgroundImage = new BackgroundImage(_local_6, _local_7);
		this.scaleAndSetPos(_local_8.m_image, _local_2, _local_3);
		this.m_bgImages.push(_local_8);
	}

	private function scaleAndSetPos(_arg_1:Sprite, _arg_2:Number, _arg_3:Number):void {
		var _local_4:Number = 1;
		if (this.m_currentData.m_scaleFull) {
			_local_4 = MenuUtils.getFillAspectScaleFull(_arg_2, _arg_3, (MenuConstants.BaseWidth + (2 * this.m_overflow)), (MenuConstants.BaseHeight + (2 * this.m_overflow)));
		} else {
			_local_4 = MenuUtils.getFillAspectScale(_arg_2, _arg_3, (MenuConstants.BaseWidth + (2 * this.m_overflow)), (MenuConstants.BaseHeight + (2 * this.m_overflow)));
		}

		_arg_1.scaleX = _local_4;
		_arg_1.scaleY = _local_4;
		var _local_5:Number = (_arg_2 * _local_4);
		var _local_6:Number = (_arg_3 * _local_4);
		var _local_7:Number = ((MenuConstants.BaseWidth - _local_5) / 2);
		var _local_8:Number = ((MenuConstants.BaseHeight - _local_6) / 2);
		_arg_1.x = (_local_7 + this.m_currentData.m_offsetX);
		_arg_1.y = (_local_8 + this.m_currentData.m_offsetY);
	}


}
}//package menu3

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.geom.Rectangle;

import common.menu.MenuConstants;

import flash.display.DisplayObjectContainer;

class BackgroundImageData {

	public static const BLENDIN_MODE_NONE:String = "none";
	public static const BLENDIN_MODE_ZOOMOUT:String = "zoomout";
	public static const BLENDIN_MODE_DEFAULT:String = BLENDIN_MODE_ZOOMOUT;//"zoomout"
	public static const FRAME_MODE_NONE:String = "none";
	public static const FRAME_MODE_SLOWBLEND:String = "slowblend";
	public static const FRAME_MODE_DEFAULT:String = FRAME_MODE_NONE;//"none"

	public var m_imgResourceIds:Array = [];
	public var m_scaleFull:Boolean = true;
	public var m_offsetX:int = 0;
	public var m_offsetY:int = 0;
	public var m_blendinMode:String = "zoomout";
	public var m_frameMode:String = "none";


	public function isEqual(_arg_1:BackgroundImageData):Boolean {
		if (((((!(this.m_imgResourceIds.length == _arg_1.m_imgResourceIds.length)) || (!(this.m_scaleFull == _arg_1.m_scaleFull))) || (!(this.m_offsetX == _arg_1.m_offsetX))) || (!(this.m_offsetY == _arg_1.m_offsetY)))) {
			return (false);
		}

		var _local_2:int;
		while (_local_2 < this.m_imgResourceIds.length) {
			if (this.m_imgResourceIds[_local_2] != _arg_1.m_imgResourceIds[_local_2]) {
				return (false);
			}

			_local_2++;
		}

		return (true);
	}

	public function setData(_arg_1:Object):void {
		this.m_imgResourceIds.length = 0;
		var _local_2:Array = _arg_1.frames;
		if (_local_2 != null) {
			this.m_imgResourceIds = _local_2;
		} else {
			if (_arg_1.image != null) {
				this.m_imgResourceIds.push(_arg_1.image);
			}

		}

		this.m_scaleFull = ((_arg_1.scaleFull != null) ? _arg_1.scaleFull : true);
		this.m_offsetX = ((_arg_1.m_offsetX != null) ? _arg_1.m_offsetX : 0);
		this.m_offsetY = ((_arg_1.m_offsetY != null) ? _arg_1.m_offsetY : 0);
		this.m_blendinMode = ((_arg_1.blendin != null) ? _arg_1.blendin : BLENDIN_MODE_DEFAULT);
		this.m_frameMode = ((_arg_1.framemode != null) ? _arg_1.framemode : FRAME_MODE_DEFAULT);
	}

	public function setSimpleImage(_arg_1:String, _arg_2:Boolean = true, _arg_3:int = 0, _arg_4:int = 0):void {
		this.m_imgResourceIds.length = 0;
		if (_arg_1.length > 0) {
			this.m_imgResourceIds.push(_arg_1);
		}

		this.m_scaleFull = _arg_2;
		this.m_offsetX = _arg_3;
		this.m_offsetY = _arg_4;
		this.m_blendinMode = BLENDIN_MODE_DEFAULT;
		this.m_frameMode = FRAME_MODE_NONE;
	}


}

class BackgroundImage {

	public var m_root:Sprite = new Sprite();
	public var m_image:Sprite = new Sprite();
	public var m_targetAlpha:Number;
	public var m_bitmap:Bitmap;

	public function BackgroundImage(_arg_1:Bitmap, _arg_2:Number) {
		this.m_root.scrollRect = new Rectangle(0, 0, MenuConstants.BaseWidth, MenuConstants.BaseHeight);
		this.m_bitmap = _arg_1;
		this.m_image.addChild(this.m_bitmap);
		this.m_targetAlpha = _arg_2;
		this.m_root.addChild(this.m_image);
	}

	public function onUnregister():void {
		this.m_image = null;
		this.m_bitmap = null;
	}

	public function setParent(_arg_1:DisplayObjectContainer):void {
		if (_arg_1 != null) {
			_arg_1.addChild(this.m_root);
		} else {
			if (this.m_root.parent != null) {
				_arg_1 = this.m_root.parent;
				_arg_1.removeChild(this.m_root);
			}

		}

	}


}


