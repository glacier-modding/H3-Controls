package menu3.missionend
{
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   import menu3.MenuElementBase;
   import menu3.MenuImageLoader;
   import menu3.basic.Badge;
   
   public dynamic class MissionEndMultiplayerScore extends MenuElementBase
   {
       
      
      private var m_view:MissionEndMultiplayerScoreView;
      
      private var m_loader:MenuImageLoader;
      
      private var m_flare:MissionEndGhostFlare;
      
      private const BADGE_MAX_SIZE:Number = 136;
      
      private var m_badge:Badge;
      
      private var m_isLocalplayer:Boolean;
      
      private var m_isWinner:Boolean;
      
      private var m_isNeutral:Boolean;
      
      private var m_imagePath:String;
      
      private var m_imageIsReady:Boolean = false;
      
      private var m_imageIsWinner:Boolean = false;
      
      private var m_mask:MaskView = null;
      
      public function MissionEndMultiplayerScore(param1:Object)
      {
         super(param1);
         this.m_view = new MissionEndMultiplayerScoreView();
         this.m_view.tileBg.alpha = 0;
         this.m_view.winner.alpha = 0;
         this.m_view.winner.width = 400;
         this.m_view.winnerstar.visible = false;
         addChild(this.m_view);
         this.m_badge = new Badge();
         this.m_badge.setMaxSize(this.BADGE_MAX_SIZE);
         this.m_view.badge.badgecontainer.addChild(this.m_badge);
      }
      
      override public function onSetData(param1:Object) : void
      {
         var _loc10_:Boolean = false;
         super.onSetData(param1);
         var _loc2_:Number = param1.scale != null ? Number(param1.scale) : 1;
         this.m_view.scaleX = _loc2_;
         this.m_view.scaleY = _loc2_;
         MenuUtils.setupProfileName(this.m_view.profilename,param1.profilename,42,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         var _loc3_:* = param1.winnertext != null;
         var _loc4_:String = _loc3_ ? String(param1.winnertext) : "";
         MenuUtils.setupTextUpper(this.m_view.winner,_loc4_,26,MenuConstants.FONT_TYPE_NORMAL,!!param1.isneutral ? MenuConstants.FontColorWhite : MenuConstants.FontColorGreen);
         var _loc5_:String = param1.state != null ? String(param1.state) : "";
         MenuUtils.setupTextUpper(this.m_view.state,_loc5_,32,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         MenuUtils.addDropShadowFilter(this.m_view.state);
         if(param1.islocalplayer == true)
         {
            MenuUtils.setupTextUpper(this.m_view.scorelocal,param1.score,160,MenuConstants.FONT_TYPE_BOLD,!!param1.iswinner ? MenuConstants.FontColorWhite : (!!param1.isneutral ? MenuConstants.FontColorWhite : MenuConstants.FontColorGreyMedium));
            MenuUtils.setColor(this.m_view.profilebg,MenuConstants.COLOR_RED);
            this.m_view.winnerstar.x = 685;
            this.m_view.winner.x = !!param1.isneutral ? 703 - this.m_view.winner.textWidth : 660 - this.m_view.winner.textWidth;
            this.m_view.image.x = this.m_view.flarecontainer.x = 311.5;
            this.m_isLocalplayer = true;
         }
         else
         {
            MenuUtils.setupTextUpper(this.m_view.scoreopponent,param1.score,160,MenuConstants.FONT_TYPE_BOLD,!!param1.iswinner ? MenuConstants.FontColorWhite : (!!param1.isneutral ? MenuConstants.FontColorWhite : MenuConstants.FontColorGreyMedium));
            MenuUtils.setColor(this.m_view.profilebg,MenuConstants.COLOR_BLUE);
            this.m_view.badge.x = 567;
            this.m_view.winnerstar.x = 19;
            this.m_view.winner.x = !!param1.isneutral ? 0 : 43;
            this.m_view.image.x = this.m_view.flarecontainer.x = 391.5;
            this.m_isLocalplayer = false;
         }
         MenuUtils.setupText(this.m_view.badge.level,param1.profilelevel,18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorGreyUltraDark);
         this.m_view.badge.levelbg.width = this.m_view.badge.level.textWidth + 20;
         this.updateBadgeLevel(param1.profilelevel);
         if(param1.iswinner == true)
         {
            this.m_view.winner.alpha = 1;
            this.m_view.winnerstar.visible = _loc3_;
            this.m_view.badge.badgecontainer.alpha = 1;
            MenuUtils.removeColor(this.m_view.badge.levelbg);
            this.m_isWinner = true;
            this.m_isNeutral = false;
         }
         else if(param1.isneutral == true)
         {
            this.m_view.winner.alpha = 1;
            this.m_view.winnerstar.visible = false;
            this.m_view.badge.badgecontainer.alpha = 1;
            MenuUtils.removeColor(this.m_view.badge.levelbg);
            this.m_isWinner = true;
            this.m_isNeutral = true;
         }
         else
         {
            this.m_view.winner.alpha = 0;
            this.m_view.winnerstar.visible = false;
            this.m_view.badge.badgecontainer.alpha = 0.5;
            MenuUtils.setColor(this.m_view.badge.levelbg,MenuConstants.COLOR_GREY_MEDIUM);
            this.m_isWinner = false;
            this.m_isNeutral = false;
         }
         if(param1.image)
         {
            if(!(_loc10_ = this.loadImage(param1.image)) && this.m_imageIsReady)
            {
               if(this.m_isWinner != this.m_imageIsWinner)
               {
                  this.setImageWinnerState(this.m_isWinner);
               }
            }
         }
         else
         {
            this.unLoadImage();
         }
         if(this.m_mask != null)
         {
            this.m_view.removeChild(this.m_mask);
            this.m_mask = null;
         }
         var _loc6_:Number = Number(Number(param1.maskx) || 0);
         var _loc7_:Number = Number(Number(param1.masky) || 0);
         var _loc8_:Number = Number(Number(param1.maskwidth) || 0);
         var _loc9_:Number = Number(Number(param1.maskheight) || 0);
         if(_loc8_ > 0 || _loc9_ > 0)
         {
            this.m_mask = new MaskView();
            this.m_mask.x = _loc6_;
            this.m_mask.y = _loc7_;
            this.m_mask.width = _loc8_;
            this.m_mask.height = _loc9_;
            this.m_view.addChild(this.m_mask);
            getContainer().mask = this.m_mask;
         }
      }
      
      private function loadImage(param1:String) : Boolean
      {
         var imagePath:String = param1;
         if(this.m_imagePath == imagePath)
         {
            return false;
         }
         this.m_imagePath = imagePath;
         this.m_imageIsReady = false;
         this.unLoadImage();
         this.m_loader = new MenuImageLoader();
         this.m_view.image.addChild(this.m_loader);
         this.m_loader.center = true;
         this.m_loader.loadImage(imagePath,function():void
         {
            MenuUtils.trySetCacheAsBitmap(m_view.image,true);
            m_view.image.height = MenuConstants.MenuTileTallHeight + 3;
            m_view.image.scaleX = m_isLocalplayer ? -m_view.image.scaleY : m_view.image.scaleY;
            setImageWinnerState(m_isWinner);
            m_imageIsReady = true;
         });
         return true;
      }
      
      private function setImageWinnerState(param1:Boolean) : void
      {
         if(this.m_view.image == null)
         {
            return;
         }
         this.unloadFlare();
         if(param1)
         {
            if(!this.m_isNeutral)
            {
               this.m_flare = new MissionEndGhostFlare();
               this.m_view.flarecontainer.addChild(this.m_flare);
               this.m_view.flarecontainer.scaleX = this.m_isLocalplayer ? 2 : -2;
               this.m_view.flarecontainer.scaleY = 2;
            }
            MenuUtils.addColorFilter(this.m_view.image,[]);
         }
         else
         {
            MenuUtils.addColorFilter(this.m_view.image,[MenuConstants.COLOR_MATRIX_DARKENED_DESATURATED]);
         }
         this.m_imageIsWinner = param1;
      }
      
      private function updateBadgeLevel(param1:int) : void
      {
         this.m_badge.setLevel(param1,true,true);
      }
      
      override public function getView() : Sprite
      {
         return this.m_view.tileBg;
      }
      
      private function unLoadImage() : void
      {
         if(this.m_loader)
         {
            this.m_loader.cancelIfLoading();
            this.m_view.image.removeChild(this.m_loader);
            this.m_loader = null;
         }
         this.unloadFlare();
      }
      
      private function unloadFlare() : void
      {
         if(this.m_flare)
         {
            this.m_flare.stopAllAnimations();
            this.m_view.flarecontainer.removeChild(this.m_flare);
            this.m_flare = null;
         }
      }
      
      override public function onUnregister() : void
      {
         if(this.m_view)
         {
            super.onUnregister();
            this.unLoadImage();
            if(this.m_badge)
            {
               this.m_view.badge.badgecontainer.removeChild(this.m_badge);
               this.m_badge = null;
            }
            removeChild(this.m_view);
            this.m_view = null;
         }
      }
   }
}
