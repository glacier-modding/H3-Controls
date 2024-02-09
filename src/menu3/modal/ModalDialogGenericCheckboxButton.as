package menu3.modal
{
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   
   public dynamic class ModalDialogGenericCheckboxButton extends ModalDialogGenericButton implements ISubmitValidator
   {
       
      
      private var m_updateSubmitEnabled:Function;
      
      private var m_isChecked:Boolean = false;
      
      public function ModalDialogGenericCheckboxButton(param1:Object)
      {
         super(param1);
      }
      
      public function setModalCallbacks(param1:Function) : void
      {
         this.m_updateSubmitEnabled = param1;
      }
      
      override public function onCreationDone() : void
      {
         super.onCreationDone();
         this.updateState();
      }
      
      override public function onPressed() : void
      {
         super.onPressed();
         this.m_isChecked = !this.m_isChecked;
         this.updateState();
      }
      
      override public function onUnregister() : void
      {
         super.onUnregister();
      }
      
      override public function setSelectedAnimationState(param1:int) : void
      {
         super.setSelectedAnimationState(param1);
         if(m_isSelected && !this.m_isChecked)
         {
            MenuUtils.setupIcon(m_view.tileIcon,m_iconLabel,MenuConstants.COLOR_WHITE,true,false);
         }
         m_view.tileIcon.icons.visible = this.m_isChecked;
      }
      
      public function isSubmitValid() : Boolean
      {
         return this.m_isChecked;
      }
      
      private function updateState() : void
      {
         var _loc1_:int = STATE_DEFAULT;
         if(m_isSelected)
         {
            _loc1_ = STATE_SELECTED;
         }
         this.setSelectedAnimationState(_loc1_);
         if(this.m_updateSubmitEnabled != null)
         {
            this.m_updateSubmitEnabled();
         }
      }
   }
}
