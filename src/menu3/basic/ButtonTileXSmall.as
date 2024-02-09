package menu3.basic
{
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.display.Sprite;
	import menu3.ButtonTileBase;
	
	public dynamic class ButtonTileXSmall extends ButtonTileBase
	{
		
		public function ButtonTileXSmall(param1:Object)
		{
			super(param1);
			m_view = new ButtonTileXSmallView();
			m_view.tileSelect.alpha = 0;
			m_view.tileBg.alpha = 0;
			addChild(m_view as ButtonTileXSmallView);
			initView();
		}
		
		override public function onSetData(param1:Object):void
		{
			super.onSetData(param1);
			if (param1.buttonnumber)
			{
				MenuUtils.setupText(m_view.buttonnumber, param1.buttonnumber, 50, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorGreyUltraDark);
			}
			setupTextFields(param1.header, param1.title);
			updateState();
		}
		
		override public function getView():Sprite
		{
			if (m_view == null)
			{
				return null;
			}
			return m_view.tileBg;
		}
		
		override public function onUnregister():void
		{
			if (m_view)
			{
				completeAnimations();
				if (m_textTicker)
				{
					m_textTicker.stopTextTicker(m_view.title, m_textObj.title);
					m_textTicker = null;
				}
				removeChild(m_view as ButtonTileXSmallView);
				m_view = null;
			}
		}
	}
}
