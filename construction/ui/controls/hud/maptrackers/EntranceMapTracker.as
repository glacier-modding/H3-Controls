package hud.maptrackers
{
   import common.Localization;
   
   public class EntranceMapTracker extends LevelCheckedMapTracker
   {
       
      
      private var m_view:minimapBlipEntranceView;
      
      public function EntranceMapTracker()
      {
         super();
         this.setupEntranceMapTracker();
      }
      
      private function setupEntranceMapTracker() : void
      {
         this.m_view = new minimapBlipEntranceView();
         setMainView(this.m_view);
      }
      
      override public function getTextForLegend() : String
      {
         return Localization.get("UI_MAP_ENTRANCE");
      }
   }
}
