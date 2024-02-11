// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.containers.ScrollingCreditsListContainer

package menu3.containers {
import __AS3__.vec.Vector;

import menu3.Credits;

import flash.display.Sprite;
import flash.geom.Point;
import flash.events.Event;
import flash.utils.getTimer;

import common.menu.MenuConstants;

import menu3.MenuElementBase;

import flash.geom.Rectangle;

import common.Log;

import flash.events.MouseEvent;

import __AS3__.vec.*;

public dynamic class ScrollingCreditsListContainer extends ScrollingListContainer {

	private const SCROLL_SPEED_EPSILON:Number = 100;
	private const INITIAL_SCROLL_SPEED:Number = 100;
	private const SCROLL_ACCELERATION:Number = 100;
	private var m_bIsInitialsed:Boolean = false;
	private var m_lastFrameTime:int = 0;
	private var m_currentScrollSpeed:Number = 0;
	private var m_currentScrollDirection:int = 0;
	private var m_initialPosition:Number = 0;
	private var m_bChildrenChanged:Boolean = true;
	private var m_height:int = -1;
	private var m_scrollPos:Number = 0;
	private var m_counter:int = 0;

	private var m_elements:Vector.<Credits> = new Vector.<Credits>();
	private var m_visibleElements:Vector.<int> = new Vector.<int>();
	private var m_creditsMask:Sprite = new Sprite();
	private var m_clickArea:Sprite = new Sprite();
	private const SCROLL_SPEED_RANGE:Point = new Point(-1000, 1000);

	public function ScrollingCreditsListContainer(_arg_1:Object) {
		super(_arg_1);
		m_alwaysClampToMaxBounds = false;
		this.m_currentScrollSpeed = this.INITIAL_SCROLL_SPEED;
		this.m_initialPosition = getScrollBounds().height;
		getContainer().y = this.m_initialPosition;
		addChild(this.m_clickArea);
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		this.startAnim();
	}

	public function startAnim():void {
		getContainer().addEventListener(Event.ENTER_FRAME, this.update);
		this.m_lastFrameTime = getTimer();
	}

	public function stopAnim():void {
		getContainer().removeEventListener(Event.ENTER_FRAME, this.update);
	}

	private function update(_arg_1:Event):void {
		if (this.m_bChildrenChanged) {
			this.m_bChildrenChanged = false;
			this.collectAllCreditsElements(this, this.m_elements);
		}
		;
		var _local_2:int = getTimer();
		var _local_3:Number = ((_local_2 - this.m_lastFrameTime) * 0.001);
		this.m_lastFrameTime = _local_2;
		this.m_currentScrollSpeed = (this.m_currentScrollSpeed + (this.m_currentScrollDirection * this.SCROLL_ACCELERATION));
		if (this.m_currentScrollSpeed < this.SCROLL_SPEED_RANGE.x) {
			this.m_currentScrollSpeed = this.SCROLL_SPEED_RANGE.x;
		}
		;
		if (this.m_currentScrollSpeed > this.SCROLL_SPEED_RANGE.y) {
			this.m_currentScrollSpeed = this.SCROLL_SPEED_RANGE.y;
		}
		;
		if (((this.m_currentScrollDirection == 0) && (Math.abs(this.m_currentScrollSpeed) < this.SCROLL_SPEED_EPSILON))) {
			this.m_currentScrollSpeed = 0;
		}
		;
		this.m_currentScrollDirection = 0;
		var _local_4:Sprite = getContainer();
		this.m_scrollPos = (this.m_scrollPos - (_local_3 * this.m_currentScrollSpeed));
		if (this.m_scrollPos < -(this.m_height)) {
			trace(((this.m_scrollPos + " < ") + -(this.m_height)));
			this.m_scrollPos = this.m_initialPosition;
		}
		;
		if (this.m_scrollPos > this.m_initialPosition) {
			this.m_scrollPos = -(this.m_height);
		}
		;
		var _local_5:Number = (Math.round((this.m_scrollPos * 20)) * 0.05);
		_local_4.y = (_local_5 + 0.001);
		if (this.m_counter > 0) {
			this.m_counter--;
			return;
		}
		;
		this.m_counter = 5;
		this.detectElementsVisibility();
	}

	private function detectElementsVisibility():void {
		var _local_1:int;
		if (this.m_visibleElements.length == 0) {
			_local_1 = 0;
			while (_local_1 < this.m_elements.length) {
				if (this.trySetVisible(this.m_elements[_local_1])) {
					this.m_visibleElements.push(_local_1);
				}
				;
				_local_1++;
			}
			;
			return;
		}
		;
		_local_1 = ((this.m_visibleElements[0] > 0) ? (this.m_visibleElements[0] - 1) : (this.m_elements.length - 1));
		if (this.trySetVisible(this.m_elements[_local_1])) {
			this.m_visibleElements.splice(0, 0, _local_1);
		}
		;
		_local_1 = ((this.m_visibleElements[(this.m_visibleElements.length - 1)] < (this.m_elements.length - 1)) ? (this.m_visibleElements[(this.m_visibleElements.length - 1)] + 1) : 0);
		if (this.trySetVisible(this.m_elements[_local_1])) {
			this.m_visibleElements.push(_local_1);
		}
		;
		_local_1 = (this.m_visibleElements.length - 1);
		while (_local_1 >= 0) {
			if (!this.trySetVisible(this.m_elements[this.m_visibleElements[_local_1]])) {
				this.m_visibleElements.splice(_local_1, 1);
			}
			;
			_local_1--;
		}
		;
	}

	private function trySetVisible(_arg_1:Credits):Boolean {
		var _local_2:Number = (getContainer().y * -1);
		var _local_3:Number = _local_2;
		var _local_4:Number = (_local_3 + MenuConstants.BaseHeight);
		var _local_5:Number = _arg_1.y;
		var _local_6:Number = (_local_5 + _arg_1.getCreditsHeight());
		var _local_7:Boolean = ((_local_5 <= _local_4) && (_local_6 >= _local_3));
		if (_local_7 != _arg_1.visible) {
			_arg_1.setCreditsVisible(_local_7);
		}
		;
		return (_local_7);
	}

	private function createClickArea():void {
		this.m_clickArea.graphics.clear();
		this.m_clickArea.graphics.beginFill(0xFF0000, 0);
		this.m_clickArea.graphics.drawRect(0, 0, getWidth(), getHeight());
		this.m_clickArea.graphics.endFill();
	}

	override protected function onAddedToStage(_arg_1:Event):void {
		super.onAddedToStage(_arg_1);
		if (this.m_elements.length > 0) {
			return;
		}
		;
		this.m_scrollPos = getContainer().y;
		this.createClickArea();
	}

	override public function onChildrenChanged():void {
		this.m_bChildrenChanged = true;
	}

	private function collectAllCreditsElements(_arg_1:MenuElementBase, _arg_2:Vector.<Credits>):void {
		var _local_4:MenuElementBase;
		var _local_5:Credits;
		this.m_height = 0;
		var _local_3:int;
		while (_local_3 < _arg_1.m_children.length) {
			_local_4 = (_arg_1.m_children[_local_3] as MenuElementBase);
			if (_local_4 != null) {
				_local_5 = (_local_4 as Credits);
				if (_local_5 != null) {
					_arg_2.push(_local_5);
					_local_5.y = this.m_height;
					this.m_height = (this.m_height + _local_5.getCreditsHeight());
				} else {
					trace("Non-credits child found in ScrollingCreditsListContainer");
				}
				;
			}
			;
			_local_3++;
		}
		;
		recalculateTotalBounds();
	}

	override protected function scrollToBoundsInternal(_arg_1:Rectangle, _arg_2:Number, _arg_3:Boolean):Boolean {
		return (false);
	}

	override public function onScroll(_arg_1:int):void {
		super.onScroll(_arg_1);
		this.m_currentScrollDirection = _arg_1;
	}

	override public function onUnregister():void {
		this.stopAnim();
	}

	override public function handleMouseWheel(_arg_1:Function, _arg_2:MouseEvent):void {
		Log.mouse(this, _arg_2);
		if (_arg_2.delta == 0) {
			return;
		}
		;
		_arg_2.stopImmediatePropagation();
		var _local_3:int = ((_arg_2.delta > 0) ? -1 : 1);
		this.onScroll(_local_3);
	}

	override public function addChild2(_arg_1:Sprite, _arg_2:int = -1):void {
		_arg_1.visible = false;
		super.addChild2(_arg_1, _arg_2);
	}

	override public function getVisibleContainerBounds():Rectangle {
		return (new Rectangle(0, 0, 1000, this.m_height));
	}

	override public function repositionChild(_arg_1:Sprite):void {
	}


}
}//package menu3.containers

