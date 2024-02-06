package hud
{
   import common.BaseControl;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   
   public class Subtitle extends BaseControl
   {
       
      
      private var m_view:SubTitleView;
      
      public function Subtitle()
      {
         super();
         this.m_view = new SubTitleView();
         addChild(this.m_view);
      }
      
      override public function onSetSize(param1:Number, param2:Number) : void
      {
         this.m_view.sub_txt.width = param1;
         this.m_view.sub_txt.height = param2;
      }
      
      public function onSetData(param1:Object) : void
      {
         var _loc2_:String = param1 as String;
         if(_loc2_ == "")
         {
            this.m_view.visible = false;
         }
         else
         {
            MenuUtils.setupText(this.m_view.sub_txt,_loc2_,22,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorGreyUltraLight);
            this.m_view.visible = true;
         }
      }
   }
}
