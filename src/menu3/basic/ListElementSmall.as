// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.ListElementSmall

package menu3.basic {
import menu3.containers.CollapsableListContainer;

import common.menu.MenuUtils;
import common.menu.MenuConstants;

import flash.display.Sprite;

import common.CommonUtils;

import flash.events.MouseEvent;

public dynamic class ListElementSmall extends CollapsableListContainer {

	protected const STATE_DEFAULT:int = 0;
	protected const STATE_SELECTED:int = 1;
	protected const STATE_GROUP_SELECTED:int = 2;
	protected const STATE_HOVER:int = 3;

	private var m_view:ListElementSmallView;
	private var m_textTickerUtil:TextTickerUtil = new TextTickerUtil();
	private var m_pressable:Boolean = true;
	private var m_selectable:Boolean = true;
	private var m_greyedout:Boolean;
	private var m_iconLabel:String;
	private var m_isTextScrollingEnabled:Boolean;

	public function ListElementSmall(_arg_1:Object) {
		super(_arg_1);
		this.m_view = new ListElementSmallView();
		this.m_view.tileSelect.alpha = 0;
		this.m_view.tileDarkBg.alpha = 0;
		this.m_view.tileBg.alpha = 0;
		addChild(this.m_view);
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		this.m_pressable = getNodeProp(this, "pressable");
		this.m_selectable = getNodeProp(this, "selectable");
		this.m_view.tileBg.alpha = ((_arg_1.showTileBg === true) ? 0.5 : 0);
		this.m_iconLabel = _arg_1.icon;
		this.m_greyedout = _arg_1.greyelement;
		MenuUtils.setupIcon(this.m_view.tileIcon, this.m_iconLabel, ((this.m_pressable) ? MenuConstants.COLOR_WHITE : MenuConstants.COLOR_GREY), true, false);
		if (_arg_1.title != undefined) {
			if ((_arg_1.title.length > 0)) {
				this.setupTextField(_arg_1.title);
			} else {
				this.setupTextField(_arg_1.titleplaceholder);
			}

		}

		this.m_isTextScrollingEnabled = ((_arg_1.force_scroll) ? true : false);
		var _local_2:int = ((m_isSelected) ? this.STATE_SELECTED : this.STATE_DEFAULT);
		this.setSelectedAnimationState(_local_2);
		if (this.m_selectable == false) {
			this.m_view.tileSelect.alpha = 0;
			MenuUtils.setupIcon(this.m_view.tileIcon, this.m_iconLabel, MenuConstants.COLOR_GREY, true, false);
			this.changeTextColor(MenuConstants.COLOR_GREY);
			MenuUtils.addDropShadowFilter(this.m_view.title);
			MenuUtils.addDropShadowFilter(this.m_view.tileIcon);
			if (this.m_isTextScrollingEnabled) {
				this.callTextTicker(true);
			}

		} else {
			this.setItemSelected(m_isSelected);
		}

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

	override public function addChild2(_arg_1:Sprite, _arg_2:int = -1):void {
		super.addChild2(_arg_1, _arg_2);
		if (getNodeProp(_arg_1, "col") === undefined) {
			if (((!(this.getData().direction == "horizontal")) && (!(this.getData().direction == "horizontalWrap")))) {
				_arg_1.x = 32;
			}

		}

	}

	public function setItemHover(_arg_1:Boolean):void {
		if (((m_isSelected) || (m_isGroupSelected))) {
			return;
		}

		var _local_2:int = ((_arg_1) ? this.STATE_HOVER : this.STATE_DEFAULT);
		this.setSelectedAnimationState(_local_2);
	}

	override protected function handleSelectionChange():void {
		var _local_1:int = this.STATE_DEFAULT;
		if (m_isSelected) {
			_local_1 = this.STATE_SELECTED;
		} else {
			if (m_isGroupSelected) {
				_local_1 = this.STATE_GROUP_SELECTED;
			}

		}

		this.setSelectedAnimationState(_local_1);
	}

	override public function setItemSelected(_arg_1:Boolean):void {
		if (m_isSelected == _arg_1) {
			return;
		}

		m_isSelected = _arg_1;
		this.handleSelectionChange();
	}

	protected function setSelectedAnimationState(_arg_1:int):void {
		if (m_loading) {
			return;
		}

		if (this.m_selectable == false) {
			return;
		}

		if (_arg_1 == this.STATE_SELECTED) {
			if (this.m_pressable) {
				this.changeTextColor(((this.m_greyedout) ? MenuConstants.COLOR_GREY : MenuConstants.COLOR_WHITE));
				MenuUtils.setColor(this.m_view.tileSelect, ((this.m_greyedout) ? MenuConstants.COLOR_GREY : MenuConstants.COLOR_RED), true, MenuConstants.MenuElementSelectedAlpha);
				MenuUtils.setupIcon(this.m_view.tileIcon, this.m_iconLabel, ((this.m_greyedout) ? MenuConstants.COLOR_GREY : MenuConstants.COLOR_RED), false, true, MenuConstants.COLOR_WHITE, 1, 0, true);
			} else {
				this.changeTextColor(MenuConstants.COLOR_GREY);
				MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_MENU_TABS_BACKGROUND, true, MenuConstants.MenuElementBackgroundAlpha);
				MenuUtils.setupIcon(this.m_view.tileIcon, this.m_iconLabel, MenuConstants.COLOR_GREY, true, false);
			}

			MenuUtils.removeDropShadowFilter(this.m_view.title);
			MenuUtils.removeDropShadowFilter(this.m_view.tileIcon);
			this.callTextTicker(true);
		} else {
			if (_arg_1 == this.STATE_GROUP_SELECTED) {
				this.changeTextColor(MenuConstants.COLOR_GREY);
				MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_MENU_SOLID_BACKGROUND, true, 0);
				MenuUtils.setupIcon(this.m_view.tileIcon, this.m_iconLabel, MenuConstants.COLOR_MENU_SOLID_BACKGROUND, false, true, MenuConstants.COLOR_GREY, 1, 0, true);
				MenuUtils.removeDropShadowFilter(this.m_view.title);
				MenuUtils.removeDropShadowFilter(this.m_view.tileIcon);
				this.callTextTicker(true);
			} else {
				if (_arg_1 == this.STATE_HOVER) {
					if (this.m_pressable) {
						this.changeTextColor(((this.m_greyedout) ? MenuConstants.COLOR_GREY : MenuConstants.COLOR_WHITE));
						MenuUtils.setColor(this.m_view.tileSelect, ((this.m_greyedout) ? MenuConstants.COLOR_GREY : MenuConstants.COLOR_RED), true, MenuConstants.MenuElementSelectedAlpha);
						MenuUtils.setupIcon(this.m_view.tileIcon, this.m_iconLabel, ((this.m_greyedout) ? MenuConstants.COLOR_GREY : MenuConstants.COLOR_RED), false, true, MenuConstants.COLOR_WHITE, 1, 0, true);
					} else {
						this.changeTextColor(MenuConstants.COLOR_GREY);
						MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_MENU_TABS_BACKGROUND, true, MenuConstants.MenuElementBackgroundAlpha);
						MenuUtils.setupIcon(this.m_view.tileIcon, this.m_iconLabel, MenuConstants.COLOR_GREY, true, false);
					}

					MenuUtils.removeDropShadowFilter(this.m_view.title);
					MenuUtils.removeDropShadowFilter(this.m_view.tileIcon);
					this.callTextTicker(true);
				} else {
					if (this.m_isTextScrollingEnabled) {
						this.callTextTicker(this.m_isTextScrollingEnabled);
					} else {
						this.changeTextColor(((this.m_greyedout) ? MenuConstants.COLOR_GREY : MenuConstants.COLOR_WHITE));
						MenuUtils.setupIcon(this.m_view.tileIcon, this.m_iconLabel, ((this.m_greyedout) ? MenuConstants.COLOR_GREY : MenuConstants.COLOR_WHITE), true, false);
						MenuUtils.addDropShadowFilter(this.m_view.title);
						MenuUtils.addDropShadowFilter(this.m_view.tileIcon);
						this.m_view.tileSelect.alpha = 0;
						this.callTextTicker(false);
					}

				}

			}

		}

	}

	override public function handleMouseOver(_arg_1:Function, _arg_2:MouseEvent):void {
		if (m_isSelected) {
			_arg_2.stopImmediatePropagation();
			return;
		}

		super.handleMouseOver(_arg_1, _arg_2);
	}

	override public function handleMouseRollOut(_arg_1:Function, _arg_2:MouseEvent):void {
		var _local_3:int;
		var _local_4:Array;
		super.handleMouseRollOut(_arg_1, _arg_2);
		_arg_2.stopImmediatePropagation();
		if (this["_nodedata"]) {
			_local_3 = (this["_nodedata"]["id"] as int);
			_local_4 = [_local_3, false];
			(_arg_1("onElementHover", _local_4));
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
}//package menu3.basic

