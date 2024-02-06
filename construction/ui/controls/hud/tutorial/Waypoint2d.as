package hud.tutorial
{
   import common.BaseControl;
   
   public class Waypoint2d extends BaseControl
   {
       
      
      private var m_view:Waypoint2DView;
      
      public function Waypoint2d()
      {
         super();
         this.m_view = new Waypoint2DView();
         addChild(this.m_view);
         if(ControlsMain.isVrModeActive())
         {
            this.m_view.icon.visible = false;
            this.m_view.distance.visible = false;
         }
      }
      
      public function onSetData(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         if(!ControlsMain.isVrModeActive())
         {
            _loc2_ = int(param1.distance);
            this.m_view.distance.visible = _loc2_ >= 0 ? true : false;
            this.m_view.distance.text = _loc2_.toString() + "m";
            _loc3_ = ControlsMain.getDisplaySize() == ControlsMain.DISPLAY_SIZE_SMALL ? 1.5 : 1;
            this.m_view.distance.scaleX = _loc3_;
            this.m_view.distance.scaleY = _loc3_;
         }
      }
   }
}
