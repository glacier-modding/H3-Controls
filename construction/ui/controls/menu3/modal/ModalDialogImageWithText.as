package menu3.modal
{
   import common.Log;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.text.TextField;
   import menu3.MenuImageLoader;
   
   public class ModalDialogImageWithText extends ModalDialogFrameInformation
   {
      
      public static const FRAME_REST_HEIGHT:Number = 160;
      
      public static const FRAME_HEIGHT_MIN:Number = 260;
      
      public static const FRAME_HEIGHT_MAX:Number = 768.223;
      
      public static const FRAME_WIDTH:Number = 870;
       
      
      protected var m_viewTitle:TextField;
      
      protected var m_viewDescription:TextField;
      
      protected var m_viewText:TextField;
      
      protected var m_viewFrame:Sprite;
      
      protected var m_viewImage:Sprite;
      
      private var m_imageLoader:MenuImageLoader;
      
      private var m_imageHolder:Sprite;
      
      private var m_view:ModalDialogGenericView;
      
      private var m_imageTextView:ModalDialogContentImageWithText;
      
      public function ModalDialogImageWithText(param1:Object)
      {
         param1.dialogWidth = ModalDialogImageWithText.FRAME_WIDTH;
         param1.dialogHeight = ModalDialogImageWithText.FRAME_HEIGHT_MIN;
         super(param1);
         this.createView();
      }
      
      protected function createView() : void
      {
         this.m_view = new ModalDialogGenericView();
         this.m_viewTitle = this.m_view.title;
         this.m_viewFrame = this.m_view.bg;
         MenuUtils.setColor(this.m_viewFrame,MenuConstants.COLOR_MENU_SOLID_BACKGROUND,true,1);
         this.m_imageTextView = new ModalDialogContentImageWithText();
         this.m_viewDescription = this.m_imageTextView.description;
         this.m_viewText = this.m_imageTextView.text;
         this.m_viewImage = this.m_imageTextView.image;
         MenuUtils.setColor(this.m_viewImage,MenuConstants.COLOR_MENU_SOLID_BACKGROUND,true,1);
         this.m_viewDescription.autoSize = "left";
         this.m_viewDescription.text = "";
         this.m_viewText.autoSize = "left";
         this.m_viewText.text = "";
         var _loc1_:Number = m_dialogWidth - this.m_viewFrame.width;
         this.m_viewFrame.width = m_dialogWidth;
         addChild(this.m_view);
         this.m_imageTextView.x = 0;
         this.m_imageTextView.y = this.m_view.description.y;
         this.m_view.addChild(this.m_imageTextView);
      }
      
      override public function onSetData(param1:Object) : void
      {
         var _loc2_:Number = param1.hasOwnProperty("frameheightmax") ? Number(param1.frameheightmax) : FRAME_HEIGHT_MAX;
         var _loc3_:Number = param1.hasOwnProperty("frameheightmin") ? Number(param1.frameheightmin) : FRAME_HEIGHT_MIN;
         var _loc4_:Number = this.m_viewDescription.x;
         var _loc5_:Number = this.m_viewDescription.y;
         super.onSetData(param1);
         setupTitle(this.m_viewTitle,param1);
         MenuUtils.setupText(this.m_viewDescription,param1.description,18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         setupText(this.m_viewText,param1.text);
         this.loadImage(param1.image);
         var _loc6_:Number = Math.ceil(this.m_imageTextView.height) + FRAME_REST_HEIGHT;
         m_dialogHeight = updateDialogHeight(_loc6_,_loc3_,_loc2_);
         if(_loc6_ > _loc2_)
         {
            Log.xwarning(Log.ChannelModal,"Content Height is capped by frameHeightMax!");
         }
         this.m_viewFrame.height = m_dialogHeight;
      }
      
      override public function hide() : void
      {
         this.cleanupImage();
         super.hide();
      }
      
      private function loadImage(param1:String) : void
      {
         var wantedWidth:Number = NaN;
         var wantedHeight:Number = NaN;
         var wantedX:Number = NaN;
         var wantedY:Number = NaN;
         var imagePath:String = param1;
         this.cleanupImage();
         wantedWidth = this.m_viewImage.width;
         wantedHeight = this.m_viewImage.height;
         wantedX = this.m_viewImage.x - wantedWidth / 2;
         wantedY = this.m_viewImage.y - wantedHeight / 2;
         this.m_imageLoader = new MenuImageLoader();
         this.m_imageLoader.center = false;
         this.m_imageLoader.loadImage(imagePath,function():void
         {
            var _loc1_:Bitmap = m_imageLoader.getImage();
            m_imageLoader = null;
            var _loc2_:Number = wantedWidth / _loc1_.width;
            var _loc3_:Number = wantedWidth;
            var _loc4_:Number = _loc1_.height * _loc2_;
            _loc1_.width = _loc3_;
            _loc1_.height = _loc4_;
            m_imageHolder = new Sprite();
            var _loc5_:MaskView;
            (_loc5_ = new MaskView()).width = wantedWidth;
            _loc5_.height = wantedHeight;
            m_imageHolder.addChild(_loc5_);
            m_imageHolder.mask = _loc5_;
            m_imageHolder.addChild(_loc1_);
            m_imageHolder.x = wantedX;
            m_imageHolder.y = wantedY;
            var _loc6_:int = m_imageTextView.getChildIndex(m_viewImage);
            m_imageTextView.addChildAt(m_imageHolder,_loc6_ + 1);
         });
      }
      
      private function cleanupImage() : void
      {
         if(this.m_imageLoader != null)
         {
            this.m_imageLoader.cancelIfLoading();
            this.m_imageLoader = null;
         }
         if(this.m_imageHolder != null)
         {
            this.m_imageTextView.removeChild(this.m_imageHolder);
            this.m_imageHolder = null;
         }
      }
   }
}
