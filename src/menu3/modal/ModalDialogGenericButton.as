package menu3.modal
{
   import common.CommonUtils;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   import menu3.basic.TextTickerUtil;
   import menu3.containers.CollapsableListContainer;
   
   public dynamic class ModalDialogGenericButton extends CollapsableListContainer
   {
       
      
      protected var m_view:ModalDialogGenericButtonView;
      
      private var m_textTickerUtil:TextTickerUtil;
      
      private var m_isPressable:Boolean = true;
      
      protected var m_iconLabel:String;
      
      private var m_optionStyle:Boolean = false;
      
      protected const STATE_DEFAULT:int = 0;
      
      protected const STATE_SELECTED:int = 1;
      
      protected const STATE_GROUP_SELECTED:int = 2;
      
      protected const STATE_HOVER:int = 3;
      
      public function ModalDialogGenericButton(param1:Object)
      {
         this.m_textTickerUtil = new TextTickerUtil();
         super(param1);
         this.m_view = new ModalDialogGenericButtonView();
         this.m_view.tileDarkBg.alpha = 0;
         this.m_view.tileBg.alpha = 0;
         addChild(this.m_view);
      }
      
      override public function onSetData(param1:Object) : void
      {
         super.onSetData(param1);
         if(param1.dialogWidth != undefined)
         {
            this.setButtonWidth(param1.dialogWidth);
         }
         if(param1.optionstyle === true)
         {
            this.m_optionStyle = true;
         }
         this.m_iconLabel = "arrowright";
         if(param1.icon)
         {
            this.m_iconLabel = param1.icon;
         }
         else if(param1.type)
         {
            if(param1.type == "ok")
            {
               this.m_iconLabel = "arrowright";
            }
            else if(param1.type == "cancel")
            {
               this.m_iconLabel = "failed";
            }
         }
         MenuUtils.setupIcon(this.m_view.tileIcon,this.m_iconLabel,MenuConstants.COLOR_WHITE,true,false);
         MenuUtils.setColor(this.m_view.tileSelect,MenuConstants.COLOR_MENU_SOLID_BACKGROUND,true,1);
         if(param1.title != undefined)
         {
            if(param1.title.length > 0)
            {
               this.setupTextField(param1.title);
            }
            else
            {
               this.setupTextField(param1.titleplaceholder);
            }
         }
         if(getNodeProp(this,"pressable") === false)
         {
            this.setPressable(false);
         }
         var _loc2_:int = m_isSelected ? this.STATE_SELECTED : this.STATE_DEFAULT;
         this.setSelectedAnimationState(_loc2_);
         setItemSelected(m_isSelected);
      }
      
      public function onCreationDone() : void
      {
      }
      
      private function setButtonWidth(param1:Number) : void
      {
         var _loc2_:Number = param1 - this.m_view.tileDarkBg.width;
         var _loc3_:Number = _loc2_ / 2;
         this.m_view.tileSelect.width += _loc2_;
         this.m_view.tileSelect.x += _loc3_;
         this.m_view.tileDarkBg.width += _loc2_;
         this.m_view.tileDarkBg.x += _loc3_;
         this.m_view.tileBg.width += _loc2_;
         this.m_view.tileBg.x += _loc3_;
         this.m_view.title.width += _loc2_;
      }
      
      public function isPressable() : Boolean
      {
         return this.m_isPressable;
      }
      
      public function setPressable(param1:Boolean) : void
      {
         this.m_isPressable = param1;
         if(this.m_isPressable)
         {
            this.m_view.tileIcon.alpha = 1;
            this.m_view.title.alpha = 1;
         }
         else
         {
            this.m_view.tileIcon.alpha = 0.5;
            this.m_view.title.alpha = 0.5;
         }
      }
      
      public function onPressed() : void
      {
      }
      
      override public function getView() : Sprite
      {
         return this.m_view.tileBg;
      }
      
      private function setupTextField(param1:String) : void
      {
         MenuUtils.setupTextUpper(this.m_view.title,param1,26,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         this.m_textTickerUtil.addTextTicker(this.m_view.title,this.m_view.title.htmlText);
         MenuUtils.truncateTextfield(this.m_view.title,1,null,CommonUtils.changeFontToGlobalIfNeeded(this.m_view.title));
      }
      
      private function changeTextColor(param1:int) : void
      {
         this.m_view.title.textColor = param1;
      }
      
      private function callTextTicker(param1:Boolean) : void
      {
         this.m_textTickerUtil.callTextTicker(param1,this.m_view.title.textColor);
      }
      
      public function setItemHover(param1:Boolean) : void
      {
         if(m_isSelected)
         {
            return;
         }
         var _loc2_:int = param1 ? this.STATE_HOVER : this.STATE_DEFAULT;
         this.setSelectedAnimationState(_loc2_);
      }
      
      override protected function handleSelectionChange() : void
      {
         var _loc1_:int = this.STATE_DEFAULT;
         if(m_isSelected)
         {
            _loc1_ = this.STATE_SELECTED;
         }
         this.setSelectedAnimationState(_loc1_);
      }
      
      public function setSelectedAnimationState(param1:int) : void
      {
         if(!this.m_isPressable)
         {
            return;
         }
         if(param1 == this.STATE_SELECTED || param1 == this.STATE_HOVER)
         {
            MenuUtils.setColor(this.m_view.tileSelect,MenuConstants.COLOR_RED,true,1);
            MenuUtils.setupIcon(this.m_view.tileIcon,this.m_iconLabel,MenuConstants.COLOR_RED,false,true,MenuConstants.COLOR_WHITE,1,0,true);
            MenuUtils.removeDropShadowFilter(this.m_view.title);
            MenuUtils.removeDropShadowFilter(this.m_view.tileIcon);
            this.callTextTicker(true);
         }
         else
         {
            if(this.m_optionStyle)
            {
               MenuUtils.setupIcon(this.m_view.tileIcon,this.m_iconLabel,MenuConstants.COLOR_WHITE,true,false);
               MenuUtils.addDropShadowFilter(this.m_view.title);
               MenuUtils.addDropShadowFilter(this.m_view.tileIcon);
               this.m_view.tileSelect.alpha = 0;
            }
            else
            {
               MenuUtils.setColor(this.m_view.tileSelect,MenuConstants.COLOR_MENU_SOLID_BACKGROUND,true,1);
               MenuUtils.setupIcon(this.m_view.tileIcon,this.m_iconLabel,MenuConstants.COLOR_WHITE,true,false);
               MenuUtils.removeDropShadowFilter(this.m_view.title);
               MenuUtils.removeDropShadowFilter(this.m_view.tileIcon);
            }
            this.callTextTicker(false);
         }
      }
      
      override public function onUnregister() : void
      {
         super.onUnregister();
         if(this.m_view)
         {
            this.m_textTickerUtil.onUnregister();
            this.m_textTickerUtil = null;
            removeChild(this.m_view);
            this.m_view = null;
         }
      }
   }
}
