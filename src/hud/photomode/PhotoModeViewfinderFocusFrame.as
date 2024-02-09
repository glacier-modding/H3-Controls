package hud.photomode
{
	import common.Animate;
	import common.BaseControl;
	
	public class PhotoModeViewfinderFocusFrame extends BaseControl
	{
		
		private var m_view:PhotoModeViewfinderFocusFrameView;
		
		private var m_maxCount:Number = 10;
		
		private var m_previousScanVal:Number = 0;
		
		private var m_isScanning:Boolean;
		
		private var m_isFocusingOnIntel:Boolean;
		
		private var m_frameFactor:int;
		
		private var m_pulseSpeed:Number = 0.3;
		
		private var m_previousZoomVal:Number = 1;
		
		private var m_alphaShifter:Boolean;
		
		public function PhotoModeViewfinderFocusFrame()
		{
			super();
			this.m_view = new PhotoModeViewfinderFocusFrameView();
			this.m_view.alpha = 0.4;
			this.m_view.viewfinder_mc.gotoAndStop(101);
			this.m_view.scanframe_outer_mc.frame_mc.gotoAndStop(0);
			this.m_view.visible = false;
			addChild(this.m_view);
		}
		
		public function setScanValue(param1:Number):void
		{
			if (!this.m_isScanning)
			{
				if (param1 >= this.m_previousScanVal)
				{
					Animate.kill(this);
					this.killAllAnims();
					this.m_isScanning = true;
					Animate.to(this.m_view, 0.4, 0, {"alpha": 0.7}, Animate.ExpoOut);
					this.pulsateOuterFrameOnScanning();
				}
			}
			if (this.m_isScanning)
			{
				this.m_frameFactor = param1 <= 5 ? 4 : 10;
				this.m_pulseSpeed = param1 <= 5 ? 0.3 : 0.1;
				Animate.to(this.m_view.viewfinder_mc, 0.2, 0, {"frames": 201 - param1 * this.m_frameFactor}, Animate.Linear);
				Animate.to(this.m_view.scanframe_outer_mc.frame_mc, 0.2, 0, {"frames": 201 - param1 * this.m_frameFactor}, Animate.Linear);
				if (param1 == this.m_maxCount || param1 <= this.m_previousScanVal)
				{
					this.m_isScanning = false;
					this.killAllAnims();
					Animate.to(this.m_view.viewfinder_mc, 0.2, 0, {"frames": 101}, Animate.ExpoOut);
					this.m_view.scanframe_outer_mc.frame_mc.gotoAndStop(0);
					Animate.to(this.m_view, 0.2, 0, {"alpha": 0.4}, Animate.ExpoOut);
				}
			}
			this.m_previousScanVal = param1;
		}
		
		private function pulsateOuterFrameOnScanning():void
		{
			this.m_view.scanframe_outer_mc.alpha = 0.7;
			this.m_view.scanframe_outer_mc.scaleX = this.m_view.scanframe_outer_mc.scaleY = 1;
			Animate.delay(this.m_view.scanframe_outer_mc, this.m_pulseSpeed, function():void
			{
				Animate.to(m_view.scanframe_outer_mc, m_pulseSpeed, 0, {"alpha": 0, "scaleX": 0.97, "scaleY": 0.95}, Animate.ExpoOut, pulsateOuterFrameOnScanning);
			});
		}
		
		private function pulsateOuterFrameOnWithinFocus():void
		{
			this.m_view.scanframe_outer_mc.alpha = 0;
			this.m_view.scanframe_outer_mc.scaleX = 0.97;
			this.m_view.scanframe_outer_mc.scaleY = 0.95;
			Animate.to(this.m_view.scanframe_outer_mc, 0.3, 0, {"alpha": 0.7, "scaleX": 1, "scaleY": 1}, Animate.ExpoOut, function():void
			{
				Animate.to(m_view.scanframe_outer_mc, 0.3, 0, {"alpha": 0}, Animate.ExpoOut, pulsateOuterFrameOnWithinFocus);
			});
		}
		
		private function pulsateViewFinderAlpha():void
		{
			this.m_view.viewfinder_mc.alpha = 1;
			Animate.to(this.m_view.viewfinder_mc, 0.6, 0, {"alpha": 0}, Animate.ExpoOut, this.pulsateViewFinderAlpha);
		}
		
		public function setZoomValue(param1:Number):void
		{
			if (this.m_isScanning || this.m_isFocusingOnIntel)
			{
				return;
			}
			Animate.kill(this.m_view.viewfinder_mc);
			Animate.kill(this.m_view.scanframe_outer_mc.frame_mc);
			this.m_view.scanframe_outer_mc.frame_mc.gotoAndStop(0);
			if (param1 < this.m_previousZoomVal)
			{
				Animate.fromTo(this.m_view.viewfinder_mc, 0.2, 0, {"frames": 1}, {"frames": 50}, Animate.Linear);
			}
			else if (param1 > this.m_previousZoomVal)
			{
				Animate.fromTo(this.m_view.viewfinder_mc, 0.2, 0, {"frames": 51}, {"frames": 100}, Animate.Linear);
			}
			this.m_previousZoomVal = param1;
		}
		
		public function setViewFinderStyle(param1:int):void
		{
			switch (param1)
			{
			case PhotoModeWidget.VIEWFINDERSTYLE_NONE: 
				this.killAllAnims();
				this.resetScanning();
				this.m_view.visible = false;
				this.m_view.alpha = 0.4;
				break;
			case PhotoModeWidget.VIEWFINDERSTYLE_CAMERAITEM: 
				this.m_view.visible = true;
				this.m_view.alpha = 0.4;
				break;
			case PhotoModeWidget.VIEWFINDERSTYLE_PHOTOOPP: 
				this.killAllAnims();
				this.resetScanning();
				this.m_view.visible = true;
				this.m_view.alpha = 0.2;
				break;
			case PhotoModeWidget.VIEWFINDERSTYLE_SPYCAM: 
				this.killAllAnims();
				this.resetScanning();
				this.m_view.visible = false;
				break;
			default: 
				this.m_view.visible = true;
				this.m_view.alpha = 0.4;
			}
		}
		
		private function resetScanning():void
		{
			this.m_view.viewfinder_mc.gotoAndStop(101);
			this.m_view.scanframe_outer_mc.frame_mc.gotoAndStop(0);
			this.m_isScanning = false;
			this.m_previousScanVal = 0;
		}
		
		public function setIntelWithinFocus(param1:Boolean):void
		{
			var val:Boolean = param1;
			Animate.kill(this);
			this.killAllAnims();
			if (val)
			{
				Animate.delay(this, 0.3, function():void
				{
					if (!m_isScanning)
					{
						Animate.to(m_view, 0.2, 0, {"alpha": 0.7}, Animate.ExpoOut);
						m_view.scanframe_outer_mc.frame_mc.gotoAndStop(101);
						pulsateViewFinderAlpha();
						pulsateOuterFrameOnWithinFocus();
						m_isFocusingOnIntel = true;
					}
				});
			}
			else
			{
				this.m_view.viewfinder_mc.alpha = 1;
				Animate.to(this.m_view, 0.2, 0, {"alpha": 0.4}, Animate.ExpoOut);
				this.m_view.scanframe_outer_mc.frame_mc.gotoAndStop(0);
				this.m_isFocusingOnIntel = false;
			}
		}
		
		private function killAllAnims():void
		{
			Animate.kill(this.m_view);
			Animate.kill(this.m_view.viewfinder_mc);
			Animate.kill(this.m_view.scanframe_outer_mc);
			Animate.kill(this.m_view.scanframe_outer_mc.frame_mc);
		}
	}
}
