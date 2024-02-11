// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.evergreen.VitalInfoIcons

package hud.evergreen {
import common.BaseControl;

import flash.display.Sprite;

import common.Animate;

public class VitalInfoIcons extends BaseControl {

	private var m_view:Sprite = new Sprite();
	private var m_assassinIcon:EvergreenVitalInfoIcons_view = new EvergreenVitalInfoIcons_view();
	private var m_lookoutIcon:EvergreenVitalInfoIcons_view = new EvergreenVitalInfoIcons_view();
	private var m_verticalSpacing:Number = 33;

	public function VitalInfoIcons() {
		this.m_view.name = "VitalInfoIcons";
		addChild(this.m_view);
		this.m_assassinIcon.name = "m_assassinIcon";
		this.m_assassinIcon.gotoAndStop("assassin_near");
		this.m_assassinIcon.visible = false;
		this.m_assassinIcon.alpha = 0;
		this.m_assassinIcon.y = -(this.m_verticalSpacing);
		this.m_lookoutIcon.name = "m_lookoutIcon";
		this.m_lookoutIcon.gotoAndStop("lookout_near");
		this.m_lookoutIcon.visible = false;
		this.m_lookoutIcon.alpha = 0;
		this.m_lookoutIcon.y = (-(this.m_verticalSpacing) * 2);
		this.m_view.addChild(this.m_assassinIcon);
		this.m_view.addChild(this.m_lookoutIcon);
	}

	public function onSetData(data:Object):void {
		if (((data.isAssassinNearby) || (data.isAssassinAlerted))) {
			this.m_assassinIcon.visible = true;
			this.m_assassinIcon.gotoAndStop(((data.isAssassinAlerted) ? "assassin_alert" : "assassin_near"));
			Animate.to(this.m_assassinIcon, 0.2, 0, {"alpha": 1}, Animate.SineInOut);
			this.m_assassinIcon.icon_mc.scaleX = (this.m_assassinIcon.icon_mc.scaleY = 1.5);
			Animate.to(this.m_assassinIcon.icon_mc, 0.3, 0.1, {
				"scaleX": 1,
				"scaleY": 1
			}, Animate.SineInOut);
			this.m_assassinIcon.back_mc.scaleX = (this.m_assassinIcon.back_mc.scaleY = 1.3);
			Animate.to(this.m_assassinIcon.back_mc, 0.2, 0, {
				"scaleX": 1,
				"scaleY": 1
			}, Animate.SineInOut);
		} else {
			Animate.to(this.m_assassinIcon, 0.7, 0, {"alpha": 0}, Animate.SineInOut, function ():void {
				m_assassinIcon.visible = false;
			});
		}

		if (((data.isLookoutNearby) || (data.isLookoutAlerted))) {
			this.m_lookoutIcon.visible = true;
			this.m_lookoutIcon.gotoAndStop(((data.isLookoutAlerted) ? "lookout_alert" : "lookout_near"));
			Animate.to(this.m_lookoutIcon, 0.2, 0, {"alpha": 1}, Animate.SineInOut);
			this.m_lookoutIcon.icon_mc.scaleX = (this.m_lookoutIcon.icon_mc.scaleY = 1.75);
			Animate.to(this.m_lookoutIcon.icon_mc, 0.3, 0.1, {
				"scaleX": 1.2,
				"scaleY": 1.2
			}, Animate.SineInOut);
			this.m_lookoutIcon.back_mc.scaleX = (this.m_lookoutIcon.back_mc.scaleY = 1.3);
			Animate.to(this.m_lookoutIcon.back_mc, 0.2, 0, {
				"scaleX": 1,
				"scaleY": 1
			}, Animate.SineInOut);
		} else {
			Animate.to(this.m_lookoutIcon, 0.7, 0, {"alpha": 0}, Animate.SineInOut, function ():void {
				m_lookoutIcon.visible = false;
			});
		}

	}


}
}//package hud.evergreen

