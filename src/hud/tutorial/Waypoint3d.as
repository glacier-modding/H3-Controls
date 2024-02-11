// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.tutorial.Waypoint3d

package hud.tutorial {
import common.BaseControl;

public class Waypoint3d extends BaseControl {

	private var m_view:Waypoint3DView;

	public function Waypoint3d() {
		this.m_view = new Waypoint3DView();
		addChild(this.m_view);
	}

	public function onSetData(_arg_1:Object):void {
		var _local_2:int = _arg_1.distance;
		this.m_view.distance.visible = ((_local_2 >= 0) ? true : false);
		this.m_view.distance.text = (_local_2.toString() + "m");
		var _local_3:Number = ((ControlsMain.getDisplaySize() == ControlsMain.DISPLAY_SIZE_SMALL) ? 1.5 : 1);
		this.m_view.distance.scaleX = _local_3;
		this.m_view.distance.scaleY = _local_3;
	}


}
}//package hud.tutorial

