// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.map.MapReticleLegend

package menu3.map {
import common.BaseControl;
import common.menu.MenuConstants;
import common.menu.MenuUtils;
import common.CommonUtils;

import flash.text.TextFieldAutoSize;

public dynamic class MapReticleLegend extends BaseControl {

	private var m_view:MapReticleLegendView;

	public function MapReticleLegend() {
		this.m_view = new MapReticleLegendView();
		this.m_view.visible = false;
		addChild(this.m_view);
	}

	public function onSetData(_arg_1:Object):void {
		this.setupTextFields(_arg_1.header, _arg_1.title);
	}

	private function setupTextFields(_arg_1:String, _arg_2:String):void {
		if (((!(_arg_1 == null)) && (!(_arg_2 == null)))) {
			this.setHeadAndTitlesTexts(_arg_1, _arg_2, "");
			this.setBg((Math.max(this.m_view.header.width, this.m_view.title.width) + (MenuConstants.tileImageBorder * 3)), 50);
		} else {
			if (_arg_1 != null) {
				this.setHeadAndTitlesTexts("", "", _arg_1);
				this.setBg((this.m_view.singletitle.width + (MenuConstants.tileImageBorder * 3)), 30);
			} else {
				if (_arg_2 != null) {
					this.setHeadAndTitlesTexts("", "", _arg_2);
					this.setBg((this.m_view.singletitle.width + (MenuConstants.tileImageBorder * 3)), 30);
				}
				;
			}
			;
		}
		;
		this.m_view.visible = (!((_arg_1 == null) && (_arg_2 == null)));
	}

	private function setHeadAndTitlesTexts(_arg_1:String, _arg_2:String, _arg_3:String):void {
		MenuUtils.setupTextUpper(this.m_view.header, _arg_1, 18, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorGrey);
		MenuUtils.setupTextUpper(this.m_view.title, _arg_2, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		MenuUtils.setupTextUpper(this.m_view.singletitle, _arg_3, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		CommonUtils.changeFontToGlobalIfNeeded(this.m_view.header);
		CommonUtils.changeFontToGlobalIfNeeded(this.m_view.title);
		CommonUtils.changeFontToGlobalIfNeeded(this.m_view.singletitle);
		this.m_view.header.autoSize = TextFieldAutoSize.LEFT;
		this.m_view.title.autoSize = TextFieldAutoSize.LEFT;
		this.m_view.singletitle.autoSize = TextFieldAutoSize.LEFT;
	}

	private function setBg(_arg_1:Number, _arg_2:Number):void {
		MenuUtils.setColor(this.m_view.tileBg, MenuConstants.COLOR_MENU_TABS_BACKGROUND, true, MenuConstants.MenuElementBackgroundAlpha);
		this.m_view.tileBg.width = _arg_1;
		this.m_view.tileBg.height = _arg_2;
		this.m_view.tileBg.x = (this.m_view.tileBg.width >> 1);
	}


}
}//package menu3.map

