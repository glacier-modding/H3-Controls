// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//basic.Quad

package basic {
import common.BaseControl;

import flash.geom.ColorTransform;

public class Quad extends BaseControl {

	private var m_view:QuadView;

	public function Quad() {
		this.m_view = new QuadView();
		addChild(this.m_view);
	}

	public function onSetData():void {
	}

	public function set Color(_arg_1:String):void {
		var _local_3:ColorTransform;
		var _local_2:Number = parseInt(_arg_1, 16);
		if (!isNaN(_local_2)) {
			_local_3 = new ColorTransform();
			_local_3.color = _local_2;
			_local_3.alphaMultiplier = 0;
			_local_3.alphaOffset = this.m_view.shape_mc.transform.colorTransform.alphaOffset;
			this.m_view.shape_mc.transform.colorTransform = _local_3;
		}
		;
	}

	public function set Alpha(_arg_1:int):void {
		var _local_2:ColorTransform;
		if (!isNaN(_arg_1)) {
			_local_2 = new ColorTransform();
			_local_2.color = this.m_view.shape_mc.transform.colorTransform.color;
			_local_2.alphaMultiplier = 0;
			_local_2.alphaOffset = ((_arg_1 * 0x0100) / 100);
			this.m_view.shape_mc.transform.colorTransform = _local_2;
		}
		;
	}

	override public function onSetSize(_arg_1:Number, _arg_2:Number):void {
		this.m_view.width = _arg_1;
		this.m_view.height = _arg_2;
	}


}
}//package basic

