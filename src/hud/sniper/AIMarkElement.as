// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.sniper.AIMarkElement

package hud.sniper {
import common.BaseControl;

import basic.BoundsExtender;

import flash.external.ExternalInterface;

import scaleform.gfx.Extensions;

public class AIMarkElement extends BaseControl {

	private var m_container:BoundsExtender = new BoundsExtender();
	private var m_aMarks:Array = new Array();
	private var m_counter:int = 0;
	private var m_scaleMod:Number = 1;

	public function AIMarkElement() {
		var _local_2:AIMarkElementView;
		super();
		addChild(this.m_container);
		var _local_1:int;
		while (_local_1 < 2) {
			_local_2 = new AIMarkElementView();
			_local_2.localState = -1;
			this.m_container.addChild(_local_2);
			_local_2.visible = false;
			this.m_aMarks.push(_local_2);
			_local_1++;
		}
		;
	}

	public function SetMarkState(_arg_1:Boolean, _arg_2:Boolean, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Boolean, _arg_7:Boolean):void {
		if (this.m_counter >= 2) {
			this.m_counter = 0;
		}
		;
		if (_arg_7) {
			if (((this.m_aMarks[this.m_counter].visible) && (_arg_2))) {
				if (this.m_aMarks[this.m_counter].localState == 1) {
					this.playSound("Mark_Local");
				} else {
					if (this.m_aMarks[this.m_counter].localState == 2) {
						this.playSound("Mark_Remote");
					}
					;
				}
				;
			}
			;
		}
		;
		if (_arg_2) {
			if (!this.m_aMarks[this.m_counter].visible) {
				this.m_aMarks[this.m_counter].visible = _arg_2;
			}
			;
			_arg_5 = (_arg_5 * this.m_scaleMod);
			if (_arg_5 != this.m_aMarks[this.m_counter].scaleX) {
				this.m_aMarks[this.m_counter].scaleX = _arg_5;
				this.m_aMarks[this.m_counter].scaleY = _arg_5;
			}
			;
			this.m_aMarks[this.m_counter].x = _arg_3;
			this.m_aMarks[this.m_counter].y = _arg_4;
			if (((_arg_1) && (!(this.m_aMarks[this.m_counter].localState == 1)))) {
				this.m_aMarks[this.m_counter].localState = 1;
				this.playSound("Mark_Local");
				this.m_aMarks[this.m_counter].gotoAndStop(1);
			}
			;
			if (((!(_arg_1)) && (!(this.m_aMarks[this.m_counter].localState == 2)))) {
				this.m_aMarks[this.m_counter].localState = 2;
				this.playSound("Mark_Remote");
				this.m_aMarks[this.m_counter].gotoAndStop(2);
			}
			;
		} else {
			if (this.m_aMarks[this.m_counter].visible) {
				this.m_aMarks[this.m_counter].visible = _arg_2;
				if (this.m_aMarks[this.m_counter].localState == 1) {
					this.playSound("Unmark_Local");
				}
				;
				if (this.m_aMarks[this.m_counter].localState == 2) {
					this.playSound("Unmark_Remote");
				}
				;
				this.m_aMarks[this.m_counter].localState = -1;
			}
			;
		}
		;
		this.m_counter++;
	}

	private function playSound(_arg_1:String):void {
		ExternalInterface.call("PlaySound", _arg_1);
	}

	override public function onSetSize(_arg_1:Number, _arg_2:Number):void {
		if (ControlsMain.isVrModeActive()) {
			this.m_scaleMod = 1;
		} else {
			this.m_scaleMod = (Extensions.visibleRect.height / 1080);
		}
		;
	}


}
}//package hud.sniper

