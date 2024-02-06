package hud.maptrackers
{
	import common.BaseControl;
	import flash.display.Sprite;
	
	public class BaseMapTracker extends BaseControl
	{
		
		protected var m_mainView:Sprite;
		
		public function BaseMapTracker()
		{
			super();
			this.m_mainView = null;
		}
		
		public function getBoundsView():Sprite
		{
			return this.m_mainView;
		}
		
		protected function setMainView(param1:Sprite):void
		{
			if (this.m_mainView == param1)
			{
				return;
			}
			if (this.m_mainView != null)
			{
				removeChild(this.m_mainView);
			}
			this.m_mainView = param1;
			if (this.m_mainView != null)
			{
				addChild(this.m_mainView);
			}
		}
		
		public function getTextForLegend():String
		{
			return "";
		}
	}
}
