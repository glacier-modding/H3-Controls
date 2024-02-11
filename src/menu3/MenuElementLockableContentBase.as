// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.MenuElementLockableContentBase

package menu3 {
import common.Animate;
import common.menu.MenuConstants;

import menu3.indicator.IIndicator;

public dynamic class MenuElementLockableContentBase extends MenuElementAvailabilityBase {

	public function MenuElementLockableContentBase(_arg_1:Object) {
		super(_arg_1);
	}

	override protected function handleSelectionChange():void {
		var _local_2:Boolean;
		super.handleSelectionChange();
		if (m_infoIndicator == null) {
			return;
		}

		Animate.complete(m_infoIndicator);
		if (m_loading) {
			return;
		}

		if (m_isSelected) {
			Animate.to(m_infoIndicator, MenuConstants.HiliteTime, 0, {"alpha": 1}, Animate.Linear);
		} else {
			m_infoIndicator.alpha = 0;
		}

		var _local_1:IIndicator = getIndicator(EEscalationLevelIndicator);
		if (_local_1 != null) {
			_local_2 = (m_isSelected == false);
			_local_1.setVisible(_local_2);
		}

	}


}
}//package menu3

