// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.search.SearchTagElementCustom

package menu3.search {
import flash.text.TextField;
import flash.display.Sprite;
import flash.text.TextFieldType;
import flash.text.TextFieldAutoSize;

import common.menu.MenuUtils;
import common.menu.MenuConstants;

public dynamic class SearchTagElementCustom extends SearchTagElement {

	public function SearchTagElementCustom(_arg_1:Object) {
		super(_arg_1);
	}

	override protected function createPrivateView():* {
		return (new ContractSearchCustomTagView());
	}

	protected function get InputTextField():TextField {
		return (m_view.input_txt);
	}

	protected function get InputTextFiledBackground():Sprite {
		return (m_view.inputTxtBgMc);
	}

	override public function onSetData(_arg_1:Object):void {
		if (_arg_1.width != null) {
			this.updateWidth(_arg_1.width);
		}

		super.onSetData(_arg_1);
		this.setupInputTextField(_arg_1);
		updateState();
	}

	protected function setupInputTextField(_arg_1:Object):void {
		this.InputTextField.selectable = false;
		this.InputTextField.type = TextFieldType.DYNAMIC;
		this.InputTextField.multiline = false;
		this.InputTextField.maxChars = 40;
		this.InputTextField.autoSize = TextFieldAutoSize.NONE;
		this.InputTextField.text = "";
		if (_arg_1.defaulttext) {
			this.InputTextField.text = _arg_1.defaulttext;
		}

	}

	override protected function setupTitleTextField(_arg_1:String):void {
	}

	override protected function setState(_arg_1:int):void {
		super.setState(_arg_1);
		this.InputTextFiledBackground.alpha = 1;
		if (_arg_1 == STATE_NONE) {
			MenuUtils.setColor(this.InputTextFiledBackground, MenuConstants.COLOR_MENU_CONTRACT_SEARCH_GREY, false);
			this.InputTextField.textColor = MenuConstants.COLOR_WHITE;
		} else {
			if (_arg_1 == STATE_DISABLED) {
				MenuUtils.setColor(this.InputTextFiledBackground, MenuConstants.COLOR_MENU_CONTRACT_SEARCH_GREY, false);
				this.InputTextFiledBackground.alpha = 0.5;
			} else {
				if (_arg_1 == STATE_ACTIVE) {
					MenuUtils.setColor(this.InputTextFiledBackground, MenuConstants.COLOR_WHITE, false);
					this.InputTextField.textColor = MenuConstants.COLOR_GREY_DARK;
				} else {
					MenuUtils.setColor(this.InputTextFiledBackground, MenuConstants.COLOR_WHITE, false);
					this.InputTextField.textColor = MenuConstants.COLOR_GREY_DARK;
				}

			}

		}

	}

	private function updateWidth(_arg_1:Number):void {
		var _local_2:Number = 4;
		var _local_3:Number = 100;
		var _local_4:Number = 44;
		var _local_5:Number = 40;
		var _local_6:* = getPrivateView();
		var _local_7:Number = (_arg_1 / 2);
		var _local_8:Number = (_arg_1 - _local_2);
		_local_6.tileBgMc.x = _local_7;
		_local_6.tileSelectMc.x = _local_7;
		_local_6.tileHoverMc.x = _local_7;
		_local_6.tileSelectPulsate.x = _local_7;
		_local_6.inputTxtBgMc.x = _local_7;
		_local_6.tileBgMc.width = _local_8;
		_local_6.tileSelectMc.width = _local_8;
		_local_6.tileHoverMc.width = (_arg_1 - _local_5);
		_local_6.tileSelectPulsate.width = (_arg_1 - _local_5);
		_local_6.inputTxtBgMc.width = (_arg_1 - _local_4);
		this.InputTextField.width = (_arg_1 - _local_3);
	}


}
}//package menu3.search

