package menu3
{
   import common.Animate;
   import common.Log;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class MenuFrameBackgroundImage extends Sprite
   {
       
      
      private const MAX_FRAMES:int = 2;
      
      private var m_currentData:BackgroundImageData;
      
      private var m_overflow:Number = 0;
      
      private var m_imageLoaders:Vector.<MenuImageLoader>;
      
      private var m_bgImages:Vector.<BackgroundImage>;
      
      private var m_currentBackgroundImageObj:Sprite;
      
      private var m_currentBackgroundInnerImageObj:Sprite;
      
      private var m_frameCount:int = 0;
      
      private var m_activeFrame:int = -1;
      
      private var m_imagesNeeded:int = 0;
      
      public function MenuFrameBackgroundImage()
      {
         this.m_currentData = new BackgroundImageData();
         this.m_imageLoaders = new Vector.<MenuImageLoader>();
         this.m_bgImages = new Vector.<BackgroundImage>();
         super();
         this.m_imageLoaders.length = this.MAX_FRAMES;
      }
      
      public function onVisibleFadeIn(param1:Number) : void
      {
         if(this.m_bgImages.length > 0)
         {
            Animate.fromTo(this.m_bgImages[0].m_bitmap,param1,0,{"alpha":0.95},{"alpha":1},Animate.Linear);
         }
      }
      
      public function setBackgroundData(param1:Object) : void
      {
         var _loc2_:BackgroundImageData = new BackgroundImageData();
         _loc2_.setData(param1);
         this.setBackgroundData_internal(_loc2_);
      }
      
      public function setBackground(param1:String, param2:Boolean = true, param3:int = 0, param4:int = 0) : void
      {
         var _loc5_:BackgroundImageData;
         (_loc5_ = new BackgroundImageData()).setSimpleImage(param1,param2,param3,param4);
         this.setBackgroundData_internal(_loc5_);
      }
      
      private function setBackgroundData_internal(param1:BackgroundImageData) : void
      {
         if(this.m_currentData.isEqual(param1))
         {
            if(this.m_bgImages.length > 0)
            {
               this.m_bgImages[0].m_bitmap.alpha = 0;
               this.m_bgImages[0].m_bitmap.alpha = 1;
            }
            return;
         }
         this.m_currentData = param1;
         var _loc2_:int = 0;
         while(_loc2_ < this.m_imageLoaders.length)
         {
            if(this.m_imageLoaders[_loc2_] != null)
            {
               this.m_imageLoaders[_loc2_].clearCallbacks();
               this.m_imageLoaders[_loc2_].cancelIfLoading();
               this.m_imageLoaders[_loc2_] = null;
            }
            _loc2_++;
         }
         if(this.m_currentData.m_imgResourceIds.length == 0)
         {
            this.removeImages();
            return;
         }
         this.m_imageLoaders[0] = new MenuImageLoader();
         this.m_imageLoaders[0].center = false;
         this.m_imageLoaders[0].loadImage(this.m_currentData.m_imgResourceIds[0],this.loadMainImageSuccess,this.loadMainImageFailed);
      }
      
      private function loadMainImageSuccess() : void
      {
         var _loc1_:BitmapData = this.m_imageLoaders[0].getImageData();
         this.setNewMainImage(_loc1_);
         this.m_imageLoaders[0] = null;
      }
      
      private function loadMainImageFailed() : void
      {
         this.removeImages();
         this.m_activeFrame = -1;
         this.m_imageLoaders[0] = null;
      }
      
      private function setNewMainImage(param1:BitmapData) : void
      {
         var prevBgImage:BackgroundImage = null;
         var targetScale:Number = NaN;
         var newWidth:Number = NaN;
         var posX:Number = NaN;
         var newHeight:Number = NaN;
         var posY:Number = NaN;
         var blendInAnimationDuration:Number = NaN;
         var bgImage:BackgroundImage = null;
         var bitmapData:BitmapData = param1;
         for each(prevBgImage in this.m_bgImages)
         {
            Animate.kill(prevBgImage.m_root);
            Animate.to(prevBgImage.m_bitmap,MenuConstants.PageOpenTime,0,{"alpha":0},Animate.ExpoInOut,function(param1:BackgroundImage):void
            {
               param1.setParent(null);
               param1.onUnregister();
            },prevBgImage);
         }
         this.m_bgImages.length = 0;
         this.createBackgroundImages(bitmapData);
         targetScale = 1.02;
         newWidth = MenuConstants.BaseWidth * targetScale;
         posX = (MenuConstants.BaseWidth - newWidth) / 2;
         newHeight = MenuConstants.BaseHeight * targetScale;
         posY = (MenuConstants.BaseHeight - newHeight) / 2;
         blendInAnimationDuration = 5;
         for each(bgImage in this.m_bgImages)
         {
            bgImage.setParent(this);
            bgImage.m_bitmap.alpha = 0;
            Animate.fromTo(bgImage.m_bitmap,MenuConstants.PageOpenTime,0,{"alpha":0},{"alpha":bgImage.m_targetAlpha},Animate.ExpoOut);
            if(!ControlsMain.isVrModeActive() && this.m_currentData.m_blendinMode == BackgroundImageData.BLENDIN_MODE_ZOOMOUT)
            {
               Animate.fromTo(bgImage.m_root,blendInAnimationDuration,0,{
                  "scaleX":targetScale,
                  "scaleY":targetScale,
                  "x":posX,
                  "y":posY
               },{
                  "scaleX":1,
                  "scaleY":1,
                  "x":0,
                  "y":0
               },Animate.ExpoOut);
            }
         }
         if(this.m_bgImages.length > 0 && this.m_currentData.m_imgResourceIds.length > 1)
         {
            Log.xinfo(Log.ChannelDebug,"delay loadAdditionalFrames");
            Animate.delay(this.m_bgImages[0].m_root,blendInAnimationDuration,this.loadAdditionalFrames);
         }
      }
      
      private function removeImages() : void
      {
         var _loc1_:BackgroundImage = null;
         for each(_loc1_ in this.m_bgImages)
         {
            Animate.kill(_loc1_.m_root);
            Animate.kill(_loc1_.m_bitmap);
            _loc1_.setParent(null);
            _loc1_.onUnregister();
         }
         this.m_bgImages.length = 0;
      }
      
      private function loadAdditionalFrames() : void
      {
         Log.xinfo(Log.ChannelDebug,"loadAdditionalFrames");
         if(this.m_currentData.m_imgResourceIds.length <= 1)
         {
            return;
         }
         var _loc1_:int = Math.min(this.m_imageLoaders.length,this.m_currentData.m_imgResourceIds.length);
         this.m_imagesNeeded = _loc1_ - 1;
         Log.xinfo(Log.ChannelDebug,"loadAdditionalFrames frameCount=" + _loc1_ + " m_imagesNeeded=" + this.m_imagesNeeded);
         if(this.m_imagesNeeded <= 0)
         {
            return;
         }
         var _loc2_:int = 1;
         while(_loc2_ < _loc1_)
         {
            this.m_imageLoaders[_loc2_] = new MenuImageLoader();
            this.m_imageLoaders[_loc2_].center = false;
            this.m_imageLoaders[_loc2_].loadImage(this.m_currentData.m_imgResourceIds[_loc2_],this.loadImageSuccess,this.loadImageFailed);
            _loc2_++;
         }
      }
      
      private function loadImageSuccess() : void
      {
         --this.m_imagesNeeded;
         Log.xinfo(Log.ChannelDebug,"loadImageSuccess m_imagesNeeded=" + this.m_imagesNeeded);
         if(this.m_imagesNeeded <= 0)
         {
            this.prepareFrames();
         }
      }
      
      private function loadImageFailed() : void
      {
         Log.xinfo(Log.ChannelDebug,"loadImageFailed");
      }
      
      private function prepareFrames() : void
      {
         var _loc2_:BitmapData = null;
         Log.xinfo(Log.ChannelDebug,"prepareFrames");
         this.m_frameCount = Math.min(this.m_imageLoaders.length,this.m_currentData.m_imgResourceIds.length);
         var _loc1_:int = 1;
         while(_loc1_ < this.m_frameCount)
         {
            _loc2_ = this.m_imageLoaders[_loc1_].getImageData();
            this.createBackgroundImages(_loc2_);
            this.m_bgImages[_loc1_].m_bitmap.alpha = 0;
            this.m_bgImages[_loc1_].setParent(this);
            this.m_imageLoaders[_loc1_] = null;
            _loc1_++;
         }
         this.m_activeFrame = 0;
         this.triggerFrameAnimation();
      }
      
      private function triggerFrameAnimation() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         Log.xinfo(Log.ChannelDebug,"startFrameAnimation");
         if(this.m_currentData.m_frameMode == BackgroundImageData.FRAME_MODE_SLOWBLEND)
         {
            _loc1_ = this.m_activeFrame;
            this.m_activeFrame = (this.m_activeFrame + 1) % this.m_frameCount;
            _loc2_ = 1;
            Animate.kill(this.m_bgImages[_loc2_].m_bitmap);
            _loc3_ = this.randomNumber(10,20);
            _loc4_ = this.randomNumber(2,12);
            if(this.m_activeFrame == 1)
            {
               Animate.to(this.m_bgImages[_loc2_].m_bitmap,_loc3_,0,{"alpha":1},Animate.ExpoOut);
               Animate.delay(this.m_bgImages[_loc2_].m_bitmap,_loc4_,this.triggerFrameAnimation);
            }
            else if(this.m_activeFrame == 0)
            {
               Animate.to(this.m_bgImages[_loc2_].m_bitmap,_loc3_,0,{"alpha":0},Animate.ExpoOut);
               Animate.delay(this.m_bgImages[_loc2_].m_bitmap,_loc4_,this.triggerFrameAnimation);
            }
         }
      }
      
      private function randomNumber(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = Math.random();
         var _loc4_:Number = param2 - param1;
         return _loc3_ * _loc4_ + param1;
      }
      
      private function createBackgroundImages(param1:BitmapData) : void
      {
         var _loc2_:int = param1.width;
         var _loc3_:int = param1.height;
         var _loc4_:Point = new Point();
         var _loc5_:Rectangle = new Rectangle(0,0,_loc2_,_loc3_);
         var _loc6_:Bitmap = new Bitmap(param1);
         MenuUtils.trySetCacheAsBitmap(_loc6_,true);
         var _loc7_:Number = 1;
         var _loc8_:BackgroundImage = new BackgroundImage(_loc6_,_loc7_);
         this.scaleAndSetPos(_loc8_.m_image,_loc2_,_loc3_);
         this.m_bgImages.push(_loc8_);
      }
      
      private function scaleAndSetPos(param1:Sprite, param2:Number, param3:Number) : void
      {
         var _loc4_:Number = 1;
         if(this.m_currentData.m_scaleFull)
         {
            _loc4_ = MenuUtils.getFillAspectScaleFull(param2,param3,MenuConstants.BaseWidth + 2 * this.m_overflow,MenuConstants.BaseHeight + 2 * this.m_overflow);
         }
         else
         {
            _loc4_ = MenuUtils.getFillAspectScale(param2,param3,MenuConstants.BaseWidth + 2 * this.m_overflow,MenuConstants.BaseHeight + 2 * this.m_overflow);
         }
         param1.scaleX = _loc4_;
         param1.scaleY = _loc4_;
         var _loc5_:Number = param2 * _loc4_;
         var _loc6_:Number = param3 * _loc4_;
         var _loc7_:Number = (MenuConstants.BaseWidth - _loc5_) / 2;
         var _loc8_:Number = (MenuConstants.BaseHeight - _loc6_) / 2;
         param1.x = _loc7_ + this.m_currentData.m_offsetX;
         param1.y = _loc8_ + this.m_currentData.m_offsetY;
      }
   }
}

