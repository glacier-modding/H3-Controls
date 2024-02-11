// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.StateText

package menu3.basic {
import menu3.MenuElementBase;

import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

import common.menu.MenuUtils;
import common.menu.MenuConstants;

public dynamic class StateText extends MenuElementBase {

	private const BACKGROUNDBOX_OVERFLOW:Number = 10;
	private const BACKGROUNDBOX_OVERFLOW_OFFSET_Y:Number = -6;
	private const BACKGROUNDBOX_OFFSET_Y:Number = -2;

	private var m_view:Sprite;
	private var m_background:Sprite;
	private var m_text:TextField;

	public function StateText(_arg_1:Object) {
		super(_arg_1);
		this.m_view = new Sprite();
		this.m_background = new Sprite();
		this.m_view.addChild(this.m_background);
		this.m_text = new TextField();
		this.m_text.multiline = false;
		this.m_text.autoSize = TextFieldAutoSize.LEFT;
		this.m_view.addChild(this.m_text);
		addChild(this.m_view);
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		var _local_2:* = (_arg_1.isdone === true);
		var _local_3:String = ((_arg_1.text != null) ? _arg_1.text : "");
		MenuUtils.setupTextUpper(this.m_text, _local_3, 40, MenuConstants.FONT_TYPE_BOLD, ((_local_2) ? MenuConstants.FontColorBlack : MenuConstants.FontColorWhite));
		var _local_4:Number = ((_arg_1.backgroundoverflow != null) ? _arg_1.backgroundoverflow : this.BACKGROUNDBOX_OVERFLOW);
		var _local_5:Number = (_local_4 + this.BACKGROUNDBOX_OVERFLOW_OFFSET_Y);
		var _local_6:Number = (this.m_text.width + (_local_4 * 2));
		var _local_7:Number = (this.m_text.height + (_local_5 * 2));
		this.m_background.graphics.clear();
		this.m_background.graphics.beginFill(((_local_2) ? MenuConstants.COLOR_GREEN : MenuConstants.COLOR_RED), 1);
		this.m_background.graphics.drawRect(-(_local_4), (-(_local_5) + this.BACKGROUNDBOX_OFFSET_Y), _local_6, _local_7);
		this.m_background.graphics.endFill();
	}

	override public function onUnregister():void {
		if (this.m_view) {
			removeChild(this.m_view);
			this.m_view = null;
		}
		;
		this.m_background = null;
		this.m_text = null;
		super.onUnregister();
	}


}
}//package menu3.basic

