// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.containers.NewItemsContainer

package menu3.containers {
import flash.display.Sprite;

import common.Animate;

import flash.geom.Rectangle;

import menu3.MenuElementBase;

import flash.events.Event;
import flash.geom.Point;
import flash.external.ExternalInterface;

import menu3.basic.ObjectiveTile;

public dynamic class NewItemsContainer extends ListContainer {

	private const ANI_STATE_STOP:int = -1;
	private const ANI_STATE_START:int = 0;
	private const ANI_STATE_WAIT:int = 1;
	private const ANI_STATE_MOVE_OLD_ITEMS:int = 2;
	private const ANI_STATE_FADE_NEW_ITEMS:int = 3;

	private var m_itemNewFlagPropertyName:String;
	private var m_startDelay:Number = 0;
	private var m_newItems:Array = new Array();
	private var m_newItemsBound:Array = new Array();
	private var m_currentAnimationState:int = -1;
	private var m_lastAnimationState:int = -1;
	private var m_fadeInAscending:Boolean = false;
	private var m_animate:Boolean = true;
	private var m_doMoveAnimationChildIndex:Array = new Array();
	private var m_originalPositions:Array = new Array();
	private var m_originalContainerPlaceholder:Sprite = null;
	private var delayCount:Number = 0;

	public function NewItemsContainer(_arg_1:Object) {
		super(_arg_1);
		if (_arg_1.itemNewFlagPropertyName != null) {
			this.m_itemNewFlagPropertyName = _arg_1.itemNewFlagPropertyName;
		}
		;
		if (_arg_1.startDelay != null) {
			this.m_startDelay = _arg_1.startDelay;
		}
		;
		if (_arg_1.fadeInOrder == "ascending") {
			this.m_fadeInAscending = true;
		}
		;
		if (_arg_1.animate != null) {
			this.m_animate = _arg_1.animate;
		}
		;
	}

	override public function onUnregister():void {
		var _local_1:int;
		if (this.m_currentAnimationState != this.ANI_STATE_STOP) {
			this.stopAnim();
			Animate.kill(this);
			_local_1 = 0;
			while (_local_1 < m_children.length) {
				Animate.kill(m_children[_local_1]);
				_local_1++;
			}
			;
			_local_1 = 0;
			while (_local_1 < this.m_newItems.length) {
				Animate.kill(this.m_newItems[_local_1]);
				_local_1++;
			}
			;
		}
		;
		super.onUnregister();
	}

	override public function addChild2(element:Sprite, index:int = -1):void {
		var elementBounds:Rectangle;
		var isNew:Boolean;
		super.addChild2(element, index);
		if (this.m_animate) {
			element.alpha = 0;
		}
		;
		var menuElement:MenuElementBase = (element as MenuElementBase);
		if (menuElement == null) {
			return;
		}
		;
		var elementData:Object = menuElement.getData();
		if (elementData == null) {
			return;
		}
		;
		if (((!(this.m_itemNewFlagPropertyName == null)) && (this.m_itemNewFlagPropertyName.length > 0))) {
			if ((this.m_itemNewFlagPropertyName in elementData)) {
				isNew = elementData[this.m_itemNewFlagPropertyName];
				if (isNew) {
					if (!this.m_animate) {
						this.onComplete(menuElement);
					}
					;
					if (this.m_fadeInAscending) {
						this.m_newItems.push(menuElement);
					} else {
						this.m_newItems.unshift(menuElement);
					}
					;
					elementBounds = getMenuElementBounds(menuElement, this, function (_arg_1:MenuElementBase):Boolean {
						return (_arg_1.visible);
					});
					if (this.m_fadeInAscending) {
						this.m_newItemsBound.push(elementBounds);
					} else {
						this.m_newItemsBound.unshift(elementBounds);
					}
					;
				}
				;
			}
			;
		}
		;
	}

	override public function onChildrenChanged():void {
		var _local_1:Rectangle;
		super.onChildrenChanged();
		if (this.m_animate) {
			_local_1 = getVisibleContainerBounds();
			if (this.m_originalContainerPlaceholder == null) {
				this.m_originalContainerPlaceholder = new Sprite();
				getView().addChild(this.m_originalContainerPlaceholder);
			} else {
				this.m_originalContainerPlaceholder.graphics.clear();
			}
			;
			this.m_originalContainerPlaceholder.graphics.beginFill(0, 0);
			this.m_originalContainerPlaceholder.graphics.lineStyle(0, 0, 0);
			this.m_originalContainerPlaceholder.graphics.drawRect(_local_1.x, _local_1.y, _local_1.width, _local_1.height);
			if (this.m_currentAnimationState != this.ANI_STATE_START) {
				this.startAnim();
			}
			;
		} else {
			if (this.m_originalContainerPlaceholder != null) {
				getView().removeChild(this.m_originalContainerPlaceholder);
				this.m_originalContainerPlaceholder = null;
			}
			;
		}
		;
	}

	private function startAnim():void {
		getContainer().addEventListener(Event.ENTER_FRAME, this.updateAnimation);
		this.setAnimationState(this.ANI_STATE_START);
	}

	private function stopAnim():void {
		getContainer().removeEventListener(Event.ENTER_FRAME, this.updateAnimation);
	}

	private function setAnimationState(state:int, delay:Number = 0):void {
		if (delay <= 0) {
			this.m_currentAnimationState = state;
			return;
		}
		;
		Animate.kill(this);
		Animate.delay(this, delay, function ():void {
			m_currentAnimationState = state;
		});
	}

	private function updateAnimation(_arg_1:Event):void {
		var _local_2:Number;
		var _local_3:Number;
		var _local_4:int;
		var _local_5:Number;
		var _local_6:int;
		var _local_7:MenuElementBase;
		var _local_8:Number;
		var _local_9:int;
		var _local_10:Number;
		var _local_11:MenuElementBase;
		if (this.m_currentAnimationState == this.m_lastAnimationState) {
			return;
		}
		;
		this.m_lastAnimationState = this.m_currentAnimationState;
		if (this.m_currentAnimationState == this.ANI_STATE_START) {
			this.initializeAnimation();
			this.setAnimationState(this.ANI_STATE_WAIT, this.m_startDelay);
		} else {
			if (this.m_currentAnimationState == this.ANI_STATE_WAIT) {
				_local_2 = 0.5;
				this.setAnimationState(this.ANI_STATE_MOVE_OLD_ITEMS, _local_2);
			} else {
				if (this.m_currentAnimationState == this.ANI_STATE_MOVE_OLD_ITEMS) {
					_local_3 = 0.5;
					_local_4 = 0;
					while (_local_4 < this.m_doMoveAnimationChildIndex.length) {
						_local_6 = this.m_doMoveAnimationChildIndex[_local_4];
						_local_7 = m_children[_local_6];
						this.startMoveAnimation(_local_7, this.m_originalPositions[_local_6], _local_3);
						_local_4++;
					}
					;
					_local_5 = ((this.m_doMoveAnimationChildIndex.length > 0) ? (_local_3 - 0.25) : 0);
					this.setAnimationState(this.ANI_STATE_FADE_NEW_ITEMS, _local_5);
				} else {
					if (this.m_currentAnimationState == this.ANI_STATE_FADE_NEW_ITEMS) {
						_local_8 = 0.5;
						_local_9 = 0;
						while (_local_9 < this.m_newItems.length) {
							_local_11 = this.m_newItems[_local_9];
							this.startFadeInAnimation(_local_11, this.m_newItemsBound[_local_9], (_local_8 - 0.2));
							_local_9++;
						}
						;
						_local_10 = ((this.m_newItems.length > 0) ? _local_8 : 0);
						this.setAnimationState(this.ANI_STATE_STOP, _local_10);
					} else {
						if (this.m_currentAnimationState == this.ANI_STATE_STOP) {
							this.stopAnim();
						}
						;
					}
					;
				}
				;
			}
			;
		}
		;
	}

	private function initializeAnimation():void {
		var _local_3:Sprite;
		var _local_4:int;
		var _local_5:Boolean;
		var _local_6:MenuElementBase;
		var _local_7:Rectangle;
		var _local_1:Point = new Point();
		var _local_2:int;
		while (_local_2 < m_children.length) {
			_local_3 = m_children[_local_2];
			this.m_originalPositions.push(new Point(_local_3.x, _local_3.y));
			_local_4 = this.m_newItems.indexOf(_local_3);
			_local_5 = (_local_4 >= 0);
			if (_local_5) {
				_local_3.alpha = 0;
				_local_6 = this.m_newItems[_local_4];
				_local_7 = this.m_newItemsBound[_local_4];
				if (this.isDirectionHorizontal()) {
					_local_1.x = (_local_1.x + _local_7.width);
				} else {
					_local_1.y = (_local_1.y + _local_7.height);
				}
				;
			} else {
				_local_3.alpha = 1;
			}
			;
			if (((!(_local_5)) && ((_local_1.x > 0) || (_local_1.y > 0)))) {
				_local_3.x = (_local_3.x - _local_1.x);
				_local_3.y = (_local_3.y - _local_1.y);
				this.m_doMoveAnimationChildIndex.push(_local_2);
			}
			;
			_local_2++;
		}
		;
	}

	private function startMoveAnimation(_arg_1:MenuElementBase, _arg_2:Point, _arg_3:Number):void {
		Animate.kill(_arg_1);
		Animate.legacyTo(_arg_1, _arg_3, {
			"x": _arg_2.x,
			"y": _arg_2.y
		}, Animate.ExpoInOut);
	}

	private function startFadeInAnimation(menuElement:MenuElementBase, elementBounds:Rectangle, animationDuration:Number):void {
		var xEndPos:Number;
		var yEndPos:Number;
		var/*const*/ SCALE_FACTOR:Number = 0.1;
		var xOffset:Number = (((elementBounds.width * SCALE_FACTOR) - elementBounds.width) / 2);
		var yOffset:Number = (((elementBounds.height * SCALE_FACTOR) - elementBounds.height) / 2);
		xEndPos = elementBounds.x;
		yEndPos = elementBounds.y;
		menuElement.scaleX = SCALE_FACTOR;
		menuElement.scaleY = SCALE_FACTOR;
		menuElement.x = (xEndPos - xOffset);
		menuElement.y = (yEndPos - yOffset);
		Animate.delay(menuElement, this.delayCount, function ():void {
			playSound("Objectives_PopUp");
			Animate.to(menuElement, animationDuration, 0, {
				"x": xEndPos,
				"y": yEndPos,
				"scaleX": 1,
				"scaleY": 1,
				"alpha": 1
			}, Animate.ExpoOut, onComplete, menuElement);
		});
		this.delayCount = (this.delayCount + 0.15);
	}

	public function playSound(_arg_1:String):void {
		ExternalInterface.call("PlaySound", _arg_1);
	}

	private function onComplete(_arg_1:Object):void {
		ObjectiveTile(_arg_1).showConditions(ObjectiveTile.TILETYPE_NEW);
	}

	private function isDirectionHorizontal():Boolean {
		return (m_direction == "horizontal");
	}


}
}//package menu3.containers

