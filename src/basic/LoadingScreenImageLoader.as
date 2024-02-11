// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//basic.LoadingScreenImageLoader

package basic {
import flash.display.Sprite;

import common.ImageLoader;
import common.menu.MenuUtils;

public class LoadingScreenImageLoader extends Sprite {

	private var m_imageLoader:ImageLoader = new ImageLoader();
	private var m_loadIndicator:LOTloadDialView = new LOTloadDialView();
	public var center:Boolean = true;

	public function LoadingScreenImageLoader() {
		this.m_imageLoader.alpha = 0;
		this.addChild(this.m_imageLoader);
		this.m_loadIndicator.alpha = 0;
		this.addChild(this.m_loadIndicator);
	}

	public function cancelIfLoading():void {
		if (this.m_imageLoader.isLoading()) {
			this.m_imageLoader.cancel();
		}

	}

	public function loadImage(rid:String, callback:Function = null, failedCallback:Function = null):void {
		if (!rid) {
			if (failedCallback != null) {
				(failedCallback());
			}

			return;
		}

		this.m_imageLoader.alpha = 0;
		this.m_loadIndicator.alpha = 1;
		this.m_loadIndicator.value.play();
		this.m_imageLoader.loadImage(rid, function ():void {
			if (center) {
				m_imageLoader.content.x = (-(m_imageLoader.content.width) / 2);
				m_imageLoader.content.y = (-(m_imageLoader.content.height) / 2);
			} else {
				m_imageLoader.content.x = 0;
				m_imageLoader.content.y = 0;
			}

			m_imageLoader.alpha = 1;
			m_loadIndicator.alpha = 0;
			m_loadIndicator.value.stop();
			if (callback != null) {
				callback();
			}

		}, function ():void {
			m_loadIndicator.value.stop();
			MenuUtils.setTintColor(m_loadIndicator, MenuUtils.TINT_COLOR_RED, true);
			if (failedCallback != null) {
				failedCallback();
			}

		});
	}


}
}//package basic

