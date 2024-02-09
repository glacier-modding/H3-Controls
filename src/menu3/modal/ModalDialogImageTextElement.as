package menu3.modal
{
   import common.CommonUtils;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   import menu3.MenuImageLoader;
   
   public class ModalDialogImageTextElement extends Sprite implements ModalDialogContentInfoElementBase
   {
       
      
      private var m_dialogDlcView:ModalDialogDlcView;
      
      private var m_imageLoader:MenuImageLoader;
      
      private const DLC_MISSING_HEIGHT:int = 361;
      
      private const DLC_MISSING_INITIAL_Y:int = 510;
      
      private const DLC_MISSING_INITIAL_Y_WITHOUT_CONTRACT:int = 147;
      
      private const DLC_MISSING_DESCRIPTION_SPACE:int = 3;
      
      public function ModalDialogImageTextElement()
      {
         super();
         this.m_dialogDlcView = new ModalDialogDlcView();
         addChild(this.m_dialogDlcView);
      }
      
      public function setData(param1:Object) : void
      {
         this.setupText(param1.header,param1.description);
         if(param1.image)
         {
            this.loadImage(param1.image);
         }
      }
      
      public function destroy() : void
      {
         this.cleanupImage();
         if(this.m_dialogDlcView != null)
         {
            removeChild(this.m_dialogDlcView);
            this.m_dialogDlcView = null;
         }
      }
      
      private function setupText(param1:String, param2:String) : void
      {
         if(param1 != null && param1 != "")
         {
            this.m_dialogDlcView.title.autoSize = "left";
            this.m_dialogDlcView.title.width = 366;
            this.m_dialogDlcView.title.multiline = true;
            this.m_dialogDlcView.title.wordWrap = true;
            MenuUtils.setupText(this.m_dialogDlcView.title,param1,28,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
            this.m_dialogDlcView.line.visible = true;
         }
         else
         {
            this.m_dialogDlcView.line.visible = false;
         }
         if(param2 != null && param2 != "")
         {
            this.m_dialogDlcView.description.autoSize = "left";
            this.m_dialogDlcView.description.width = 366;
            this.m_dialogDlcView.description.multiline = true;
            this.m_dialogDlcView.description.wordWrap = true;
            MenuUtils.setupText(this.m_dialogDlcView.description,param2,20,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
         }
         MenuUtils.truncateTextfield(this.m_dialogDlcView.title,4,null,CommonUtils.changeFontToGlobalIfNeeded(this.m_dialogDlcView.title));
         var _loc3_:int = 1;
         if(this.m_dialogDlcView.title.numLines > 4)
         {
            _loc3_ = 2;
         }
         this.m_dialogDlcView.title.y -= (this.m_dialogDlcView.title.numLines - _loc3_) * 31;
         var _loc4_:int = 12;
         switch(this.m_dialogDlcView.title.numLines + (1 - _loc3_))
         {
            case 1:
               _loc4_ = 12;
               break;
            case 2:
               _loc4_ = 11;
               break;
            case 3:
               _loc4_ = 10;
               break;
            case 4:
               _loc4_ = 9;
               break;
            default:
               _loc4_ = 12;
         }
         MenuUtils.truncateTextfield(this.m_dialogDlcView.description,_loc4_,null,CommonUtils.changeFontToGlobalIfNeeded(this.m_dialogDlcView.description));
         var _loc5_:int = 1;
         if(this.m_dialogDlcView.description.numLines > _loc4_)
         {
            _loc5_ = 2;
         }
         var _loc6_:Number = (this.m_dialogDlcView.description.numLines - _loc5_) * 24;
         this.m_dialogDlcView.title.y -= _loc6_;
         this.m_dialogDlcView.line.y -= _loc6_;
         this.m_dialogDlcView.description.y -= _loc6_;
      }
      
      private function loadImage(param1:String) : void
      {
         var imagePath:String = param1;
         this.cleanupImage();
         this.m_imageLoader = new MenuImageLoader();
         this.m_dialogDlcView.image.addChild(this.m_imageLoader);
         this.m_imageLoader.center = true;
         this.m_imageLoader.loadImage(imagePath,function():void
         {
            MenuUtils.trySetCacheAsBitmap(m_dialogDlcView.image,true);
            var _loc1_:Number = MenuConstants.MenuTileSmallWidth / MenuConstants.MenuTileLargeWidth;
            var _loc2_:Number = MenuConstants.MenuTileLargeWidth * _loc1_;
            var _loc3_:Number = MenuConstants.MenuTileLargeWidth * _loc1_;
            m_dialogDlcView.image.width = _loc2_ - MenuConstants.tileImageBorder * 2;
            m_dialogDlcView.image.height = _loc3_ - MenuConstants.tileImageBorder * 2;
         });
      }
      
      private function cleanupImage() : void
      {
         if(this.m_imageLoader == null)
         {
            return;
         }
         this.m_imageLoader.cancelIfLoading();
         this.m_dialogDlcView.image.removeChild(this.m_imageLoader);
         this.m_imageLoader = null;
      }
   }
}
