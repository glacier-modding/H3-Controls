package hud.maptrackers
{
   import basic.TextBox;
   import common.menu.MenuUtils;
   
   public class MapTextTracker extends TextBox
   {
       
      
      public function MapTextTracker()
      {
         super();
      }
      
      override public function onSetSize(param1:Number, param2:Number) : void
      {
      }
      
      override public function onAttached() : void
      {
         super.onAttached();
         this.applyFormat();
         m_textfield.autoSize = "center";
         m_textfield.width = 3000;
         m_textfield.multiline = true;
         m_textfield.wordWrap = true;
         MenuUtils.addDropShadowFilter(m_textfield);
      }
      
      override protected function applyFormat() : void
      {
         super.applyFormat();
         m_textfield.x = -m_textfield.width / 2;
         m_textfield.y = -m_textfield.height / 2;
      }
   }
}
