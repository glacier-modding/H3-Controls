// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//basic.ScrollingList

package basic {
import common.BaseControl;

import flash.display.Sprite;
import flash.display.Shape;

import common.Animate;

public class ScrollingList extends BaseControl {

	private var m_container:Sprite = new Sprite();
	private var m_mask:Shape = new Shape();
	private var m_sizeX:Number;
	private var m_sizeY:Number;


	override public function onAttached():void {
		addChild(this.m_container);
	}

	override public function getContainer():Sprite {
		return (this.m_container);
	}

	public function onSelectedIndexChanged(_arg_1:int):void {
		var _local_3:Number;
		var _local_4:Number;
		var _local_5:Number;
		var _local_6:Number;
		var _local_2:BaseControl = (this.getContainer().getChildAt(_arg_1) as BaseControl);
		if (_local_2 != null) {
			_local_3 = (_local_2.x + (_local_2.width / 2));
			_local_4 = (_local_2.y + (_local_2.height / 2));
			_local_5 = this.m_container.x;
			_local_6 = this.m_container.y;
			if (this.m_container.width > this.m_sizeX) {
				_local_5 = ((this.m_sizeX / 2) - _local_3);
				_local_5 = Math.max(_local_5, (this.m_sizeX - this.m_container.width));
				_local_5 = Math.min(_local_5, 0);
			}
			;
			if (this.m_container.height > this.m_sizeY) {
				_local_6 = ((this.m_sizeY / 2) - _local_4);
				_local_6 = Math.max(_local_6, (this.m_sizeY - this.m_container.height));
				_local_6 = Math.min(_local_6, 0);
			}
			;
			Animate.legacyTo(this.m_container, 0.5, {
				"x": _local_5,
				"y": _local_6
			}, Animate.ExpoOut);
		}
		;
	}

	override public function onSetSize(_arg_1:Number, _arg_2:Number):void {
		this.m_sizeX = _arg_1;
		this.m_sizeY = _arg_2;
		this.m_mask.x = this.x;
		this.m_mask.y = this.y;
		this.m_mask.graphics.clear();
		this.m_mask.graphics.beginFill(0xFF0000, 1);
		this.m_mask.graphics.drawRect(0, 0, (_arg_1 + 1), (_arg_2 + 1));
		this.m_mask.graphics.endFill();
		this.mask = this.m_mask;
	}


}
}//package basic

