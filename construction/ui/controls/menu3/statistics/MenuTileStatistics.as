package menu3.statistics
{
   import common.Animate;
   import common.Localization;
   import common.TaskletSequencer;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import menu3.MenuElementTileBase;
   
   public dynamic class MenuTileStatistics extends MenuElementTileBase
   {
      
      private static var s_tilesReadyToShow:Vector.<MenuTileStatistics> = new Vector.<MenuTileStatistics>(0);
      
      {
         TaskletSequencer.getGlobalInstance().addEventListener(TaskletSequencer.COMPLETE,function():void
         {
            if(s_tilesReadyToShow.length > 0)
            {
               dequeueNextTile(s_tilesReadyToShow);
               s_tilesReadyToShow = new Vector.<MenuTileStatistics>(0);
            }
         });
      }
      
      private var m_view:MenuTileStatisticsView;
      
      private var m_locationImages:LocationImage;
      
      private var m_statBars:StatisticBars;
      
      private var m_opportunityBarView:StatisticBarSmallView;
      
      private var m_opportunityBar:StatisticBar;
      
      private var m_masteryLevelChart:MasteryLevelChart;
      
      private var m_textfieldCollection:Vector.<TextField>;
      
      private var m_iconCollection:Vector.<MovieClip>;
      
      private var m_data:Object;
      
      private var m_isCompleted:Boolean;
      
      private var m_pressable:Boolean = true;
      
      private var m_isInitialized:Boolean = false;
      
      private var m_isAvailable:Boolean = false;
      
      private var m_isMasteryAvailable:Boolean = false;
      
      public function MenuTileStatistics(param1:Object)
      {
         this.m_data = {};
         super(param1);
         this.m_data = param1;
         this.m_isCompleted = this.m_data.completionValue == 100;
         this.m_view = new MenuTileStatisticsView();
         this.m_view.tileBg.alpha = 0;
         this.m_view.dropShadow.alpha = 0;
         this.m_view.tileContent.alpha = 0;
         MenuUtils.setColor(this.m_view.tileDarkBg,MenuConstants.COLOR_MENU_BUTTON_TILE_DESELECTED);
         MenuUtils.setupText(this.m_view.tileHeader,"",12,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         MenuUtils.setupText(this.m_view.tileTitle,"",26,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         MenuUtils.setupText(this.m_view.tileContent.completionTitle,"",20,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorGrey);
         MenuUtils.setupText(this.m_view.tileContent.completionValue,"",90,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         MenuUtils.setupText(this.m_view.tileContent.challengesTitle,"",20,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         MenuUtils.setupText(this.m_view.tileContent.masteryTitle,"",20,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         addChild(this.m_view);
      }
      
      private static function dequeueNextTile(param1:Vector.<MenuTileStatistics>) : void
      {
         var _loc2_:MenuTileStatistics = null;
         if(param1.length > 0)
         {
            _loc2_ = param1.shift();
            Animate.to(_loc2_.m_view.tileContent,0.05,0,{"alpha":1},Animate.Linear,dequeueNextTile,param1);
         }
      }
      
      override public function onSetData(param1:Object) : void
      {
         var ts:TaskletSequencer;
         var isAvailable:Boolean;
         var isMasteryAvailable:Boolean;
         var availableChanged:Boolean = false;
         var masteryAvailabilityChanged:Boolean = false;
         var self:MenuTileStatistics = null;
         var data:Object = param1;
         super.onSetData(data);
         ts = TaskletSequencer.getGlobalInstance();
         this.m_data = data;
         isAvailable = Boolean(this.m_data.isAvailable);
         availableChanged = this.m_isAvailable != isAvailable;
         this.m_isAvailable = isAvailable;
         isMasteryAvailable = this.m_data.hideMastery === false;
         masteryAvailabilityChanged = this.m_isMasteryAvailable != isMasteryAvailable;
         this.m_isMasteryAvailable = isMasteryAvailable;
         if(!this.m_isAvailable)
         {
            this.m_data.completionValue = 0;
         }
         this.m_pressable = true;
         if(getNodeProp(this,"pressable") == false)
         {
            this.m_pressable = false;
         }
         this.m_iconCollection = new <MovieClip>[this.m_view.tileIcon,this.m_view.tileContent.challengesIcon,this.m_view.tileContent.masteryIcon];
         this.m_textfieldCollection = new <TextField>[this.m_view.tileHeader,this.m_view.tileTitle,this.m_view.tileContent.completionTitle,this.m_view.tileContent.completionValue,this.m_view.tileContent.challengesTitle,this.m_view.tileContent.masteryTitle];
         MenuUtils.setupIcon(this.m_view.tileIcon,this.m_data.tileIcon,MenuConstants.COLOR_WHITE,true,false);
         MenuUtils.setupIcon(this.m_view.tileContent.challengesIcon,this.m_data.challenges.challengesIcon,MenuConstants.COLOR_WHITE,false,true,MenuConstants.COLOR_WHITE,1,0,true);
         MenuUtils.setupIcon(this.m_view.tileContent.masteryIcon,this.m_data.masteryIcon,MenuConstants.COLOR_WHITE,false,true,MenuConstants.COLOR_WHITE,1,0,true);
         this.m_view.tileHeader.htmlText = this.m_data.tileHeader.toUpperCase();
         this.m_view.tileTitle.htmlText = this.m_data.tileTitle.toUpperCase();
         this.m_view.tileContent.completionTitle.htmlText = this.m_data.completionTitle.toUpperCase();
         this.m_view.tileContent.completionValue.htmlText = Math.floor(this.m_data.completionValue) + "%";
         this.m_view.tileContent.masteryTitle.htmlText = this.m_data.masteryTitle.toUpperCase();
         ts.addChunk(function():void
         {
            if(!m_isInitialized || availableChanged)
            {
               initImage({"tileImage":m_data.tileImage});
               initStatisticBars(m_data.challenges.statistics);
               initOpportunityBar(m_data.opportunities);
            }
         });
         ts.addChunk(function():void
         {
            if(!m_isInitialized || masteryAvailabilityChanged || availableChanged)
            {
               initMasteryLevelChart(m_data.mastery);
            }
         });
         ts.addChunk(function():void
         {
            if(!m_isCompleted)
            {
               if(!m_isInitialized)
               {
                  animateIcons(new <MovieClip>[m_view.tileIcon,m_view.tileContent.challengesIcon,m_view.tileContent.masteryIcon]);
                  showTexts(new <TextField>[m_view.tileHeader,m_view.tileTitle,m_view.tileContent.challengesTitle,m_view.tileContent.masteryTitle],true);
                  if(!m_isAvailable)
                  {
                     m_view.tileContent.completionTitle.alpha = 0;
                     m_view.tileContent.completionValue.alpha = 0;
                  }
                  else
                  {
                     showTexts(new <TextField>[m_view.tileContent.completionTitle,m_view.tileContent.completionValue],true);
                  }
               }
               if(!m_isAvailable)
               {
                  Animate.kill(m_view.tileContent.completionTitle);
                  Animate.kill(m_view.tileContent.completionValue);
                  m_view.tileContent.completionTitle.alpha = 0;
                  m_view.tileContent.completionValue.alpha = 0;
               }
            }
            else
            {
               showTexts(new <TextField>[m_view.tileHeader,m_view.tileTitle,m_view.tileContent.completionTitle,m_view.tileContent.completionValue,m_view.tileContent.challengesTitle,m_view.tileContent.masteryTitle],false);
            }
         });
         self = this;
         ts.addChunk(function():void
         {
            handleSelectionChange();
            m_isInitialized = true;
            s_tilesReadyToShow.push(self);
         });
      }
      
      override public function getView() : Sprite
      {
         return this.m_view.tileBg;
      }
      
      override protected function handleSelectionChange() : void
      {
         super.handleSelectionChange();
         if(m_loading)
         {
            return;
         }
         if(m_isSelected)
         {
            setPopOutScale(this.m_view,true);
            Animate.to(this.m_view.dropShadow,0.3,0,{"alpha":1},Animate.ExpoOut);
            MenuUtils.setColor(this.m_view.tileSelectionHeader,MenuConstants.COLOR_RED,true,MenuConstants.MenuElementSelectedAlpha);
            MenuUtils.setupIcon(this.m_view.tileIcon,this.m_data.tileIcon,MenuConstants.COLOR_RED,false,true,MenuConstants.COLOR_WHITE,1,0,true);
         }
         else
         {
            setPopOutScale(this.m_view,false);
            Animate.kill(this.m_view.dropShadow);
            this.m_view.dropShadow.alpha = 0;
            MenuUtils.setColor(this.m_view.tileSelectionHeader,MenuConstants.COLOR_MENU_TABS_BACKGROUND,true,MenuConstants.MenuElementBackgroundAlpha);
            MenuUtils.setupIcon(this.m_view.tileIcon,this.m_data.tileIcon,MenuConstants.COLOR_WHITE,true,false);
         }
      }
      
      override public function onUnregister() : void
      {
         if(this.m_view)
         {
            this.killAnimations();
            if(this.m_locationImages)
            {
               this.m_locationImages.destroy();
               this.m_locationImages = null;
            }
            this.removeStatisticBars();
            this.removeMasteryLevelChart();
            this.removeOpportunityBar();
            removeChild(this.m_view);
            this.m_view = null;
         }
         var _loc1_:int = s_tilesReadyToShow.indexOf(this);
         if(_loc1_ >= 0)
         {
            s_tilesReadyToShow.splice(_loc1_,1);
         }
         super.onUnregister();
      }
      
      private function killAnimations() : void
      {
         var _loc1_:int = 0;
         if(this.m_iconCollection != null)
         {
            _loc1_ = 0;
            while(_loc1_ < this.m_iconCollection.length)
            {
               Animate.kill(this.m_iconCollection[_loc1_]);
               _loc1_++;
            }
         }
         if(this.m_textfieldCollection != null)
         {
            _loc1_ = 0;
            while(_loc1_ < this.m_textfieldCollection.length)
            {
               Animate.kill(this.m_textfieldCollection[_loc1_]);
               _loc1_++;
            }
         }
      }
      
      private function getAvailabilityAlpha() : Number
      {
         return this.m_isAvailable ? 1 : 0.5;
      }
      
      private function showTexts(param1:Vector.<TextField>, param2:Boolean = true) : void
      {
         var _loc3_:Number = 0;
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            if(param2 && !this.m_isInitialized)
            {
               param1[_loc4_].alpha = 0;
               this.startTextAnimation(param1[_loc4_],_loc3_);
               _loc3_ += 0.05;
            }
            else if(param1[_loc4_] == this.m_view.tileHeader || param1[_loc4_] == this.m_view.tileTitle)
            {
               param1[_loc4_].alpha = 1;
            }
            else
            {
               param1[_loc4_].alpha = this.getAvailabilityAlpha();
            }
            _loc4_++;
         }
      }
      
      private function startTextAnimation(param1:TextField, param2:Number) : void
      {
         if(param1 == this.m_view.tileHeader || param1 == this.m_view.tileTitle)
         {
            Animate.to(param1,0.75,param2,{"alpha":1},Animate.ExpoOut);
         }
         else
         {
            Animate.to(param1,0.75,param2,{"alpha":this.getAvailabilityAlpha()},Animate.ExpoOut);
         }
      }
      
      private function animateIcons(param1:Vector.<MovieClip>) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(!m_isSelected && !this.m_isInitialized)
            {
               _loc2_ = Number(param1[_loc3_].icons.scaleX);
               param1[_loc3_].icons.scaleX = param1[_loc3_].icons.scaleY = 0;
               Animate.from(param1[_loc3_].bg,0.3,0,{
                  "scaleX":0.2,
                  "scaleY":0.2
               },Animate.ExpoOut);
               Animate.to(param1[_loc3_].icons,0.3,0.2,{
                  "scaleX":_loc2_,
                  "scaleY":_loc2_
               },Animate.ExpoOut);
            }
            _loc3_++;
         }
      }
      
      private function initImage(param1:Object) : void
      {
         param1.completionValue = this.m_data.completionValue;
         this.m_locationImages = new LocationImage(param1);
         this.m_locationImages.x = 16;
         this.m_locationImages.y = 295;
         this.m_view.tileContent.addChild(this.m_locationImages);
      }
      
      private function initStatisticBars(param1:Object) : void
      {
         param1.completionValue = this.m_data.completionValue;
         param1.isAvailable = this.m_isAvailable;
         this.removeStatisticBars();
         this.m_statBars = new StatisticBars(param1);
         this.m_statBars.x = 16;
         this.m_statBars.y = 370;
         this.m_view.tileContent.addChild(this.m_statBars);
      }
      
      private function removeStatisticBars() : void
      {
         if(this.m_statBars == null)
         {
            return;
         }
         this.m_view.tileContent.removeChild(this.m_statBars);
         this.m_statBars.destroy();
         this.m_statBars = null;
      }
      
      private function initOpportunityBar(param1:Object) : void
      {
         this.removeOpportunityBar();
         if(param1 == null || param1.total == null || param1.completed == null)
         {
            return;
         }
         var _loc2_:Number = Number(param1.total);
         if(_loc2_ <= 0)
         {
            return;
         }
         var _loc3_:Boolean = this.m_isAvailable;
         var _loc4_:Number = Number(param1.completed);
         this.m_opportunityBarView = new StatisticBarSmallView();
         this.m_opportunityBarView.x = 425;
         this.m_opportunityBarView.y = 270;
         this.m_view.tileContent.addChild(this.m_opportunityBarView);
         this.m_opportunityBar = new StatisticBar(this.m_opportunityBarView,_loc3_);
         this.m_opportunityBar.init(param1.title,_loc4_,_loc2_);
         this.m_opportunityBar.show(0);
      }
      
      private function removeOpportunityBar() : void
      {
         if(this.m_opportunityBar != null)
         {
            this.m_opportunityBar.destroy();
            this.m_opportunityBar = null;
         }
         if(this.m_opportunityBarView != null)
         {
            this.m_view.tileContent.removeChild(this.m_opportunityBarView);
            this.m_opportunityBarView = null;
         }
      }
      
      private function initMasteryLevelChart(param1:Object) : void
      {
         param1.isAvailable = this.m_isAvailable;
         this.removeMasteryLevelChart();
         if(this.m_isMasteryAvailable)
         {
            this.m_masteryLevelChart = new MasteryLevelChart(param1);
            this.m_masteryLevelChart.x = 548;
            this.m_masteryLevelChart.y = 460;
            this.m_view.tileContent.addChild(this.m_masteryLevelChart);
            this.m_view.tileContent.noMasteryTitle.text = "";
         }
         else
         {
            this.m_view.tileContent.noMasteryTitle.alpha = this.getAvailabilityAlpha();
            this.m_view.tileContent.noMasteryTitle.text = Localization.get("UI_MENU_PAGE_PROFILE_MASTERY_NOT_AVAILABLE");
            MenuUtils.setColor(this.m_view.tileContent.noMasteryTitle,MenuConstants.COLOR_GREY);
         }
      }
      
      private function removeMasteryLevelChart() : void
      {
         if(this.m_masteryLevelChart == null)
         {
            return;
         }
         this.m_view.tileContent.removeChild(this.m_masteryLevelChart);
         this.m_masteryLevelChart.destroy();
         this.m_masteryLevelChart = null;
      }
   }
}
