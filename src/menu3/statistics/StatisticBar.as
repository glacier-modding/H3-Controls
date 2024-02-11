// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.statistics.StatisticBar

package menu3.statistics {
import flash.display.MovieClip;

import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.Animate;

import flash.text.TextField;

public class StatisticBar {

	private var m_bar:MovieClip;
	private var m_data:Object;
	private var m_showValues:Boolean = true;
	private var m_hasData:Boolean = false;
	private var m_completed:Number = 0;
	private var m_total:Number = 0;

	public function StatisticBar(_arg_1:MovieClip, _arg_2:Boolean):void {
		this.m_bar = _arg_1;
		this.m_showValues = _arg_2;
	}

	public function init(_arg_1:String, _arg_2:int, _arg_3:int):void {
		this.m_completed = _arg_2;
		this.m_total = _arg_3;
		MenuUtils.setColor(this.m_bar.fill, MenuConstants.COLOR_MENU_CONTRACT_SEARCH_GREY);
		MenuUtils.setColor(this.m_bar.bg, MenuConstants.COLOR_MENU_SOLID_BACKGROUND);
		this.m_bar.bg.alpha = 0;
		this.m_bar.fill.scaleX = 0;
		this.m_bar.title.alpha = 0;
		this.m_bar.value.alpha = 0;
		this.m_hasData = false;
		if (_arg_1 != null) {
			this.m_hasData = true;
			MenuUtils.setupTextUpper(this.m_bar.title, _arg_1, 12, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			if (this.m_showValues) {
				this.m_bar.value.text = ((_arg_2 + "/") + _arg_3);
			} else {
				this.m_bar.value.text = "";
				this.m_bar.title.alpha = 0.5;
			}
			;
		}
		;
	}

	public function show(_arg_1:Number):void {
		if (this.m_hasData) {
			Animate.delay(this.m_bar.bg, _arg_1, this.delayCallbackBg, this.m_bar.bg);
			Animate.delay(this.m_bar.title, _arg_1, this.delayCallbackTf, this.m_bar.title);
			Animate.delay(this.m_bar.value, _arg_1, this.delayCallbackTf, this.m_bar.value);
			if (this.m_showValues) {
				Animate.delay(this.m_bar.fill, (_arg_1 + 0.05), this.delayCallbackFill, this.m_bar.fill, (this.m_completed / this.m_total));
			}
			;
		} else {
			Animate.to(this.m_bar.bg, 0.2, 0, {"alpha": 0.4}, Animate.ExpoOut);
		}
		;
	}

	private function delayCallbackTf(_arg_1:TextField):void {
		Animate.to(_arg_1, 0.3, 0, {"alpha": this.getAvailabilityAlpha()}, Animate.ExpoOut);
	}

	private function delayCallbackBg(_arg_1:MovieClip):void {
		Animate.to(_arg_1, 0.3, 0, {"alpha": 1}, Animate.ExpoOut);
	}

	private function delayCallbackFill(_arg_1:MovieClip, _arg_2:Number):void {
		Animate.to(_arg_1, 0.4, 0, {"scaleX": _arg_2}, Animate.ExpoInOut);
	}

	private function getAvailabilityAlpha():Number {
		return ((this.m_showValues) ? 1 : 0.5);
	}

	public function destroy():void {
		Animate.kill(this.m_bar.bg);
		Animate.kill(this.m_bar.title);
		Animate.kill(this.m_bar.value);
		Animate.kill(this.m_bar.fill);
		this.m_bar = null;
	}


}
}//package menu3.statistics