class BackgroundImageData
{
   
   public static const BLENDIN_MODE_NONE:String = "none";
   
   public static const BLENDIN_MODE_ZOOMOUT:String = "zoomout";
   
   public static const BLENDIN_MODE_DEFAULT:String = BLENDIN_MODE_ZOOMOUT;
   
   public static const FRAME_MODE_NONE:String = "none";
   
   public static const FRAME_MODE_SLOWBLEND:String = "slowblend";
   
   public static const FRAME_MODE_DEFAULT:String = FRAME_MODE_NONE;
    
   
   public var m_imgResourceIds:Array;
   
   public var m_scaleFull:Boolean = true;
   
   public var m_offsetX:int = 0;
   
   public var m_offsetY:int = 0;
   
   public var m_blendinMode:String = "zoomout";
   
   public var m_frameMode:String = "none";
   
   public function BackgroundImageData()
   {
      this.m_imgResourceIds = new Array();
      super();
   }
   
   public function isEqual(param1:BackgroundImageData) : Boolean
   {
      if(this.m_imgResourceIds.length != param1.m_imgResourceIds.length || this.m_scaleFull != param1.m_scaleFull || this.m_offsetX != param1.m_offsetX || this.m_offsetY != param1.m_offsetY)
      {
         return false;
      }
      var _loc2_:int = 0;
      while(_loc2_ < this.m_imgResourceIds.length)
      {
         if(this.m_imgResourceIds[_loc2_] != param1.m_imgResourceIds[_loc2_])
         {
            return false;
         }
         _loc2_++;
      }
      return true;
   }
   
