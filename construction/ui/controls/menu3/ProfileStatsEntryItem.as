package menu3
{
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   
   public dynamic class ProfileStatsEntryItem extends MenuElementBase
   {
       
      
      private var m_view:ProfileStatsEntryItemView;
      
      public function ProfileStatsEntryItem(param1:Object)
      {
         super(param1);
         this.m_view = new ProfileStatsEntryItemView();
         addChild(this.m_view);
      }
      
      override public function onSetData(param1:Object) : void
      {
         this.m_view.separator.width = MenuConstants.MenuWidth;
         if(param1.header)
         {
            this.m_view.separator.gotoAndStop(1);
            MenuUtils.setupText(this.m_view.title,param1.name,24,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorGreyMedium);
            MenuUtils.setupText(this.m_view.score,param1.score,24,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorGreyMedium);
            MenuUtils.setupText(this.m_view.comment,param1.info,24,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorGreyMedium);
         }
         else
         {
            this.m_view.separator.gotoAndStop(2);
            this.m_view.comment.y = 3;
            MenuUtils.setupText(this.m_view.title,param1.name,24,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorGreyUltraLight);
            MenuUtils.setupText(this.m_view.score,param1.score,24,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorGreyUltraLight);
            MenuUtils.setupText(this.m_view.comment,param1.info,18,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorGreyMedium);
         }
      }
      
      override public function onUnregister() : void
      {
         if(this.m_view)
         {
            removeChild(this.m_view);
            this.m_view = null;
         }
      }
      
      override public function getView() : Sprite
      {
         return this.m_view;
      }
   }
}
