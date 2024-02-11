// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.tutorial.Waypoint2d

package hud.tutorial {
import common.BaseControl;

public class Waypoint2d extends BaseControl {

	private var m_view:Waypoint2DView;

	public function Waypoint2d() {
		this.m_view = new Waypoint2DView();
		addChild(this.m_view);
		if (ControlsMain.isVrModeActive()) {
			this.m_view.icon.visible = false;
			this.m_view.distance.visible = false;
		}
		;
	}

	public function onSetData(_arg_1:Object):void {
		var _local_2:int;
		var _local_3:Number;
		if (!ControlsMain.isVrModeActive()) {
			_local_2 = _arg_1.distance;
			this.m_view.distance.visible = ((_local_2 >= 0) ? true : false);
			this.m_view.distance.text = (_local_2.toString() + "m");
			_local_3 = ((ControlsMain.getDisplaySize() == ControlsMain.DISPLAY_SIZE_SMALL) ? 1.5 : 1);
			this.m_view.distance.scaleX = _local_3;
			this.m_view.distance.scaleY = _local_3;
		}
		;
	}


}
}//package hud.tutorial

