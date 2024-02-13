// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.HUDActionPrompts

package hud {
import common.BaseControl;


import flash.display.MovieClip;

import basic.ButtonPromptImage;

import flash.text.TextFieldAutoSize;

import common.menu.MenuConstants;
import common.menu.MenuUtils;

import flash.text.TextFormat;

import mx.utils.StringUtil;


public class HUDActionPrompts extends BaseControl {

	private const INVISIBLE_ICON_INDEX:int = 0xFFFF;
	private const IDX_FIRST_EXTRA_PROMPT:int = 4;
	private const MAX_PROMPTS:int = 7;

	private var m_view:HUDActionPromptsView;
	private var m_buttonClips:Vector.<MovieClip> = new Vector.<MovieClip>();
	private var m_buttonFontSize:Vector.<int> = new Vector.<int>();

	public function HUDActionPrompts() {
		var _local_1:ButtonPromptImage;
		var _local_4:MovieClip;
		var _local_5:Boolean;
		var _local_6:String;
		var _local_7:int;
		var _local_8:Object;
		super();
		this.m_view = new HUDActionPromptsView();
		addChild(this.m_view);
		var _local_2:String = ControlsMain.getControllerType();
		var _local_3:int;
		while (_local_3 < this.MAX_PROMPTS) {
			_local_4 = this.getButtonClip(_local_3);
			_local_1 = new ButtonPromptImage();
			_local_4.prompt = _local_4.promptHolder_mc.addChild(_local_1);
			_local_4.prompt.platform = _local_2;
			if (_local_3 <= 3) {
				_local_4.prompt.button = _local_3;
			}

			_local_4.visible = false;
			_local_5 = (_local_3 == 3);
			_local_4.prompt_mc.label_txt.width = 500;
			_local_4.prompt_mc.desc_txt.width = 500;
			_local_6 = ((_local_5) ? TextFieldAutoSize.RIGHT : TextFieldAutoSize.LEFT);
			_local_4.prompt_mc.label_txt.autoSize = _local_6;
			_local_4.prompt_mc.desc_txt.autoSize = _local_6;
			this.m_buttonClips.push(_local_4);
			_local_7 = MenuConstants.INTERACTIONPROMPTSIZE_DEFAULT;
			this.m_buttonFontSize.push(_local_7);
			_local_8 = MenuConstants.InteractionIndicatorFontSpecs[_local_7];
			MenuUtils.setupText(_local_4.prompt_mc.label_txt, "", _local_8.fontSizeLabel, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
			MenuUtils.setupText(_local_4.prompt_mc.desc_txt, "", _local_8.fontSizeDesc, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
			_local_3++;
		}

	}

	private function setupFontSize(_arg_1:int, _arg_2:int):void {
		if (this.m_buttonFontSize[_arg_1] == _arg_2) {
			return;
		}

		this.m_buttonFontSize[_arg_1] = _arg_2;
		var _local_3:MovieClip = this.m_buttonClips[_arg_1];
		var _local_4:Object = MenuConstants.InteractionIndicatorFontSpecs[_arg_2];
		var _local_5:TextFormat = new TextFormat();
		_local_5.size = _local_4.fontSizeLabel;
		_local_3.prompt_mc.label_txt.defaultTextFormat = _local_5;
		var _local_6:TextFormat = new TextFormat();
		_local_6.size = _local_4.fontSizeDesc;
		_local_3.prompt_mc.desc_txt.defaultTextFormat = _local_6;
	}

	public function set ShowExtraButtonsBelow(_arg_1:Boolean):void {
		var _local_4:Number;
		var _local_2:Number = this.m_buttonClips[1].y;
		var _local_3:int = this.IDX_FIRST_EXTRA_PROMPT;
		while (_local_3 < this.MAX_PROMPTS) {
			_local_4 = Math.abs((this.m_buttonClips[_local_3].y - _local_2));
			this.m_buttonClips[_local_3].y = (_local_2 + (_local_4 * ((_arg_1) ? 1 : -1)));
			_local_3++;
		}

	}

	public function onSetData(_arg_1:Object):void {
		var _local_7:MovieClip;
		var _local_8:Object;
		var _local_9:int;
		var _local_10:Boolean;
		var _local_2:String;
		var _local_3:Number = ((ControlsMain.getDisplaySize() == ControlsMain.DISPLAY_SIZE_SMALL) ? 1.25 : 1);
		var _local_4:Object;
		var _local_5:Array = (_arg_1 as Array);
		var _local_6:int;
		_local_6 = 0;
		while (((_local_6 < _local_5.length) && (_local_6 < this.MAX_PROMPTS))) {
			_local_7 = this.m_buttonClips[_local_6];
			_local_8 = _local_5[_local_6];
			_local_7.visible = _local_8.m_bActive;
			_local_7.scaleX = _local_3;
			_local_7.scaleY = _local_3;
			if (_local_8.m_bActive) {
				_local_9 = ((_local_8.m_nFontSize) ? _local_8.m_nFontSize : MenuConstants.INTERACTIONPROMPTSIZE_DEFAULT);
				_local_4 = MenuConstants.InteractionIndicatorFontSpecs[_local_9];
				_local_7.scaleX = (_local_7.scaleX * _local_4.fScaleIndividual);
				_local_7.scaleY = (_local_7.scaleY * _local_4.fScaleIndividual);
				this.setupFontSize(_local_6, _local_9);
				if (_local_2 == null) {
					_local_2 = ControlsMain.getControllerType();
				}

				_local_10 = (_local_6 == 3);
				this.showActionButton(_local_7, _local_8, _local_10, _local_2);
			}

			_local_6++;
		}

		if (_local_4 != null) {
			this.m_view.scaleX = _local_4.fScaleGroup;
			this.m_view.scaleY = _local_4.fScaleGroup;
		}

	}

	private function showActionButton(_arg_1:MovieClip, _arg_2:Object, _arg_3:Boolean, _arg_4:String):void {
		var _local_17:Number;
		var _local_18:int;
		var _local_19:int;
		var _local_5:int = _arg_2.m_nIconId;
		var _local_6:String = _arg_2.m_sLabel;
		var _local_7:String = _arg_2.m_sDescription;
		var _local_8:Boolean = _arg_2.m_bIllegalItem;
		var _local_9:Boolean = _arg_2.m_bSuspiciousItem;
		var _local_10:Number = _arg_2.m_fProgress;
		var _local_11:Boolean = _arg_2.m_bNoActionAvailable;
		var _local_12:Number = _arg_2.m_eTypeId;
		var _local_13:String = _arg_2.m_sGlyph;
		var _local_14:Boolean = _arg_2.m_bDropTempHolsterableItems;
		if (_arg_2.m_bShowWarning) {
			_local_8 = true;
		}

		if (_local_5 == this.INVISIBLE_ICON_INDEX) {
			_arg_1.visible = false;
			return;
		}

		var _local_15:Object = MenuConstants.InteractionIndicatorFontSpecs[((_arg_2.m_nFontSize) ? _arg_2.m_nFontSize : MenuConstants.INTERACTIONPROMPTSIZE_DEFAULT)];
		var _local_16:int = (((_local_8) || (_local_9)) ? 81 : 1);
		if (((_local_8) || (_local_9))) {
			_local_17 = 0.46;
			_local_18 = 58;
			_local_19 = ((_arg_1.hold_mc.visible) ? 39 : 35);
			if (_arg_2.m_nFontSize == MenuConstants.INTERACTIONPROMPTSIZE_MEDIUM) {
				_local_17 = 0.52;
				_local_18 = 60;
				_local_19 = ((_arg_1.hold_mc.visible) ? 40 : 36);
			} else {
				if (_arg_2.m_nFontSize >= MenuConstants.INTERACTIONPROMPTSIZE_LARGE) {
					_local_17 = 0.65;
					_local_18 = 67;
					_local_19 = ((_arg_1.hold_mc.visible) ? 44 : 40);
				}

			}

			_arg_1.illegalIcon_mc.x = ((_arg_3) ? -(_local_19) : _local_19);
			_arg_1.illegalIcon_mc.scaleX = (_arg_1.illegalIcon_mc.scaleY = _local_17);
			_arg_1.prompt_mc.x = ((_arg_3) ? -(_local_18) : _local_18);
		} else {
			_arg_1.prompt_mc.x = ((_arg_3) ? -28 : 28);
		}

		_arg_1.prompt.alpha = ((_local_11) ? 0.33 : 1);
		_arg_1.prompt_mc.label_txt.htmlText = _local_6.toUpperCase();
		_local_7 = StringUtil.trim(_local_7);
		if (((_local_7) && (_local_7.length > 0))) {
			_arg_1.prompt_mc.desc_txt.visible = true;
			_arg_1.prompt_mc.desc_txt.htmlText = _local_7.toUpperCase();
			_arg_1.prompt_mc.label_txt.y = _local_15.yOffsetLabel;
			_arg_1.prompt_mc.desc_txt.y = _local_15.yOffsetDesc;
		} else {
			_arg_1.prompt_mc.desc_txt.visible = false;
			_arg_1.prompt_mc.desc_txt.text = "";
			_arg_1.prompt_mc.label_txt.y = _local_15.yOffsetLabelSolo;
		}

		if (_local_9) {
			_arg_1.illegalIcon_mc.visible = true;
			_arg_1.illegalIcon_mc.gotoAndStop("susarmed");
		} else {
			if (_local_8) {
				_arg_1.illegalIcon_mc.visible = true;
				_arg_1.illegalIcon_mc.gotoAndStop("visarmed");
			} else {
				_arg_1.illegalIcon_mc.visible = false;
			}

		}

		_arg_1.prompt.scaleX = (_arg_1.prompt.scaleY = ((_arg_4 == "key") ? 0.8 : 1));
		if (_local_5 == -1) {
			_arg_1.prompt.customKey = _local_13;
		} else {
			_arg_1.prompt.platform = _arg_4;
			_arg_1.prompt.button = _local_5;
		}

		if (((_local_12 == 2) || (_local_12 == 3))) {
			if (_local_10 > 0) {
				_arg_1.hold_mc.gotoAndStop((Math.ceil((_local_10 * 60)) + _local_16));
			} else {
				_arg_1.hold_mc.gotoAndStop(_local_16);
			}

			_arg_1.hold_mc.visible = true;
			_arg_1.tap_mc.visible = false;
		} else {
			if (_local_12 == 4) {
				_arg_1.tap_mc.visible = true;
				_arg_1.tap_mc.play();
			} else {
				_arg_1.tap_mc.visible = false;
				_arg_1.hold_mc.visible = false;
			}

		}

		if (_arg_1.hold_mc.visible) {
			_arg_1.prompt_mc.label_txt.x = ((_arg_3) ? (1 - _arg_1.prompt_mc.label_txt.textWidth) : -3);
			_arg_1.prompt_mc.desc_txt.x = ((_arg_3) ? (1 - _arg_1.prompt_mc.desc_txt.textWidth) : -3);
		} else {
			_arg_1.prompt_mc.label_txt.x = ((_arg_3) ? (5 - _arg_1.prompt_mc.label_txt.textWidth) : -7);
			_arg_1.prompt_mc.desc_txt.x = ((_arg_3) ? (5 - _arg_1.prompt_mc.desc_txt.textWidth) : -7);
		}

	}

	private function getButtonClip(_arg_1:int):MovieClip {
		return (this.m_view.getChildByName((("button0" + String((_arg_1 + 1))) + "_button_mc")) as MovieClip);
	}


}
}//package hud

