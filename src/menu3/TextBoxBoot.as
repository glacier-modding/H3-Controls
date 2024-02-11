// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.TextBoxBoot

package menu3 {
import common.BaseControl;

import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.AntiAliasType;

import common.CommonUtils;
import common.Log;

public class TextBoxBoot extends BaseControl {

	protected var m_view:LabelView = new LabelView();
	protected var m_textfield:TextField = m_view.m_textfield;
	protected var m_textformat:TextFormat = new TextFormat("$normal");
	protected var m_checkForGlobalFont:Boolean = false;

	public function TextBoxBoot() {
		this.m_textfield.antiAliasType = AntiAliasType.ADVANCED;
		super();
	}

	override public function onAttached():void {
		this.m_textfield.wordWrap = true;
		this.m_textfield.embedFonts = false;
		this.applyFormat();
		addChild(this.m_textfield);
	}

	public function set Text(_arg_1:String):void {
		this.m_textfield.htmlText = _arg_1;
		this.applyFormat();
		if (this.m_checkForGlobalFont) {
			CommonUtils.changeFontToGlobalIfNeeded(this.m_textfield);
		}
		;
	}

	public function SetText(_arg_1:String):void {
		this.Text = _arg_1;
	}

	public function set CheckForGlobalFont(_arg_1:Boolean):void {
		this.m_checkForGlobalFont = _arg_1;
		this.SetText(this.m_textfield.htmlText);
	}

	public function set WrapText(_arg_1:Boolean):void {
		this.m_textfield.wordWrap = _arg_1;
	}

	public function set TextAlignment(_arg_1:String):void {
		this.m_textformat.align = _arg_1;
		this.applyFormat();
	}

	public function set Font(_arg_1:String):void {
		this.m_textformat.font = _arg_1;
		this.applyFormat();
	}

	public function set FontSize(_arg_1:Number):void {
		this.m_textformat.size = _arg_1;
		this.applyFormat();
	}

	public function set LetterSpacing(_arg_1:Number):void {
		this.m_textformat.letterSpacing = _arg_1;
		this.applyFormat();
	}

	public function set Color(_arg_1:String):void {
		var _local_2:Number = parseInt(_arg_1, 16);
		if (!isNaN(_local_2)) {
			this.m_textformat.color = _local_2;
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

	override public function onSetSize(_arg_1:Number, _arg_2:Number):void {
		this.m_textfield.width = _arg_1;
		this.m_textfield.height = _arg_2;
	}

	protected function applyFormat():void {
		this.m_textfield.setTextFormat(this.m_textformat);
	}

	public function onSetData(_arg_1:Object):void {
		var _local_2:String = _arg_1.prependedstring;
		if (_arg_1.username) {
			_local_2 = _local_2.replace("{0}", _arg_1.username);
		}
		;
		Log.xinfo(Log.ChannelCommon, ("text: " + _local_2));
		this.Text = _local_2;
	}


}
}//package menu3

