package menu3.search
{
   import common.Log;
   import flash.text.TextField;
   
   public dynamic class SearchTagElementBig extends SearchElementBase
   {
       
      
      private var m_isElementActive:Boolean = false;
      
      private var m_isElementDisabled:Boolean = false;
      
      public function SearchTagElementBig(param1:Object)
      {
         super(param1);
      }
      
      public static function setTabPositionBetweenTextFields(param1:TextField, param2:TextField, param3:Number) : void
      {
         var _loc4_:Number = param2.x - (param1.width + param1.x);
         var _loc5_:Number = param3 - _loc4_ - param1.x;
         var _loc6_:Number = param3;
         var _loc7_:Number = param2.x - _loc6_ + param2.width;
         param1.width = _loc5_;
         param2.x = _loc6_;
         param2.width = _loc7_;
      }
      
      override protected function createPrivateView() : *
      {
         return new ContractSearchTagElementBigView();
      }
      
      protected function get Tab01TextField() : TextField
      {
         return getPrivateView().tab01_txt;
      }
      
      protected function get Tab02TextField() : TextField
      {
         return getPrivateView().tab02_txt;
      }
      
      override public function onSetData(param1:Object) : void
      {
         if(param1.titletab01 != null || param1.titletab02 != null)
         {
            param1.title = null;
         }
         super.onSetData(param1);
         if(param1.titletab01 != null)
         {
            setupTextField(this.Tab01TextField,param1.titletab01);
         }
         if(param1.titletab02 != null)
         {
            setupTextField(this.Tab02TextField,param1.titletab02);
         }
         if(param1.tabposition != null)
         {
            setTabPositionBetweenTextFields(this.Tab01TextField,this.Tab02TextField,param1.tabposition);
         }
         this.m_isElementActive = false;
         if(param1.hasOwnProperty("active"))
         {
            this.m_isElementActive = param1.active;
         }
         else if(getNodeProp(this,"pressable") == false)
         {
            this.m_isElementActive = true;
         }
         this.m_isElementDisabled = false;
         if(param1.hasOwnProperty("disabled"))
         {
            this.m_isElementDisabled = param1.disabled;
         }
         this.updateState();
      }
      
      public function onAcceptPressed() : void
      {
         Log.info(Log.ChannelDebug,this,"onAcceptPressed");
         this.m_isElementActive = true;
         this.updateState();
      }
      
      public function onCancelPressed() : void
      {
         Log.info(Log.ChannelDebug,this,"onCancelPressed");
         this.m_isElementActive = false;
         this.updateState();
      }
      
      override protected function updateState() : void
      {
         if(this.m_isElementDisabled)
         {
            setState(STATE_DISABLED);
         }
         else if(this.m_isElementActive)
         {
            setState(m_isSelected ? STATE_ACTIVE_SELECT : STATE_ACTIVE);
         }
         else
         {
            setState(m_isSelected ? STATE_SELECT : STATE_NONE);
         }
      }
   }
}
