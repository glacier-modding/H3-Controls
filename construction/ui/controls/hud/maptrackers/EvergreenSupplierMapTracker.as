package hud.maptrackers
{
   import common.Localization;
   
   public class EvergreenSupplierMapTracker extends LevelCheckedMapTracker
   {
       
      
      private var m_view:minimapBlipEvergreenSupplierView;
      
      public function EvergreenSupplierMapTracker()
      {
         super();
         this.setupEvergreenSupplierMapTracker();
      }
      
      private function setupEvergreenSupplierMapTracker() : void
      {
         this.m_view = new minimapBlipEvergreenSupplierView();
         setMainView(this.m_view);
      }
      
      override public function getTextForLegend() : String
      {
         return Localization.get("UI_MAP_LEGEND_LABEL_EVERGREEN_SUPPLIER");
      }
   }
}
