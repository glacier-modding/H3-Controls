// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.DifficultyIcon

package hud {
import common.BaseControl;

public class DifficultyIcon extends BaseControl {

	private var m_view:DifficultyIconView;

	public function DifficultyIcon() {
		this.m_view = new DifficultyIconView();
		this.m_view.bg.alpha = 0.5;
		addChild(this.m_view);
	}

	public function onSetData(_arg_1:Object):void {
		this.m_view.gotoAndStop(_arg_1.difficulty);
	}


}
}//package hud

