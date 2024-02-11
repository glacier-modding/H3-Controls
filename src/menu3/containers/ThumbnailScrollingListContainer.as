// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.containers.ThumbnailScrollingListContainer

package menu3.containers {
import menu3.basic.ThumbnailSelectedltemTile;

import flash.geom.Rectangle;

import menu3.basic.ThumbnailItemTile;

import common.menu.MenuConstants;

import menu3.basic.ChallengeCategoryTile;

import common.MouseUtil;

import flash.display.Sprite;
import flash.system.System;

import common.Log;

import menu3.MenuElementBase;

import flash.display.BitmapData;

import menu3.basic.IImageContainer;

import flash.events.MouseEvent;
import flash.geom.Point;

import menu3.ScreenResizeEvent;

public dynamic class ThumbnailScrollingListContainer extends ScrollingListContainer {

	public var m_childrenOffset:Array = [];
	private var m_selectedItemTile:ThumbnailSelectedltemTile;
	private var m_scrollMaxBounds:Rectangle;
	private var m_elementIndex:int = 0;
	private var m_currentFocusedElement:ThumbnailItemTile = null;
	private var m_mouseEdgeScrollActivated:Boolean = false;
	private var m_nextElementIndexFromEdgeScroll:int = -1;
	private var m_currentHoverIndex:int = -1;
	private var m_visibleLocalWidth:Number = MenuConstants.BaseWidth;
	private var m_bValidContent:Boolean = true;
	private var m_emptyContainerFeedbackTile:ChallengeCategoryTile = null;
	private var m_prevNextHandles:ThumbnailPrevNextHandles = null;
	private var m_isDirty:Boolean = false;

	public function ThumbnailScrollingListContainer(_arg_1:Object) {
		super(_arg_1);
		m_mouseMode = MouseUtil.MODE_ONOVER_HOVER_ONUP_SELECTCLICK;
		this.m_selectedItemTile = new ThumbnailSelectedltemTile(this);
		this.m_selectedItemTile.visible = false;
		addChild(this.m_selectedItemTile);
		m_alwaysClampToMaxBounds = false;
		if (m_mask != null) {
			m_mask.x = (m_mask.x + MenuConstants.GridUnitWidth);
			m_mask.width = (m_mask.width - (MenuConstants.GridUnitWidth / 2));
		}
		;
		if (m_maskArea != null) {
			m_maskArea.x = (m_maskArea.x + MenuConstants.GridUnitWidth);
			m_maskArea.width = (m_maskArea.width - (MenuConstants.GridUnitWidth / 2));
		}
		;
		if (m_visibilityArea != null) {
			m_visibilityArea.x = (m_visibilityArea.x + MenuConstants.GridUnitWidth);
			m_visibilityArea.width = (m_visibilityArea.width - (MenuConstants.GridUnitWidth / 2));
		}
		;
	}

	public function get selectedTileView():ThumbnailSelectedltemTile {
		return (this.m_selectedItemTile);
	}

	public function get focusedElementIndex():int {
		return (this.m_elementIndex);
	}

	public function get emptyContainerFeedbackTile():Sprite {
		return (this.m_emptyContainerFeedbackTile);
	}

	public function hasValidContent():Boolean {
		return (this.m_bValidContent);
	}

	public function isEmptyContainerFeedbackTileActive():Boolean {
		return (!(this.m_emptyContainerFeedbackTile == null));
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		if (((!(isNaN(_arg_1.sizeX))) && (!(isNaN(_arg_1.sizeY))))) {
			this.updateVisibleWidth(_arg_1.sizeX, _arg_1.sizeY);
		}
		;
		this.m_bValidContent = (!(_arg_1.novalidcontent));
		this.m_selectedItemTile.visible = false;
		if (this.m_bValidContent) {
			this.SetFocusedElementIndex(this.focusedElementIndex);
		}
		;
		this.deleteContainerEmptyFeedback();
		if (!this.m_bValidContent) {
			this.m_emptyContainerFeedbackTile = this.createContainerEmptyFeedback(_arg_1.containeremptydata);
			if (this.m_emptyContainerFeedbackTile != null) {
				this.m_emptyContainerFeedbackTile.y = -1;
				addChild(this.m_emptyContainerFeedbackTile);
			}
			;
		}
		;
		if (((ThumbnailPrevNextHandles.arePrevNextCategoryHandlesNeeded(_arg_1)) && (this.m_prevNextHandles == null))) {
			this.m_prevNextHandles = new ThumbnailPrevNextHandles(this);
		}
		;
		if (this.m_prevNextHandles != null) {
			this.m_prevNextHandles.onSetData(_arg_1);
		}
		;
	}

	override public function onUnregister():void {
		this.m_currentFocusedElement = null;
		if (this.m_prevNextHandles != null) {
			this.m_prevNextHandles.onUnregister();
			this.m_prevNextHandles = null;
		}
		;
		if (this.m_selectedItemTile != null) {
			removeChild(this.m_selectedItemTile);
			this.m_selectedItemTile.onUnregister();
			this.m_selectedItemTile = null;
		}
		;
		this.deleteContainerEmptyFeedback();
		super.onUnregister();
		if (!ControlsMain.isVrModeActive()) {
			System.gc();
		}
		;
	}

	private function createContainerEmptyFeedback(_arg_1:Object):ChallengeCategoryTile {
		if (_arg_1 == null) {
			Log.error(Log.ChannelContainer, this, "data is null, not creating EmptyContainerFeedbackTile");
			return (null);
		}
		;
		var _local_2:ChallengeCategoryTile = new ChallengeCategoryTile(_arg_1);
		_local_2.onSetData(_arg_1);
		_local_2.setSelectedState(true);
		return (_local_2);
	}

	private function deleteContainerEmptyFeedback():void {
		if (this.m_emptyContainerFeedbackTile != null) {
			this.m_emptyContainerFeedbackTile.onUnregister();
			removeChild(this.m_emptyContainerFeedbackTile);
			this.m_emptyContainerFeedbackTile = null;
		}
		;
	}

	public function onReloadData(_arg_1:MenuElementBase, _arg_2:Object):void {
		if (!this.m_bValidContent) {
			return;
		}
		;
		var _local_3:int = m_children.indexOf(_arg_1);
		if (_local_3 == this.m_elementIndex) {
			Log.info(Log.ChannelContainer, this, ("updating large tile data from element " + this.m_elementIndex));
			this.m_selectedItemTile.visible = true;
			this.m_selectedItemTile.onSetData(_arg_2);
		}
		;
	}

	public function onItemSelected(_arg_1:Object, _arg_2:BitmapData):void {
		if (!this.m_bValidContent) {
			return;
		}
		;
		this.m_selectedItemTile.visible = true;
		this.m_selectedItemTile.onItemSelectionChanged(_arg_1, _arg_2);
	}

	public function onImageLoaded(_arg_1:BitmapData):void {
		if (!this.m_bValidContent) {
			return;
		}
		;
		this.m_selectedItemTile.setImageFrom(_arg_1);
	}

	public function onItemUnselected():void {
		if (!this.m_bValidContent) {
			return;
		}
		;
		this.m_selectedItemTile.onItemUnselected();
	}

	public function onSelectedItemRollOver():void {
		if (!this.m_bValidContent) {
			return;
		}
		;
		this.selectChildWithMouseEvent(this.m_elementIndex);
	}

	override public function addChild2(_arg_1:Sprite, _arg_2:int = -1):void {
		super.addChild2(_arg_1, _arg_2);
		this.m_childrenOffset.push(false);
	}

	override public function repositionChild(_arg_1:Sprite):void {
		super.repositionChild(_arg_1);
		this.m_scrollMaxBounds = getVisibleContainerBounds();
	}

	override public function setFocusTarget(target:Sprite):void {
		if (!this.m_bValidContent) {
			return;
		}
		;
		var elementIndex:int = m_children.indexOf(target);
		if (this.focusedElementIndex != elementIndex) {
			this.SetFocusedElementIndex(elementIndex);
		}
		;
		var scrollTime:Number = MenuConstants.ScrollTime;
		if (((this.m_nextElementIndexFromEdgeScroll >= 0) && (this.m_nextElementIndexFromEdgeScroll == this.m_elementIndex))) {
			scrollTime = MenuConstants.ChallengeEdgeScrollTime;
		} else {
			this.m_currentHoverIndex = -1;
		}
		;
		this.m_nextElementIndexFromEdgeScroll = -1;
		var elementWasOffset:Boolean = this.m_childrenOffset[this.m_elementIndex];
		this.resetTileOffsets();
		var menuElem:MenuElementBase = (target as MenuElementBase);
		var targetBounds:Rectangle = getMenuElementBounds(menuElem, this, function (_arg_1:MenuElementBase):Boolean {
			return (_arg_1.visible);
		});
		if (this.m_prevNextHandles != null) {
			this.m_prevNextHandles.onSetFocusAfterChildren(targetBounds, this.m_scrollMaxBounds, scrollTime);
		}
		;
		var scrollBounds:Rectangle = getScrollBounds();
		if (isVertical()) {
			targetBounds.height = scrollBounds.height;
		} else {
			targetBounds.width = scrollBounds.width;
		}
		;
		scrollToBounds(targetBounds, scrollTime);
		this.setTileOffsets(this.m_elementIndex);
	}

	override protected function updateChildrenVisibility(_arg_1:Boolean, _arg_2:Rectangle = null):void {
		var _local_4:Number;
		var _local_5:Number;
		_arg_2 = null;
		var _local_3:Rectangle;
		if (m_visibilityArea != null) {
			_local_3 = m_visibilityArea.clone();
		} else {
			_local_4 = getWidth();
			_local_3 = new Rectangle(0, 0, _local_4, getHeight());
			_local_5 = Math.max(((this.m_visibleLocalWidth - _local_4) / 2), 0);
			_local_3.inflate(_local_5, 0);
		}
		;
		if (!_arg_1) {
			_local_3.width = (_local_3.width - MenuConstants.GridUnitWidth);
		}
		;
		updateChildrenVisibiltyOnRect(_local_3, _arg_1, _arg_2);
		if (this.m_isDirty) {
			this.m_isDirty = false;
			if (!ControlsMain.isVrModeActive()) {
				System.gc();
			}
			;
		}
		;
	}

	override protected function setElementVisibility(_arg_1:Boolean, _arg_2:MenuElementBase, _arg_3:Boolean):void {
		super.setElementVisibility(_arg_1, _arg_2, _arg_3);
		var _local_4:IImageContainer = (_arg_2 as IImageContainer);
		if (_local_4 == null) {
			return;
		}
		;
		if (_local_4.isImageLoaded() == _arg_3) {
			return;
		}
		;
		this.m_isDirty = true;
		if (_arg_3) {
			_local_4.loadImage();
		} else {
			_local_4.unloadImage();
		}
		;
	}

	override public function handleEvent(_arg_1:String, _arg_2:Sprite):Boolean {
		if (_arg_1 == "itemHoverOn") {
			this.doMouseEdgeScroll(_arg_2);
			return (true);
		}
		;
		return (super.handleEvent(_arg_1, _arg_2));
	}

	override public function handleMouseUp(_arg_1:Function, _arg_2:MouseEvent):void {
		var _local_4:Boolean;
		Log.mouse(this, _arg_2);
		if (this.m_prevNextHandles != null) {
			if (this.m_prevNextHandles.handleMouseUp(_arg_1, _arg_2)) {
				return;
			}
			;
		}
		;
		var _local_3:Sprite = ((this.hasValidContent()) ? this.m_selectedItemTile : this.m_emptyContainerFeedbackTile);
		if (_local_3 != null) {
			_local_4 = _local_3.hitTestPoint(_arg_2.stageX, _arg_2.stageY, false);
			if (!_local_4) {
				return;
			}
			;
		}
		;
		super.handleMouseUp(_arg_1, _arg_2);
	}

	override public function handleMouseRollOver(_arg_1:Function, _arg_2:MouseEvent):void {
		super.handleMouseRollOver(_arg_1, _arg_2);
		if (!this.m_mouseEdgeScrollActivated) {
			this.checkMouseEdgeScrollActivation();
		}
		;
	}

	override public function handleMouseWheel(_arg_1:Function, _arg_2:MouseEvent):void {
		if (_arg_2.delta == 0) {
			return;
		}
		;
		_arg_2.stopImmediatePropagation();
		if (!this.m_bValidContent) {
			return;
		}
		;
		var _local_3:int = ((_arg_2.delta > 0) ? (this.m_elementIndex - 1) : (this.m_elementIndex + 1));
		this.selectChildWithMouseEvent(_local_3);
	}

	private function doMouseEdgeScroll(target:Sprite):void {
		if (m_sendEventWithValue == null) {
			return;
		}
		;
		if (!this.m_bValidContent) {
			return;
		}
		;
		if (!this.m_mouseEdgeScrollActivated) {
			this.checkMouseEdgeScrollActivation();
			return;
		}
		;
		var menuElem:MenuElementBase = (target as MenuElementBase);
		var targetBounds:Rectangle = getMenuElementBounds(menuElem, this, function (_arg_1:MenuElementBase):Boolean {
			return (_arg_1.visible);
		});
		var scrollBounds:Rectangle = getScrollBounds();
		targetBounds.y = scrollBounds.y;
		if (scrollBounds.containsRect(targetBounds)) {
			return;
		}
		;
		var hoverIndex:int = m_children.indexOf(target);
		if (hoverIndex == this.m_currentHoverIndex) {
			return;
		}
		;
		this.m_currentHoverIndex = hoverIndex;
		if ((((hoverIndex == this.m_elementIndex) || (hoverIndex < 0)) || (hoverIndex >= m_children.length))) {
			return;
		}
		;
		this.m_nextElementIndexFromEdgeScroll = ((hoverIndex > this.m_elementIndex) ? (this.m_elementIndex + 1) : (this.m_elementIndex - 1));
		this.selectChildWithMouseEvent(this.m_nextElementIndexFromEdgeScroll);
	}

	public function selectChildWithMouseEvent(_arg_1:int):void {
		if (((_arg_1 < 0) || (_arg_1 >= m_children.length))) {
			return;
		}
		;
		var _local_2:MenuElementBase = (m_children[_arg_1] as MenuElementBase);
		var _local_3:MouseEvent = new MouseEvent(MouseEvent.MOUSE_UP);
		_local_2.handleMouseUp(m_sendEventWithValue, _local_3);
	}

	private function checkMouseEdgeScrollActivation():void {
		if (this.m_mouseEdgeScrollActivated) {
			return;
		}
		;
		var _local_1:Point = new Point(stage.mouseX, stage.mouseY);
		var _local_2:Rectangle = getScrollBounds();
		var _local_3:Point = globalToLocal(_local_1);
		if (_local_2.containsPoint(_local_3)) {
			this.m_mouseEdgeScrollActivated = true;
		}
		;
	}

	private function resetTileOffsets():void {
		var _local_1:int;
		var _local_2:Sprite;
		_local_1 = 0;
		while (_local_1 < m_children.length) {
			if (this.m_childrenOffset[_local_1]) {
				_local_2 = m_children[_local_1];
				_local_2.x = (_local_2.x - MenuConstants.GridUnitWidth);
				this.m_childrenOffset[_local_1] = false;
			}
			;
			_local_1++;
		}
		;
	}

	private function setTileOffsets(_arg_1:int):void {
		var _local_2:int;
		var _local_3:Sprite;
		_local_2 = _arg_1;
		while (_local_2 < m_children.length) {
			if (!this.m_childrenOffset[_local_2]) {
				_local_3 = m_children[_local_2];
				_local_3.x = (_local_3.x + MenuConstants.GridUnitWidth);
				this.m_childrenOffset[_local_2] = true;
			}
			;
			_local_2++;
		}
		;
	}

	override protected function onScreenResize(_arg_1:ScreenResizeEvent):void {
		super.onScreenResize(_arg_1);
		this.updateVisibleWidth(_arg_1.screenSize.sizeX, _arg_1.screenSize.sizeY);
		this.updateChildrenVisibility(true);
	}

	private function updateVisibleWidth(_arg_1:Number, _arg_2:Number):void {
		if (_arg_2 <= 0) {
			_arg_2 = 1;
		}
		;
		var _local_3:Number = (MenuConstants.BaseHeight / _arg_2);
		this.m_visibleLocalWidth = (_arg_1 * _local_3);
	}

	private function SetFocusedElementIndex(_arg_1:int):void {
		var _local_2:ThumbnailItemTile = (m_children[_arg_1] as ThumbnailItemTile);
		if (this.m_currentFocusedElement != _local_2) {
			if (this.m_currentFocusedElement != null) {
				this.m_currentFocusedElement.setFocusedOnParentList(false);
			}
			;
			if (_local_2 != null) {
				_local_2.setFocusedOnParentList(true);
			}
			;
			this.m_currentFocusedElement = _local_2;
		}
		;
		this.m_elementIndex = _arg_1;
	}


}
}//package menu3.containers

