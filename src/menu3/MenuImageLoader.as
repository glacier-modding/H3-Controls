// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.MenuImageLoader

package menu3 {
import flash.display.Sprite;

import common.ImageLoader;

import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.display.BitmapData;

import common.Animate;
import common.menu.MenuUtils;

public class MenuImageLoader extends Sprite implements IScreenVisibilityReceiver {

	private var m_rid:String = null;
	private var m_isLoaded:Boolean = false;
	private var m_imageLoader:ImageLoader;
	private var m_loadIndicator:loadDialView = new loadDialView();
	private var m_loadOnVisibleOnScreen:Boolean = false;
	private var m_callback:Function;
	private var m_failedCallback:Function;
	public var center:Boolean = true;

	public function MenuImageLoader(_arg_1:Boolean = false, _arg_2:Boolean = false) {
		this.m_loadOnVisibleOnScreen = _arg_2;
		this.m_imageLoader = new ImageLoader(_arg_1);
		this.m_imageLoader.alpha = 0;
		this.addChild(this.m_imageLoader);
		this.m_loadIndicator.alpha = 0;
		this.addChild(this.m_loadIndicator);
	}

	public function cancelIfLoading():void {
		if (this.m_imageLoader.isLoading()) {
			this.m_imageLoader.cancel();
			this.m_rid = null;
		}

	}

	public function getImage():Bitmap {
		var _local_2:Bitmap;
		var _local_1:DisplayObject = this.m_imageLoader.content;
		if ((_local_1 is Bitmap)) {
			return (_local_1 as Bitmap);
		}

		return (null);
	}

	public function getImageData():BitmapData {
		var _local_2:Bitmap;
		var _local_1:DisplayObject = this.m_imageLoader.content;
		if ((_local_1 is Bitmap)) {
			_local_2 = (_local_1 as Bitmap);
			return (_local_2.bitmapData);
		}

		return (null);
	}

	public function loadImage(_arg_1:String, _arg_2:Function = null, _arg_3:Function = null):void {
		if (!_arg_1) {
			if (_arg_3 != null) {
				(_arg_3());
			}

			return;
		}

		if (this.m_rid == _arg_1) {
			return;
		}

		this.m_imageLoader.alpha = 0;
		this.m_loadIndicator.alpha = 0;
		this.m_loadIndicator.value.play();
		Animate.legacyTo(this.m_loadIndicator, 0.3, {"alpha": 1}, Animate.Linear);
		this.m_callback = _arg_2;
		this.m_failedCallback = _arg_3;
		this.m_imageLoader.cancelAndClearImage();
		this.m_isLoaded = false;
		this.m_rid = _arg_1;
		if (!this.m_loadOnVisibleOnScreen) {
			this.triggerLoadImage();
		}

	}

	private function triggerLoadImage():void {
		if (((!(this.m_isLoaded)) && (!(this.m_rid == null)))) {
			this.m_imageLoader.loadImage(this.m_rid, this.onSuccess, this.onFailed);
		}

	}

	private function unloadImage():void {
		if (this.m_isLoaded) {
			this.m_imageLoader.cancelAndClearImage();
			this.m_isLoaded = false;
		}

	}

	private function onSuccess():void {
		this.m_isLoaded = true;
		if (this.center) {
			this.m_imageLoader.content.x = (-(this.m_imageLoader.content.width) / 2);
			this.m_imageLoader.content.y = (-(this.m_imageLoader.content.height) / 2);
		} else {
			this.m_imageLoader.content.x = 0;
			this.m_imageLoader.content.y = 0;
		}

		Animate.legacyTo(this.m_imageLoader, 0.3, {"alpha": 1}, Animate.Linear);
		Animate.legacyTo(this.m_loadIndicator, 0.3, {"alpha": 0}, Animate.Linear);
		this.m_loadIndicator.value.stop();
		if (this.m_callback != null) {
			this.m_callback();
		}

	}

	private function onFailed():void {
		this.m_loadIndicator.value.stop();
		MenuUtils.setTintColor(this.m_loadIndicator, MenuUtils.TINT_COLOR_RED, true);
		if (this.m_failedCallback != null) {
			this.m_failedCallback();
		}

	}

	public function clearCallbacks():void {
		this.m_callback = null;
		this.m_failedCallback = null;
	}

	public function setVisibleOnScreen(_arg_1:Boolean):void {
		if (!this.m_loadOnVisibleOnScreen) {
			return;
		}

		if (_arg_1) {
			this.triggerLoadImage();
		} else {
			this.unloadImage();
		}

	}


}
}//package menu3

