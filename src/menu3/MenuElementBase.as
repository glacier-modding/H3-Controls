// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.MenuElementBase

package menu3 {
import flash.display.Sprite;

import common.AnimationContainerBase;

import flash.geom.Point;

import common.MouseUtil;
import common.Log;
import common.menu.MenuConstants;

import flash.geom.Rectangle;
import flash.events.MouseEvent;
import flash.display.DisplayObjectContainer;

import common.Animate;
import common.CalcUtil;

public dynamic class MenuElementBase extends Sprite implements AnimationContainerBase {

	public var m_children:Array = [];
	public var m_parent:MenuElementBase;
	public var m_name:String;
	protected var m_mouseMode:int = 0;
	protected var m_mouseWheelMode:int = 0;
	private var m_data:Object = {};
	private var m_focusIndex:int = -1;
	private var m_activePopOutScaleViewElement:Object = null;
	private var m_activePopOutScaleViewElementPaused:Object = null;
	private var m_focusPlaceholder:Sprite = new Sprite();
	private var m_isPopOutScaleActive:Boolean = false;
	private var m_popOutOriginalScale:Point;
	private var m_popOutOriginalPos:Point;
	private var m_isPopOutScaleQueued:Boolean = false;

	public function MenuElementBase(_arg_1:Object) {
		this.m_data = _arg_1;
		this.m_name = _arg_1.name;
	}

	public static function getNodeProp(_arg_1:Sprite, _arg_2:String):* {
		if (_arg_1["_nodedata"]) {
			return (_arg_1["_nodedata"][_arg_2]);
		}
		;
		return (undefined);
	}

	public static function getId(_arg_1:Sprite):int {
		if (_arg_1["_nodedata"]) {
			return (_arg_1["_nodedata"]["id"]);
		}
		;
		return (-1);
	}


	public function getView():Sprite {
		return (this);
	}

	public function hasChildren():Boolean {
		var _local_1:Boolean;
		if (this.m_children.length >= 1) {
			_local_1 = true;
		}
		;
		return (_local_1);
	}

	public function getContainer():Sprite {
		return (this);
	}

	public function onSetData(_arg_1:Object):void {
		var _local_2:int;
		var _local_3:int;
		this.m_data = _arg_1;
		this.m_name = _arg_1.name;
		if (_arg_1.mousemode != null) {
			_local_2 = MouseUtil.getModeFromName(_arg_1.mousemode);
			if (_local_2 >= 0) {
				this.m_mouseMode = _local_2;
			}
			;
		}
		;
		if (_arg_1.mousewheelmode != null) {
			Log.info(Log.ChannelMouse, this, ("Setting mouse wheel mode from data to " + _arg_1.mousewheelmode));
			_local_3 = MouseUtil.getWheelModeFromName(_arg_1.mousewheelmode);
			if (_local_3 >= 0) {
				this.m_mouseWheelMode = _local_3;
			}
			;
		}
		;
	}

	public function onUnregister():void {
		this.unsetFocusChild();
	}

	public function getPersistentReloadData():Object {
		return (null);
	}

	public function onPersistentReloadData(_arg_1:Object):void {
	}

	public function setX(_arg_1:Number):void {
		var _local_2:Object = this.getNodeData();
		_local_2.x = _arg_1;
		this.updatePosX();
	}

	public function setY(_arg_1:Number):void {
		var _local_2:Object = this.getNodeData();
		_local_2.y = _arg_1;
		this.updatePosY();
	}

	public function setCol(_arg_1:Number):void {
		Log.info(Log.ChannelDebug, this, ("setCol:" + _arg_1));
		var _local_2:Object = this.getNodeData();
		_local_2.col = _arg_1;
		this.updatePosX();
	}

	public function setRow(_arg_1:Number):void {
		Log.info(Log.ChannelDebug, this, ("setRow:" + _arg_1));
		var _local_2:Object = this.getNodeData();
		_local_2.row = _arg_1;
		this.updatePosY();
	}

	private function updatePosX():void {
		var _local_1:Object = this.getNodeData();
		if (_local_1.x) {
			this.x = _local_1.x;
		} else {
			this.x = ((_local_1.col * MenuConstants.GridUnitWidth) || (0));
		}
		;
	}

	private function updatePosY():void {
		var _local_1:Object = this.getNodeData();
		if (_local_1.y) {
			this.y = _local_1.y;
		} else {
			this.y = ((_local_1.row * MenuConstants.GridUnitHeight) || (0));
		}
		;
	}

	public function setWidth(_arg_1:Number):void {
	}

	public function setHeight(_arg_1:Number):void {
	}

	public function getWidth():Number {
		return ((this.m_data.width) || (this.width));
	}

	public function getHeight():Number {
		return ((this.m_data.height) || (this.height));
	}

	public function getData():Object {
		return (this.m_data);
	}

	public function clearChildren():void {
		this.unsetFocusChild();
		this.m_children = [];
		while (this.getContainer().numChildren > 0) {
			this.getContainer().removeChildAt(0);
		}
		;
	}

	public function addChild2(_arg_1:Sprite, _arg_2:int = -1):void {
		var _local_3:int = this.m_focusIndex;
		this.unsetFocusChild();
		if (_arg_2 == -1) {
			this.m_children.push(_arg_1);
			this.getContainer().addChild(_arg_1);
		} else {
			this.m_children.splice(_arg_2, 0, _arg_1);
			this.getContainer().addChildAt(_arg_1, _arg_2);
		}
		;
		var _local_4:MenuElementBase = (_arg_1 as MenuElementBase);
		if (_local_4) {
			_local_4.m_parent = this;
			_local_4.onAddedAsChild(_local_4);
		}
		;
		if (_local_3 >= 0) {
			if (_arg_2 == _local_3) {
				_local_3++;
			}
			;
			this.setFocusChild(_local_3);
		}
		;
	}

	public function replaceChild2(_arg_1:Sprite, _arg_2:Sprite):void {
		var _local_3:int = this.m_focusIndex;
		this.unsetFocusChild();
		var _local_4:int = this.m_children.indexOf(_arg_1);
		if (_local_4 >= 0) {
			this.removeChild2(_arg_1);
			this.addChild2(_arg_2, _local_4);
		}
		;
		var _local_5:MenuElementBase = (_arg_2 as MenuElementBase);
		if (_local_5) {
			_local_5.m_parent = this;
			_local_5.onAddedAsChild(_local_5);
		}
		;
		if (((_local_3 >= 0) && (!(_local_3 == _local_4)))) {
			this.setFocusChild(_local_3);
		}
		;
	}

	public function removeChild2(_arg_1:Sprite):void {
		var _local_2:int = this.m_focusIndex;
		this.unsetFocusChild();
		var _local_3:int = this.m_children.indexOf(_arg_1);
		if (_local_3 >= 0) {
			this.m_children.splice(_local_3, 1);
			this.getContainer().removeChild(_arg_1);
		}
		;
		if (((_local_2 >= 0) && (!(_local_2 == _local_3)))) {
			if (_local_3 < _local_2) {
				_local_2--;
			}
			;
			this.setFocusChild(_local_2);
		}
		;
	}

	public function reorderChildren(_arg_1:Array):void {
		var _local_5:MenuElementBase;
		var _local_6:int;
		Log.info(Log.ChannelDebug, this, "reorderChildren");
		var _local_2:int = this.m_focusIndex;
		this.unsetFocusChild();
		var _local_3:int;
		var _local_4:int;
		while (_local_4 < _arg_1.length) {
			_local_5 = _arg_1[_local_4];
			_local_6 = this.m_children.indexOf(_local_5);
			if (_local_6 >= 0) {
				if (_local_6 != _local_3) {
					this.m_children.splice(_local_6, 1);
					this.m_children.splice(_local_3, 0, _local_5);
					if (this.m_focusIndex == _local_6) {
						this.m_focusIndex = _local_3;
					}
					;
					this.getContainer().setChildIndex(_local_5, _local_3);
				}
				;
				_local_3++;
			} else {
				Log.error(Log.ChannelCommon, this, "reorderChildren: child not found");
			}
			;
			_local_4++;
		}
		;
		if (_local_2 >= 0) {
			this.setFocusChild(_local_2);
		}
		;
	}

	public function onAddedAsChild(_arg_1:MenuElementBase):void {
	}

	public function onChildrenChanged():void {
	}

	public function onContextActivate():void {
	}

	public function onContextDeactivate():void {
	}

	public function getChildElementIndex(_arg_1:MenuElementBase):int {
		return (this.m_children.indexOf(_arg_1));
	}

	public function getChildElementCount():int {
		return (this.m_children.length);
	}

	public function bubbleEvent(_arg_1:String, _arg_2:MenuElementBase):void {
		var _local_3:MenuElementBase = _arg_2.m_parent;
		var _local_4:DynamicMenuPage = (_local_3 as DynamicMenuPage);
		while ((((_local_3) && (_local_4 == null)) && ((!(_local_3["handleEvent"])) || (!(_local_3["handleEvent"](_arg_1, _arg_2)))))) {
			_local_3 = _local_3.m_parent;
		}
		;
	}

	public function getVisualBounds(_arg_1:MenuElementBase):Rectangle {
		var _local_2:Sprite = this.getView();
		if (_local_2 == null) {
			return (new Rectangle());
		}
		;
		return (_local_2.getBounds(_arg_1));
	}

	public function getMenuElementBounds(_arg_1:MenuElementBase, _arg_2:MenuElementBase, _arg_3:Function = null):Rectangle {
		var _local_6:MenuElementBase;
		if (!_arg_1) {
			return (new Rectangle());
		}
		;
		var _local_4:Rectangle = _arg_1.getVisualBounds(_arg_2);
		var _local_5:int;
		while (_local_5 < _arg_1.m_children.length) {
			_local_6 = (_arg_1.m_children[_local_5] as MenuElementBase);
			if (!((!(_arg_3 == null)) && (!(_arg_3(_local_6))))) {
				_local_4 = _local_4.union(this.getMenuElementBounds(_local_6, _arg_2, _arg_3));
			}
			;
			_local_5++;
		}
		;
		return (_local_4);
	}

	public function handleEvent(_arg_1:String, _arg_2:Sprite):Boolean {
		return (false);
	}

	public function setVisible(_arg_1:Object):void {
		var _local_2:Boolean = _arg_1["visible"];
		if (_local_2 != this.visible) {
			this.visible = _local_2;
			dispatchEvent(new VisibilityChangedEvent(VisibilityChangedEvent.VISIBILITY_CHANGED, _local_2));
		}
		;
	}

	private function getNodeData():Object {
		return (this["_nodedata"]);
	}

	public function setEngineCallbacks(_arg_1:Function, _arg_2:Function):void {
	}

	public function handleMouseDown(_arg_1:Function, _arg_2:MouseEvent):void {
		Log.mouse(this, _arg_2);
		_arg_2.stopImmediatePropagation();
	}

	public function handleMouseUp(_arg_1:Function, _arg_2:MouseEvent):void {
		MouseUtil.handleMouseUp(this.m_mouseMode, this, _arg_1, _arg_2);
	}

	public function handleMouseOver(_arg_1:Function, _arg_2:MouseEvent):void {
	}

	public function handleMouseOut(_arg_1:Function, _arg_2:MouseEvent):void {
		Log.mouse(this, _arg_2);
	}

	public function handleMouseRollOver(_arg_1:Function, _arg_2:MouseEvent):void {
		MouseUtil.handleMouseRollOver(this.m_mouseMode, this, _arg_1, _arg_2);
	}

	public function handleMouseRollOut(_arg_1:Function, _arg_2:MouseEvent):void {
		MouseUtil.handleMouseRollOut(this.m_mouseMode, this, _arg_1, _arg_2);
	}

	public function handleMouseWheel(_arg_1:Function, _arg_2:MouseEvent):void {
		MouseUtil.handleMouseWheel(this.m_mouseWheelMode, this, _arg_1, _arg_2);
	}

	public function triggerMouseRollOver():void {
		Log.info(Log.ChannelMouse, this, "triggerMouseRollOver");
		var _local_1:MouseEvent = new MouseEvent(MouseEvent.ROLL_OVER, true);
		this.dispatchEvent(_local_1);
	}

	public function setFocus(_arg_1:Boolean):void {
		var _local_7:MenuElementBase;
		var _local_2:Boolean = true;
		var _local_3:MenuElementBase;
		var _local_4:DisplayObjectContainer = this;
		var _local_5:MenuElementBase = (this as MenuElementBase);
		var _local_6:DisplayObjectContainer = this.parent;
		while (_local_6 != null) {
			_local_3 = (_local_6 as MenuElementBase);
			_local_7 = (_local_4 as MenuElementBase);
			if (_local_7 != null) {
				_local_5 = _local_7;
			}
			;
			if (((!(_local_3 == null)) && (!(_local_5 == null)))) {
				if (_arg_1) {
					_local_3.setFocusChildElement(_local_5);
				} else {
					_local_3.unsetFocusChildElement(_local_5);
				}
				;
				if (!_local_2) {
					return;
				}
				;
			}
			;
			_local_4 = _local_6;
			_local_6 = _local_4.parent;
		}
		;
	}

	public function setFocusChildElement(_arg_1:Sprite):void {
		var _local_2:int = this.m_children.indexOf(_arg_1);
		if (_local_2 >= 0) {
			this.setFocusChild(_local_2);
		}
		;
	}

	public function unsetFocusChildElement(_arg_1:Sprite):void {
		if (((this.m_focusIndex >= 0) && (this.getContainer().getChildAt((this.getContainer().numChildren - 1)) == _arg_1))) {
			this.unsetFocusChild();
		}
		;
	}

	private function setFocusChild(_arg_1:int):void {
		this.unsetFocusChild();
		if (((_arg_1 < 0) && (_arg_1 >= this.getContainer().numChildren))) {
			return;
		}
		;
		var _local_2:Sprite = (this.getContainer().getChildAt(_arg_1) as Sprite);
		if (_local_2 != null) {
			this.getContainer().setChildIndex(_local_2, (this.getContainer().numChildren - 1));
			this.getContainer().addChildAt(this.m_focusPlaceholder, _arg_1);
			this.m_focusIndex = _arg_1;
		}
		;
	}

	private function unsetFocusChild():void {
		var _local_1:Sprite;
		if (((this.m_focusIndex >= 0) && (this.m_focusIndex < (this.getContainer().numChildren - 1)))) {
			_local_1 = (this.getContainer().getChildAt((this.getContainer().numChildren - 1)) as Sprite);
			if (_local_1 != null) {
				this.getContainer().removeChildAt(this.m_focusIndex);
				this.getContainer().setChildIndex(_local_1, this.m_focusIndex);
			}
			;
		}
		;
		this.m_focusIndex = -1;
	}

	public function pausePopOutScale():void {
		if (this.m_activePopOutScaleViewElement == null) {
			return;
		}
		;
		this.m_activePopOutScaleViewElementPaused = this.m_activePopOutScaleViewElement;
		this.setPopOutScale(this.m_activePopOutScaleViewElement, false, false);
	}

	public function resumePopOutScale():void {
		if (this.m_activePopOutScaleViewElementPaused == null) {
			return;
		}
		;
		this.setPopOutScale(this.m_activePopOutScaleViewElementPaused, true, false);
		this.m_activePopOutScaleViewElementPaused = null;
	}

	protected function setPopOutScale(viewElement:Object, active:Boolean, animate:Boolean = true):void {
		var isQueuedOrActive:Boolean = ((this.m_isPopOutScaleQueued) || (this.m_isPopOutScaleActive));
		if (isQueuedOrActive == active) {
			return;
		}
		;
		if (!active) {
			if (this.m_isPopOutScaleActive) {
				this.setPopOutScale_internal(viewElement, active, animate);
				return;
			}
			;
			if (this.m_isPopOutScaleQueued) {
				Animate.kill(viewElement);
				this.m_isPopOutScaleQueued = false;
				return;
			}
			;
		}
		;
		this.m_isPopOutScaleQueued = true;
		Animate.delay(viewElement, 0.1, function ():void {
			m_isPopOutScaleQueued = false;
			setPopOutScale_internal(viewElement, active, animate);
		});
	}

	private function setPopOutScale_internal(viewElement:Object, active:Boolean, animate:Boolean = true):void {
		var bound:Rectangle;
		var width:Number;
		var height:Number;
		var localBounds:Rectangle;
		var localCoordScale:Number;
		var target_z:Number;
		var/*const*/ POPOUT_GAIN_MAX_WIDTH_VR:Number = NaN;
		var/*const*/ POPOUT_GAIN_MAX_HEIGHT_VR:Number = NaN;
		var animationVarsVr:Object;
		var/*const*/ POPOUT_GAIN_MAX_WIDTH:Number = NaN;
		var/*const*/ POPOUT_GAIN_MAX_HEIGHT:Number = NaN;
		var animationVars:Object;
		if (this.m_isPopOutScaleActive == active) {
			return;
		}
		;
		this.m_activePopOutScaleViewElement = ((active) ? viewElement : null);
		this.setFocus(active);
		this.m_isPopOutScaleActive = active;
		if (active) {
			Animate.complete(viewElement);
			bound = this.getMenuElementBounds(this, this, function (_arg_1:MenuElementBase):Boolean {
				return (_arg_1.visible);
			});
			width = bound.width;
			height = bound.height;
			this.m_popOutOriginalScale = new Point(viewElement.scaleX, viewElement.scaleY);
			this.m_popOutOriginalPos = new Point(viewElement.x, viewElement.y);
			localBounds = viewElement.getBounds(viewElement);
			if (ControlsMain.isVrModeActive()) {
				localCoordScale = Math.min(localBounds.width, localBounds.height);
				target_z = (localCoordScale * -0.1);
				POPOUT_GAIN_MAX_WIDTH_VR = 14;
				POPOUT_GAIN_MAX_HEIGHT_VR = 12;
				animationVarsVr = CalcUtil.createScalingAnimationParameters(this.m_popOutOriginalPos, this.m_popOutOriginalScale, localBounds, POPOUT_GAIN_MAX_WIDTH_VR, POPOUT_GAIN_MAX_HEIGHT_VR);
				animationVarsVr.z = target_z;
				if (animate) {
					Animate.to(viewElement, 0.3, 0, animationVarsVr, Animate.ExpoOut);
				} else {
					viewElement.scaleX = animationVarsVr.scaleX;
					viewElement.scaleY = animationVarsVr.scaleY;
					viewElement.x = animationVarsVr.x;
					viewElement.y = animationVarsVr.y;
					viewElement.z = animationVarsVr.z;
				}
				;
			} else {
				POPOUT_GAIN_MAX_WIDTH = 28;
				POPOUT_GAIN_MAX_HEIGHT = 24;
				animationVars = CalcUtil.createScalingAnimationParameters(this.m_popOutOriginalPos, this.m_popOutOriginalScale, localBounds, POPOUT_GAIN_MAX_WIDTH, POPOUT_GAIN_MAX_HEIGHT);
				if (animate) {
					Animate.to(viewElement, 0.3, 0, animationVars, Animate.ExpoOut);
				} else {
					viewElement.scaleX = animationVars.scaleX;
					viewElement.scaleY = animationVars.scaleY;
					viewElement.x = animationVars.x;
					viewElement.y = animationVars.y;
				}
				;
			}
			;
		} else {
			Animate.kill(viewElement);
			viewElement.scaleX = this.m_popOutOriginalScale.x;
			viewElement.scaleY = this.m_popOutOriginalScale.y;
			viewElement.x = this.m_popOutOriginalPos.x;
			viewElement.y = this.m_popOutOriginalPos.y;
			viewElement.z = 0;
		}
		;
	}


}
}//package menu3

