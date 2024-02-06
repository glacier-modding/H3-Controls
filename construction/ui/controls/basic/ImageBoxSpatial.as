package basic
{
   import common.BaseControl;
   import common.ImageLoaderCache;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.text.TextFormat;
   import flash.utils.getQualifiedClassName;
   
   public class ImageBoxSpatial extends BaseControl
   {
       
      
      private var m_txtFormat:TextFormat;
      
      private var m_view:ImageBoxSpatialView;
      
      private var m_loader:Bitmap;
      
      private var m_center:Boolean;
      
      private var m_justification:int = 7;
      
      private var m_rid:String = null;
      
      private var m_isRegistered:Boolean = false;
      
      public function ImageBoxSpatial()
      {
         this.m_txtFormat = new TextFormat();
         super();
         this.m_loader = new Bitmap();
         addChild(this.m_loader);
         this.m_view = new ImageBoxSpatialView();
         this.m_view.txt_info.height *= 2;
         addChild(this.m_view);
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
      
      public function loadImage(param1:String) : void
      {
         if(this.m_isRegistered && this.m_rid == param1)
         {
            return;
         }
         this.unloadImage();
         this.m_rid = param1;
         if(this.m_rid == null)
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
         this.applyJustification();
      }
      
      private function applyCenter() : void
      {
         if(this.m_center)
         {
            this.m_loader.x = -this.m_loader.width / 2;
            this.m_loader.y = -this.m_loader.height / 2;
         }
      }
      
      private function applyJustification() : void
      {
         var _loc1_:int = this.m_justification % 3;
         var _loc2_:int = this.m_justification / 3;
         if(_loc1_ == 0)
         {
            this.m_txtFormat.align = "right";
            this.m_view.txt_info.x = this.m_loader.x - this.m_view.txt_info.width;
         }
         if(_loc1_ == 1)
         {
            this.m_txtFormat.align = "center";
            this.m_view.txt_info.x = this.m_loader.x + this.m_loader.width / 2 - this.m_view.txt_info.width / 2;
         }
         if(_loc1_ == 2)
         {
            this.m_txtFormat.align = "left";
            this.m_view.txt_info.x = this.m_loader.x + this.m_loader.width;
         }
         if(_loc2_ == 0)
         {
            this.m_view.txt_info.y = this.m_loader.y - this.m_view.txt_info.textHeight;
         }
         if(_loc2_ == 1)
         {
            this.m_view.txt_info.y = -this.m_view.txt_info.textHeight / 2;
         }
         if(_loc2_ == 2)
         {
            this.m_view.txt_info.y = this.m_loader.y + this.m_loader.height;
         }
         this.m_view.txt_info.setTextFormat(this.m_txtFormat);
      }
      
      public function onSetData(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(getQualifiedClassName(param1) == "String")
         {
            _loc2_ = param1 as String;
            if(_loc2_)
            {
               this.loadImage(_loc2_);
            }
         }
         else if(param1.id == "distance")
         {
            _loc3_ = ControlsMain.getDisplaySize() == ControlsMain.DISPLAY_SIZE_SMALL ? 24 : 12;
            this.m_txtFormat.size = _loc3_;
            _loc4_ = int(param1.distance);
            this.m_view.txt_info.visible = _loc4_ >= 0 ? true : false;
            this.m_view.txt_info.text = _loc4_.toString() + "m";
            this.m_view.txt_info.setTextFormat(this.m_txtFormat);
         }
      }
      
      public function set CenterImage(param1:Boolean) : void
      {
         this.m_center = param1;
         this.applyCenter();
         this.applyJustification();
      }
      
      public function set ScaleX(param1:Number) : void
      {
         this.scaleX = param1;
      }
      
      public function set ScaleY(param1:Number) : void
      {
         this.scaleY = param1;
      }
      
      public function set TextJustification(param1:int) : void
      {
         this.m_justification = param1;
         this.applyJustification();
      }
   }
}
