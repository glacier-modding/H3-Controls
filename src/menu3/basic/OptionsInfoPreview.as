// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.OptionsInfoPreview

package menu3.basic {
import flash.display.Bitmap;
import flash.display.Sprite;

import __AS3__.vec.Vector;

import flash.events.Event;

import common.ImageLoaderCache;

import flash.display.DisplayObject;

import common.Animate;

import flash.display.BitmapData;
import flash.utils.setTimeout;

import __AS3__.vec.*;

public dynamic class OptionsInfoPreview extends OptionsInfo {

	public static const PX_PREVIEW_BACKGROUND_WIDTH:Number = 620;

	private var m_bitmap:Bitmap = new Bitmap();
	private var m_previewContentContainer:Sprite = new Sprite();
	private var m_ridCurrentImage:String;
	private var m_ridKeepAliveImages:Vector.<String>;
	private var m_isImmediateLoad:Boolean = false;

	public function OptionsInfoPreview(_arg_1:Object) {
		super(_arg_1);
		this.m_bitmap.name = "m_bitmap";
		m_view.addChild(this.m_bitmap);
		this.m_previewContentContainer.name = "m_previewContentContainer";
		m_view.addChild(this.m_previewContentContainer);
		addEventListener(Event.REMOVED_FROM_STAGE, this.onPreviewRemovedFromStage);
		this.onSetData(_arg_1);
	}

	public function getPreviewContentContainer():Sprite {
		return (this.m_previewContentContainer);
	}

	public function getPreviewBackgroundImage():Bitmap {
		return (this.m_bitmap);
	}

	override public function onSetData(_arg_1:Object):void {
		var _local_3:String;
		super.onSetData(_arg_1);
		this.m_bitmap.y = ((m_view.paragraph.y + m_view.paragraph.textHeight) + 35);
		this.m_previewContentContainer.y = this.m_bitmap.y;
		this.loadImage(_arg_1.backgroundImage);
		var _local_2:Vector.<String> = this.m_ridKeepAliveImages;
		if (_arg_1.keepAliveImages) {
			this.m_ridKeepAliveImages = new Vector.<String>();
			for each (_local_3 in _arg_1.keepAliveImages) {
				this.m_ridKeepAliveImages.push(_local_3);
				ImageLoaderCache.getGlobalInstance().registerLoadImage(_local_3);
			}

		} else {
			this.m_ridKeepAliveImages = null;
		}

		if (_local_2) {
			while (_local_2.length > 0) {
				ImageLoaderCache.getGlobalInstance().unregisterLoadImage(_local_2.pop());
			}

		}

	}

	private function loadImage(_arg_1:String):void {
		if (_arg_1 == this.m_ridCurrentImage) {
			return;
		}

		if (this.m_ridCurrentImage) {
			ImageLoaderCache.getGlobalInstance().unregisterLoadImage(this.m_ridCurrentImage, this.onImageLoadSucceeded);
		}

		this.m_previewContentContainer.visible = false;
		this.m_ridCurrentImage = _arg_1;
		if (this.m_ridCurrentImage) {
			this.onPreviewBackgroundImageLoading();
			this.m_isImmediateLoad = true;
			ImageLoaderCache.getGlobalInstance().registerLoadImage(this.m_ridCurrentImage, this.onImageLoadSucceeded);
			this.m_isImmediateLoad = false;
		} else {
			this.m_previewContentContainer.visible = true;
		}

	}

	private function onImageLoadSucceeded(_arg_1:BitmapData):void {
		var _local_2:DisplayObject;
		if (this.m_bitmap != null) {
			this.m_bitmap.bitmapData = _arg_1;
			this.m_bitmap.width = PX_PREVIEW_BACKGROUND_WIDTH;
			this.m_bitmap.scaleY = this.m_bitmap.scaleX;
			this.m_previewContentContainer.visible = true;
			if (!this.m_isImmediateLoad) {
				for each (_local_2 in [this.m_previewContentContainer, this.m_bitmap]) {
					_local_2.alpha = 0;
					Animate.to(_local_2, 0.25, 0, {"alpha": 1}, Animate.SineOut);
				}

			}

			this.onPreviewBackgroundImageLoaded();
		}

	}

	protected function onPreviewBackgroundImageLoading():void {
	}

	protected function onPreviewBackgroundImageLoaded():void {
	}

	protected function onPreviewRemovedFromStage():void {
		setTimeout(function ():void {
			loadImage(null);
			if (m_ridKeepAliveImages) {
				while (m_ridKeepAliveImages.length > 0) {
					ImageLoaderCache.getGlobalInstance().unregisterLoadImage(m_ridKeepAliveImages.pop());
				}

			}

		}, (1000 / 20));
	}


}
}//package menu3.basic

