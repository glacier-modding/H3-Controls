package hud.tutorial
{
   import common.BaseControl;
   
   public class Waypoint2dArrow extends BaseControl
   {
       
      
      private var m_view:Waypoint2DArrowView;
      
      public function Waypoint2dArrow()
      {
         super();
         this.m_view = new Waypoint2DArrowView();
         addChild(this.m_view);
      }
   }
}
