// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.ButtonTileXXSmall

package menu3.basic {
import menu3.ButtonTileBase;

import flash.display.Sprite;

public dynamic class ButtonTileXXSmall extends ButtonTileBase {

	public function ButtonTileXXSmall(_arg_1:Object) {
		super(_arg_1);
		m_view = new ButtonTileXXSmallView();
		m_view.tileSelect.alpha = 0;
		m_view.tileBg.alpha = 0;
		addChild((m_view as ButtonTileXXSmallView));
		initView();
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
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

			removeChild((m_view as ButtonTileXXSmallView));
			m_view = null;
		}

	}


}
}//package menu3.basic

