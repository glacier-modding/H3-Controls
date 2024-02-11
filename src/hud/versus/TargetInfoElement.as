// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.versus.TargetInfoElement

package hud.versus {
import common.BaseControl;

import flash.display.MovieClip;

import common.Localization;
import common.Animate;
import common.menu.MenuUtils;
import common.menu.MenuConstants;

public class TargetInfoElement extends BaseControl {

	private var m_view:TargetInfoElementView;
	private var m_headerClip:MovieClip;
	private var m_counterClip:MovieClip;
	private var m_headerPosY:Number;
	private var m_headerString:String = "";
	private var m_counterString:String = "";
	private var m_animateIn:Boolean = true;

	public function TargetInfoElement() {
		this.m_view = new TargetInfoElementView();
		addChild(this.m_view);
		this.m_headerClip = this.m_view.headerClip;
		this.m_counterClip = this.m_view.counterClip;
		this.m_headerClip.alpha = 0;
		this.m_counterClip.alpha = 0;
		this.m_headerPosY = this.m_headerClip.y;
	}

	public function onSetData(_arg_1:Object):void {
		if (_arg_1.nextTargetTime == 0) {
			this.resetToInitialState();
			return;
		}

		this.m_headerString = ((_arg_1.isKiller == true) ? Localization.get("UI_HUD_VS_NEXT_TARGET_TIMER") : Localization.get("UI_HUD_VS_KILL_TARGET_TIMER"));
		if (_arg_1.isDuelStart == true) {
			this.m_headerString = "";
		}

		this.m_counterString = _arg_1.nextTargetTime.toString();
		this.updateHeader();
		if (this.m_animateIn) {
			this.m_animateIn = false;
			this.updateCounter();
			this.animateIn();
		} else {
			this.animateCount();
		}

	}

	private function animateIn():void {
		Animate.fromTo(this.m_headerClip, 0.3, 0, {
			"alpha": 0,
			"y": (this.m_headerPosY + 30)
		}, {
			"alpha": 1,
			"y": this.m_headerPosY
		}, Animate.ExpoOut);
		Animate.fromTo(this.m_counterClip, 0.15, 0.3, {"alpha": 0}, {"alpha": 1}, Animate.ExpoOut);
		Animate.addFromTo(this.m_counterClip, 0.3, 0.3, {
			"scaleX": 0,
			"scaleY": 0
		}, {
			"scaleX": 1,
			"scaleY": 1
		}, Animate.ExpoOut);
	}

	private function animateCount():void {
		Animate.fromTo(this.m_counterClip, 0.2, 0, {
			"scaleX": 1.5,
			"scaleY": 1.5
		}, {
			"scaleX": 1,
			"scaleY": 1
		}, Animate.ExpoOut);
		this.updateCounter();
	}

	private function updateHeader():void {
		MenuUtils.setupTextUpper(this.m_headerClip.txtLabel, this.m_headerString, 36, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
	}

	private function updateCounter():void {
		MenuUtils.setupText(this.m_counterClip.txtLabel, this.m_counterString, 120, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
	}

	private function resetToInitialState():void {
		this.m_animateIn = true;
		Animate.kill(this.m_headerClip);
		Animate.kill(this.m_counterClip);
		this.m_headerClip.alpha = 0;
		this.m_counterClip.alpha = 0;
		this.m_counterString = "";
		this.m_headerString = "";
		this.updateHeader();
		this.updateCounter();
	}


}
}//package hud.versus

