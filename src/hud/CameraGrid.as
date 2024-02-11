// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.CameraGrid

package hud {
import common.BaseControl;

import flash.display.Sprite;

import common.menu.MenuConstants;

public class CameraGrid extends BaseControl {

	private var m_view:Sprite;
	private var m_sizeX:Number;
	private var m_sizeY:Number;
	private var m_offsetXPercent:Number;
	private var m_offsetYPercent:Number;

	public function CameraGrid() {
		this.m_view = new Sprite();
		this.m_view.visible = false;
		addChild(this.m_view);
	}

	override public function onSetSize(_arg_1:Number, _arg_2:Number):void {
		super.onSetSize(_arg_1, _arg_2);
		this.m_sizeX = _arg_1;
		this.m_sizeY = _arg_2;
		this.drawGrid();
	}

	private function drawGrid():void {
		var _local_1:Number = (this.m_sizeY * this.m_offsetYPercent);
		var _local_2:Number = (this.m_sizeY * (1 - this.m_offsetYPercent));
		var _local_3:Number = (this.m_sizeX * this.m_offsetXPercent);
		var _local_4:Number = (this.m_sizeX * (1 - this.m_offsetXPercent));
		this.m_view.graphics.clear();
		this.m_view.graphics.lineStyle(1, MenuConstants.COLOR_GREY_LIGHT, 1);
		this.m_view.graphics.moveTo(0, _local_1);
		this.m_view.graphics.lineTo(this.m_sizeX, _local_1);
		this.m_view.graphics.moveTo(0, _local_2);
		this.m_view.graphics.lineTo(this.m_sizeX, _local_2);
		this.m_view.graphics.moveTo(_local_3, 0);
		this.m_view.graphics.lineTo(_local_3, this.m_sizeY);
		this.m_view.graphics.moveTo(_local_4, 0);
		this.m_view.graphics.lineTo(_local_4, this.m_sizeY);
	}

	public function set horizontalOffsetPercent(_arg_1:Number):void {
		this.m_offsetXPercent = _arg_1;
		this.drawGrid();
	}

	public function set verticalOffsetPercent(_arg_1:Number):void {
		this.m_offsetYPercent = _arg_1;
		this.drawGrid();
	}

	public function Show():void {
		this.m_view.visible = true;
	}

	public function Hide():void {
		this.m_view.visible = false;
	}


}
}//package hud

