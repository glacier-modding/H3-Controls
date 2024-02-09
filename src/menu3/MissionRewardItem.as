package menu3
{
	import common.Animate;
	import flash.display.MovieClip;
	
	public dynamic class MissionRewardItem extends MissionRewardItemView
	{
		
		private var m_loader:MenuImageLoader;
		
		public function MissionRewardItem()
		{
			super();
			this.alpha = 0;
			this.visible = false;
			tileDarkBg.alpha = 0;
		}
		
		public function animateIn(param1:*):void
		{
			this.visible = true;
			Animate.legacyTo(this, 0.2, {"alpha": 1}, Animate.ExpoOut);
			this.image.scaleX = this.image.scaleY = 0;
			Animate.legacyTo(this.image, 0.3, {"scaleX": 1, "scaleY": 1}, Animate.ExpoOut);
		}
		
		public function animateOut(param1:*):void
		{
			var val:* = param1;
			Animate.legacyTo(this, 0.2, {"alpha": 0}, Animate.ExpoOut, function(param1:MovieClip):void
			{
				param1.visible = false;
				param1.image.visible = false;
			}, this);
			Animate.legacyTo(this.image, 0.3, {"scaleX": 0, "scaleY": 0}, Animate.ExpoOut);
		}
		
		public function loadImage(param1:String, param2:Function = null, param3:Function = null):void
		{
			var imagePath:String = param1;
			var callback:Function = param2;
			var failedCallback:Function = param3;
			if (this.m_loader != null)
			{
				this.m_loader.cancelIfLoading();
				image.removeChild(this.m_loader);
				this.m_loader = null;
			}
			this.m_loader = new MenuImageLoader();
			this.m_loader.center = true;
			image.addChild(this.m_loader);
			this.m_loader.loadImage(imagePath, function():void
			{
				var _loc1_:int = imageMask.width;
				var _loc2_:int = imageMask.height;
				var _loc3_:Number = m_loader.width / m_loader.height;
				m_loader.width = _loc1_;
				m_loader.height = _loc1_ / _loc3_;
				if (m_loader.height < _loc2_)
				{
					m_loader.height = _loc2_;
					m_loader.width = _loc2_ * _loc3_;
				}
				if (callback != null)
				{
					callback();
				}
			}, failedCallback);
		}
	}
}
