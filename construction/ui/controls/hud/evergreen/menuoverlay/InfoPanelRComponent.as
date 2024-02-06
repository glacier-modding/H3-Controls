package hud.evergreen.menuoverlay
{
   import basic.DottedLine;
   import common.Animate;
   import common.CommonUtils;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import hud.evergreen.EvergreenUtils;
   import hud.evergreen.IMenuOverlayComponent;
   
   public class InfoPanelRComponent extends Sprite implements IMenuOverlayComponent
   {
      
      public static const PXMARGINBOTTOM:Number = 0;
      
      public static const PXPADDING:Number = 25;
      
      public static const PXGAPBETWEENICONANDTITLE:Number = 12;
      
      public static const PXICONSIZE:Number = 50;
      
      public static const PXCONTENTWIDTH:Number = 598;
      
      public static const PXGAPBETWEENLABELS:Number = 8;
       
      
      private var m_background:Shape;
      
      private var m_contentMask:Shape;
      
      private var m_content:Sprite;
      
      private var m_icon:iconsAll76x76View;
      
      private var m_title_txt:TextField;
      
      private var m_header_txt:TextField;
      
      private var m_descr_txt:TextField;
      
      private var m_perksHolder:Sprite;
      
      private var m_labelsHolder:Sprite;
      
      private var m_headlineSeparator:DottedLine;
      
      private var m_perkSeparator:DottedLine;
      
      private var m_labelSeparator:DottedLine;
      
      private var m_yTop:Number = 0;
      
      private var m_yBottom:Number = 0;
      
      private var m_isEmpty:Boolean = true;
      
      public function InfoPanelRComponent()
      {
         this.m_background = new Shape();
         this.m_contentMask = new Shape();
         this.m_content = new Sprite();
         this.m_icon = new iconsAll76x76View();
         this.m_title_txt = new TextField();
         this.m_header_txt = new TextField();
         this.m_descr_txt = new TextField();
         this.m_perksHolder = new Sprite();
         this.m_labelsHolder = new Sprite();
         this.m_headlineSeparator = new DottedLine(PXCONTENTWIDTH,MenuConstants.COLOR_WHITE,DottedLine.TYPE_HORIZONTAL,1,2);
         this.m_perkSeparator = new DottedLine(PXCONTENTWIDTH,MenuConstants.COLOR_WHITE,DottedLine.TYPE_HORIZONTAL,1,2);
         this.m_labelSeparator = new DottedLine(PXCONTENTWIDTH,MenuConstants.COLOR_WHITE,DottedLine.TYPE_HORIZONTAL,1,2);
         super();
         this.m_background.name = "m_background";
         this.m_background.graphics.beginFill(MenuConstants.COLOR_MENU_TABS_BACKGROUND,0.85);
         this.m_background.graphics.drawRect(0,0,PXCONTENTWIDTH + 2 * PXPADDING,25);
         this.m_background.graphics.endFill();
         addChild(this.m_background);
         this.m_contentMask.name = "m_contentMask";
         this.m_contentMask.graphics.beginFill(255);
         this.m_contentMask.graphics.drawRect(0,0,PXCONTENTWIDTH + 2 * PXPADDING,25);
         this.m_contentMask.graphics.endFill();
         addChild(this.m_contentMask);
         this.m_content.name = "m_content";
         addChild(this.m_content);
         this.m_content.x = -(PXCONTENTWIDTH + PXPADDING);
         this.m_contentMask.x = -(PXCONTENTWIDTH + PXPADDING * 2);
         this.m_background.x = -(PXCONTENTWIDTH + PXPADDING * 2);
         this.m_content.mask = this.m_contentMask;
         this.m_content.alpha = 0;
         this.m_contentMask.height = 1;
         this.m_background.height = 1;
         this.m_icon.name = "m_icon";
         this.m_title_txt.name = "m_title_txt";
         this.m_header_txt.name = "m_header_txt";
         this.m_headlineSeparator.name = "m_headlineSeparator";
         this.m_descr_txt.name = "m_descr_txt";
         this.m_perkSeparator.name = "m_perkSeparator";
         this.m_perksHolder.name = "m_perksHolder";
         this.m_labelSeparator.name = "m_labelSeparator";
         this.m_labelsHolder.name = "m_labelsHolder";
         this.m_content.addChild(this.m_icon);
         this.m_content.addChild(this.m_title_txt);
         this.m_content.addChild(this.m_header_txt);
         this.m_content.addChild(this.m_headlineSeparator);
         this.m_content.addChild(this.m_descr_txt);
         this.m_content.addChild(this.m_perkSeparator);
         this.m_content.addChild(this.m_perksHolder);
         this.m_content.addChild(this.m_labelSeparator);
         this.m_content.addChild(this.m_labelsHolder);
         this.m_icon.scaleX = PXICONSIZE / 76;
         this.m_icon.scaleY = PXICONSIZE / 76;
         this.m_icon.x = PXICONSIZE / 2;
         this.m_icon.y = PXICONSIZE / 2;
         MenuUtils.setupText(this.m_title_txt,"",30,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
         MenuUtils.setupText(this.m_header_txt,"",16,MenuConstants.FONT_TYPE_LIGHT,MenuConstants.FontColorWhite);
         MenuUtils.setupText(this.m_descr_txt,"",18,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
         this.m_title_txt.width = PXCONTENTWIDTH - PXICONSIZE - PXGAPBETWEENICONANDTITLE;
         this.m_header_txt.width = PXCONTENTWIDTH - PXICONSIZE - PXGAPBETWEENICONANDTITLE;
         this.m_descr_txt.width = PXCONTENTWIDTH;
         this.m_descr_txt.multiline = true;
         this.m_descr_txt.wordWrap = true;
         this.m_descr_txt.autoSize = TextFieldAutoSize.LEFT;
         var _loc1_:TextFormat = this.m_descr_txt.defaultTextFormat;
         _loc1_.align = TextFormatAlign.JUSTIFY;
         this.m_descr_txt.defaultTextFormat = _loc1_;
      }
      
      public function isLeftAligned() : Boolean
      {
         return false;
      }
      
      public function onControlLayoutChanged() : void
      {
      }
      
      public function onUsableSizeChanged(param1:Number, param2:Number, param3:Number) : void
      {
         this.m_yTop = param2;
         this.m_yBottom = param3;
         this.updateLayout();
      }
      
      public function onSetData(param1:Object) : void
      {
         var _loc9_:ModalItemPerkView = null;
         var _loc10_:ModalDialogItemDetailsKilltypeView = null;
         var _loc11_:ModalDialogItemDetailsPoisonTypeView = null;
         if(param1 == null || param1.icon == null || param1.icon == "")
         {
            this.m_icon.visible = false;
         }
         else
         {
            this.m_icon.visible = true;
            MenuUtils.setupIcon(this.m_icon,param1.icon,MenuConstants.COLOR_WHITE,true,false,16777215,0,0,false);
         }
         if(param1 == null || param1.lstrTitle == null || param1.lstrTitle == "")
         {
            this.m_title_txt.visible = false;
            this.m_title_txt.text = "";
         }
         else
         {
            this.m_title_txt.visible = true;
            this.m_title_txt.text = param1.lstrTitle.toUpperCase();
            MenuUtils.truncateTextfield(this.m_title_txt,1,MenuConstants.FontColorWhite);
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
         if(param1 == null || param1.lstrDescription == null || param1.lstrDescription == "")
         {
            this.m_descr_txt.visible = false;
            this.m_descr_txt.text = "";
         }
         else
         {
            this.m_descr_txt.visible = true;
            this.m_descr_txt.text = param1.lstrDescription;
            CommonUtils.changeFontToGlobalIfNeeded(this.m_descr_txt);
         }
         var _loc2_:int = param1 == null || param1.perks == null ? 0 : int(param1.perks.length);
         while(this.m_perksHolder.numChildren > _loc2_)
         {
            this.m_perksHolder.removeChildAt(this.m_perksHolder.numChildren - 1);
         }
         while(this.m_perksHolder.numChildren < _loc2_)
         {
            this.m_perksHolder.addChild(new ModalItemPerkView());
         }
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         var _loc5_:* = true;
         var _loc6_:int = 0;
         while(_loc6_ < _loc2_)
         {
            (_loc9_ = ModalItemPerkView(this.m_perksHolder.getChildAt(_loc6_))).scaleX = 0.9;
            _loc9_.scaleY = 0.9;
            MenuUtils.setupIcon(_loc9_.icon,param1.perks[_loc6_].icon,MenuConstants.COLOR_WHITE,true,param1.perks[_loc6_].purposeColorTint != EvergreenUtils.LABELPURPOSE_NONE,EvergreenUtils.LABELBGCOLOR[param1.perks[_loc6_].purposeColorTint],1,0,false);
            MenuUtils.setupText(_loc9_.header,param1.perks[_loc6_].lstrTitle,21,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
            MenuUtils.setupText(_loc9_.description,param1.perks[_loc6_].lstrDescription,17,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
            _loc9_.description.autoSize = TextFieldAutoSize.LEFT;
            _loc9_.description.width = (PXCONTENTWIDTH / 2 - PXPADDING / 2) / _loc9_.scaleX - _loc9_.description.x;
            _loc9_.y = _loc3_;
            _loc4_ = Math.max(_loc4_,_loc9_.height);
            if(_loc5_)
            {
               _loc9_.x = 0;
            }
            else
            {
               _loc9_.x = PXCONTENTWIDTH / 2 + PXPADDING / 2;
               _loc3_ += _loc4_ + PXPADDING;
               _loc4_ = 0;
            }
            _loc5_ = !_loc5_;
            _loc6_++;
         }
         var _loc7_:int = param1 == null || param1.labels == null ? 0 : int(param1.labels.length);
         while(this.m_labelsHolder.numChildren > 0)
         {
            this.m_labelsHolder.removeChildAt(this.m_labelsHolder.numChildren - 1);
         }
         var _loc8_:Number = 0;
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            switch(param1.labels[_loc6_].purpose)
            {
               case EvergreenUtils.LABELPURPOSE_ACTION_KILL_TYPE:
               case EvergreenUtils.LABELPURPOSE_LOSE_ON_WOUNDED:
                  (_loc10_ = new ModalDialogItemDetailsKilltypeView()).label_txt.text = param1.labels[_loc6_].lstrTitle;
                  _loc10_.label_txt.autoSize = TextFieldAutoSize.LEFT;
                  _loc10_.back_mc.width = Math.ceil(_loc10_.label_txt.textWidth) + 18;
                  _loc10_.x = _loc8_;
                  _loc8_ += _loc10_.back_mc.width + PXGAPBETWEENLABELS;
                  this.m_labelsHolder.addChild(_loc10_);
                  break;
               case EvergreenUtils.LABELPURPOSE_POISON_LETHAL:
               case EvergreenUtils.LABELPURPOSE_POISON_EMETIC:
               case EvergreenUtils.LABELPURPOSE_POISON_SEDATIVE:
                  _loc11_ = new ModalDialogItemDetailsPoisonTypeView();
                  MenuUtils.setupText(_loc11_.label_txt,param1.labels[_loc6_].lstrTitle,18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
                  _loc11_.label_txt.autoSize = TextFieldAutoSize.LEFT;
                  _loc11_.back_mc.gotoAndStop(param1.labels[_loc6_].purpose == EvergreenUtils.LABELPURPOSE_POISON_LETHAL ? 1 : (param1.labels[_loc6_].purpose == EvergreenUtils.LABELPURPOSE_POISON_SEDATIVE ? 2 : 3));
                  _loc11_.back_mc.width = Math.ceil(_loc11_.label_txt.textWidth) + 18;
                  _loc11_.x = _loc8_;
                  _loc8_ += _loc11_.back_mc.width + PXGAPBETWEENLABELS;
                  this.m_labelsHolder.addChild(_loc11_);
                  break;
            }
            _loc6_++;
         }
         this.updateLayout();
      }
      
      private function updateLayout() : void
      {
         var dxIconOffset:Number;
         var yLayout:Number;
         var wasEmpty:Boolean;
         var yContent:Number = NaN;
         var yBackground:Number = NaN;
         var yContentMask:Number = NaN;
         Animate.kill(this.m_content);
         Animate.kill(this.m_background);
         Animate.kill(this.m_contentMask);
         dxIconOffset = this.m_icon.visible ? PXICONSIZE + PXGAPBETWEENICONANDTITLE : 0;
         this.m_title_txt.x = dxIconOffset;
         this.m_header_txt.x = dxIconOffset;
         yLayout = 0;
         if(this.m_header_txt.visible)
         {
            this.m_header_txt.y = yLayout - 2;
            this.m_title_txt.y = this.m_icon.y + PXICONSIZE / 2 - this.m_title_txt.textHeight + 2;
         }
         else
         {
            this.m_title_txt.y = yLayout + PXICONSIZE / 2 - this.m_title_txt.textHeight / 2;
         }
         yLayout += PXICONSIZE;
         if(!this.m_descr_txt.visible)
         {
            this.m_headlineSeparator.visible = false;
         }
         else
         {
            yLayout += PXPADDING;
            this.m_headlineSeparator.visible = true;
            this.m_headlineSeparator.y = yLayout;
            yLayout += PXPADDING;
            this.m_descr_txt.y = yLayout;
            yLayout += this.m_descr_txt.textHeight;
         }
         if(this.m_perksHolder.numChildren == 0)
         {
            this.m_perkSeparator.visible = false;
         }
         else
         {
            yLayout += PXPADDING;
            this.m_perkSeparator.visible = true;
            this.m_perkSeparator.y = yLayout;
            yLayout += PXPADDING;
            this.m_perksHolder.y = yLayout;
            yLayout += this.m_perksHolder.height;
         }
         if(this.m_labelsHolder.numChildren == 0)
         {
            this.m_labelSeparator.visible = false;
         }
         else
         {
            yLayout += PXPADDING;
            this.m_labelSeparator.visible = true;
            this.m_labelSeparator.y = yLayout;
            yLayout += PXPADDING;
            this.m_labelsHolder.y = yLayout;
            yLayout += this.m_labelsHolder.height;
         }
         wasEmpty = this.m_isEmpty;
         this.m_isEmpty = !this.m_icon.visible && !this.m_title_txt.visible && !this.m_header_txt.visible && !this.m_descr_txt.visible && this.m_perksHolder.numChildren == 0;
         if(this.m_isEmpty)
         {
            Animate.to(this.m_content,0.1,0,{"alpha":0},Animate.SineOut);
            Animate.to(this.m_background,0.1,0,{"height":1},Animate.SineOut,function():void
            {
               m_background.visible = false;
            });
            Animate.to(this.m_contentMask,0.1,0,{"height":1},Animate.SineOut);
         }
         else
         {
            this.m_background.visible = true;
            Animate.to(this.m_content,0.1,0.1,{"alpha":1},Animate.SineOut);
            Animate.to(this.m_background,0.1,0,{"height":yLayout + 2 * PXPADDING},Animate.SineOut);
            Animate.to(this.m_contentMask,0.1,0,{"height":yLayout + 1.5 * PXPADDING},Animate.SineOut);
         }
         if(!this.m_isEmpty)
         {
            yContent = this.m_yBottom - PXMARGINBOTTOM - yLayout - PXPADDING;
            yBackground = this.m_yBottom - PXMARGINBOTTOM - yLayout - 2 * PXPADDING;
            yContentMask = this.m_yBottom - PXMARGINBOTTOM - yLayout - 1.75 * PXPADDING;
            if(wasEmpty)
            {
               this.m_content.y = yContent;
               this.m_background.y = yBackground;
               this.m_contentMask.y = yContentMask;
            }
            else
            {
               Animate.addTo(this.m_content,0.1,0,{"y":yContent},Animate.SineOut);
               Animate.addTo(this.m_background,0.1,0,{"y":yBackground},Animate.SineOut);
               Animate.addTo(this.m_contentMask,0.1,0,{"y":yContentMask},Animate.SineOut);
            }
         }
      }
   }
}
