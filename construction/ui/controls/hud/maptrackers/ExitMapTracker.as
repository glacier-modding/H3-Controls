package hud.maptrackers
{
   import common.Localization;
   
   public class ExitMapTracker extends LevelCheckedMapTracker
   {
       
      
      private var m_view:minimapBlipExitView;
      
      public function ExitMapTracker()
      {
         super();
         this.setupExitMapTracker();
      }
      
      private function setupExitMapTracker() : void
      {
         this.m_view = new minimapBlipExitView();
         setMainView(this.m_view);
      }
      
      override public function getTextForLegend() : String
      {
         return Localization.get("UI_MAP_EXIT_LEVEL");
      }
   }
}
