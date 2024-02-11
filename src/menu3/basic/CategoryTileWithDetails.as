// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.CategoryTileWithDetails

package menu3.basic {
import common.menu.MenuConstants;

import flash.display.Sprite;
import flash.text.TextField;

import common.menu.MenuUtils;
import common.Animate;

public dynamic class CategoryTileWithDetails extends CategoryTile {

	private const HEADER_HEIGHT:Number = 70;
	private const GAP_BETWEEN_HEADER_AND_DETAILS:Number = 30;
	private const DETAILS_PADDING_X:Number = 15;
	private const DETAILS_PADDING_Y:Number = 20;
	private const DETAILS_HEIGHT_MAX:Number = (((MenuConstants.MenuTileTallHeight - HEADER_HEIGHT) - GAP_BETWEEN_HEADER_AND_DETAILS) - DETAILS_PADDING_Y);

	private var m_detailBg:Sprite;
	private var m_details:TextField;
	private var m_detailsHeight:Number = 0;
	private var m_originalTileSelectPosY:Number = 0;
	private var m_originalHeaderPosY:Number = 0;
	private var m_originalTitlePosY:Number = 0;
	private var m_originalTileIconPosY:Number = 0;
	private var m_showDetailsOnSelect:Boolean = true;

	public function CategoryTileWithDetails(_arg_1:Object) {
		super(_arg_1);
	}

	override protected function createView():* {
		var _local_1:* = super.createView();
		var _local_2:int = _local_1.getChildIndex(_local_1.image);
		this.m_detailBg = new Sprite();
		_local_1.addChildAt(this.m_detailBg, (_local_2 + 1));
		this.m_detailBg.graphics.clear();
		this.m_detailBg.graphics.beginFill(MenuConstants.COLOR_MENU_TABS_BACKGROUND, MenuConstants.MenuElementBackgroundAlpha);
		this.m_detailBg.graphics.drawRect(0, 0, MenuConstants.MenuTileTallWidth, -1);
		this.m_detailBg.graphics.endFill();
		this.m_detailBg.x = 0;
		this.m_detailBg.y = MenuConstants.MenuTileTallHeight;
		this.m_details = new TextField();
		this.m_details.multiline = true;
		this.m_details.wordWrap = true;
		_local_1.addChildAt(this.m_details, (_local_2 + 2));
		this.m_details.x = this.DETAILS_PADDING_X;
		this.m_details.width = (MenuConstants.MenuTileTallWidth - (this.DETAILS_PADDING_X * 2));
		this.m_details.y = this.DETAILS_PADDING_Y;
		this.m_details.height = this.DETAILS_HEIGHT_MAX;
		this.m_details.visible = false;
		this.m_originalTitlePosY = _local_1.title.y;
		this.m_originalHeaderPosY = _local_1.header.y;
		this.m_originalTileIconPosY = _local_1.tileIcon.y;
		this.m_originalTileSelectPosY = _local_1.tileSelect.y;
		return (_local_1);
	}

	override public function onSetData(_arg_1:Object):void {
		var _local_3:int;
		super.onSetData(_arg_1);
		this.m_details.visible = false;
		if (_arg_1.description != null) {
			_local_3 = ((ControlsMain.getDisplaySize() == ControlsMain.DISPLAY_SIZE_SMALL) ? 22 : 14);
			MenuUtils.setupText(this.m_details, _arg_1.description, _local_3, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
			this.m_detailsHeight = Math.min(this.m_details.textHeight, this.DETAILS_HEIGHT_MAX);
			this.m_details.y = ((MenuConstants.MenuTileTallHeight - this.DETAILS_PADDING_Y) - this.m_detailsHeight);
		}
		;
		this.m_showDetailsOnSelect = true;
		if (_arg_1.showDetailsOnSelect === false) {
			this.m_showDetailsOnSelect = false;
		}
		;
		var _local_2:* = (_arg_1.showDetails === true);
		this.setDetailsVisible(_local_2);
	}

	override protected function handleSelectionChange():void {
		super.handleSelectionChange();
		if (m_loading) {
			return;
		}
		;
		if (!this.m_showDetailsOnSelect) {
			return;
		}
		;
		if (m_isSelected) {
			this.setDetailsVisible(true);
		} else {
			this.setDetailsVisible(false);
		}
		;
	}

	public function setDetailsVisible(_arg_1:Boolean):void {
		var _local_2:Number;
		var _local_3:Number;
		var _local_4:int;
		this.killAnimations();
		if (_arg_1) {
			_local_2 = (this.m_detailsHeight + this.GAP_BETWEEN_HEADER_AND_DETAILS);
			_local_3 = 0.3;
			_local_4 = Animate.ExpoOut;
			Animate.to(this.m_detailBg, _local_3, 0, {"height": (_local_2 - 2)}, _local_4);
			Animate.to(m_view.header, _local_3, 0, {"y": (this.m_originalHeaderPosY - _local_2)}, _local_4);
			Animate.to(m_view.title, _local_3, 0, {"y": (this.m_originalTitlePosY - _local_2)}, _local_4);
			Animate.to(m_view.tileIcon, _local_3, 0, {"y": (this.m_originalTileIconPosY - _local_2)}, _local_4);
			Animate.to(m_view.tileSelect, _local_3, 0, {"y": (this.m_originalTileSelectPosY - _local_2)}, _local_4);
			this.m_details.visible = true;
			this.m_details.alpha = 0;
			Animate.to(this.m_details, 0.1, (_local_3 - 0.1), {"alpha": 1}, Animate.Linear);
		} else {
			this.m_detailBg.height = 1;
			m_view.header.y = this.m_originalHeaderPosY;
			m_view.title.y = this.m_originalTitlePosY;
			m_view.tileIcon.y = this.m_originalTileIconPosY;
			m_view.tileSelect.y = this.m_originalTileSelectPosY;
			this.m_details.visible = false;
		}
		;
	}

	private function killAnimations():void {
		Animate.kill(m_view.header);
		Animate.kill(m_view.title);
		Animate.kill(m_view.tileIcon);
		Animate.kill(m_view.tileSelect);
		if (this.m_detailBg != null) {
			Animate.kill(this.m_detailBg);
		}
		;
		if (this.m_details != null) {
			Animate.kill(this.m_details);
		}
		;
	}

	override public function onUnregister():void {
		if (m_view != null) {
			this.killAnimations();
			if (this.m_detailBg != null) {
				m_view.removeChild(this.m_detailBg);
				this.m_detailBg = null;
			}
			;
			if (this.m_details != null) {
				m_view.removeChild(this.m_details);
				this.m_details = null;
			}
			;
		}
		;
		super.onUnregister();
	}


}
}//package menu3.basic

