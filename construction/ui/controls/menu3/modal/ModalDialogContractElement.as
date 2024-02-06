package menu3.modal
{
   import common.Animate;
   import common.CommonUtils;
   import common.DateTimeUtils;
   import common.Localization;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   import menu3.MenuImageLoader;
   import menu3.indicator.CompletionStatusIndicatorUtil;
   import menu3.indicator.InPlaylistIndicator;
   
   public dynamic class ModalDialogContractElement extends Sprite implements ModalDialogContentInfoElementBase
   {
      
      private static const CONTRACT_FOUND_HEIGHT:int = 273;
      
      private static const CONTRACT_FOUND_ICON_INITIAL_Y:int = 125;
      
      private static const CONTRACT_FOUND_TITLE_INITIAL_Y:int = 147;
      
      private static const CONTRACT_FOUND_LINE_INITIAL_Y:int = 185.5;
      
      private static const CONTRACT_FOUND_CREATOR_INITIAL_Y:int = 190;
      
      private static const StatusIndicatorAdditionOffsetY:int = 7;
       
      
      private var m_modalDialogContractView:ModalDialogContractView;
      
      private var m_contractImageLoader:MenuImageLoader;
      
      private var m_isInPlaylist:Boolean = false;
      
      private var m_inPlaylistIndicator:InPlaylistIndicator;
      
      public function ModalDialogContractElement()
      {
         super();
         this.m_modalDialogContractView = new ModalDialogContractView();
         addChild(this.m_modalDialogContractView);
         MenuUtils.setColor(this.m_modalDialogContractView.line,MenuConstants.COLOR_WHITE,true,1);
      }
      
      public function destroy() : void
      {
         this.cleanupContractImage();
         CompletionStatusIndicatorUtil.removeIndicator(this);
         if(this.m_modalDialogContractView != null)
         {
            removeChild(this.m_modalDialogContractView);
            this.m_modalDialogContractView = null;
         }
      }
      
      public function setData(param1:Object) : void
      {
         var _loc3_:ModalDialogContractAddedToPlaylistView = null;
         var _loc2_:Boolean = !param1.hasOwnProperty("type") || param1.type == "usercreated";
         if(_loc2_)
         {
            this.setupUGCTextFields(param1.name,param1.creator,param1.id,param1.creationdate);
         }
         else
         {
            this.setupContractTextFields(param1.name,param1.description);
         }
         MenuUtils.setupIcon(this.m_modalDialogContractView.icon,param1.icon,MenuConstants.COLOR_WHITE,true,false);
         this.m_modalDialogContractView.tileIcon.visible = false;
         if(param1.image)
         {
            this.loadContractImage(param1.image);
         }
         if(param1.locked)
         {
            this.m_modalDialogContractView.tileIcon.visible = true;
            MenuUtils.setupIcon(this.m_modalDialogContractView.tileIcon,"locked",MenuConstants.COLOR_WHITE,true,false);
         }
         CompletionStatusIndicatorUtil.removeIndicator(this);
         if(Boolean(param1.completionstate) && param1.completionstate.length > 0)
         {
            CompletionStatusIndicatorUtil.addIndicator(this,param1.completionstate,CompletionStatusIndicatorUtil.StatusIndicatorOffset,CompletionStatusIndicatorUtil.StatusIndicatorOffset + StatusIndicatorAdditionOffsetY);
         }
         if(param1.addedSuccessfullyToPlaylist != undefined && param1.addedSuccessfullyToPlaylist == true)
         {
            _loc3_ = new ModalDialogContractAddedToPlaylistView();
            _loc3_.x = 351;
            _loc3_.y = 0;
            _loc3_.label.y = _loc3_.icon.y;
            _loc3_.label.text = Localization.get("UI_DIALOG_CONTRACT_SEARCH_ADDED_TO_PLAYLIST");
            Animate.addFromTo(_loc3_,MenuConstants.TabsHoverScrollTime,2,{"alpha":1},{"alpha":0},Animate.ExpoOut);
            _loc3_.icon.visible = false;
            this.m_modalDialogContractView.addChild(_loc3_);
         }
         this.m_isInPlaylist = param1.isInPlaylist === true;
      }
      
      private function setupUGCTextFields(param1:String, param2:String, param3:String, param4:String) : void
      {
         this.m_modalDialogContractView.title.autoSize = "left";
         this.m_modalDialogContractView.title.width = 366;
         this.m_modalDialogContractView.title.multiline = true;
         this.m_modalDialogContractView.title.wordWrap = true;
         MenuUtils.setupText(this.m_modalDialogContractView.title,param1,28,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         var _loc6_:String;
         var _loc5_:String = (_loc6_ = (_loc5_ = Localization.get("UI_AUTHOR_BY")).substr(0,1).toUpperCase()) + _loc5_.substr(1);
         MenuUtils.setupText(this.m_modalDialogContractView.creator,_loc5_ + " " + param2,20,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
         MenuUtils.setupText(this.m_modalDialogContractView.id,param3,20,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
         var _loc7_:Date = DateTimeUtils.parseSqlUTCTimeStamp(param4);
         var _loc8_:String = Localization.get("UI_DIALOG_CONTRACT_SEARCH_CONTRACT_CREATION_DATE") + " " + DateTimeUtils.formatLocalDateLocalized(_loc7_);
         MenuUtils.setupText(this.m_modalDialogContractView.creationdate,_loc8_,20,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
         MenuUtils.truncateTextfield(this.m_modalDialogContractView.title,4,null,CommonUtils.changeFontToGlobalIfNeeded(this.m_modalDialogContractView.title));
         MenuUtils.truncateTextfield(this.m_modalDialogContractView.creator,1,null,CommonUtils.changeFontToGlobalIfNeeded(this.m_modalDialogContractView.creator));
         MenuUtils.truncateTextfield(this.m_modalDialogContractView.id,1,null,CommonUtils.changeFontToGlobalIfNeeded(this.m_modalDialogContractView.id));
         MenuUtils.truncateTextfield(this.m_modalDialogContractView.creationdate,1,null,CommonUtils.changeFontToGlobalIfNeeded(this.m_modalDialogContractView.creationdate));
         var _loc9_:int = 1;
         if(this.m_modalDialogContractView.title.numLines > 4)
         {
            _loc9_ = 2;
         }
         this.m_modalDialogContractView.title.y = CONTRACT_FOUND_TITLE_INITIAL_Y - (this.m_modalDialogContractView.title.numLines - _loc9_) * 31;
         this.m_modalDialogContractView.icon.y = CONTRACT_FOUND_ICON_INITIAL_Y - (this.m_modalDialogContractView.title.numLines - _loc9_) * 31;
      }
      
      private function setupContractTextFields(param1:String, param2:String) : void
      {
         MenuUtils.setupText(this.m_modalDialogContractView.id,"",20,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
         MenuUtils.setupText(this.m_modalDialogContractView.creationdate,"",20,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
         this.m_modalDialogContractView.icon.y = CONTRACT_FOUND_ICON_INITIAL_Y + 50;
         this.m_modalDialogContractView.title.y = CONTRACT_FOUND_TITLE_INITIAL_Y + 50;
         this.m_modalDialogContractView.creator.y = CONTRACT_FOUND_CREATOR_INITIAL_Y + 50;
         this.m_modalDialogContractView.line.y = CONTRACT_FOUND_LINE_INITIAL_Y + 50;
         this.m_modalDialogContractView.title.autoSize = "left";
         this.m_modalDialogContractView.title.width = 366;
         this.m_modalDialogContractView.title.multiline = true;
         this.m_modalDialogContractView.title.wordWrap = true;
         MenuUtils.setupText(this.m_modalDialogContractView.title,param1,28,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         this.m_modalDialogContractView.creator.autoSize = "left";
         this.m_modalDialogContractView.creator.width = 366;
         this.m_modalDialogContractView.creator.multiline = true;
         this.m_modalDialogContractView.creator.wordWrap = true;
         MenuUtils.setupText(this.m_modalDialogContractView.creator,MenuUtils.removeHtmlLineBreaks(param2),20,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
         MenuUtils.truncateTextfield(this.m_modalDialogContractView.title,4,null,CommonUtils.changeFontToGlobalIfNeeded(this.m_modalDialogContractView.title));
         var _loc3_:int = 1;
         if(this.m_modalDialogContractView.title.numLines > 4)
         {
            _loc3_ = 2;
         }
         this.m_modalDialogContractView.title.y -= (this.m_modalDialogContractView.title.numLines - _loc3_) * 31;
         this.m_modalDialogContractView.icon.y -= (this.m_modalDialogContractView.title.numLines - _loc3_) * 31;
         var _loc4_:int = 7;
         switch(this.m_modalDialogContractView.title.numLines)
         {
            case 1:
               _loc4_ = 7;
               break;
            case 2:
               _loc4_ = 5;
               break;
            case 3:
               _loc4_ = 4;
               break;
            case 4:
               _loc4_ = 3;
               break;
            default:
               _loc4_ = 7;
         }
         MenuUtils.truncateTextfield(this.m_modalDialogContractView.creator,_loc4_,null,CommonUtils.changeFontToGlobalIfNeeded(this.m_modalDialogContractView.creator));
         var _loc5_:int = 1;
         if(this.m_modalDialogContractView.creator.numLines > _loc4_)
         {
            _loc5_ = 2;
         }
         var _loc6_:Number = (this.m_modalDialogContractView.creator.numLines - _loc5_) * 24;
         this.m_modalDialogContractView.title.y -= _loc6_;
         this.m_modalDialogContractView.icon.y -= _loc6_;
         this.m_modalDialogContractView.line.y -= _loc6_;
         this.m_modalDialogContractView.creator.y -= _loc6_;
      }
      
      private function loadContractImage(param1:String) : void
      {
         var imagePath:String = param1;
         this.cleanupContractImage();
         this.m_contractImageLoader = new MenuImageLoader();
         this.m_modalDialogContractView.image.addChild(this.m_contractImageLoader);
         this.m_contractImageLoader.center = true;
         this.m_contractImageLoader.loadImage(imagePath,function():void
         {
            var _loc4_:Number = NaN;
            MenuUtils.trySetCacheAsBitmap(m_modalDialogContractView.image,true);
            var _loc1_:Number = MenuConstants.MenuTileSmallWidth / MenuConstants.MenuTileLargeWidth;
            var _loc2_:Number = MenuConstants.MenuTileLargeWidth * _loc1_;
            var _loc3_:Number = MenuConstants.MenuTileLargeHeight * _loc1_;
            m_modalDialogContractView.image.width = _loc2_ - MenuConstants.tileImageBorder * 2;
            m_modalDialogContractView.image.height = _loc3_ - MenuConstants.tileImageBorder * 2;
            if(m_isInPlaylist)
            {
               _loc4_ = 11 + m_modalDialogContractView.image.height;
               m_inPlaylistIndicator = new InPlaylistIndicator(m_modalDialogContractView.image.width,_loc4_);
               m_inPlaylistIndicator.onSetData(m_modalDialogContractView,new Object());
            }
         });
      }
      
      private function cleanupContractImage() : void
      {
         if(this.m_contractImageLoader == null)
         {
            return;
         }
         if(this.m_inPlaylistIndicator != null)
         {
            this.m_inPlaylistIndicator.onUnregister();
            this.m_inPlaylistIndicator = null;
         }
         this.m_contractImageLoader.cancelIfLoading();
         this.m_modalDialogContractView.image.removeChild(this.m_contractImageLoader);
         this.m_contractImageLoader = null;
      }
   }
}
