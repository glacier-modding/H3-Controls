package menu3.basic
{
   import common.Log;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import menu3.MenuElementBase;
   
   public dynamic class AccountElement extends MenuElementBase
   {
       
      
      private var m_view:AccountElementView;
      
      public function AccountElement(param1:Object)
      {
         super(param1);
         this.m_view = new AccountElementView();
         addChild(this.m_view);
      }
      
      protected function getRootView() : AccountElementView
      {
         return this.m_view;
      }
      
      override public function onSetData(param1:Object) : void
      {
         super.onSetData(param1);
         Log.debugData(this,param1);
         if(param1.header == undefined || param1.content == undefined)
         {
            this.m_view.visible = false;
            return;
         }
         this.showData(param1.header,param1.content);
      }
      
      private function showData(param1:String, param2:Object) : void
      {
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc3_:String = null;
         var _loc4_:Array;
         if((_loc4_ = param2 as Array) != null)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               if((_loc6_ = this.prepareValue(_loc4_[_loc5_])) != null)
               {
                  if(_loc3_ == null)
                  {
                     _loc3_ = _loc6_;
                  }
                  else
                  {
                     _loc3_ = _loc6_;
                  }
               }
               _loc5_++;
            }
         }
         else
         {
            _loc3_ = this.prepareValue(param2);
         }
         if(_loc3_ != null)
         {
            this.m_view.visible = true;
            MenuUtils.setupTextUpper(this.m_view.value,"  -  " + _loc3_,12,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorGreen);
         }
         else
         {
            this.m_view.visible = false;
         }
      }
      
      private function prepareValue(param1:Object) : String
      {
         var _loc2_:* = null;
         var _loc3_:String = null;
         if(param1.value != undefined)
         {
            _loc2_ = "";
            _loc3_ = "";
            if(param1.valuePrefix != null && param1.valuePrefix.length > 0)
            {
               _loc2_ = param1.valuePrefix + " ";
            }
            if(param1.valuePostfix != null && param1.valuePostfix.length > 0)
            {
               _loc3_ = " " + param1.valuePostfix;
            }
            return _loc2_ + MenuUtils.formatNumber(param1.value) + _loc3_;
         }
         if(param1.text != undefined)
         {
            return param1.text;
         }
         return null;
      }
      
      public function setTextPosition(param1:int) : void
      {
         this.m_view.value.x = 75 + param1;
      }
      
      public function setupDifficulty(param1:Boolean) : void
      {
      }
      
      override public function onUnregister() : void
      {
         if(this.m_view)
         {
            removeChild(this.m_view);
            this.m_view = null;
         }
         super.onUnregister();
      }
   }
}
