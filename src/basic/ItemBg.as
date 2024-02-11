// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//basic.ItemBg

package basic {
import common.BaseControl;

import flash.display.Sprite;

import common.Animate;

public class ItemBg extends BaseControl {

	private var m_view:ItemBgView;
	private var m_container:Sprite;

	public function ItemBg() {
		this.m_view = new ItemBgView();
		addChild(this.m_view);
		this.m_view.selected_mc.alpha = 0;
		this.m_container = new Sprite();
		addChild(this.m_container);
	}

	override public function getContainer():Sprite {
		return (this.m_container);
	}

	override public function onSetSize(_arg_1:Number, _arg_2:Number):void {
		this.m_view.bg_mc.width = (this.m_view.selected_mc.width = _arg_1);
		this.m_view.bg_mc.height = (this.m_view.selected_mc.height = _arg_2);
		this.m_view.focusIndicator_mc.height = _arg_2;
	}

	public function onSetSelected(_arg_1:Boolean):void {
		Animate.legacyTo(this.m_view.selected_mc, 0.2, {"alpha": ((_arg_1) ? 1 : 0)}, Animate.ExpoOut);
	}

	public function onSetFocused(_arg_1:Boolean):void {
		Animate.legacyTo(this.m_view.focusIndicator_mc, 0.2, {"alpha": ((_arg_1) ? 1 : 0)}, Animate.ExpoOut);
	}

	public function onButtonPressed():void {
		this.m_view.alpha = 0;
		Animate.legacyTo(this.m_view, 0.4, {"alpha": 1}, Animate.ExpoOut);
	}


}
}//package basic

