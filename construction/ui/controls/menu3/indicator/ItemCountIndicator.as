package menu3.indicator
{
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class ItemCountIndicator extends IndicatorBase
   {
       
      
      private var m_tileWidth:Number = 0;
      
      public function ItemCountIndicator(param1:Number)
      {
         super();
         this.m_tileWidth = param1;
         var _loc2_:TextField = new TextField();
         _loc2_.y = MenuConstants.ItemCountIndicatorYOffset;
         _loc2_.autoSize = TextFieldAutoSize.LEFT;
         m_indicatorView = _loc2_;
      }
      
      override public function onSetData(param1:*, param2:Object) : void
      {
         super.onSetData(param1,param2);
         this.setText(param2.itemcount);
         var _loc3_:TextField = m_indicatorView as TextField;
         _loc3_.x = this.m_tileWidth - MenuConstants.ItemCountIndicatorXOffset - _loc3_.width;
      }
      
      private function setText(param1:int) : void
      {
         var _loc2_:String = "x" + param1;
         MenuUtils.setupText(m_indicatorView,_loc2_,36,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorGreyUltraLight);
      }
   }
}
