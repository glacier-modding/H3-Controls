// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//basic.Subtitle

package basic {
import common.BaseControl;

import flash.text.TextField;
import flash.display.MovieClip;

import common.CommonUtils;

import mx.utils.StringUtil;

import flash.text.TextFieldAutoSize;

import common.menu.MenuUtils;
import common.Animate;

import flash.text.*;

public class Subtitle extends BaseControl {

	public static const MIN_FONT_SIZE:int = 22;
	public static const MAX_FONT_SIZE:int = 46;
	public static const LOCKBIT_None:int = 0;
	public static const LOCKBIT_Left:int = 1;
	public static const LOCKBIT_Top:int = 2;
	public static const LOCKBIT_Right:int = 4;
	public static const LOCKBIT_Bot:int = 8;

	private var m_view:SubTitleView;
	private var m_sub_txt:TextField;
	private var m_characterName_txt:TextField;
	private var m_textFieldSetWidth:Number;
	private var m_icon2DSpeaker_mc:MovieClip;
	private var m_arrowL_mc:MovieClip;
	private var m_arrowR_mc:MovieClip;
	private var m_fontSize:Number = 22;
	private var m_fBGAlpha:Number = 0;
	private var m_alignToBottom:Boolean = true;
	private var m_fCinematicMode:Number = 1;
	private var m_isAntiFreakoutDisabled:Boolean = true;

	public function Subtitle() {
		this.m_view = new SubTitleView();
		addChild(this.m_view);
		this.m_characterName_txt = this.m_view.characterName_txt;
		this.m_sub_txt = this.m_view.sub_txt;
		this.m_textFieldSetWidth = this.m_sub_txt.width;
		this.m_fontSize = CommonUtils.getUIOptionValueNumber("UI_OPTION_GRAPHICS_SUBTITLES_SIZE");
		this.m_fBGAlpha = (CommonUtils.getUIOptionValueNumber("UI_OPTION_GRAPHICS_SUBTITLES_BGALPHA") / 100);
		this.m_icon2DSpeaker_mc = this.m_view.icon2DSpeaker_mc;
		this.m_arrowL_mc = this.m_view.arrowL_mc;
		this.m_arrowR_mc = this.m_view.arrowR_mc;
		if (ControlsMain.isVrModeActive()) {
			this.m_arrowL_mc.filters = [];
			this.m_arrowR_mc.filters = [];
			this.m_icon2DSpeaker_mc.filters = [];
		}
		;
		this.updateViewportLockBits(LOCKBIT_None);
		this.m_characterName_txt.alpha = 1;
		this.m_icon2DSpeaker_mc.alpha = 0;
		this.m_arrowL_mc.alpha = 0;
		this.m_arrowR_mc.alpha = 0;
	}

	private static function easeInOut(_arg_1:Number):Number {
		var _local_2:Number;
		if (_arg_1 < 0.5) {
			return ((2 * _arg_1) * _arg_1);
		}
		;
		_local_2 = ((2 * _arg_1) - 2);
		return (1 - ((0.5 * _local_2) * _local_2));
	}


	public function set isAntiFreakoutDisabled(_arg_1:Boolean):void {
		this.m_isAntiFreakoutDisabled = _arg_1;
	}

	public function setCinematicMode(_arg_1:Number):void {
		this.m_fCinematicMode = _arg_1;
		this.m_characterName_txt.alpha = easeInOut(Math.max(0, ((2 * _arg_1) - 1)));
		this.m_icon2DSpeaker_mc.alpha = (this.m_arrowL_mc.alpha = (this.m_arrowR_mc.alpha = easeInOut(Math.max(0, (1 - (2 * _arg_1))))));
		this.updateSpeakerIndicatorLayout();
		this.updateDarkBack();
	}

	public function getTextFieldWidth():Number {
		return (this.m_textFieldSetWidth);
	}

	override public function onSetSize(_arg_1:Number, _arg_2:Number):void {
		this.m_sub_txt.width = _arg_1;
		this.m_textFieldSetWidth = _arg_1;
		this.m_sub_txt.height = _arg_2;
		this.updateSpeakerIndicatorLayout();
		this.updateDarkBack();
	}

	public function onSetData(_arg_1:Object):void {
		var _local_2:String;
		var _local_3:String;
		if (("text" in _arg_1)) {
			_local_2 = _arg_1.text;
		} else {
			_local_2 = (_arg_1 as String);
		}
		;
		if (("fontsize" in _arg_1)) {
			this.m_fontSize = _arg_1.fontsize;
		}
		;
		if (("pctBGAlpha" in _arg_1)) {
			this.m_fBGAlpha = (_arg_1.pctBGAlpha / 100);
		}
		;
		if (("align" in _arg_1)) {
			this.m_alignToBottom = (_arg_1.align == "bottom");
		} else {
			this.m_alignToBottom = true;
		}
		;
		this.m_fontSize = Math.max(this.m_fontSize, MIN_FONT_SIZE);
		this.m_fontSize = Math.min(this.m_fontSize, MAX_FONT_SIZE);
		if (("characterName" in _arg_1)) {
			_local_3 = _arg_1.characterName;
		}
		;
		_local_3 = ((_local_3 == null) ? "" : StringUtil.trim(_local_3.replace(/_+/g, " ")));
		if (_local_3 == "") {
			this.m_characterName_txt.visible = false;
		} else {
			this.m_characterName_txt.visible = true;
			_local_2 = _local_2.replace(/^[-‒–—―⸺⸻] */, "");
		}
		;
		if (_local_2 == "") {
			this.m_view.visible = false;
		} else {
			this.m_sub_txt.autoSize = TextFieldAutoSize.CENTER;
			this.m_sub_txt.width = this.m_textFieldSetWidth;
			MenuUtils.setupText(this.m_sub_txt, _local_2, this.m_fontSize);
			if (this.m_characterName_txt.visible) {
				this.m_characterName_txt.autoSize = TextFieldAutoSize.LEFT;
				MenuUtils.setupText(this.m_characterName_txt, (_local_3 + ":"), this.m_fontSize, "$medium", "#ebeb92");
			}
			;
			if (((!(_arg_1.icon2DSpeaker is String)) || (_arg_1.icon2DSpeaker == ""))) {
				this.m_icon2DSpeaker_mc.visible = false;
			} else {
				this.m_icon2DSpeaker_mc.visible = true;
				this.m_icon2DSpeaker_mc.gotoAndStop(_arg_1.icon2DSpeaker);
			}
			;
			this.m_view.visible = true;
			this.updateSpeakerIndicatorLayout();
			this.updateDarkBack();
			if (!this.m_isAntiFreakoutDisabled) {
				this.m_view.alpha = 0;
				Animate.to(this.m_view, 0, 0.05, {"alpha": 1}, Animate.Linear);
			}
			;
		}
		;
		if (this.m_alignToBottom) {
			this.m_view.y = -(this.m_sub_txt.textHeight);
		} else {
			this.m_view.y = 0;
		}
		;
	}

	public function updateViewportLockBits(_arg_1:int):void {
		this.m_arrowL_mc.visible = (!((_arg_1 & LOCKBIT_Left) == 0));
		this.m_arrowR_mc.visible = (!((_arg_1 & LOCKBIT_Right) == 0));
		this.updateDarkBack();
	}

	private function updateSpeakerIndicatorLayout():void {
		var _local_3:Number;
		var _local_8:Number;
		var _local_1:Number = (this.m_fontSize * 0.75);
		var _local_2:Number = 0;
		if (this.m_characterName_txt.visible) {
			_local_2 = (this.m_characterName_txt.textWidth + _local_1);
		}
		;
		this.m_sub_txt.x = ((_local_2 / 2) * (1 - this.m_icon2DSpeaker_mc.alpha));
		_local_3 = (this.m_sub_txt.x + (this.m_sub_txt.width / 2));
		var _local_4:Number = (this.m_sub_txt.y + (this.m_sub_txt.height / 2));
		var _local_5:Number = (_local_3 - (this.m_sub_txt.textWidth / 2));
		var _local_6:Number = (_local_3 + (this.m_sub_txt.textWidth / 2));
		var _local_7:Number = (this.m_fontSize / MIN_FONT_SIZE);
		this.m_arrowL_mc.x = _local_5;
		this.m_arrowL_mc.y = _local_4;
		this.m_arrowL_mc.scaleX = _local_7;
		this.m_arrowL_mc.scaleY = _local_7;
		this.m_arrowR_mc.x = _local_6;
		this.m_arrowR_mc.y = _local_4;
		this.m_arrowR_mc.scaleX = _local_7;
		this.m_arrowR_mc.scaleY = _local_7;
		if (this.m_icon2DSpeaker_mc.visible) {
			this.m_icon2DSpeaker_mc.scaleX = _local_7;
			this.m_icon2DSpeaker_mc.scaleY = _local_7;
			_local_8 = (35 * _local_7);
			this.m_icon2DSpeaker_mc.x = ((_local_5 - _local_8) - this.m_sub_txt.x);
			this.m_icon2DSpeaker_mc.y = _local_4;
		}
		;
		if (this.m_characterName_txt.visible) {
			this.m_characterName_txt.x = ((_local_3 - (this.m_sub_txt.getLineMetrics(0).width / 2)) - _local_2);
			this.m_characterName_txt.y = this.m_sub_txt.y;
		}
		;
	}

	private function updateDarkBack():void {
		var _local_10:Number;
		if (this.m_view == null) {
			return;
		}
		;
		if (this.m_fBGAlpha == 0) {
			this.m_view.box_mc.visible = false;
			return;
		}
		;
		var _local_1:Number = 50;
		var _local_2:Number = 15;
		var _local_3:Number = 45;
		var _local_4:Number = 50;
		var _local_5:Number = (this.m_fontSize * 0.75);
		var _local_6:Number = (this.m_fCinematicMode * ((this.m_characterName_txt.visible) ? (this.m_characterName_txt.textWidth + _local_5) : 0));
		var _local_7:Number = ((this.m_fCinematicMode == 1) ? 0 : ((this.m_icon2DSpeaker_mc.visible) ? (_local_3 * this.m_icon2DSpeaker_mc.scaleX) : 0));
		var _local_8:Number = (this.m_arrowL_mc.alpha * ((this.m_arrowL_mc.visible) ? (_local_4 * this.m_arrowL_mc.scaleX) : 0));
		var _local_9:Number = (this.m_arrowR_mc.alpha * ((this.m_arrowR_mc.visible) ? (_local_4 * this.m_arrowR_mc.scaleX) : 0));
		_local_10 = (this.m_sub_txt.x + (this.m_sub_txt.width / 2));
		var _local_11:Number = (_local_10 - (this.m_sub_txt.textWidth / 2));
		this.m_view.box_mc.visible = true;
		this.m_view.box_mc.alpha = this.m_fBGAlpha;
		this.m_view.box_mc.width = ((((this.m_sub_txt.textWidth + Math.max(_local_6, _local_7)) + _local_8) + _local_9) + _local_1);
		this.m_view.box_mc.height = (this.m_sub_txt.textHeight + _local_2);
		this.m_view.box_mc.x = (((_local_11 - Math.max(_local_6, _local_7)) - _local_8) - (_local_1 / 2));
		this.m_view.box_mc.y = (-(_local_2 - 5) / 2);
	}


}
}//package basic

