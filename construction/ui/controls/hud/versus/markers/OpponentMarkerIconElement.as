package hud.versus.markers
{
   public class OpponentMarkerIconElement extends BaseMarkerElement
   {
       
      
      public function OpponentMarkerIconElement()
      {
         super();
         m_view = new OpponentMarkerIconElementView();
         addChild(m_view);
      }
   }
}
