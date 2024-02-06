package menu3.statistics.elements
{
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class BarChartLabel extends Sprite
   {
       
      
      private var m_title:String;
      
      private var m_maxWidth:Number;
      
      public function BarChartLabel(param1:String, param2:Number)
      {
         super();
         this.m_title = param1;
         this.m_maxWidth = param2;
         this.setTitle();
      }
      
      private function setTitle() : void
      {
         var _loc1_:TextField = new TextField();
         _loc1_.width = this.m_maxWidth;
         _loc1_.multiline = true;
         _loc1_.wordWrap = true;
         _loc1_.autoSize = TextFieldAutoSize.LEFT;
         MenuUtils.setupTextUpper(_loc1_,this.m_title,14,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         addChild(_loc1_);
      }
   }
}
