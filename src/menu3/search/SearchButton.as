package menu3.search
{
   import common.Animate;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import common.menu.textTicker;
   import flash.display.Sprite;
   import menu3.MenuElementTileBase;
   
   public dynamic class SearchButton extends MenuElementTileBase
   {
       
      
      protected const STATE_DEFAULT:int = 0;
      
      protected const STATE_SELECTED:int = 1;
      
      protected const STATE_NOT_SELECTABLE:int = 2;
      
      protected const STATE_DISABLED:int = 3;
      
      protected var m_view:Object;
      
      protected var m_iconName:String;
      
      protected var m_textTicker:textTicker;
      
      protected var m_textObj:Object;
      
      protected var m_title:String;
      
      protected var m_currentState:int = 0;
      
      private var m_previousState:int = 0;
      
      private var m_animationBox:Sprite;
      
      public function SearchButton(param1:Object)
      {
         this.m_textObj = new Object();
         this.m_animationBox = new Sprite();
         super(param1);
         this.m_iconName = param1.icon;
         this.m_view = new ButtonTileSmallView();
         this.m_view.tileSelect.alpha = 0;
         this.m_view.tileBg.alpha = 0;
         addChild(this.m_view as ButtonTileSmallView);
         var _loc2_:Number = Number(this.m_view.tileDarkBg.width);
         var _loc3_:Number = Number(this.m_view.tileDarkBg.height);
         var _loc4_:Number = this.m_view.tileDarkBg.width / 2;
         var _loc5_:Number = this.m_view.tileDarkBg.height / 2;
         this.m_view.addChildAt(this.m_animationBox,0);
         this.m_animationBox.graphics.clear();
         this.m_animationBox.graphics.beginFill(MenuConstants.COLOR_WHITE,1);
         this.m_animationBox.graphics.drawRect(-_loc4_,-_loc5_,this.m_view.tileDarkBg.width,this.m_view.tileDarkBg.height);
         this.m_animationBox.graphics.endFill();
         this.m_animationBox.x = _loc4_;
         this.m_animationBox.y = _loc5_;
         this.m_animationBox.alpha = 0;
      }
      
      override public function onUnregister() : void
      {
         if(this.m_view)
         {
            this.completeAnimations();
            if(this.m_textTicker)
            {
               this.m_textTicker.stopTextTicker(this.m_view.title,this.m_textObj.title);
               this.m_textTicker = null;
            }
            removeChild(this.m_view as ButtonTileSmallView);
            this.m_view = null;
         }
         super.onUnregister();
      }
      
      override public function onSetData(param1:Object) : void
      {
         super.onSetData(param1);
         this.m_view.dropShadow.alpha = 0;
         this.m_view.tileSelect.alpha = 0;
         this.m_view.tileDarkBg.alpha = 0;
         this.m_title = param1.title;
         this.m_currentState = m_isSelected ? this.STATE_SELECTED : this.STATE_DEFAULT;
         if(param1.hasOwnProperty("disabled") && param1.disabled == true)
         {
            this.m_currentState = this.STATE_DISABLED;
         }
         else if(getNodeProp(this,"selectable") == false)
         {
            this.m_currentState = this.STATE_NOT_SELECTABLE;
         }
         if(getNodeProp(this,"pressable") == false)
         {
            MenuUtils.setColor(this.m_view.tileSelect,MenuConstants.COLOR_GREY_LIGHT,false);
         }
         else
         {
            MenuUtils.removeColor(this.m_view.tileSelect);
         }
         this.setupTextFields(param1.header,param1.title);
         this.updateState();
      }
      
      override public function getView() : Sprite
      {
         return this.m_view.tileBg;
      }
      
      override public function setItemSelected(param1:Boolean) : void
      {
         if(m_isSelected == param1)
         {
            return;
         }
         m_isSelected = param1;
         this.handleSelectionChange();
      }
      
      protected function updateState() : void
      {
         this.setSelectedAnimationState(this.m_view,this.m_currentState);
      }
      
      protected function changeTextColor(param1:int) : void
      {
         this.m_view.header.textColor = param1;
         this.m_view.title.textColor = param1;
         this.m_view.information.textColor = param1;
         if(this.m_textTicker)
         {
            this.m_textTicker.setTextColor(param1);
         }
      }
      
      override protected function handleSelectionChange() : void
      {
         if(this.m_currentState == this.STATE_DISABLED)
         {
            return;
         }
         this.m_currentState = m_isSelected ? this.STATE_SELECTED : this.STATE_DEFAULT;
         this.updateState();
      }
      
      protected function completeAnimations() : void
      {
         Animate.complete(this.m_view);
      }
      
      protected function setSelectedAnimationState(param1:Object, param2:int) : void
      {
         var fromScaleX:Number = NaN;
         var fromScaleY:Number = NaN;
         var m_view:Object = param1;
         var state:int = param2;
         if(state == this.STATE_DISABLED || state == this.STATE_NOT_SELECTABLE)
         {
            Animate.complete(this.m_animationBox);
         }
         this.completeAnimations();
         if(m_loading)
         {
            return;
         }
         this.callTextTicker(m_isSelected);
         if(state == this.STATE_NOT_SELECTABLE || state == this.STATE_DISABLED)
         {
            setPopOutScale(m_view,false);
            Animate.kill(m_view.dropShadow);
            m_view.dropShadow.alpha = 0;
            m_view.tileSelect.alpha = 0;
            MenuUtils.setupIcon(m_view.tileIcon,this.m_iconName,MenuConstants.COLOR_GREY_MEDIUM,false,true,MenuConstants.COLOR_GREY_LIGHT);
            this.changeTextColor(state == this.STATE_DISABLED ? MenuConstants.COLOR_GREY_DARK : MenuConstants.COLOR_GREY_ULTRA_LIGHT);
         }
         else if(state == this.STATE_SELECTED)
         {
            setPopOutScale(m_view,true);
            Animate.to(m_view.dropShadow,0.3,0,{"alpha":1},Animate.ExpoOut);
            m_view.tileSelect.alpha = 1;
            this.changeTextColor(MenuConstants.COLOR_WHITE);
            MenuUtils.setColor(m_view.tileSelect,MenuConstants.COLOR_RED);
            MenuUtils.setupIcon(m_view.tileIcon,this.m_iconName,MenuConstants.COLOR_RED,false,true,MenuConstants.COLOR_WHITE);
         }
         else
         {
            setPopOutScale(m_view,false);
            Animate.kill(m_view.dropShadow);
            m_view.dropShadow.alpha = 0;
            m_view.tileSelect.alpha = 1;
            this.changeTextColor(MenuConstants.COLOR_GREY_ULTRA_DARK);
            MenuUtils.removeColor(m_view.tileSelect);
            MenuUtils.setupIcon(m_view.tileIcon,this.m_iconName,MenuConstants.COLOR_GREY_ULTRA_DARK,true,false);
         }
         if(state == this.STATE_DEFAULT && this.m_previousState != this.STATE_SELECTED && this.m_previousState != this.STATE_DEFAULT)
         {
            fromScaleX = this.m_animationBox.scaleX * 4;
            fromScaleY = this.m_animationBox.scaleY * 4;
            Animate.from(this.m_animationBox,0.25,0,{
               "scaleX":fromScaleX,
               "scaleY":fromScaleY
            },Animate.ExpoOut);
            Animate.addFromTo(this.m_animationBox,0.25,0,{"alpha":0},{"alpha":1},Animate.Linear,function():void
            {
               m_animationBox.alpha = 0;
            });
         }
         this.m_previousState = state;
      }
      
      protected function callTextTicker(param1:Boolean) : void
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
            MenuUtils.truncateTextfield(this.m_view.title,1,null);
         }
      }
      
      protected function setupTextFields(param1:String, param2:String) : void
      {
         MenuUtils.setupTextUpper(this.m_view.header,param1,14,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorGreyUltraLight);
         MenuUtils.setupTextUpper(this.m_view.title,param2,24,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorGreyUltraLight);
         this.m_textObj.header = this.m_view.header.htmlText;
         this.m_textObj.title = this.m_view.title.htmlText;
         MenuUtils.truncateTextfield(this.m_view.header,1,null);
         MenuUtils.truncateTextfield(this.m_view.title,1,null);
      }
      
      protected function showText(param1:Boolean) : void
      {
         this.m_view.header.visible = param1;
         this.m_view.title.visible = param1;
      }
   }
}
