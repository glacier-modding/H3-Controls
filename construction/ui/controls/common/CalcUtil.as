package common
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class CalcUtil
   {
       
      
      public function CalcUtil()
      {
         super();
      }
      
      public static function getCenterPosOffsetForScaledBound(param1:Rectangle, param2:Number) : Point
      {
         var _loc3_:Number = param1.width;
         var _loc4_:Number = param1.height;
         var _loc5_:Number = param1.width * param2;
         var _loc6_:Number = param1.height * param2;
         var _loc7_:Number = _loc5_ - _loc3_;
         var _loc8_:Number = _loc6_ - _loc4_;
         var _loc9_:Number = param1.x + param1.width / 2;
         var _loc10_:Number = param1.y + param1.height / 2;
         var _loc11_:Number = (0 - _loc9_) / _loc3_;
         var _loc12_:Number = (0 - _loc10_) / _loc4_;
         var _loc13_:Number = _loc11_ * _loc7_;
         var _loc14_:Number = _loc12_ * _loc8_;
         return new Point(_loc13_,_loc14_);
      }
      
      public static function createScalingAnimationParameters(param1:Point, param2:Point, param3:Rectangle, param4:Number, param5:Number) : Object
      {
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc6_:Number = 1.04;
         var _loc7_:Number = Math.abs(param2.x) > 0.001 ? param2.x : 1;
         var _loc8_:Number = Math.abs(param2.y) > 0.001 ? param2.y : 1;
         var _loc9_:Number = 1 / _loc7_;
         var _loc10_:Number = 1 / _loc8_;
         var _loc11_:Number = param3.width;
         var _loc12_:Number = param3.height;
         if(_loc11_ > 0 && _loc12_ > 0)
         {
            _loc17_ = (_loc11_ + param4 * _loc9_) / _loc11_;
            _loc18_ = (_loc12_ + param5 * _loc10_) / _loc12_;
            _loc6_ = Math.min(_loc17_,_loc18_);
         }
         var _loc13_:Point = CalcUtil.getCenterPosOffsetForScaledBound(param3,_loc6_);
         var _loc14_:Number = param1.x + _loc13_.x * _loc7_;
         var _loc15_:Number = param1.y + _loc13_.y * _loc8_;
         return {
            "scaleX":_loc6_ * _loc7_,
            "scaleY":_loc6_ * _loc8_,
            "x":_loc14_,
            "y":_loc15_
         };
      }
   }
}
