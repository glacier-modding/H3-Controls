// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.ButtonTileBase

package menu3 {
import common.menu.textTicker;

import flash.text.TextField;

import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.CommonUtils;
import common.Animate;

public dynamic class ButtonTileBase extends MenuElementTileBase {

	protected const STATE_DEFAULT:int = 0;
	protected const STATE_SELECTED:int = 1;
	protected const STATE_NOT_SELECTABLE:int = 2;
	protected const STATE_DISABLED:int = 3;
	protected const SUBSTATE_DEFAULT:String = "default";
	protected const SUBSTATE_IN_PROGRESS:String = "inprogress";
	protected const SUBSTATE_DONE:String = "done";

	protected var m_view:Object;
	protected var m_iconName:String;
	protected var m_GroupSelected:Boolean = false;
	protected var m_textTicker:textTicker;
	protected var m_textObj:Object = {};
	protected var m_infoText:String;
	protected var m_currentState:int = 0;
	protected var m_currentSubState:String = "default";
	private var m_title:String = "";
	private var m_titleChanged:Boolean = false;

	public function ButtonTileBase(_arg_1:Object) {
		super(_arg_1);
		this.m_iconName = _arg_1.icon;
	}

	protected function initView():void {
		this.m_view.tileBg.alpha = 0;
		this.m_view.tileDarkBg.alpha = 0;
		this.m_view.dropShadow.alpha = 0;
	}

	override public function onSetData(_arg_1:Object):void {
		var _local_2:TextField;
		var _local_3:String;
		var _local_4:String;
		super.onSetData(_arg_1);
		this.m_currentSubState = this.SUBSTATE_DEFAULT;
		if (_arg_1.substate != null) {
			this.m_currentSubState = _arg_1.substate;
		}

		this.m_infoText = "";
		if (_arg_1.infoTitle != null) {
			this.m_infoText = _arg_1.infoTitle;
		}

		MenuUtils.setupTextUpper(this.m_view.information, this.m_infoText, 22, MenuConstants.FONT_TYPE_MEDIUM);
		MenuUtils.truncateHTMLField(this.m_view.information, this.m_view.information.htmlText);
		if (_arg_1.infoPlayer != null) {
			_local_2 = new TextField();
			_local_2.width = this.m_view.information.width;
			_local_2.height = this.m_view.information.height;
			_local_3 = _arg_1.infoPlayer;
			MenuUtils.setupTextUpper(_local_2, _local_3, 20, MenuConstants.FONT_TYPE_NORMAL);
			CommonUtils.changeFontToGlobalIfNeeded(_local_2);
			MenuUtils.truncateTextfieldWithCharLimit(_local_2, 1, MenuConstants.PLAYERNAME_MIN_CHAR_COUNT);
			MenuUtils.shrinkTextToFit(_local_2, _local_2.width, -1);
			_local_4 = _local_2.htmlText;
			if (this.m_infoText.length > 0) {
				_local_4 = (this.m_view.information.htmlText + _local_4);
			}

			this.m_view.information.htmlText = _local_4;
		}

		this.m_currentState = ((m_isSelected) ? this.STATE_SELECTED : this.STATE_DEFAULT);
		if (((_arg_1.hasOwnProperty("disabled")) && (_arg_1.disabled == true))) {
			this.m_currentState = this.STATE_DISABLED;
		} else {
			if (getNodeProp(this, "selectable") == false) {
				this.m_currentState = this.STATE_NOT_SELECTABLE;
			}

		}

		MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_MENU_BUTTON_TILE_DESELECTED, true, 1);
	}

	override protected function handleSelectionChange():void {
		if (this.m_currentState == this.STATE_DISABLED) {
			return;
		}

		this.m_currentState = ((m_isSelected) ? this.STATE_SELECTED : this.STATE_DEFAULT);
		this.updateState();
	}

	public function setItemGroupSelected(_arg_1:Boolean):void {
		if (this.m_GroupSelected != _arg_1) {
			this.m_GroupSelected = _arg_1;
			this.updateState();
		}

	}

	override public function setItemSelected(_arg_1:Boolean):void {
		if (m_isSelected == _arg_1) {
			return;
		}

		m_isSelected = _arg_1;
		this.handleSelectionChange();
	}

	protected function updateState():void {
		this.setSelectedAnimationState(this.m_view, this.m_currentState);
	}

	protected function changeTextColor(_arg_1:int):void {
		if (!m_isSelected) {
			if (this.m_currentSubState == this.SUBSTATE_IN_PROGRESS) {
				_arg_1 = ((this.m_GroupSelected) ? MenuConstants.COLOR_RED : MenuConstants.COLOR_RED);
			} else {
				if (this.m_currentSubState == this.SUBSTATE_DONE) {
					_arg_1 = MenuConstants.COLOR_GREEN;
				}

			}

		}

		this.m_view.header.textColor = MenuConstants.COLOR_WHITE;
		this.m_view.title.textColor = _arg_1;
		this.m_view.information.textColor = _arg_1;
		if (this.m_textTicker) {
			this.m_textTicker.setTextColor(_arg_1);
		}

	}

	protected function completeAnimations():void {
		Animate.kill(this.m_view.dropShadow);
	}

	protected function setSelectedAnimationState(_arg_1:Object, _arg_2:int):void {
		this.completeAnimations();
		if (m_loading) {
			return;
		}

		this.callTextTicker(m_isSelected);
		if (((_arg_2 == this.STATE_NOT_SELECTABLE) || (_arg_2 == this.STATE_DISABLED))) {
			setPopOutScale(_arg_1, false);
			_arg_1.dropShadow.alpha = 0;
			MenuUtils.setupIcon(_arg_1.tileIcon, this.m_iconName, MenuConstants.COLOR_GREY, true, false);
			this.changeTextColor(((_arg_2 == this.STATE_DISABLED) ? MenuConstants.COLOR_GREY : MenuConstants.COLOR_WHITE));
			if (_arg_1.buttonnumber) {
				MenuUtils.setColor(_arg_1.buttonnumber, MenuConstants.COLOR_GREY, false);
			}

		} else {
			if (_arg_2 == this.STATE_SELECTED) {
				setPopOutScale(_arg_1, true);
				Animate.to(_arg_1.dropShadow, 0.3, 0, {"alpha": 1}, Animate.ExpoOut);
				this.changeTextColor(MenuConstants.COLOR_WHITE);
				MenuUtils.setColor(_arg_1.tileSelect, MenuConstants.COLOR_RED, true, 1);
				MenuUtils.setupIcon(_arg_1.tileIcon, this.m_iconName, MenuConstants.COLOR_RED, false, true, MenuConstants.COLOR_WHITE, 1, 0, true);
				if (_arg_1.buttonnumber) {
					MenuUtils.setColor(_arg_1.buttonnumber, MenuConstants.COLOR_WHITE, false);
				}

			} else {
				setPopOutScale(_arg_1, false);
				_arg_1.dropShadow.alpha = 0;
				if (this.m_GroupSelected) {
					MenuUtils.setColor(_arg_1.tileSelect, MenuConstants.COLOR_MENU_SOLID_BACKGROUND, false);
					MenuUtils.setupIcon(_arg_1.tileIcon, this.m_iconName, MenuConstants.COLOR_MENU_SOLID_BACKGROUND, false, true, MenuConstants.COLOR_GREY);
					if (_arg_1.buttonnumber) {
						MenuUtils.setColor(_arg_1.buttonnumber, MenuConstants.COLOR_GREY, false);
					}

					this.changeTextColor(MenuConstants.COLOR_GREY);
				} else {
					this.changeTextColor(MenuConstants.COLOR_WHITE);
					MenuUtils.setColor(_arg_1.tileSelect, MenuConstants.COLOR_MENU_BUTTON_TILE_DESELECTED, true, 1);
					MenuUtils.setupIcon(_arg_1.tileIcon, this.m_iconName, MenuConstants.COLOR_RED, false, true, MenuConstants.COLOR_WHITE, 1, 0, true);
					if (_arg_1.buttonnumber) {
						MenuUtils.setColor(_arg_1.buttonnumber, MenuConstants.COLOR_WHITE, false);
					}

				}

			}

		}

	}

	protected function callTextTicker(_arg_1:Boolean):void {
		if (!this.m_textTicker) {
			this.m_textTicker = new textTicker();
		}

		if (_arg_1) {
			if (((this.m_titleChanged) || (!(this.m_textTicker.isRunning())))) {
				this.m_textTicker.startTextTicker(this.m_view.title, this.m_textObj.title);
			}

		} else {
			this.m_textTicker.stopTextTicker(this.m_view.title, this.m_textObj.title);
			MenuUtils.truncateTextfield(this.m_view.title, 1, null);
		}

		this.m_titleChanged = false;
	}

	protected function setupTextFields(_arg_1:String, _arg_2:String):void {
		MenuUtils.setupTextUpper(this.m_view.header, _arg_1, 14, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorGreyUltraLight);
		this.m_textObj.header = this.m_view.header.htmlText;
		MenuUtils.truncateTextfield(this.m_view.header, 1, null);
		if (this.m_title != _arg_2) {
			this.m_title = _arg_2;
			this.m_titleChanged = true;
			MenuUtils.setupTextUpper(this.m_view.title, _arg_2, 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
			this.m_textObj.title = this.m_view.title.htmlText;
			MenuUtils.truncateTextfield(this.m_view.title, 1, null);
		}

	}

	protected function showText(_arg_1:Boolean):void {
		this.m_view.header.visible = _arg_1;
		this.m_view.title.visible = _arg_1;
	}

	override public function onUnregister():void {
		if (this.m_textTicker) {
			this.m_textTicker.stopTextTicker(this.m_view.title, this.m_textObj.title);
			this.m_textTicker = null;
		}

		super.onUnregister();
	}


}
}//package menu3

