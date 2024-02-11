// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.Reticle

package hud {
import common.BaseControl;

import flash.display.MovieClip;

import common.Animate;

public class Reticle extends BaseControl {

	private var m_view:ReticleView;
	private var currentType:Number = 0;
	private var baseAlpha:Number = 0.8;

	public function Reticle() {
		this.m_view = new ReticleView();
		this.m_view.hitKill_mc.visible = false;
		this.m_view.hit_mc.visible = false;
		addChild(this.m_view);
	}

	public function set type(_arg_1:Number):void {
		this.setType(_arg_1);
	}

	public function setType(_arg_1:Number):void {
		this.currentType = _arg_1;
		switch (_arg_1) {
			case 0:
				this.m_view.gotoAndStop("NONE");
				this.m_view.center_mc.alpha = 0;
				return;
			case 1:
				this.m_view.gotoAndStop("PISTOL");
				this.m_view.center_mc.alpha = 0;
				return;
			case 2:
				this.m_view.gotoAndStop("REVOLVER");
				this.m_view.center_mc.alpha = 0;
				return;
			case 3:
				this.m_view.gotoAndStop("SMG");
				this.m_view.center_mc.alpha = 0;
				return;
			case 4:
				this.m_view.gotoAndStop("RIFLE");
				this.m_view.center_mc.alpha = 0;
				return;
			case 5:
				this.m_view.gotoAndStop("SHOTGUN");
				this.m_view.center_mc.alpha = 0;
				return;
			case 6:
				this.m_view.gotoAndStop("SNIPER");
				this.m_view.center_mc.alpha = 0;
				return;
			case 7:
				this.m_view.gotoAndStop("HARDBALLER");
				this.m_view.center_mc.alpha = 0;
				return;
			case 8:
				this.m_view.gotoAndStop("SPOTTER");
				return;
			case 9:
				this.m_view.gotoAndStop("POINTER");
				this.m_view.center_mc.alpha = 0;
				return;
			case 10:
				this.m_view.gotoAndStop("WORLDMAP");
				return;
			case 11:
				this.m_view.gotoAndStop("BLINDFIRE");
				return;
			case 12:
				this.m_view.gotoAndStop("RANGEDINDICATOR");
				this.m_view.center_mc.alpha = 0;
				return;
			case 13:
				this.m_view.gotoAndStop("NONE");
				this.m_view.center_mc.alpha = 0.5;
				return;
			default:
				this.m_view.gotoAndStop("NONE");
				this.m_view.center_mc.alpha = 0;
		}

	}

	public function setAccuracy(_arg_1:Number):void {
		var _local_2:Number = 960;
		switch (this.currentType) {
			case 1:
				this.moveMarkers(_arg_1, 0, _local_2, -1, 0, 0, 1, 1, 0);
				return;
			case 2:
				this.moveMarkers(_arg_1, 0, _local_2, -1, 0, 0, 1, 1, 0);
				return;
			case 3:
				this.moveMarkers(_arg_1, 0, _local_2, -1, 0, 0, 1, 1, 0);
				return;
			case 4:
				this.moveMarkers(_arg_1, 0, _local_2, -1, 0, 0, 1, 1, 0);
				return;
			case 5:
				this.moveCircle(_arg_1, _local_2);
				return;
			case 6:
				this.moveMarkers(_arg_1, 0, _local_2, -1, 0, 0, 1, 1, 0, -0.3, 0.3, 0.3, 0.3, 0.3, -0.3, -0.3, -0.3);
				return;
			case 7:
				this.moveMarkers(_arg_1, 0, _local_2, -1, 0, 0, 1, 1, 0);
				return;
			case 8:
				this.moveMarkers(_arg_1, 5, _local_2, -1, 0, 0, 1, 1, 0);
				return;
			case 9:
				this.moveMarkers(_arg_1, 5, _local_2);
				return;
			case 10:
				this.moveMarkers(_arg_1, 5, 0, -1, 0, 0, 1, 1, 0, 0, -1);
				return;
			case 11:
				this.moveMarkers(_arg_1, 0, _local_2, 1, 0, -1, 0);
				return;
		}

	}

	private function moveMarkers(_arg_1:Number, _arg_2:Number, _arg_3:Number, ..._args):void {
		var _local_6:MovieClip;
		var _local_5:int;
		while (_local_5 < (_args.length / 2)) {
			_local_6 = (this.m_view.getChildByName((("marker" + String(_local_5)) + "_mc")) as MovieClip);
			_local_6.x = ((_arg_2 * _args[(_local_5 * 2)]) + ((_arg_3 * _arg_1) * _args[(_local_5 * 2)]));
			_local_6.y = ((_arg_2 * _args[((_local_5 * 2) + 1)]) + ((_arg_3 * _arg_1) * _args[((_local_5 * 2) + 1)]));
			_local_6.alpha = this.baseAlpha;
			_local_5++;
		}

	}

	private function moveCircle(_arg_1:Number, _arg_2:Number):void {
		this.m_view.marker0_mc.width = ((_arg_1 * 2) * _arg_2);
		this.m_view.marker0_mc.height = ((_arg_1 * 2) * _arg_2);
	}

	public function triggerHit():void {
		this.m_view.hit_mc.visible = true;
		this.m_view.hit_mc.alpha = this.baseAlpha;
		this.m_view.hit_mc.scaleX = (this.m_view.hit_mc.scaleY = 0.5);
		Animate.delay(this.m_view.hit_mc, 0.4, this.hideMarker, this.m_view.hit_mc);
	}

	public function triggerKill():void {
		Animate.kill(this.m_view.hitKill_mc);
		this.m_view.hit_mc.visible = false;
		this.m_view.hitKill_mc.alpha = 1;
		if (this.m_view.hitKill_mc.visible) {
			this.m_view.hitKill_mc.scaleX = (this.m_view.hitKill_mc.scaleY = 1.1);
			Animate.legacyTo(this.m_view.hitKill_mc, 0.7, {
				"scaleX": 0.75,
				"scaleY": 0.75
			}, Animate.Linear, this.hideMarker, this.m_view.hitKill_mc);
		} else {
			this.m_view.hitKill_mc.visible = true;
			this.m_view.hitKill_mc.scaleX = (this.m_view.hitKill_mc.scaleY = 0.75);
			Animate.delay(this.m_view.hitKill_mc, 0.7, this.hideMarker, this.m_view.hitKill_mc);
		}

	}

	private function hideMarker(_arg_1:MovieClip):void {
		_arg_1.visible = false;
	}


}
}//package hud

