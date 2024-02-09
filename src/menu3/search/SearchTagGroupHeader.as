package menu3.search
{
   import common.CommonUtils;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   
   public dynamic class SearchTagGroupHeader extends SearchElementBase
   {
       
      
      public function SearchTagGroupHeader(param1:Object)
      {
         super(param1);
      }
      
      override protected function createPrivateView() : *
      {
         return new ContractSearchTagGroupHeaderView();
      }
      
      protected function get Icon() : iconsAll40x40View
      {
         return getPrivateView().icon;
      }
      
      override public function onSetData(param1:Object) : void
      {
         if(param1.width != null)
         {
            this.updateWidth(param1.width);
         }
         super.onSetData(param1);
         if(param1.icon)
         {
            MenuUtils.setupIcon(this.Icon,param1.icon,MenuConstants.COLOR_WHITE,true,false);
         }
      }
      
      override public function onUnregister() : void
      {
         super.onUnregister();
      }
      
      override protected function setupTitleTextField(param1:String) : void
      {
         MenuUtils.setupText(TitleTextField,param1,24,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         CommonUtils.changeFontToGlobalIfNeeded(TitleTextField);
         MenuUtils.shrinkTextToFit(TitleTextField,TitleTextField.width,0);
      }
      
      override public function setItemSelected(param1:Boolean) : void
      {
      }
      
      override protected function setState(param1:int) : void
      {
      }
      
      private function updateWidth(param1:Number) : void
      {
         var _loc2_:Number = 8;
         var _loc3_:Number = 4;
         var _loc4_:*;
         (_loc4_ = getPrivateView()).bg.x = param1 / 2;
         _loc4_.bg.width = param1 - _loc2_;
         TitleTextField.width = param1 - TitleTextField.x - _loc3_;
      }
   }
}
