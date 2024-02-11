// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.search.SearchSelectedTagScrollingListContainer

package menu3.search {
import menu3.containers.ScrollingListContainer;

import flash.display.Sprite;

import common.menu.MenuConstants;

import menu3.MenuElementBase;

import flash.geom.Rectangle;

import common.menu.MenuUtils;

public dynamic class SearchSelectedTagScrollingListContainer extends ScrollingListContainer {

	private const GROUPHEADER_HEIGHT:Number = 56.32;
	private const GROUPHEADER_OFFSET_X:Number = 10;

	private var m_groupHeader:ContractSearchTagGroupHeaderView = null;
	private var m_background:Sprite = null;
	private var m_emptyElements:Array = new Array();
	private var m_elementHeight:Number = 0;
	private var m_emptyElementFillCount:Number = 1;

	public function SearchSelectedTagScrollingListContainer(_arg_1:Object) {
		var _local_2:Number = ((_arg_1.offsetRow != undefined) ? _arg_1.offsetRow : 0);
		_local_2 = (_local_2 + (this.GROUPHEADER_HEIGHT / MenuConstants.GridUnitHeight));
		_arg_1.offsetRow = _local_2;
		super(_arg_1);
		setScrollIndicatorColors();
		if (_arg_1.elementnrows != undefined) {
			this.m_elementHeight = (_arg_1.elementnrows * MenuConstants.GridUnitHeight);
		}
		;
		if (_arg_1.emptyelementfillcount != undefined) {
			this.m_emptyElementFillCount = Math.max(_arg_1.emptyelementfillcount, 0);
		}
		;
		this.setupGroupHeader(_arg_1);
		this.setupBackground();
		var _local_3:int = ((_arg_1.emptycount != undefined) ? _arg_1.emptycount : 5);
		this.setupEmptyElements(_local_3);
		this.repositionAllElements();
	}

	override public function repositionChild(_arg_1:Sprite):void {
		super.repositionChild(_arg_1);
		this.repositionAllElements();
	}

	override public function getVisibleContainerBounds():Rectangle {
		var _local_1:MenuElementBase;
		if (m_children.length > 0) {
			_local_1 = m_children[0];
		}
		;
		var _local_2:Rectangle = _local_1.getVisualBounds(this);
		var _local_3:int = Math.max((m_children.length + this.m_emptyElementFillCount), this.m_emptyElements.length);
		_local_2.height = (_local_3 * this.m_elementHeight);
		return (_local_2);
	}

	private function setupGroupHeader(_arg_1:Object):void {
		this.m_groupHeader = new ContractSearchTagGroupHeaderView();
		this.m_groupHeader.bg.visible = false;
		this.m_groupHeader.label_txt.selectable = false;
		this.m_groupHeader.x = this.GROUPHEADER_OFFSET_X;
		this.m_groupHeader.y = 0;
		addChild(this.m_groupHeader);
		var _local_2:String = ((_arg_1.title) ? _arg_1.title : "");
		MenuUtils.setupText(this.m_groupHeader.label_txt, _local_2, 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		MenuUtils.truncateTextfield(this.m_groupHeader.label_txt, 1);
		if (_arg_1.icon) {
			MenuUtils.setupIcon(this.m_groupHeader.icon, _arg_1.icon, MenuConstants.COLOR_WHITE, true, false);
		}
		;
	}

	private function setupBackground():void {
		var _local_1:Rectangle = new Rectangle(0, 0, getWidth(), getHeight());
		_local_1.inflate(0, 5);
		this.m_background = new Sprite();
		addChildAt(this.m_background, 0);
		this.m_background.graphics.clear();
		this.m_background.graphics.beginFill(MenuConstants.COLOR_MENU_SOLID_BACKGROUND, 1);
		this.m_background.graphics.drawRect(_local_1.x, _local_1.y, _local_1.width, _local_1.height);
		this.m_background.graphics.endFill();
	}

	private function setupEmptyElements(_arg_1:int):void {
		var _local_3:Sprite;
		var _local_2:int;
		while (_local_2 < _arg_1) {
			_local_3 = new ContractSearchSelectedTagElementEmptyView();
			MenuUtils.setColor(_local_3, MenuConstants.COLOR_MENU_SOLID_BACKGROUND, false);
			_local_3.alpha = 1;
			this.m_emptyElements.push(_local_3);
			getContainer().addChild(_local_3);
			_local_2++;
		}
		;
	}

	private function repositionAllElements():void {
		var _local_1:Number = 0;
		var _local_2:Number = 0;
		var _local_3:int = Math.max((m_children.length + this.m_emptyElementFillCount), this.m_emptyElements.length);
		var _local_4:int;
		var _local_5:int;
		while (_local_5 < m_children.length) {
			_local_2 = (_local_4 * this.m_elementHeight);
			_local_4++;
			m_children[_local_5].x = (_local_1 + (m_xOffset * MenuConstants.GridUnitWidth));
			m_children[_local_5].y = (_local_2 + (m_yOffset * MenuConstants.GridUnitHeight));
			_local_5++;
		}
		;
		var _local_6:int;
		while (_local_6 < this.m_emptyElements.length) {
			this.m_emptyElements[_local_6].visible = false;
			if (_local_4 < _local_3) {
				this.m_emptyElements[_local_6].visible = true;
				_local_2 = (_local_4 * this.m_elementHeight);
				_local_4++;
				this.m_emptyElements[_local_6].x = (_local_1 + (m_xOffset * MenuConstants.GridUnitWidth));
				this.m_emptyElements[_local_6].y = (_local_2 + (m_yOffset * MenuConstants.GridUnitHeight));
			}
			;
			_local_6++;
		}
		;
	}


}
}//package menu3.search

