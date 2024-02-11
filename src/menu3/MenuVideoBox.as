// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.MenuVideoBox

package menu3 {
import basic.VideoBox;

import flash.display.Sprite;

import common.menu.MenuConstants;

import flash.events.Event;

public class MenuVideoBox extends VideoBox {

	private var m_isPlaying:Boolean = false;
	private var m_background:Sprite;
	private var m_drawBackground:Boolean = false;
	private var m_backgroundX:Number = 0;
	private var m_backgroundY:Number = 0;
	private var m_backgroundWidth:Number = MenuConstants.BaseWidth;
	private var m_backgroundHeight:Number = MenuConstants.BaseHeight;

	public function MenuVideoBox() {
		addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage, true, 0, true);
		this.m_background = new Sprite();
		addChildAt(this.m_background, 0);
	}

	public function set DrawBackground(_arg_1:Boolean):void {
		if (this.m_drawBackground == _arg_1) {
			return;
		}
		;
		this.m_drawBackground = _arg_1;
		if (this.m_drawBackground) {
			this.redrawBackground();
		} else {
			this.clearBackground();
		}
		;
	}

	override public function play(_arg_1:String):void {
		super.play(_arg_1);
		this.m_isPlaying = true;
		this.redrawBackground();
	}

	override public function stop():void {
		super.stop();
		this.m_isPlaying = false;
		this.clearBackground();
	}

	override public function onSetSize(_arg_1:Number, _arg_2:Number):void {
		super.onSetSize(_arg_1, _arg_2);
		this.updateBackgroundPosition();
	}

	private function onAddedToStage(_arg_1:Event):void {
		removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage, true);
		stage.addEventListener(ScreenResizeEvent.SCREEN_RESIZED, this.screenResizeEventHandler, true, 0, true);
	}

	private function screenResizeEventHandler(_arg_1:ScreenResizeEvent):void {
		var _local_2:Object = _arg_1.screenSize;
		if (((this.m_backgroundWidth == _local_2.sizeX) && (this.m_backgroundHeight == _local_2.sizeY))) {
			return;
		}
		;
		this.m_backgroundWidth = _local_2.sizeX;
		this.m_backgroundHeight = _local_2.sizeY;
		this.redrawBackground();
	}

	private function updateBackgroundPosition():void {
		var _local_1:Number = -(x);
		var _local_2:Number = -(y);
		if (((this.m_backgroundX == _local_1) && (this.m_backgroundY == _local_2))) {
			return;
		}
		;
		this.m_backgroundX = _local_1;
		this.m_backgroundY = _local_2;
		this.redrawBackground();
	}

	private function redrawBackground():void {
		var _local_1:uint;
		var _local_2:Number;
		this.clearBackground();
		if (((this.m_drawBackground) && (this.m_isPlaying))) {
			_local_1 = 0;
			_local_2 = 1;
			this.m_background.graphics.beginFill(_local_1, _local_2);
			this.m_background.graphics.drawRect(this.m_backgroundX, this.m_backgroundY, this.m_backgroundWidth, this.m_backgroundHeight);
			this.m_background.graphics.endFill();
		}
		;
	}

	private function clearBackground():void {
		this.m_background.graphics.clear();
	}


}
}//package menu3

