// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.DamageDirection

package hud {
import common.BaseControl;

public class DamageDirection extends BaseControl {

	private var m_view:HitIndicator;

	public function DamageDirection() {
		this.m_view = new HitIndicator();
		addChild(this.m_view);
	}

}
}//package hud

