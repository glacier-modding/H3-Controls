// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.AccountElement

package menu3.basic {
import menu3.MenuElementBase;

import common.Log;
import common.menu.MenuUtils;
import common.menu.MenuConstants;

public dynamic class AccountElement extends MenuElementBase {

	private var m_view:AccountElementView;

	public function AccountElement(_arg_1:Object) {
		super(_arg_1);
		this.m_view = new AccountElementView();
		addChild(this.m_view);
	}

	protected function getRootView():AccountElementView {
		return (this.m_view);
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		Log.debugData(this, _arg_1);
		if (((_arg_1.header == undefined) || (_arg_1.content == undefined))) {
			this.m_view.visible = false;
			return;
		}

		this.showData(_arg_1.header, _arg_1.content);
	}

	private function showData(_arg_1:String, _arg_2:Object):void {
		var _local_5:int;
		var _local_6:String;
		var _local_3:String;
		var _local_4:Array = (_arg_2 as Array);
		if (_local_4 != null) {
			_local_5 = 0;
			while (_local_5 < _local_4.length) {
				_local_6 = this.prepareValue(_local_4[_local_5]);
				if (_local_6 != null) {
					if (_local_3 == null) {
						_local_3 = _local_6;
					} else {
						_local_3 = _local_6;
					}

				}

				_local_5++;
			}

		} else {
			_local_3 = this.prepareValue(_arg_2);
		}

		if (_local_3 != null) {
			this.m_view.visible = true;
			MenuUtils.setupTextUpper(this.m_view.value, ("  -  " + _local_3), 12, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorGreen);
		} else {
			this.m_view.visible = false;
		}

	}

	private function prepareValue(_arg_1:Object):String {
		var _local_2:String;
		var _local_3:String;
		if (_arg_1.value != undefined) {
			_local_2 = "";
			_local_3 = "";
			if (((!(_arg_1.valuePrefix == null)) && (_arg_1.valuePrefix.length > 0))) {
				_local_2 = (_arg_1.valuePrefix + " ");
			}

			if (((!(_arg_1.valuePostfix == null)) && (_arg_1.valuePostfix.length > 0))) {
				_local_3 = (" " + _arg_1.valuePostfix);
			}

			return ((_local_2 + MenuUtils.formatNumber(_arg_1.value)) + _local_3);
		}

		if (_arg_1.text != undefined) {
			return (_arg_1.text);
		}

		return (null);
	}

	public function setTextPosition(_arg_1:int):void {
		this.m_view.value.x = (75 + _arg_1);
	}

	public function setupDifficulty(_arg_1:Boolean):void {
	}

	override public function onUnregister():void {
		if (this.m_view) {
			removeChild(this.m_view);
			this.m_view = null;
		}

		super.onUnregister();
	}


}
}//package menu3.basic

