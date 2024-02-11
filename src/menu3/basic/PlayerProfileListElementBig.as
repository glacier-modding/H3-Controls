// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.PlayerProfileListElementBig

package menu3.basic {
import menu3.MenuElementTileBase;

import flash.display.Sprite;

import common.menu.MenuConstants;
import common.menu.MenuUtils;
import common.CommonUtils;

import flash.text.TextField;

import basic.DottedLine;

public dynamic class PlayerProfileListElementBig extends MenuElementTileBase {

	private var m_view:*;
	private var m_isPressable:Boolean;
	private var m_isSelectable:Boolean;
	private var m_isHeadline:Boolean;
	private var m_dottedLineContainer:Sprite;

	public function PlayerProfileListElementBig(_arg_1:Object) {
		super(_arg_1);
		this.m_view = this.createView();
		addChild(this.m_view);
	}

	protected function createView():* {
		var _local_1:* = new PlayerProfileListElementBigView();
		_local_1.tileDarkBg.alpha = 0;
		_local_1.tileBg.alpha = 0;
		return (_local_1);
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		this.m_isHeadline = (_arg_1.style == "headline");
		this.m_isPressable = getNodeProp(this, "pressable");
		this.m_isSelectable = getNodeProp(this, "selectable");
		this.setupTextField(this.m_view.title, _arg_1.title);
		this.setupTextField(this.m_view.value1, _arg_1.value1);
		this.setupTextField(this.m_view.value2, _arg_1.value2);
		this.setupTextField(this.m_view.value3, _arg_1.value3);
	}

	override public function getView():Sprite {
		return (this.m_view.tileBg);
	}

	private function setupTextField(_arg_1:TextField, _arg_2:String):void {
		var _local_3:String = ((this.m_isHeadline) ? MenuConstants.FONT_TYPE_BOLD : MenuConstants.FONT_TYPE_NORMAL);
		MenuUtils.setupText(_arg_1, _arg_2, 18, _local_3, MenuConstants.FontColorWhite);
		CommonUtils.changeFontToGlobalIfNeeded(_arg_1);
		if (this.m_isHeadline) {
			this.setupHeaderDivider();
		}
		;
	}

	private function setupHeaderDivider():void {
		if (this.m_dottedLineContainer) {
			return;
		}
		;
		this.m_dottedLineContainer = new Sprite();
		this.m_dottedLineContainer.x = this.m_view.title.x;
		this.m_dottedLineContainer.y = this.m_view.tileBg.height;
		var _local_1:Number = (((this.m_view.title.width + this.m_view.value1.width) + this.m_view.value2.width) + this.m_view.value3.width);
		var _local_2:DottedLine = new DottedLine(_local_1, MenuConstants.COLOR_WHITE, DottedLine.TYPE_HORIZONTAL, 1, 2);
		this.m_dottedLineContainer.addChild(_local_2);
		this.m_view.addChild(this.m_dottedLineContainer);
	}

	override protected function handleSelectionChange():void {
	}

	override public function onUnregister():void {
		super.onUnregister();
		if (this.m_view) {
			removeChild(this.m_view);
			this.m_view = null;
		}
		;
	}


}
}//package menu3.basic

