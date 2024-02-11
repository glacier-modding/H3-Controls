// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.evergreen.EconomyWidget

package hud.evergreen {
import common.BaseControl;

import __AS3__.vec.Vector;

import common.Localization;
import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.Animate;

import __AS3__.vec.*;

public class EconomyWidget extends BaseControl {

	private var m_mercesPrev:int = 2147483647;
	private var m_isNotificationAnimating:Boolean = false;
	private var notifEndX:Number = 0;

	private var m_view:EvergreenEconomyWidgetView = new EvergreenEconomyWidgetView();
	private var m_notificationsPending:Vector.<Notification> = new Vector.<Notification>();
	private const m_lstrMerces:String = Localization.get("UI_EVERGREEN_MERCES");
	private const m_lstrMoney:String = Localization.get("EVERGREEN_HUD_MONEY").toUpperCase();

	public function EconomyWidget() {
		addChild(this.m_view);
		MenuUtils.setupText(this.m_view.money_txt, "", 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_view.notification_txt, "", 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		this.m_view.notification_txt.alpha = 0;
		this.notifEndX = this.m_view.notification_txt.x;
	}

	public function onSetData(_arg_1:int):void {
		var _local_2:int;
		if (this.m_mercesPrev == int.MAX_VALUE) {
			this.updateMoney(_arg_1);
		} else {
			_local_2 = (_arg_1 - this.m_mercesPrev);
			if (_local_2 != 0) {
				if (this.m_isNotificationAnimating) {
					this.m_notificationsPending.push(new Notification(_local_2, _arg_1));
				} else {
					this.startNotificationAnimation(_local_2, _arg_1);
				}
				;
			}
			;
		}
		;
		this.m_mercesPrev = _arg_1;
	}

	private function updateMoney(_arg_1:int):void {
		this.m_view.money_txt.htmlText = this.m_lstrMoney.replace(/\{0\}/g, MenuUtils.formatNumber(_arg_1, false));
	}

	private function startNotificationAnimation(diffMerces:int, mercesAfter:int):void {
		var yEnd:Number;
		this.m_isNotificationAnimating = true;
		if (diffMerces < 0) {
			this.updateMoney(mercesAfter);
			this.animateIcon();
		}
		;
		MenuUtils.setTextColor(this.m_view.notification_txt, ((diffMerces > 0) ? MenuConstants.COLOR_GREEN : MenuConstants.COLOR_RED));
		this.m_view.notification_txt.htmlText = (((((diffMerces > 0) ? "+" : "") + MenuUtils.formatNumber(diffMerces, false)) + " ") + this.m_lstrMerces);
		var yTop:Number = ((this.m_view.money_txt.y + this.m_view.money_txt.height) - this.m_view.notification_txt.height);
		var yMid:Number = (this.m_view.money_txt.y + this.m_view.money_txt.height);
		var yLow:Number = ((this.m_view.money_txt.y + this.m_view.money_txt.height) + this.m_view.notification_txt.height);
		var yStart:Number = ((diffMerces < 0) ? yTop : yMid);
		yEnd = ((diffMerces < 0) ? yMid : yTop);
		var xStart:Number = ((diffMerces < 0) ? this.notifEndX : (this.notifEndX - 100));
		var xEnd:Number = ((diffMerces < 0) ? (this.notifEndX - 100) : this.notifEndX);
		this.m_view.notification_txt.x = xStart;
		this.m_view.notification_txt.y = yStart;
		this.m_view.notification_txt.alpha = 0;
		Animate.to(this.m_view.notification_txt, 0.2, 0, {
			"alpha": 1,
			"y": yMid,
			"x": this.notifEndX
		}, Animate.SineOut, Animate.to, this.m_view.notification_txt, 0.2, 1, {
			"alpha": 0,
			"y": yEnd,
			"x": xEnd
		}, Animate.SineIn, function ():void {
			var _local_1:Notification;
			if (diffMerces > 0) {
				updateMoney(mercesAfter);
				animateIcon();
			}
			;
			if (m_notificationsPending.length == 0) {
				m_isNotificationAnimating = false;
			} else {
				_local_1 = m_notificationsPending.shift();
				startNotificationAnimation(_local_1.diffMerces, _local_1.mercesAfter);
			}
			;
		});
	}

	private function animateIcon():void {
		this.m_view.icon_mc.scaleX = (this.m_view.icon_mc.scaleY = 1.3);
		Animate.to(this.m_view.icon_mc, 0.2, 0.07, {
			"scaleX": 1,
			"scaleY": 1
		}, Animate.SineOut);
	}


}
}//package hud.evergreen

class Notification {

	public var diffMerces:int;
	public var mercesAfter:int;

	public function Notification(_arg_1:int, _arg_2:int) {
		this.diffMerces = _arg_1;
		this.mercesAfter = _arg_2;
	}

}


