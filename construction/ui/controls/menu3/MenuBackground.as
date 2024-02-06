package menu3
{
	import common.BaseControl;
	import common.menu.MenuConstants;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class MenuBackground extends BaseControl
	{
		
		private var m_ingameBackgroundContainer:Sprite;
		
		public function MenuBackground()
		{
			super();
		}
		
		public function drawIngameBackground():void
		{
			this.m_ingameBackgroundContainer = new Sprite();
			addChild(this.m_ingameBackgroundContainer);
			var _loc1_:Sprite = new Sprite();
			_loc1_.graphics.clear();
			_loc1_.graphics.beginFill(MenuConstants.COLOR_END_SCREEN_BACKGROUND, MenuConstants.MenuFrameEndScreenBackgroundAlpha);
			_loc1_.graphics.drawRect(0, 0, MenuConstants.BaseWidth, MenuConstants.BaseHeight);
			_loc1_.graphics.endFill();
			this.m_ingameBackgroundContainer.addChild(_loc1_);
		}
		
		public function showBokeh(param1:Rectangle, param2:int, param3:int, param4:Number, param5:Number):void
		{
		}
		
		public function showLensFlare(param1:Point, param2:Number, param3:Number, param4:Number):void
		{
		}
	}
}
