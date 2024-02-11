// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.MapDynamicLayer

package hud {
import common.BaseControl;

import flash.display.Sprite;

public class MapDynamicLayer extends BaseControl {

	private var m_sprite:Sprite;
	private var m_spriteSuspiciousBodies:Sprite;

	public function MapDynamicLayer() {
		trace("ActionScript Map - trace");
		super();
		this.m_sprite = new Sprite();
		addChild(this.m_sprite);
		this.m_spriteSuspiciousBodies = new Sprite();
		addChild(this.m_spriteSuspiciousBodies);
	}

	public function setRectangles(_arg_1:Array):void {
		var _local_3:Number;
		var _local_4:Number;
		var _local_5:Number;
		var _local_6:Number;
		var _local_7:Number;
		trace("MapDynamicLayer::setRectangles");
		this.m_sprite.graphics.clear();
		var _local_2:int;
		while (_local_2 < _arg_1.length) {
			_local_3 = ((_arg_1[_local_2] * 0.5) + 0.3);
			this.m_sprite.graphics.beginFill(0xFF0000, _local_3);
			_local_4 = _arg_1[(_local_2 + 1)];
			_local_5 = _arg_1[(_local_2 + 2)];
			_local_6 = _arg_1[(_local_2 + 3)];
			_local_7 = _arg_1[(_local_2 + 4)];
			trace(((((((("MapDynamicLayer::setRectangles " + _local_4) + " ") + _local_5) + " ") + _local_6) + " ") + _local_7));
			this.m_sprite.graphics.drawRect(_local_4, _local_5, _local_6, _local_7);
			_local_2 = (_local_2 + 5);
		}
		;
	}

	public function setSuspiciousBodies(_arg_1:Array):void {
		var _local_4:Number;
		var _local_5:Number;
		trace("MapDynamicLayer::setSuspiciousBodies");
		this.m_spriteSuspiciousBodies.graphics.clear();
		if (_arg_1.length == 0) {
			return;
		}
		;
		this.m_spriteSuspiciousBodies.graphics.beginFill(0x990000, 0.8);
		var _local_2:Number = ((_arg_1[0] * 0.5) + 0.3);
		var _local_3:int = 1;
		while (_local_3 < _arg_1.length) {
			_local_4 = (_arg_1[_local_3] + (_local_2 * 0.5));
			_local_5 = (_arg_1[(_local_3 + 1)] + (_local_2 * 0.5));
			trace(((((("MapDynamicLayer::setSuspiciousBodies " + _local_4) + " ") + _local_5) + " ") + _local_2));
			this.m_spriteSuspiciousBodies.graphics.drawCircle(_local_4, _local_5, _local_2);
			_local_3 = (_local_3 + 2);
		}
		;
		this.m_spriteSuspiciousBodies.graphics.endFill();
	}


}
}//package hud

