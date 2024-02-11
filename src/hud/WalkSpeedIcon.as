// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.WalkSpeedIcon

package hud {
import common.BaseControl;
import common.Animate;

public class WalkSpeedIcon extends BaseControl {

	private var m_view:WalkSpeedIconView;

	public function WalkSpeedIcon() {
		this.m_view = new WalkSpeedIconView();
		this.m_view.bg.alpha = 0.5;
		this.m_view.visible = false;
		this.m_view.scaleX = 0;
		this.m_view.scaleY = 0;
		addChild(this.m_view);
	}

	public function onSetData(data:Object):void {
		if (!data.isVisible) {
			Animate.to(this.m_view, 0.5, 0, {
				"scaleX": 0,
				"scaleY": 0
			}, Animate.ExpoOut, function ():void {
				m_view.visible = false;
			});
		} else {
			if (!this.m_view.visible) {
				this.m_view.visible = true;
				this.m_view.iconMc.gotoAndStop(data.speed);
				Animate.to(this.m_view, 0.5, 0, {
					"scaleX": 1,
					"scaleY": 1
				}, Animate.ExpoOut);
			} else {
				Animate.to(this.m_view, 0.125, 0, {
					"scaleX": 0,
					"scaleY": 0
				}, Animate.SineIn, function (_arg_1:String):void {
					m_view.iconMc.gotoAndStop(_arg_1);
					Animate.to(m_view, 0.125, 0, {
						"scaleX": 1,
						"scaleY": 1
					}, Animate.SineOut);
				}, data.speed);
			}

		}

	}


}
}//package hud

