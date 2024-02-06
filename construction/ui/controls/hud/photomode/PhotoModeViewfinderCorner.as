package hud.photomode
{
   import common.BaseControl;
   
   public class PhotoModeViewfinderCorner extends BaseControl
   {
       
      
      private var m_view:PhotoModeViewfinderCornerView;
      
      public function PhotoModeViewfinderCorner()
      {
         super();
         this.m_view = new PhotoModeViewfinderCornerView();
         this.m_view.cameraitem_corner_mc.alpha = 0.4;
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
               this.m_view.visible = true;
               this.m_view.cameraitem_corner_mc.visible = true;
               break;
            case PhotoModeWidget.VIEWFINDERSTYLE_PHOTOOPP:
               this.m_view.visible = true;
               this.m_view.cameraitem_corner_mc.visible = false;
               break;
            case PhotoModeWidget.VIEWFINDERSTYLE_SPYCAM:
               this.m_view.visible = false;
               this.m_view.cameraitem_corner_mc.visible = false;
               break;
            default:
               this.m_view.visible = true;
               this.m_view.cameraitem_corner_mc.visible = true;
         }
      }
   }
}
