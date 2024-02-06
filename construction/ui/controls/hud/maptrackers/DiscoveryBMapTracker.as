package hud.maptrackers
{
   import common.Localization;
   
   public class DiscoveryBMapTracker extends LevelCheckedMapTracker
   {
       
      
      private var m_view:minimapBlipDiscoveryBView;
      
      public function DiscoveryBMapTracker()
      {
         super();
         this.setupDiscoveryBMapTracker();
      }
      
      private function setupDiscoveryBMapTracker() : void
      {
         this.m_view = new minimapBlipDiscoveryBView();
         setMainView(this.m_view);
      }
      
      override public function getTextForLegend() : String
      {
         return Localization.get("UI_MAP_OBJECTIVE");
      }
   }
}
