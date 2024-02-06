package hud
{
   import common.Animate;
   import common.BaseControl;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   
   public class HintBox extends BaseControl
   {
       
      
      private var m_view:HintBoxView;
      
      public function HintBox()
      {
         super();
         this.m_view = new HintBoxView();
         this.m_view.hintbox_mc.x = this.m_view.hintbox_mc.y = 0;
         addChild(this.m_view);
      }
      
      public function showText(param1:String, param2:String) : void
      {
         MenuUtils.setupText(this.m_view.hintbox_mc.title_text,param1,18,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorGreyUltraLight);
         MenuUtils.setupText(this.m_view.hintbox_mc.body_text,param2,18,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorGreyUltraLight);
         this.m_view.hintbox_mc.background_mc.height = this.m_view.hintbox_mc.body_text.textHeight + 55;
         this.onSetVisible(true);
      }
      
      public function hideText() : void
      {
         this.m_view.visible = false;
      }
      
      public function onSetData(param1:Object) : void
      {
         this.showText(param1.title,param1.body);
      }
      
      override public function onSetVisible(param1:Boolean) : void
      {
         this.m_view.visible = param1;
         if(param1)
         {
            this.m_view.y = 30;
            Animate.legacyTo(this.m_view,1,{"y":0},Animate.ExpoOut);
         }
      }
   }
}
