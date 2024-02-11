// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.LeafNavigationUtil

package menu3 {
import flash.geom.Rectangle;
import flash.geom.Vector3D;

import common.Log;

import flash.display.DisplayObject;

public class LeafNavigationUtil {

	private static const m_debugOutput:Boolean = false;


	public static function getBestElementForSelection(_arg_1:DisplayObject, _arg_2:MenuElementBase, _arg_3:MenuElementBase, _arg_4:Number, _arg_5:Number):MenuElementBase {
		var _local_6:Rectangle = _arg_3.getView().getBounds(_arg_1);
		var _local_7:Vector3D = getCenterFromBounds(_local_6);
		if (m_debugOutput) {
			Log.xinfo(Log.ChannelDebug, ((("getBestElementForSelection startPos:" + _local_7) + " bounds:") + _local_6));
		}
		;
		var _local_8:Vector3D = new Vector3D(_arg_4, _arg_5);
		var _local_9:MenuElementBase = LeafNavigationUtil.getBestElement(_arg_1, _local_7, _local_8, _arg_2);
		return (_local_9);
	}

	private static function getBestElement(_arg_1:DisplayObject, _arg_2:Vector3D, _arg_3:Vector3D, _arg_4:MenuElementBase):MenuElementBase {
		var _local_8:MenuElementBase;
		var _local_9:Rectangle;
		var _local_10:Number;
		if (m_debugOutput) {
			Log.xinfo(Log.ChannelDebug, "getBestElement from container");
		}
		;
		if ((((_arg_4 == null) || (_arg_4.m_children == null)) || (_arg_4.m_children.length <= 0))) {
			if (m_debugOutput) {
				Log.xinfo(Log.ChannelDebug, "getBestElement container is null or emtpy");
			}
			;
			return (null);
		}
		;
		var _local_5:Number = -(Number.MAX_VALUE);
		var _local_6:MenuElementBase;
		var _local_7:int;
		while (_local_7 < _arg_4.m_children.length) {
			_local_8 = (_arg_4.m_children[_local_7] as MenuElementBase);
			if (((!(_local_8 == null)) && (!(MenuElementBase.getNodeProp(_local_8, "selectable") == false)))) {
				if (((!(_local_8.m_children == null)) && (_local_8.m_children.length > 0))) {
					_local_8 = getBestElement(_arg_1, _arg_2, _arg_3, _local_8);
				}
				;
				if (_local_8 != null) {
					_local_9 = _local_8.getView().getBounds(_arg_1);
					_local_10 = getScoreFromBounds(_arg_2, _local_9, _arg_3);
					if (m_debugOutput) {
						Log.xinfo(Log.ChannelDebug, ((("getBestElement score:" + _local_10) + " id:") + _local_8["_nodedata"]["id"]));
					}
					;
					if (_local_10 > _local_5) {
						_local_6 = _local_8;
						_local_5 = _local_10;
					}
					;
				}
				;
			}
			;
			_local_7++;
		}
		;
		return (_local_6);
	}

	private static function getScoreFromBounds(_arg_1:Vector3D, _arg_2:Rectangle, _arg_3:Vector3D):Number {
		var _local_4:Vector3D = getCenterFromBounds(_arg_2);
		return (getScore(_arg_1, _local_4, _arg_3));
	}

	private static function getCenterFromBounds(_arg_1:Rectangle):Vector3D {
		var _local_2:Vector3D = new Vector3D(_arg_1.topLeft.x, _arg_1.topLeft.y);
		var _local_3:Vector3D = new Vector3D(_arg_1.bottomRight.x, _arg_1.bottomRight.y);
		var _local_4:Vector3D = _local_3.subtract(_local_2);
		_local_4.scaleBy(0.5);
		var _local_5:Vector3D = _local_2.add(_local_4);
		return (_local_5);
	}

	private static function getScore(_arg_1:Vector3D, _arg_2:Vector3D, _arg_3:Vector3D):Number {
		var _local_10:Number;
		var _local_11:Number;
		var _local_12:Number;
		if (m_debugOutput) {
			Log.xinfo(Log.ChannelDebug, ((((("getScore startPos:" + _arg_1) + " endPos:") + _arg_2) + " inputDir:") + _arg_3));
		}
		;
		var _local_4:Vector3D = _arg_2.subtract(_arg_1);
		var _local_5:Number = _local_4.length;
		var _local_6:Number = -(Number.MAX_VALUE);
		var _local_7:Number = 0.0002;
		if (_local_5 <= _local_7) {
			return (_local_6);
		}
		;
		var _local_8:Vector3D = _local_4.clone();
		_local_8.normalize();
		var _local_9:Number = _arg_3.dotProduct(_local_8);
		_local_9 = Math.min(_local_9, 1);
		if (_local_9 > 0) {
			_local_10 = Math.acos(_local_9);
			_local_11 = ((Math.PI / 2) * 0.95);
			if (_local_10 < _local_11) {
				_local_12 = 2;
				_local_6 = (1 - (Math.abs(_local_4.x) + (Math.abs(_local_4.y) * _local_12)));
			}
			;
		}
		;
		return (_local_6);
	}


}
}//package menu3

