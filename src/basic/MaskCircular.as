// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//basic.MaskCircular

package basic {
import common.BaseControl;

import flash.display.Sprite;

public class MaskCircular extends BaseControl {

	private var m_view:MaskView_circular;
	private var m_cacheMaskeeAsBitmap:Boolean;
	private var m_maskee:Sprite;

	public function MaskCircular() {
		this.m_view = new MaskView_circular();
		this.m_cacheMaskeeAsBitmap = false;
		addChild(this.m_view);
	}

	public function onSetData(_arg_1:Object):void {
		this.m_maskee = (_arg_1 as Sprite);
		this.updateMask();
	}

	public function updateMask():void {
		trace(("MaskCircular attempting to set maskee: " + this.m_maskee));
		if (this.m_maskee) {
			trace(("MaskCircular sets maskee: " + this.m_maskee));
			this.m_maskee.mask = this.m_view;
		}

	}

	override public function onSetSize(_arg_1:Number, _arg_2:Number):void {
		this.m_view.width = _arg_1;
		this.m_view.height = _arg_2;
		this.m_view.x = (-(this.m_view.width) / 2);
		this.m_view.y = (-(this.m_view.height) / 2);
	}

	public function set CacheMaskAsBitmap(_arg_1:Boolean):void {
		this.m_cacheMaskeeAsBitmap = _arg_1;
		this.updateMask();
	}


}
}//package basic

