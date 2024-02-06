package menu3.basic
{
   import common.Animate;
   import common.CommonUtils;
   import common.Localization;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import common.menu.textTicker;
   import flash.display.Sprite;
   import menu3.CountDownTimer;
   import menu3.MenuElementTileBase;
   import menu3.MenuImageLoader;
   import menu3.indicator.IIndicator;
   import menu3.indicator.IndicatorUtil;
   import menu3.indicator.ItemCountIndicator;
   
   public dynamic class ItemTileSmall extends MenuElementTileBase
   {
       
      
      private var m_view:ItemTileSmallView;
      
      private var m_loader:MenuImageLoader;
      
      private var m_countDownTimer:CountDownTimer;
      
      private var m_textObj:Object;
      
      private var m_textTicker:textTicker;
      
      private var m_perkElements:Array;
      
      private var m_locked:Boolean;
      
      private var m_timed:Boolean;
      
      private var m_playableSince:String;
      
      private var m_playableUntil:String;
      
      private var m_pressable:Boolean = true;
      
      private var m_indicatorUtil:IndicatorUtil;
      
      private const EItemCountIndicator:int = 0;
      
      private var m_lockedIndicator:LockedIndicatorView;
      
      private var m_timeindicator:TimeIndicatorSmallView;
      
      private var m_infoIndicator:*;
      
      private var m_disabledIndicator:*;
      
      private var m_suitOverride:Boolean;
      
      private var m_imageSpecialSuitCrop:Boolean = false;
      
      private var m_iconLabel:String;
      
      public function ItemTileSmall(param1:Object)
      {
         this.m_textObj = {};
         this.m_perkElements = [];
         this.m_indicatorUtil = new IndicatorUtil();
         super(param1);
         this.m_view = new ItemTileSmallView();
         MenuUtils.setColorFilter(this.m_view.image);
         this.m_view.tileBg.alpha = 0;
         this.m_view.tileDarkBg.alpha = 0.3;
         this.m_view.dropShadow.alpha = 0;
         this.m_view.crossOutIcon.alpha = 0;
         addChild(this.m_view);
      }
      
      override public function onSetData(param1:Object) : void
      {
         var _loc2_:IIndicator = null;
         super.onSetData(param1);
         this.m_suitOverride = param1.suitoverride;
         this.m_imageSpecialSuitCrop = param1.specialsuitcrop;
         this.m_indicatorUtil.clearIndicators();
         MenuUtils.setColor(this.m_view.tileSelect,MenuConstants.COLOR_MENU_TABS_BACKGROUND,true,MenuConstants.MenuElementBackgroundAlpha);
         this.m_pressable = getNodeProp(this,"pressable");
         this.m_iconLabel = param1.icon;
         MenuUtils.setupIcon(this.m_view.tileIcon,this.m_iconLabel,this.m_pressable ? uint(MenuConstants.COLOR_WHITE) : uint(MenuConstants.COLOR_GREY),true,false);
         if(param1.disabledreason)
         {
            this.setupDisabledIndicator(param1.disabledreason.description,param1.disabledreason.icon,true);
         }
         if(this.m_suitOverride)
         {
            this.setupInfoIndicator(param1.suitoverrideinfo,"info",true);
         }
         this.setupTextFields(param1.header,param1.title);
         this.changeTextColor(this.m_pressable ? uint(MenuConstants.COLOR_WHITE) : uint(MenuConstants.COLOR_GREY),this.m_pressable ? uint(MenuConstants.COLOR_WHITE) : uint(MenuConstants.COLOR_GREY));
         if(param1.itemcount != undefined && param1.itemcount > 1)
         {
            _loc2_ = new ItemCountIndicator(this.m_view.tileBg.width);
            this.m_indicatorUtil.add(this.EItemCountIndicator,_loc2_,this.m_view.indicator,param1);
         }
         if(param1.playableSince)
         {
            if(!this.m_countDownTimer)
            {
               this.m_countDownTimer = new CountDownTimer();
            }
            if(this.m_countDownTimer.validateTimeStamp(param1.playableSince))
            {
               this.m_playableSince = param1.playableSince;
               this.m_timed = true;
            }
            else
            {
               this.m_countDownTimer = null;
            }
         }
         if(param1.playableUntil)
         {
            if(!this.m_countDownTimer)
            {
               this.m_countDownTimer = new CountDownTimer();
            }
            if(this.m_countDownTimer.validateTimeStamp(param1.playableUntil))
            {
               this.m_playableUntil = param1.playableUntil;
               this.m_timed = true;
            }
            else
            {
               this.m_countDownTimer = null;
            }
         }
         if(this.m_playableSince)
         {
            this.m_locked = true;
            this.m_lockedIndicator = new LockedIndicatorView();
            addChild(this.m_lockedIndicator);
            this.showTimer(this.m_playableSince,Localization.get("UI_DIALOG_TARGET_ARRIVES"));
         }
         else if(this.m_playableUntil)
         {
            this.showTimer(this.m_playableUntil,Localization.get("UI_DIALOG_TARGET_ESCAPES"));
         }
         if(param1.image)
         {
            this.loadImage(param1.image);
            if(this.m_suitOverride)
            {
               MenuUtils.setColorFilter(this.m_view.image,"desaturated");
            }
         }
         this.handleSelectionChange();
      }
      
      override public function getView() : Sprite
      {
         return this.m_view.tileBg;
      }
      
      private function setupDisabledIndicator(param1:String, param2:String, param3:Boolean) : void
      {
         var _loc8_:int = 0;
         if(this.m_disabledIndicator)
         {
            this.m_view.indicator.removeChild(this.m_disabledIndicator);
         }
         this.m_disabledIndicator = new InfoIndicatorSmallView();
         this.m_disabledIndicator.alpha = 0;
         MenuUtils.setColor(this.m_disabledIndicator.darkBg,MenuConstants.COLOR_MENU_TABS_BACKGROUND,true,param3 ? MenuConstants.MenuElementBackgroundAlpha : 0);
         var _loc4_:Number = Number(this.m_disabledIndicator.darkBg.height);
         var _loc5_:Number = Number(this.m_disabledIndicator.title.y);
         var _loc6_:Number = this.m_view.tileBg.height - MenuConstants.ValueIndicatorYOffset;
         this.m_disabledIndicator.y = _loc6_;
         this.m_disabledIndicator.title.height = _loc4_ + _loc6_ - _loc5_ * 2;
         MenuUtils.setupText(this.m_disabledIndicator.title,param1,18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         MenuUtils.shrinkTextToFit(this.m_disabledIndicator.title,this.m_disabledIndicator.title.width,this.m_disabledIndicator.title.height);
         var _loc7_:Number = this.m_disabledIndicator.title.textHeight + _loc5_ * 2;
         if(this.m_disabledIndicator.title.numLines > 2 && _loc7_ > _loc4_)
         {
            _loc8_ = Math.min(_loc7_,_loc6_ + _loc4_);
            this.m_disabledIndicator.darkBg.height += _loc8_ - _loc4_;
            this.m_disabledIndicator.y -= _loc8_ - _loc4_;
         }
         MenuUtils.setupIcon(this.m_disabledIndicator.valueIcon,param2,MenuConstants.COLOR_WHITE,true,false);
         if(!param3)
         {
            MenuUtils.addDropShadowFilter(this.m_disabledIndicator.title);
            MenuUtils.addDropShadowFilter(this.m_disabledIndicator.valueIcon);
         }
         this.m_view.indicator.addChild(this.m_disabledIndicator);
      }
      
      private function setupInfoIndicator(param1:String, param2:String, param3:Boolean) : void
      {
         var _loc4_:int = 0;
         if(this.m_infoIndicator)
         {
            this.m_view.indicator.removeChild(this.m_infoIndicator);
         }
         this.m_infoIndicator = new InfoIndicatorSmallView();
         this.m_infoIndicator.alpha = 1;
         MenuUtils.setColor(this.m_infoIndicator.darkBg,MenuConstants.COLOR_MENU_TABS_BACKGROUND,true,param3 ? MenuConstants.MenuElementBackgroundAlpha : 0);
         this.m_infoIndicator.y = this.m_view.tileBg.height - MenuConstants.ValueIndicatorYOffset;
         MenuUtils.setupText(this.m_infoIndicator.title,param1,18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         if(this.m_infoIndicator.title.numLines > 2)
         {
            _loc4_ = (this.m_infoIndicator.title.numLines - 2) * 24;
            this.m_infoIndicator.darkBg.height += _loc4_;
            this.m_infoIndicator.y -= _loc4_;
         }
         MenuUtils.setupIcon(this.m_infoIndicator.valueIcon,param2,MenuConstants.COLOR_WHITE,true,false);
         if(!param3)
         {
            MenuUtils.addDropShadowFilter(this.m_infoIndicator.title);
            MenuUtils.addDropShadowFilter(this.m_infoIndicator.valueIcon);
         }
         this.m_view.indicator.addChild(this.m_infoIndicator);
      }
      
      private function setupTextFields(param1:String, param2:String) : void
      {
         MenuUtils.setupTextUpper(this.m_view.header,param1,14,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
         MenuUtils.setupTextUpper(this.m_view.title,param2,26,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         this.m_textObj.header = this.m_view.header.htmlText;
         this.m_textObj.title = this.m_view.title.htmlText;
         MenuUtils.truncateTextfield(this.m_view.header,1,MenuConstants.FontColorWhite,CommonUtils.changeFontToGlobalIfNeeded(this.m_view.header));
         MenuUtils.truncateTextfield(this.m_view.title,1,MenuConstants.FontColorWhite,CommonUtils.changeFontToGlobalIfNeeded(this.m_view.title));
      }
      
      private function callTextTicker(param1:Boolean) : void
      {
         if(!this.m_textTicker)
         {
            this.m_textTicker = new textTicker();
         }
         if(param1)
         {
            this.m_textTicker.startTextTicker(this.m_view.title,this.m_textObj.title);
         }
         else
         {
            this.m_textTicker.stopTextTicker(this.m_view.title,this.m_textObj.title);
            MenuUtils.truncateTextfield(this.m_view.title,1,MenuConstants.FontColorWhite);
         }
      }
      
      private function changeTextColor(param1:uint, param2:uint) : void
      {
         this.m_view.header.textColor = param1;
         this.m_view.title.textColor = param2;
      }
      
      private function showText(param1:Boolean) : void
      {
         this.m_view.header.visible = param1;
         this.m_view.title.visible = param1;
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
         this.m_loader = new MenuImageLoader(ControlsMain.isVrModeActive());
         this.m_view.image.addChild(this.m_loader);
         this.m_loader.center = true;
         this.m_loader.loadImage(imagePath,function():void
         {
            var _loc1_:Number = NaN;
            var _loc2_:Number = NaN;
            var _loc3_:Number = NaN;
            var _loc4_:Number = NaN;
            var _loc5_:Number = NaN;
            var _loc6_:Number = NaN;
            var _loc7_:Number = NaN;
            Animate.legacyTo(m_view.tileDarkBg,0.3,{"alpha":0},Animate.Linear);
            MenuUtils.trySetCacheAsBitmap(m_view.image,true);
            if(m_imageSpecialSuitCrop == false)
            {
               m_view.image.height = MenuConstants.MenuTileSmallHeight;
               m_view.image.scaleX = m_view.image.scaleY;
               if(m_view.image.width < MenuConstants.MenuTileSmallWidth)
               {
                  m_view.image.width = MenuConstants.MenuTileSmallWidth;
                  m_view.image.scaleY = m_view.image.scaleX;
               }
            }
            else
            {
               _loc1_ = m_view.image.width / m_view.image.height;
               _loc2_ = m_view.image.height / 2;
               _loc3_ = 1.5;
               _loc4_ = MenuConstants.ItemTileSmallWidth / MenuConstants.MenuTileLargeWidth * _loc3_;
               _loc6_ = (_loc5_ = MenuConstants.MenuTileLargeWidth * _loc4_) / _loc1_;
               m_view.image.width = _loc5_ - MenuConstants.tileBorder * 2;
               m_view.image.height = _loc6_ - MenuConstants.tileBorder * 2;
               _loc7_ = _loc6_ / 2;
               m_view.image.y += Math.ceil(_loc2_ - _loc7_);
            }
         });
      }
      
      private function showTimer(param1:String, param2:String) : void
      {
         if(!this.m_countDownTimer)
         {
            this.m_countDownTimer = new CountDownTimer();
         }
         if(!this.m_timeindicator)
         {
            this.m_timeindicator = new TimeIndicatorSmallView();
            this.m_timeindicator.y = this.m_view.tileBg.height - MenuConstants.ValueIndicatorYOffset;
            addChild(this.m_timeindicator);
         }
         MenuUtils.setupText(this.m_timeindicator.header,param2,18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         MenuUtils.truncateTextfield(this.m_timeindicator.header,1,MenuConstants.FontColorWhite);
         this.m_countDownTimer.startCountDown(this.m_timeindicator.value,param1,this);
      }
      
      public function timerComplete() : void
      {
         this.m_countDownTimer = null;
         if(this.m_locked)
         {
            this.m_locked = false;
            removeChild(this.m_lockedIndicator);
            if(this.m_playableUntil)
            {
               this.showTimer(this.m_playableUntil,Localization.get("UI_DIALOG_TARGET_ESCAPES"));
            }
         }
         else
         {
            this.m_timed = false;
            removeChild(this.m_timeindicator);
         }
      }
      
      override protected function handleSelectionChange() : void
      {
         if(!this.m_view)
         {
            return;
         }
         Animate.complete(this.m_view);
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
               MenuUtils.setColor(this.m_view.tileSelect,MenuConstants.COLOR_RED,true,MenuConstants.MenuElementSelectedAlpha);
               MenuUtils.setupIcon(this.m_view.tileIcon,this.m_iconLabel,MenuConstants.COLOR_RED,false,true,MenuConstants.COLOR_WHITE,1,0,true);
               if(this.m_suitOverride)
               {
                  MenuUtils.setColorFilter(this.m_view.image,"desaturated");
               }
               else
               {
                  MenuUtils.setColorFilter(this.m_view.image,"selected");
               }
            }
            if(this.m_disabledIndicator)
            {
               this.m_disabledIndicator.alpha = 1;
            }
         }
         else
         {
            setPopOutScale(this.m_view,false);
            Animate.kill(this.m_view.dropShadow);
            this.m_view.dropShadow.alpha = 0;
            if(this.m_pressable)
            {
               MenuUtils.setColor(this.m_view.tileSelect,MenuConstants.COLOR_MENU_TABS_BACKGROUND,true,MenuConstants.MenuElementBackgroundAlpha);
               MenuUtils.setupIcon(this.m_view.tileIcon,this.m_iconLabel,MenuConstants.COLOR_WHITE,true,false);
               if(this.m_suitOverride)
               {
                  MenuUtils.setColorFilter(this.m_view.image,"desaturated");
               }
               else
               {
                  MenuUtils.setColorFilter(this.m_view.image);
               }
            }
            if(this.m_disabledIndicator)
            {
               this.m_disabledIndicator.alpha = 0;
            }
         }
      }
      
      override public function onUnregister() : void
      {
         var _loc1_:int = 0;
         if(this.m_view)
         {
            this.completeAnimations();
            if(this.m_countDownTimer)
            {
               this.m_countDownTimer.stopCountDown();
               this.m_countDownTimer = null;
            }
            if(this.m_loader != null)
            {
               this.m_loader.cancelIfLoading();
               this.m_view.image.removeChild(this.m_loader);
               this.m_loader = null;
            }
            if(this.m_indicatorUtil != null)
            {
               this.m_indicatorUtil.clearIndicators();
               this.m_indicatorUtil = null;
            }
            if(this.m_timeindicator)
            {
               removeChild(this.m_timeindicator);
               this.m_timeindicator = null;
            }
            if(this.m_disabledIndicator)
            {
               this.m_view.indicator.removeChild(this.m_disabledIndicator);
               this.m_disabledIndicator = null;
            }
            if(this.m_infoIndicator)
            {
               this.m_view.indicator.removeChild(this.m_infoIndicator);
               this.m_infoIndicator = null;
            }
            if(this.m_lockedIndicator)
            {
               removeChild(this.m_lockedIndicator);
               this.m_lockedIndicator = null;
            }
            if(this.m_textTicker)
            {
               this.m_textTicker.stopTextTicker(this.m_view.title,this.m_textObj.title);
               this.m_textTicker = null;
            }
            if(this.m_perkElements.length > 0)
            {
               _loc1_ = 0;
               while(_loc1_ < this.m_perkElements.length)
               {
                  removeChild(this.m_perkElements[_loc1_]);
                  this.m_perkElements[_loc1_] = null;
                  _loc1_++;
               }
               this.m_perkElements = [];
            }
            removeChild(this.m_view);
            this.m_view = null;
         }
         super.onUnregister();
      }
      
      private function completeAnimations() : void
      {
         Animate.complete(this.m_view.tileDarkBg);
      }
   }
}
