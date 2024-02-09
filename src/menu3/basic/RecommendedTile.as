package menu3.basic
{
   import common.Animate;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   import menu3.MenuElementLockableContentBase;
   import menu3.MenuImageLoader;
   
   public dynamic class RecommendedTile extends MenuElementLockableContentBase
   {
       
      
      protected var m_view:RecommendedTileView;
      
      private var m_loader:MenuImageLoader;
      
      private var m_imagePath:String = null;
      
      private var m_pressable:Boolean = true;
      
      private var m_isLocked:Boolean = false;
      
      private var m_iconLabel:String;
      
      private var m_textTickerUtil:TextTickerUtil;
      
      public function RecommendedTile(param1:Object)
      {
         this.m_textTickerUtil = new TextTickerUtil();
         super(param1);
         this.m_view = this.createView();
         this.m_view.tileBg.alpha = 0;
         this.m_view.tileDarkBg.alpha = 0;
         this.m_view.dropShadow.alpha = 0;
         addChild(this.m_view);
      }
      
      protected function createView() : *
      {
         return new RecommendedTileView();
      }
      
      override public function getView() : Sprite
      {
         return this.m_view.tileBg;
      }
      
      override public function onSetData(param1:Object) : void
      {
         super.onSetData(param1);
         this.m_pressable = Boolean(getNodeProp(this,"pressable"));
         this.m_isLocked = Boolean(param1.islocked);
         this.m_iconLabel = param1.icon;
         MenuUtils.setupTextUpper(this.m_view.title,param1.title,24,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         this.m_textTickerUtil.addTextTicker(this.m_view.title,this.m_view.title.htmlText);
         MenuUtils.truncateTextfield(this.m_view.title,1,MenuConstants.FontColorWhite);
         if(param1.image)
         {
            this.loadImage(param1.image);
         }
         MenuUtils.removeColor(this.m_view.tileIcon);
         MenuUtils.setupIcon(this.m_view.tileIcon,this.m_iconLabel,MenuConstants.COLOR_WHITE,true,false);
         this.handleSelectionChange();
      }
      
      private function callTextTicker(param1:Boolean) : void
      {
         this.m_textTickerUtil.callTextTicker(param1,this.m_view.title.textColor);
      }
      
      private function changeTextColor(param1:uint) : void
      {
         this.m_view.title.textColor = param1;
      }
      
      private function loadImage(param1:String) : void
      {
         var imagePath:String = param1;
         if(this.m_imagePath == imagePath)
         {
            return;
         }
         this.m_imagePath = imagePath;
         if(this.m_loader != null)
         {
            this.m_loader.cancelIfLoading();
            this.m_view.image.removeChild(this.m_loader);
            this.m_loader = null;
         }
         this.m_loader = new MenuImageLoader();
         this.m_view.image.addChild(this.m_loader);
         this.m_loader.center = true;
         this.m_loader.loadImage(imagePath,function():void
         {
            Animate.legacyTo(m_view.tileDarkBg,0.3,{"alpha":0},Animate.Linear);
            MenuUtils.trySetCacheAsBitmap(m_view.image,true);
            m_view.image.height = MenuConstants.MenuTileLargeHeight;
            m_view.image.scaleX = m_view.image.scaleY;
            if(m_view.image.width < MenuConstants.MenuTileTallWidth)
            {
               m_view.image.width = MenuConstants.MenuTileTallWidth;
               m_view.image.scaleY = m_view.image.scaleX;
            }
         });
      }
      
      override protected function handleSelectionChange() : void
      {
         super.handleSelectionChange();
         Animate.complete(this.m_view.tileSelect);
         if(m_loading)
         {
            return;
         }
         if(m_isSelected)
         {
            setPopOutScale(this.m_view,true);
            Animate.to(this.m_view.dropShadow,0.3,0,{"alpha":1},Animate.ExpoOut);
            if(this.m_pressable)
            {
               this.changeTextColor(MenuConstants.COLOR_WHITE);
               MenuUtils.setColor(this.m_view.tileSelect,MenuConstants.COLOR_RED,true,MenuConstants.MenuElementSelectedAlpha);
               MenuUtils.setupIcon(this.m_view.tileIcon,this.m_iconLabel,MenuConstants.COLOR_RED,false,true,MenuConstants.COLOR_WHITE,1,0,true);
            }
            this.callTextTicker(true);
         }
         else
         {
            setPopOutScale(this.m_view,false);
            Animate.kill(this.m_view.dropShadow);
            this.m_view.dropShadow.alpha = 0;
            if(this.m_pressable)
            {
               this.changeTextColor(MenuConstants.COLOR_WHITE);
               MenuUtils.setColor(this.m_view.tileSelect,MenuConstants.COLOR_MENU_TABS_BACKGROUND,true,MenuConstants.MenuElementBackgroundAlpha);
               if(this.m_isLocked)
               {
                  this.changeTextColor(MenuConstants.COLOR_GREY);
                  MenuUtils.setupIcon(this.m_view.tileIcon,this.m_iconLabel,MenuConstants.COLOR_GREY,true,false);
               }
               else
               {
                  MenuUtils.setupIcon(this.m_view.tileIcon,this.m_iconLabel,MenuConstants.COLOR_WHITE,true,false);
               }
            }
            this.callTextTicker(false);
         }
      }
      
      override public function onUnregister() : void
      {
         if(this.m_view)
         {
            this.callTextTicker(false);
            this.completeAnimations();
            if(this.m_loader)
            {
               this.m_loader.cancelIfLoading();
               this.m_view.image.removeChild(this.m_loader);
               this.m_loader = null;
            }
            removeChild(this.m_view);
            this.m_view = null;
         }
         super.onUnregister();
      }
      
      private function completeAnimations() : void
      {
         Animate.complete(this.m_view.tileDarkBg);
         Animate.complete(this.m_view.tileSelect);
      }
   }
}
