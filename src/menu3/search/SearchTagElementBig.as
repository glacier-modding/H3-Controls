// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.search.SearchTagElementBig

package menu3.search {
import flash.text.TextField;

import common.Log;

public dynamic class SearchTagElementBig extends SearchElementBase {

	private var m_isElementActive:Boolean = false;
	private var m_isElementDisabled:Boolean = false;

	public function SearchTagElementBig(_arg_1:Object) {
		super(_arg_1);
	}

	public static function setTabPositionBetweenTextFields(_arg_1:TextField, _arg_2:TextField, _arg_3:Number):void {
		var _local_4:Number = (_arg_2.x - (_arg_1.width + _arg_1.x));
		var _local_5:Number = ((_arg_3 - _local_4) - _arg_1.x);
		var _local_6:Number = _arg_3;
		var _local_7:Number = ((_arg_2.x - _local_6) + _arg_2.width);
		_arg_1.width = _local_5;
		_arg_2.x = _local_6;
		_arg_2.width = _local_7;
	}


	override protected function createPrivateView():* {
		return (new ContractSearchTagElementBigView());
	}

	protected function get Tab01TextField():TextField {
		return (getPrivateView().tab01_txt);
	}

	protected function get Tab02TextField():TextField {
		return (getPrivateView().tab02_txt);
	}

	override public function onSetData(_arg_1:Object):void {
		if (((!(_arg_1.titletab01 == null)) || (!(_arg_1.titletab02 == null)))) {
			_arg_1.title = null;
		}

		super.onSetData(_arg_1);
		if (_arg_1.titletab01 != null) {
			setupTextField(this.Tab01TextField, _arg_1.titletab01);
		}

		if (_arg_1.titletab02 != null) {
			setupTextField(this.Tab02TextField, _arg_1.titletab02);
		}

		if (_arg_1.tabposition != null) {
			setTabPositionBetweenTextFields(this.Tab01TextField, this.Tab02TextField, _arg_1.tabposition);
		}

		this.m_isElementActive = false;
		if (_arg_1.hasOwnProperty("active")) {
			this.m_isElementActive = _arg_1.active;
		} else {
			if (getNodeProp(this, "pressable") == false) {
				this.m_isElementActive = true;
			}

		}

		this.m_isElementDisabled = false;
		if (_arg_1.hasOwnProperty("disabled")) {
			this.m_isElementDisabled = _arg_1.disabled;
		}

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

		}

	}


}
}//package menu3.search

