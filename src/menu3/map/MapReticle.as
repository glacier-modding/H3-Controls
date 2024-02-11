// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.map.MapReticle

package menu3.map {
import common.BaseControl;
import common.menu.MenuUtils;

import flash.display.Sprite;
import flash.geom.Rectangle;
import flash.geom.Point;

public class MapReticle extends BaseControl {

	private var m_view:MapReticleView;
	private var m_found:Boolean;

	public function MapReticle() {
		this.m_view = new MapReticleView();
		MenuUtils.addDropShadowFilter(this.m_view.reticle);
		MenuUtils.addDropShadowFilter(this.m_view.finder);
		addChild(this.m_view);
	}

	public function scaledHitTest(_arg_1:Object):int {
		var _local_14:Sprite;
		var _local_15:Rectangle;
		var _local_16:Number;
		var _local_17:Number;
		var _local_2:Sprite = (this.m_view.reticle as Sprite);
		var _local_3:Number = (_arg_1.hitTestSize as Number);
		var _local_4:Boolean = (_arg_1.isUsingMouse as Boolean);
		var _local_5:Boolean = _arg_1.isMapHandlingInput;
		var _local_6:Rectangle = _local_2.getBounds(this);
		var _local_7:Point = new Point();
		if (!_local_4) {
			_local_7.x = (_local_6.x + (_local_6.width / 2));
			_local_7.y = (_local_6.y + (_local_6.height / 2));
		} else {
			_local_7.x = ((_local_6.x + (_local_6.width / 2)) + _local_2.mouseX);
			_local_7.y = ((_local_6.y + (_local_6.height / 2)) + _local_2.mouseY);
		}

		var _local_8:int = -1;
		var _local_9:Number = 0x3B9ACA00;
		var _local_10:Number = 0x3B9ACA00;
		var _local_11:Number = this.m_view.finder.x;
		var _local_12:Number = this.m_view.finder.y;
		var _local_13:int;
		while (_local_13 < _arg_1.subjects.length) {
			if (_arg_1.subjects[_local_13] != null) {
				_local_14 = (_arg_1.subjects[_local_13].getBoundsView() as Sprite);
				if (_local_14 != null) {
					_local_15 = _local_14.getBounds(this);
					_local_16 = this.distancePointRect(_local_7, _local_15);
					if (_local_16 < _local_3) {
						_local_17 = this.distancePointRectCenter(_local_7, _local_15);
						if (_local_17 < _local_10) {
							_local_9 = _local_16;
							_local_10 = _local_17;
							_local_8 = _local_13;
							_local_11 = (this.m_view.finder.x - (_local_15.x + (_local_15.width / 2)));
							_local_12 = (this.m_view.finder.y - (_local_15.y + (_local_15.height / 2)));
						}

					}

				}

			}

			_local_13++;
		}

		if (_local_8 == -1) {
			if (this.m_found) {
				this.m_view.finder.gotoAndStop(1);
				this.m_found = false;
			}

			if (((_local_4) && (_arg_1.isMapHandlingInput))) {
				this.m_view.finder.x = (this.m_view.finder.x + this.m_view.finder.mouseX);
				this.m_view.finder.y = (this.m_view.finder.y + this.m_view.finder.mouseY);
			} else {
				this.m_view.finder.x = (this.m_view.finder.x - (this.m_view.finder.x / 5));
				this.m_view.finder.y = (this.m_view.finder.y - (this.m_view.finder.y / 5));
			}

		} else {
			if (!this.m_found) {
				this.m_view.finder.gotoAndPlay(2);
				this.m_found = true;
			}

			if (_local_4) {
				this.m_view.finder.x = (this.m_view.finder.x - _local_11);
				this.m_view.finder.y = (this.m_view.finder.y - _local_12);
			} else {
				this.m_view.finder.x = (this.m_view.finder.x - (_local_11 / 3));
				this.m_view.finder.y = (this.m_view.finder.y - (_local_12 / 3));
			}

		}

		if (_local_4) {
			this.m_view.finder.visible = ((this.m_found) || (!(_local_5)));
			this.m_view.reticle.visible = (!(_local_5));
		} else {
			this.m_view.finder.visible = true;
			this.m_view.reticle.visible = true;
		}

		return (_local_8);
	}

	private function distancePointRectCenter(_arg_1:Point, _arg_2:Rectangle):Number {
		var _local_3:Point = new Point();
		_local_3.x = (_arg_2.x + (_arg_2.width / 2));
		_local_3.y = (_arg_2.y + (_arg_2.height / 2));
		return (this.distanceFromPointToRectCenter(_arg_1, _local_3));
	}

	private function distanceFromPointToRectCenter(_arg_1:Point, _arg_2:Point):Number {
		return (Math.sqrt((Math.pow((_arg_1.x - _arg_2.x), 2) + Math.pow((_arg_1.y - _arg_2.y), 2))));
	}

	private function distancePointRect(_arg_1:Point, _arg_2:Rectangle):Number {
		return (this.distanceFromPointToRect(_arg_1.x, _arg_1.y, _arg_2.x, _arg_2.y, _arg_2.width, _arg_2.height));
	}

	private function distanceFromPointToRect(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number):Number {
		var _local_7:Number = Math.max(Math.min(_arg_1, (_arg_3 + _arg_5)), _arg_3);
		var _local_8:Number = Math.max(Math.min(_arg_2, (_arg_4 + _arg_6)), _arg_4);
		return (Math.sqrt((((_arg_1 - _local_7) * (_arg_1 - _local_7)) + ((_arg_2 - _local_8) * (_arg_2 - _local_8)))));
	}


}
}//package menu3.map

