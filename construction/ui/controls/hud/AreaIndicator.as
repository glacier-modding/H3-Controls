package hud
{
	import common.Animate;
	import common.BaseControl;
	
	public class AreaIndicator extends BaseControl
	{
		
		private var m_view:AreaIndicatorView;
		
		private var m_areaRadius:Number = 30;
		
		public function AreaIndicator()
		{
			super();
			this.m_view = new AreaIndicatorView();
			addChild(this.m_view);
		}
		
		public function setAreaSize(param1:Number, param2:Number = 0.2):void
		{
			this.m_areaRadius = param1;
			this.m_view.areaCircle.alpha = param2;
			this.m_view.areaCircle.width = this.m_view.areaCircle.height = this.m_areaRadius;
		}
		
		override public function onSetVisible(param1:Boolean):void
		{
			var value:Boolean = param1;
			Animate.kill(this.m_view);
			if (value)
			{
				this.m_view.visible = true;
				Animate.to(this.m_view, HudConstants.MinimapBlipFadeInFadeOutTime, 0, {"alpha": 1}, Animate.ExpoOut);
			}
			else
			{
				Animate.to(this.m_view, HudConstants.MinimapBlipFadeInFadeOutTime, 0, {"alpha": 0}, Animate.ExpoOut, function():void
				{
					m_view.visible = false;
				});
			}
		}
	}
}
