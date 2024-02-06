package menu3.indicator
{
   import flash.utils.Dictionary;
   
   public class IndicatorUtil
   {
       
      
      private var m_indicators:Dictionary;
      
      public function IndicatorUtil()
      {
         this.m_indicators = new Dictionary();
         super();
      }
      
      public function getIndicator(param1:int) : IIndicator
      {
         if(param1 in this.m_indicators)
         {
            return this.m_indicators[param1];
         }
         return null;
      }
      
      public function add(param1:int, param2:IIndicator, param3:*, param4:Object) : void
      {
         param2.onSetData(param3,param4);
         this.m_indicators[param1] = param2;
      }
      
      public function clearIndicators() : void
      {
         var _loc1_:IIndicator = null;
         for each(_loc1_ in this.m_indicators)
         {
            _loc1_.onUnregister();
         }
         this.m_indicators = new Dictionary();
      }
      
      public function callTextTickers(param1:Boolean) : void
      {
         var _loc2_:IIndicator = null;
         for each(_loc2_ in this.m_indicators)
         {
            _loc2_.callTextTicker(param1);
         }
      }
   }
}
