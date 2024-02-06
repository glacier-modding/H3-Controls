package hud.evergreen.menuoverlay
{
   import common.Animate;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Shape;
   import flash.display.Sprite;
   import hud.evergreen.IMenuOverlayComponent;
   
   public class HeadlineComponent extends Sprite implements IMenuOverlayComponent
   {
      
      public static const PXPADDING:Number = 25;
      
      public static const DYMARGINBOTTOM:Number = 90;
       
      
      private var m_background:Shape;
      
      private var m_content:Sprite;
      
      private var m_titleRow:TitleRow;
      
      private var m_microRow:MicroRow;
      
      private var m_yBottom:Number = 0;
      
      private var m_isTitleRowVisible:Boolean = false;
      
      private var m_isMicroRowVisible:Boolean = false;
      
      private var m_isEmpty:Boolean = true;
      
      public function HeadlineComponent()
      {
         this.m_background = new Shape();
         this.m_content = new Sprite();
         this.m_titleRow = new TitleRow();
         this.m_microRow = new MicroRow();
         super();
         this.m_background.name = "m_background";
         this.m_background.graphics.beginFill(MenuConstants.COLOR_MENU_TABS_BACKGROUND,0.85);
         this.m_background.graphics.drawRect(0,0,25,25);
         this.m_background.graphics.endFill();
         addChild(this.m_background);
         this.m_content.name = "m_content";
         MenuUtils.addDropShadowFilter(this.m_content);
         addChild(this.m_content);
         this.m_titleRow.name = "m_titleRow";
         this.m_microRow.name = "m_microRow";
         this.m_content.addChild(this.m_titleRow);
         this.m_content.addChild(this.m_microRow);
         this.m_content.x = PXPADDING;
      }
      
      public function isLeftAligned() : Boolean
      {
         return true;
      }
      
      public function onControlLayoutChanged() : void
      {
      }
      
      public function onUsableSizeChanged(param1:Number, param2:Number, param3:Number) : void
      {
         this.m_yBottom = param3;
         this.m_content.y = param3 - DYMARGINBOTTOM - PXPADDING;
         this.updateLayout();
      }
      
      public function onSetData(param1:Object) : void
      {
         this.m_titleRow.onSetData(param1);
         this.m_microRow.onSetData(param1);
         this.updateLayout();
      }
      
      private function updateLayout() : void
      {
         var y:Number = NaN;
         var dyGapLastUsed:Number = NaN;
         var dyBackgroundHeight:Number = NaN;
         var wasTitleRowVisible:Boolean = this.m_isTitleRowVisible;
         var wasMicroRowVisible:Boolean = this.m_isMicroRowVisible;
         var wasEmpty:Boolean = this.m_isEmpty;
         this.m_isTitleRowVisible = this.m_titleRow.visible;
         this.m_isMicroRowVisible = this.m_microRow.visible;
         this.m_isEmpty = !this.m_isTitleRowVisible && !this.m_isMicroRowVisible;
         if(this.m_isEmpty)
         {
            if(!wasEmpty)
            {
               Animate.to(this.m_background,0.1,0,{"width":1},Animate.SineOut,function():void
               {
                  m_background.visible = false;
               });
            }
         }
         else
         {
            y = 0;
            dyGapLastUsed = 0;
            if(this.m_isMicroRowVisible)
            {
               y -= MicroRow.PXMICROICONSIZE;
               this.m_microRow.y = y;
               this.m_microRow.x = 0;
               dyGapLastUsed = PXPADDING * MicroRow.MICROICONSCALE;
               y -= dyGapLastUsed;
            }
            if(this.m_isTitleRowVisible)
            {
               this.m_microRow.x = this.m_titleRow.dxIconOffset + 4;
               y -= TitleRow.PXICONSIZE;
               if(!wasTitleRowVisible)
               {
                  this.m_titleRow.y = y;
               }
               else
               {
                  Animate.to(this.m_titleRow,0.1,0,{"y":y},Animate.SineOut);
               }
               dyGapLastUsed = PXPADDING;
               y -= dyGapLastUsed;
            }
            y += dyGapLastUsed;
            this.m_background.visible = true;
            Animate.to(this.m_background,0.1,0,{"width":Math.max(this.m_titleRow.dxTotalWidth,this.m_microRow.x + this.m_microRow.dxTotalWidth) + 2 * PXPADDING},Animate.SineOut);
            dyBackgroundHeight = Math.abs(y) + 2 * PXPADDING;
            if(wasEmpty)
            {
               this.m_background.y = this.m_yBottom - DYMARGINBOTTOM - dyBackgroundHeight;
               this.m_background.height = dyBackgroundHeight;
            }
            else
            {
               Animate.addTo(this.m_background,0.1,0,{
                  "y":this.m_yBottom - DYMARGINBOTTOM - dyBackgroundHeight,
                  "height":dyBackgroundHeight
               },Animate.SineOut);
            }
         }
      }
   }
}

import common.menu.MenuConstants;
import common.menu.MenuUtils;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

class TitleRow extends Sprite
{
   
