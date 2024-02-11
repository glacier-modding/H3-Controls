// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.MenuElementTileBase

package menu3 {
import common.MouseUtil;
import common.Animate;

public dynamic class MenuElementTileBase extends MenuElementBase {

	protected var m_isSelected:Boolean = false;
	protected var m_loading:Boolean = false;
	private var m_wheelDelayActive:Boolean = false;

	public function MenuElementTileBase(_arg_1:Object) {
		super(_arg_1);
		m_mouseMode = MouseUtil.MODE_ONOVER_SELECT_ONUP_CLICK;
	}

	public function onItemLoadingStateChanged(_arg_1:Boolean):void {
		var _local_2:Boolean;
		if (_arg_1) {
			_local_2 = this.m_isSelected;
			this.setItemSelected(false);
			this.m_loading = true;
			this.m_isSelected = _local_2;
		} else {
			this.m_loading = false;
			this.setItemSelected(this.m_isSelected);
		}

	}

	public function setItemSelected(_arg_1:Boolean):void {
		if (this.m_isSelected == _arg_1) {
			return;
		}

		this.m_isSelected = _arg_1;
		this.handleSelectionChange();
	}

	public function isSelected():Boolean {
		return (this.m_isSelected);
	}

	public function isWheelDelayActive():Boolean {
		return (this.m_wheelDelayActive);
	}

	public function setWheelDelayActive(_arg_1:Boolean):void {
		this.m_wheelDelayActive = _arg_1;
	}

	protected function handleSelectionChange():void {
	}

	override public function onUnregister():void {
		if (this.m_wheelDelayActive) {
			Animate.kill(this);
		}

		super.onUnregister();
	}


}
}//package menu3

