package hud.tutorial
{
   import common.BaseControl;
   
   public class Waypoint3d extends BaseControl
   {
       
      
      private var m_view:Waypoint3DView;
      
      public function Waypoint3d()
      {
         super();
         this.m_view = new Waypoint3DView();
         addChild(this.m_view);
      }
      
      public function onSetData(param1:Object) : void
      {
         var _loc2_:int = int(param1.distance);
         this.m_view.distance.visible = _loc2_ >= 0 ? true : false;
         this.m_view.distance.text = _loc2_.toString() + "m";
         var _loc3_:Number = ControlsMain.getDisplaySize() == ControlsMain.DISPLAY_SIZE_SMALL ? 1.5 : 1;
         this.m_view.distance.scaleX = _loc3_;
         this.m_view.distance.scaleY = _loc3_;
      }
   }
}
