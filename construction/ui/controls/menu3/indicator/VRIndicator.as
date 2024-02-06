package menu3.indicator
{
   import common.menu.MenuConstants;
   
   public class VRIndicator extends IndicatorBase
   {
       
      
      public function VRIndicator(param1:Number, param2:Number)
      {
         super();
         m_indicatorView = new VRIndicatorView();
         m_indicatorView.x = param1 - MenuConstants.VRIndicatorXOffset;
         m_indicatorView.y = MenuConstants.VRIndicatorYOffset;
      }
   }
}
