// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.RecommendedInfoTile

package menu3.basic {
import menu3.MenuElementTileBase;
import menu3.MenuImageLoader;

import flash.display.Sprite;

import basic.DottedLine;

import flash.text.TextFieldAutoSize;

import common.menu.MenuUtils;
import common.menu.MenuConstants;

public dynamic class RecommendedInfoTile extends MenuElementTileBase {

	protected var m_view:RecommendedInfoTileView;
	private var m_loader:MenuImageLoader;
	private var m_imagePath:String = null;
	private var m_dottedLineContainer:Sprite;
	private var m_headerLine:DottedLine;
	private var m_footerLine:DottedLine;

	public function RecommendedInfoTile(_arg_1:Object) {
		super(_arg_1);
		this.m_view = this.createView();
		this.m_view.tileDarkBg.alpha = 0;
		this.m_view.descriptionBody.autoSize = TextFieldAutoSize.LEFT;
		MenuUtils.setColor(this.m_view.tileBg, MenuConstants.COLOR_MENU_SOLID_BACKGROUND, true, 1);
		this.m_dottedLineContainer = new Sprite();
		this.m_headerLine = new DottedLine(308, MenuConstants.COLOR_WHITE, DottedLine.TYPE_HORIZONTAL, 1, 2);
		this.m_headerLine.x = 22;
		this.m_headerLine.y = 80;
		this.m_footerLine = new DottedLine(308, MenuConstants.COLOR_WHITE, DottedLine.TYPE_HORIZONTAL, 1, 2);
		this.m_footerLine.x = 22;
		this.m_footerLine.y = 450;
		this.m_dottedLineContainer.addChild(this.m_headerLine);
		this.m_dottedLineContainer.addChild(this.m_footerLine);
		this.m_view.addChild(this.m_dottedLineContainer);
		addChild(this.m_view);
	}

	protected function createView():* {
		return (new RecommendedInfoTileView());
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		if (getNodeProp(this, "pressable") == false) {
		}

		MenuUtils.setupTextAndShrinkToFitUpper(this.m_view.descriptionHeader, _arg_1.descriptionHeader, 36, MenuConstants.FONT_TYPE_MEDIUM, 280, -1, 18, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_view.descriptionBody, _arg_1.descriptionBody, 18, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		if (_arg_1.showUnlock === true) {
			MenuUtils.setupTextUpper(this.m_view.header, _arg_1.unlockHeader, 12, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
			MenuUtils.setupTextUpper(this.m_view.title, _arg_1.unlockTitle, 26, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			MenuUtils.setupIcon(this.m_view.tileIcon, _arg_1.unlockIcon, MenuConstants.COLOR_WHITE, true, false);
		} else {
			this.m_view.header.text = "";
			this.m_view.title.text = "";
			this.m_view.tileIcon.visible = false;
			this.m_footerLine.visible = false;
		}

		this.handleSelectionChange();
	}

	override protected function handleSelectionChange():void {
		super.handleSelectionChange();
		if (m_loading) {
			return;
		}

	}

	override public function onUnregister():void {
		if (this.m_view) {
			super.onUnregister();
			removeChild(this.m_view);
			this.m_view = null;
		}

	}

	private function completeAnimations():void {
	}


}
}//package menu3.basic

