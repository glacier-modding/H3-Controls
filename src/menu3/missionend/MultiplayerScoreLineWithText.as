package menu3.missionend
{
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import menu3.MenuElementBase;
   
   public dynamic class MultiplayerScoreLineWithText extends MenuElementBase
   {
       
      
      private var m_view:MultiplayerScoreLineWithTextView;
      
      private var m_listElements:Array;
      
      public function MultiplayerScoreLineWithText(param1:Object)
      {
         super(param1);
         this.m_view = new MultiplayerScoreLineWithTextView();
         addChild(this.m_view);
      }
      
      override public function onSetData(param1:Object) : void
      {
         super.onSetData(param1);
         var _loc2_:String = param1.text != null ? String(param1.text) : "";
         MenuUtils.setupTextUpper(this.m_view.text,_loc2_,170,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
      }
      
      override public function onUnregister() : void
      {
         if(this.m_view)
         {
            removeChild(this.m_view);
            this.m_view = null;
         }
         super.onUnregister();
      }
   }
}
