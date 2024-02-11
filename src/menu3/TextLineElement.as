// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.TextLineElement

package menu3 {
import flash.text.TextField;

import menu3.basic.TextTickerUtil;

import flash.text.TextFieldAutoSize;

import common.menu.MenuUtils;
import common.Animate;
import common.menu.MenuConstants;
import common.CommonUtils;

public dynamic class TextLineElement extends MenuElementBase {

	private var m_once:Boolean = true;
	private var m_textfield:TextField;
	private var m_textTickerUtil:TextTickerUtil = new TextTickerUtil();
	private var m_title:String;
	private var m_maxtextwidth:Number;
	private var m_fontcolor:String;
	private var m_fontsize:int;
	private var m_fonttype:String;
	private var m_textfieldAnimTargetX:Number;
	private var m_textfieldAnimTargetY:Number;
	private var m_textfieldAnimTargetAlpha:Number;

	public function TextLineElement(_arg_1:Object) {
		super(_arg_1);
		this.m_textfield = new TextField();
		this.m_textfield.autoSize = TextFieldAutoSize.LEFT;
		addChild(this.m_textfield);
		MenuUtils.addDropShadowFilter(this.m_textfield);
	}

	override public function onSetData(data:Object):void {
		var vars:Object;
		var xoffset:Number;
		var yoffset:Number;
		var alpha:Number;
		var isTextTooLong:Boolean;
		super.onSetData(data);
		if (this.m_once) {
			this.m_once = false;
			this.m_textfield.x = ((data.xoffset != null) ? data.xoffset : 0);
			this.m_textfield.y = ((data.yoffset != null) ? data.yoffset : 0);
			this.m_textfield.alpha = ((data.alpha != null) ? data.alpha : 1);
			this.m_textfieldAnimTargetX = this.m_textfield.x;
			this.m_textfieldAnimTargetY = this.m_textfield.y;
			this.m_textfieldAnimTargetAlpha = this.m_textfield.alpha;
		} else {
			vars = null;
			xoffset = ((data.xoffset != null) ? data.xoffset : 0);
			yoffset = ((data.yoffset != null) ? data.yoffset : 0);
			alpha = ((data.alpha != null) ? data.alpha : 1);
			if (xoffset != this.m_textfieldAnimTargetX) {
				vars = ((vars) || ({}));
				vars.x = (this.m_textfieldAnimTargetX = xoffset);
			}
			;
			if (yoffset != this.m_textfieldAnimTargetY) {
				vars = ((vars) || ({}));
				vars.y = (this.m_textfieldAnimTargetY = yoffset);
			}
			;
			if (alpha != this.m_textfieldAnimTargetAlpha) {
				vars = ((vars) || ({}));
				vars.alpha = (this.m_textfieldAnimTargetAlpha = alpha);
			}
			;
			if (vars) {
				if (vars.alpha != null) {
					this.m_textfield.visible = true;
				}
				;
				Animate.to(this.m_textfield, 0.2, 0, vars, Animate.Linear, function ():void {
					m_textfield.visible = (!(m_textfield.alpha == 0));
				});
			}
			;
		}
		;
		var isTextUpdated:Boolean;
		var title:String = ((data.title != null) ? data.title : "");
		var maxtextwidth:Number = ((data.maxtextwidth != null) ? data.maxtextwidth : 250);
		var fontcolor:String = ((data.colorname != null) ? this.getColorString(data.colorname) : MenuConstants.FontColorWhite);
		var fontsize:int = ((data.fontsize != null) ? data.fontsize : 26);
		var fonttype:String = ((data.fonttype != null) ? data.fonttype : MenuConstants.FONT_TYPE_MEDIUM);
		if (title != this.m_title) {
			this.m_title = title;
			isTextUpdated = true;
		}
		;
		if (maxtextwidth != this.m_maxtextwidth) {
			this.m_maxtextwidth = maxtextwidth;
			isTextUpdated = true;
		}
		;
		if (fontcolor != this.m_fontcolor) {
			this.m_fontcolor = fontcolor;
			isTextUpdated = true;
		}
		;
		if (fontsize != this.m_fontsize) {
			this.m_fontsize = fontsize;
			isTextUpdated = true;
		}
		;
		if (fonttype != this.m_fonttype) {
			this.m_fonttype = fonttype;
			isTextUpdated = true;
		}
		;
		if (isTextUpdated) {
			this.m_textfield.width = this.m_maxtextwidth;
			MenuUtils.setupText(this.m_textfield, this.m_title, this.m_fontsize, this.m_fonttype, this.m_fontcolor);
			this.m_textTickerUtil.addTextTicker(this.m_textfield, this.m_textfield.htmlText);
			MenuUtils.truncateTextfield(this.m_textfield, 1, null, CommonUtils.changeFontToGlobalIfNeeded(this.m_textfield));
			this.m_textfield.wordWrap = true;
			this.m_textfield.multiline = true;
			isTextTooLong = (this.m_textfield.numLines > 1);
			this.m_textfield.multiline = false;
			this.m_textfield.wordWrap = false;
			this.m_textfield.autoSize = ((isTextTooLong) ? TextFieldAutoSize.NONE : TextFieldAutoSize.LEFT);
			this.m_textTickerUtil.callTextTicker(true, this.m_textfield.textColor);
		}
		;
	}

	override public function onUnregister():void {
		if (this.m_textTickerUtil != null) {
			this.m_textTickerUtil.onUnregister();
			this.m_textTickerUtil = null;
		}
		;
		removeChild(this.m_textfield);
		this.m_textfield = null;
		super.onUnregister();
	}

	private function getColorString(_arg_1:String):String {
		return (MenuConstants.ColorString(MenuConstants.GetColorByName(_arg_1)));
	}


}
}//package menu3

