// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.versus.scoring.UnnoticedKillElement

package hud.versus.scoring {
import flash.display.MovieClip;

import common.Animate;
import common.menu.MenuUtils;
import common.menu.MenuConstants;

import flash.text.TextFieldAutoSize;

public class UnnoticedKillElement extends MovieClip {

	private var m_view:UnnoticedKillElementView;
	private var m_isAnimating:Boolean = false;

	public function UnnoticedKillElement() {
		this.m_view = new UnnoticedKillElementView();
		this.m_view.alpha = 0;
		this.m_view.bgMc.visible = false;
		addChild(this.m_view);
	}

	public function onSetData(_arg_1:Object):void {
		this.updateHeader(_arg_1.header);
		this.show();
	}

	public function show():void {
		this.m_view.barMc.scaleX = 1;
		Animate.to(this.m_view, 0.5, 0, {"alpha": 1}, Animate.ExpoOut);
	}

	public function hide():void {
		this.killAnimations();
		Animate.to(this.m_view, 0.5, 0, {"alpha": 0}, Animate.ExpoOut);
	}

	public function update(_arg_1:Number):void {
		if (!this.m_isAnimating) {
			this.m_isAnimating = true;
			this.updateBar(_arg_1);
			this.pulsateHeaderIn();
		}

	}

	private function updateHeader(_arg_1:String):void {
		MenuUtils.setupTextUpper(this.m_view.headerMc.txtLabel, _arg_1, 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		this.m_view.headerMc.txtLabel.autoSize = TextFieldAutoSize.CENTER;
		this.m_view.bgMc.width = (this.m_view.headerMc.txtLabel.textWidth + 20);
	}

	private function updateBar(duration:Number):void {
		Animate.to(this.m_view.barMc, duration, 0, {"scaleX": 0}, Animate.Linear, function ():void {
			m_isAnimating = false;
		});
	}

	private function pulsateHeaderOut():void {
		this.m_view.bgMc.visible = true;
		MenuUtils.setColor(this.m_view.headerMc, MenuConstants.COLOR_GREY_ULTRA_DARK);
		Animate.delay(this, 0.5, this.pulsateHeaderIn);
	}

	private function pulsateHeaderIn():void {
		this.m_view.bgMc.visible = false;
		MenuUtils.removeColor(this.m_view.headerMc);
		Animate.delay(this, 0.5, this.pulsateHeaderOut);
	}

	private function killAnimations():void {
		Animate.kill(this);
		Animate.kill(this.m_view.barMc);
		Animate.kill(this.m_view);
		this.m_isAnimating = false;
	}


}
}//package hud.versus.scoring

