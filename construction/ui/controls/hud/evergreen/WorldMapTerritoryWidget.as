package hud.evergreen
{
   import common.Animate;
   import common.BaseControl;
   import common.menu.MenuConstants;
   import flash.display.Shape;
   
   public class WorldMapTerritoryWidget extends BaseControl
   {
      
      public static const NotVisited:int = 0;
      
      public static const VisitedAndWon:int = 1;
      
      public static const VisitedAndLost:int = 2;
       
      
      private var m_mapMarker:MapMarker;
      
      private var m_tooltipBackground:Shape;
      
      private var m_collapsedTooltipContent:CollapsedTooltipContent;
      
      private var m_expandedTooltipContent:ExpandedTooltipContent;
      
      private var m_expandDetailsLeft:Boolean;
      
      private var m_expandDetailsUp:Boolean;
      
      private var m_yMaxInfoPanel:Number;
      
      public function WorldMapTerritoryWidget()
      {
         this.m_mapMarker = new MapMarker();
         this.m_tooltipBackground = new Shape();
         this.m_collapsedTooltipContent = new CollapsedTooltipContent();
         this.m_expandedTooltipContent = new ExpandedTooltipContent();
         super();
         this.m_mapMarker.name = "m_mapMarker";
         this.m_tooltipBackground.name = "m_tooltipBackground";
         this.m_collapsedTooltipContent.name = "m_collapsedTooltipContent";
         this.m_expandedTooltipContent.name = "m_expandedTooltipContent";
         addChild(this.m_tooltipBackground);
         addChild(this.m_collapsedTooltipContent);
         addChild(this.m_expandedTooltipContent);
         addChild(this.m_mapMarker);
         this.m_collapsedTooltipContent.y = -this.m_mapMarker.height / 2;
         this.m_collapsedTooltipContent.scaleX = 0.5;
         this.m_collapsedTooltipContent.scaleY = 0.5;
         this.m_expandedTooltipContent.scaleX = 0.7;
         this.m_expandedTooltipContent.scaleY = 0.7;
      }
      
      [PROPERTY(HELPTEXT="Possible values: down_left, down_right, up_left, up_right")]
      public function set ExpandDetailsToDirection(param1:String) : void
      {
         switch(param1)
         {
            case "down_left":
            case "down_right":
            case "up_left":
            case "up_right":
               break;
            default:
               param1 = "down_left";
         }
         this.m_expandDetailsLeft = param1 == "down_left" || param1 == "up_left";
         this.m_expandDetailsUp = param1 == "up_left" || param1 == "up_right";
         this.m_tooltipBackground.graphics.clear();
         this.m_tooltipBackground.graphics.beginFill(MenuConstants.COLOR_MENU_BUTTON_TILE_DESELECTED,0.85);
         this.m_tooltipBackground.graphics.drawRect(0,0,this.m_expandDetailsLeft ? -100 : 100,100);
         this.m_tooltipBackground.graphics.endFill();
         this.m_tooltipBackground.x = (this.m_expandDetailsLeft ? -1 : 1) * this.m_mapMarker.width * 0.75;
      }
      
      [PROPERTY(CONSTRAINT="Step(1)")]
      public function set YMaxInfoPanel(param1:Number) : void
      {
         this.m_yMaxInfoPanel = param1;
      }
      
      public function send_dxExpandedCenter(param1:Number) : void
      {
         sendEventWithValue("dxExpandedCenter",param1);
      }
      
      public function send_dyExpandedCenter(param1:Number) : void
      {
         sendEventWithValue("dyExpandedCenter",param1);
      }
      
      public function onSetData(param1:Object) : void
      {
         this.m_collapsedTooltipContent.visible = false;
         this.m_expandedTooltipContent.visible = false;
         this.m_tooltipBackground.visible = false;
         Animate.to(this,0.2,0,{"alpha":(!!param1.isAnotherSelectedToTravelNext ? 0.25 : 1)},Animate.Linear);
         if(!param1.isInCampaign)
         {
            this.m_mapMarker.gotoAndStop("not_in_campaign");
            return;
         }
         if(param1.visited == VisitedAndWon)
         {
            this.m_mapMarker.gotoAndStop("mission_completed");
            return;
         }
         if(param1.visited == VisitedAndLost)
         {
            this.m_mapMarker.gotoAndStop("mission_failed");
            return;
         }
         if(param1.isHotMission)
         {
            this.m_mapMarker.gotoAndStop(!!param1.isSelectedInMenu ? "selected_mission_showdown" : "mission_showdown");
            if(Boolean(this.m_mapMarker.icon_mc) && Boolean(param1.isSelectedInMenu))
            {
               this.m_mapMarker.icon_mc.gotoAndPlay(1);
            }
         }
         else if(param1.isAlerted)
         {
            this.m_mapMarker.gotoAndStop(!!param1.isSelectedInMenu ? "selected_mission_alerted" : "mission_alerted");
         }
         else
         {
            this.m_mapMarker.gotoAndStop(!!param1.isSelectedInMenu ? "selected_mission" : "mission");
         }
         var _loc2_:Boolean = Boolean(param1.isThisSelectedToTravelNext) || Boolean(param1.isMenuZoomedIn);
         if(this.m_mapMarker.blink_mc)
         {
            if(!_loc2_)
            {
               this.m_mapMarker.blink_mc.gotoAndPlay(1);
            }
            else
            {
               this.m_mapMarker.blink_mc.gotoAndStop(1);
            }
         }
         if(param1.isSelectedInMenu)
         {
            parent.setChildIndex(this,parent.numChildren - 1);
         }
         if(!param1.isSelectedInMenu || _loc2_)
         {
            Animate.kill(this.m_collapsedTooltipContent);
            this.m_collapsedTooltipContent.alpha = 0;
         }
         else
         {
            this.m_collapsedTooltipContent.visible = true;
            this.m_collapsedTooltipContent.onSetData(param1);
            if(!this.m_expandDetailsLeft)
            {
               this.m_collapsedTooltipContent.x = this.m_mapMarker.width * 0.75;
            }
            else
            {
               this.m_collapsedTooltipContent.x = -(this.m_mapMarker.width * 0.75 + this.m_collapsedTooltipContent.backgroundWidth * this.m_collapsedTooltipContent.scaleX);
            }
            Animate.to(this.m_collapsedTooltipContent,0.2,0.2,{"alpha":1},Animate.SineOut);
         }
         if(!param1.isSelectedInMenu || !_loc2_)
         {
            Animate.kill(this.m_expandedTooltipContent);
            this.m_expandedTooltipContent.alpha = 0;
            this.m_expandedTooltipContent.stopLoopingAnimations();
         }
         else
         {
            this.m_expandedTooltipContent.visible = true;
            this.m_expandedTooltipContent.onSetData(param1);
            if(!this.m_expandDetailsLeft)
            {
               this.m_expandedTooltipContent.x = this.m_mapMarker.width * 0.75;
            }
            else
            {
               this.m_expandedTooltipContent.x = -(this.m_mapMarker.width * 0.75 + this.m_expandedTooltipContent.backgroundWidth * this.m_expandedTooltipContent.scaleX);
            }
            this.m_expandedTooltipContent.y = -(this.m_expandedTooltipContent.backgroundHeight * this.m_expandedTooltipContent.scaleY) / 2;
            Animate.to(this.m_expandedTooltipContent,0.2,0.2,{"alpha":1},Animate.SineOut);
         }
         if(!param1.isSelectedInMenu)
         {
            Animate.kill(this.m_tooltipBackground);
            this.m_tooltipBackground.width = 1;
         }
         else if(!_loc2_)
         {
            this.m_tooltipBackground.visible = true;
            if(this.m_tooltipBackground.width == 1)
            {
               this.m_tooltipBackground.y = this.m_collapsedTooltipContent.y;
               this.m_tooltipBackground.height = this.m_collapsedTooltipContent.backgroundHeight * this.m_collapsedTooltipContent.scaleY;
            }
            Animate.to(this.m_tooltipBackground,0.2,0,{
               "y":this.m_collapsedTooltipContent.y,
               "width":this.m_collapsedTooltipContent.backgroundWidth * this.m_collapsedTooltipContent.scaleX,
               "height":this.m_collapsedTooltipContent.backgroundHeight * this.m_collapsedTooltipContent.scaleY
            },Animate.SineOut);
         }
         else
         {
            this.m_tooltipBackground.visible = true;
            if(this.m_tooltipBackground.width == 1)
            {
               this.m_tooltipBackground.y = this.m_expandedTooltipContent.y;
               this.m_tooltipBackground.height = this.m_expandedTooltipContent.backgroundHeight * this.m_expandedTooltipContent.scaleY;
            }
            Animate.to(this.m_tooltipBackground,0.2,0,{
               "y":this.m_expandedTooltipContent.y,
               "width":this.m_expandedTooltipContent.backgroundWidth * this.m_expandedTooltipContent.scaleX,
               "height":this.m_expandedTooltipContent.backgroundHeight * this.m_expandedTooltipContent.scaleY
            },Animate.SineOut);
            this.send_dxExpandedCenter(this.m_expandedTooltipContent.x + this.m_expandedTooltipContent.backgroundWidth * this.m_expandedTooltipContent.scaleX / 2);
            this.send_dyExpandedCenter(this.m_expandedTooltipContent.y + this.m_expandedTooltipContent.backgroundHeight * this.m_expandedTooltipContent.scaleY / 2);
         }
      }
   }
}

