package menu3.search
{
   import common.Animate;
   import common.CommonUtils;
   import common.Log;
   import common.MouseUtil;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import common.menu.textTicker;
   import flash.text.TextField;
   import menu3.MenuElementBase;
   
   public dynamic class SearchElementBase extends MenuElementBase
   {
       
      
      protected var m_view:* = null;
      
      private var m_textTickerObjs:Array;
      
      protected var m_isSelected:Boolean = false;
      
      protected const STATE_NONE:int = 0;
      
      protected const STATE_SELECT:int = 1;
      
      protected const STATE_ACTIVE:int = 2;
      
      protected const STATE_ACTIVE_SELECT:int = 3;
      
      protected const STATE_DISABLED:int = 4;
      
      public function SearchElementBase(param1:Object)
      {
         this.m_textTickerObjs = new Array();
         super(param1);
         this.m_view = this.createPrivateView();
         if(this.m_view != null)
         {
            addChild(this.m_view);
         }
         else
         {
            Log.error(Log.ChannelDebug,this,"createPrivateView returned null!");
         }
         m_mouseMode = MouseUtil.MODE_ONOVER_SELECT_ONUP_CLICK;
      }
      
      override public function onSetData(param1:Object) : void
      {
         super.onSetData(param1);
         this.setupTitleTextField(!!param1.title ? String(param1.title) : "");
         this.setState(this.STATE_NONE);
      }
      
      public function setItemSelected(param1:Boolean) : void
      {
         if(this.m_isSelected == param1)
         {
            return;
         }
         this.m_isSelected = param1;
         Animate.kill(this.m_view.tileHoverMc);
         if(this.m_isSelected)
         {
            this.callTextTicker(true);
         }
         else
         {
            this.callTextTicker(false);
         }
         this.updateState();
      }
      
      protected function updateState() : void
      {
         if(this.m_isSelected)
         {
            this.setState(this.STATE_SELECT);
         }
         else
         {
            this.setState(this.STATE_NONE);
         }
      }
      
      protected function createPrivateView() : *
      {
         return null;
      }
      
      protected function getPrivateView() : *
      {
         return this.m_view;
      }
      
      protected function get TitleTextField() : TextField
      {
         return this.m_view.label_txt;
      }
      
      protected function setState(param1:int) : void
      {
         this.changeTextColor(MenuConstants.COLOR_WHITE);
         this.m_view.tileSelectPulsate.alpha = false;
         this.m_view.tileBgMc.visible = false;
         this.m_view.tileHoverMc.visible = false;
         m_mouseMode = MouseUtil.MODE_ONOVER_SELECT_ONUP_CLICK;
         this.changeTextColor(MenuConstants.COLOR_WHITE);
         if(param1 == this.STATE_NONE)
         {
            this.m_view.tileSelectMc.visible = false;
         }
         else if(param1 == this.STATE_SELECT || param1 == this.STATE_ACTIVE_SELECT)
         {
            this.m_view.tileSelectMc.alpha = 1;
            this.m_view.tileSelectMc.visible = true;
            MenuUtils.setColor(this.m_view.tileSelectMc,MenuConstants.COLOR_RED,false);
         }
         else if(param1 == this.STATE_ACTIVE)
         {
            this.m_view.tileSelectMc.alpha = 1;
            this.m_view.tileSelectMc.visible = true;
            this.changeTextColor(MenuConstants.COLOR_WHITE);
            MenuUtils.setColor(this.m_view.tileSelectMc,MenuConstants.COLOR_MENU_CONTRACT_SEARCH_GREY,false);
         }
         else if(param1 == this.STATE_DISABLED)
         {
            m_mouseMode = MouseUtil.MODE_ONOVER_HOVER_ONUP_SELECT;
            this.m_view.tileSelectMc.visible = false;
            this.changeTextColor(MenuConstants.COLOR_GREY_MEDIUM);
         }
      }
      
      protected function setupTitleTextField(param1:String) : void
      {
         this.setupTextField(this.TitleTextField,param1);
      }
      
      protected function setupTextField(param1:TextField, param2:String, param3:String = "#464646") : void
      {
         MenuUtils.setupText(param1,param2,18,MenuConstants.FONT_TYPE_MEDIUM,param3);
         CommonUtils.changeFontToGlobalIfNeeded(param1);
         var _loc4_:Object;
         (_loc4_ = new Object()).title = param1.htmlText;
         _loc4_.textField = param1;
         _loc4_.ticker = new textTicker();
         MenuUtils.truncateTextfield(param1,1);
         this.m_textTickerObjs.push(_loc4_);
      }
      
      protected function changeTextColor(param1:int) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.m_textTickerObjs.length)
         {
            this.m_textTickerObjs[_loc2_].textField.textColor = param1;
            this.m_textTickerObjs[_loc2_].ticker.setTextColor(param1);
            _loc2_++;
         }
      }
      
      override public function onUnregister() : void
      {
         var _loc2_:Object = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.m_textTickerObjs.length)
         {
            _loc2_ = this.m_textTickerObjs[_loc1_];
            _loc2_.ticker.stopTextTicker(_loc2_.textField,_loc2_.title);
            _loc2_.ticker = null;
            _loc2_.textField = null;
            _loc1_++;
         }
         this.m_textTickerObjs.length = 0;
         if(this.m_view)
         {
            removeChild(this.m_view);
            this.m_view = null;
         }
         super.onUnregister();
      }
      
      private function callTextTicker(param1:Boolean) : void
      {
         var _loc3_:Object = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.m_textTickerObjs.length)
         {
            _loc3_ = this.m_textTickerObjs[_loc2_];
            if(param1)
            {
               _loc3_.ticker.startTextTickerHtml(_loc3_.textField,_loc3_.title);
            }
            else
            {
               _loc3_.ticker.stopTextTicker(_loc3_.textField,_loc3_.title);
               _loc3_.textField.htmlText = _loc3_.title;
               MenuUtils.truncateTextfield(_loc3_.textField,1);
            }
            _loc2_++;
         }
      }
   }
}
