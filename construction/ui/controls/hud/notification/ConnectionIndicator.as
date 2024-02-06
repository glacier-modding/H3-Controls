package hud.notification
{
   import common.Animate;
   import common.CommonUtils;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   
   public class ConnectionIndicator extends NotificationListener
   {
       
      
      private var m_view:ConnectionIndicatorView;
      
      public function ConnectionIndicator()
      {
         super();
         this.m_view = new ConnectionIndicatorView();
         addChild(this.m_view);
         this.m_view.x = 350;
         this.m_view.visible = false;
      }
      
      override public function SetText(param1:String) : void
      {
         this.setTextFields(param1);
      }
      
      private function setTextFields(param1:String, param2:String = null) : void
      {
         if(param2)
         {
            MenuUtils.setupText(this.m_view.label_txt,param2,18,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorRed);
            MenuUtils.setupText(this.m_view.label2_txt,param1,16,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorGreyUltraLight);
            this.m_view.label2_txt.y = this.m_view.label_txt.y + this.m_view.label_txt.textHeight + 8;
            this.m_view.back_mc.height = this.m_view.label2_txt.y + this.m_view.label2_txt.textHeight + 10;
         }
         else
         {
            MenuUtils.setupText(this.m_view.label_txt,param1,18,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorGreyUltraLight);
            MenuUtils.setupText(this.m_view.label2_txt,"",16,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorGreyUltraLight);
            this.m_view.back_mc.height = this.m_view.label_txt.y + this.m_view.label_txt.textHeight + 14;
         }
         this.m_view.visible = true;
         this.m_view.spinner_mc.visible = true;
         CommonUtils.changeFontToGlobalFont(this.m_view.label_txt);
         CommonUtils.changeFontToGlobalFont(this.m_view.label2_txt);
         this.animateIndicator();
         Animate.legacyTo(this.m_view,0.3,{
            "alpha":1,
            "x":0
         },Animate.ExpoIn);
      }
      
      override public function ShowNotification(param1:String, param2:String, param3:Object) : void
      {
         this.setTextFields(param2,param1);
      }
      
      public function ShowTestString() : void
      {
         this.ShowNotification("Connection status","WWWWWWWWWWWWWWWW suckers!",{});
      }
      
      public function ShowTestString2() : void
      {
         this.SetText("Connectionining to da networkaaa!");
      }
      
      private function animateIndicator() : void
      {
         Animate.legacyTo(this.m_view.spinner_mc,1.5,{"rotation":360},Animate.Linear,function():void
         {
            animateIndicator();
         });
      }
      
      override public function HideNotification() : void
      {
         Animate.legacyTo(this.m_view,0.2,{
            "alpha":0,
            "x":350
         },Animate.ExpoIn,function():void
         {
            Animate.kill(m_view.spinner_mc);
            Animate.kill(m_view);
            m_view.visible = false;
            m_view.spinner_mc.visible = false;
         });
      }
      
      override public function onSetVisible(param1:Boolean) : void
      {
         if(!param1)
         {
            this.HideNotification();
         }
      }
   }
}
