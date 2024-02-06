package menu3.basic
{
   import common.Animate;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   import menu3.MenuElementTileBase;
   import menu3.MenuImageLoader;
   
   public dynamic class ChallengeCategoryTile extends MenuElementTileBase
   {
       
      
      private var m_view:ChallengeCategoryTileView;
      
      private var m_loader:MenuImageLoader;
      
      private var m_iconSprite:iconsAll40x40View = null;
      
      private const m_iconScale:Number = 0.8;
      
      private const m_iconPositionX:Number = 32;
      
      private const m_iconPositionY:Number = 495;
      
      public function ChallengeCategoryTile(param1:Object)
      {
         super(param1);
         this.m_view = new ChallengeCategoryTileView();
         MenuUtils.setColorFilter(this.m_view.image);
         this.m_view.tileSelect.alpha = 0;
         this.m_view.tileSelectPulsate.alpha = 0;
         this.m_view.tileBg.alpha = 0;
         this.m_view.tileDarkBg.alpha = 0.3;
         addChild(this.m_view);
      }
      
      override public function onSetData(param1:Object) : void
      {
         MenuUtils.setupIcon(this.m_view.tileIcon,param1.icon,MenuConstants.COLOR_WHITE,true,true,MenuConstants.COLOR_BLACK,0.15);
         this.setupTextFields(param1.title,param1.totalcount,param1.totalcompleted);
         this.changeTextColor(MenuConstants.COLOR_WHITE);
         if(param1.image)
         {
            this.loadImage(param1.image);
         }
         var _loc2_:int = int(param1.totalcount);
         var _loc3_:int = int(param1.totalcompleted);
         if(_loc2_ == _loc3_)
         {
            this.m_iconSprite = new iconsAll40x40View();
            this.m_iconSprite.x = this.m_iconPositionX;
            this.m_iconSprite.y = this.m_iconPositionY;
            this.m_iconSprite.scaleX = this.m_iconSprite.scaleY = this.m_iconScale;
            MenuUtils.setupIcon(this.m_iconSprite,"check",MenuConstants.COLOR_GREY_DARK,false,true,MenuConstants.COLOR_WHITE);
            addChild(this.m_iconSprite);
         }
      }
      
      override public function onUnregister() : void
      {
         if(this.m_view)
         {
            this.killAnimations();
            if(this.m_loader != null)
            {
               this.m_loader.cancelIfLoading();
               this.m_view.image.removeChild(this.m_loader);
               this.m_loader = null;
            }
            if(this.m_iconSprite)
            {
               removeChild(this.m_iconSprite);
               this.m_iconSprite = null;
            }
            removeChild(this.m_view);
            this.m_view = null;
         }
         super.onUnregister();
      }
      
      override public function getView() : Sprite
      {
         return this.m_view.tileBg;
      }
      
      public function setSelectedState(param1:Boolean) : void
      {
         Animate.complete(this.m_view.tileSelect);
         MenuUtils.pulsate(this.m_view.tileSelectPulsate,false);
         if(param1)
         {
            MenuUtils.setColorFilter(this.m_view.image,"selected");
            Animate.legacyTo(this.m_view.tileSelect,MenuConstants.HiliteTime,{"alpha":1},Animate.Linear);
            MenuUtils.pulsate(this.m_view.tileSelectPulsate,true);
         }
         else
         {
            MenuUtils.setColorFilter(this.m_view.image);
            this.m_view.tileSelect.alpha = 0;
            MenuUtils.pulsate(this.m_view.tileSelectPulsate,false);
         }
      }
      
      override protected function handleSelectionChange() : void
      {
         this.setSelectedState(m_isSelected);
      }
      
      private function setupTextFields(param1:String, param2:String, param3:String) : void
      {
         var _loc4_:* = "<font size=\'28\' >" + param3 + "</font><font size=\'16\'>/" + param2 + "</font>";
         MenuUtils.setupText(this.m_view.completionIndicator.header,_loc4_,28,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
         MenuUtils.setupText(this.m_view.title,param1,24,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorGreyUltraLight);
         MenuUtils.truncateTextfield(this.m_view.title,1);
      }
      
      private function changeTextColor(param1:uint) : void
      {
         this.m_view.title.textColor = param1;
      }
      
      private function loadImage(param1:String) : void
      {
         var imagePath:String = param1;
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
      
      private function killAnimations() : void
      {
         Animate.kill(this.m_view.tileSelect);
         MenuUtils.pulsate(this.m_view.tileSelectPulsate,false);
         Animate.kill(this.m_view.tileDarkBg);
      }
      
      private function completeAnimations() : void
      {
         Animate.complete(this.m_view.tileSelect);
         MenuUtils.pulsate(this.m_view.tileSelectPulsate,false);
         Animate.complete(this.m_view.tileDarkBg);
      }
   }
}
