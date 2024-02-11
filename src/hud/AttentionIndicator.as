// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.AttentionIndicator

package hud {
import common.BaseControl;

import flash.display.Sprite;

import scaleform.gfx.Extensions;

public class AttentionIndicator extends BaseControl {

	private var m_hContainer:Sprite = new Sprite();
	private var m_aWedges:Array = [];
	private var i:int;

	public function AttentionIndicator() {
		addChild(this.m_hContainer);
		this.ensureWedgesCount(10);
	}

	public function getWedges():Array {
		return (this.m_aWedges);
	}

	public function ensureWedgesCount(_arg_1:int):void {
		var _local_2:AttentionWedge;
		while (_arg_1 > this.m_aWedges.length) {
			_local_2 = new AttentionWedge();
			_local_2.visible = false;
			this.m_aWedges.push(_local_2);
			this.m_hContainer.addChild(_local_2);
		}

	}

	override public function onSetSize(_arg_1:Number, _arg_2:Number):void {
		var _local_3:Number = 1;
		if (!ControlsMain.isVrModeActive()) {
			_local_3 = (Extensions.visibleRect.height / 1080);
		}

		this.m_hContainer.scaleX = (this.m_hContainer.scaleY = _local_3);
	}


}
}//package hud

