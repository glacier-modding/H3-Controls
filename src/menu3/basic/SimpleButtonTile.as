// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.SimpleButtonTile

package menu3.basic {
import menu3.MenuElementTileBase;

import common.menu.textTicker;

import flash.text.TextField;
import flash.display.Sprite;

import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.CommonUtils;
import common.Localization;
import common.Animate;

public dynamic class SimpleButtonTile extends MenuElementTileBase {

	protected const STATE_DEFAULT:int = 0;
	protected const STATE_SELECTED:int = 1;

	protected var m_view:SimpleButtonTileView;
	protected var m_iconName:String;
	protected var m_textTicker:textTicker;
	protected var m_textObj:Object = {};
	protected var m_title:String;
	protected var m_currentState:int = 0;
	protected var m_isDisabled:Boolean = false;
	protected var m_pressable:Boolean = true;
	protected var m_isAvailable:Boolean = true;
	protected var m_showIcon:Boolean = false;
	protected var m_textfieldTitle:TextField = null;
	protected var m_textfieldHeader:TextField = null;

	public function SimpleButtonTile(_arg_1:Object) {
		super(_arg_1);
		this.m_view = new SimpleButtonTileView();
		this.m_view.tileBgInvisibleBorder.visible = false;
		this.m_view.tileBg.alpha = 0;
		this.m_view.tileSelect.alpha = 0;
		this.m_view.dropShadow.alpha = 0;
		addChild(this.m_view);
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		this.callTextTicker(false);
		this.m_pressable = true;
		if (getNodeProp(this, "pressable") == false) {
			this.m_pressable = false;
		}

		this.m_isDisabled = (_arg_1.disabled === true);
		this.m_iconName = _arg_1.icon;
		var _local_2:String;
		this.m_isAvailable = true;
		if (_arg_1.availability != null) {
			this.m_isAvailable = (_arg_1.availability.available === true);
			if (!this.m_isAvailable) {
				this.m_iconName = "arrowright";
				_local_2 = this.getUnavailableInfo(_arg_1.availability.unavailable_reason, _arg_1.availability.percentage_complete);
			}

		}

		this.m_showIcon = (!(this.m_iconName == null));
		this.m_view.tileIcon.visible = this.m_showIcon;
		this.m_view.title.visible = false;
		this.m_view.header.visible = false;
		this.m_view.iconTitle.visible = false;
		this.m_view.iconHeader.visible = false;
		if (this.m_showIcon) {
			this.m_textfieldTitle = this.m_view.iconTitle;
			this.m_textfieldHeader = this.m_view.iconHeader;
		} else {
			this.m_textfieldTitle = this.m_view.title;
			this.m_textfieldHeader = this.m_view.header;
		}

		this.m_textfieldTitle.visible = true;
		this.m_textfieldHeader.visible = true;
		var _local_3:String = ((_local_2 != null) ? _local_2 : _arg_1.header);
		this.setupTextFields(_local_3, _arg_1.title);
		this.m_currentState = ((m_isSelected) ? this.STATE_SELECTED : this.STATE_DEFAULT);
		this.updateState();
	}

	override protected function handleSelectionChange():void {
		this.m_currentState = ((m_isSelected) ? this.STATE_SELECTED : this.STATE_DEFAULT);
		this.updateState();
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

	override public function getView():Sprite {
		return (this.m_view.tileBg);
	}

	protected function setSelectedAnimationState(_arg_1:Object, _arg_2:int):void {
		this.completeAnimations();
		if (m_loading) {
			return;
		}

		this.callTextTicker(m_isSelected);
		if (_arg_2 == this.STATE_SELECTED) {
			_arg_1.alpha = 1;
			if (this.m_pressable) {
				MenuUtils.setColor(_arg_1.tileSelect, MenuConstants.COLOR_RED, true, ((this.m_isDisabled) ? 0.25 : MenuConstants.MenuElementSelectedAlpha));
				if (this.m_showIcon) {
					MenuUtils.setupIcon(_arg_1.tileIcon, this.m_iconName, MenuConstants.COLOR_RED, false, true, MenuConstants.COLOR_WHITE, 1, 0, true);
				}

			} else {
				MenuUtils.setColor(_arg_1.tileSelect, MenuConstants.COLOR_MENU_TABS_BACKGROUND, true, ((this.m_isDisabled) ? 0.25 : MenuConstants.MenuElementBackgroundAlpha));
				if (this.m_showIcon) {
					MenuUtils.setupIcon(_arg_1.tileIcon, this.m_iconName, MenuConstants.COLOR_GREY, true, false);
				}

			}

		} else {
			_arg_1.alpha = (((this.m_isDisabled) || (this.m_isAvailable)) ? 1 : 0.5);
			_arg_1.tileSelect.alpha = 0;
			if (this.m_pressable) {
				if (this.m_showIcon) {
					MenuUtils.setupIcon(_arg_1.tileIcon, this.m_iconName, MenuConstants.COLOR_WHITE, true, false);
				}

			} else {
				if (this.m_showIcon) {
					MenuUtils.setupIcon(_arg_1.tileIcon, this.m_iconName, MenuConstants.COLOR_GREY, true, false);
				}

			}

		}

	}

	protected function callTextTicker(_arg_1:Boolean):void {
		if (!this.m_textfieldTitle) {
			return;
		}

		if (!this.m_textTicker) {
			this.m_textTicker = new textTicker();
		}

		if (_arg_1) {
			this.m_textTicker.startTextTicker(this.m_textfieldTitle, this.m_textObj.title);
		} else {
			this.m_textTicker.stopTextTicker(this.m_textfieldTitle, this.m_textObj.title);
			MenuUtils.truncateTextfield(this.m_textfieldTitle, 1, MenuConstants.FontColorWhite);
		}

	}

	private function changeTextColor(_arg_1:uint, _arg_2:uint):void {
		this.m_textfieldHeader.textColor = _arg_1;
		this.m_textfieldTitle.textColor = _arg_2;
	}

	protected function setupTextFields(_arg_1:String, _arg_2:String):void {
		MenuUtils.setupTextUpper(this.m_textfieldHeader, _arg_1, 14, MenuConstants.FONT_TYPE_NORMAL, ((this.m_pressable) ? MenuConstants.FontColorWhite : MenuConstants.FontColorGrey));
		MenuUtils.setupTextUpper(this.m_textfieldTitle, _arg_2, 30, MenuConstants.FONT_TYPE_MEDIUM, ((this.m_pressable) ? MenuConstants.FontColorWhite : MenuConstants.FontColorGrey));
		this.m_textObj.header = this.m_textfieldHeader.htmlText;
		this.m_textObj.title = this.m_textfieldTitle.htmlText;
		MenuUtils.truncateTextfield(this.m_textfieldHeader, 1, ((this.m_pressable) ? MenuConstants.FontColorWhite : MenuConstants.FontColorGrey), CommonUtils.changeFontToGlobalIfNeeded(this.m_textfieldHeader));
		MenuUtils.truncateTextfield(this.m_textfieldTitle, 1, ((this.m_pressable) ? MenuConstants.FontColorWhite : MenuConstants.FontColorGrey), CommonUtils.changeFontToGlobalIfNeeded(this.m_textfieldTitle));
	}

	private function getUnavailableInfo(_arg_1:String, _arg_2:Number):String {
		var _local_3:String;
		switch (_arg_1) {
			case "entitlements_missing":
			case "dlc_not_owned":
				_local_3 = Localization.get("UI_DIALOG_DLC_PURCHASE");
				break;
			case "dlc_not_installed":
			case "dlc_update_required":
				_local_3 = Localization.get("UI_DIALOG_DLC_DOWNLOAD");
				break;
			case "dlc_downloading":
				_local_3 = ((Localization.get("UI_DIALOG_DLC_DOWNLOADING") + " ") + (Math.round((_arg_2 * 100)) + "%"));
				break;
			case "dlc_installing":
				_local_3 = ((Localization.get("UI_DIALOG_DLC_INSTALLING") + " ") + (Math.round((_arg_2 * 100)) + "%"));
				break;
			default:
				_local_3 = Localization.get("UI_DIALOG_DLC_UNKNOWN");
		}

		return (_local_3);
	}

	override public function onUnregister():void {
		if (this.m_view) {
			super.onUnregister();
			this.completeAnimations();
			if (this.m_textTicker) {
				this.m_textTicker.stopTextTicker(this.m_textfieldTitle, this.m_textObj.title);
				this.m_textTicker = null;
			}

			removeChild(this.m_view);
			this.m_view = null;
		}

	}

	protected function completeAnimations():void {
		Animate.complete(this.m_view);
	}


}
}//package menu3.basic

