package hud.photomode
{
	import common.Animate;
	import common.BaseControl;
	
	public class PhotoModeViewfinderScanner extends BaseControl
	{
		
		private var m_view:PhotoModeViewfinderScannerView;
		
		private var m_maxCount:Number = 10;
		
		private var m_previousScanVal:Number = 0;
		
		private var m_largeRingsIsPulsating:Boolean;
		
		private var m_isShown:Boolean;
		
		public function PhotoModeViewfinderScanner()
		{
			super();
			this.m_view = new PhotoModeViewfinderScannerView();
			this.pulsateLargeRings(false);
			this.m_view.scanner_mc.alpha = 0;
			this.m_view.visible = false;
			addChild(this.m_view);
		}
		
		public function setScanValue(param1:Number):void
		{
			if (!this.m_isShown)
			{
				if (param1 >= this.m_previousScanVal)
				{
					this.m_view.scanner_mc.alpha = 1;
					this.m_isShown = true;
				}
			}
			if (this.m_isShown)
			{
				this.goScanning(param1);
				if (param1 == this.m_maxCount || param1 <= this.m_previousScanVal)
				{
					this.m_view.scanner_mc.alpha = 0;
					this.pulsateLargeRings(false);
					this.m_isShown = false;
				}
			}
			this.m_previousScanVal = param1;
		}
		
		private function goScanning(param1:Number):void
		{
			if (!this.m_largeRingsIsPulsating)
			{
				this.pulsateLargeRings(true);
			}
			Animate.to(this.m_view.scanner_mc.large_rings_mc.inner_mc.dots_mc, 0.2, 0, {"frames": param1 * 10}, Animate.Linear);
		}
		
		private function pulsateLargeRings(param1:Boolean):void
		{
			Animate.kill(this.m_view.scanner_mc.large_rings_mc.outer_mc);
			Animate.kill(this.m_view.scanner_mc.large_rings_mc.inner_mc);
			Animate.kill(this.m_view.scanner_mc.large_rings_mc.inner_mc.dots_mc);
			this.m_view.scanner_mc.large_rings_mc.outer_mc.alpha = 0;
			this.m_view.scanner_mc.large_rings_mc.inner_mc.alpha = 0;
			this.m_largeRingsIsPulsating = param1;
			if (param1)
			{
				this.m_view.scanner_mc.large_rings_mc.outer_mc.scaleX = this.m_view.scanner_mc.large_rings_mc.outer_mc.scaleY = 1.4;
				Animate.to(this.m_view.scanner_mc.large_rings_mc.outer_mc, 0.6, 0, {"scaleX": 1, "scaleY": 1, "alpha": 1}, Animate.ExpoOut, this.pulsateLargeRingsOut);
				Animate.to(this.m_view.scanner_mc.large_rings_mc.inner_mc, 0.4, 0.2, {"alpha": 1}, Animate.ExpoOut);
			}
		}
		
		private function pulsateLargeRingsIn():void
		{
			Animate.to(this.m_view.scanner_mc.large_rings_mc.outer_mc, 0.6, 0, {"alpha": 0.7}, Animate.ExpoOut, this.pulsateLargeRingsOut);
		}
		
		private function pulsateLargeRingsOut():void
		{
			Animate.to(this.m_view.scanner_mc.large_rings_mc.outer_mc, 0.6, 0, {"alpha": 1}, Animate.ExpoOut, this.pulsateLargeRingsIn);
		}
		
		public function setViewFinderStyle(param1:int):void
		{
			switch (param1)
			{
			case PhotoModeWidget.VIEWFINDERSTYLE_NONE: 
				this.m_view.scanner_mc.alpha = 0;
				this.pulsateLargeRings(false);
				this.m_isShown = false;
				this.m_view.visible = false;
				break;
			case PhotoModeWidget.VIEWFINDERSTYLE_SPYCAM: 
				this.m_view.scanner_mc.alpha = 0;
				this.pulsateLargeRings(false);
				this.m_isShown = false;
				this.m_view.visible = false;
				break;
			default: 
				this.m_view.visible = true;
			}
		}
	}
}
