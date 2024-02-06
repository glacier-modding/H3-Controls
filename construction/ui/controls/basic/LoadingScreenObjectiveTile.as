package basic
{
   import common.CommonUtils;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import common.menu.ObjectiveUtil;
   import flash.display.Sprite;
   
   public dynamic class LoadingScreenObjectiveTile extends Sprite
   {
       
      
      private const CONTRACT_TYPE_MISSION:String = "mission";
      
      private const CONTRACT_TYPE_FLASHBACK:String = "flashback";
      
      private const CONTRACT_TYPE_ELUSIVE:String = "elusive";
      
      private const CONTRACT_TYPE_ESCALATION:String = "escalation";
      
      private const CONTRACT_TYPE_USER_CREATED:String = "usercreated";
      
      private const CONTRACT_TYPE_TUTORIAL:String = "tutorial";
      
      private const CONTRACT_TYPE_CREATION:String = "creation";
      
      private const CONTRACT_TYPE_ORBIS:String = "orbis";
      
      private const CONTRACT_TYPE_FEATURED:String = "featured";
      
      private const CONTRACT_TYPE_INVALID:String = "";
      
      private var m_contractType:String;
      
      private const CONDITION_TYPE_KILL:String = "kill";
      
      private const CONDITION_TYPE_CUSTOMKILL:String = "customkill";
      
      private const CONDITION_TYPE_DEFAULTKILL:String = "defaultkill";
      
      private const CONDITION_TYPE_SETPIECE:String = "setpiece";
      
      private const CONDITION_TYPE_CUSTOM:String = "custom";
      
      private const CONDITION_TYPE_GAMECHANGER:String = "gamechanger";
      
      private var m_view:LoadingObjectiveTileView;
      
      private var m_loader:LoadingScreenImageLoader;
      
      private var m_textObj:Object;
      
      private var m_indicatorTextObjArray:Array;
      
      private var m_pressable:Boolean = true;
      
      private var m_isLocked:Boolean = false;
      
      private var m_conditionsContainer:Array;
      
      private var m_useZoomedImage:Boolean = false;
      
      private var m_iconLabel:String;
      
      public function LoadingScreenObjectiveTile()
      {
         this.m_textObj = {};
         this.m_indicatorTextObjArray = [];
         this.m_conditionsContainer = [];
         super();
         this.m_view = new LoadingObjectiveTileView();
         this.m_view.tileBg.alpha = 0;
         this.m_view.tileDarkBg.alpha = 0.3;
         this.m_view.dropShadow.alpha = 0;
         addChild(this.m_view);
      }
      
      public function setData(param1:Object) : void
      {
         this.m_useZoomedImage = param1.useZoomedImage !== false;
         if(this.m_useZoomedImage)
         {
            MenuUtils.setColorFilter(this.m_view.image);
         }
         else
         {
            MenuUtils.setColorFilter(this.m_view.imagesmall);
         }
         MenuUtils.setColor(this.m_view.tileSelect,MenuConstants.COLOR_MENU_TABS_BACKGROUND,true,MenuConstants.MenuElementBackgroundAlpha);
         MenuUtils.setColor(this.m_view.conditionsBg,MenuConstants.COLOR_MENU_SOLID_BACKGROUND);
         if(this.m_useZoomedImage == true)
         {
            this.m_view.conditionsBg.visible = false;
         }
         this.m_iconLabel = param1.icon;
         MenuUtils.setupIcon(this.m_view.tileIcon,this.m_iconLabel,MenuConstants.COLOR_WHITE,true,false);
         if(param1.contracttype != undefined)
         {
            this.m_contractType = param1.contracttype;
         }
         this.setupTextFields(param1.header,param1.title);
         if(param1.displayaskill)
         {
            this.setConditions(ObjectiveUtil.prepareConditions([],false));
         }
         else if(param1.conditions)
         {
            this.setConditions(ObjectiveUtil.prepareConditions(param1.conditions,false));
         }
         if(param1.image)
         {
            this.loadImage(param1.image);
         }
      }
      
      private function setConditions(param1:Array) : void
      {
         var _loc5_:LoadingConditionIndicatorSmallView = null;
         this.m_conditionsContainer = [];
         var _loc2_:int = MenuConstants.ValueIndicatorHeight * 2;
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            (_loc5_ = new LoadingConditionIndicatorSmallView()).y = this.m_view.tileBg.height - MenuConstants.ValueIndicatorYOffset - _loc2_;
            if(param1[_loc4_].type == this.CONDITION_TYPE_DEFAULTKILL)
            {
               ObjectiveUtil.setupConditionIndicator(_loc5_,param1[_loc4_],this.m_indicatorTextObjArray,MenuConstants.FontColorWhite);
            }
            else if(param1[_loc4_].type == this.CONDITION_TYPE_KILL)
            {
               ObjectiveUtil.setupConditionIndicator(_loc5_,param1[_loc4_],this.m_indicatorTextObjArray,MenuConstants.FontColorWhite);
            }
            else if(param1[_loc4_].type == this.CONDITION_TYPE_SETPIECE || param1[_loc4_].type == this.CONDITION_TYPE_GAMECHANGER || param1[_loc4_].type == this.CONDITION_TYPE_CUSTOMKILL)
            {
               _loc5_.description.autoSize = "left";
               _loc5_.description.width = 276;
               _loc5_.description.multiline = true;
               _loc5_.description.wordWrap = true;
               MenuUtils.setupText(_loc5_.description,param1[_loc4_].summary,18,MenuConstants.FONT_TYPE_NORMAL,this.m_isLocked ? MenuConstants.FontColorGrey : MenuConstants.FontColorWhite);
               MenuUtils.truncateTextfield(_loc5_.description,7,this.m_isLocked ? MenuConstants.FontColorGrey : MenuConstants.FontColorWhite);
            }
            if(this.m_useZoomedImage)
            {
               MenuUtils.setupIcon(_loc5_.valueIcon,param1[_loc4_].icon,this.m_isLocked ? uint(MenuConstants.COLOR_GREY) : uint(MenuConstants.COLOR_WHITE),true,true,MenuConstants.COLOR_MENU_TABS_BACKGROUND,MenuConstants.MenuElementBackgroundAlpha);
            }
            else
            {
               MenuUtils.setupIcon(_loc5_.valueIcon,param1[_loc4_].icon,this.m_isLocked ? uint(MenuConstants.COLOR_GREY) : uint(MenuConstants.COLOR_WHITE),true,false);
            }
            if(param1[_loc4_].type == null && param1.length == 1)
            {
               if(param1[_loc4_].header)
               {
                  MenuUtils.setupText(_loc5_.header,param1[_loc4_].header,18,MenuConstants.FONT_TYPE_NORMAL,this.m_isLocked ? MenuConstants.FontColorGrey : MenuConstants.FontColorWhite);
               }
               if(param1[_loc4_].title)
               {
                  MenuUtils.setupText(_loc5_.title,param1[_loc4_].title,24,MenuConstants.FONT_TYPE_MEDIUM,this.m_isLocked ? MenuConstants.FontColorGrey : MenuConstants.FontColorWhite);
                  _loc5_.title.autoSize = "left";
                  _loc5_.title.width = 276;
                  _loc5_.title.multiline = true;
                  _loc5_.title.wordWrap = true;
                  MenuUtils.truncateTextfield(_loc5_.title,3,this.m_isLocked ? MenuConstants.FontColorGrey : MenuConstants.FontColorWhite);
               }
            }
            _loc5_.alpha = 0;
            this.m_conditionsContainer.push(_loc5_);
            if(this.m_useZoomedImage)
            {
               MenuUtils.addDropShadowFilter(_loc5_);
            }
            this.m_view.indicator.addChild(_loc5_);
            if(param1[_loc4_].type == this.CONDITION_TYPE_KILL || param1[_loc4_].type == this.CONDITION_TYPE_DEFAULTKILL)
            {
               _loc2_ -= MenuConstants.ValueIndicatorHeight + 14;
            }
            _loc4_++;
         }
         this.showConditions();
      }
      
      public function showConditions() : void
      {
         var _loc1_:int = int(this.m_conditionsContainer.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            this.m_conditionsContainer[_loc2_].alpha = 1;
            this.m_conditionsContainer[_loc2_].valueIcon.scaleX = this.m_conditionsContainer[_loc2_].valueIcon.scaleY = this.m_conditionsContainer[_loc2_].valueIcon.alpha = 1;
            if(this.m_conditionsContainer[_loc2_].description.length > 1)
            {
               this.m_conditionsContainer[_loc2_].description.alpha = 1;
            }
            else
            {
               this.m_conditionsContainer[_loc2_].header.alpha = 1;
               this.m_conditionsContainer[_loc2_].title.alpha = 1;
               this.m_conditionsContainer[_loc2_].method.alpha = 1;
            }
            _loc2_++;
         }
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
      
      private function loadImage(param1:String) : void
      {
         var imagePath:String = param1;
         if(this.m_loader != null)
         {
            this.m_loader.cancelIfLoading();
            if(this.m_useZoomedImage)
            {
               this.m_view.image.removeChild(this.m_loader);
            }
            else
            {
               this.m_view.imagesmall.removeChild(this.m_loader);
            }
            this.m_loader = null;
         }
         this.m_loader = new LoadingScreenImageLoader();
         if(this.m_useZoomedImage)
         {
            this.m_view.image.addChild(this.m_loader);
         }
         else
         {
            this.m_view.imagesmall.addChild(this.m_loader);
         }
         this.m_loader.center = true;
         this.m_loader.loadImage(imagePath,function():void
         {
            if(m_useZoomedImage)
            {
               m_view.image.cacheAsBitmap = true;
               m_view.image.height = MenuConstants.MenuTileLargeHeight;
               m_view.image.scaleX = m_view.image.scaleY;
               if(m_view.image.width < MenuConstants.MenuTileTallWidth)
               {
                  m_view.image.width = MenuConstants.MenuTileTallWidth;
                  m_view.image.scaleY = m_view.image.scaleX;
               }
            }
            else
            {
               m_view.imagesmall.cacheAsBitmap = true;
               m_view.imagesmall.height = MenuConstants.MenuTileSmallHeight;
               m_view.imagesmall.scaleX = m_view.imagesmall.scaleY;
               if(m_view.imagesmall.width < MenuConstants.MenuTileSmallWidth)
               {
                  m_view.imagesmall.width = MenuConstants.MenuTileSmallWidth;
                  m_view.imagesmall.scaleY = m_view.imagesmall.scaleX;
               }
            }
         });
      }
   }
}
