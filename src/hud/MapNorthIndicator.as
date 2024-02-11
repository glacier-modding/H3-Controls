// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.MapNorthIndicator

package hud {
import common.BaseControl;

public class MapNorthIndicator extends BaseControl {

	private var m_view:MapNorthIndicatorView;

	public function MapNorthIndicator():void {
		this.m_view = new MapNorthIndicatorView();
		addChild(this.m_view);
	}

	public function SetDirection(_arg_1:Number = 0):void {
		trace(("MapNorthIndicator | SetDirection | rot: " + _arg_1));
		this.m_view.visible = true;
		this.m_view.rotation = _arg_1;
		this.m_view.n_mc.rotation = -(_arg_1);
	}


}
}//package hud

