// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.TextLineWithIcon

package menu3.basic {
import menu3.MenuElementBase;

import flash.display.Sprite;
import flash.text.TextField;

import common.menu.MenuConstants;

import flash.text.TextFieldAutoSize;

import common.menu.MenuUtils;
import common.CommonUtils;

public dynamic class TextLineWithIcon extends MenuElementBase {

	private var m_view:Sprite = null;
	private var m_icon:iconsAll40x40View = null;
	private var m_textfield:TextField = null;
	private var m_textTickerUtil:TextTickerUtil = new TextTickerUtil();
	private var m_color:int = 0xFFFFFF;
	private var m_fontcolor:String = MenuConstants.FontColorWhite;
	private var m_iconLabel:String;
	private var m_isTextScrollingEnabled:Boolean;

	public function TextLineWithIcon(_arg_1:Object) {
		super(_arg_1);
		this.m_view = new Sprite();
		addChild(this.m_view);
		this.m_icon = new iconsAll40x40View();
		this.m_icon.x = 36.5;
		this.m_icon.y = 32.5;
		this.m_textfield = new TextField();
		this.m_textfield.autoSize = TextFieldAutoSize.LEFT;
		this.m_textfield.x = 65;
		this.m_textfield.y = 17;
		this.m_textfield.wordWrap = false;
		this.m_textfield.multiline = false;
		this.m_view.addChild(this.m_icon);
		this.m_view.addChild(this.m_textfield);
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		this.m_textfield.width = ((_arg_1.maxtextwidth != undefined) ? _arg_1.maxtextwidth : 250);
		this.m_textfield.autoSize = TextFieldAutoSize.LEFT;
		this.m_color = MenuConstants.COLOR_WHITE;
		this.m_fontcolor = MenuConstants.FontColorWhite;
		if (_arg_1.colorname != null) {
			this.m_color = MenuConstants.GetColorByName(_arg_1.colorname);
			this.m_fontcolor = MenuConstants.ColorString(this.m_color);
		}

		this.m_iconLabel = _arg_1.icon;
		MenuUtils.setupIcon(this.m_icon, this.m_iconLabel, this.m_color, true, false);
		this.setupTextField(_arg_1.title);
		this.m_textfield.wordWrap = true;
		this.m_textfield.multiline = true;
		var _local_2:int = this.m_textfield.numLines;
		this.m_textfield.multiline = false;
		this.m_textfield.wordWrap = false;
		if (_local_2 > 1) {
			this.m_textfield.autoSize = TextFieldAutoSize.NONE;
		}

		this.m_view.x = 0;
		this.m_view.y = 0;
		if (_arg_1.align == "right") {
			this.m_view.x = ((this.m_textfield.x + this.m_textfield.width) * -1);
		} else {
			if (_arg_1.align == "center") {
				this.m_view.x = ((this.m_textfield.x + this.m_textfield.width) * -0.5);
			}

		}

		this.m_isTextScrollingEnabled = ((_arg_1.force_scroll) ? true : false);
		MenuUtils.addDropShadowFilter(this.m_textfield);
		MenuUtils.addDropShadowFilter(this.m_icon);
		if (this.m_isTextScrollingEnabled) {
			this.callTextTicker(true);
		}

	}

	override public function getView():Sprite {
		return (this);
	}

	private function setupTextField(_arg_1:String):void {
		MenuUtils.setupTextUpper(this.m_textfield, _arg_1, 26, MenuConstants.FONT_TYPE_MEDIUM, this.m_fontcolor);
		this.m_textTickerUtil.addTextTicker(this.m_textfield, this.m_textfield.htmlText);
		MenuUtils.truncateTextfield(this.m_textfield, 1, null, CommonUtils.changeFontToGlobalIfNeeded(this.m_textfield));
	}

	private function changeTextColor(_arg_1:int):void {
		this.m_textfield.textColor = _arg_1;
	}

	private function callTextTicker(_arg_1:Boolean):void {
		this.m_textTickerUtil.callTextTicker(_arg_1, this.m_textfield.textColor);
	}

	override public function onUnregister():void {
		super.onUnregister();
		if (this.m_textTickerUtil != null) {
			this.m_textTickerUtil.onUnregister();
			this.m_textTickerUtil = null;
		}

		this.m_textfield = null;
		this.m_icon = null;
		if (this.m_view != null) {
			removeChild(this.m_view);
			this.m_view = null;
		}

	}


}
}//package menu3.basic

