// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//basic.MaskCentered

package basic {
import common.BaseControl;

import flash.display.Sprite;

public class MaskCentered extends BaseControl {

	private var m_view:MaskView;
	private var m_cacheMaskeeAsBitmap:Boolean;
	private var m_maskee:Sprite;

	public function MaskCentered() {
		this.m_view = new MaskView();
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
		;
	}

	override public function onSetSize(_arg_1:Number, _arg_2:Number):void {
		this.m_view.width = _arg_1;
		this.m_view.height = _arg_2;
		this.m_view.x = (-(_arg_1) / 2);
		this.m_view.y = (-(_arg_2) / 2);
	}

	public function set CacheMaskAsBitmap(_arg_1:Boolean):void {
		this.m_cacheMaskeeAsBitmap = _arg_1;
		this.updateMask();
	}


}
}//package basic

