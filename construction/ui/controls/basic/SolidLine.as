package basic
{
   import flash.display.Shape;
   
   public class SolidLine extends Shape
   {
      
      public static const TYPE_VERTICAL:String = "vertical";
      
      public static const TYPE_HORIZONTAL:String = "horizontal";
       
      
      private var size:Number;
      
      private var color:uint;
      
      private var thickness:Number;
      
      private var type:String;
      
      public function SolidLine(param1:Number = 100, param2:uint = 16711935, param3:Number = 1, param4:String = "horizontal")
      {
         super();
         this.size = param1;
         this.color = param2;
         this.thickness = param3;
         this.type = param4;
         if(param4 == TYPE_HORIZONTAL)
         {
            this.drawHorizontal();
         }
         else if(param4 == TYPE_VERTICAL)
         {
            this.drawVertical();
         }
      }
      
      private function drawHorizontal() : void
      {
         graphics.clear();
         graphics.beginFill(this.color,1);
         graphics.drawRect(0,0,this.size,this.thickness);
         graphics.endFill();
      }
      
      private function drawVertical() : void
      {
         graphics.clear();
         graphics.beginFill(this.color,1);
         graphics.drawRect(0,0,this.thickness,this.size);
         graphics.endFill();
      }
   }
}