   public function setData(param1:Object) : void
   {
      this.m_imgResourceIds.length = 0;
      var _loc2_:Array = param1.frames;
      if(_loc2_ != null)
      {
         this.m_imgResourceIds = _loc2_;
      }
      else if(param1.image != null)
      {
         this.m_imgResourceIds.push(param1.image);
      }
      this.m_scaleFull = param1.scaleFull != null ? Boolean(param1.scaleFull) : true;
      this.m_offsetX = param1.m_offsetX != null ? int(param1.m_offsetX) : 0;
      this.m_offsetY = param1.m_offsetY != null ? int(param1.m_offsetY) : 0;
      this.m_blendinMode = param1.blendin != null ? String(param1.blendin) : String(BLENDIN_MODE_DEFAULT);
      this.m_frameMode = param1.framemode != null ? String(param1.framemode) : String(FRAME_MODE_DEFAULT);
   }
   
   public function setSimpleImage(param1:String, param2:Boolean = true, param3:int = 0, param4:int = 0) : void
   {
      this.m_imgResourceIds.length = 0;
      if(param1.length > 0)
      {
         this.m_imgResourceIds.push(param1);
      }
      this.m_scaleFull = param2;
      this.m_offsetX = param3;
      this.m_offsetY = param4;
      this.m_blendinMode = BLENDIN_MODE_DEFAULT;
      this.m_frameMode = FRAME_MODE_NONE;
   }
}

import common.menu.MenuConstants;
import flash.display.Bitmap;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.geom.Rectangle;

class BackgroundImage
{
    
   
   public var m_root:Sprite;
   
   public var m_image:Sprite;
   
   public var m_targetAlpha:Number;
   
   public var m_bitmap:Bitmap;
   
   public function BackgroundImage(param1:Bitmap, param2:Number)
   {
      this.m_root = new Sprite();
      this.m_image = new Sprite();
      super();
      this.m_root.scrollRect = new Rectangle(0,0,MenuConstants.BaseWidth,MenuConstants.BaseHeight);
      this.m_bitmap = param1;
      this.m_image.addChild(this.m_bitmap);
      this.m_targetAlpha = param2;
      this.m_root.addChild(this.m_image);
   }
   
   public function onUnregister() : void
   {
      this.m_image = null;
      this.m_bitmap = null;
   }
   
   public function setParent(param1:DisplayObjectContainer) : void
   {
      if(param1 != null)
      {
         param1.addChild(this.m_root);
      }
      else if(this.m_root.parent != null)
      {
         param1 = this.m_root.parent;
         param1.removeChild(this.m_root);
      }
   }
}
