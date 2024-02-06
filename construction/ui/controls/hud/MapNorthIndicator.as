package hud
{
   import common.BaseControl;
   
   public class MapNorthIndicator extends BaseControl
   {
       
      
      private var m_view:MapNorthIndicatorView;
      
      public function MapNorthIndicator()
      {
         super();
         this.m_view = new MapNorthIndicatorView();
         addChild(this.m_view);
      }
      
      public function SetDirection(param1:Number = 0) : void
      {
         trace("MapNorthIndicator | SetDirection | rot: " + param1);
         this.m_view.visible = true;
         this.m_view.rotation = param1;
         this.m_view.n_mc.rotation = -param1;
      }
   }
}
