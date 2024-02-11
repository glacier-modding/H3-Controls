// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.search.SearchTagElement

package menu3.search {
import common.Log;

public dynamic class SearchTagElement extends SearchElementBase {

	protected var m_isElementActive:Boolean = false;
	private var m_isElementDisabled:Boolean = false;

	public function SearchTagElement(_arg_1:Object) {
		super(_arg_1);
	}

	override protected function createPrivateView():* {
		return (new ContractSearchTagElementView());
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		this.m_isElementActive = false;
		if (_arg_1.hasOwnProperty("active")) {
			this.m_isElementActive = _arg_1.active;
		} else {
			if (getNodeProp(this, "pressable") == false) {
				this.m_isElementActive = true;
			}
			;
		}
		;
		this.m_isElementDisabled = false;
		if (_arg_1.hasOwnProperty("disabled")) {
			this.m_isElementDisabled = _arg_1.disabled;
		}
		;
		this.updateState();
	}

	public function onAcceptPressed():void {
		Log.info(Log.ChannelDebug, this, "onAcceptPressed");
		this.m_isElementActive = true;
		this.updateState();
	}

	public function onCancelPressed():void {
		Log.info(Log.ChannelDebug, this, "onCancelPressed");
		this.m_isElementActive = false;
		this.updateState();
	}

	override protected function updateState():void {
		if (this.m_isElementDisabled) {
			setState(STATE_DISABLED);
		} else {
			if (this.m_isElementActive) {
				setState(((m_isSelected) ? STATE_ACTIVE_SELECT : STATE_ACTIVE));
			} else {
				setState(((m_isSelected) ? STATE_SELECT : STATE_NONE));
			}
			;
		}
		;
	}


}
}//package menu3.search

