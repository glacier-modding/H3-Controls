package hud.maptrackers
{
   import common.Localization;
   
   public class EvidenceMapTracker extends LevelCheckedMapTracker
   {
       
      
      private var m_view:minimapBlipEvidenceView;
      
      public function EvidenceMapTracker()
      {
         super();
         this.setupEvidenceMapTracker();
      }
      
      private function setupEvidenceMapTracker() : void
      {
         this.m_view = new minimapBlipEvidenceView();
         setMainView(this.m_view);
      }
      
      override public function getTextForLegend() : String
      {
         return Localization.get("UI_MAP_LEGEND_LABEL_DROPPED_CLOTHBUNDLE");
      }
   }
}
