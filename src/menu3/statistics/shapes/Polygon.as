package menu3.statistics.shapes
{
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   
   public class Polygon extends Sprite
   {
       
      
      public function Polygon(param1:Number = 100, param2:Number = 5, param3:uint = 16737792, param4:uint = 153, param5:Number = 1)
      {
         super();
         this.draw(param1,param2,param3,param4,param5);
      }
      
      protected function draw(param1:Number, param2:Number, param3:uint, param4:uint, param5:Number) : void
      {
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc6_:Array = [];
         var _loc7_:Number = 360 / param2;
         var _loc8_:Number = 0;
         graphics.clear();
         graphics.beginFill(param3,0);
         graphics.lineStyle(param5,param4,0.5);
         var _loc12_:Number = 0;
         while(_loc12_ <= 360)
         {
            _loc9_ = MenuUtils.toRadians(_loc12_);
            _loc10_ = Math.sin(_loc9_) * param1;
            _loc11_ = Math.cos(_loc9_) * param1;
            _loc6_[_loc8_] = [_loc10_,_loc11_];
            if(_loc8_ >= 1)
            {
               graphics.lineTo(_loc10_,_loc11_);
            }
            else
            {
               graphics.moveTo(_loc10_,_loc11_);
            }
            _loc8_++;
            _loc12_ += _loc7_;
         }
         graphics.endFill();
      }
   }
}
