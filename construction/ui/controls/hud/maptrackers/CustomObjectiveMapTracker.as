package hud.maptrackers
{
   import common.Localization;
   
   public class CustomObjectiveMapTracker extends LevelCheckedMapTracker
   {
       
      
      private var m_view:minimapBlipObjectiveView;
      
      public function CustomObjectiveMapTracker()
      {
         super();
         this.setupCustomObjectiveMapTracker();
      }
      
      private function setupCustomObjectiveMapTracker() : void
      {
         this.m_view = new minimapBlipObjectiveView();
         setMainView(this.m_view);
      }
      
      override public function getTextForLegend() : String
      {
         return Localization.get("UI_MAP_OBJECTIVE");
      }
   }
}
