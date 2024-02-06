package hud
{
   public class MapLegendMenu extends MapLegend
   {
       
      
      public function MapLegendMenu()
      {
         super();
         onSetData({
            "showExitIcon":false,
            "showEntranceIcon":true,
            "showOpportunityIcons":false,
            "showStashpointIcons":true
         });
      }
   }
}
