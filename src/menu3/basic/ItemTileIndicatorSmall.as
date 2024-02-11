// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.ItemTileIndicatorSmall

package menu3.basic {
import common.Log;

import flash.events.MouseEvent;

public dynamic class ItemTileIndicatorSmall extends ItemTileSmall {

	public function ItemTileIndicatorSmall(_arg_1:Object) {
		super(_arg_1);
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
	}

	public function handleRollOver(_arg_1:MouseEvent):void {
		Log.mouse(this, _arg_1, "ItemTileIndicatorSmall");
		_arg_1.stopImmediatePropagation();
		if (m_isSelected) {
			return;
		}
		;
		if (stage.focus == this) {
			return;
		}
		;
		stage.focus = this;
		setItemSelected(true);
		stage.stageFocusRect = false;
	}

	public function handleRollOut(_arg_1:MouseEvent):void {
		Log.mouse(this, _arg_1, "ItemTileIndicatorSmall");
		_arg_1.stopImmediatePropagation();
		if (((stage) && (stage.focus == this))) {
			stage.focus = null;
		}
		;
		setItemSelected(false);
	}


}
}//package menu3.basic

