// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.evergreen.SupplierPriceWidget

package hud.evergreen {
import common.BaseControl;
import common.Localization;

import flash.text.TextField;

import common.menu.MenuUtils;
import common.menu.MenuConstants;

import flash.text.TextFieldAutoSize;

public class SupplierPriceWidget extends BaseControl {

	private const m_lstrMercesSymbol:String = (('<font size="24">' + Localization.get("UI_EVERGREEN_MERCES")) + "</font>");

	private var m_txtWhite:TextField = new TextField();
	private var m_txtShadow:TextField = new TextField();
	private var m_fScaleBase:Number = 1;

	public function SupplierPriceWidget() {
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

	override public function onSetViewport(_arg_1:Number, _arg_2:Number, _arg_3:Number):void {
		this.m_fScaleBase = Math.min(_arg_1, _arg_2);
	}

	public function onSetData(_arg_1:Object):void {
		var _local_2:Boolean = _arg_1.isAffordable;
		var _local_3:String = ((MenuUtils.formatNumber(((_arg_1.merces) || (0)), false) + " ") + this.m_lstrMercesSymbol);
		MenuUtils.setupText(this.m_txtWhite, _local_3, 32, MenuConstants.FONT_TYPE_MEDIUM, ((_local_2) ? MenuConstants.FontColorWhite : MenuConstants.FontColorRed));
		MenuUtils.setupText(this.m_txtShadow, _local_3, 32, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorBlack);
		this.m_txtWhite.x = (this.m_txtShadow.x = (-(this.m_txtWhite.width) / 2));
	}


}
}//package hud.evergreen

