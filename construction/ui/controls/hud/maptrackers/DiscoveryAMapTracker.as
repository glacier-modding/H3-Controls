package hud.maptrackers
{
   import common.Localization;
   
   public class DiscoveryAMapTracker extends LevelCheckedMapTracker
   {
       
      
      private var m_view:minimapBlipDiscoveryAView;
      
      public function DiscoveryAMapTracker()
      {
         super();
         this.setupDiscoveryAMapTracker();
      }
      
      private function setupDiscoveryAMapTracker() : void
      {
         this.m_view = new minimapBlipDiscoveryAView();
         setMainView(this.m_view);
      }
      
      override public function getTextForLegend() : String
      {
         return Localization.get("UI_MAP_OBJECTIVE");
      }
   }
}
