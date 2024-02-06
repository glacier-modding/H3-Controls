package basic
{
   import common.Animate;
   import common.BaseControl;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import menu3.MenuImageLoader;
   
   public class BootFlowBackdropImage extends BaseControl
   {
       
      
      private var m_scrollDuration:Number;
      
      private var m_scrollDist:Number;
      
      private var m_imageBitmapData:BitmapData;
      
      private var m_imageContainer:Sprite;
      
      private var m_loader:MenuImageLoader;
      
      public function BootFlowBackdropImage()
      {
         super();
         this.m_imageContainer = new Sprite();
         addChild(this.m_imageContainer);
      }
      
      public function onSetData(param1:Object) : void
      {
         this.loadImage(param1 as String);
      }
      
      private function loadImage(param1:String) : void
      {
         var rid:String = param1;
         if(this.m_loader != null)
         {
            this.m_loader.cancelIfLoading();
            this.m_imageContainer.removeChild(this.m_loader);
            this.m_loader = null;
         }
         this.m_loader = new MenuImageLoader();
         this.m_imageContainer.addChild(this.m_loader);
         this.m_loader.center = false;
         this.m_loader.loadImage(rid,function():void
         {
            m_imageBitmapData = m_loader.getImageData();
            var _loc1_:Bitmap = new Bitmap(m_imageBitmapData);
            var _loc2_:Bitmap = new Bitmap(m_imageBitmapData);
            m_imageContainer.removeChild(m_loader);
            m_loader = null;
            m_imageContainer.addChild(_loc1_);
            m_imageContainer.addChild(_loc2_);
            _loc2_.y = m_imageBitmapData.height - 1;
            m_scrollDist = m_imageContainer.height / 4;
            goAnim();
         });
      }
      
      private function goAnim() : void
      {
         Animate.kill(this.m_imageContainer);
         Animate.fromTo(this.m_imageContainer,this.m_scrollDuration / 2,0,{"y":0},{"y":-this.m_scrollDist},Animate.Linear,function():void
         {
            Animate.fromTo(m_imageContainer,m_scrollDuration / 2,0,{"y":m_imageContainer.y},{"y":-(m_scrollDist * 2)},Animate.Linear,function():void
            {
               goAnim();
            });
         });
      }
      
      override public function getContainer() : Sprite
      {
         return this.m_imageContainer;
      }
      
      override public function onSetSize(param1:Number, param2:Number) : void
      {
         Animate.kill(this.m_imageContainer);
         MenuUtils.centerFill(this.m_imageContainer,MenuConstants.BaseWidth,MenuConstants.BaseHeight,param1,param2);
         this.goAnim();
      }
      
      public function set ScrollDuration(param1:Number) : void
      {
         this.m_scrollDuration = param1;
      }
   }
}
