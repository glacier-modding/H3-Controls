// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.ListElementControlBinding

package menu3.basic {
import menu3.containers.CollapsableListContainer;

import common.menu.textTicker;
import common.menu.MenuUtils;
import common.menu.MenuConstants;

import flash.display.Sprite;

import common.CommonUtils;

import flash.text.TextField;

import common.Animate;

import fl.motion.Color;

import flash.display.DisplayObject;

public dynamic class ListElementControlBinding extends CollapsableListContainer {

	private var m_view:ListElementControlBindingView;
	private var m_textObj:Object = {};
	private var m_textTicker:textTicker;
	private var m_font:String;

	public function ListElementControlBinding(_arg_1:Object) {
		super(_arg_1);
		this.m_view = new ListElementControlBindingView();
		this.m_view.tileSelect.alpha = 0;
		this.m_view.tileSelectPulsate.alpha = 0;
		this.m_view.tileSelected.alpha = 0;
		this.m_view.tileDarkBg.alpha = 0.08;
		this.m_view.tileBg.alpha = 0;
		addChild(this.m_view);
	}

	override public function onSetData(_arg_1:Object):void {
		this.setupTextField(_arg_1.title);
		MenuUtils.setTintColor(this.m_view.tileSelect, MenuUtils.TINT_COLOR_MAGENTA_DARK, false);
		if (getNodeProp(this, "pressable") == false) {
			MenuUtils.setTintColor(this.m_view.tileSelect, MenuUtils.TINT_COLOR_GREY, false);
			MenuUtils.setTintColor(this.m_view.tileSelectPulsate, MenuUtils.TINT_COLOR_GREY, false);
		}

		if (getNodeProp(this, "selectable") == false) {
			MenuUtils.setTintColor(this.m_view.tileDarkBg, MenuUtils.TINT_COLOR_GREY, false);
			this.changeTextColor(this.m_view.title, MenuConstants.COLOR_GREY_DARK);
		}

	}

	override public function getView():Sprite {
		return (this.m_view.tileBg);
	}

	private function setupTextField(_arg_1:String):void {
		this.m_textObj.title = _arg_1;
		MenuUtils.setupText(this.m_view.title, _arg_1, 28, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		if (m_isSelected) {
			this.changeTextColor(this.m_view.title, MenuConstants.COLOR_WHITE);
		}

		MenuUtils.truncateTextfield(this.m_view.title, 1);
		CommonUtils.changeFontToGlobalIfNeeded(this.m_view.title);
		this.callTextTicker(true);
	}

	private function callTextTicker(_arg_1:Boolean):void {
		if (!this.m_textTicker) {
			this.m_textTicker = new textTicker();
		}

		if (_arg_1) {
			this.m_textTicker.startTextTicker(this.m_view.title, this.m_textObj.title, CommonUtils.changeFontToGlobalIfNeeded);
		} else {
			this.m_textTicker.stopTextTicker(this.m_view.title, this.m_textObj.title);
			MenuUtils.truncateTextfield(this.m_view.title, 1);
		}

	}

	private function changeTextColor(_arg_1:TextField, _arg_2:uint):void {
		_arg_1.textColor = _arg_2;
		if (!this.m_textTicker) {
			this.m_textTicker = new textTicker();
		}

		this.m_textTicker.setTextColor(_arg_2);
	}

	override public function addChild2(_arg_1:Sprite, _arg_2:int = -1):void {
		super.addChild2(_arg_1, _arg_2);
		if (getNodeProp(_arg_1, "col") === undefined) {
			if (((!(this.getData().direction == "horizontal")) && (!(this.getData().direction == "horizontalWrap")))) {
				_arg_1.x = 32;
			}

		}

	}

	override protected function handleSelectionChange():void {
		Animate.kill(this.m_view.tileSelect);
		MenuUtils.pulsate(this.m_view.tileSelectPulsate, false);
		Animate.kill(this.m_view.tileSelected);
		if (m_loading) {
			return;
		}

		if (m_isSelected) {
			Animate.legacyTo(this.m_view.tileSelect, MenuConstants.HiliteTime, {"alpha": 1}, Animate.Linear);
			this.m_view.tileSelected.alpha = 0;
			Animate.legacyTo(this.m_view.tileSelected, MenuConstants.HiliteTime, {"alpha": 1}, Animate.ExpoOut);
			this.changeTextColor(this.m_view.title, MenuConstants.COLOR_WHITE);
			this.callTextTicker(true);
		} else {
			this.m_view.tileSelect.alpha = 0;
			Animate.legacyTo(this.m_view.tileSelected, MenuConstants.HiliteTime, {"alpha": 0}, Animate.ExpoOut);
			this.callTextTicker(false);
			this.changeTextColor(this.m_view.title, MenuConstants.COLOR_WHITE);
		}

	}

	private function setItemTint(_arg_1:Object, _arg_2:int, _arg_3:Boolean = true):void {
		var _local_4:Number;
		if (!_arg_3) {
			_local_4 = _arg_1.alpha;
		}

		var _local_5:Color = new Color();
		_local_5.setTint(MenuConstants.COLOR_GREY_ULTRA_LIGHT, 1);
		DisplayObject(_arg_1).transform.colorTransform = _local_5;
		if (!_arg_3) {
			_arg_1.alpha = _local_4;
		}

	}

	override public function onUnregister():void {
		super.onUnregister();
		if (this.m_view) {
			Animate.kill(this.m_view.tileSelect);
			MenuUtils.pulsate(this.m_view.tileSelectPulsate, false);
			Animate.kill(this.m_view.tileSelected);
			if (this.m_textTicker) {
				this.m_textTicker.stopTextTicker(this.m_view.title, this.m_textObj.title);
				this.m_textTicker = null;
			}

			removeChild(this.m_view);
			this.m_view = null;
		}

	}


}
}//package menu3.basic

