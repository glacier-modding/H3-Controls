// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.ButtonTileXSmall

package menu3.basic {
import menu3.ButtonTileBase;

import common.menu.MenuUtils;
import common.menu.MenuConstants;

import flash.display.Sprite;

public dynamic class ButtonTileXSmall extends ButtonTileBase {

	public function ButtonTileXSmall(_arg_1:Object) {
		super(_arg_1);
		m_view = new ButtonTileXSmallView();
		m_view.tileSelect.alpha = 0;
		m_view.tileBg.alpha = 0;
		addChild((m_view as ButtonTileXSmallView));
		initView();
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		if (_arg_1.buttonnumber) {
			MenuUtils.setupText(m_view.buttonnumber, _arg_1.buttonnumber, 50, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorGreyUltraDark);
		}

		setupTextFields(_arg_1.header, _arg_1.title);
		updateState();
	}

	override public function getView():Sprite {
		if (m_view == null) {
			return (null);
		}

		return (m_view.tileBg);
	}

	override public function onUnregister():void {
		if (m_view) {
			completeAnimations();
			if (m_textTicker) {
				m_textTicker.stopTextTicker(m_view.title, m_textObj.title);
				m_textTicker = null;
			}

			removeChild((m_view as ButtonTileXSmallView));
			m_view = null;
		}

	}


}
}//package menu3.basic

