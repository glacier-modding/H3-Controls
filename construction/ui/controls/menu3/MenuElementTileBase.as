package menu3
{
   import common.Animate;
   import common.MouseUtil;
   
   public dynamic class MenuElementTileBase extends MenuElementBase
   {
       
      
      protected var m_isSelected:Boolean = false;
      
      protected var m_loading:Boolean = false;
      
      private var m_wheelDelayActive:Boolean = false;
      
      public function MenuElementTileBase(param1:Object)
      {
         super(param1);
         m_mouseMode = MouseUtil.MODE_ONOVER_SELECT_ONUP_CLICK;
      }
      
      public function onItemLoadingStateChanged(param1:Boolean) : void
      {
         var _loc2_:Boolean = false;
         if(param1)
         {
            _loc2_ = this.m_isSelected;
            this.setItemSelected(false);
            this.m_loading = true;
            this.m_isSelected = _loc2_;
         }
         else
         {
            this.m_loading = false;
            this.setItemSelected(this.m_isSelected);
         }
      }
      
      public function setItemSelected(param1:Boolean) : void
      {
         if(this.m_isSelected == param1)
         {
            return;
         }
         this.m_isSelected = param1;
         this.handleSelectionChange();
      }
      
      public function isSelected() : Boolean
      {
         return this.m_isSelected;
      }
      
      public function isWheelDelayActive() : Boolean
      {
         return this.m_wheelDelayActive;
      }
      
      public function setWheelDelayActive(param1:Boolean) : void
      {
         this.m_wheelDelayActive = param1;
      }
      
      protected function handleSelectionChange() : void
      {
      }
      
      override public function onUnregister() : void
      {
         if(this.m_wheelDelayActive)
         {
            Animate.kill(this);
         }
         super.onUnregister();
      }
   }
}
