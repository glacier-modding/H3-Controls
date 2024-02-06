package hud.evergreen
{
	import common.BaseControl;
	import common.Localization;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class SupplierPriceWidget extends BaseControl
	{
		
		private const m_lstrMercesSymbol:String = "<font size=\"24\">" + Localization.get("UI_EVERGREEN_MERCES") + "</font>";
		
		private var m_txtWhite:TextField;
		
		private var m_txtShadow:TextField;
		
		private var m_fScaleBase:Number = 1;
		
		public function SupplierPriceWidget()
		{
			this.m_txtWhite = new TextField();
			this.m_txtShadow = new TextField();
			super();
			this.m_txtWhite.name = "m_txtWhite";
			this.m_txtShadow.name = "m_txtShadow";
			addChild(this.m_txtShadow);
			addChild(this.m_txtWhite);
			this.m_txtShadow.y = 3;
			MenuUtils.setupText(this.m_txtWhite, "", 32, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			MenuUtils.setupText(this.m_txtShadow, "", 32, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorBlack);
			this.m_txtShadow.alpha = 0.5;
			this.m_txtWhite.autoSize = TextFieldAutoSize.LEFT;
		}
		
		override public function onSetViewport(param1:Number, param2:Number, param3:Number):void
		{
			this.m_fScaleBase = Math.min(param1, param2);
		}
		
		public function onSetData(param1:Object):void
		{
			var _loc2_:Boolean = Boolean(param1.isAffordable);
			var _loc3_:String = MenuUtils.formatNumber(Number(param1.merces) || 0, false) + " " + this.m_lstrMercesSymbol;
			MenuUtils.setupText(this.m_txtWhite, _loc3_, 32, MenuConstants.FONT_TYPE_MEDIUM, _loc2_ ? MenuConstants.FontColorWhite : MenuConstants.FontColorRed);
			MenuUtils.setupText(this.m_txtShadow, _loc3_, 32, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorBlack);
			this.m_txtWhite.x = this.m_txtShadow.x = -this.m_txtWhite.width / 2;
		}
	}
}
