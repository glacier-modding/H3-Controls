package hud
{
   import basic.BoundsExtender;
   import common.BaseControl;
   import common.ObjectPool;
   
   public class AIIndicator extends BaseControl
   {
       
      
      private var m_hContainer:BoundsExtender;
      
      private var m_indicatorsAvailable:ObjectPool = null;
      
      public function AIIndicator()
      {
         this.m_hContainer = new BoundsExtender();
         super();
         addChild(this.m_hContainer);
         this.m_indicatorsAvailable = new ObjectPool(AIIndicatorView,256,this.onNewIndicatorAllocated);
      }
      
      private function onNewIndicatorAllocated(param1:AIIndicatorView) : void
      {
         param1.alpha = 0;
         param1.witnessIcon.alpha = 0;
         this.m_hContainer.addChild(param1);
         param1.rotationX = 0;
      }
      
      public function acquireIndicator() : AIIndicatorView
      {
         return this.m_indicatorsAvailable.acquireObject();
      }
      
      public function releaseIndicator(param1:AIIndicatorView) : void
      {
         this.m_indicatorsAvailable.releaseObject(param1);
      }
   }
}
