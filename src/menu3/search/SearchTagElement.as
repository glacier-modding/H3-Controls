package menu3.search
{
   import common.Log;
   
   public dynamic class SearchTagElement extends SearchElementBase
   {
       
      
      protected var m_isElementActive:Boolean = false;
      
      private var m_isElementDisabled:Boolean = false;
      
      public function SearchTagElement(param1:Object)
      {
         super(param1);
      }
      
      override protected function createPrivateView() : *
      {
         return new ContractSearchTagElementView();
      }
      
      override public function onSetData(param1:Object) : void
      {
         super.onSetData(param1);
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
