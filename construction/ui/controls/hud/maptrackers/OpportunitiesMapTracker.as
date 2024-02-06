package hud.maptrackers
{
   import common.Localization;
   
   public class OpportunitiesMapTracker extends LevelCheckedMapTracker
   {
       
      
      private var m_view:minimapBlipOpportunitiesView;
      
      public function OpportunitiesMapTracker()
      {
         super();
         this.setupNorthIndicatorMapTracker();
      }
      
      private function setupNorthIndicatorMapTracker() : void
      {
         this.m_view = new minimapBlipOpportunitiesView();
         setMainView(this.m_view);
      }
      
      override public function getTextForLegend() : String
      {
         return Localization.get("UI_MAP_TARGET");
      }
   }
}
