// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.AIIndicator

package hud {
import common.BaseControl;

import basic.BoundsExtender;

import common.ObjectPool;

public class AIIndicator extends BaseControl {

	private var m_hContainer:BoundsExtender = new BoundsExtender();
	private var m_indicatorsAvailable:ObjectPool = null;

	public function AIIndicator() {
		addChild(this.m_hContainer);
		this.m_indicatorsAvailable = new ObjectPool(AIIndicatorView, 0x0100, this.onNewIndicatorAllocated);
	}

	private function onNewIndicatorAllocated(_arg_1:AIIndicatorView):void {
		_arg_1.alpha = 0;
		_arg_1.witnessIcon.alpha = 0;
		this.m_hContainer.addChild(_arg_1);
		_arg_1.rotationX = 0;
	}

	public function acquireIndicator():AIIndicatorView {
		return (this.m_indicatorsAvailable.acquireObject());
	}

	public function releaseIndicator(_arg_1:AIIndicatorView):void {
		this.m_indicatorsAvailable.releaseObject(_arg_1);
	}


}
}//package hud

