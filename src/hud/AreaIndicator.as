// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.AreaIndicator

package hud {
import common.BaseControl;
import common.Animate;

public class AreaIndicator extends BaseControl {

	private var m_view:AreaIndicatorView;
	private var m_areaRadius:Number = 30;

	public function AreaIndicator() {
		this.m_view = new AreaIndicatorView();
		addChild(this.m_view);
	}

	public function setAreaSize(_arg_1:Number, _arg_2:Number = 0.2):void {
		this.m_areaRadius = _arg_1;
		this.m_view.areaCircle.alpha = _arg_2;
		this.m_view.areaCircle.width = (this.m_view.areaCircle.height = this.m_areaRadius);
	}

	override public function onSetVisible(value:Boolean):void {
		Animate.kill(this.m_view);
		if (value) {
			this.m_view.visible = true;
			Animate.to(this.m_view, HudConstants.MinimapBlipFadeInFadeOutTime, 0, {"alpha": 1}, Animate.ExpoOut);
		} else {
			Animate.to(this.m_view, HudConstants.MinimapBlipFadeInFadeOutTime, 0, {"alpha": 0}, Animate.ExpoOut, function ():void {
				m_view.visible = false;
			});
		}

	}


}
}//package hud

