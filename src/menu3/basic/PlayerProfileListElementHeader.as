// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.PlayerProfileListElementHeader

package menu3.basic {
import menu3.MenuElementTileBase;

import flash.display.Sprite;

import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.CommonUtils;

import basic.DottedLine;

public dynamic class PlayerProfileListElementHeader extends MenuElementTileBase {

	private var m_view:*;
	private var m_isPressable:Boolean;
	private var m_isSelectable:Boolean;
	private var m_dottedLineContainer:Sprite;

	public function PlayerProfileListElementHeader(_arg_1:Object) {
		super(_arg_1);
		this.m_view = this.createView();
		addChild(this.m_view);
	}

	protected function createView():* {
		var _local_1:* = new PlayerProfileListElementHeaderView();
		_local_1.tileDarkBg.alpha = 0;
		_local_1.tileBg.alpha = 0;
		return (_local_1);
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		this.m_isPressable = getNodeProp(this, "pressable");
		this.m_isSelectable = getNodeProp(this, "selectable");
		MenuUtils.setupText(this.m_view.title, _arg_1.title, 40, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		CommonUtils.changeFontToGlobalIfNeeded(this.m_view.title);
		MenuUtils.truncateTextfieldWithCharLimit(this.m_view.title, 1, MenuConstants.PLAYERNAME_MIN_CHAR_COUNT);
		MenuUtils.shrinkTextToFit(this.m_view.title, this.m_view.title.width, -1);
		MenuUtils.setupText(this.m_view.level, _arg_1.level, 30, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_view.xp, _arg_1.xp, 18, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		this.setupHeaderDivider();
	}

	override public function getView():Sprite {
		return (this.m_view.tileBg);
	}

	private function setupHeaderDivider():void {
		if (this.m_dottedLineContainer) {
			return;
		}
		;
		this.m_dottedLineContainer = new Sprite();
		this.m_dottedLineContainer.x = 14;
		this.m_dottedLineContainer.y = this.m_view.tileBg.height;
		var _local_1:DottedLine = new DottedLine((this.m_view.tileBg.width - 24), MenuConstants.COLOR_WHITE, DottedLine.TYPE_HORIZONTAL, 1, 2);
		this.m_dottedLineContainer.addChild(_local_1);
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

