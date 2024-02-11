// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.evergreen.EvergreenSpycameraGridlines

package hud.evergreen {
import common.BaseControl;

import flash.display.Sprite;

import hud.photomode.PhotoModeWidget;

public class EvergreenSpycameraGridlines extends BaseControl {

	private var m_view:Sprite;

	public function EvergreenSpycameraGridlines() {
		this.m_view = new Sprite();
		this.m_view.visible = false;
		addChild(this.m_view);
	}

	public function setViewFinderStyle(_arg_1:int):void {
		switch (_arg_1) {
			case PhotoModeWidget.VIEWFINDERSTYLE_NONE:
				this.m_view.visible = false;
				return;
			case PhotoModeWidget.VIEWFINDERSTYLE_CAMERAITEM:
				this.m_view.visible = false;
				return;
			case PhotoModeWidget.VIEWFINDERSTYLE_PHOTOOPP:
				this.m_view.visible = false;
				return;
			case PhotoModeWidget.VIEWFINDERSTYLE_SPYCAM:
				this.m_view.visible = true;
				return;
			default:
				this.m_view.visible = false;
		}

	}

	override public function onSetSize(_arg_1:Number, _arg_2:Number):void {
		var _local_9:spyCameraGridline;
		var _local_10:spyCameraGridline;
		this.m_view.removeChildren();
		var _local_3:uint = uint(Math.floor((_arg_1 / 47)));
		var _local_4:uint = uint(Math.floor((_arg_2 / 47)));
		var _local_5:Number = (((_local_3 - (_arg_1 / 47)) * 47) / 2);
		var _local_6:Number = (((_local_4 - (_arg_2 / 47)) * 47) / 2);
		var _local_7:uint;
		while (_local_7 <= _local_3) {
			_local_9 = new spyCameraGridline();
			_local_9.alpha = 0.1;
			_local_9.width = 1;
			_local_9.height = _arg_2;
			_local_9.x = ((_local_7 * 47) - _local_5);
			_local_9.y = 0;
			this.m_view.addChild(_local_9);
			_local_7++;
		}

		var _local_8:uint;
		while (_local_8 <= _local_4) {
			_local_10 = new spyCameraGridline();
			_local_10.alpha = 0.1;
			_local_10.width = _arg_1;
			_local_10.height = 1;
			_local_10.x = 0;
			_local_10.y = ((_local_8 * 47) - _local_6);
			this.m_view.addChild(_local_10);
			_local_8++;
		}

	}


}
}//package hud.evergreen

