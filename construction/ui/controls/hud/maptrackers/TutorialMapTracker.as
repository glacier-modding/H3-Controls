package hud.maptrackers
{
   import common.Localization;
   
   public class TutorialMapTracker extends LevelCheckedMapTracker
   {
       
      
      private var m_view:minimapBlipTutorialView;
      
      public function TutorialMapTracker()
      {
         super();
         this.setupTutorialMapTracker();
      }
      
      private function setupTutorialMapTracker() : void
      {
         this.m_view = new minimapBlipTutorialView();
         setMainView(this.m_view);
      }
      
      override public function getTextForLegend() : String
      {
         return Localization.get("UI_MAP_LEGEND_LABEL_WAYPOINT");
      }
   }
}
