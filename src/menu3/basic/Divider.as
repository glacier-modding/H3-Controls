// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.Divider

package menu3.basic {
import menu3.MenuElementBase;

import flash.display.Sprite;
import flash.geom.Point;

import common.menu.MenuConstants;

public dynamic class Divider extends MenuElementBase {

	private var m_spacer:Sprite;
	private var m_line:Sprite;

	public function Divider(_arg_1:Object) {
		super(_arg_1);
		this.m_spacer = new Sprite();
		addChild(this.m_spacer);
		this.m_line = new Sprite();
		addChild(this.m_line);
		this.createDivider(_arg_1);
	}

	override public function onUnregister():void {
		super.onUnregister();
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		this.createDivider(_arg_1);
	}

	private function createDivider(_arg_1:Object):void {
		var _local_7:Number;
		var _local_8:Number;
		this.m_spacer.graphics.clear();
		this.m_line.graphics.clear();
		var _local_2:Number = getWidth();
		var _local_3:Number = getHeight();
		this.m_spacer.graphics.beginFill(0xFF0000, 0);
		this.m_spacer.graphics.drawRect(0, 0, _local_2, _local_3);
		this.m_spacer.graphics.endFill();
		if (_arg_1.showLine !== true) {
			return;
		}

		var _local_4:Number = ((_arg_1.lineWidth != null) ? _arg_1.lineWidth : 2);
		var _local_5:String = ((_arg_1.direction != null) ? _arg_1.direction : "vertical");
		var _local_6:Point = new Point(-1, 0);
		if (_local_5 == "vertical") {
			_local_7 = ((_local_2 / 2) - (_local_4 / 2));
			this.m_line.graphics.beginFill(MenuConstants.COLOR_RED, MenuConstants.MenuElementSelectedAlpha);
			this.m_line.graphics.drawRect((_local_6.x + _local_7), _local_6.y, _local_4, _local_3);
			this.m_line.graphics.endFill();
		} else {
			_local_8 = ((_local_3 / 2) - (_local_4 / 2));
			this.m_line.graphics.beginFill(MenuConstants.COLOR_RED, MenuConstants.MenuElementSelectedAlpha);
			this.m_line.graphics.drawRect(_local_6.x, (_local_6.y + _local_8), _local_2, _local_4);
			this.m_line.graphics.endFill();
		}

	}


}
}//package menu3.basic

