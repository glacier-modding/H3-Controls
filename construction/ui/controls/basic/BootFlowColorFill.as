package basic
{
	import common.BaseControl;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.display.Sprite;
	
	public class BootFlowColorFill extends BaseControl
	{
		
		private var m_backdrop:Sprite;
		
		private var m_fillColor:int = 0;
		
		private var m_enableMultiply:Boolean;
		
		public function BootFlowColorFill()
		{
			super();
			this.m_backdrop = new Sprite();
			this.m_backdrop.alpha = 1;
			this.m_backdrop.graphics.clear();
			this.m_backdrop.graphics.beginFill(this.m_fillColor, 1);
			this.m_backdrop.graphics.drawRect(0, 0, MenuConstants.BaseWidth, MenuConstants.BaseHeight);
			this.m_backdrop.graphics.endFill();
			if (this.m_enableMultiply)
			{
				this.m_backdrop.blendMode = "multiply";
			}
			addChild(this.m_backdrop);
		}
		
		private function drawFillShape():void
		{
			this.m_backdrop.graphics.clear();
			this.m_backdrop.graphics.beginFill(this.m_fillColor, 1);
			this.m_backdrop.graphics.drawRect(0, 0, MenuConstants.BaseWidth, MenuConstants.BaseHeight);
			this.m_backdrop.graphics.endFill();
			if (this.m_enableMultiply)
			{
				this.m_backdrop.blendMode = "multiply";
			}
		}
		
		override public function getContainer():Sprite
		{
			return this.m_backdrop;
		}
		
		override public function onSetSize(param1:Number, param2:Number):void
		{
			MenuUtils.centerFill(this.m_backdrop, MenuConstants.BaseWidth, MenuConstants.BaseHeight, param1, param2);
		}
		
		public function set fillColor(param1:String):void
		{
			this.m_fillColor = int(param1);
			this.drawFillShape();
		}
		
		public function set BlendModeMultiply(param1:Boolean):void
		{
			this.m_enableMultiply = param1;
			this.drawFillShape();
		}
	}
}
