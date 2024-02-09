package menu3.modal
{
   import common.CommonUtils;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   import menu3.MenuImageLoader;
   
   public class ModalDialogDlcMissingElement extends Sprite implements ModalDialogContentInfoElementBase
   {
       
      
      private var m_dlcMissingView:ModalDialogDlcView;
      
      private var m_dlcImageLoader:MenuImageLoader;
      
      private const DLC_MISSING_HEIGHT:int = 361;
      
      private const DLC_MISSING_INITIAL_Y:int = 510;
      
      private const DLC_MISSING_INITIAL_Y_WITHOUT_CONTRACT:int = 147;
      
      private const DLC_MISSING_DESCRIPTION_SPACE:int = 3;
      
      public function ModalDialogDlcMissingElement()
      {
         super();
         this.m_dlcMissingView = new ModalDialogDlcView();
         addChild(this.m_dlcMissingView);
         MenuUtils.setColor(this.m_dlcMissingView.line,MenuConstants.COLOR_WHITE,true,1);
      }
      
      public function setData(param1:Object) : void
      {
         this.setupDlcTextFields(param1.showcreatedin,param1.episode == null ? "" : String(param1.episode),param1.location == null ? "" : String(param1.location),param1.description);
         if(param1.image)
         {
            this.loadDlcImage(param1.image);
         }
      }
      
      public function destroy() : void
      {
         this.cleanupDlcImage();
         if(this.m_dlcMissingView != null)
         {
            removeChild(this.m_dlcMissingView);
            this.m_dlcMissingView = null;
         }
      }
      
      private function setupDlcTextFields(param1:Boolean, param2:String, param3:String, param4:String) : void
      {
         this.m_dlcMissingView.title.autoSize = "left";
         this.m_dlcMissingView.title.width = 366;
         this.m_dlcMissingView.title.multiline = true;
         this.m_dlcMissingView.title.wordWrap = true;
         MenuUtils.setupText(this.m_dlcMissingView.title,param2,28,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         this.m_dlcMissingView.description.autoSize = "left";
         this.m_dlcMissingView.description.width = 366;
         this.m_dlcMissingView.description.multiline = true;
         this.m_dlcMissingView.description.wordWrap = true;
         var _loc5_:String = param1 ? param3 + "<br><br>" + param4 : param4;
         MenuUtils.setupText(this.m_dlcMissingView.description,_loc5_,20,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
         MenuUtils.truncateTextfield(this.m_dlcMissingView.title,4,null,CommonUtils.changeFontToGlobalIfNeeded(this.m_dlcMissingView.title));
         var _loc6_:int = 1;
         if(this.m_dlcMissingView.title.numLines > 4)
         {
            _loc6_ = 2;
         }
         this.m_dlcMissingView.title.y -= (this.m_dlcMissingView.title.numLines - _loc6_) * 31;
         var _loc7_:int = 12;
         switch(this.m_dlcMissingView.title.numLines + (1 - _loc6_))
         {
            case 1:
               _loc7_ = 12;
               break;
            case 2:
               _loc7_ = 11;
               break;
            case 3:
               _loc7_ = 10;
               break;
            case 4:
               _loc7_ = 9;
               break;
            default:
               _loc7_ = 12;
         }
         MenuUtils.truncateTextfield(this.m_dlcMissingView.description,_loc7_,null,CommonUtils.changeFontToGlobalIfNeeded(this.m_dlcMissingView.description));
         var _loc8_:int = 1;
         if(this.m_dlcMissingView.description.numLines > _loc7_)
         {
            _loc8_ = 2;
         }
         var _loc9_:Number = (this.m_dlcMissingView.description.numLines - _loc8_) * 24;
         this.m_dlcMissingView.title.y -= _loc9_;
         this.m_dlcMissingView.line.y -= _loc9_;
         this.m_dlcMissingView.description.y -= _loc9_;
      }
      
      private function loadDlcImage(param1:String) : void
      {
         var imagePath:String = param1;
         this.cleanupDlcImage();
         this.m_dlcImageLoader = new MenuImageLoader();
         this.m_dlcMissingView.image.addChild(this.m_dlcImageLoader);
         this.m_dlcImageLoader.center = true;
         this.m_dlcImageLoader.loadImage(imagePath,function():void
         {
            MenuUtils.trySetCacheAsBitmap(m_dlcMissingView.image,true);
            var _loc1_:Number = MenuConstants.MenuTileSmallWidth / MenuConstants.MenuTileLargeWidth;
            var _loc2_:Number = MenuConstants.MenuTileLargeWidth * _loc1_;
            var _loc3_:Number = MenuConstants.MenuTileLargeWidth * _loc1_;
            m_dlcMissingView.image.width = _loc2_ - MenuConstants.tileImageBorder * 2;
            m_dlcMissingView.image.height = _loc3_ - MenuConstants.tileImageBorder * 2;
         });
      }
      
      private function cleanupDlcImage() : void
      {
         if(this.m_dlcImageLoader == null)
         {
            return;
         }
         this.m_dlcImageLoader.cancelIfLoading();
         this.m_dlcMissingView.image.removeChild(this.m_dlcImageLoader);
         this.m_dlcImageLoader = null;
      }
   }
}
