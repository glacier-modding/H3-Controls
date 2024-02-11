// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.DroppedItemVR

package hud {
import common.BaseControl;
import common.Animate;

public class DroppedItemVR extends BaseControl {

	private var m_view:DroppedItemVRView;
	private var m_pulsateCounter:int;

	public function DroppedItemVR() {
		this.m_view = new DroppedItemVRView();
		addChild(this.m_view);
		this.m_view.visible = false;
	}

	public function onItemAutoDropped(_arg_1:Object):void {
		Animate.kill(this.m_view.arrow_mc);
		Animate.kill(this.m_view.icon_mc);
		this.m_view.visible = true;
		this.m_pulsateCounter = 0;
		this.m_view.icon_mc.y = -60;
		this.m_view.icon_mc.alpha = 0;
		this.animateArrows();
		this.animateIcon();
	}

	private function animateArrows():void {
		if (this.m_pulsateCounter >= 3) {
			return;
		}

		Animate.fromTo(this.m_view.arrow_mc, 0.4, 0, {"frames": 0}, {"frames": 60}, Animate.Linear, this.animateArrows);
		this.m_pulsateCounter = (this.m_pulsateCounter + 1);
	}

	private function animateIcon():void {
		Animate.to(this.m_view.icon_mc, 0.4, 0, {
			"alpha": 1,
			"y": -20
		}, Animate.ExpoOut, function ():void {
			Animate.to(m_view.icon_mc, 0.8, 0, {"y": 0}, Animate.Linear, function ():void {
				Animate.to(m_view.icon_mc, 0.4, 0, {
					"y": 80,
					"alpha": 0
				}, Animate.ExpoOut, function ():void {
					m_view.visible = false;
				});
			});
		});
	}


}
}//package hud

