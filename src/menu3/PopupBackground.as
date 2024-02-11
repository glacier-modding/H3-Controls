// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.PopupBackground

package menu3 {
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;

import common.menu.MenuConstants;

public dynamic class PopupBackground extends MenuElementBase {

	private var m_background:Sprite = new Sprite();
	private var m_screenHeight:Number = 0;
	private var m_addedToStage:Boolean = false;

	public function PopupBackground(_arg_1:Object) {
		super(_arg_1);
		addChild(this.m_background);
		addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage, true, 0, true);
	}

	override public function onUnregister():void {
		this.m_addedToStage = false;
		super.onUnregister();
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		if (this.m_addedToStage) {
			this.drawBackground();
		}

	}

	protected function onAddedToStage(_arg_1:Event):void {
		removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage, true);
		this.m_addedToStage = true;
		this.drawBackground();
		stage.addEventListener(ScreenResizeEvent.SCREEN_RESIZED, this.onScreenResize, true, 0, true);
		addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage, false);
	}

	protected function onRemovedFromStage(_arg_1:Event):void {
		removeEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage, false);
		stage.removeEventListener(ScreenResizeEvent.SCREEN_RESIZED, this.onScreenResize, true);
		this.m_addedToStage = false;
	}

	protected function onScreenResize(_arg_1:ScreenResizeEvent):void {
		this.m_screenHeight = _arg_1.screenSize.sizeY;
		this.drawBackground();
	}

	private function drawBackground():void {
		var _local_1:Number;
		var _local_2:Number;
		var _local_3:Point;
		var _local_4:Point;
		this.m_background.graphics.clear();
		this.m_background.graphics.beginFill(0, 0.75);
		if (!ControlsMain.isVrModeActive()) {
			_local_1 = stage.stageWidth;
			_local_2 = stage.stageHeight;
			_local_3 = globalToLocal(new Point(0, 0));
			_local_4 = globalToLocal(new Point(_local_1, _local_2));
			this.m_background.graphics.moveTo(_local_3.x, _local_3.y);
			this.m_background.graphics.lineTo(_local_4.x, _local_3.y);
			this.m_background.graphics.lineTo(_local_4.x, _local_4.y);
			this.m_background.graphics.lineTo(_local_3.x, _local_4.y);
			this.m_background.graphics.moveTo(_local_3.x, _local_3.y);
		} else {
			this.m_background.graphics.drawRect(-(MenuConstants.BaseWidth), -(MenuConstants.BaseHeight), (3 * MenuConstants.BaseWidth), (3 * MenuConstants.BaseHeight));
		}

		this.m_background.graphics.endFill();
	}


}
}//package menu3

