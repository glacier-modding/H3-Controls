// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.modal.ModalDialogGenericButton

package menu3.modal {
import menu3.containers.CollapsableListContainer;
import menu3.basic.TextTickerUtil;

import common.menu.MenuUtils;
import common.menu.MenuConstants;

import flash.display.Sprite;

import common.CommonUtils;

public dynamic class ModalDialogGenericButton extends CollapsableListContainer {

	protected const STATE_DEFAULT:int = 0;
	protected const STATE_SELECTED:int = 1;
	protected const STATE_GROUP_SELECTED:int = 2;
	protected const STATE_HOVER:int = 3;

	protected var m_view:ModalDialogGenericButtonView;
	private var m_textTickerUtil:TextTickerUtil = new TextTickerUtil();
	private var m_isPressable:Boolean = true;
	protected var m_iconLabel:String;
	private var m_optionStyle:Boolean = false;

	public function ModalDialogGenericButton(_arg_1:Object) {
		super(_arg_1);
		this.m_view = new ModalDialogGenericButtonView();
		this.m_view.tileDarkBg.alpha = 0;
		this.m_view.tileBg.alpha = 0;
		addChild(this.m_view);
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		if (_arg_1.dialogWidth != undefined) {
			this.setButtonWidth(_arg_1.dialogWidth);
		}

		if (_arg_1.optionstyle === true) {
			this.m_optionStyle = true;
		}

		this.m_iconLabel = "arrowright";
		if (_arg_1.icon) {
			this.m_iconLabel = _arg_1.icon;
		} else {
			if (_arg_1.type) {
				if (_arg_1.type == "ok") {
					this.m_iconLabel = "arrowright";
				} else {
					if (_arg_1.type == "cancel") {
						this.m_iconLabel = "failed";
					}

				}

			}

		}

		MenuUtils.setupIcon(this.m_view.tileIcon, this.m_iconLabel, MenuConstants.COLOR_WHITE, true, false);
		MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_MENU_SOLID_BACKGROUND, true, 1);
		if (_arg_1.title != undefined) {
			if ((_arg_1.title.length > 0)) {
				this.setupTextField(_arg_1.title);
			} else {
				this.setupTextField(_arg_1.titleplaceholder);
			}

		}

		if (getNodeProp(this, "pressable") === false) {
			this.setPressable(false);
		}

		var _local_2:int = ((m_isSelected) ? this.STATE_SELECTED : this.STATE_DEFAULT);
		this.setSelectedAnimationState(_local_2);
		setItemSelected(m_isSelected);
	}

	public function onCreationDone():void {
	}

	private function setButtonWidth(_arg_1:Number):void {
		var _local_2:Number = (_arg_1 - this.m_view.tileDarkBg.width);
		var _local_3:Number = (_local_2 / 2);
		this.m_view.tileSelect.width = (this.m_view.tileSelect.width + _local_2);
		this.m_view.tileSelect.x = (this.m_view.tileSelect.x + _local_3);
		this.m_view.tileDarkBg.width = (this.m_view.tileDarkBg.width + _local_2);
		this.m_view.tileDarkBg.x = (this.m_view.tileDarkBg.x + _local_3);
		this.m_view.tileBg.width = (this.m_view.tileBg.width + _local_2);
		this.m_view.tileBg.x = (this.m_view.tileBg.x + _local_3);
		this.m_view.title.width = (this.m_view.title.width + _local_2);
	}

	public function isPressable():Boolean {
		return (this.m_isPressable);
	}

	public function setPressable(_arg_1:Boolean):void {
		this.m_isPressable = _arg_1;
		if (this.m_isPressable) {
			this.m_view.tileIcon.alpha = 1;
			this.m_view.title.alpha = 1;
		} else {
			this.m_view.tileIcon.alpha = 0.5;
			this.m_view.title.alpha = 0.5;
		}

	}

	public function onPressed():void {
	}

	override public function getView():Sprite {
		return (this.m_view.tileBg);
	}

	private function setupTextField(_arg_1:String):void {
		MenuUtils.setupTextUpper(this.m_view.title, _arg_1, 26, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		this.m_textTickerUtil.addTextTicker(this.m_view.title, this.m_view.title.htmlText);
		MenuUtils.truncateTextfield(this.m_view.title, 1, null, CommonUtils.changeFontToGlobalIfNeeded(this.m_view.title));
	}

	private function changeTextColor(_arg_1:int):void {
		this.m_view.title.textColor = _arg_1;
	}

	private function callTextTicker(_arg_1:Boolean):void {
		this.m_textTickerUtil.callTextTicker(_arg_1, this.m_view.title.textColor);
	}

	public function setItemHover(_arg_1:Boolean):void {
		if (m_isSelected) {
			return;
		}

		var _local_2:int = ((_arg_1) ? this.STATE_HOVER : this.STATE_DEFAULT);
		this.setSelectedAnimationState(_local_2);
	}

	override protected function handleSelectionChange():void {
		var _local_1:int = this.STATE_DEFAULT;
		if (m_isSelected) {
			_local_1 = this.STATE_SELECTED;
		}

		this.setSelectedAnimationState(_local_1);
	}

	public function setSelectedAnimationState(_arg_1:int):void {
		if (!this.m_isPressable) {
			return;
		}

		if (((_arg_1 == this.STATE_SELECTED) || (_arg_1 == this.STATE_HOVER))) {
			MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_RED, true, 1);
			MenuUtils.setupIcon(this.m_view.tileIcon, this.m_iconLabel, MenuConstants.COLOR_RED, false, true, MenuConstants.COLOR_WHITE, 1, 0, true);
			MenuUtils.removeDropShadowFilter(this.m_view.title);
			MenuUtils.removeDropShadowFilter(this.m_view.tileIcon);
			this.callTextTicker(true);
		} else {
			if (this.m_optionStyle) {
				MenuUtils.setupIcon(this.m_view.tileIcon, this.m_iconLabel, MenuConstants.COLOR_WHITE, true, false);
				MenuUtils.addDropShadowFilter(this.m_view.title);
				MenuUtils.addDropShadowFilter(this.m_view.tileIcon);
				this.m_view.tileSelect.alpha = 0;
			} else {
				MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_MENU_SOLID_BACKGROUND, true, 1);
				MenuUtils.setupIcon(this.m_view.tileIcon, this.m_iconLabel, MenuConstants.COLOR_WHITE, true, false);
				MenuUtils.removeDropShadowFilter(this.m_view.title);
				MenuUtils.removeDropShadowFilter(this.m_view.tileIcon);
			}

			this.callTextTicker(false);
		}

	}

	override public function onUnregister():void {
		super.onUnregister();
		if (this.m_view) {
			this.m_textTickerUtil.onUnregister();
			this.m_textTickerUtil = null;
			removeChild(this.m_view);
			this.m_view = null;
		}

	}


}
}//package menu3.modal

