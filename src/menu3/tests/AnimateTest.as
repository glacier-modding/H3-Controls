// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.tests.AnimateTest

package menu3.tests {
import menu3.MenuElementBase;

import common.Animate;

import flash.display.Sprite;

import common.Log;

public dynamic class AnimateTest extends MenuElementBase {

	private const OBJECT_COUNT:int = 10;

	private var m_objects:Array = new Array();

	public function AnimateTest(_arg_1:Object) {
		super(_arg_1);
		var _local_2:int;
		while (_local_2 < this.OBJECT_COUNT) {
			this.m_objects.push(this.createSpriteObject());
			_local_2++;
		}
		;
	}

	private static function setupEasingAnimation(_arg_1:Sprite, _arg_2:Boolean, _arg_3:Number, _arg_4:int):void {
		var _local_5:Number = 2;
		var _local_6:Number = 0;
		var _local_7:Number = (_arg_3 * ((_arg_2) ? 1 : -1));
		Animate.addOffset(_arg_1, _local_5, _local_6, {"x": _local_7}, _arg_4, setupEasingAnimation, _arg_1, (!(_arg_2)), _arg_3, _arg_4);
	}

	private static function setupAlphaAnimation(_arg_1:Sprite, _arg_2:Boolean, _arg_3:int):void {
		var _local_4:Number = 1;
		var _local_5:Number = 0.8;
		var _local_6:Number = ((_arg_2) ? 1 : 0.5);
		var _local_7:Number = ((_arg_2) ? 0.3 : 1);
		Animate.addFromTo(_arg_1, _local_4, _local_5, {"alpha": _local_6}, {"alpha": _local_7}, _arg_3, setupAlphaAnimation, _arg_1, (!(_arg_2)), _arg_3);
	}


	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		this.setupStartPosition();
		this.setupCallbackTest();
	}

	private function createSpriteObject():Sprite {
		var _local_1:Sprite = new Sprite();
		_local_1.graphics.clear();
		_local_1.graphics.beginFill(0xFF0000, 1);
		_local_1.graphics.drawRect(-25, -25, 50, 50);
		_local_1.graphics.endFill();
		addChild(_local_1);
		return (_local_1);
	}

	private function setupStartPosition():void {
		var _local_1:Number = 0;
		var _local_2:Number = 200;
		var _local_3:Number = 10;
		var _local_4:int;
		while (_local_4 < this.m_objects.length) {
			this.m_objects[_local_4].x = _local_1;
			this.m_objects[_local_4].y = (((this.m_objects[_local_4].height + _local_3) * _local_4) + _local_2);
			_local_4++;
		}
		;
	}

	private function killAnimations():void {
		Animate.kill(this);
		var _local_1:int;
		while (_local_1 < this.m_objects.length) {
			Animate.kill(this.m_objects[_local_1]);
			_local_1++;
		}
		;
	}

	private function startAnimationGroup():void {
		this.setupEasingTest();
		this.setupParallelTest();
		this.setupFromToTest();
	}

	private function setupEasingTest():void {
		var _local_1:Number = 1000;
		setupEasingAnimation(this.m_objects[0], true, _local_1, Animate.Linear);
		setupEasingAnimation(this.m_objects[1], true, _local_1, Animate.SineIn);
		setupEasingAnimation(this.m_objects[2], true, _local_1, Animate.SineOut);
		setupEasingAnimation(this.m_objects[3], true, _local_1, Animate.SineInOut);
		setupEasingAnimation(this.m_objects[4], true, _local_1, Animate.ExpoIn);
		setupEasingAnimation(this.m_objects[5], true, _local_1, Animate.ExpoOut);
		setupEasingAnimation(this.m_objects[6], true, _local_1, Animate.ExpoInOut);
		setupEasingAnimation(this.m_objects[7], true, _local_1, Animate.BackIn);
		setupEasingAnimation(this.m_objects[8], true, _local_1, Animate.BackOut);
		setupEasingAnimation(this.m_objects[9], true, _local_1, Animate.BackInOut);
	}

	private function setupFromToTest():void {
		var _local_1:int;
		while (_local_1 < this.m_objects.length) {
			setupAlphaAnimation(this.m_objects[_local_1], true, Animate.Linear);
			_local_1++;
		}
		;
	}

	private function setupParallelTest():void {
		this.setupParallelAnimation(0, Animate.Linear);
	}

	private function setupParallelAnimation(_arg_1:int, _arg_2:int):void {
		if (_arg_1 >= this.m_objects.length) {
			this.killAnimations();
			this.setupStartPosition();
			this.setupEasingTest();
			return;
		}
		;
		var _local_3:Number = 0.5;
		var _local_4:Number = 0;
		Animate.addOffset(this.m_objects[_arg_1], _local_3, _local_4, {"rotation": 360}, _arg_2, this.setupParallelAnimation, (_arg_1 + 1), _arg_2);
	}

	private function setupCallbackTest():void {
		var text:String;
		Animate.delay(this.m_objects[0], 0.1, this.simpleCallback);
		text = "Hello World!";
		Animate.delay(this.m_objects[0], 0.2, this.callback, text);
		text = "Hello World2!";
		Animate.delay(this.m_objects[0], 0.3, this.callback, text);
		text = "Hello World3!";
		Animate.delay(this.m_objects[0], 0.4, this.nestedCallback, text);
		Animate.delay(this.m_objects[0], 0.6, function ():void {
			Log.info("debug", this, "simpleLambdaCallback");
		});
		text = "Hello World7!";
		Animate.delay(this.m_objects[0], 0.7, function (_arg_1:String):void {
			Log.info("debug", this, ("lambdaCallback: " + _arg_1));
		}, text);
		text = "Hello World8!";
		Animate.delay(this.m_objects[0], 0.8, function ():void {
			Log.info("debug", this, ("lambdaCallback: " + text));
		});
		text = "Hello World9!";
		Animate.delay(this, 0.9, this.setupCallbackTest2);
	}

	private function simpleCallback():void {
		Log.info("debug", this, "simpleCallback");
	}

	private function callback(_arg_1:String):void {
		Log.info("debug", this, ("callback: " + _arg_1));
	}

	private function nestedCallback(_arg_1:String):void {
		Log.info("debug", this, ("nestedCallback: " + _arg_1));
		Animate.delay(this.m_objects[5], 0.1, this.callback, _arg_1);
	}

	private function setupCallbackTest2():void {
		var textObj:Object;
		textObj = new Object();
		textObj["Text"] = "Hello Object!";
		Animate.delay(this.m_objects[0], 0.1, this.callbackObject, textObj);
		textObj["Text"] = "Hello Object2!";
		Animate.delay(this.m_objects[0], 0.2, this.callbackObject, textObj);
		textObj["Text"] = "Hello Object3!";
		Animate.delay(this.m_objects[0], 0.3, this.nestedCallbackObject, textObj);
		textObj["Text"] = "Hello Object7!";
		Animate.delay(this.m_objects[0], 0.5, function (_arg_1:Object):void {
			Log.info("debug", this, ("lambdaCallback: " + _arg_1["Text"]));
		}, textObj);
		textObj["Text"] = "Hello Object8!";
		Animate.delay(this.m_objects[0], 0.6, function ():void {
			Log.info("debug", this, ("lambdaCallback: " + textObj["Text"]));
		});
		textObj["Text"] = "Hello Object9!";
		Animate.delay(this, 0.7, this.startAnimationGroup);
	}

	private function callbackObject(_arg_1:Object):void {
		Log.info("debug", this, ("callbackObject: " + _arg_1["Text"]));
	}

	private function nestedCallbackObject(_arg_1:Object):void {
		Log.info("debug", this, ("nestedCallbackObject: " + _arg_1["Text"]));
		Animate.delay(this.m_objects[0], 0.1, this.callbackObject, _arg_1);
	}


}
}//package menu3.tests

