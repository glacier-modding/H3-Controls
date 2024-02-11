// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//basic.BootFlowBackdropImage

package basic {
import common.BaseControl;

import flash.display.BitmapData;
import flash.display.Sprite;

import menu3.MenuImageLoader;

import flash.display.Bitmap;

import common.Animate;
import common.menu.MenuUtils;
import common.menu.MenuConstants;

public class BootFlowBackdropImage extends BaseControl {

	private var m_scrollDuration:Number;
	private var m_scrollDist:Number;
	private var m_imageBitmapData:BitmapData;
	private var m_imageContainer:Sprite;
	private var m_loader:MenuImageLoader;

	public function BootFlowBackdropImage() {
		this.m_imageContainer = new Sprite();
		addChild(this.m_imageContainer);
	}

	public function onSetData(_arg_1:Object):void {
		this.loadImage((_arg_1 as String));
	}

	private function loadImage(rid:String):void {
		if (this.m_loader != null) {
			this.m_loader.cancelIfLoading();
			this.m_imageContainer.removeChild(this.m_loader);
			this.m_loader = null;
		}
		;
		this.m_loader = new MenuImageLoader();
		this.m_imageContainer.addChild(this.m_loader);
		this.m_loader.center = false;
		this.m_loader.loadImage(rid, function ():void {
			m_imageBitmapData = m_loader.getImageData();
			var _local_1:Bitmap = new Bitmap(m_imageBitmapData);
			var _local_2:Bitmap = new Bitmap(m_imageBitmapData);
			m_imageContainer.removeChild(m_loader);
			m_loader = null;
			m_imageContainer.addChild(_local_1);
			m_imageContainer.addChild(_local_2);
			_local_2.y = (m_imageBitmapData.height - 1);
			m_scrollDist = (m_imageContainer.height / 4);
			goAnim();
		});
	}

	private function goAnim():void {
		Animate.kill(this.m_imageContainer);
		Animate.fromTo(this.m_imageContainer, (this.m_scrollDuration / 2), 0, {"y": 0}, {"y": -(this.m_scrollDist)}, Animate.Linear, function ():void {
			Animate.fromTo(m_imageContainer, (m_scrollDuration / 2), 0, {"y": m_imageContainer.y}, {"y": -(m_scrollDist * 2)}, Animate.Linear, function ():void {
				goAnim();
			});
		});
	}

	override public function getContainer():Sprite {
		return (this.m_imageContainer);
	}

	override public function onSetSize(_arg_1:Number, _arg_2:Number):void {
		Animate.kill(this.m_imageContainer);
		MenuUtils.centerFill(this.m_imageContainer, MenuConstants.BaseWidth, MenuConstants.BaseHeight, _arg_1, _arg_2);
		this.goAnim();
	}

	public function set ScrollDuration(_arg_1:Number):void {
		this.m_scrollDuration = _arg_1;
	}


}
}//package basic

