// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.missionend.MissionEndGhostFlare

package menu3.missionend {
import flash.display.Sprite;

import common.Animate;
import common.menu.MenuUtils;

public class MissionEndGhostFlare extends Sprite {

	private var m_view:MissionEndGhostFlareView;

	public function MissionEndGhostFlare() {
		this.m_view = new MissionEndGhostFlareView();
		addChild(this.m_view);
		this.pulsateClip(this.m_view.up, true, 20, 0.7, 0.3, 0.3, false);
		this.pulsateClip(this.m_view.mid, true, 15, 0.6, 0.5, 0.3, false);
		this.pulsateClip(this.m_view.low, true, 10, 1, 0.6, 0, true);
		this.rotateClipForEver(this.m_view.up.inner);
	}

	private function pulsateClip(_arg_1:Sprite, _arg_2:Boolean, _arg_3:Number = 1, _arg_4:Number = 1, _arg_5:Number = 1, _arg_6:Number = 0, _arg_7:Boolean = false):void {
		Animate.kill(_arg_1);
		_arg_1.alpha = 0;
		if (_arg_2) {
			Animate.delay(_arg_1, _arg_6, this.pulsateClipInitialIn, {
				"clip": _arg_1,
				"speed": _arg_3,
				"scaleMax": _arg_4,
				"alphaMax": _arg_5,
				"speedyInit": _arg_7
			});
		}

	}

	private function pulsateClipInitialIn(_arg_1:Object):void {
		if (_arg_1.speedyInit) {
			Animate.to(_arg_1.clip, 0.6, 0, {"alpha": 0.4}, Animate.Linear, this.pulsateClipOut, _arg_1);
		} else {
			Animate.to(_arg_1.clip, ((Math.random() + 1) * _arg_1.speed), 0, {"alpha": 0.4}, Animate.Linear, this.pulsateClipOut, _arg_1);
		}

	}

	private function pulsateClipOut(_arg_1:Object):void {
		Animate.to(_arg_1.clip, ((Math.random() + 1) * _arg_1.speed), 0, {
			"alpha": (_arg_1.alphaMax / 4),
			"scaleX": this.getRandomScale(_arg_1.scaleMax),
			"scaleY": this.getRandomScale(_arg_1.scaleMax)
		}, Animate.Linear, this.pulsateClipIn, _arg_1);
	}

	private function pulsateClipIn(_arg_1:Object):void {
		Animate.to(_arg_1.clip, ((Math.random() + 1) * _arg_1.speed), 0, {
			"alpha": _arg_1.alphaMax,
			"scaleX": this.getRandomScale(_arg_1.scaleMax),
			"scaleY": this.getRandomScale(_arg_1.scaleMax)
		}, Animate.Linear, this.pulsateClipOut, _arg_1);
	}

	private function rotateClipForEver(_arg_1:Sprite):void {
		Animate.offset(_arg_1, 30, 0, {"rotation": 30}, Animate.Linear, this.rotateClipForEver, _arg_1);
	}

	private function getRandomScale(_arg_1:Number):Number {
		if (_arg_1 == 1) {
			return (1);
		}

		return (_arg_1 + (MenuUtils.getRandomInRange(-20, 20) / 100));
	}

	public function stopAllAnimations():void {
		this.pulsateClip(this.m_view.up, false);
		this.pulsateClip(this.m_view.mid, false);
		this.pulsateClip(this.m_view.low, false);
		this.pulsateClip(this.m_view.up.inner, false);
	}


}
}//package menu3.missionend

