package menu3.indicator
{
   public class InPlaylistIndicator extends IndicatorBase
   {
       
      
      public function InPlaylistIndicator(param1:Number, param2:Number)
      {
         super();
         m_indicatorView = new InPlaylistIndicatorView();
         m_indicatorView.x = param1 - 52;
         m_indicatorView.y = 0;
      }
      
      public function markForDeletion(param1:Boolean) : void
      {
         if(param1)
         {
            m_indicatorView.icon.gotoAndStop(2);
            m_indicatorView.bg.gotoAndStop(2);
         }
         else
         {
            m_indicatorView.icon.gotoAndStop(1);
            m_indicatorView.bg.gotoAndStop(1);
         }
      }
      
      public function setColorInvert(param1:Boolean) : void
      {
      }
   }
}
