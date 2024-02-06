package hud.sniper
{
	import basic.BoundsExtender;
	import common.BaseControl;
	import common.ObjectPool;
	
	public class AIIndicatorElement extends BaseControl
	{
		
		private var m_hContainer:BoundsExtender;
		
		private var m_indicatorsAvailable:ObjectPool = null;
		
		public function AIIndicatorElement()
		{
			this.m_hContainer = new BoundsExtender();
			super();
			addChild(this.m_hContainer);
			this.m_indicatorsAvailable = new ObjectPool(AIIndicatorElementView, 256, this.onNewIndicatorAllocated);
		}
		
		private function onNewIndicatorAllocated(param1:AIIndicatorElementView):void
		{
			param1.alpha = 0;
			this.m_hContainer.addChild(param1);
			param1.hasSliceAnimation = true;
		}
		
		public function acquireIndicator():AIIndicatorElementView
		{
			return this.m_indicatorsAvailable.acquireObject();
		}
		
		public function releaseIndicator(param1:AIIndicatorElementView):void
		{
			this.m_indicatorsAvailable.releaseObject(param1);
		}
	}
}
