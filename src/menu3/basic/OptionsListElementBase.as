// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.OptionsListElementBase

package menu3.basic {
import menu3.containers.CollapsableListContainer;

import flash.geom.Rectangle;

import common.Localization;
import common.menu.MenuConstants;
import common.menu.MenuUtils;
import common.CommonUtils;

import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.display.Sprite;
import flash.geom.Point;
import flash.events.MouseEvent;

public dynamic class OptionsListElementBase extends CollapsableListContainer {

	private const OPTION_NONE:int = 0;
	private const OPTION_TOGGLE:int = 1;
	private const OPTION_SLIDER:int = 2;
	protected const STATE_DEFAULT:int = 0;
	protected const STATE_SELECTED:int = 1;
	protected const STATE_GROUP_SELECTED:int = 2;
	protected const STATE_HOVER:int = 3;

	private var m_view:*;
	private var m_textTickerUtilTitle:TextTickerUtil = new TextTickerUtil();
	private var m_textTickerUtilValue:TextTickerUtil = new TextTickerUtil();
	private var m_optionType:int = 0;
	private var m_titleWidthNoOptions:Number = 440;
	private var m_valueWidthNoOptions:Number = 205;
	private var m_titleWidthSliderOption:Number = 356;
	private var m_valueWidthSliderOption:Number = 94;
	private var m_titleWidthToggleOption:Number = 511;
	private var m_valueWidthToggleOption:Number = 94;
	private var m_titleWidthMAX:Number;
	private var m_edgePadding:Number = 21;
	private var m_hasSlider:Boolean = false;
	private var m_sliderDragActive:Boolean = false;
	private var m_sliderRange:Rectangle;
	private var m_sliderClickRange:Rectangle;
	private var m_pressable:Boolean;
	private var m_selectable:Boolean;
	private var m_firstTimeOnly:Boolean;
	private var m_isTextScrollingEnabled:Boolean;
	private var m_solidStyle:Boolean = false;

	public function OptionsListElementBase(_arg_1:Object) {
		super(_arg_1);
		this.m_firstTimeOnly = true;
		this.m_view = this.createView();
		addChild(this.m_view);
	}

	protected function createView():* {
		return (null);
	}

	override public function onSetData(_arg_1:Object):void {
		var _local_3:Boolean;
		var _local_4:Boolean;
		var _local_5:Number;
		var _local_6:Rectangle;
		var _local_7:Number;
		var _local_8:Number;
		this.m_pressable = getNodeProp(this, "pressable");
		this.m_selectable = getNodeProp(this, "selectable");
		this.m_solidStyle = (_arg_1.solidstyle === true);
		if (this.m_firstTimeOnly) {
			this.m_titleWidthMAX = (this.m_view.tileDarkBg.width - (this.m_edgePadding * 2));
		}
		;
		if (_arg_1.toggle) {
			this.m_optionType = this.OPTION_TOGGLE;
			if (this.m_firstTimeOnly) {
				this.m_view.optionsIndicator.gotoAndStop("Toggle");
			}
			;
			_local_3 = ((_arg_1.oldTechUpdate != null) ? _arg_1.oldTechUpdate : false);
			_local_4 = ((_arg_1.value == true) || (_arg_1.value == 1));
			if (_arg_1.invertToggle === true) {
				_local_4 = (!(_local_4));
			}
			;
			if (_local_4) {
				if (_local_3) {
					_arg_1.displayValue = String((("[" + Localization.get("UI_AID_VALUE_ON")) + "]"));
				}
				;
				this.m_view.optionsIndicator.toggleIndicator.gotoAndStop(2);
			} else {
				if (_local_3) {
					_arg_1.displayValue = String((("[" + Localization.get("UI_AID_VALUE_OFF")) + "]"));
				}
				;
				this.m_view.optionsIndicator.toggleIndicator.gotoAndStop(1);
			}
			;
		} else {
			if (_arg_1.slider) {
				this.m_optionType = this.OPTION_SLIDER;
				this.m_hasSlider = true;
				if (this.m_firstTimeOnly) {
					this.m_view.optionsIndicator.gotoAndStop("Slider");
				}
				;
				if (((this.m_sliderRange == null) || (this.m_sliderClickRange == null))) {
					_local_6 = this.m_view.optionsIndicator.slideIndicator.getBounds(this.m_view);
					this.m_sliderRange = new Rectangle(_local_6.x, _local_6.y, MenuConstants.OptionsListElementSliderWidth, MenuConstants.OptionsListElementSliderHeight);
					this.m_sliderRange.inflate((this.m_sliderRange.height * -0.5), 0);
					this.m_sliderClickRange = this.m_sliderRange.clone();
					this.m_sliderClickRange.inflate(20, 20);
				}
				;
				_local_5 = _arg_1.value;
				if (_arg_1.sliderconfig) {
					_arg_1.propertyValue = _arg_1.displayValue;
					_local_7 = _arg_1.sliderconfig.valuerangemin;
					_local_8 = _arg_1.sliderconfig.valuerangemax;
					_local_5 = (((_arg_1.propertyValue - _local_7) / (_local_8 - _local_7)) * 100);
					_arg_1.value = _local_5;
				}
				;
				this.m_view.optionsIndicator.slideIndicator.gotoAndStop(_local_5);
				if (_arg_1.formattedValue != undefined) {
					_arg_1.displayValue = (("[" + String(_arg_1.formattedValue).toUpperCase()) + "]");
				} else {
					if (_arg_1.displayValueDecimals != undefined) {
						_arg_1.displayValue = String((("[" + MenuUtils.formatNumber(Number(_arg_1.propertyValue), true, Number(_arg_1.displayValueDecimals))) + "]"));
					} else {
						_arg_1.displayValue = String((("[" + MenuUtils.formatNumber(Number(_arg_1.propertyValue), true, 2)) + "]"));
					}
					;
				}
				;
			}
			;
		}
		;
		if (this.m_firstTimeOnly) {
			this.setupTextField(this.m_view.title, _arg_1.title);
		}
		;
		this.setupTextField(this.m_view.value, _arg_1.displayValue);
		this.setTextfieldWidths();
		this.m_isTextScrollingEnabled = ((_arg_1.force_scroll) ? true : false);
		var _local_2:int = ((m_isSelected) ? this.STATE_SELECTED : this.STATE_DEFAULT);
		this.setSelectedAnimationState(_local_2);
		if (((this.m_selectable == false) || (this.m_pressable == false))) {
			this.changeTextColor(MenuConstants.COLOR_GREY);
			if (this.m_solidStyle) {
				MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_MENU_SOLID_BACKGROUND, false);
				MenuUtils.removeDropShadowFilter(this.m_view.title);
				MenuUtils.removeDropShadowFilter(this.m_view.value);
				this.m_view.tileSelect.alpha = 1;
			} else {
				MenuUtils.addDropShadowFilter(this.m_view.title);
				MenuUtils.addDropShadowFilter(this.m_view.value);
				this.m_view.tileSelect.alpha = 0;
			}
			;
			this.m_view.optionsIndicator.alpha = 0.25;
			if (this.m_isTextScrollingEnabled) {
				this.callTextTicker(true);
			}
			;
		} else {
			this.m_view.optionsIndicator.alpha = 1;
		}
		;
		this.m_firstTimeOnly = false;
	}

	private function setupTextField(_arg_1:TextField, _arg_2:String):void {
		MenuUtils.setupTextUpper(_arg_1, _arg_2, 26, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		CommonUtils.changeFontToGlobalIfNeeded(_arg_1);
		if (_arg_1 == this.m_view.title) {
			this.m_textTickerUtilTitle.addTextTicker(this.m_view.title, this.m_view.title.htmlText);
		}
		;
		if (_arg_1 == this.m_view.value) {
			this.m_textTickerUtilValue.addTextTicker(this.m_view.value, this.m_view.value.htmlText);
		}
		;
		MenuUtils.truncateTextfield(_arg_1, 1, null, CommonUtils.changeFontToGlobalIfNeeded(_arg_1));
	}

	private function changeTextColor(_arg_1:int):void {
		this.m_view.title.textColor = _arg_1;
		this.m_view.value.textColor = _arg_1;
	}

	private function setTextfieldWidths():void {
		var _local_1:Number;
		var _local_2:Number;
		this.m_view.title.autoSize = TextFieldAutoSize.NONE;
		this.m_view.value.autoSize = TextFieldAutoSize.NONE;
		switch (this.m_optionType) {
			case this.OPTION_NONE:
				_local_1 = ((this.m_view.value.text == "") ? this.m_titleWidthMAX : this.m_titleWidthNoOptions);
				_local_2 = this.m_valueWidthNoOptions;
				break;
			case this.OPTION_TOGGLE:
				_local_1 = this.m_titleWidthToggleOption;
				_local_2 = this.m_valueWidthToggleOption;
				break;
			case this.OPTION_SLIDER:
				_local_1 = this.m_titleWidthSliderOption;
				_local_2 = this.m_valueWidthSliderOption;
				break;
			default:
				trace(((("unhandled case in " + this) + " setTextfieldWidths() : ") + this.m_optionType));
		}
		;
		this.m_view.title.width = _local_1;
		this.m_view.value.width = _local_2;
		this.m_view.value.x = ((this.m_view.tileDarkBg.width - this.m_view.value.width) - this.m_edgePadding);
	}

	private function callTextTicker(_arg_1:Boolean):void {
		this.m_textTickerUtilTitle.callTextTicker(_arg_1, this.m_view.title.textColor);
		this.m_textTickerUtilValue.callTextTicker(_arg_1, this.m_view.value.textColor);
	}

	override public function getView():Sprite {
		return (this.m_view.tileBg);
	}

	override public function addChild2(_arg_1:Sprite, _arg_2:int = -1):void {
		super.addChild2(_arg_1, _arg_2);
		if (getNodeProp(_arg_1, "col") === undefined) {
			if (((!(this.getData().direction == "horizontal")) && (!(this.getData().direction == "horizontalWrap")))) {
				_arg_1.x = 32;
			}
			;
		}
		;
	}

	public function setItemHover(_arg_1:Boolean):void {
		if (((m_isSelected) || (m_isGroupSelected))) {
			return;
		}
		;
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
			;
		}
		;
		this.setSelectedAnimationState(_local_1);
	}

	protected function setSelectedAnimationState(_arg_1:int):void {
		if (m_loading) {
			return;
		}
		;
		if (this.m_selectable == false) {
			this.callTextTicker(false);
			return;
		}
		;
		if (_arg_1 == this.STATE_SELECTED) {
			if (this.m_pressable) {
				this.changeTextColor(MenuConstants.COLOR_WHITE);
				MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_RED, true, MenuConstants.MenuElementSelectedAlpha);
			} else {
				this.changeTextColor(MenuConstants.COLOR_GREY);
				MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_MENU_TABS_BACKGROUND, true, MenuConstants.MenuElementBackgroundAlpha);
			}
			;
			MenuUtils.removeDropShadowFilter(this.m_view.title);
			MenuUtils.removeDropShadowFilter(this.m_view.value);
			this.callTextTicker(true);
		} else {
			if (_arg_1 == this.STATE_GROUP_SELECTED) {
				this.changeTextColor(MenuConstants.COLOR_GREY);
				if (this.m_solidStyle) {
					MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_MENU_SOLID_BACKGROUND, true, MenuConstants.MenuElementBackgroundAlpha);
				} else {
					MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_MENU_SOLID_BACKGROUND, true, 0);
				}
				;
				MenuUtils.removeDropShadowFilter(this.m_view.title);
				MenuUtils.removeDropShadowFilter(this.m_view.value);
				this.callTextTicker(true);
			} else {
				if (_arg_1 == this.STATE_HOVER) {
					if (this.m_pressable) {
						this.changeTextColor(MenuConstants.COLOR_WHITE);
						MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_RED, true, MenuConstants.MenuElementSelectedAlpha);
					} else {
						this.changeTextColor(MenuConstants.COLOR_GREY);
						MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_MENU_TABS_BACKGROUND, true, MenuConstants.MenuElementBackgroundAlpha);
					}
					;
					MenuUtils.removeDropShadowFilter(this.m_view.title);
					MenuUtils.removeDropShadowFilter(this.m_view.value);
					this.callTextTicker(true);
				} else {
					if (this.m_pressable) {
						this.changeTextColor(MenuConstants.COLOR_WHITE);
					} else {
						this.changeTextColor(MenuConstants.COLOR_GREY);
					}
					;
					if (this.m_solidStyle) {
						MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_MENU_SOLID_BACKGROUND, false);
						MenuUtils.removeDropShadowFilter(this.m_view.title);
						MenuUtils.removeDropShadowFilter(this.m_view.value);
						this.m_view.tileSelect.alpha = 1;
					} else {
						MenuUtils.addDropShadowFilter(this.m_view.title);
						MenuUtils.addDropShadowFilter(this.m_view.value);
						this.m_view.tileSelect.alpha = 0;
					}
					;
					this.callTextTicker(false);
				}
				;
			}
			;
		}
		;
	}

	override public function onUnregister():void {
		super.onUnregister();
		if (this.m_view) {
			this.m_textTickerUtilTitle.onUnregister();
			this.m_textTickerUtilTitle = null;
			this.m_textTickerUtilValue.onUnregister();
			this.m_textTickerUtilValue = null;
			removeChild(this.m_view);
			this.m_view = null;
		}
		;
	}

	override public function handleMouseDown(_arg_1:Function, _arg_2:MouseEvent):void {
		var _local_3:Point;
		var _local_4:Point;
		var _local_5:int;
		var _local_6:Number;
		if (((this.m_hasSlider) && (this.m_selectable))) {
			if (!m_isSelected) {
				if (this["_nodedata"]) {
					_local_5 = (this["_nodedata"]["id"] as int);
					(_arg_1("onElementClick", _local_5));
				}
				;
			}
			;
			_local_3 = new Point(_arg_2.stageX, _arg_2.stageY);
			_local_4 = this.m_view.globalToLocal(_local_3);
			if (this.m_sliderClickRange.containsPoint(_local_4)) {
				_arg_2.stopImmediatePropagation();
				_local_6 = this.calculateSliderValueFromLocalPoint(_local_4);
				this.sendDragValueToEngine(_arg_1, _local_6);
				this.setMouseDragActive(true);
				return;
			}
			;
		}
		;
		super.handleMouseDown(_arg_1, _arg_2);
	}

	public function handleMouseMove(_arg_1:MouseEvent):void {
		if (!this.m_sliderDragActive) {
			return;
		}
		;
		_arg_1.stopImmediatePropagation();
		var _local_2:Point = new Point(_arg_1.stageX, _arg_1.stageY);
		var _local_3:Point = this.m_view.globalToLocal(_local_2);
		var _local_4:Number = this.calculateSliderValueFromLocalPoint(_local_3);
		this.sendDragValueToEngine(m_sendEventWithValue, _local_4);
	}

	override public function handleMouseUp(_arg_1:Function, _arg_2:MouseEvent):void {
		super.handleMouseUp(_arg_1, _arg_2);
		_arg_2.stopImmediatePropagation();
		this.setMouseDragActive(false);
	}

	override public function handleMouseRollOut(_arg_1:Function, _arg_2:MouseEvent):void {
		var _local_3:int;
		var _local_4:Array;
		super.handleMouseRollOut(_arg_1, _arg_2);
		_arg_2.stopImmediatePropagation();
		this.setMouseDragActive(false);
		if (this.m_selectable) {
			if (this["_nodedata"]) {
				_local_3 = (this["_nodedata"]["id"] as int);
				_local_4 = new Array(_local_3, false);
				(_arg_1("onElementHover", _local_4));
			}
			;
		}
		;
	}

	override public function handleMouseOver(_arg_1:Function, _arg_2:MouseEvent):void {
		if (m_isSelected) {
			_arg_2.stopImmediatePropagation();
			return;
		}
		;
		super.handleMouseOver(_arg_1, _arg_2);
	}

	private function calculateSliderValueFromLocalPoint(_arg_1:Point):Number {
		var _local_2:Number = ((_arg_1.x - this.m_sliderRange.x) / this.m_sliderRange.width);
		_local_2 = Math.max(_local_2, 0);
		_local_2 = Math.min(_local_2, 1);
		return (_local_2 * 100);
	}

	private function setMouseDragActive(_arg_1:Boolean):void {
		if (this.m_sliderDragActive == _arg_1) {
			return;
		}
		;
		this.m_sliderDragActive = _arg_1;
		if (this.m_sliderDragActive) {
			addEventListener(MouseEvent.MOUSE_MOVE, this.handleMouseMove, false, 0, false);
		} else {
			removeEventListener(MouseEvent.MOUSE_MOVE, this.handleMouseMove, false);
		}
		;
	}

	private function sendDragValueToEngine(_arg_1:Function, _arg_2:Number):void {
		var _local_4:Array;
		var _local_3:int;
		if (this["_nodedata"]) {
			_local_3 = (this["_nodedata"]["id"] as int);
			_local_4 = new Array(_local_3, _arg_2);
			(_arg_1("onPreferenceSetValue", _local_4));
		}
		;
	}


}
}//package menu3.basic

