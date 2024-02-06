package menu3.basic
{
   import common.Animate;
   import common.MouseUtil;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   
   public dynamic class CategoryElement extends CategoryElementBase
   {
       
      
      private var m_view:CategoryElementView;
      
      private var m_icon:String;
      
      public function CategoryElement(param1:Object)
      {
         super(param1);
         m_mouseMode = MouseUtil.MODE_ONOVER_HOVER_ONUP_SELECT;
         m_mouseModeCollapsed = MouseUtil.MODE_ONOVER_HOVER_ONUP_SELECT;
         m_mouseModeUncollapsed = MouseUtil.MODE_ONOVER_HOVER_ONUP_SELECT;
         this.m_view = new CategoryElementView();
         MenuUtils.setColor(this.m_view.tileSelect,MenuConstants.COLOR_RED,true,MenuConstants.MenuElementSelectedAlpha);
         this.m_view.tileBg.alpha = 0;
         this.m_view.tileSelect.alpha = 0;
         this.m_icon = param1.icon;
         this.setupTextFields(String(param1.title) || "");
         this.setSelectedAnimationState(STATE_DEFAULT);
         addChild(this.m_view);
      }
      
      override public function onUnregister() : void
      {
         if(this.m_view)
         {
            Animate.kill(this.m_view.tileSelect);
            removeChild(this.m_view);
            this.m_view = null;
         }
         super.onUnregister();
      }
      
      override public function getView() : Sprite
      {
         return this.m_view.tileBg;
      }
      
      private function setupTextFields(param1:String) : void
      {
         MenuUtils.setupTextAndShrinkToFitUpper(this.m_view.title,param1,20,MenuConstants.FONT_TYPE_MEDIUM,this.m_view.title.width,-1,15,MenuConstants.FontColorWhite);
         MenuUtils.truncateTextfield(this.m_view.title,1,MenuConstants.FontColorWhite);
      }
      
      private function changeTextColor(param1:uint) : void
      {
         this.m_view.title.textColor = param1;
      }
      
      override protected function setSelectedAnimationState(param1:int) : void
      {
         Animate.complete(this.m_view.tileSelect);
         if(param1 == STATE_SELECTED)
         {
            MenuUtils.removeDropShadowFilter(this.m_view.title);
            MenuUtils.removeDropShadowFilter(this.m_view.tileIcon);
            MenuUtils.setupIcon(this.m_view.tileIcon,this.m_icon,MenuConstants.COLOR_RED,false,true,MenuConstants.COLOR_WHITE,1,0,true);
            Animate.to(this.m_view.tileSelect,MenuConstants.HiliteTime,0,{"alpha":MenuConstants.MenuElementSelectedAlpha},Animate.Linear);
            this.changeTextColor(MenuConstants.COLOR_WHITE);
         }
         else if(param1 == STATE_HOVER)
         {
            MenuUtils.removeDropShadowFilter(this.m_view.title);
            MenuUtils.removeDropShadowFilter(this.m_view.tileIcon);
            MenuUtils.setupIcon(this.m_view.tileIcon,this.m_icon,MenuConstants.COLOR_RED,false,true,MenuConstants.COLOR_WHITE,1,0,true);
            Animate.to(this.m_view.tileSelect,MenuConstants.HiliteTime,0,{"alpha":MenuConstants.MenuElementSelectedAlpha},Animate.Linear);
            this.changeTextColor(MenuConstants.COLOR_WHITE);
         }
         else
         {
            MenuUtils.addDropShadowFilter(this.m_view.title);
            MenuUtils.addDropShadowFilter(this.m_view.tileIcon);
            this.m_view.tileSelect.alpha = 0;
            MenuUtils.setupIcon(this.m_view.tileIcon,this.m_icon,MenuConstants.COLOR_WHITE,true,false);
            this.changeTextColor(MenuConstants.COLOR_WHITE);
         }
      }
   }
}