import common.menu.MenuConstants;
import common.menu.MenuUtils;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import hud.evergreen.misc.DottedLineAlt;

class CollapsedTooltipContent extends Sprite
{
   
   private static const PXPADDING:Number = 40;
   
   private static const DYGAP:Number = 30;
    
   
   private var m_destinationName_txt:TextField;
   
   private var m_dottedLine:DottedLineAlt;
   
   private var m_iconTargets:iconsAll76x76View;
   
   private var m_iconSafes:iconsAll76x76View;
   
   private var m_iconMules:iconsAll76x76View;
   
   private var m_iconSuppliers:iconsAll76x76View;
   
   private var m_numTargets_txt:TextField;
   
   private var m_numSafes_txt:TextField;
   
   private var m_numMules_txt:TextField;
   
   private var m_numSuppliers_txt:TextField;
   
   private var m_bonusRequirements:Sprite;
   
   private var m_backgroundWidth:Number = 0;
   
   private var m_backgroundHeight:Number = 0;
   
   public function CollapsedTooltipContent()
   {
      this.m_destinationName_txt = new TextField();
      this.m_dottedLine = new DottedLineAlt(5);
      this.m_iconTargets = new iconsAll76x76View();
      this.m_iconSafes = new iconsAll76x76View();
      this.m_iconMules = new iconsAll76x76View();
      this.m_iconSuppliers = new iconsAll76x76View();
      this.m_numTargets_txt = new TextField();
      this.m_numSafes_txt = new TextField();
      this.m_numMules_txt = new TextField();
      this.m_numSuppliers_txt = new TextField();
      this.m_bonusRequirements = new Sprite();
      super();
      this.m_destinationName_txt.name = "m_destinationName_txt";
      this.m_dottedLine.name = "m_dottedLine";
      this.m_iconTargets.name = "m_iconTargets";
      this.m_iconSafes.name = "m_iconSafes";
      this.m_iconMules.name = "m_iconMules";
      this.m_iconSuppliers.name = "m_iconSuppliers";
      this.m_numTargets_txt.name = "m_numTargets_txt";
      this.m_numSafes_txt.name = "m_numSafes_txt";
      this.m_numMules_txt.name = "m_numMules_txt";
      this.m_numSuppliers_txt.name = "m_numSuppliers_txt";
      this.m_bonusRequirements.name = "m_bonusRequirements";
      addChild(this.m_destinationName_txt);
      addChild(this.m_dottedLine);
      addChild(this.m_iconTargets);
      addChild(this.m_iconSafes);
      addChild(this.m_iconMules);
      addChild(this.m_iconSuppliers);
      addChild(this.m_numTargets_txt);
      addChild(this.m_numSafes_txt);
      addChild(this.m_numMules_txt);
      addChild(this.m_numSuppliers_txt);
      addChild(this.m_bonusRequirements);
      setupCounterIcon(this.m_iconTargets,"evergreen_target");
      setupCounterIcon(this.m_iconSafes,"evergreen_safe");
      setupCounterIcon(this.m_iconMules,"evergreen_mules");
      setupCounterIcon(this.m_iconSuppliers,"evergreen_suppliers");
      MenuUtils.setupText(this.m_destinationName_txt,"",80,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
      MenuUtils.setupText(this.m_numTargets_txt,"",70,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
      MenuUtils.setupText(this.m_numSafes_txt,"",70,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
      MenuUtils.setupText(this.m_numMules_txt,"",70,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
      MenuUtils.setupText(this.m_numSuppliers_txt,"",70,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
      this.m_destinationName_txt.autoSize = TextFieldAutoSize.LEFT;
      this.m_numTargets_txt.autoSize = TextFieldAutoSize.LEFT;
      this.m_numSafes_txt.autoSize = TextFieldAutoSize.LEFT;
      this.m_numMules_txt.autoSize = TextFieldAutoSize.LEFT;
      this.m_numSuppliers_txt.autoSize = TextFieldAutoSize.LEFT;
      this.m_destinationName_txt.x = PXPADDING - 6;
      this.m_dottedLine.x = PXPADDING;
      this.m_bonusRequirements.x = PXPADDING;
      this.m_bonusRequirements.scaleX = 0.85;
      this.m_bonusRequirements.scaleY = 0.85;
   }
   
   private static function setupCounterIcon(param1:iconsAll76x76View, param2:String) : void
   {
      MenuUtils.setupIcon(param1,param2,16777215,false,false,16777215,0,0,true);
   }
   
   private static function syncCounter(param1:Number, param2:Number, param3:iconsAll76x76View, param4:TextField) : Number
   {
      if(!param2)
      {
         param3.alpha = 0.4;
         param4.alpha = 0.4;
      }
      else
      {
         param3.alpha = 1;
         param4.alpha = 1;
      }
      param4.htmlText = "<font face=\"$global\">" + param2.toString() + "</font>";
      param3.x = param1 + param3.width / 2;
      param1 += param3.width * 1.25;
      param4.x = param1;
      param1 += param4.textWidth;
      return param1 + param3.width;
   }
   
   public function get backgroundWidth() : Number
   {
      return this.m_backgroundWidth;
   }
   
   public function get backgroundHeight() : Number
   {
      return this.m_backgroundHeight;
   }
   
   public function onSetData(param1:Object) : void
   {
      var _loc8_:iconsAll76x76View = null;
      var _loc12_:String = null;
      var _loc2_:Number = Number(PXPADDING);
      var _loc3_:Number = 0;
      this.m_destinationName_txt.text = param1.lstrDestinationFullName.toUpperCase();
      this.m_destinationName_txt.y = _loc2_;
      _loc2_ += this.m_destinationName_txt.textHeight + DYGAP;
      _loc3_ = Number(DYGAP);
      this.m_dottedLine.y = _loc2_ - 6;
      _loc2_ += this.m_dottedLine.dottedLineThickness + DYGAP;
      _loc3_ = Number(DYGAP);
      var _loc4_:Number = Number(PXPADDING);
      _loc4_ = Number(syncCounter(_loc4_,param1.nTargets,this.m_iconTargets,this.m_numTargets_txt));
      _loc4_ = Number(syncCounter(_loc4_,param1.nSafes,this.m_iconSafes,this.m_numSafes_txt));
      _loc4_ = Number(syncCounter(_loc4_,param1.nMules,this.m_iconMules,this.m_numMules_txt));
      _loc4_ = Number(syncCounter(_loc4_,param1.nSuppliers,this.m_iconSuppliers,this.m_numSuppliers_txt));
      var _loc5_:Number = Number(this.m_iconTargets.width);
      var _loc6_:Number = Number(this.m_iconTargets.height);
      if(_loc4_ != PXPADDING)
      {
         _loc4_ -= _loc5_;
         this.m_iconTargets.y = _loc2_ + _loc6_ / 2;
         this.m_numTargets_txt.y = _loc2_ + _loc6_ / 2 - this.m_numTargets_txt.textHeight / 2;
         this.m_iconSafes.y = _loc2_ + _loc6_ / 2;
         this.m_numSafes_txt.y = _loc2_ + _loc6_ / 2 - this.m_numSafes_txt.textHeight / 2;
         this.m_iconMules.y = _loc2_ + _loc6_ / 2;
         this.m_numMules_txt.y = _loc2_ + _loc6_ / 2 - this.m_numMules_txt.textHeight / 2;
         this.m_iconSuppliers.y = _loc2_ + _loc6_ / 2;
         this.m_numSuppliers_txt.y = _loc2_ + _loc6_ / 2 - this.m_numSuppliers_txt.textHeight / 2;
         _loc2_ += _loc6_ + DYGAP;
         _loc3_ = Number(DYGAP);
      }
      var _loc7_:int = int(param1.bonusRequirements.length);
      while(this.m_bonusRequirements.numChildren > _loc7_)
      {
         this.m_bonusRequirements.removeChildAt(this.m_bonusRequirements.numChildren - 1);
      }
      while(this.m_bonusRequirements.numChildren < _loc7_)
      {
         _loc8_ = new iconsAll76x76View();
         _loc8_.y = _loc8_.height / 2;
         this.m_bonusRequirements.addChild(_loc8_);
      }
      var _loc9_:int = 0;
      while(_loc9_ < _loc7_)
      {
         _loc8_ = iconsAll76x76View(this.m_bonusRequirements.getChildAt(_loc9_));
         _loc12_ = String(param1.bonusRequirements[_loc9_].icon);
         MenuUtils.setupIcon(_loc8_,_loc12_ == "" ? "blank" : _loc12_,16777215,true,false,16777215,0,0,false);
         _loc8_.x = _loc8_.width / 2 + _loc9_ * (_loc8_.width * 1.5);
         _loc9_++;
      }
      if(_loc7_ > 0)
      {
         this.m_bonusRequirements.y = _loc2_;
         _loc2_ += this.m_bonusRequirements.height + DYGAP;
         _loc3_ = Number(DYGAP);
      }
      var _loc10_:Number = Math.max(this.m_destinationName_txt.textWidth,_loc4_ - PXPADDING,this.m_bonusRequirements.width);
      var _loc11_:Number = _loc2_ - _loc3_ - PXPADDING;
      this.m_dottedLine.updateLineLength(_loc10_);
      this.m_backgroundWidth = Math.max(_loc10_,this.m_dottedLine.dottedLineLength) + 2 * PXPADDING;
      this.m_backgroundHeight = _loc11_ + 2 * PXPADDING;
   }
}

import common.Localization;
import common.menu.MenuConstants;
import common.menu.MenuUtils;
import flash.display.Shape;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

class PayoutBlock extends Sprite
{
   
   private static const PXPADDING:Number = 5;
    
   
   private var m_background:Shape;
   
   private var m_amount_txt:TextField;
   
   private var m_merces_txt:TextField;
   
   private var m_payout_txt:TextField;
   
   public function PayoutBlock()
   {
      this.m_background = new Shape();
      this.m_amount_txt = new TextField();
      this.m_merces_txt = new TextField();
      this.m_payout_txt = new TextField();
      super();
      this.m_background.name = "m_background";
      this.m_amount_txt.name = "m_amount_txt";
      this.m_merces_txt.name = "m_merces_txt";
      this.m_payout_txt.name = "m_payout_txt";
      this.m_background.graphics.beginFill(16777215);
      this.m_background.graphics.drawRect(0,0,100,100);
      this.m_background.graphics.endFill();
      MenuUtils.setupText(this.m_amount_txt,"",30,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorBlack);
      MenuUtils.setupText(this.m_merces_txt,"",15,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorBlack);
      MenuUtils.setupText(this.m_payout_txt,"",30,MenuConstants.FONT_TYPE_LIGHT,MenuConstants.FontColorBlack);
      this.m_payout_txt.htmlText = Localization.get("UI_EVEREGREEN_SAFEHOUSE_WORLDMAP_ELIMINATIONPAYOUT").toUpperCase();
      this.m_merces_txt.htmlText = Localization.get("UI_EVERGREEN_MERCES");
      this.m_amount_txt.autoSize = TextFieldAutoSize.LEFT;
      this.m_merces_txt.autoSize = TextFieldAutoSize.LEFT;
      this.m_payout_txt.autoSize = TextFieldAutoSize.LEFT;
      addChild(this.m_background);
      addChild(this.m_payout_txt);
      addChild(this.m_amount_txt);
      addChild(this.m_merces_txt);
      this.m_payout_txt.x = PXPADDING;
      this.m_payout_txt.y = PXPADDING;
      this.m_amount_txt.x = PXPADDING * 2 + this.m_payout_txt.textWidth;
      this.m_amount_txt.y = PXPADDING;
      this.m_merces_txt.y = 9;
   }
   
   public function setAmount(param1:int) : void
   {
      this.m_amount_txt.htmlText = MenuUtils.formatNumber(param1);
      this.m_merces_txt.x = this.m_amount_txt.x + this.m_amount_txt.textWidth + 6;
      this.m_background.width = this.m_merces_txt.x + this.m_merces_txt.textWidth + this.m_amount_txt.textWidth + PXPADDING + 5;
      this.m_background.height = this.m_amount_txt.y + this.m_amount_txt.textHeight + PXPADDING;
   }
}

import common.menu.MenuConstants;
import common.menu.MenuUtils;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

class BonusRequirement extends Sprite
{
   
   public static const DXGAPBETWEENICONANDTITLE:Number = 10;
    
   
   private var m_icon:iconsAll76x76View;
   
   private var m_title_txt:TextField;
   
   public function BonusRequirement()
   {
      this.m_icon = new iconsAll76x76View();
      this.m_title_txt = new TextField();
      super();
      this.m_icon.name = "m_icon";
      this.m_title_txt.name = "m_title_txt";
      addChild(this.m_icon);
      addChild(this.m_title_txt);
      this.m_icon.scaleX = this.m_icon.scaleY = 0.5;
      this.m_icon.x = this.m_icon.width / 2;
      this.m_icon.y = this.m_icon.height / 2;
      MenuUtils.setupText(this.m_title_txt,"",18,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
      this.m_title_txt.autoSize = TextFieldAutoSize.LEFT;
      this.m_title_txt.multiline = true;
      this.m_title_txt.wordWrap = true;
      this.m_title_txt.x = this.m_icon.x + this.m_icon.width / 2 + DXGAPBETWEENICONANDTITLE;
      this.m_title_txt.width = ExpandedTooltipContent.DXCONTENTWIDTH / 2 - ExpandedTooltipContent.PXPADDING / 2 - this.m_title_txt.x;
   }
   
   public function onSetData(param1:String, param2:String) : void
   {
      MenuUtils.setupIcon(this.m_icon,param1 == "" ? "blank" : param1,16777215,true,false,16777215,0,0,false);
      this.m_title_txt.htmlText = param2;
      if(this.m_title_txt.numLines == 1)
      {
         this.m_title_txt.y = this.m_icon.height / 2 - this.m_title_txt.textHeight / 2 - 2;
      }
      else
      {
         this.m_title_txt.y = -4;
      }
   }
}

import common.Localization;
import common.menu.MenuConstants;
import common.menu.MenuUtils;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import hud.evergreen.misc.DottedLineAlt;

class BonusRequirementsBlock extends Sprite
{
   
   public static const DYGAP:Number = 20;
    
   
   private var m_header_txt:TextField;
   
   private var m_dottedLine:DottedLineAlt;
   
   private var m_bonusRequirements:Vector.<BonusRequirement>;
   
   private var m_dyContentHeight:Number = 0;
   
   public function BonusRequirementsBlock()
   {
      this.m_header_txt = new TextField();
      this.m_dottedLine = new DottedLineAlt(1);
      this.m_bonusRequirements = new Vector.<BonusRequirement>();
      super();
      this.m_header_txt.name = "m_header_txt";
      this.m_dottedLine.name = "m_dottedLine";
      addChild(this.m_header_txt);
      addChild(this.m_dottedLine);
      MenuUtils.setupText(this.m_header_txt,"",18,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
      this.m_header_txt.autoSize = TextFieldAutoSize.LEFT;
      this.m_header_txt.text = Localization.get("UI_EVEREGREEN_SAFEHOUSE_WORLDMAP_BONUSREQUIREMENTS_HEADER").toUpperCase();
      this.m_dottedLine.y = this.m_header_txt.y + this.m_header_txt.textHeight + 10;
      this.m_dottedLine.updateLineLength(ExpandedTooltipContent.DXCONTENTWIDTH);
   }
   
   public function get dyContentHeight() : Number
   {
      return this.m_dyContentHeight;
   }
   
   public function onSetData(param1:Object) : void
   {
      var _loc3_:BonusRequirement = null;
      var _loc9_:* = false;
      if(param1.bonusRequirements.length == 0)
      {
         this.visible = false;
         this.m_dyContentHeight = 0;
         return;
      }
      this.visible = true;
      var _loc2_:int = int(param1.bonusRequirements.length);
      while(this.m_bonusRequirements.length > _loc2_)
      {
         removeChild(this.m_bonusRequirements.pop());
      }
      while(this.m_bonusRequirements.length < _loc2_)
      {
         _loc3_ = new BonusRequirement();
         this.m_bonusRequirements.push(_loc3_);
         addChild(_loc3_);
      }
      var _loc4_:Number = this.m_dottedLine.y + this.m_dottedLine.dottedLineThickness + DYGAP;
      var _loc5_:Number = Number(DYGAP);
      var _loc6_:Number = 0;
      var _loc7_:Boolean = false;
      var _loc8_:int = 0;
      while(_loc8_ < param1.bonusRequirements.length)
      {
         _loc3_ = this.m_bonusRequirements[_loc8_];
         _loc3_.onSetData(param1.bonusRequirements[_loc8_].icon,param1.bonusRequirements[_loc8_].lstrTitle);
         _loc3_.y = _loc4_;
         if(_loc9_ = _loc8_ % 2 == 0)
         {
            _loc3_.x = 0;
            _loc6_ = Number(_loc3_.height);
         }
         else
         {
            _loc3_.x = ExpandedTooltipContent.DXCONTENTWIDTH / 2 + ExpandedTooltipContent.PXPADDING / 2;
            _loc6_ = Math.max(_loc6_,_loc3_.height);
            _loc4_ = (_loc4_ += _loc6_) + DYGAP;
            _loc5_ = Number(DYGAP);
         }
         _loc7_ = _loc9_;
         _loc8_++;
      }
      if(_loc7_)
      {
         _loc4_ = (_loc4_ += _loc6_) + DYGAP;
         _loc5_ = Number(DYGAP);
      }
      this.m_dyContentHeight = _loc4_ - _loc5_;
   }
}

import common.Animate;
import common.Localization;
import common.menu.MenuConstants;
import common.menu.MenuUtils;
import flash.display.CapsStyle;
import flash.display.JointStyle;
import flash.display.LineScaleMode;
import flash.display.Shape;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

class AirTicketButton extends Sprite
{
   
   public static const DYHEIGHT:Number = 70;
   
   public static const STATE_BOOKMESSAGE:int = 1;
   
   public static const STATE_CANCELMESSAGE:int = 2;
   
   private static const s_lstrBook:String = Localization.get("UI_EVEREGREEN_SAFEHOUSE_WORLDMAP_SETNEXTDESTINATION").toUpperCase();
   
   private static const s_lstrCancel:String = Localization.get("UI_EVEREGREEN_SAFEHOUSE_WORLDMAP_UNSETNEXTDESTINATION").toUpperCase();
    
   
   private var m_icon:iconsAll76x76View;
   
   private var m_label_txt:TextField;
   
   private var m_blinkOutline:Shape;
   
   private var m_state:int;
   
   public function AirTicketButton()
   {
      this.m_icon = new iconsAll76x76View();
      this.m_label_txt = new TextField();
      this.m_blinkOutline = new Shape();
      super();
      this.m_icon.name = "m_icon";
      this.m_label_txt.name = "m_label_txt";
      this.m_blinkOutline.name = "m_blinkOutline";
      addChild(this.m_icon);
      addChild(this.m_label_txt);
      addChild(this.m_blinkOutline);
      this.graphics.beginFill(16777215);
      this.graphics.drawRect(0,0,ExpandedTooltipContent.DXCONTENTWIDTH,DYHEIGHT);
      this.graphics.endFill();
      MenuUtils.setupIcon(this.m_icon,"location",0,false,false,0,0,0,true);
      this.m_icon.height = 38;
      this.m_icon.width = 38;
      this.m_icon.x = DYHEIGHT / 2;
      this.m_icon.y = DYHEIGHT / 2;
      MenuUtils.setupText(this.m_label_txt,"X",26,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorBlack);
      this.m_label_txt.autoSize = TextFieldAutoSize.LEFT;
      this.m_label_txt.x = this.m_icon.x + this.m_icon.width;
      this.m_label_txt.y = this.m_icon.y - this.m_label_txt.textHeight / 2;
      this.m_blinkOutline.graphics.lineStyle(3,16777215,1,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.MITER);
      this.m_blinkOutline.graphics.drawRect(-ExpandedTooltipContent.DXCONTENTWIDTH / 2,-DYHEIGHT / 2,ExpandedTooltipContent.DXCONTENTWIDTH,DYHEIGHT);
      this.m_blinkOutline.x = ExpandedTooltipContent.DXCONTENTWIDTH / 2;
      this.m_blinkOutline.y = DYHEIGHT / 2;
      this.m_label_txt.text = s_lstrBook;
      this.m_state = STATE_BOOKMESSAGE;
   }
   
   public function get dyContentHeight() : Number
   {
      return DYHEIGHT;
   }
   
   public function showBookMessage() : void
   {
      this.pulse();
      this.changeState(STATE_BOOKMESSAGE,s_lstrBook);
   }
   
   public function showCancelMessage() : void
   {
      this.pulse();
      this.changeState(STATE_CANCELMESSAGE,s_lstrCancel);
   }
   
   public function stopBlinkAnimation() : void
   {
      Animate.kill(this.m_blinkOutline);
   }
   
   private function pulse() : void
   {
      var PXANIMDELTA:Number = ExpandedTooltipContent.PXPADDING * 1.5;
      Animate.fromTo(this.m_blinkOutline,30 / 60,40 / 60,{
         "width":ExpandedTooltipContent.DXCONTENTWIDTH,
         "height":DYHEIGHT,
         "alpha":1
      },{
         "width":ExpandedTooltipContent.DXCONTENTWIDTH + PXANIMDELTA,
         "height":DYHEIGHT + PXANIMDELTA,
         "alpha":0
      },Animate.ExpoOut,function():void
      {
         m_blinkOutline.alpha = 0;
         m_blinkOutline.scaleX = 1;
         m_blinkOutline.scaleY = 1;
         pulse();
      });
      this.m_blinkOutline.alpha = 0;
      this.m_blinkOutline.scaleX = 1;
      this.m_blinkOutline.scaleY = 1;
   }
   
   private function changeState(param1:int, param2:String) : void
   {
      var state:int = param1;
      var lstrLabel:String = param2;
      if(this.m_state != state)
      {
         Animate.to(this.m_icon,0.1,0,{
            "width":1,
            "height":1
         },Animate.SineIn,Animate.to,this.m_icon,0.1,0,{
            "width":38,
            "height":38
         },Animate.SineOut);
         Animate.to(this.m_label_txt,0.1,0,{"alpha":0},Animate.SineIn,function():void
         {
            m_label_txt.text = lstrLabel;
            Animate.to(m_label_txt,0.1,0,{"alpha":1},Animate.SineOut);
         });
         this.m_state = state;
      }
   }
}

import common.Localization;
import common.menu.MenuConstants;
import common.menu.MenuUtils;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

class TooltipHeadline extends Sprite
{
   
   public static const DXWIDTH:Number = 650 + 2 * 30;
   
   public static const DYHEIGHT:Number = 70;
    
   
   private var m_icon:iconsAll76x76View;
   
   private var m_title_txt:TextField;
   
   private var m_subtitle_txt:TextField;
   
   public function TooltipHeadline(param1:uint, param2:String, param3:String, param4:String)
   {
      this.m_icon = new iconsAll76x76View();
      this.m_title_txt = new TextField();
      this.m_subtitle_txt = new TextField();
      super();
      this.m_icon.name = "m_icon";
      this.m_title_txt.name = "m_title_txt";
      this.m_subtitle_txt.name = "m_subtitle_txt";
      addChild(this.m_icon);
      addChild(this.m_title_txt);
      addChild(this.m_subtitle_txt);
      this.graphics.beginFill(param1,0.65);
      this.graphics.drawRect(0,0,DXWIDTH,DYHEIGHT);
      this.graphics.endFill();
      MenuUtils.setupIcon(this.m_icon,param2,16777215,true,false,0,0,0,false);
      this.m_icon.height = 42;
      this.m_icon.width = 42;
      this.m_icon.x = DYHEIGHT / 2;
      this.m_icon.y = DYHEIGHT / 2;
      MenuUtils.setupText(this.m_title_txt,Localization.get(param3).toUpperCase(),24,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
      MenuUtils.setupText(this.m_subtitle_txt,Localization.get(param4).toUpperCase(),14,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
      this.m_title_txt.autoSize = TextFieldAutoSize.LEFT;
      this.m_subtitle_txt.autoSize = TextFieldAutoSize.LEFT;
      this.m_title_txt.x = this.m_icon.x + this.m_icon.width / 2 + 10;
      this.m_subtitle_txt.x = this.m_icon.x + this.m_icon.width / 2 + 10;
      this.m_title_txt.y = this.m_icon.y - this.m_icon.height / 2 - 4;
      this.m_subtitle_txt.y = this.m_icon.y + this.m_icon.height / 2 - this.m_subtitle_txt.textHeight;
   }
   
   public function set showSubtitle(param1:Boolean) : void
   {
      this.m_subtitle_txt.visible = param1;
   }
}

import common.menu.MenuConstants;
import common.menu.MenuUtils;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import hud.evergreen.misc.LocationIntelBlock;

class ExpandedTooltipContent extends Sprite
{
   
   public static const PXPADDING:Number = 30;
   
   public static const DYGAP:Number = 40;
   
   public static const DXCONTENTWIDTH:Number = 650;
    
   
   private var m_headlineAlerted:TooltipHeadline;
   
   private var m_headlineHotMission:TooltipHeadline;
   
   private var m_destinationCountry_txt:TextField;
   
   private var m_destinationCity_txt:TextField;
   
   private var m_payoutBlock:PayoutBlock;
   
   private var m_locationIntelBlock:LocationIntelBlock;
   
   private var m_bonusRequirementsBlock:BonusRequirementsBlock;
   
   private var m_airTicketButton:AirTicketButton;
   
   private var m_backgroundWidth:Number = 0;
   
   private var m_backgroundHeight:Number = 0;
   
   public function ExpandedTooltipContent()
   {
      this.m_headlineAlerted = new TooltipHeadline(MenuConstants.COLOR_YELLOW,"warning","UI_EVEREGREEN_SAFEHOUSE_WORLDMAP_TERRITORYHEADLINE_ALERTED_TITLE","UI_EVEREGREEN_SAFEHOUSE_WORLDMAP_TERRITORYHEADLINE_ALERTED_SUBTITLE");
      this.m_headlineHotMission = new TooltipHeadline(MenuConstants.COLOR_PURPLE,"evergreen_showdown_mission","UI_EVEREGREEN_SAFEHOUSE_WORLDMAP_TERRITORYHEADLINE_HOTMISSION_TITLE","UI_EVEREGREEN_SAFEHOUSE_WORLDMAP_TERRITORYHEADLINE_HOTMISSION_SUBTITLE");
      this.m_destinationCountry_txt = new TextField();
      this.m_destinationCity_txt = new TextField();
      this.m_payoutBlock = new PayoutBlock();
      this.m_locationIntelBlock = new LocationIntelBlock(ExpandedTooltipContent.DXCONTENTWIDTH,ExpandedTooltipContent.PXPADDING);
      this.m_bonusRequirementsBlock = new BonusRequirementsBlock();
      this.m_airTicketButton = new AirTicketButton();
      super();
      this.m_headlineAlerted.name = "m_headlineAlerted";
      this.m_headlineHotMission.name = "m_headlineHotMission";
      this.m_destinationCountry_txt.name = "m_destinationCountry_txt";
      this.m_destinationCity_txt.name = "m_destinationCity_txt";
      this.m_payoutBlock.name = "m_payoutBlock";
      this.m_locationIntelBlock.name = "m_locationIntelBlock";
      this.m_bonusRequirementsBlock.name = "m_bonusRequirementsBlock";
      this.m_airTicketButton.name = "m_airTicketButton";
      addChild(this.m_headlineAlerted);
      addChild(this.m_headlineHotMission);
      addChild(this.m_destinationCountry_txt);
      addChild(this.m_destinationCity_txt);
      addChild(this.m_payoutBlock);
      addChild(this.m_locationIntelBlock);
      addChild(this.m_bonusRequirementsBlock);
      addChild(this.m_airTicketButton);
      MenuUtils.setupText(this.m_destinationCountry_txt,"",16,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
      MenuUtils.setupText(this.m_destinationCity_txt,"",36,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
      this.m_destinationCountry_txt.x = PXPADDING;
      this.m_destinationCity_txt.x = PXPADDING;
      this.m_payoutBlock.x = PXPADDING;
      this.m_locationIntelBlock.x = PXPADDING;
      this.m_bonusRequirementsBlock.x = PXPADDING;
      this.m_airTicketButton.x = PXPADDING;
      this.m_destinationCountry_txt.autoSize = TextFieldAutoSize.LEFT;
      this.m_destinationCity_txt.autoSize = TextFieldAutoSize.LEFT;
      this.m_headlineAlerted.y = -this.m_headlineAlerted.height;
      this.m_headlineHotMission.y = -this.m_headlineHotMission.height;
   }
   
   public function get backgroundWidth() : Number
   {
      return this.m_backgroundWidth;
   }
   
   public function get backgroundHeight() : Number
   {
      return this.m_backgroundHeight;
   }
   
   public function onSetData(param1:Object) : void
   {
      this.m_headlineHotMission.visible = param1.isHotMission;
      this.m_headlineAlerted.visible = param1.isAlerted;
      if(this.m_headlineAlerted.visible)
      {
         this.m_headlineHotMission.y = this.m_headlineAlerted.y - this.m_headlineHotMission.height;
         this.m_headlineAlerted.showSubtitle = !param1.isHotMission;
      }
      else
      {
         this.m_headlineHotMission.y = -this.m_headlineHotMission.height;
      }
      var _loc2_:Number = Number(PXPADDING);
      var _loc3_:Number = 0;
      this.m_destinationCountry_txt.text = param1.lstrDestinationCountry.toUpperCase();
      this.m_destinationCountry_txt.y = _loc2_;
      _loc2_ += this.m_destinationCountry_txt.textHeight;
      this.m_destinationCity_txt.text = param1.lstrDestinationCity.toUpperCase();
      this.m_destinationCity_txt.y = _loc2_;
      _loc2_ += this.m_destinationCity_txt.textHeight;
      _loc2_ += 5;
      _loc3_ = 5;
      this.m_payoutBlock.setAmount(param1.mercesPayout);
      this.m_payoutBlock.y = _loc2_;
      _loc2_ += this.m_payoutBlock.height;
      _loc2_ += DYGAP;
      _loc3_ = Number(DYGAP);
      this.m_locationIntelBlock.onSetData(param1);
      if(this.m_locationIntelBlock.dyContentHeight > 0)
      {
         this.m_locationIntelBlock.y = _loc2_;
         _loc2_ += this.m_locationIntelBlock.dyContentHeight;
         _loc2_ += DYGAP;
         _loc3_ = Number(DYGAP);
      }
      this.m_bonusRequirementsBlock.onSetData(param1);
      if(this.m_bonusRequirementsBlock.dyContentHeight > 0)
      {
         this.m_bonusRequirementsBlock.y = _loc2_;
         _loc2_ += this.m_bonusRequirementsBlock.dyContentHeight;
         _loc2_ += DYGAP;
         _loc3_ = Number(DYGAP);
      }
      if(param1.isThisSelectedToTravelNext)
      {
         this.m_airTicketButton.showCancelMessage();
      }
      else
      {
         this.m_airTicketButton.showBookMessage();
      }
      this.m_airTicketButton.y = _loc2_ + DYGAP;
      _loc2_ = this.m_airTicketButton.y + this.m_airTicketButton.dyContentHeight;
      _loc2_ += DYGAP;
      _loc3_ = Number(DYGAP);
      var _loc4_:Number = _loc2_ - _loc3_ - PXPADDING;
      this.m_backgroundWidth = DXCONTENTWIDTH + 2 * PXPADDING;
      this.m_backgroundHeight = _loc4_ + 2 * PXPADDING;
   }
   
   public function stopLoopingAnimations() : void
   {
      this.m_airTicketButton.stopBlinkAnimation();
   }
}
