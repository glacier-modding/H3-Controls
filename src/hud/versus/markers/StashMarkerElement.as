// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.versus.markers.StashMarkerElement

package hud.versus.markers {
import common.Animate;

import flash.display.Sprite;

public class StashMarkerElement extends BaseMarkerElement {

	private var m_isCounting:Boolean = false;

	public function StashMarkerElement() {
		m_view = new StashMarkerElementView();
		this.pulsateOverlays(m_view.pointerOverlay, false);
		this.pulsateBlurs(m_view.pointerBlur, false);
		this.pulsateOverlays(m_view.stashbarOverlay, false);
		this.pulsateBlurs(m_view.stashbarBlur, false);
		this.pulsateIcons(m_view.pointer, false);
		m_view.stashbar.bar.scaleX = 1;
		m_view.stashbarOverlay.scaleX = 1;
		m_view.stashbar.y = (m_view.stashbarBlur.y = (m_view.stashbarOverlay.y = 0));
		addChild(m_view);
	}

	public function onSetData(_arg_1:Object):void {
	}

	public function setIconType(_arg_1:int, _arg_2:Boolean):void {
		m_view.pointer.visible = ((_arg_2) ? true : false);
		m_view.iconMc.visible = ((_arg_2) ? true : false);
		m_view.iconMc.gotoAndStop((_arg_1 + 1));
		m_view.stashbar.bar.visible = ((_arg_2) ? false : true);
	}

	public function setTimeLeft(_arg_1:Number, _arg_2:Boolean):void {
		m_view.stashbar.bar.gotoAndStop(2);
		m_view.stashbar.bar.scaleX = _arg_1;
		m_view.stashbarOverlay.scaleX = _arg_1;
		if (!this.m_isCounting) {
			if (_arg_2) {
				m_view.pointer.gotoAndStop(2);
				this.pulsateOverlays(m_view.pointerOverlay, true);
				this.pulsateBlurs(m_view.pointerBlur, true);
				this.pulsateIcons(m_view.pointer, true);
			} else {
				this.pulsateOverlays(m_view.stashbarOverlay, true);
				this.pulsateBlurs(m_view.stashbarBlur, true);
			}
			;
			this.m_isCounting = true;
		}
		;
		if (_arg_1 <= 0) {
			this.m_isCounting = false;
			m_view.stashbar.bar.gotoAndStop(1);
			m_view.pointer.gotoAndStop(1);
			if (_arg_2) {
				this.pulsateOverlays(m_view.pointerOverlay, true, true);
				this.pulsateBlurs(m_view.pointerBlur, true, true);
				this.pulsateIcons(m_view.pointer, true, true);
			} else {
				this.pulsateOverlays(m_view.stashbarOverlay, true, true);
				this.pulsateBlurs(m_view.stashbarBlur, true, true);
			}
			;
		}
		;
	}

	private function pulsateBlurs(_arg_1:Sprite, _arg_2:Boolean, _arg_3:Boolean = false):void {
		Animate.kill(_arg_1);
		_arg_1.alpha = 0;
		if (_arg_2) {
			this.pulsateBlursIn({
				"clip": _arg_1,
				"singlePulseThenKill": _arg_3
			});
		}
		;
	}

	private function pulsateBlursIn(_arg_1:Object):void {
		_arg_1.clip.scaleX = (_arg_1.clip.scaleY = 1);
		_arg_1.clip.alpha = 0.3;
		Animate.to(_arg_1.clip, 0.2, 0, {
			"alpha": 1,
			"scaleX": 1.4,
			"scaleY": 1
		}, Animate.ExpoIn, this.pulsateBlursOut, _arg_1);
	}

	private function pulsateBlursOut(clipObject:Object):void {
		Animate.to(clipObject.clip, 0.5, 0, {
			"alpha": 0,
			"scaleX": 2,
			"scaleY": 1
		}, Animate.ExpoOut, function ():void {
			if (clipObject.singlePulseThenKill) {
				pulsateBlurs(clipObject.clip, false);
			} else {
				pulsateBlursIn(clipObject);
			}
			;
		});
	}

	private function pulsateOverlays(_arg_1:Sprite, _arg_2:Boolean, _arg_3:Boolean = false):void {
		Animate.kill(_arg_1);
		_arg_1.alpha = 0;
		if (_arg_2) {
			this.pulsateOverlaysIn({
				"clip": _arg_1,
				"singlePulseThenKill": _arg_3
			});
		}
		;
	}

	private function pulsateOverlaysIn(_arg_1:Object):void {
		_arg_1.clip.alpha = 0.6;
		Animate.to(_arg_1.clip, 0.5, 0.2, {"alpha": 0}, Animate.ExpoOut, this.pulsateOverlaysOut, _arg_1);
	}

	private function pulsateOverlaysOut(_arg_1:Object):void {
		if (_arg_1.singlePulseThenKill) {
			this.pulsateOverlays(_arg_1.clip, false);
		} else {
			this.pulsateOverlaysIn(_arg_1);
		}
		;
	}

	private function pulsateIcons(_arg_1:Sprite, _arg_2:Boolean, _arg_3:Boolean = false):void {
		Animate.kill(_arg_1);
		_arg_1.scaleX = (_arg_1.scaleY = 1);
		_arg_1.alpha = 1;
		if (_arg_2) {
			this.pulsateIconsIn({
				"clip": _arg_1,
				"singlePulseThenKill": _arg_3
			});
		}
		;
	}

	private function pulsateIconsIn(_arg_1:Object):void {
		_arg_1.clip.scaleX = (_arg_1.clip.scaleY = 0.9);
		Animate.to(_arg_1.clip, 0.5, 0.1, {
			"scaleX": 1,
			"scaleY": 1
		}, Animate.BackInOut, this.pulsateIconsOut, _arg_1);
	}

	private function pulsateIconsOut(clipObject:Object):void {
		Animate.delay(clipObject.clip, 0.1, function ():void {
			if (clipObject.singlePulseThenKill) {
				pulsateIcons(clipObject.clip, false);
			} else {
				pulsateIconsIn(clipObject);
			}
			;
		});
	}


}
}//package hud.versus.markers

