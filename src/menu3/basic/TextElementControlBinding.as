// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.TextElementControlBinding

package menu3.basic {
import menu3.MenuElementBase;

import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.text.TextFieldAutoSize;

import common.menu.MenuUtils;
import common.menu.MenuConstants;

public dynamic class TextElementControlBinding extends MenuElementBase {

	private var m_view:TextElementControlBindingView;
	private var m_textfield:TextField;
	private var m_textformat:TextFormat;

	public function TextElementControlBinding(_arg_1:Object) {
		super(_arg_1);
		if (_arg_1.visible != null) {
			this.visible = _arg_1.visible;
		}

		this.m_textformat = new TextFormat();
		this.m_textformat.align = TextFormatAlign.LEFT;
		this.m_textformat.size = ((_arg_1.fontSize) || (24));
		this.m_view = new TextElementControlBindingView();
		this.m_view.tileBg.alpha = 0;
		addChild(this.m_view);
	}

	override public function onSetData(_arg_1:Object):void {
		this.m_textfield = this.m_view.title;
		this.m_textfield.defaultTextFormat = this.m_textformat;
		this.m_textfield.autoSize = TextFieldAutoSize.LEFT;
		this.m_textfield.multiline = true;
		this.m_textfield.wordWrap = true;
		MenuUtils.setupText(this.m_textfield, ((_arg_1.title) || ("")), 20, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		this.m_textfield.width = ((_arg_1.width) || (0));
		this.m_textfield.height = ((_arg_1.height) || (0));
		if (((!(_arg_1.showDebugBoundries == undefined)) && (_arg_1.showDebugBoundries == true))) {
			this.m_textfield.border = true;
			this.m_textfield.borderColor = 0xFF00FF;
			this.m_view.tileBg.alpha = 0.2;
		}

		this.m_textfield.setTextFormat(this.m_textformat);
		this.m_textfield.y = ((this.m_view.tileBg.height >> 1) - (this.m_textfield.height >> 1));
		this.m_view.tileBg.width = this.m_textfield.width;
		this.m_view.tileBg.x = (this.m_view.tileBg.width >> 1);
	}

	override public function getHeight():Number {
		return (this.m_view.tileBg.height);
	}

	override public function onUnregister():void {
		if (this.m_view) {
			this.m_textfield = null;
			this.m_textformat = null;
			removeChild(this.m_view);
			this.m_view = null;
		}

	}


}
}//package menu3.basic

