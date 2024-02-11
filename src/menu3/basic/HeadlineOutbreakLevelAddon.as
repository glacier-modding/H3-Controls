// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.HeadlineOutbreakLevelAddon

package menu3.basic {
import menu3.MenuElementBase;

import common.menu.MenuUtils;
import common.menu.MenuConstants;

public dynamic class HeadlineOutbreakLevelAddon extends MenuElementBase {

	private var m_view:HeadlineOutbreakLevelAddonView;

	public function HeadlineOutbreakLevelAddon(_arg_1:Object) {
		super(_arg_1);
		this.m_view = new HeadlineOutbreakLevelAddonView();
		this.m_view.indicator.x = 114;
		addChild(this.m_view);
	}

	override public function onSetData(_arg_1:Object):void {
		this.showEscalationLevel(_arg_1);
	}

	override public function onUnregister():void {
		if (this.m_view) {
			this.completeAnimations();
			removeChild(this.m_view);
			this.m_view = null;
		}
		;
	}

	private function showEscalationLevel(_arg_1:Object):void {
		var _local_5:OutbreakLevelIconView;
		var _local_2:int;
		var _local_3:int = 1;
		var _local_4:int;
		while (_local_4 < _arg_1.totallevels) {
			_local_5 = new OutbreakLevelIconView();
			MenuUtils.setTintColor(_local_5, MenuUtils.TINT_COLOR_WHITE, true);
			_local_5.alpha = 0.4;
			if (_local_3 <= (_arg_1.completedlevels + 1)) {
				_local_5.alpha = 1;
			}
			;
			this.m_view.indicator.addChild(_local_5);
			_local_5.x = _local_2;
			_local_2 = (_local_2 + MenuConstants.outbreakLevelIconXOffset);
			_local_3 = (_local_3 + 1);
			_local_4++;
		}
		;
	}

	private function completeAnimations():void {
	}


}
}//package menu3.basic

