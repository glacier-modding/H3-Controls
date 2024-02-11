// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.photomode.PhotoModeViewfinderScanner

package hud.photomode {
import common.BaseControl;
import common.Animate;

public class PhotoModeViewfinderScanner extends BaseControl {

	private var m_view:PhotoModeViewfinderScannerView;
	private var m_maxCount:Number = 10;
	private var m_previousScanVal:Number = 0;
	private var m_largeRingsIsPulsating:Boolean;
	private var m_isShown:Boolean;

	public function PhotoModeViewfinderScanner() {
		this.m_view = new PhotoModeViewfinderScannerView();
		this.pulsateLargeRings(false);
		this.m_view.scanner_mc.alpha = 0;
		this.m_view.visible = false;
		addChild(this.m_view);
	}

	public function setScanValue(_arg_1:Number):void {
		if (!this.m_isShown) {
			if (_arg_1 >= this.m_previousScanVal) {
				this.m_view.scanner_mc.alpha = 1;
				this.m_isShown = true;
			}
			;
		}
		;
		if (this.m_isShown) {
			this.goScanning(_arg_1);
			if (((_arg_1 == this.m_maxCount) || (_arg_1 <= this.m_previousScanVal))) {
				this.m_view.scanner_mc.alpha = 0;
				this.pulsateLargeRings(false);
				this.m_isShown = false;
			}
			;
		}
		;
		this.m_previousScanVal = _arg_1;
	}

	private function goScanning(_arg_1:Number):void {
		if (!this.m_largeRingsIsPulsating) {
			this.pulsateLargeRings(true);
		}
		;
		Animate.to(this.m_view.scanner_mc.large_rings_mc.inner_mc.dots_mc, 0.2, 0, {"frames": (_arg_1 * 10)}, Animate.Linear);
	}

	private function pulsateLargeRings(_arg_1:Boolean):void {
		Animate.kill(this.m_view.scanner_mc.large_rings_mc.outer_mc);
		Animate.kill(this.m_view.scanner_mc.large_rings_mc.inner_mc);
		Animate.kill(this.m_view.scanner_mc.large_rings_mc.inner_mc.dots_mc);
		this.m_view.scanner_mc.large_rings_mc.outer_mc.alpha = 0;
		this.m_view.scanner_mc.large_rings_mc.inner_mc.alpha = 0;
		this.m_largeRingsIsPulsating = _arg_1;
		if (_arg_1) {
			this.m_view.scanner_mc.large_rings_mc.outer_mc.scaleX = (this.m_view.scanner_mc.large_rings_mc.outer_mc.scaleY = 1.4);
			Animate.to(this.m_view.scanner_mc.large_rings_mc.outer_mc, 0.6, 0, {
				"scaleX": 1,
				"scaleY": 1,
				"alpha": 1
			}, Animate.ExpoOut, this.pulsateLargeRingsOut);
			Animate.to(this.m_view.scanner_mc.large_rings_mc.inner_mc, 0.4, 0.2, {"alpha": 1}, Animate.ExpoOut);
		}
		;
	}

	private function pulsateLargeRingsIn():void {
		Animate.to(this.m_view.scanner_mc.large_rings_mc.outer_mc, 0.6, 0, {"alpha": 0.7}, Animate.ExpoOut, this.pulsateLargeRingsOut);
	}

	private function pulsateLargeRingsOut():void {
		Animate.to(this.m_view.scanner_mc.large_rings_mc.outer_mc, 0.6, 0, {"alpha": 1}, Animate.ExpoOut, this.pulsateLargeRingsIn);
	}

	public function setViewFinderStyle(_arg_1:int):void {
		switch (_arg_1) {
			case PhotoModeWidget.VIEWFINDERSTYLE_NONE:
				this.m_view.scanner_mc.alpha = 0;
				this.pulsateLargeRings(false);
				this.m_isShown = false;
				this.m_view.visible = false;
				return;
			case PhotoModeWidget.VIEWFINDERSTYLE_SPYCAM:
				this.m_view.scanner_mc.alpha = 0;
				this.pulsateLargeRings(false);
				this.m_isShown = false;
				this.m_view.visible = false;
				return;
			default:
				this.m_view.visible = true;
		}
		;
	}


}
}//package hud.photomode

