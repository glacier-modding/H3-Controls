// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.sniper.AIIndicatorElement

package hud.sniper {
import common.BaseControl;

import basic.BoundsExtender;

import common.ObjectPool;

public class AIIndicatorElement extends BaseControl {

	private var m_hContainer:BoundsExtender = new BoundsExtender();
	private var m_indicatorsAvailable:ObjectPool = null;

	public function AIIndicatorElement() {
		addChild(this.m_hContainer);
		this.m_indicatorsAvailable = new ObjectPool(AIIndicatorElementView, 0x0100, this.onNewIndicatorAllocated);
	}

	private function onNewIndicatorAllocated(_arg_1:AIIndicatorElementView):void {
		_arg_1.alpha = 0;
		this.m_hContainer.addChild(_arg_1);
		_arg_1.hasSliceAnimation = true;
	}

	public function acquireIndicator():AIIndicatorElementView {
		return (this.m_indicatorsAvailable.acquireObject());
	}

	public function releaseIndicator(_arg_1:AIIndicatorElementView):void {
		this.m_indicatorsAvailable.releaseObject(_arg_1);
	}


}
}//package hud.sniper

