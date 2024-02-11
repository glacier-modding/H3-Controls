// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.modal.ModalScrollingContainer

package menu3.modal {
import flash.display.Sprite;
import flash.geom.Point;
import flash.geom.Rectangle;

import common.menu.MenuUtils;
import common.menu.MenuConstants;

import flash.events.MouseEvent;
import flash.display.DisplayObject;

import common.Animate;

import flash.text.TextField;
import flash.text.AntiAliasType;

public class ModalScrollingContainer extends Sprite {

	private var m_container:Sprite;
	private var m_clickArea:Sprite;
	private var m_entries:Array;
	private var m_totalHeight:Number;
	private var m_visibleArea:Number;
	private var m_currentIndex:int;
	private var m_scrollBar:ModalDialogScrollIndicatorVerticalView;
	private var m_scrollBarSafeWidth:Number;
	private var m_useMask:Boolean = false;
	private var m_mask:Sprite = null;
	private var m_listGradientT:*;
	private var m_listGradientB:*;
	private var m_listWidth:Number;
	private var m_scrollDist:Number = 28.963;
	public var margin:Number = 60;
	private var m_gap:Number = 20;
	private var m_mouseDragPos:Point;
	private var m_isMouseDragActive:Boolean;
	private var m_dragAreaScrollBarV:Rectangle;
	private var m_clickAreaScrollBarV:Rectangle;

	public function ModalScrollingContainer(_arg_1:Number, _arg_2:Number, _arg_3:Number = 0, _arg_4:Boolean = false, _arg_5:String = "default") {
		this.m_visibleArea = _arg_2;
		this.m_listWidth = _arg_1;
		this.m_scrollBarSafeWidth = _arg_3;
		this.m_useMask = _arg_4;
		if (_arg_5 == "targetobjectives") {
			this.m_listGradientT = new ModalDialogScrollingListGradientTargetView();
			this.m_listGradientB = new ModalDialogScrollingListGradientTargetView();
		} else {
			this.m_listGradientT = new ModalDialogScrollingListGradientView();
			this.m_listGradientB = new ModalDialogScrollingListGradientView();
		}

		this.m_listGradientT.width = (this.m_listGradientB.width = (this.m_listWidth - this.m_scrollBarSafeWidth));
		this.m_listGradientT.height = (this.m_listGradientB.height = this.m_scrollDist);
		this.m_listGradientT.y = -1;
		this.m_listGradientB.rotation = 180;
		this.m_listGradientB.x = (this.m_listWidth - this.m_scrollBarSafeWidth);
		this.m_listGradientB.y = (this.m_visibleArea + 1);
		this.m_listGradientT.alpha = (this.m_listGradientB.alpha = 0);
		this.m_scrollBar = new ModalDialogScrollIndicatorVerticalView();
		this.m_scrollBar.x = (_arg_1 - 7);
		this.m_scrollBar.visible = false;
		MenuUtils.setColor(this.m_scrollBar.indicator, MenuConstants.COLOR_RED, true, MenuConstants.MenuElementSelectedAlpha);
		MenuUtils.setColor(this.m_scrollBar.indicatorbg, MenuConstants.COLOR_MENU_BUTTON_TILE_DESELECTED, true, MenuConstants.MenuElementBackgroundAlpha);
		this.m_entries = [];
		this.m_currentIndex = 0;
		this.m_container = new Sprite();
		addChild(this.m_container);
		this.m_clickArea = new Sprite();
		this.m_container.addChild(this.m_clickArea);
		addChild(this.m_listGradientT);
		addChild(this.m_listGradientB);
		addChild(this.m_scrollBar);
		this.m_totalHeight = 0;
		addEventListener(MouseEvent.MOUSE_DOWN, this.handleMouseDown);
	}

	public function onUnregister():void {
		if (this.m_isMouseDragActive) {
			this.handleDragEnd(new MouseEvent(MouseEvent.MOUSE_UP));
		}

		removeEventListener(MouseEvent.MOUSE_DOWN, this.handleMouseDown);
	}

	public function addGap(_arg_1:Number):void {
		this.m_totalHeight = (this.m_totalHeight + _arg_1);
	}

	public function append(_arg_1:DisplayObject, _arg_2:Boolean, _arg_3:Number, _arg_4:Boolean):void {
		var _local_5:String = ((_arg_4) ? "large" : "small");
		this.appendEntry(_arg_1, _arg_2, _arg_3, _local_5);
	}

	public function appendEntry(_arg_1:DisplayObject, _arg_2:Boolean, _arg_3:Number, _arg_4:String = "default", _arg_5:String = "small"):void {
		var _local_6:Number;
		var _local_7:Number;
		var _local_8:Boolean;
		if (_arg_1) {
			this.m_container.addChild(_arg_1);
			_local_6 = ((_arg_3) ? _arg_3 : _arg_1.height);
			_local_7 = (Math.ceil((_local_6 / this.m_scrollDist)) * this.m_scrollDist);
			if (_arg_4 == "default") {
				_arg_1.y = this.m_totalHeight;
				this.m_totalHeight = (this.m_totalHeight + _local_6);
			} else {
				_arg_1.y = (this.m_totalHeight + ((_local_7 - _local_6) / 2));
				this.m_totalHeight = (this.m_totalHeight + _local_7);
			}

			_local_8 = (this.m_totalHeight > this.m_visibleArea);
			this.m_scrollBar.visible = _local_8;
			this.setScrollPosition(this.getScrollPosition(), false, true);
			if ((((_local_8) && (this.m_useMask)) && (this.m_mask == null))) {
				this.createMask();
			}

			this.m_clickArea.graphics.clear();
			this.m_clickArea.graphics.beginFill(113407, 0);
			this.m_clickArea.graphics.moveTo(0, 0);
			this.m_clickArea.graphics.lineTo(this.m_listWidth, 0);
			this.m_clickArea.graphics.lineTo(this.m_listWidth, this.m_totalHeight);
			this.m_clickArea.graphics.lineTo(0, this.m_totalHeight);
		}

	}

	public function setEntrySelected(_arg_1:int, _arg_2:Boolean):void {
		var _local_3:Object;
		var _local_4:Number;
		this.m_entries[_arg_1].object.setItemSelected(_arg_2);
		if (_arg_2) {
			_local_3 = this.m_entries[_arg_1];
			_local_4 = this.getScrollPosition();
			if (_local_4 > (_local_3.y - this.margin)) {
				_local_4 = (_local_3.y - this.margin);
			} else {
				if (_local_4 < (((_local_3.y + _local_3.height) + this.margin) - this.m_visibleArea)) {
					_local_4 = (((_local_3.y + _local_3.height) + this.margin) - this.m_visibleArea);
				}

			}

			this.setScrollPosition(_local_4, true, true);
		}

	}

	public function onEntryPressed(_arg_1:int, _arg_2:Boolean = false):void {
		this.m_entries[_arg_1].object.itemPressed(_arg_2);
	}

	public function scroll(_arg_1:Number, _arg_2:Boolean):void {
		this.setScrollPosition((this.getScrollPosition() - (_arg_1 * this.m_scrollDist)), _arg_2, true);
	}

	public function getScrollPosition():Number {
		return (-(this.m_container.y));
	}

	public function setScrollPosition(_arg_1:Number, _arg_2:Boolean, _arg_3:Boolean):void {
		var _local_4:Number = (this.m_totalHeight - this.m_visibleArea);
		if (_local_4 <= 0) {
			return;
		}

		var _local_5:Number = ((_arg_3) ? (this.m_scrollDist / 2) : 0);
		if (_arg_1 < _local_5) {
			_arg_1 = 0;
		} else {
			if (_arg_1 > (_local_4 - _local_5)) {
				_arg_1 = _local_4;
			}

		}

		this.showListGradientTop((_arg_1 > 5));
		this.showListGradientBottom((_arg_1 < (_local_4 - 5)));
		if (_arg_2) {
			Animate.legacyTo(this.m_container, 0.25, {"y": -(_arg_1)}, Animate.SineOut);
		} else {
			Animate.kill(this.m_container);
			this.m_container.y = -(_arg_1);
		}

		this.m_scrollBar.indicatorbg.height = this.m_visibleArea;
		var _local_6:Number = ((this.m_visibleArea / this.m_totalHeight) * 100);
		this.m_scrollBar.indicator.height = ((_local_6 * this.m_visibleArea) / 100);
		var _local_7:Number = ((_arg_1 / this.m_visibleArea) * this.m_scrollBar.indicator.height);
		if (_arg_2) {
			Animate.legacyTo(this.m_scrollBar.indicator, 0.25, {"y": _local_7}, Animate.SineOut);
		} else {
			Animate.kill(this.m_scrollBar.indicator);
			this.m_scrollBar.indicator.y = _local_7;
		}

		this.updateScrollDargAndClickArea();
	}

	private function updateScrollDargAndClickArea():void {
		this.m_dragAreaScrollBarV = this.m_scrollBar.indicator.getBounds(this);
		this.m_dragAreaScrollBarV.inflate(20, 0);
		this.m_clickAreaScrollBarV = this.m_scrollBar.indicatorbg.getBounds(this);
		this.m_clickAreaScrollBarV.inflate(20, 0);
	}

	public function getContentWidth():Number {
		return (this.m_listWidth - this.m_scrollBarSafeWidth);
	}

	public function getContentHeight():Number {
		return (this.m_totalHeight);
	}

	public function getScrollDist():Number {
		return (this.m_scrollDist);
	}

	public function onFadeInFinished():void {
		var _local_2:TextField;
		var _local_1:int;
		while (_local_1 < this.m_container.numChildren) {
			_local_2 = (this.m_container.getChildAt(_local_1) as TextField);
			if (_local_2 != null) {
				_local_2.antiAliasType = AntiAliasType.ADVANCED;
			}

			_local_1++;
		}

	}

	private function showListGradientTop(_arg_1:Boolean):void {
		Animate.kill(this.m_listGradientT);
		if (_arg_1) {
			Animate.legacyTo(this.m_listGradientT, MenuConstants.HiliteTime, {"alpha": 1}, Animate.Linear);
		} else {
			Animate.legacyTo(this.m_listGradientT, MenuConstants.HiliteTime, {"alpha": 0}, Animate.Linear);
		}

	}

	private function showListGradientBottom(_arg_1:Boolean):void {
		Animate.kill(this.m_listGradientB);
		if (_arg_1) {
			Animate.legacyTo(this.m_listGradientB, MenuConstants.HiliteTime, {"alpha": 1}, Animate.Linear);
		} else {
			Animate.legacyTo(this.m_listGradientB, MenuConstants.HiliteTime, {"alpha": 0}, Animate.Linear);
		}

	}

	private function createMask():void {
		if (this.m_mask != null) {
			return;
		}

		this.m_mask = new Sprite();
		addChild(this.m_mask);
		this.mask = this.m_mask;
		this.m_mask.graphics.clear();
		this.m_mask.graphics.beginFill(113407, 1);
		this.m_mask.graphics.moveTo(0, 0);
		this.m_mask.graphics.lineTo(this.m_listWidth, 0);
		this.m_mask.graphics.lineTo(this.m_listWidth, this.m_visibleArea);
		this.m_mask.graphics.lineTo(0, this.m_visibleArea);
		this.m_mask.graphics.endFill();
	}

	private function handleMouseDown(_arg_1:MouseEvent):void {
		var _local_5:Number;
		var _local_6:Number;
		if (!this.m_scrollBar.visible) {
			return;
		}

		var _local_2:Point = new Point(_arg_1.stageX, _arg_1.stageY);
		var _local_3:Point = globalToLocal(_local_2);
		var _local_4:Boolean;
		if (this.m_dragAreaScrollBarV.containsPoint(_local_3)) {
			_arg_1.stopImmediatePropagation();
			_local_4 = true;
		} else {
			if (this.m_clickAreaScrollBarV.containsPoint(_local_3)) {
				_arg_1.stopImmediatePropagation();
				_local_5 = ((_local_3.y < this.m_dragAreaScrollBarV.y) ? -1 : 1);
				_local_6 = ((this.m_visibleArea * _local_5) * 0.9);
				this.setScrollPosition((this.getScrollPosition() + _local_6), false, true);
				return;
			}

		}

		if (_local_4) {
			this.m_isMouseDragActive = true;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, this.handleDragMouseMove, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, this.handleDragEnd, true);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, this.handleDragEnd, true);
			this.m_mouseDragPos = _local_2;
			return;
		}

	}

	private function handleDragMouseMove(_arg_1:MouseEvent):void {
		_arg_1.stopImmediatePropagation();
		var _local_2:Point = new Point(_arg_1.stageX, _arg_1.stageY);
		var _local_3:Point = _local_2.subtract(this.m_mouseDragPos);
		this.m_mouseDragPos = _local_2;
		var _local_4:Number = this.computeGlobalToLocalScale();
		var _local_5:Number = ((this.m_totalHeight / this.m_visibleArea) * _local_4);
		this.setScrollPosition((this.getScrollPosition() + (_local_3.y * _local_5)), false, false);
	}

	private function handleDragEnd(_arg_1:MouseEvent):void {
		this.m_isMouseDragActive = false;
		_arg_1.stopImmediatePropagation();
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.handleDragMouseMove, true);
		stage.removeEventListener(MouseEvent.MOUSE_UP, this.handleDragEnd, true);
		stage.removeEventListener(MouseEvent.MOUSE_DOWN, this.handleDragEnd, true);
		this.setScrollPosition(this.getScrollPosition(), false, true);
	}

	private function computeGlobalToLocalScale():Number {
		var _local_1:Number = 100;
		var _local_2:Point = new Point(0, 0);
		var _local_3:Point = new Point(0, _local_1);
		var _local_4:Point = globalToLocal(_local_2);
		var _local_5:Point = globalToLocal(_local_3);
		var _local_6:Number = _local_5.subtract(_local_4).length;
		var _local_7:Number = (_local_6 / _local_1);
		return (_local_7);
	}


}
}//package menu3.modal

