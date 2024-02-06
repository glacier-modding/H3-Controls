package hud.versus.names
{
   public class PlayerNameElement extends BaseNameElement
   {
       
      
      public function PlayerNameElement()
      {
         super();
         m_view = new PlayerNameElementView();
         addChild(m_view);
      }
      
      public function onSetData(param1:Object) : void
      {
      }
   }
}
