package menu3
{
	import common.Animate;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.geom.Rectangle;
	
	public class PageIndicator extends PageIndicatorView
	{
		
		private var m_pageSize:int;
		
		private var m_stepSize:Number;
		
		public function PageIndicator(param1:int)
		{
			super();
			this.m_pageSize = param1;
			var _loc2_:Rectangle = new Rectangle(3, 1, 94, 754);
			indicator.scale9Grid = _loc2_;
			indicatorbg.scale9Grid = _loc2_;
			indicatorbg.width = this.m_pageSize;
			arrowL.alpha = 0.3;
			arrowR.alpha = 0.3;
			scrollnumL01.autoSize = "left";
			scrollnumL02.autoSize = "left";
			scrollnumR01.autoSize = "right";
			scrollnumR02.autoSize = "right";
		}
		
		public function setPageIndicator(param1:int):void
		{
			this.m_stepSize = this.m_pageSize / param1;
			indicator.width = this.m_stepSize;
		}
		
		public function updatePageIndicator(param1:int, param2:String, param3:String, param4:String):void
		{
			MenuUtils.setupText(scrollnumL01, param3 + " +", 14, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorGreyDark);
			MenuUtils.setupText(scrollnumL02, param3 + " +", 14, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorGreyDark);
			MenuUtils.setupText(scrollnumR01, "+ " + param4, 14, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorGreyDark);
			MenuUtils.setupText(scrollnumR02, "+ " + param4, 14, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorGreyDark);
			Animate.legacyTo(indicator, 0.3, {"x": this.m_stepSize * param1}, Animate.ExpoOut);
		}
	}
}
