package hud.evergreen.misc
{
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class DottedLineAlt extends Sprite
	{
		
		private var m_txt:TextField;
		
		private var m_pxDotSize:Number;
		
		public function DottedLineAlt(param1:int)
		{
			this.m_txt = new TextField();
			super();
			this.m_pxDotSize = param1;
			MenuUtils.setupText(this.m_txt, ".", param1 * 15, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
			this.m_txt.autoSize = TextFieldAutoSize.LEFT;
			addChild(this.m_txt);
			this.m_txt.x = -4;
			this.m_txt.y = -param1 * 13.333333;
		}
		
		public function updateLineLength(param1:int):void
		{
			this.m_txt.text = ".";
			while (this.m_txt.textWidth < param1)
			{
				this.m_txt.appendText(" .");
			}
		}
		
		public function get dottedLineLength():Number
		{
			return this.m_txt.textWidth;
		}
		
		public function get dottedLineThickness():Number
		{
			return this.m_pxDotSize;
		}
	}
}
