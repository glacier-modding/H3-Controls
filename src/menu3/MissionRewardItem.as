// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.MissionRewardItem

package menu3 {
import common.Animate;

import flash.display.MovieClip;

public dynamic class MissionRewardItem extends MissionRewardItemView {

	private var m_loader:MenuImageLoader;

	public function MissionRewardItem() {
		this.alpha = 0;
		this.visible = false;
		tileDarkBg.alpha = 0;
	}

	public function animateIn(_arg_1:*):void {
		this.visible = true;
		Animate.legacyTo(this, 0.2, {"alpha": 1}, Animate.ExpoOut);
		this.image.scaleX = (this.image.scaleY = 0);
		Animate.legacyTo(this.image, 0.3, {
			"scaleX": 1,
			"scaleY": 1
		}, Animate.ExpoOut);
	}

	public function animateOut(val:*):void {
		Animate.legacyTo(this, 0.2, {"alpha": 0}, Animate.ExpoOut, function (_arg_1:MovieClip):void {
			_arg_1.visible = false;
			_arg_1.image.visible = false;
		}, this);
		Animate.legacyTo(this.image, 0.3, {
			"scaleX": 0,
			"scaleY": 0
		}, Animate.ExpoOut);
	}

	public function loadImage(imagePath:String, callback:Function = null, failedCallback:Function = null):void {
		if (this.m_loader != null) {
			this.m_loader.cancelIfLoading();
			image.removeChild(this.m_loader);
			this.m_loader = null;
		}
		;
		this.m_loader = new MenuImageLoader();
		this.m_loader.center = true;
		image.addChild(this.m_loader);
		this.m_loader.loadImage(imagePath, function ():void {
			var _local_1:int = imageMask.width;
			var _local_2:int = imageMask.height;
			var _local_3:Number = (m_loader.width / m_loader.height);
			m_loader.width = _local_1;
			m_loader.height = (_local_1 / _local_3);
			if (m_loader.height < _local_2) {
				m_loader.height = _local_2;
				m_loader.width = (_local_2 * _local_3);
			}
			;
			if (callback != null) {
				callback();
			}
			;
		}, failedCallback);
	}


}
}//package menu3

