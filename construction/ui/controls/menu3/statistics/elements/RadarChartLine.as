package menu3.statistics.elements
{
   import flash.display.CapsStyle;
   import flash.display.JointStyle;
   import flash.display.LineScaleMode;
   import flash.display.Sprite;
   
   public class RadarChartLine extends Sprite
   {
       
      
      private var size:Number = 0;
      
      public function RadarChartLine(param1:Number)
      {
         super();
         this.size = param1;
         graphics.lineStyle(1,16777215,0.5,true,LineScaleMode.NONE,CapsStyle.NONE,JointStyle.MITER,10);
         graphics.moveTo(0,-10);
         graphics.lineTo(0,-param1);
      }
   }
}
