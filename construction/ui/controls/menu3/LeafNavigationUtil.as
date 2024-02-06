package menu3
{
	import common.Log;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	public class LeafNavigationUtil
	{
		
		private static const m_debugOutput:Boolean = false;
		
		public function LeafNavigationUtil()
		{
			super();
		}
		
		public static function getBestElementForSelection(param1:DisplayObject, param2:MenuElementBase, param3:MenuElementBase, param4:Number, param5:Number):MenuElementBase
		{
			var _loc6_:Rectangle = param3.getView().getBounds(param1);
			var _loc7_:Vector3D = getCenterFromBounds(_loc6_);
			if (m_debugOutput)
			{
				Log.xinfo(Log.ChannelDebug, "getBestElementForSelection startPos:" + _loc7_ + " bounds:" + _loc6_);
			}
			var _loc8_:Vector3D = new Vector3D(param4, param5);
			return LeafNavigationUtil.getBestElement(param1, _loc7_, _loc8_, param2);
		}
		
		private static function getBestElement(param1:DisplayObject, param2:Vector3D, param3:Vector3D, param4:MenuElementBase):MenuElementBase
		{
			var _loc8_:MenuElementBase = null;
			var _loc9_:Rectangle = null;
			var _loc10_:Number = NaN;
			if (m_debugOutput)
			{
				Log.xinfo(Log.ChannelDebug, "getBestElement from container");
			}
			if (param4 == null || param4.m_children == null || param4.m_children.length <= 0)
			{
				if (m_debugOutput)
				{
					Log.xinfo(Log.ChannelDebug, "getBestElement container is null or emtpy");
				}
				return null;
			}
			var _loc5_:Number = -Number.MAX_VALUE;
			var _loc6_:MenuElementBase = null;
			var _loc7_:int = 0;
			while (_loc7_ < param4.m_children.length)
			{
				if ((_loc8_ = param4.m_children[_loc7_] as MenuElementBase) != null && MenuElementBase.getNodeProp(_loc8_, "selectable") != false)
				{
					if (_loc8_.m_children != null && _loc8_.m_children.length > 0)
					{
						_loc8_ = getBestElement(param1, param2, param3, _loc8_);
					}
					if (_loc8_ != null)
					{
						_loc9_ = _loc8_.getView().getBounds(param1);
						_loc10_ = getScoreFromBounds(param2, _loc9_, param3);
						if (m_debugOutput)
						{
							Log.xinfo(Log.ChannelDebug, "getBestElement score:" + _loc10_ + " id:" + _loc8_["_nodedata"]["id"]);
						}
						if (_loc10_ > _loc5_)
						{
							_loc6_ = _loc8_;
							_loc5_ = _loc10_;
						}
					}
				}
				_loc7_++;
			}
			return _loc6_;
		}
		
		private static function getScoreFromBounds(param1:Vector3D, param2:Rectangle, param3:Vector3D):Number
		{
			var _loc4_:Vector3D = getCenterFromBounds(param2);
			return getScore(param1, _loc4_, param3);
		}
		
		private static function getCenterFromBounds(param1:Rectangle):Vector3D
		{
			var _loc2_:Vector3D = new Vector3D(param1.topLeft.x, param1.topLeft.y);
			var _loc3_:Vector3D = new Vector3D(param1.bottomRight.x, param1.bottomRight.y);
			var _loc4_:Vector3D;
			(_loc4_ = _loc3_.subtract(_loc2_)).scaleBy(0.5);
			return _loc2_.add(_loc4_);
		}
		
		private static function getScore(param1:Vector3D, param2:Vector3D, param3:Vector3D):Number
		{
			var _loc10_:Number = NaN;
			var _loc11_:Number = NaN;
			var _loc12_:Number = NaN;
			if (m_debugOutput)
			{
				Log.xinfo(Log.ChannelDebug, "getScore startPos:" + param1 + " endPos:" + param2 + " inputDir:" + param3);
			}
			var _loc4_:Vector3D;
			var _loc5_:Number = (_loc4_ = param2.subtract(param1)).length;
			var _loc6_:Number = -Number.MAX_VALUE;
			var _loc7_:Number = 0.0002;
			if (_loc5_ <= _loc7_)
			{
				return _loc6_;
			}
			var _loc8_:Vector3D;
			(_loc8_ = _loc4_.clone()).normalize();
			var _loc9_:Number = param3.dotProduct(_loc8_);
			if ((_loc9_ = Math.min(_loc9_, 1)) > 0)
			{
				_loc10_ = Math.acos(_loc9_);
				_loc11_ = Math.PI / 2 * 0.95;
				if (_loc10_ < _loc11_)
				{
					_loc12_ = 2;
					_loc6_ = 1 - (Math.abs(_loc4_.x) + Math.abs(_loc4_.y) * _loc12_);
				}
			}
			return _loc6_;
		}
	}
}
