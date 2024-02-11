// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.HeadlineElement

package menu3.basic {
import menu3.MenuElementBase;

import flash.display.Sprite;

import common.menu.MenuUtils;

import basic.DottedLine;

import common.menu.MenuConstants;
import common.Localization;
import common.CommonUtils;

import mx.utils.StringUtil;

public dynamic class HeadlineElement extends MenuElementBase {

	private var m_view:HeadlineElementView;
	private var m_isPopupModeActive:Boolean = false;
	private var m_fontColor:String;
	private var m_dottedLineContainer:Sprite;
	private var m_textTickerUtil:TextTickerUtil = new TextTickerUtil();

	public function HeadlineElement(_arg_1:Object) {
		super(_arg_1);
		this.m_view = new HeadlineElementView();
		MenuUtils.addDropShadowFilter(this.m_view.typeIcon);
		MenuUtils.addDropShadowFilter(this.m_view.headerlarge);
		MenuUtils.addDropShadowFilter(this.m_view.titlelarge);
		MenuUtils.addDropShadowFilter(this.m_view.creatorname);
		MenuUtils.addDropShadowFilter(this.m_view.header);
		MenuUtils.addDropShadowFilter(this.m_view.title);
		MenuUtils.addDropShadowFilter(this.m_view.titlemultiline);
		this.m_view.typeIcon.visible = false;
		addChild(this.m_view);
	}

	protected function getRootView():HeadlineElementView {
		return (this.m_view);
	}

	override public function onSetData(_arg_1:Object):void {
		var _local_5:DottedLine;
		var _local_6:String;
		this.m_isPopupModeActive = (!(_arg_1.popupMode === false));
		this.m_fontColor = ((this.m_isPopupModeActive) ? MenuConstants.FontColorWhite : MenuConstants.FontColorGreyDark);
		if (_arg_1.useDottedLine === true) {
			this.m_dottedLineContainer = new Sprite();
			this.m_dottedLineContainer.x = 0;
			this.m_dottedLineContainer.y = -15;
			_local_5 = new DottedLine((MenuConstants.GridUnitWidth * 10), MenuConstants.COLOR_WHITE, DottedLine.TYPE_HORIZONTAL, 1, 2);
			this.m_dottedLineContainer.addChild(_local_5);
			this.m_view.addChild(this.m_dottedLineContainer);
		}
		;
		var _local_2:String = this.getHeaderString(_arg_1);
		var _local_3:String = this.getTitleString(_arg_1);
		if (_arg_1.largetitle) {
			this.setupLargeTextField(_local_2, _local_3);
		} else {
			_local_6 = _arg_1.typeicon;
			if (_local_6 == null) {
				_local_6 = _arg_1.icon;
			}
			;
			if (_local_6 != null) {
				this.m_view.typeIcon.visible = true;
				MenuUtils.setupIcon(this.m_view.typeIcon, _local_6, MenuConstants.COLOR_GREY_ULTRA_DARK, false, true, MenuConstants.COLOR_WHITE, 1, 0, true);
			}
			;
			this.setupTextFields(_local_2, _local_3, _arg_1.multilinetitle);
		}
		;
		var _local_4:* = "";
		if (_arg_1.creatorname) {
			_local_4 = _arg_1.creatorname;
		}
		;
		if (_arg_1.publicid) {
			_local_4 = (_local_4 + (((" " + Localization.get("UI_DIALOG_SLASH")) + " ") + _arg_1.publicid));
		}
		;
		if (_local_4 != "") {
			MenuUtils.setupText(this.m_view.creatorname, ((Localization.get("UI_AUTHOR_BY") + " ") + _local_4), 24, MenuConstants.FONT_TYPE_MEDIUM, this.m_fontColor);
			MenuUtils.truncateTextfield(this.m_view.creatorname, 1, MenuConstants.FontColorGreyDark);
			CommonUtils.changeFontToGlobalIfNeeded(this.m_view.creatorname);
		}
		;
	}

	private function getHeaderString(_arg_1:Object):String {
		var _local_4:String;
		var _local_5:int;
		var _local_6:int;
		var _local_7:String;
		var _local_2:* = "";
		var _local_3:Array = (_arg_1.header as Array);
		if (((!(_local_3 == null)) && (_local_3.length > 0))) {
			_local_4 = Localization.get("UI_TEXT_PERIOD");
			_local_5 = _local_3.length;
			_local_6 = 0;
			while (_local_6 < _local_5) {
				_local_7 = (_local_3[_local_6] as String);
				if (_local_7 != null) {
					_local_7 = StringUtil.trim(_local_7);
					if (_local_7.length != 0) {
						if (_local_4.length > 0) {
							if (_local_7.charAt((_local_7.length - 1)) != _local_4.charAt(0)) {
								_local_7 = (_local_7 + _local_4);
							}
							;
						}
						;
						if (_local_2.length > 0) {
							_local_2 = (_local_2 + " ");
						}
						;
						_local_2 = (_local_2 + _local_7);
					}
					;
				}
				;
				_local_6++;
			}
			;
		}
		;
		if (_local_2.length == 0) {
			_local_2 = _arg_1.header;
		}
		;
		return (_local_2);
	}

	private function getTitleString(_arg_1:Object):String {
		if (_arg_1.title != undefined) {
			return (_arg_1.title);
		}
		;
		if (_arg_1.player != undefined) {
			if (_arg_1.player2 != undefined) {
				return ((_arg_1.player + MenuConstants.PLAYER_MULTIPLAYER_DELIMITER) + _arg_1.player2);
			}
			;
			return (_arg_1.player);
		}
		;
		return ("");
	}

	private function setupLargeTextField(_arg_1:String = "", _arg_2:String = ""):void {
		this.m_view.creatorname.x = -2;
		this.m_view.headerlarge.visible = true;
		this.m_view.titlelarge.visible = true;
		MenuUtils.setupTextUpper(this.m_view.headerlarge, _arg_1, 24, MenuConstants.FONT_TYPE_MEDIUM, this.m_fontColor);
		MenuUtils.setupTextUpper(this.m_view.titlelarge, _arg_2, 54, MenuConstants.FONT_TYPE_BOLD, this.m_fontColor);
		this.m_textTickerUtil.addTextTickerHtml(this.m_view.headerlarge);
		this.m_textTickerUtil.addTextTickerHtml(this.m_view.titlelarge);
		MenuUtils.truncateTextfield(this.m_view.headerlarge, 1, null, CommonUtils.changeFontToGlobalIfNeeded(this.m_view.headerlarge));
		MenuUtils.truncateTextfield(this.m_view.titlelarge, 1, null, CommonUtils.changeFontToGlobalIfNeeded(this.m_view.titlelarge));
		this.m_textTickerUtil.callTextTicker(true);
	}

	private function setupTextFields(_arg_1:String, _arg_2:String, _arg_3:Boolean):void {
		this.m_view.creatorname.x = 92;
		if (_arg_1 == null) {
			_arg_1 = "";
		}
		;
		if (_arg_2 == null) {
			_arg_2 = "";
		}
		;
		if (_arg_3) {
			this.m_view.titlemultiline.visible = true;
			this.m_view.header.visible = false;
			this.m_view.title.visible = false;
			MenuUtils.setupTextUpper(this.m_view.titlemultiline, _arg_2, 36, MenuConstants.FONT_TYPE_MEDIUM, this.m_fontColor);
			CommonUtils.changeFontToGlobalIfNeeded(this.m_view.titlemultiline);
			this.m_view.header.visible = (this.m_view.titlemultiline.numLines == 1);
			MenuUtils.truncateHTMLField(this.m_view.titlemultiline, this.m_view.titlemultiline.htmlText);
		} else {
			this.m_view.titlemultiline.visible = false;
			this.m_view.header.visible = true;
			this.m_view.title.visible = true;
			MenuUtils.setupTextUpper(this.m_view.header, _arg_1, 24, MenuConstants.FONT_TYPE_MEDIUM, this.m_fontColor);
			MenuUtils.setupTextUpper(this.m_view.title, _arg_2, 54, MenuConstants.FONT_TYPE_BOLD, this.m_fontColor);
			CommonUtils.changeFontToGlobalIfNeeded(this.m_view.header);
			CommonUtils.changeFontToGlobalIfNeeded(this.m_view.title);
			this.m_textTickerUtil.addTextTickerHtml(this.m_view.header);
			this.m_textTickerUtil.addTextTickerHtml(this.m_view.title);
			MenuUtils.truncateTextfield(this.m_view.header, 1, null);
			MenuUtils.truncateTextfield(this.m_view.title, 1, null);
			this.m_textTickerUtil.callTextTicker(true);
		}
		;
	}

	override public function onUnregister():void {
		if (this.m_view == null) {
			return;
		}
		;
		this.m_textTickerUtil.onUnregister();
		this.m_textTickerUtil = null;
		removeChild(this.m_view);
		this.m_view = null;
	}


}
}//package menu3.basic

