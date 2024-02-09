package menu3.search
{
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   
   public dynamic class SearchSelectedTagElement extends SearchElementBase
   {
       
      
      private var m_isReadOnly:Boolean = false;
      
      public function SearchSelectedTagElement(param1:Object)
      {
         super(param1);
      }
      
      override protected function createPrivateView() : *
      {
         return new ContractSearchSelectedTagElementView();
      }
      
      override public function onSetData(param1:Object) : void
      {
         this.m_isReadOnly = !!param1.readonly ? Boolean(param1.readonly) : false;
         if(this.m_isReadOnly)
         {
            getPrivateView().iconMc.visible = false;
         }
         else
         {
            MenuUtils.setupIcon(m_view.iconMc,"failed",MenuConstants.COLOR_WHITE,false,false);
         }
         super.onSetData(param1);
      }
      
      override public function onUnregister() : void
      {
         super.onUnregister();
      }
      
      override public function setItemSelected(param1:Boolean) : void
      {
         if(this.m_isReadOnly)
         {
            return;
         }
         super.setItemSelected(param1);
      }
      
      override protected function setState(param1:int) : void
      {
         m_view.tileSelectPulsate.visible = false;
         m_view.tileHoverMc.visible = false;
         if(param1 == STATE_SELECT || param1 == STATE_ACTIVE_SELECT)
         {
            m_view.tileSelectMc.visible = true;
            changeTextColor(MenuConstants.COLOR_WHITE);
            MenuUtils.setColor(m_view.iconMc,MenuConstants.COLOR_WHITE,false);
            MenuUtils.setColor(m_view.tileSelectMc,MenuConstants.COLOR_RED,false);
         }
         else
         {
            m_view.tileSelectMc.visible = true;
            changeTextColor(MenuConstants.COLOR_WHITE);
            MenuUtils.setColor(m_view.iconMc,MenuConstants.COLOR_WHITE,false);
            MenuUtils.setColor(m_view.tileSelectMc,MenuConstants.COLOR_MENU_CONTRACT_SEARCH_GREY,false);
         }
      }
      
      override protected function setupTitleTextField(param1:String) : void
      {
         setupTextField(TitleTextField,param1,MenuConstants.FontColorWhite);
      }
   }
}
