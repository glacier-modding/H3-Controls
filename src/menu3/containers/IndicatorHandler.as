// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.containers.IndicatorHandler

package menu3.containers {
import flash.display.Sprite;

import common.Log;

import menu3.MenuElementBase;

import flash.events.MouseEvent;

import common.menu.MenuConstants;

import flash.utils.getDefinitionByName;

public dynamic class IndicatorHandler {

	private var m_container:BaseContainer = null;
	private var m_sendEventWithValue:Function = null;
	private var m_prevIndicator:Sprite = null;
	private var m_nextIndicator:Sprite = null;
	private var indicatorCount:int = 0;

	public function IndicatorHandler(_arg_1:BaseContainer, _arg_2:Object) {
		this.m_container = _arg_1;
		if (((_arg_2.hasOwnProperty("showprevnext")) && (_arg_2.showprevnext == true))) {
			if (((_arg_2.hasOwnProperty("currentpage")) && (_arg_2.currentpage > 0))) {
				Log.info("IndicatorHandler", this, "has previous pages - trying to add previous indicators");
				this.m_prevIndicator = new Sprite();
				this.addIndicators(this.m_prevIndicator, _arg_2.previousindicator, this.handleMouseUpPrevIndicator);
			}

			if (((_arg_2.hasOwnProperty("hasmorepages")) && (_arg_2.hasmorepages))) {
				Log.info("IndicatorHandler", this, "has more pages - trying to add next indicators");
				this.m_nextIndicator = new Sprite();
				this.addIndicators(this.m_nextIndicator, _arg_2.nextindicator, this.handleMouseUpNextIndicator, this.m_container.getScrollBounds().width);
			}

		}

	}

	public function setEngineCallback(_arg_1:Function):void {
		this.m_sendEventWithValue = _arg_1;
	}

	public function destroy():void {
		if (!this.m_container) {
			return;
		}

		if (this.m_prevIndicator) {
			this.destroyIndicator(this.m_prevIndicator, this.handleMouseUpPrevIndicator);
			this.m_prevIndicator = null;
		}

		if (this.m_nextIndicator) {
			this.destroyIndicator(this.m_nextIndicator, this.handleMouseUpNextIndicator);
			this.m_nextIndicator = null;
		}

		this.m_container = null;
	}

	private function destroyIndicator(_arg_1:Sprite, _arg_2:Function):void {
		var _local_3:MenuElementBase;
		while (_arg_1.numChildren) {
			_local_3 = (_arg_1.getChildAt(0) as MenuElementBase);
			_local_3.removeEventListener(MouseEvent.MOUSE_UP, _arg_2, false);
			_local_3.removeEventListener(MouseEvent.ROLL_OVER, _local_3.handleRollOver, false);
			_local_3.removeEventListener(MouseEvent.ROLL_OUT, _local_3.handleRollOut, false);
			_local_3.onUnregister();
			_arg_1.removeChildAt(0);
		}

		this.m_container.removeChild(_arg_1);
	}

	private function addIndicators(_arg_1:Sprite, _arg_2:Object, _arg_3:Function, _arg_4:Number = 0):void {
		var _local_6:Sprite;
		var _local_7:Array;
		var _local_8:Number;
		var _local_9:int;
		if (_arg_2 == null) {
			Log.error("IndicatorHandler", this.m_container, "indicator data is invalid");
			return;
		}

		var _local_5:Number = 0;
		if ((_arg_2 is Array)) {
			_local_7 = (_arg_2 as Array);
			_local_8 = 0;
			_local_9 = 0;
			while (_local_9 < _local_7.length) {
				_local_6 = this.addIndicator(_arg_1, _local_7[_local_9], _local_8, _arg_3);
				_local_8 = (_local_8 + (_local_6.height + 1));
				_local_5 = _local_6.width;
				_local_9++;
			}

		} else {
			_local_6 = this.addIndicator(_arg_1, _arg_2, 0, _arg_3);
			_local_5 = _local_6.width;
			if (_local_6.height < MenuConstants.MenuTileLargeHeight) {
				_local_6 = this.addIndicator(_arg_1, _arg_2, (_local_6.height + 1), _arg_3);
			}

		}

		if (_arg_4 == 0) {
			_arg_1.x = (_arg_1.x - (_local_5 + 1));
		} else {
			_arg_1.x = (_arg_1.x + _arg_4);
		}

		this.m_container.addChild(_arg_1);
		Log.info("IndicatorHandler", this.m_container, ("added indicators at " + _arg_4));
	}

	private function addIndicator(_arg_1:Sprite, _arg_2:Object, _arg_3:Number, _arg_4:Function):Sprite {
		var _local_5:Class = (getDefinitionByName(_arg_2.view) as Class);
		if (_local_5 == null) {
			Log.error("IndicatorHandler", this.m_container, "Could not read 'view' from indicator handler");
			return (new Sprite());
		}

		var _local_6:Object = _arg_2.data;
		var _local_7:MenuElementBase = (new _local_5(_local_6) as MenuElementBase);
		_local_7.onSetData(_local_6);
		_local_7.name = ("indicator" + this.indicatorCount);
		this.indicatorCount = (this.indicatorCount + 1);
		_local_7.y = (_local_7.y + _arg_3);
		_local_7.addEventListener(MouseEvent.MOUSE_UP, _arg_4, false, 0, false);
		_local_7.addEventListener(MouseEvent.ROLL_OVER, _local_7.handleRollOver, false, 0, false);
		_local_7.addEventListener(MouseEvent.ROLL_OUT, _local_7.handleRollOut, false, 0, false);
		_arg_1.addChild(_local_7);
		return (_local_7);
	}

	private function handleMouseUpPrevIndicator(_arg_1:MouseEvent):void {
		Log.mouse(this.m_container, _arg_1, "PrevIndicator");
		this.triggerPaginate(-1);
	}

	private function handleMouseUpNextIndicator(_arg_1:MouseEvent):void {
		Log.mouse(this.m_container, _arg_1, "NextIndicator");
		this.triggerPaginate(1);
	}

	private function triggerPaginate(_arg_1:int):void {
		var _local_2:int;
		var _local_3:Array;
		if (this.m_container["_nodedata"]) {
			if (this.m_sendEventWithValue != null) {
				_local_2 = (this.m_container["_nodedata"]["id"] as int);
				_local_3 = [_local_2, _arg_1];
				this.m_sendEventWithValue("onTriggerPaginate", _local_3);
			} else {
				Log.error("IndicatorHandler", this.m_container, "Callback handling not set-up properly!");
			}

		}

	}


}
}//package menu3.containers

