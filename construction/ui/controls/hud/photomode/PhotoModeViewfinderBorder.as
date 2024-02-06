package hud.photomode
{
   import common.BaseControl;
   import common.menu.MenuConstants;
   
   public class PhotoModeViewfinderBorder extends BaseControl
   {
       
      
      private var m_posX:int = 354;
      
      private var m_posY:int = 236;
      
      private var m_view:PhotoModeViewfinderBorderView;
      
      public function PhotoModeViewfinderBorder()
      {
         super();
         this.m_view = new PhotoModeViewfinderBorderView();
         this.m_view.corner_lt.alpha = this.m_view.corner_rt.alpha = this.m_view.corner_lb.alpha = this.m_view.corner_rb.alpha = 0.3;
         this.m_view.battery_mc.alpha = this.m_view.flash_mc.alpha = 0.7;
         this.m_view.visible = false;
         addChild(this.m_view);
      }
      
      public function setViewFinderStyle(param1:int) : void
      {
         switch(param1)
         {
            case PhotoModeWidget.VIEWFINDERSTYLE_NONE:
               this.m_view.visible = false;
               break;
            case PhotoModeWidget.VIEWFINDERSTYLE_CAMERAITEM:
               this.m_view.visible = false;
               break;
            case PhotoModeWidget.VIEWFINDERSTYLE_PHOTOOPP:
               this.m_view.visible = true;
               break;
            default:
               this.m_view.visible = false;
         }
      }
      
      override public function onSetSize(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = param1 > MenuConstants.BaseWidth ? param1 / MenuConstants.BaseWidth : 1;
         var _loc4_:Number = param2 > MenuConstants.BaseHeight ? param2 / MenuConstants.BaseHeight : 1;
         this.m_view.corner_lt.x = this.m_posX * _loc3_;
         this.m_view.corner_lt.y = this.m_posY * _loc4_;
         this.m_view.corner_rt.x = param1 - this.m_posX * _loc3_;
         this.m_view.corner_rt.y = this.m_posY * _loc4_;
         this.m_view.corner_lb.x = this.m_posX * _loc3_;
         this.m_view.corner_lb.y = param2 - this.m_posY * _loc4_;
         this.m_view.corner_rb.x = param1 - this.m_posX * _loc3_;
         this.m_view.corner_rb.y = param2 - this.m_posY * _loc4_;
         this.m_view.battery_mc.x = this.m_view.flash_mc.x = this.m_posX * _loc3_;
         this.m_view.battery_mc.y = this.m_view.flash_mc.y = param2 - this.m_posY * _loc4_;
      }
   }
}
