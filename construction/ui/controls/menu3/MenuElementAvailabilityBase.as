package menu3
{
   import common.DateTimeUtils;
   import common.Localization;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import common.menu.textTicker;
   import flash.display.Sprite;
   import menu3.basic.TextTickerUtil;
   import menu3.indicator.CompletionStatusIndicatorUtil;
   import menu3.indicator.EscalationLevelIndicator;
   import menu3.indicator.FreeDlcIndicator;
   import menu3.indicator.IIndicator;
   import menu3.indicator.InPlaylistIndicator;
   import menu3.indicator.IndicatorUtil;
   import menu3.indicator.LevelCountIndicator;
   import menu3.indicator.NoVRIndicator;
   import menu3.indicator.VRIndicator;
   
   public dynamic class MenuElementAvailabilityBase extends MenuElementTileBase
   {
       
      
      private var m_contractState:String;
      
      private var m_icon:String;
      
      public var m_infoIndicator:*;
      
      public var m_valueIndicator:*;
      
      public var m_ElusiveIndicator:*;
      
      public var m_timeindicator:*;
      
      public var m_newIndicator:*;
      
      public var m_countDownTimer:CountDownTimer;
      
      private var m_tileView:*;
      
      private var m_tileSize:String;
      
      private var m_hasDLCIssues:Boolean;
      
      private var m_textTickerUtil:TextTickerUtil;
      
      private var m_indicatorUtil:IndicatorUtil;
      
      protected const EEscalationLevelIndicator:int = 0;
      
      protected const EFreeDlcIndicator:int = 1;
      
      protected const EInPlaylistIndicator:int = 2;
      
      protected const ELevelCountIndicator:int = 3;
      
      protected const EVRIndicator:int = 4;
      
      private var m_aboveBarcodeIndicator:Sprite = null;
      
      public function MenuElementAvailabilityBase(param1:Object)
      {
         this.m_textTickerUtil = new TextTickerUtil();
         this.m_indicatorUtil = new IndicatorUtil();
         super(param1);
      }
      
      protected function getIndicator(param1:int) : IIndicator
      {
         return this.m_indicatorUtil.getIndicator(param1);
      }
      
      public function setAgencyPickup(param1:*, param2:Object, param3:String) : void
      {
         var _loc6_:int = 0;
         if(!this.m_tileView)
         {
            this.m_tileView = param1;
         }
         if(!this.m_tileSize)
         {
            this.m_tileSize = param3;
         }
         this.m_hasDLCIssues = false;
         if(this.m_valueIndicator)
         {
            this.m_tileView.indicator.removeChild(this.m_valueIndicator);
            this.m_valueIndicator = null;
         }
         if(param2.agencypickup == null)
         {
            return;
         }
         switch(this.m_tileSize)
         {
            case "large":
               this.m_valueIndicator = new ValueIndicatorLargeView();
               break;
            default:
               this.m_valueIndicator = new ValueIndicatorSmallView();
         }
         if(param2.hidebarcode)
         {
            this.m_valueIndicator.header.width = this.m_valueIndicator.title.width = 278;
         }
         this.m_valueIndicator.y = this.m_tileView.tileBg.height - MenuConstants.ValueIndicatorYOffset;
         MenuUtils.setupText(this.m_valueIndicator.header,param2.agencypickup.header,18,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorGrey);
         var _loc4_:String = String(param2.agencypickup.title);
         if(param2.agencypickup.itemcount != null && param2.agencypickup.itemcount > 1)
         {
            _loc4_ += ", x" + param2.agencypickup.itemcount;
         }
         MenuUtils.setupText(this.m_valueIndicator.title,_loc4_,24,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         var _loc5_:String = String(this.m_valueIndicator.title.htmlText);
         MenuUtils.truncateTextfield(this.m_valueIndicator.header,1);
         MenuUtils.truncateTextfield(this.m_valueIndicator.title,1);
         this.m_valueIndicator.valueIcon.icons.gotoAndStop(param2.agencypickup.icon);
         if(param2.agencypickup.rarity != "common")
         {
            switch(param2.agencypickup.rarity)
            {
               case "uncommon":
                  _loc6_ = MenuConstants.COLOR_UNCOMMON;
                  break;
               case "rare":
                  _loc6_ = MenuConstants.COLOR_RARE;
                  break;
               case "legendary":
                  _loc6_ = MenuConstants.COLOR_LEGENDARY;
                  break;
               default:
                  _loc6_ = MenuConstants.COLOR_COMMON;
            }
            MenuUtils.setupIcon(this.m_valueIndicator.valueIcon,param2.agencypickup.icon,MenuConstants.COLOR_WHITE,true,true,_loc6_,1);
         }
         else
         {
            MenuUtils.setupIcon(this.m_valueIndicator.valueIcon,param2.agencypickup.icon,MenuConstants.COLOR_WHITE,true,true,MenuConstants.COLOR_MENU_TABS_BACKGROUND,MenuConstants.MenuElementBackgroundAlpha);
         }
         this.m_textTickerUtil.clearOnly();
         this.m_textTickerUtil.addTextTicker(this.m_valueIndicator.title,_loc5_);
         this.m_tileView.indicator.addChild(this.m_valueIndicator);
      }
      
      public function setAvailablity(param1:*, param2:Object, param3:String) : void
      {
         var _loc4_:EscalationLevelIndicator = null;
         var _loc5_:Boolean = false;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:InPlaylistIndicator = null;
         var _loc9_:LevelCountIndicator = null;
         var _loc10_:VRIndicator = null;
         var _loc11_:NoVRIndicator = null;
         var _loc12_:String = null;
         var _loc13_:FreeDlcIndicator = null;
         if(!this.m_tileView)
         {
            this.m_tileView = param1;
         }
         if(!this.m_tileSize)
         {
            this.m_tileSize = param3;
         }
         if(this.m_aboveBarcodeIndicator == null)
         {
            this.m_aboveBarcodeIndicator = new Sprite();
            this.m_tileView.addChild(this.m_aboveBarcodeIndicator);
         }
         this.m_icon = param2.icon;
         this.m_hasDLCIssues = false;
         this.clearIndicators();
         if(param2.availability.available)
         {
            if(!(_loc5_ = this.setupArcadeTimer(param2)))
            {
               if(Boolean(param2.locked) || Boolean(param2.masterylocked))
               {
                  _loc6_ = !!param2.masterylocked ? "masterylocked" : "locked";
                  this.setContractState(_loc6_);
                  if(param2.totallevels != null)
                  {
                     _loc4_ = new EscalationLevelIndicator(this.m_tileSize,this.m_tileView.tileBg.height);
                     this.m_indicatorUtil.add(this.EEscalationLevelIndicator,_loc4_,this.m_tileView.indicator,param2);
                  }
                  switch(this.m_tileSize)
                  {
                     case "large":
                        this.m_infoIndicator = new InfoIndicatorLargeView();
                        break;
                     default:
                        this.m_infoIndicator = new InfoIndicatorSmallView();
                  }
                  this.m_infoIndicator.alpha = 0;
                  MenuUtils.setColor(this.m_infoIndicator.darkBg,MenuConstants.COLOR_MENU_TABS_BACKGROUND,true,MenuConstants.MenuElementBackgroundAlpha);
                  this.m_infoIndicator.y = this.m_tileView.tileBg.height - MenuConstants.ValueIndicatorYOffset;
                  MenuUtils.setupText(this.m_infoIndicator.title,param2.lockedreason,18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
                  if(this.m_infoIndicator.title.numLines > 2)
                  {
                     _loc7_ = (this.m_infoIndicator.title.numLines - 2) * 24;
                     this.m_infoIndicator.darkBg.height += _loc7_;
                     this.m_infoIndicator.y -= _loc7_;
                  }
                  MenuUtils.setupIcon(this.m_infoIndicator.valueIcon,"info",MenuConstants.COLOR_WHITE,true,false);
                  this.m_tileView.indicator.addChild(this.m_infoIndicator);
                  if(this.isElusive(param2))
                  {
                     this.parseElusiveData(param2);
                  }
                  if(param2.completionstate != null && param2.completionstate.length > 0)
                  {
                     CompletionStatusIndicatorUtil.addIndicator(this.m_tileView.indicator,param2.completionstate);
                  }
               }
               else if(param2.totallevels != null)
               {
                  this.setContractState("available");
                  _loc4_ = new EscalationLevelIndicator(this.m_tileSize,this.m_tileView.tileBg.height);
                  this.m_indicatorUtil.add(this.EEscalationLevelIndicator,_loc4_,this.m_tileView.indicator,param2);
                  if(param2.completionstate != null && param2.completionstate.length > 0)
                  {
                     CompletionStatusIndicatorUtil.addIndicator(this.m_tileView.indicator,param2.completionstate);
                  }
               }
               else if(param2.totallevels == null && (param2.completionstate != null && param2.completionstate.length > 0))
               {
                  this.setContractState("available");
                  if(param2.completionstate != null && param2.completionstate.length > 0)
                  {
                     CompletionStatusIndicatorUtil.addIndicator(this.m_tileView.indicator,param2.completionstate);
                  }
               }
               else
               {
                  this.setContractState("available");
                  this.parseElusiveData(param2);
               }
            }
            if(param2.isInPlaylist === true)
            {
               _loc8_ = new InPlaylistIndicator(this.m_tileView.tileBg.width,this.m_tileView.tileBg.height);
               this.m_indicatorUtil.add(this.EInPlaylistIndicator,_loc8_,this.m_aboveBarcodeIndicator,param2);
               if(param2.isMarkedForDeletion != undefined)
               {
                  _loc8_.markForDeletion(param2.isMarkedForDeletion);
               }
            }
            if(param2.levelcount != null && param2.levelcounttotal != null)
            {
               _loc9_ = new LevelCountIndicator(this.m_tileView.tileBg.width,this.m_tileView.tileBg.height);
               this.m_indicatorUtil.add(this.ELevelCountIndicator,_loc9_,this.m_tileView.indicator,param2);
            }
            if(param2.vr === true)
            {
               _loc10_ = new VRIndicator(this.m_tileView.tileBg.width,this.m_tileView.tileBg.height);
               this.m_indicatorUtil.add(this.EVRIndicator,_loc10_,this.m_tileView.indicator,param2);
            }
            else if(param2.novr === true)
            {
               _loc11_ = new NoVRIndicator(this.m_tileView.tileBg.width,this.m_tileView.tileBg.height);
               this.m_indicatorUtil.add(this.EVRIndicator,_loc11_,this.m_tileView.indicator,param2);
            }
         }
         else
         {
            switch(this.m_tileSize)
            {
               case "large":
                  this.m_valueIndicator = new ValueIndicatorLargeView();
                  break;
               default:
                  this.m_valueIndicator = new ValueIndicatorSmallView();
            }
            this.m_textTickerUtil.clearOnly();
            _loc12_ = String(param2.availability.unavailable_reason);
            if(param2.freedlc === true)
            {
               _loc13_ = new FreeDlcIndicator(this.m_tileSize);
               this.m_indicatorUtil.add(this.EFreeDlcIndicator,_loc13_,this.m_tileView.indicator,param2);
            }
            switch(_loc12_)
            {
               case "entitlements_missing":
                  this.setContractState("shop");
                  this.m_valueIndicator.y = this.m_tileView.tileBg.height - MenuConstants.ValueIndicatorYOffset;
                  MenuUtils.setupText(this.m_valueIndicator.title,Localization.get("UI_DIALOG_DLC_PURCHASE"),24,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
                  MenuUtils.truncateTextfield(this.m_valueIndicator.header,1);
                  MenuUtils.truncateTextfield(this.m_valueIndicator.title,1);
                  MenuUtils.setupIcon(this.m_valueIndicator.valueIcon,"arrowright",MenuConstants.COLOR_GREY_DARK,false,true,MenuConstants.COLOR_WHITE,1,0,true);
                  this.m_textTickerUtil.addTextTicker(this.m_valueIndicator.title,Localization.get("UI_DIALOG_DLC_PURCHASE"));
                  break;
               case "dlc_not_owned":
                  this.setContractState("shop");
                  this.m_valueIndicator.y = this.m_tileView.tileBg.height - MenuConstants.ValueIndicatorYOffset;
                  MenuUtils.setupText(this.m_valueIndicator.title,Localization.get("UI_DIALOG_DLC_PURCHASE"),24,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
                  MenuUtils.truncateTextfield(this.m_valueIndicator.header,1);
                  MenuUtils.truncateTextfield(this.m_valueIndicator.title,1);
                  MenuUtils.setupIcon(this.m_valueIndicator.valueIcon,"arrowright",MenuConstants.COLOR_GREY_DARK,false,true,MenuConstants.COLOR_WHITE,1,0,true);
                  this.m_textTickerUtil.addTextTicker(this.m_valueIndicator.title,Localization.get("UI_DIALOG_DLC_PURCHASE"));
                  break;
               case "dlc_not_installed":
                  this.setContractState("download");
                  this.m_valueIndicator.y = this.m_tileView.tileBg.height - MenuConstants.ValueIndicatorYOffset;
                  MenuUtils.setupText(this.m_valueIndicator.title,Localization.get("UI_DIALOG_DLC_DOWNLOAD"),24,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
                  MenuUtils.truncateTextfield(this.m_valueIndicator.title,1);
                  MenuUtils.setupIcon(this.m_valueIndicator.valueIcon,"arrowright",MenuConstants.COLOR_GREY_DARK,false,true,MenuConstants.COLOR_WHITE,1,0,true);
                  this.m_textTickerUtil.addTextTicker(this.m_valueIndicator.title,Localization.get("UI_DIALOG_DLC_DOWNLOAD"));
                  break;
               case "dlc_update_required":
                  this.setContractState("update");
                  this.m_valueIndicator.y = this.m_tileView.tileBg.height - MenuConstants.ValueIndicatorYOffset;
                  MenuUtils.setupText(this.m_valueIndicator.valuetitle,Localization.get("UI_DIALOG_DLC_DOWNLOAD"),24,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
                  MenuUtils.truncateTextfield(this.m_valueIndicator.valuetitle,1);
                  MenuUtils.setupIcon(this.m_valueIndicator.valueIcon,"downloading",MenuConstants.COLOR_GREY_DARK,false,true,MenuConstants.COLOR_WHITE,1,0,true);
                  this.m_textTickerUtil.addTextTicker(this.m_valueIndicator.valuetitle,Localization.get("UI_DIALOG_DLC_DOWNLOAD"));
                  break;
               case "dlc_downloading":
                  this.setContractState("downloading");
                  this.m_valueIndicator.y = this.m_tileView.tileBg.height - MenuConstants.ValueIndicatorYOffset;
                  MenuUtils.setupText(this.m_valueIndicator.valuetitle,Localization.get("UI_DIALOG_DLC_DOWNLOADING"),24,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
                  MenuUtils.truncateTextfield(this.m_valueIndicator.valuetitle,1);
                  MenuUtils.setupIcon(this.m_valueIndicator.valueIcon,this.m_contractState,MenuConstants.COLOR_GREY_DARK,false,true,MenuConstants.COLOR_WHITE,1,0,true);
                  this.m_textTickerUtil.addTextTicker(this.m_valueIndicator.valuetitle,Localization.get("UI_DIALOG_DLC_DOWNLOADING"));
                  if(param2.availability.percentage_complete >= 0)
                  {
                     MenuUtils.setupText(this.m_valueIndicator.value,Math.round(param2.availability.percentage_complete * 100) + "%",32,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
                  }
                  break;
               case "dlc_installing":
                  this.setContractState("installing");
                  this.m_valueIndicator.y = this.m_tileView.tileBg.height - MenuConstants.ValueIndicatorYOffset;
                  MenuUtils.setupText(this.m_valueIndicator.valuetitle,Localization.get("UI_DIALOG_DLC_INSTALLING"),24,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
                  MenuUtils.truncateTextfield(this.m_valueIndicator.valuetitle,1);
                  MenuUtils.setupIcon(this.m_valueIndicator.valueIcon,"downloading",MenuConstants.COLOR_GREY_DARK,false,true,MenuConstants.COLOR_WHITE,1,0,true);
                  this.m_textTickerUtil.addTextTicker(this.m_valueIndicator.valuetitle,Localization.get("UI_DIALOG_DLC_INSTALLING"));
                  if(param2.availability.percentage_complete >= 0)
                  {
                     MenuUtils.setupText(this.m_valueIndicator.value,Math.round(param2.availability.percentage_complete * 100) + "%",32,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
                  }
                  break;
               case "dlc_unknown":
                  this.setContractState("unknown");
                  this.m_valueIndicator.y = this.m_tileView.tileBg.height - MenuConstants.ValueIndicatorYOffset;
                  MenuUtils.setupText(this.m_valueIndicator.title,Localization.get("UI_DIALOG_DLC_UNKNOWN"),24,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
                  MenuUtils.truncateTextfield(this.m_valueIndicator.title,1);
                  this.m_valueIndicator.valueIcon.visible = false;
                  this.m_textTickerUtil.addTextTicker(this.m_valueIndicator.title,Localization.get("UI_DIALOG_DLC_UNKNOWN"));
                  break;
               default:
                  this.setContractState("unknown");
                  this.m_valueIndicator.y = this.m_tileView.tileBg.height - MenuConstants.ValueIndicatorYOffset;
                  MenuUtils.setupText(this.m_valueIndicator.title,Localization.get("UI_DIALOG_DLC_STATE_UNKNOWN"),24,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
                  MenuUtils.truncateTextfield(this.m_valueIndicator.title,1);
                  this.m_valueIndicator.valueIcon.visible = false;
                  this.m_textTickerUtil.addTextTicker(this.m_valueIndicator.title,Localization.get("UI_DIALOG_DLC_STATE_UNKNOWN"));
            }
            this.m_hasDLCIssues = true;
            this.m_tileView.indicator.addChild(this.m_valueIndicator);
            this.parseElusiveData(param2);
         }
      }
      
      private function clearIndicators() : void
      {
         this.m_indicatorUtil.clearIndicators();
         if(this.m_tileView == null || this.m_tileView.indicator == null)
         {
            return;
         }
         if(this.m_timeindicator)
         {
            this.m_tileView.indicator.removeChild(this.m_timeindicator);
            this.m_timeindicator = null;
         }
         if(this.m_infoIndicator)
         {
            this.m_tileView.indicator.removeChild(this.m_infoIndicator);
            this.m_infoIndicator = null;
         }
         if(this.m_valueIndicator)
         {
            this.m_tileView.indicator.removeChild(this.m_valueIndicator);
            this.m_valueIndicator = null;
         }
         if(this.m_ElusiveIndicator)
         {
            this.m_tileView.indicator.removeChild(this.m_ElusiveIndicator);
            this.m_ElusiveIndicator = null;
         }
         if(this.m_newIndicator)
         {
            this.m_tileView.indicator.removeChild(this.m_newIndicator);
            this.m_newIndicator = null;
         }
         CompletionStatusIndicatorUtil.removeIndicator(this.m_tileView.indicator);
      }
      
      private function parseElusiveData(param1:Object) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:textTicker = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Boolean = false;
         var _loc10_:String = null;
         var _loc11_:Boolean = false;
         var _loc12_:String = null;
         if(param1.elusivecontractstate && param1.elusivecontractstate != null && param1.elusivecontractstate != "")
         {
            _loc2_ = false;
            _loc3_ = false;
            if(param1.playableSince != null && param1.playableSince != "" && param1.lastPlayedAt != null && param1.lastPlayedAt != "")
            {
               _loc5_ = DateTimeUtils.parseUTCTimeStamp(param1.playableSince).getTime();
               if((_loc6_ = DateTimeUtils.parseUTCTimeStamp(param1.lastPlayedAt).getTime()) < _loc5_)
               {
                  _loc2_ = true;
               }
               _loc7_ = DateTimeUtils.getUTCClockNow().getTime();
               _loc8_ = DateTimeUtils.parseUTCTimeStamp(param1.playableUntil).getTime();
               if(_loc7_ >= _loc8_)
               {
                  _loc3_ = true;
               }
            }
            switch(param1.elusivecontractstate)
            {
               case "not_completed":
                  this.parseTimedData(param1);
                  break;
               case "time_ran_out":
                  if(!this.m_hasDLCIssues)
                  {
                     this.setContractState("failed");
                  }
                  this.showTimeRanOut();
                  break;
               case "completed":
                  if(!this.m_hasDLCIssues)
                  {
                     this.setContractState("completed");
                  }
                  switch(this.m_tileSize)
                  {
                     case "large":
                        this.m_ElusiveIndicator = new ValueIndicatorLargeView();
                        break;
                     default:
                        this.m_ElusiveIndicator = new ValueIndicatorSmallView();
                  }
                  this.m_ElusiveIndicator.y = this.m_hasDLCIssues ? this.m_tileView.tileBg.height - MenuConstants.ValueIndicatorYOffset - MenuConstants.ValueIndicatorHeight : this.m_tileView.tileBg.height - MenuConstants.ValueIndicatorYOffset;
                  _loc10_ = (_loc9_ = _loc2_ && !_loc3_) ? Localization.get("UI_CONTRACT_ELUSIVE_STATE_COMPLETED_PREVIOUSLY") : Localization.get("UI_CONTRACT_ELUSIVE_STATE_COMPLETED");
                  if(_loc9_)
                  {
                     MenuUtils.setupText(this.m_ElusiveIndicator.titlelarge,_loc10_,22,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
                     this.m_ElusiveIndicator.titlelarge.y += 10;
                  }
                  else
                  {
                     MenuUtils.setupText(this.m_ElusiveIndicator.titlelarge,_loc10_,38,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
                  }
                  this.m_textTickerUtil.addTextTickerHtml(this.m_ElusiveIndicator.titlelarge);
                  MenuUtils.truncateTextfield(this.m_ElusiveIndicator.titlelarge,1);
                  MenuUtils.setupIcon(this.m_ElusiveIndicator.valueIcon,this.m_contractState,MenuConstants.COLOR_WHITE,true,true,MenuConstants.COLOR_MENU_TABS_BACKGROUND,MenuConstants.MenuElementBackgroundAlpha);
                  this.m_tileView.indicator.addChild(this.m_ElusiveIndicator);
                  break;
               case "failed":
               case "completed_but_died":
                  if(!this.m_hasDLCIssues)
                  {
                     this.setContractState("failed");
                  }
                  switch(this.m_tileSize)
                  {
                     case "large":
                        this.m_ElusiveIndicator = new ValueIndicatorLargeView();
                        break;
                     default:
                        this.m_ElusiveIndicator = new ValueIndicatorSmallView();
                  }
                  this.m_ElusiveIndicator.y = this.m_hasDLCIssues ? this.m_tileView.tileBg.height - MenuConstants.ValueIndicatorYOffset - MenuConstants.ValueIndicatorHeight : this.m_tileView.tileBg.height - MenuConstants.ValueIndicatorYOffset;
                  _loc12_ = (_loc11_ = _loc2_ && !_loc3_) ? Localization.get("UI_CONTRACT_ELUSIVE_STATE_COMPLETED_BUT_DIED_PREVIOUSLY") : Localization.get("UI_CONTRACT_ELUSIVE_STATE_COMPLETED_BUT_DIED");
                  if(_loc11_)
                  {
                     MenuUtils.setupText(this.m_ElusiveIndicator.titlelarge,_loc12_,22,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
                     this.m_ElusiveIndicator.titlelarge.y += 10;
                  }
                  else
                  {
                     MenuUtils.setupText(this.m_ElusiveIndicator.titlelarge,_loc12_,38,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
                  }
                  this.m_textTickerUtil.addTextTickerHtml(this.m_ElusiveIndicator.titlelarge);
                  MenuUtils.truncateTextfield(this.m_ElusiveIndicator.titlelarge,1);
                  MenuUtils.setupIcon(this.m_ElusiveIndicator.valueIcon,this.m_contractState,MenuConstants.COLOR_WHITE,true,true,MenuConstants.COLOR_MENU_TABS_BACKGROUND,MenuConstants.MenuElementBackgroundAlpha);
                  this.m_tileView.indicator.addChild(this.m_ElusiveIndicator);
                  break;
               default:
                  this.parseTimedData(param1);
            }
         }
         else
         {
            this.parseTimedData(param1);
         }
      }
      
      private function setupArcadeTimer(param1:Object) : Boolean
      {
         var _loc2_:Number = DateTimeUtils.getUTCClockNow().getTime();
         if(param1.type == "arcade" && param1.errorType == "ContractNotPlayableYet" && param1.playableSince && _loc2_ <= DateTimeUtils.parseUTCTimeStamp(param1.playableSince).getTime())
         {
            if(this.m_countDownTimer)
            {
               this.m_countDownTimer.stopCountDown();
               this.m_countDownTimer = null;
            }
            this.m_countDownTimer = new CountDownTimer();
            if(param1.masterylocked)
            {
               this.setContractState("masterylocked");
            }
            else if(this.m_hasDLCIssues)
            {
               this.setContractState("locked");
            }
            else
            {
               this.setContractState("failed");
            }
            this.showTimer(param1.playableSince,Localization.get("UI_CONTRACT_ARCADE_STATE_FAILED"));
            return true;
         }
         return false;
      }
      
      private function parseTimedData(param1:Object) : void
      {
         if(this.m_countDownTimer)
         {
            this.m_countDownTimer.stopCountDown();
            this.m_countDownTimer = null;
         }
         var _loc2_:Number = DateTimeUtils.getUTCClockNow().getTime();
         var _loc3_:String = "playable";
         if(Boolean(param1.playableSince) && _loc2_ <= DateTimeUtils.parseUTCTimeStamp(param1.playableSince).getTime())
         {
            _loc3_ = "notplayable";
         }
         if(Boolean(param1.playableUntil) && _loc2_ >= DateTimeUtils.parseUTCTimeStamp(param1.playableUntil).getTime())
         {
            _loc3_ = "gone";
         }
         switch(_loc3_)
         {
            case "notplayable":
               if(!this.m_countDownTimer)
               {
                  this.m_countDownTimer = new CountDownTimer();
               }
               if(!this.m_hasDLCIssues)
               {
                  this.setContractState("locked");
               }
               this.showTimer(param1.playableSince,Localization.get("UI_DIALOG_TARGET_ARRIVES"));
               break;
            case "playable":
               if(Boolean(param1.playableUntil) && !this.m_countDownTimer)
               {
                  this.m_countDownTimer = new CountDownTimer();
               }
               if(!this.m_hasDLCIssues)
               {
                  this.setContractState("available");
               }
               if(param1.playableUntil)
               {
                  this.showTimer(param1.playableUntil);
               }
               break;
            case "gone":
               this.m_textTickerUtil.clearOnly();
               if(this.m_countDownTimer)
               {
                  this.m_countDownTimer.stopCountDown();
                  this.m_countDownTimer = null;
               }
               if(!this.m_hasDLCIssues)
               {
                  this.setContractState("failed");
               }
               this.showTimeRanOut();
         }
      }
      
      private function isElusive(param1:Object) : Boolean
      {
         return Boolean(param1.elusivecontractstate) && param1.elusivecontractstate != "";
      }
      
      private function isPlayable(param1:Object) : Boolean
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc2_:Number = DateTimeUtils.getUTCClockNow().getTime();
         if(param1.playableSince)
         {
            _loc3_ = DateTimeUtils.parseUTCTimeStamp(param1.playableSince).getTime();
            if(_loc2_ < _loc3_)
            {
               return false;
            }
         }
         if(param1.playableUntil)
         {
            _loc4_ = DateTimeUtils.parseUTCTimeStamp(param1.playableUntil).getTime();
            if(_loc2_ >= _loc4_)
            {
               return false;
            }
         }
         return true;
      }
      
      private function isStartedContract(param1:Object) : Boolean
      {
         return !param1.playableSince || DateTimeUtils.parseUTCTimeStamp(param1.playableSince).getTime() <= DateTimeUtils.getUTCClockNow().getTime();
      }
      
      private function showTimeRanOut() : void
      {
         switch(this.m_tileSize)
         {
            case "large":
               this.m_ElusiveIndicator = new ValueIndicatorLargeView();
               break;
            default:
               this.m_ElusiveIndicator = new ValueIndicatorSmallView();
         }
         this.m_ElusiveIndicator.y = this.m_hasDLCIssues ? this.m_tileView.tileBg.height - MenuConstants.ValueIndicatorYOffset - MenuConstants.ValueIndicatorHeight : this.m_tileView.tileBg.height - MenuConstants.ValueIndicatorYOffset;
         MenuUtils.setupText(this.m_ElusiveIndicator.titlelarge,Localization.get("UI_CONTRACT_ELUSIVE_STATE_TIME_RAN_OUT"),38,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         MenuUtils.truncateTextfield(this.m_ElusiveIndicator.titlelarge,1);
         this.m_textTickerUtil.addTextTicker(this.m_ElusiveIndicator.titlelarge,Localization.get("UI_CONTRACT_ELUSIVE_STATE_TIME_RAN_OUT"));
         MenuUtils.setupIcon(this.m_ElusiveIndicator.valueIcon,"timed",MenuConstants.COLOR_WHITE,true,true,MenuConstants.COLOR_MENU_TABS_BACKGROUND,MenuConstants.MenuElementBackgroundAlpha);
         this.m_tileView.indicator.addChild(this.m_ElusiveIndicator);
      }
      
      private function showTimer(param1:String, param2:String = null) : void
      {
         if(!this.m_timeindicator)
         {
            switch(this.m_tileSize)
            {
               case "large":
                  this.m_timeindicator = new TimeIndicatorLargeView();
                  break;
               default:
                  this.m_timeindicator = new TimeIndicatorSmallView();
            }
            this.m_timeindicator.y = this.m_hasDLCIssues ? this.m_tileView.tileBg.height - MenuConstants.ValueIndicatorYOffset - MenuConstants.ValueIndicatorHeight : this.m_tileView.tileBg.height - MenuConstants.ValueIndicatorYOffset;
            MenuUtils.setupIcon(this.m_timeindicator.valueIcon,"timed",MenuConstants.COLOR_WHITE,true,true,MenuConstants.COLOR_MENU_TABS_BACKGROUND,MenuConstants.MenuElementBackgroundAlpha);
            this.m_tileView.indicator.addChild(this.m_timeindicator);
         }
         if(param2)
         {
            MenuUtils.setupTextUpper(this.m_timeindicator.header,param2,18,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorGrey);
            this.m_countDownTimer.startCountDown(this.m_timeindicator.title,param1,this,24,MenuConstants.FontColorWhite);
         }
         else
         {
            this.m_countDownTimer.startCountDown(this.m_timeindicator.titlelarge,param1,this,38,MenuConstants.FontColorWhite);
         }
      }
      
      public function timerComplete() : void
      {
         this.m_countDownTimer.stopCountDown();
         this.m_countDownTimer = null;
         this.m_tileView.indicator.removeChild(this.m_timeindicator);
         this.m_timeindicator = null;
         var _loc1_:Object = getData();
         if(_loc1_.type == "arcade")
         {
            this.setAvailablity(this.m_tileView,_loc1_,this.m_tileSize);
         }
         else
         {
            if(!this.m_hasDLCIssues)
            {
               if(!_loc1_.locked && this.isElusive(_loc1_) && this.m_contractState == "locked" && this.isStartedContract(_loc1_))
               {
                  if(this.m_infoIndicator)
                  {
                     this.m_tileView.indicator.removeChild(this.m_infoIndicator);
                  }
                  this.setContractState("available");
                  this.parseTimedData(_loc1_);
                  return;
               }
               this.setContractState("failed");
            }
            this.showTimeRanOut();
         }
      }
      
      public function setContractState(param1:String) : void
      {
         this.m_contractState = param1;
         switch(param1)
         {
            case "available":
               this.m_tileView.tileIcon.icons.gotoAndStop(this.m_icon);
               break;
            case "locked":
               this.m_tileView.tileIcon.icons.gotoAndStop(this.m_icon);
               break;
            case "masterylocked":
               this.m_tileView.tileIcon.icons.gotoAndStop("locked");
               break;
            case "shop":
               this.m_tileView.tileIcon.icons.gotoAndStop(this.m_icon);
               break;
            case "download":
               this.m_tileView.tileIcon.icons.gotoAndStop(this.m_icon);
               break;
            case "downloading":
               this.m_tileView.tileIcon.icons.gotoAndStop(this.m_icon);
               break;
            case "installing":
               this.m_tileView.tileIcon.icons.gotoAndStop(this.m_icon);
               break;
            case "unknown":
               this.m_tileView.tileIcon.icons.gotoAndStop(this.m_icon);
         }
         this.setOverlayColor();
      }
      
      public function setOverlayColor(param1:Boolean = false) : void
      {
         var _loc2_:String = null;
         if(this.m_tileView == null || this.m_tileView.image == null)
         {
            return;
         }
         if(param1)
         {
            MenuUtils.setColorFilter(this.m_tileView.image,"selected");
         }
         else
         {
            _loc2_ = !!this.m_contractState ? this.m_contractState : "";
            MenuUtils.setColorFilter(this.m_tileView.image,_loc2_);
         }
      }
      
      override protected function handleSelectionChange() : void
      {
         this.m_textTickerUtil.callTextTicker(m_isSelected);
         this.m_indicatorUtil.callTextTickers(m_isSelected);
      }
      
      override public function onUnregister() : void
      {
         this.clearIndicators();
         if(this.m_tileView != null && this.m_aboveBarcodeIndicator != null)
         {
            this.m_tileView.removeChild(this.m_aboveBarcodeIndicator);
            this.m_aboveBarcodeIndicator = null;
         }
         if(this.m_countDownTimer)
         {
            this.m_countDownTimer.stopCountDown();
            this.m_countDownTimer = null;
         }
         this.m_textTickerUtil.onUnregister();
         this.m_textTickerUtil = null;
         super.onUnregister();
      }
   }
}
