// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//basic.Mask

package basic {
import common.BaseControl;

public class Mask extends BaseControl {

	private var m_view:MaskView;

	public function Mask() {
		this.m_view = new MaskView();
		addChild(this.m_view);
	}

	override public function onChildrenAttached():void {
		var _local_1:uint;
		while (_local_1 < this.numChildren) {
			if (this.getChildAt(_local_1) != this.m_view) {
				this.getChildAt(_local_1).mask = this.m_view;
			}
			;
			_local_1++;
		}
		;
	}

	override public function onSetSize(_arg_1:Number, _arg_2:Number):void {
		this.m_view.width = _arg_1;
		this.m_view.height = _arg_2;
	}


}
}//package basic

