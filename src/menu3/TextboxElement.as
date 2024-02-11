// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.TextboxElement

package menu3 {
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.AntiAliasType;

import common.menu.MenuUtils;

import flash.geom.Rectangle;

public dynamic class TextboxElement extends MenuElementBase {

	private var m_view:LabelView;
	private var m_textfield:TextField;
	private var m_textformat:TextFormat;
	private var m_useDynamicTextBounds:Boolean = false;

	public function TextboxElement(_arg_1:Object) {
		super(_arg_1);
		this.m_view = new LabelView();
		this.m_textfield = this.m_view.m_textfield;
		addChild(this.m_view);
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		var _local_2:String = ((_arg_1.text) || (""));
		this.m_textfield.htmlText = _local_2;
		var _local_3:String = ((_arg_1.font) || ("$normal"));
		if (((_local_3.length > 0) && (!(_local_3.charAt(0) == "$")))) {
			_local_3 = ("$" + _local_3);
		}
		;
		var _local_4:String = ((_arg_1.color) || ("#FFFFFF"));
		if ((((!(_local_4 == null)) && (_local_4.length > 0)) && (!(_local_4.charAt(0) == "#")))) {
			_local_4 = ("#" + _local_4);
		}
		;
		var _local_5:int = ((_arg_1.size) || (18));
		this.m_textfield.antiAliasType = AntiAliasType.ADVANCED;
		var _local_6:Boolean = ((_arg_1.multiline) || (true));
		this.m_textfield.multiline = _local_6;
		this.m_textfield.wordWrap = _local_6;
		this.m_textfield.autoSize = "left";
		this.m_textfield.width = ((_arg_1.width) || (1));
		this.m_textfield.height = ((_arg_1.height) || (1));
		if (_arg_1.visible != null) {
			this.visible = _arg_1.visible;
		}
		;
		if (_arg_1.toUpper === true) {
			MenuUtils.setupTextUpper(this.m_textfield, _local_2, _local_5, _local_3, _local_4);
		} else {
			MenuUtils.setupText(this.m_textfield, _local_2, _local_5, _local_3, _local_4);
		}
		;
		if (_arg_1.align != undefined) {
			this.m_textformat = this.m_textfield.getTextFormat();
			this.m_textformat.align = _arg_1.align;
			this.m_textfield.setTextFormat(this.m_textformat);
		}
		;
		this.m_useDynamicTextBounds = (_arg_1.useDynamicTextBounds === true);
		if (_arg_1.dropShadow === true) {
			MenuUtils.addDropShadowFilter(this.m_textfield);
		}
		;
	}

	override public function getHeight():Number {
		return ((getData().height) || (this.m_textfield.textHeight));
	}

	override public function getVisualBounds(_arg_1:MenuElementBase):Rectangle {
		var _local_2:Rectangle = super.getVisualBounds(_arg_1);
		if (this.m_useDynamicTextBounds) {
			_local_2.width = this.m_textfield.textWidth;
			_local_2.height = this.m_textfield.textHeight;
		}
		;
		return (_local_2);
	}

	override public function onUnregister():void {
		if (this.m_view) {
			this.m_textfield = null;
			this.m_textformat = null;
			removeChild(this.m_view);
			this.m_view = null;
		}
		;
	}


}
}//package menu3

