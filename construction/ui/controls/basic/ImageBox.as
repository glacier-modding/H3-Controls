package basic
{
   import common.BaseControl;
   import common.ImageLoaderCache;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.Event;
   
   public class ImageBox extends BaseControl
   {
       
      
      private var m_loader:Bitmap;
      
      private var m_center:Boolean;
      
      private var m_rid:String;
      
      private var m_isVisible:Boolean;
      
      private var m_isRegistered:Boolean = false;
      
      public function ImageBox()
      {
         super();
         this.m_loader = new Bitmap();
         addChild(this.m_loader);
         this.m_isVisible = true;
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAdded);
      }
      
      private function onAdded(param1:Event) : void
      {
         this.loadImage(this.m_rid);
      }
      
      private function onRemoved(param1:Event) : void
      {
         this.unloadImage();
      }
      
      override public function onSetVisible(param1:Boolean) : void
      {
         if(this.m_isVisible == param1)
         {
            return;
         }
         this.m_isVisible = param1;
         if(!param1)
         {
            this.unloadImage();
         }
         else
         {
            this.loadImage(this.m_rid);
         }
      }
      
      public function loadImage(param1:String) : void
      {
         if(this.m_isRegistered && this.m_rid == param1)
         {
            return;
         }
         this.unloadImage();
         this.m_rid = param1;
         if(!this.m_isVisible || this.m_rid == null)
         {
            return;
         }
         var _loc2_:ImageLoaderCache = ImageLoaderCache.getGlobalInstance();
         this.m_isRegistered = true;
         _loc2_.registerLoadImage(this.m_rid,this.onSuccess,null);
      }
      
      private function unloadImage() : void
      {
         var _loc1_:ImageLoaderCache = null;
         if(this.m_isRegistered)
         {
            _loc1_ = ImageLoaderCache.getGlobalInstance();
            _loc1_.unregisterLoadImage(this.m_rid,this.onSuccess,null);
            this.m_isRegistered = false;
         }
         this.m_loader.bitmapData = null;
      }
      
      private function onSuccess(param1:BitmapData) : void
      {
         this.m_loader.bitmapData = param1;
         this.applyCenter();
      }
      
      private function applyCenter() : void
      {
         if(this.m_center)
         {
            this.m_loader.x = -this.m_loader.width / 2;
            this.m_loader.y = -this.m_loader.height / 2;
         }
      }
      
      public function onSetData(param1:Object) : void
      {
         var _loc2_:String = param1 as String;
         if(_loc2_ != null)
         {
            this.loadImage(_loc2_);
         }
      }
      
      public function set CenterImage(param1:Boolean) : void
      {
         this.m_center = param1;
         this.applyCenter();
      }
      
      public function set ScaleX(param1:Number) : void
      {
         this.scaleX = param1;
      }
      
      public function set ScaleY(param1:Number) : void
      {
         this.scaleY = param1;
      }
   }
}
