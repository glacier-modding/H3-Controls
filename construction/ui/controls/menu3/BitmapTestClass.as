package menu3
{
   import common.BaseControl;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class BitmapTestClass extends BaseControl
   {
       
      
      private var source:BitmapData;
      
      private var target:BitmapData;
      
      public function BitmapTestClass()
      {
         super();
         this.source = new BitmapData(300,300,false);
         this.source.fillRect(this.source.rect,16711680);
         addChild(new Bitmap(this.source));
      }
      
      private function cropImage(param1:BitmapData, param2:Rectangle) : BitmapData
      {
         var _loc3_:BitmapData = new BitmapData(param2.width,param2.height,param1.transparent);
         _loc3_.copyPixels(param1,param2,new Point());
         return _loc3_;
      }
   }
}
