package menu3.basic
{
	import flash.utils.setTimeout;
	import hud.WalkSpeedIcon;
	
	public dynamic class OptionsInfoWalkSpeedPreview extends OptionsInfoHoldTogglePreview
	{
		
		private var m_walkSpeedIcon:WalkSpeedIcon;
		
		public function OptionsInfoWalkSpeedPreview(param1:Object)
		{
			var _loc2_:Number = NaN;
			this.m_walkSpeedIcon = new WalkSpeedIcon();
			super(param1);
			_loc2_ = OptionsInfoPreview.PX_PREVIEW_BACKGROUND_WIDTH;
			var _loc3_:Number = _loc2_ / 1920 * 1080;
			this.m_walkSpeedIcon.name = "m_walkSpeedIcon";
			this.m_walkSpeedIcon.scaleX = 0.6;
			this.m_walkSpeedIcon.scaleY = 0.6;
			this.m_walkSpeedIcon.x = 30;
			this.m_walkSpeedIcon.y = _loc3_ - 25;
			getPreviewContentContainer().addChild(this.m_walkSpeedIcon);
			this.m_walkSpeedIcon.visible = param1.previewData.showWalkSpeedIcon;
		}
		
		override public function onSetData(param1:Object):void
		{
			super.onSetData(param1);
			this.m_walkSpeedIcon.visible = param1.previewData.showWalkSpeedIcon;
		}
		
		override protected function onPreviewSlideshowExitedFrameLabel(param1:String):void
		{
			var label:String = param1;
			super.onPreviewSlideshowExitedFrameLabel(label);
			setTimeout(function():void
			{
				var _loc1_:Object = null;
				switch (label)
				{
				case "running-start": 
					_loc1_ = {"isVisible": true, "speed": "run"};
					break;
				case "running-done": 
					_loc1_ = {"isVisible": false, "speed": "run"};
					break;
				case "slow-start": 
					_loc1_ = {"isVisible": true, "speed": "slow"};
					break;
				case "slow-done": 
					_loc1_ = {"isVisible": false, "speed": "slow"};
				}
				m_walkSpeedIcon.onSetData(_loc1_);
			}, 150);
		}
	}
}
