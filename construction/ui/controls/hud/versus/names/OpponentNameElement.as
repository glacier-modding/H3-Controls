package hud.versus.names
{
   public class OpponentNameElement extends BaseNameElement
   {
       
      
      public function OpponentNameElement()
      {
         super();
         m_view = new OpponentNameElementView();
         addChild(m_view);
      }
      
      public function onSetData(param1:Object) : void
      {
      }
   }
}
