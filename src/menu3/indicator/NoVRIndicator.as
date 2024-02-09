package menu3.indicator
{
   import common.menu.MenuConstants;
   
   public class NoVRIndicator extends IndicatorBase
   {
       
      
      public function NoVRIndicator(param1:Number, param2:Number)
      {
         super();
         m_indicatorView = new NoVRIndicatorView();
         m_indicatorView.x = param1 - MenuConstants.VRIndicatorXOffset;
         m_indicatorView.y = MenuConstants.VRIndicatorYOffset;
      }
   }
}
