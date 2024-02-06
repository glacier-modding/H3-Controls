package basic
{
   import flash.display.BitmapData;
   import flash.display.Shape;
   import flash.geom.Rectangle;
   
   public class DottedLine extends Shape
   {
      
      public static const TYPE_VERTICAL:String = "vertical";
      
      public static const TYPE_HORIZONTAL:String = "horizontal";
       
      
      private var size:Number;
      
      private var color:uint;
      
      private var type:String;
      
      private var dotSize:Number;
      
      private var dotSpacing:Number;
      
      public function DottedLine(param1:Number = 100, param2:uint = 16711935, param3:String = "horizontal", param4:Number = 1, param5:Number = 1)
      {
         super();
         this.size = param1;
         this.color = param2;
         this.type = param3;
         this.dotSize = param4;
         this.dotSpacing = param5;
         if(param3 == TYPE_HORIZONTAL)
         {
            this.drawHorizontal();
         }
         else if(param3 == TYPE_VERTICAL)
         {
            this.drawVertical();
         }
      }
      
      private function drawHorizontal() : void
      {
         graphics.clear();
         var _loc1_:BitmapData = new BitmapData(this.dotSize + this.dotSpacing,this.dotSize);
         var _loc2_:Rectangle = new Rectangle(0,0,this.dotSize,this.dotSize);
         var _loc3_:Rectangle = new Rectangle(this.dotSize,0,this.dotSpacing,this.dotSize);
         var _loc4_:uint = this.returnARGB(this.color,255);
         _loc1_.fillRect(_loc2_,_loc4_);
         _loc1_.fillRect(_loc3_,0);
         graphics.beginBitmapFill(_loc1_);
         graphics.drawRect(0,0,this.size,this.dotSize);
         graphics.endFill();
      }
      
      private function drawVertical() : void
      {
         graphics.clear();
         var _loc1_:BitmapData = new BitmapData(this.dotSize,this.dotSize + this.dotSpacing);
         var _loc2_:Rectangle = new Rectangle(0,0,this.dotSize,this.dotSize);
         var _loc3_:Rectangle = new Rectangle(0,this.dotSize,this.dotSize,this.dotSpacing);
         var _loc4_:uint = this.returnARGB(this.color,255);
         _loc1_.fillRect(_loc2_,_loc4_);
         _loc1_.fillRect(_loc3_,0);
         graphics.beginBitmapFill(_loc1_);
         graphics.drawRect(0,0,this.dotSize,this.size);
         graphics.endFill();
      }
      
      private function returnARGB(param1:uint, param2:uint) : uint
      {
         var _loc3_:uint = 0;
         _loc3_ += param2 << 24;
         return _loc3_ + param1;
      }
   }
}
