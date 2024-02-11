// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//basic.TextBox

package basic {
import common.BaseControl;

import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.AntiAliasType;

import scaleform.gfx.TextFormatEx;

import common.menu.MenuUtils;
import common.CommonUtils;

public class TextBox extends BaseControl {

	protected var m_view:LabelView = new LabelView();
	protected var m_textfield:TextField = m_view.m_textfield;
	protected var m_textformat:TextFormat = new TextFormat();
	protected var m_checkForGlobalFont:Boolean = false;
	protected var m_shrinkToFit:Boolean = false;
	protected var m_uppercase:Boolean = false;
	protected var m_text:String = "";
	protected var m_font:String = "$normal";
	protected var m_fontSize:int = 12;
	protected var m_fontColor:String = "#000000";

	public function TextBox() {
		this.m_textfield.antiAliasType = AntiAliasType.ADVANCED;
		super();
	}

	override public function onAttached():void {
		this.m_textfield.wordWrap = true;
		this.m_textfield.embedFonts = false;
		this.applyFormat();
		addChild(this.m_textfield);
	}

	public function GetTextField():TextField {
		return (this.m_textfield);
	}

	public function set Text(_arg_1:String):void {
		this.m_text = _arg_1;
		this.applyFormat();
	}

	public function SetText(_arg_1:String):void {
		this.Text = _arg_1;
	}

	public function set CheckForGlobalFont(_arg_1:Boolean):void {
		this.m_checkForGlobalFont = _arg_1;
		this.applyFormat();
	}

	public function set ShrinkToFit(_arg_1:Boolean):void {
		this.m_shrinkToFit = _arg_1;
		this.applyFormat();
	}

	public function set Uppercase(_arg_1:Boolean):void {
		this.m_uppercase = _arg_1;
		this.applyFormat();
	}

	public function set WrapText(_arg_1:Boolean):void {
		this.m_textfield.wordWrap = _arg_1;
	}

	public function set TextAlignment(_arg_1:String):void {
		this.m_textformat.align = _arg_1;
		this.applyFormat();
	}

	public function set CompactBulletLists(_arg_1:Boolean):void {
		TextFormatEx.setBulletIndent(this.m_textformat, ((_arg_1) ? 0 : null));
		this.applyFormat();
	}

	public function set ParagraphLeading(_arg_1:Number):void {
		var _local_2:int = int(_arg_1);
		TextFormatEx.setParagraphLeading(this.m_textformat, ((_local_2 > 0) ? _local_2 : null));
		this.applyFormat();
	}

	public function set Font(_arg_1:String):void {
		this.m_font = _arg_1;
		this.applyFormat();
	}

	public function set FontSize(_arg_1:Number):void {
		var _local_2:int = int(_arg_1);
		if (_local_2 == this.m_fontSize) {
			return;
		}
		;
		this.m_fontSize = _local_2;
		this.applyFormat();
	}

	public function set Color(_arg_1:String):void {
		var _local_2:Number = parseInt(_arg_1, 16);
		if (!isNaN(_local_2)) {
			this.m_fontColor = ("#" + _arg_1);
			this.applyFormat();
		}
		;
	}

	public function SetColor(_arg_1:String):void {
		this.Color = _arg_1;
	}

	public function set Alpha(_arg_1:Number):void {
		alpha = _arg_1;
	}

	public function set Background(_arg_1:Boolean):void {
		this.m_textfield.background = _arg_1;
	}

	public function set BackgroundColor(_arg_1:String):void {
		var _local_2:Number = parseInt(_arg_1, 16);
		if (!isNaN(_local_2)) {
			this.m_textfield.backgroundColor = _local_2;
		}
		;
	}

	override public function onSetSize(_arg_1:Number, _arg_2:Number):void {
		this.m_textfield.width = _arg_1;
		this.m_textfield.height = _arg_2;
	}

	protected function applyFormat():void {
		if (this.m_uppercase) {
			MenuUtils.setupTextUpper(this.m_textfield, this.m_text, this.m_fontSize, this.m_font, this.m_fontColor);
		} else {
			MenuUtils.setupText(this.m_textfield, this.m_text, this.m_fontSize, this.m_font, this.m_fontColor);
		}
		;
		if (this.m_checkForGlobalFont) {
			CommonUtils.changeFontToGlobalIfNeeded(this.m_textfield);
		}
		;
		if (this.m_shrinkToFit) {
			this.applyShrinkToFit();
		} else {
			this.m_textfield.setTextFormat(this.m_textformat);
		}
		;
	}

	private function applyShrinkToFit():void {
		MenuUtils.shrinkTextToFit(this.m_textfield, this.m_textfield.width, this.m_textfield.height);
		var _local_1:TextFormat = this.m_textfield.getTextFormat();
		_local_1.align = this.m_textformat.align;
		TextFormatEx.setBulletIndent(_local_1, TextFormatEx.getBulletIndent(this.m_textformat));
		TextFormatEx.setParagraphLeading(_local_1, TextFormatEx.getParagraphLeading(this.m_textformat));
		this.m_textfield.setTextFormat(_local_1);
	}

	public function onSetData(_arg_1:Object):void {
		var _local_2:Number;
		if ((_arg_1 as Number)) {
			_local_2 = (_arg_1 as Number);
			if (Math.abs((_local_2 % 1)) > 0.001) {
				this.Text = _local_2.toFixed(2).toString();
			} else {
				this.Text = _local_2.toString();
			}
			;
		} else {
			this.Text = _arg_1.toString();
		}
		;
	}


}
}//package basic

