package menu3.basic
{
   import common.Animate;
   import common.ImageLoaderCache;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.setTimeout;
   
   public dynamic class OptionsInfoPreview extends OptionsInfo
   {
      
      public static const PX_PREVIEW_BACKGROUND_WIDTH:Number = 620;
       
      
      private var m_bitmap:Bitmap;
      
      private var m_previewContentContainer:Sprite;
      
      private var m_ridCurrentImage:String;
      
      private var m_ridKeepAliveImages:Vector.<String>;
      
      private var m_isImmediateLoad:Boolean = false;
      
      public function OptionsInfoPreview(param1:Object)
      {
         this.m_bitmap = new Bitmap();
         this.m_previewContentContainer = new Sprite();
         super(param1);
         this.m_bitmap.name = "m_bitmap";
         m_view.addChild(this.m_bitmap);
         this.m_previewContentContainer.name = "m_previewContentContainer";
         m_view.addChild(this.m_previewContentContainer);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onPreviewRemovedFromStage);
         this.onSetData(param1);
      }
      
      public function getPreviewContentContainer() : Sprite
      {
         return this.m_previewContentContainer;
      }
      
      public function getPreviewBackgroundImage() : Bitmap
      {
         return this.m_bitmap;
      }
      
      override public function onSetData(param1:Object) : void
      {
         var _loc3_:String = null;
         super.onSetData(param1);
         this.m_bitmap.y = m_view.paragraph.y + m_view.paragraph.textHeight + 35;
         this.m_previewContentContainer.y = this.m_bitmap.y;
         this.loadImage(param1.backgroundImage);
         var _loc2_:Vector.<String> = this.m_ridKeepAliveImages;
         if(param1.keepAliveImages)
         {
            this.m_ridKeepAliveImages = new Vector.<String>();
            for each(_loc3_ in param1.keepAliveImages)
            {
               this.m_ridKeepAliveImages.push(_loc3_);
               ImageLoaderCache.getGlobalInstance().registerLoadImage(_loc3_);
            }
         }
         else
         {
            this.m_ridKeepAliveImages = null;
         }
         if(_loc2_)
         {
            while(_loc2_.length > 0)
            {
               ImageLoaderCache.getGlobalInstance().unregisterLoadImage(_loc2_.pop());
            }
         }
      }
      
      private function loadImage(param1:String) : void
      {
         if(param1 == this.m_ridCurrentImage)
         {
            return;
         }
         if(this.m_ridCurrentImage)
         {
            ImageLoaderCache.getGlobalInstance().unregisterLoadImage(this.m_ridCurrentImage,this.onImageLoadSucceeded);
         }
         this.m_previewContentContainer.visible = false;
         this.m_ridCurrentImage = param1;
         if(this.m_ridCurrentImage)
         {
            this.onPreviewBackgroundImageLoading();
            this.m_isImmediateLoad = true;
            ImageLoaderCache.getGlobalInstance().registerLoadImage(this.m_ridCurrentImage,this.onImageLoadSucceeded);
            this.m_isImmediateLoad = false;
         }
         else
         {
            this.m_previewContentContainer.visible = true;
         }
      }
      
      private function onImageLoadSucceeded(param1:BitmapData) : void
      {
         var _loc2_:DisplayObject = null;
         if(this.m_bitmap != null)
         {
            this.m_bitmap.bitmapData = param1;
            this.m_bitmap.width = PX_PREVIEW_BACKGROUND_WIDTH;
            this.m_bitmap.scaleY = this.m_bitmap.scaleX;
            this.m_previewContentContainer.visible = true;
            if(!this.m_isImmediateLoad)
            {
               for each(_loc2_ in [this.m_previewContentContainer,this.m_bitmap])
               {
                  _loc2_.alpha = 0;
                  Animate.to(_loc2_,0.25,0,{"alpha":1},Animate.SineOut);
               }
            }
            this.onPreviewBackgroundImageLoaded();
         }
      }
      
      protected function onPreviewBackgroundImageLoading() : void
      {
      }
      
      protected function onPreviewBackgroundImageLoaded() : void
      {
      }
      
      protected function onPreviewRemovedFromStage() : void
      {
         setTimeout(function():void
         {
            loadImage(null);
            if(m_ridKeepAliveImages)
            {
               while(m_ridKeepAliveImages.length > 0)
               {
                  ImageLoaderCache.getGlobalInstance().unregisterLoadImage(m_ridKeepAliveImages.pop());
               }
            }
         },1000 / 20);
      }
   }
}
