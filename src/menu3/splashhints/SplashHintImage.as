// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.splashhints.SplashHintImage

package menu3.splashhints {
import flash.display.Sprite;

import menu3.MenuImageLoader;

import common.Animate;

public class SplashHintImage extends Sprite {

	private var m_imageContainer:Sprite;
	private var m_loader:MenuImageLoader;

	public function SplashHintImage() {
		this.m_imageContainer = new Sprite();
		this.m_imageContainer.alpha = 0;
		addChild(this.m_imageContainer);
	}

	public function loadImage(rid:String, onComplete:Function = null):void {
		if (this.m_loader != null) {
			this.m_loader.cancelIfLoading();
			this.m_imageContainer.removeChild(this.m_loader);
			this.m_loader = null;
		}
		;
		this.m_loader = new MenuImageLoader();
		this.m_imageContainer.addChildAt(this.m_loader, 0);
		this.m_loader.center = false;
		this.m_loader.loadImage(rid, function ():void {
			if (onComplete != null) {
				onComplete();
			}
			;
		});
	}

	public function show():void {
		Animate.fromTo(this.m_imageContainer, 0.2, 0, {"alpha": 0}, {"alpha": 1}, Animate.ExpoOut);
		Animate.addFromTo(this.m_imageContainer, 0.4, 0, {"x": 20}, {"x": 0}, Animate.ExpoOut);
	}

	public function hide():void {
	}

	override public function get width():Number {
		if (this.m_loader != null) {
			return (this.m_loader.getImage().width);
		}
		;
		return (super.width);
	}

	override public function get height():Number {
		if (this.m_loader != null) {
			return (this.m_loader.getImage().height);
		}
		;
		return (super.height);
	}


}
}//package menu3.splashhints

