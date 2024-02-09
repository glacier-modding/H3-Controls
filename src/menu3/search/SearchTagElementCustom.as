package menu3.search
{
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   
   public dynamic class SearchTagElementCustom extends SearchTagElement
   {
       
      
      public function SearchTagElementCustom(param1:Object)
      {
         super(param1);
      }
      
      override protected function createPrivateView() : *
      {
         return new ContractSearchCustomTagView();
      }
      
      protected function get InputTextField() : TextField
      {
         return m_view.input_txt;
      }
      
      protected function get InputTextFiledBackground() : Sprite
      {
         return m_view.inputTxtBgMc;
      }
      
      override public function onSetData(param1:Object) : void
      {
         if(param1.width != null)
         {
            this.updateWidth(param1.width);
         }
         super.onSetData(param1);
         this.setupInputTextField(param1);
         updateState();
      }
      
      protected function setupInputTextField(param1:Object) : void
      {
         this.InputTextField.selectable = false;
         this.InputTextField.type = TextFieldType.DYNAMIC;
         this.InputTextField.multiline = false;
         this.InputTextField.maxChars = 40;
         this.InputTextField.autoSize = TextFieldAutoSize.NONE;
         this.InputTextField.text = "";
         if(param1.defaulttext)
         {
            this.InputTextField.text = param1.defaulttext;
         }
      }
      
      override protected function setupTitleTextField(param1:String) : void
      {
      }
      
      override protected function setState(param1:int) : void
      {
         super.setState(param1);
         this.InputTextFiledBackground.alpha = 1;
         if(param1 == STATE_NONE)
         {
            MenuUtils.setColor(this.InputTextFiledBackground,MenuConstants.COLOR_MENU_CONTRACT_SEARCH_GREY,false);
            this.InputTextField.textColor = MenuConstants.COLOR_WHITE;
         }
         else if(param1 == STATE_DISABLED)
         {
            MenuUtils.setColor(this.InputTextFiledBackground,MenuConstants.COLOR_MENU_CONTRACT_SEARCH_GREY,false);
            this.InputTextFiledBackground.alpha = 0.5;
         }
         else if(param1 == STATE_ACTIVE)
         {
            MenuUtils.setColor(this.InputTextFiledBackground,MenuConstants.COLOR_WHITE,false);
            this.InputTextField.textColor = MenuConstants.COLOR_GREY_DARK;
         }
         else
         {
            MenuUtils.setColor(this.InputTextFiledBackground,MenuConstants.COLOR_WHITE,false);
            this.InputTextField.textColor = MenuConstants.COLOR_GREY_DARK;
         }
      }
      
      private function updateWidth(param1:Number) : void
      {
         var _loc2_:Number = 4;
         var _loc3_:Number = 100;
         var _loc4_:Number = 44;
         var _loc5_:Number = 40;
         var _loc6_:* = getPrivateView();
         var _loc7_:Number = param1 / 2;
         var _loc8_:Number = param1 - _loc2_;
         _loc6_.tileBgMc.x = _loc7_;
         _loc6_.tileSelectMc.x = _loc7_;
         _loc6_.tileHoverMc.x = _loc7_;
         _loc6_.tileSelectPulsate.x = _loc7_;
         _loc6_.inputTxtBgMc.x = _loc7_;
         _loc6_.tileBgMc.width = _loc8_;
         _loc6_.tileSelectMc.width = _loc8_;
         _loc6_.tileHoverMc.width = param1 - _loc5_;
         _loc6_.tileSelectPulsate.width = param1 - _loc5_;
         _loc6_.inputTxtBgMc.width = param1 - _loc4_;
         this.InputTextField.width = param1 - _loc3_;
      }
   }
}
