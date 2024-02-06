package basic
{
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class InfoBoxWithBackground extends Sprite
	{
		
		private const HEIGHT:int = 94;
		
		private const POS_X:int = 85;
		
		private const POS_TITLE_Y:int = 10;
		
		private const POS_DESCRIPTION_Y:int = 51;
		
		private var m_title:TextField;
		
		private var m_description:TextField;
		
		private var m_background:Sprite;
		
		public function InfoBoxWithBackground()
		{
			super();
			this.m_background = new Sprite();
			addChild(this.m_background);
			this.m_background.graphics.clear();
			this.m_background.graphics.beginFill(16777215, 1);
			this.m_background.graphics.drawRect(0, 0, MenuConstants.BaseWidth, this.HEIGHT);
			this.m_background.graphics.endFill();
			this.m_background.visible = false;
			this.m_title = new TextField();
			this.m_title.x = this.POS_X;
			this.m_title.y = this.POS_TITLE_Y;
			this.m_title.width = MenuConstants.BaseWidth - 2 * this.POS_X;
			this.m_title.height = this.POS_DESCRIPTION_Y - this.POS_TITLE_Y;
			addChild(this.m_title);
			this.m_description = new TextField();
			this.m_description.x = this.POS_X;
			this.m_description.y = this.POS_DESCRIPTION_Y;
			this.m_description.width = MenuConstants.BaseWidth - 2 * this.POS_X;
			this.m_description.height = this.HEIGHT - this.POS_DESCRIPTION_Y;
			addChild(this.m_description);
		}
		
		public function onSetData(param1:Object):void
		{
			var _loc2_:String = param1.title != undefined ? String(param1.title) : "";
			var _loc3_:String = param1.description != undefined ? String(param1.description) : "";
			var _loc4_:* = param1.isWarning === true;
			this.m_background.visible = _loc2_.length != 0 || _loc3_.length != 0;
			var _loc5_:String = _loc4_ ? MenuConstants.FontColorGreyUltraLight : MenuConstants.FontColorBlack;
			var _loc6_:int = _loc4_ ? MenuUtils.TINT_COLOR_LIGHT_RED : MenuUtils.TINT_COLOR_WHITE;
			MenuUtils.setupText(this.m_title, _loc2_, 36, MenuConstants.FONT_TYPE_MEDIUM, _loc5_);
			MenuUtils.setupText(this.m_description, _loc3_, 24, MenuConstants.FONT_TYPE_MEDIUM, _loc5_);
			MenuUtils.shrinkTextToFit(this.m_description, this.m_description.width, this.m_description.height);
			MenuUtils.setTintColor(this.m_background, _loc6_);
		}
	}
}
