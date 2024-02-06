package menu3.indicator
{
   import common.menu.MenuConstants;
   
   public class ValueIndicatorBase extends IndicatorBase
   {
       
      
      public function ValueIndicatorBase(param1:String, param2:Number)
      {
         super();
         switch(param1)
         {
            case "large":
               m_indicatorView = new ValueIndicatorLargeView();
               break;
            default:
               m_indicatorView = new ValueIndicatorSmallView();
         }
         m_indicatorView.y = param2 - MenuConstants.ValueIndicatorYOffset;
      }
   }
}