   public static const PXICONSIZE:Number = 50;
   
   public static const PXGAPBETWEENICONANDTITLE:Number = 12;
    
   
   private var m_title_txt:TextField;
   
   private var m_header_txt:TextField;
   
   private var m_icon:iconsAll76x76View;
   
   private var m_dxIconOffset:Number = 0;
   
   public function TitleRow()
   {
      this.m_title_txt = new TextField();
      this.m_header_txt = new TextField();
      this.m_icon = new iconsAll76x76View();
      super();
      this.m_title_txt.name = "m_title_txt";
      this.m_header_txt.name = "m_header_txt";
      this.m_icon.name = "m_icon";
      MenuUtils.setupText(this.m_title_txt,"",30,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
      MenuUtils.setupText(this.m_header_txt,"",16,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
      this.m_title_txt.autoSize = TextFieldAutoSize.LEFT;
      this.m_header_txt.autoSize = TextFieldAutoSize.LEFT;
      addChild(this.m_title_txt);
      addChild(this.m_header_txt);
      addChild(this.m_icon);
      this.m_icon.scaleX = PXICONSIZE / 76;
      this.m_icon.scaleY = PXICONSIZE / 76;
      this.m_icon.x = PXICONSIZE / 2;
      this.m_icon.y = PXICONSIZE / 2;
   }
   
   public function get dxIconOffset() : Number
   {
      return this.m_dxIconOffset;
   }
   
   public function get dxTotalWidth() : Number
   {
      return Math.max(this.m_dxIconOffset + Math.max(this.m_title_txt.textWidth,this.m_header_txt.textWidth));
   }
   
   public function onSetData(param1:Object) : void
   {
      if(param1 == null || param1.lstrTitle == null || param1.lstrTitle == "")
      {
         this.m_title_txt.visible = false;
         this.m_title_txt.text = "";
      }
      else
      {
         this.m_title_txt.visible = true;
         this.m_title_txt.text = param1.lstrTitle.toUpperCase();
      }
      if(param1 == null || param1.lstrHeader == null || param1.lstrHeader == "")
      {
         this.m_header_txt.visible = false;
         this.m_header_txt.text = "";
      }
      else
      {
         this.m_header_txt.visible = true;
         this.m_header_txt.text = param1.lstrHeader.toUpperCase();
      }
      if(param1 == null || param1.icon == null || param1.icon == "")
      {
         this.m_icon.visible = false;
      }
      else
      {
         this.m_icon.visible = true;
         MenuUtils.setupIcon(this.m_icon,param1.icon,MenuConstants.COLOR_WHITE,false,false,16777215,0,0,true);
      }
      if(!this.m_title_txt.visible && !this.m_header_txt.visible && !this.m_icon.visible)
      {
         this.visible = false;
      }
      else
      {
         this.visible = true;
         this.m_dxIconOffset = !!this.m_icon.visible ? PXICONSIZE + PXGAPBETWEENICONANDTITLE : 0;
         this.m_title_txt.x = this.m_dxIconOffset;
         this.m_header_txt.x = this.m_dxIconOffset;
         if(this.m_header_txt.visible)
         {
            this.m_header_txt.y = -2;
            this.m_title_txt.y = PXICONSIZE - this.m_title_txt.textHeight + 2;
         }
         else
         {
            this.m_title_txt.y = PXICONSIZE / 2 - this.m_title_txt.textHeight / 2;
         }
      }
   }
}

import common.menu.MenuConstants;
import common.menu.MenuUtils;
import flash.display.CapsStyle;
import flash.display.JointStyle;
import flash.display.LineScaleMode;
import flash.display.Shape;
import flash.display.Sprite;
import flash.geom.ColorTransform;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import hud.evergreen.EvergreenUtils;

class MicroLabel extends Sprite
{
    
   
   private var m_txt:TextField;
   
   private var m_background:Shape;
   
   public function MicroLabel()
   {
      this.m_txt = new TextField();
      this.m_background = new Shape();
      super();
      this.m_txt.name = "m_txt";
      this.m_background.name = "m_background";
      addChild(this.m_background);
      addChild(this.m_txt);
      MenuUtils.setupText(this.m_txt,"",16,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
      this.m_txt.autoSize = TextFieldAutoSize.LEFT;
      this.m_txt.x = 5;
      this.m_txt.y = 2;
      this.m_background.graphics.lineStyle(6,8355711,1,false,LineScaleMode.VERTICAL,CapsStyle.NONE,JointStyle.ROUND);
      this.m_background.graphics.beginFill(8355711);
      this.m_background.graphics.drawRect(3,3,100,25 - 6);
      this.m_background.graphics.endFill();
   }
   
   public function onSetData(param1:int, param2:String) : void
   {
      this.m_txt.text = param2.toUpperCase();
      this.m_background.width = 5 + this.m_txt.textWidth + 9;
      var _loc3_:ColorTransform = this.m_background.transform.colorTransform;
      _loc3_.color = EvergreenUtils.LABELBGCOLOR[param1];
      this.m_background.transform.colorTransform = _loc3_;
   }
}

import common.Animate;
import common.menu.MenuConstants;
import common.menu.MenuUtils;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

class MicroRow extends Sprite
{
   
   public static const PXMICROICONSIZE:Number = 25;
   
   public static const MICROICONSCALE:Number = 25 / 76;
   
   public static const PXPADDING:Number = 25 * MICROICONSCALE;
    
   
   private var m_labels:Sprite;
   
   private var m_microicons:Sprite;
   
   private var m_micromessage_txt:TextField;
   
   private var m_dxTotalWidth:Number = 0;
   
   public function MicroRow()
   {
      this.m_labels = new Sprite();
      this.m_microicons = new Sprite();
      this.m_micromessage_txt = new TextField();
      super();
      this.m_labels.name = "m_labels";
      this.m_microicons.name = "m_microicons";
      this.m_micromessage_txt.name = "m_micromessage_txt";
      addChild(this.m_labels);
      addChild(this.m_microicons);
      addChild(this.m_micromessage_txt);
      this.m_microicons.scaleX = MICROICONSCALE;
      this.m_microicons.scaleY = MICROICONSCALE;
      MenuUtils.setupText(this.m_micromessage_txt,"",18,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
      this.m_micromessage_txt.autoSize = TextFieldAutoSize.LEFT;
      this.m_micromessage_txt.y = 2;
   }
   
   public function get dxTotalWidth() : Number
   {
      return this.m_dxTotalWidth;
   }
   
   public function onSetData(param1:Object) : void
   {
      var _loc8_:MicroLabel = null;
      var _loc9_:iconsAll76x76View = null;
      this.m_dxTotalWidth = 0;
      var _loc2_:Number = 0;
      this.m_labels.x = this.m_dxTotalWidth;
      var _loc3_:int = int(this.m_labels.numChildren);
      var _loc4_:int = param1 == null || param1.labels == null ? 0 : int(param1.labels.length);
      while(this.m_labels.numChildren > _loc4_)
      {
         this.m_labels.removeChildAt(this.m_labels.numChildren - 1);
      }
      while(this.m_labels.numChildren < _loc4_)
      {
         this.m_labels.addChild(new MicroLabel());
      }
      var _loc5_:int = 0;
      while(_loc5_ < _loc4_)
      {
         (_loc8_ = MicroLabel(this.m_labels.getChildAt(_loc5_))).onSetData(param1.labels[_loc5_].purpose,param1.labels[_loc5_].lstrTitle);
         _loc2_ = Number(PXPADDING);
         this.m_dxTotalWidth = this.m_labels.x + (_loc8_.x + _loc8_.width) + _loc2_;
         _loc5_++;
      }
      this.m_microicons.x = this.m_dxTotalWidth;
      var _loc6_:int = int(this.m_microicons.numChildren);
      var _loc7_:int = param1 == null || param1.microicons == null ? 0 : int(param1.microicons.length);
      while(this.m_microicons.numChildren > _loc7_)
      {
         this.m_microicons.removeChildAt(this.m_microicons.numChildren - 1);
      }
      while(this.m_microicons.numChildren < _loc7_)
      {
         this.m_microicons.addChild(new iconsAll76x76View());
      }
      _loc5_ = 0;
      while(_loc5_ < _loc7_)
      {
         _loc9_ = iconsAll76x76View(this.m_microicons.getChildAt(_loc5_));
         MenuUtils.setupIcon(_loc9_,param1.microicons[_loc5_],MenuConstants.COLOR_WHITE,false,false,16777215,0,0,true);
         _loc9_.x = 76 / 2 + _loc5_ * (76 + PXPADDING / MICROICONSCALE);
         _loc9_.y = 76 / 2;
         this.m_dxTotalWidth = this.m_microicons.x + (_loc9_.x + 76 / 2) * MICROICONSCALE;
         if(_loc6_ == 0)
         {
            _loc9_.scaleX = 0;
            _loc9_.scaleY = 0;
            Animate.to(_loc9_,0.1,0,{
               "scaleX":1,
               "scaleY":1
            },Animate.SineOut);
         }
         _loc5_++;
      }
      if(_loc7_ > 0)
      {
         _loc2_ = Number(PXPADDING);
         this.m_dxTotalWidth += _loc2_;
      }
      if(param1 == null || param1.lstrMicroMessage == null || param1.lstrMicroMessage == "")
      {
         this.m_micromessage_txt.visible = false;
         this.m_micromessage_txt.htmlText = "";
      }
      else
      {
         this.m_micromessage_txt.visible = true;
         this.m_micromessage_txt.htmlText = param1.lstrMicroMessage.toUpperCase();
         this.m_micromessage_txt.x = this.m_dxTotalWidth;
         _loc2_ = Number(PXPADDING);
         this.m_dxTotalWidth += this.m_micromessage_txt.textWidth + _loc2_;
      }
      this.m_dxTotalWidth -= _loc2_;
      this.visible = _loc7_ > 0 || Boolean(this.m_micromessage_txt.visible);
   }
}
