package menu3.basic
{
   import common.Animate;
   import common.CommonUtils;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   import menu3.MenuElementLockableContentBase;
   import menu3.MenuImageLoader;
   
   public dynamic class PlayerProfileTile extends MenuElementLockableContentBase
   {
       
      
      protected var m_view:*;
      
      private var m_loader:MenuImageLoader;
      
      private var m_imagePath:String = null;
      
      public function PlayerProfileTile(param1:Object)
      {
         super(param1);
         this.m_view = this.createView();
         MenuUtils.addColorFilter(this.m_view.image,[MenuConstants.COLOR_MATRIX_DEFAULT]);
         MenuUtils.setupIcon(this.m_view.tileIcon,param1.icon,MenuConstants.COLOR_GREY_ULTRA_LIGHT,true,true,MenuConstants.COLOR_BLACK,0.15);
         this.m_view.tileSelect.alpha = 0;
         this.m_view.tileSelectPulsate.alpha = 0;
         this.m_view.tileBg.alpha = 0;
         this.m_view.tileDarkBg.alpha = 0.3;
         this.m_view.dropShadow.alpha = 0;
         addChild(this.m_view);
      }
      
      protected function createView() : *
      {
         return new PlayerProfileTileView();
      }
      
      override public function onSetData(param1:Object) : void
      {
         super.onSetData(param1);
         if(getNodeProp(this,"pressable") == false)
         {
            MenuUtils.setColor(this.m_view.tileSelect,MenuConstants.COLOR_GREY_DARK,false);
            MenuUtils.setColor(this.m_view.tileSelectPulsate,MenuConstants.COLOR_GREY_DARK,false);
         }
         MenuUtils.setupText(this.m_view.header,param1.header,18,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
         MenuUtils.setupText(this.m_view.title,param1.title,24,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         MenuUtils.setupText(this.m_view.levelHeader,param1.levelHeader,24,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorGreyUltraLight);
         MenuUtils.setupText(this.m_view.levelTitle,param1.levelTitle,60,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorGreyUltraLight);
         MenuUtils.setupText(this.m_view.levelValue,param1.levelValue,28,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorGreyUltraLight);
         CommonUtils.changeFontToGlobalIfNeeded(this.m_view.levelHeader);
         MenuUtils.shrinkTextToFit(this.m_view.levelHeader,this.m_view.levelHeader.width,-1);
         if(param1.image)
         {
            this.loadImage(param1.image);
         }
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
      
      override public function getView() : Sprite
      {
         return this.m_view.tileBg;
      }
      
      override protected function handleSelectionChange() : void
      {
         super.handleSelectionChange();
         Animate.complete(this.m_view.tileSelect);
         MenuUtils.pulsate(this.m_view.tileSelectPulsate,false);
         if(m_loading)
         {
            return;
         }
         if(m_isSelected)
         {
            setPopOutScale(this.m_view,true);
            Animate.to(this.m_view.dropShadow,0.3,0,{"alpha":1},Animate.ExpoOut);
            Animate.to(this.m_view.tileSelect,MenuConstants.HiliteTime,0,{"alpha":1},Animate.Linear);
            MenuUtils.pulsate(this.m_view.tileSelectPulsate,true);
         }
         else
         {
            setPopOutScale(this.m_view,false);
            Animate.kill(this.m_view.dropShadow);
            this.m_view.dropShadow.alpha = 0;
            this.m_view.tileSelect.alpha = 0;
            MenuUtils.pulsate(this.m_view.tileSelectPulsate,false);
         }
      }
      
      override public function onUnregister() : void
      {
         if(this.m_view)
         {
            super.onUnregister();
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
      }
      
      private function completeAnimations() : void
      {
         Animate.complete(this.m_view.tileDarkBg);
         Animate.complete(this.m_view.tileSelect);
         MenuUtils.pulsate(this.m_view.tileSelectPulsate,false);
         if(m_infoIndicator != null)
         {
            Animate.complete(m_infoIndicator);
         }
      }
   }
}
