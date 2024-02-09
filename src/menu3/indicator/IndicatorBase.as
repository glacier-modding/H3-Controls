package menu3.indicator
{
   import common.Animate;
   import common.menu.MenuConstants;
   import menu3.basic.TextTickerUtil;
   
   public class IndicatorBase implements IIndicator
   {
       
      
      protected var m_indicatorView:* = null;
      
      protected var m_textTickerUtil:TextTickerUtil;
      
      public function IndicatorBase()
      {
         this.m_textTickerUtil = new TextTickerUtil();
         super();
      }
      
      public function onSetData(param1:*, param2:Object) : void
      {
         param1.addChild(this.m_indicatorView);
      }
      
      public function onUnregister() : void
      {
         if(this.m_textTickerUtil != null)
         {
            this.m_textTickerUtil.onUnregister();
            this.m_textTickerUtil = null;
         }
         if(this.m_indicatorView == null)
         {
            return;
         }
         if(this.m_indicatorView.parent != null)
         {
            this.m_indicatorView.parent.removeChild(this.m_indicatorView);
         }
         this.m_indicatorView = null;
      }
      
      public function callTextTicker(param1:Boolean) : void
      {
         this.m_textTickerUtil.callTextTicker(param1);
      }
      
      public function setVisible(param1:Boolean) : void
      {
         Animate.kill(this.m_indicatorView);
         this.m_indicatorView.alpha = 0;
         if(param1)
         {
            Animate.to(this.m_indicatorView,MenuConstants.HiliteTime,0,{"alpha":1},Animate.Linear);
         }
      }
   }
}
