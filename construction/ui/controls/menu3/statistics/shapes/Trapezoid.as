package menu3.statistics.shapes
{
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class Trapezoid extends Sprite
   {
       
      
      public function Trapezoid(param1:Point, param2:Point, param3:Point, param4:Point, param5:uint = 16711740)
      {
         super();
         graphics.beginFill(param5);
         graphics.moveTo(param1.x,param1.y);
         graphics.lineTo(param2.x,param2.y);
         graphics.lineTo(param3.x,param3.y);
         graphics.lineTo(param4.x,param4.y);
         graphics.lineTo(param1.x,param1.y);
         graphics.endFill();
      }
   }
}
