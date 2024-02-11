// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.statistics.LocationImage

package menu3.statistics {
import flash.display.Sprite;

import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.Animate;

import flash.display.MovieClip;

public class LocationImage extends Sprite {

	private var m_view:LocationImageView;
	private var m_imageMask:Sprite;
	private var m_data:Object;
	private var m_totalCompletion:Boolean;

	public function LocationImage(_arg_1:Object):void {
		this.m_data = _arg_1;
		this.m_totalCompletion = (this.m_data.completionValue == 100);
		this.m_view = new LocationImageView();
		this.m_view.tileImages.gotoAndStop(this.m_data.tileImage);
		this.m_view.tileImagesBg.gotoAndStop(this.m_data.tileImage);
		MenuUtils.setColor(this.m_view.tileImages, MenuConstants.COLOR_WHITE);
		MenuUtils.setColor(this.m_view.tileImagesBg, MenuConstants.COLOR_MENU_SOLID_BACKGROUND);
		this.m_imageMask = new Sprite();
		this.m_imageMask.graphics.beginFill(0xFF0000);
		this.m_imageMask.graphics.drawRect(0, -(this.m_view.tileImages.height), this.m_view.tileImages.width, this.m_view.tileImages.height);
		this.m_imageMask.graphics.endFill();
		this.m_imageMask.scaleX = 0;
		this.m_view.tileImages.mask = this.m_imageMask;
		this.m_view.addChild(this.m_imageMask);
		addChild(this.m_view);
		if (!this.m_totalCompletion) {
			Animate.legacyFrom(this.m_view, 0.3, {"alpha": 0}, Animate.ExpoOut);
		}

		this.init();
	}

	private function init():void {
		var _local_1:Number = (this.m_data.completionValue / 100);
		var _local_2:Number = Math.min(0.6, Math.max(0.4, _local_1));
		if (!this.m_totalCompletion) {
			Animate.legacyTo(this.m_imageMask, 0.6, {"scaleX": (this.m_data.completionValue / 100)}, Animate.ExpoInOut);
		} else {
			this.m_imageMask.scaleX = 1;
		}

	}

	public function destroy():void {
		Animate.kill(this.m_view);
		Animate.kill(this.m_imageMask);
		while (this.m_view.numChildren > 0) {
			if ((this.m_view.getChildAt(0) is MovieClip)) {
				MovieClip(this.m_view.getChildAt(0)).gotoAndStop(1);
			}

			this.m_view.removeChild(this.m_view.getChildAt(0));
		}

		removeChild(this.m_view);
		this.m_view = null;
		this.m_imageMask = null;
	}


}
}//package menu3.statistics

