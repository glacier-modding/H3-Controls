// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.PageBanner

package menu3.basic {
import menu3.MenuElementBase;

import flash.text.TextFormat;

import common.menu.MenuUtils;
import common.menu.MenuConstants;

public dynamic class PageBanner extends MenuElementBase {

	private var m_view:PageBannerView;
	private var m_originalTitlePosY:Number;
	private var m_originalTitleFormat:TextFormat;

	public function PageBanner(_arg_1:Object) {
		super(_arg_1);
		this.m_view = new PageBannerView();
		addChild(this.m_view);
		this.m_originalTitlePosY = this.m_view.title.y;
		this.m_originalTitleFormat = this.m_view.title.getTextFormat();
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		this.m_view.title.setTextFormat(this.m_originalTitleFormat);
		MenuUtils.setupText(this.m_view.title, _arg_1.title, 48, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
		var _local_2:Number = this.m_view.title.textHeight;
		MenuUtils.shrinkTextToFit(this.m_view.title, MenuConstants.MenuWidth, _local_2);
		var _local_3:Number = (_local_2 - this.m_view.title.textHeight);
		this.m_view.title.y = (this.m_originalTitlePosY + (_local_3 / 2));
	}


}
}//package menu3.basic

