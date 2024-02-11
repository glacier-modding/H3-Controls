// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.tutorial.Waypoint2dArrow

package hud.tutorial {
import common.BaseControl;

public class Waypoint2dArrow extends BaseControl {

	private var m_view:Waypoint2DArrowView;

	public function Waypoint2dArrow() {
		this.m_view = new Waypoint2DArrowView();
		addChild(this.m_view);
	}

}
}//package hud.tutorial

