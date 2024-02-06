package hud.maptrackers
{
   import common.Localization;
   
   public class EvergreenMeetingBusinessMapTracker extends LevelCheckedMapTracker
   {
       
      
      private var m_view:minimapBlipEvergreenMeetingBusinessView;
      
      public function EvergreenMeetingBusinessMapTracker()
      {
         super();
         this.setupEvergreenMeetingBusinessMapTracker();
      }
      
      private function setupEvergreenMeetingBusinessMapTracker() : void
      {
         this.m_view = new minimapBlipEvergreenMeetingBusinessView();
         setMainView(this.m_view);
      }
      
      override public function getTextForLegend() : String
      {
         return Localization.get("UI_MAP_LEGEND_LABEL_EVERGREEN_MEETING_BUSINESS");
      }
   }
}
