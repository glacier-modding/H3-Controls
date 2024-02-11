// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.indicator.FreeDlcIndicator

package menu3.indicator {
import common.menu.MenuUtils;
import common.menu.MenuConstants;

public class FreeDlcIndicator extends IndicatorBase {

	public function FreeDlcIndicator(_arg_1:String) {
		switch (_arg_1) {
			case "large":
				m_indicatorView = new NewIndicatorLargeView();
				break;
			default:
				m_indicatorView = new NewIndicatorSmallView();
		}

		MenuUtils.setColor(m_indicatorView.bg, MenuConstants.COLOR_MENU_TABS_BACKGROUND, true, MenuConstants.MenuElementBackgroundAlpha);
		MenuUtils.setColor(m_indicatorView.extraInfoBg, MenuConstants.COLOR_MENU_TABS_BACKGROUND, true, MenuConstants.MenuElementBackgroundAlpha);
		m_indicatorView.y = MenuConstants.NewIndicatorYOffset;
	}

	override public function onSetData(_arg_1:*, _arg_2:Object):void {
		var _local_6:String;
		if (((_arg_2.freedlc_header == null) || (_arg_2.freedlc_header.length == 0))) {
			return;
		}

		super.onSetData(_arg_1, _arg_2);
		var _local_3:String = _arg_2.freedlc_header;
		MenuUtils.setupText(m_indicatorView.titlelarge, _local_3, 38, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		MenuUtils.truncateTextfield(m_indicatorView.titlelarge, 1, MenuConstants.ColorString(MenuConstants.COLOR_WHITE));
		m_textTickerUtil.addTextTicker(m_indicatorView.titlelarge, _local_3, MenuConstants.ColorString(MenuConstants.COLOR_WHITE));
		var _local_4:* = "livetilenews";
		var _local_5:String = _local_4;
		if (_arg_2.freedlc_icon != undefined) {
			_local_5 = _arg_2.freedlc_icon;
		}

		MenuUtils.setupIcon(m_indicatorView.icon, _local_5, MenuConstants.COLOR_WHITE, true, false);
		m_indicatorView.bigIcon.visible = false;
		if (((!(_arg_2.freedlc_extrainfo == null)) && (_arg_2.freedlc_extrainfo.length > 0))) {
			_local_6 = _arg_2.freedlc_extrainfo;
			m_indicatorView.extraInfo.visible = true;
			m_indicatorView.extraInfoBg.visible = true;
			MenuUtils.setupText(m_indicatorView.extraInfo, _local_6, 18, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
			MenuUtils.truncateTextfield(m_indicatorView.extraInfo, 1);
			m_textTickerUtil.addTextTicker(m_indicatorView.extraInfo, _local_6);
		} else {
			m_indicatorView.extraInfo.visible = false;
			m_indicatorView.extraInfoBg.visible = false;
		}

	}


}
}//package menu3.indicator

