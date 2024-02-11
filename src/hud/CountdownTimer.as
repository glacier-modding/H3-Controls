// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.CountdownTimer

package hud {
import common.BaseControl;
import common.CommonUtils;
import common.menu.MenuUtils;
import common.Localization;
import common.menu.MenuConstants;

public class CountdownTimer extends BaseControl {

	private var m_view:timeDisplayView;
	private var startDial:Number;
	private var m_textLocaleYOffset:int;
	private var m_timeTextFontSize:int;

	public function CountdownTimer() {
		this.m_view = new timeDisplayView();
		addChild(this.m_view);
		this.m_view.y = -31;
		this.m_view.visible = false;
		this.m_textLocaleYOffset = 6;
		this.m_timeTextFontSize = 60;
		if ((((CommonUtils.getActiveTextLocaleIndex() == 10) || (CommonUtils.getActiveTextLocaleIndex() == 11)) || (CommonUtils.getActiveTextLocaleIndex() == 12))) {
			this.m_textLocaleYOffset = 13;
			this.m_timeTextFontSize = 52;
		}

		MenuUtils.setupText(this.m_view.header_txt, Localization.get("UI_BRIEFING_DIAL_TIME"), 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
	}

	public function onSetData(_arg_1:Object):void {
		var _local_2:String = (_arg_1.time as String);
		var _local_3:String = (_arg_1.string as String);
		var _local_4:Number = (_arg_1.dial as Number);
		this.showCountDown(_local_2, _local_3, _local_4);
	}

	public function showCountDown(_arg_1:String, _arg_2:String, _arg_3:Number):void {
		this.m_view.time_txt.y = this.m_textLocaleYOffset;
		MenuUtils.setupText(this.m_view.time_txt, _arg_1, this.m_timeTextFontSize, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
		if (_arg_2) {
			MenuUtils.setupText(this.m_view.header_txt, _arg_2, 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
		} else {
			MenuUtils.setupText(this.m_view.header_txt, Localization.get("UI_BRIEFING_DIAL_TIME"), 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
		}

		this.m_view.visible = true;
	}

	public function updateCountDown(_arg_1:String, _arg_2:String, _arg_3:Number, _arg_4:Number):void {
		this.m_view.time_txt.y = this.m_textLocaleYOffset;
		MenuUtils.setupText(this.m_view.time_txt, _arg_1, this.m_timeTextFontSize, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
	}

	public function hideCountDown():void {
	}

	public function SetText(_arg_1:String):void {
		this.m_view.visible = true;
		var _local_2:Array = [];
		_local_2 = _arg_1.split(":");
		var _local_3:Number = _local_2.length;
		var _local_4:Number = _local_2[(_local_3 - 2)];
		var _local_5:Number = _local_2[(_local_3 - 3)];
		var _local_6:String = _local_2.slice(-(_local_3), (_local_3 - 1)).join(":");
		this.updateCountDown(_local_6, ((this.startDial + "-") + _arg_1), (_local_4 / 60), 0);
	}

	public function ShowTest():void {
		this.onSetData({"time": "10:10"});
	}


}
}//package hud

