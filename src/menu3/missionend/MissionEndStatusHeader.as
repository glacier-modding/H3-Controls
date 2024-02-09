package menu3.missionend
{
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import menu3.MenuElementBase;
   
   public dynamic class MissionEndStatusHeader extends MenuElementBase
   {
       
      
      private var m_view:MissionEndStatusHeaderView;
      
      public function MissionEndStatusHeader(param1:Object)
      {
         super(param1);
         this.m_view = new MissionEndStatusHeaderView();
         MenuUtils.addDropShadowFilter(this.m_view.title);
         MenuUtils.addDropShadowFilter(this.m_view.subtitle);
         addChild(this.m_view);
      }
      
      override public function onSetData(param1:Object) : void
      {
         super.onSetData(param1);
         var _loc2_:String = !!param1.title ? String(param1.title) : "";
         var _loc3_:String = !!param1.subtitle ? String(param1.subtitle) : "";
         MenuUtils.setupTextUpper(this.m_view.title,_loc2_,70,MenuConstants.FONT_TYPE_MEDIUM,param1.isFailed === true ? MenuConstants.FontColorRed : MenuConstants.FontColorWhite);
         MenuUtils.setupTextUpper(this.m_view.subtitle,_loc3_,35,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
      }
   }
}
