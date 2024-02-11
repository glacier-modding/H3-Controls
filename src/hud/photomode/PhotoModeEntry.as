// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.photomode.PhotoModeEntry

package hud.photomode {
import common.BaseControl;
import common.menu.MenuUtils;
import common.menu.MenuConstants;

public class PhotoModeEntry extends BaseControl {

	public static const TYPE_TOGGLE:int = 1;
	public static const TYPE_SLIDER:int = 2;
	public static const TYPE_LIST:int = 3;

	private var m_view:PhotoModeEntryView;

	public function PhotoModeEntry() {
		this.m_view = new PhotoModeEntryView();
		MenuUtils.setupText(this.m_view.title_txt, "", 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_view.value_txt, "", 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		addChild(this.m_view);
	}

	public function onSetData(_arg_1:Object):void {
		if (_arg_1.bIsEnabled) {
			this.m_view.title_txt.alpha = 1;
			this.m_view.value_txt.alpha = 1;
			this.m_view.type_mc.alpha = 1;
		} else {
			this.m_view.title_txt.alpha = 0.3;
			this.m_view.value_txt.alpha = 0.3;
			this.m_view.type_mc.alpha = 0.3;
		}

		this.m_view.title_txt.text = _arg_1.sLabel.toUpperCase();
		this.m_view.value_txt.text = (("[" + _arg_1.sCurrentValue.toUpperCase()) + "]");
		switch (_arg_1.eType) {
			case TYPE_TOGGLE:
				this.m_view.type_mc.gotoAndStop("toggle");
				this.m_view.type_mc.toggle_mc.gotoAndStop(((_arg_1.bIsToggledOn) ? 2 : 1));
				break;
			case TYPE_SLIDER:
				this.m_view.type_mc.gotoAndStop("slider");
				this.m_view.type_mc.slide_mc.gotoAndStop(_arg_1.fSliderPerc);
				break;
			case TYPE_LIST:
				this.m_view.type_mc.gotoAndStop("list");
				break;
		}

		if (_arg_1.bIsHighlighted) {
			this.m_view.tileSelect.alpha = 1;
			MenuUtils.removeDropShadowFilter(this.m_view.title_txt);
			MenuUtils.removeDropShadowFilter(this.m_view.value_txt);
		} else {
			this.m_view.tileSelect.alpha = 0;
			MenuUtils.addDropShadowFilter(this.m_view.title_txt);
			MenuUtils.addDropShadowFilter(this.m_view.value_txt);
		}

	}


}
}//package hud.photomode

