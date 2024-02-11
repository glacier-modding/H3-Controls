// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.containers.AnimationContainerSearchPage

package menu3.containers {
import flash.geom.Point;

import common.menu.MenuConstants;

import menu3.MenuElementBase;

import flash.display.Sprite;

import common.Log;
import common.Animate;

public dynamic class AnimationContainerSearchPage extends BaseContainer {

	private const ANIMATION_MOVE_NAME:String = "move";
	private const ANIMATION_BLENDOUT_NAME:String = "blendout";

	private var m_moveElements:Array = [];
	private var m_moveElementsStartPositions:Array = [];
	private var m_blendoutElements:Array = [];
	private var m_movement:Point;
	private var m_moveDuration:Number = 0;
	private var m_blendoutDuration:Number = 0;
	private var m_forwardCallbackAction:String;
	private var m_reverseCallbackAction:String;

	public function AnimationContainerSearchPage(_arg_1:Object) {
		super(_arg_1);
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		var _local_2:Number = (_arg_1.move_col * MenuConstants.GridUnitHeight);
		var _local_3:Number = (_arg_1.move_row * MenuConstants.GridUnitHeight);
		this.m_movement = new Point(_local_2, _local_3);
		this.m_moveDuration = ((_arg_1.moveduration != undefined) ? _arg_1.moveduration : 0);
		this.m_blendoutDuration = ((_arg_1.blendoutduration != undefined) ? _arg_1.blendoutduration : 0);
		this.m_forwardCallbackAction = _arg_1.callback_forward;
		this.m_reverseCallbackAction = _arg_1.callback_reverse;
	}

	override public function addChild2(_arg_1:Sprite, _arg_2:int = -1):void {
		var _local_5:Point;
		super.addChild2(_arg_1, _arg_2);
		var _local_3:MenuElementBase = (_arg_1 as MenuElementBase);
		if (_local_3 == null) {
			return;
		}

		var _local_4:Object = _local_3.getData();
		if (_local_4 == null) {
			return;
		}

		if (("animation" in _local_4)) {
			if (_local_4["animation"] == this.ANIMATION_MOVE_NAME) {
				this.m_moveElements.push(_local_3);
				_local_5 = new Point(_local_3.x, _local_3.y);
				this.m_moveElementsStartPositions.push(_local_5);
			} else {
				if (_local_4["animation"] == this.ANIMATION_BLENDOUT_NAME) {
					this.m_blendoutElements.push(_local_3);
				}

			}

		}

	}

	override public function removeChild2(_arg_1:Sprite):void {
		var _local_3:int;
		var _local_2:MenuElementBase = (_arg_1 as MenuElementBase);
		if (_local_2 != null) {
			_local_3 = this.m_moveElements.indexOf(_local_2);
			if (_local_3 >= 0) {
				this.m_moveElements.splice(_local_3, 1);
				this.m_moveElementsStartPositions.splice(_local_3, 1);
			}

			_local_3 = this.m_blendoutElements.indexOf(_local_2);
			if (_local_3 >= 0) {
				this.m_blendoutElements.splice(_local_3, 1);
			}

		}

		super.removeChild2(_arg_1);
	}

	public function startAnimation(_arg_1:Boolean):void {
		Log.info(Log.ChannelAni, this, ("start animation forward=" + _arg_1));
		var _local_2:Array = [];
		var _local_3:Array = [];
		_local_2.push(this.startBlendoutAnimation);
		_local_3.push(this.m_blendoutDuration);
		_local_2.push(this.startMoveAnimation);
		_local_3.push(this.m_moveDuration);
		if (!_arg_1) {
			_local_2 = _local_2.reverse();
			_local_3 = _local_3.reverse();
		}

		this.callAnimation(_local_2, _local_3, _arg_1, 0);
	}

	private function callAnimation(animationFunctions:Array, durations:Array, forward:Boolean, index:int):void {
		var callbackAction:String;
		Log.info(Log.ChannelAni, this, ((("callAnimation index=" + index) + " animationFunctions.length()=") + animationFunctions.length));
		if ((((animationFunctions == null) || (durations == null)) || (index < 0))) {
			return;
		}

		if (((index >= animationFunctions.length) || (index >= durations.length))) {
			return;
		}

		var animationFunction:Function = animationFunctions[index];
		var duration:Number = durations[index];
		Log.info(Log.ChannelAni, this, ((("callAnimation animationFunction=" + animationFunction) + " duration=") + duration));
		if (animationFunction != null) {
			(animationFunction(duration, forward));
		}

		index = (index + 1);
		if (index < animationFunctions.length) {
			Log.info(Log.ChannelAni, this, ("callAnimation queue next animation index=" + index));
			Animate.delay(this, duration, function ():void {
				callAnimation(animationFunctions, durations, forward, index);
			});
		} else {
			Log.info(Log.ChannelAni, this, "callAnimation queue callback");
			callbackAction = ((forward) ? this.m_forwardCallbackAction : this.m_reverseCallbackAction);
			Animate.delay(this, duration, function ():void {
				animationFinished(callbackAction);
			});
		}

	}

	private function startBlendoutAnimation(_arg_1:Number, _arg_2:Boolean):void {
		var _local_3:int;
		while (_local_3 < this.m_blendoutElements.length) {
			this.startBlendoutAnimationOnElement(this.m_blendoutElements[_local_3], _arg_2, _arg_1);
			_local_3++;
		}

	}

	private function startMoveAnimation(_arg_1:Number, _arg_2:Boolean):void {
		var _local_3:int;
		while (_local_3 < this.m_moveElements.length) {
			this.startMoveAnimationOnElement(this.m_moveElements[_local_3], this.m_moveElementsStartPositions[_local_3], _arg_2, _arg_1);
			_local_3++;
		}

	}

	private function startBlendoutAnimationOnElement(element:MenuElementBase, forward:Boolean, duration:Number):void {
		var endAlpha:Number;
		if (element == null) {
			return;
		}

		Animate.complete(element);
		var startAlpha:Number = ((forward) ? 1 : 0);
		endAlpha = ((forward) ? 0 : 1);
		element.alpha = startAlpha;
		element.visible = true;
		Animate.legacyTo(element, duration, {"alpha": endAlpha}, Animate.ExpoOut, function ():void {
			element.visible = (endAlpha == 1);
		});
	}

	private function startMoveAnimationOnElement(_arg_1:MenuElementBase, _arg_2:Point, _arg_3:Boolean, _arg_4:Number):void {
		if (_arg_1 == null) {
			return;
		}

		Animate.complete(_arg_1);
		var _local_5:Point = _arg_2.clone();
		_local_5.offset(this.m_movement.x, this.m_movement.y);
		var _local_6:Number = ((_arg_3) ? 1 : -1);
		var _local_7:Point = ((_arg_3) ? _arg_2 : _local_5);
		var _local_8:Point = ((_arg_3) ? _local_5 : _arg_2);
		_arg_1.x = _local_7.x;
		_arg_1.y = _local_7.y;
		Animate.legacyTo(_arg_1, _arg_4, {
			"x": _local_8.x,
			"y": _local_8.y
		}, Animate.ExpoOut);
	}

	private function animationFinished(_arg_1:String):void {
		var _local_2:int;
		var _local_3:Array;
		if (((this["_nodedata"]) && (!(m_sendEventWithValue == null)))) {
			Log.info(Log.ChannelAni, this, ("Animation finished. Call json action: " + _arg_1));
			_local_2 = (this["_nodedata"]["id"] as int);
			_local_3 = [_local_2, _arg_1];
			m_sendEventWithValue("onTriggerAction", _local_3);
		}

	}


}
}//package menu3.containers

