// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.AttractorScreen

package menu3 {
import common.BaseControl;
import common.menu.MenuUtils;

import flash.utils.getTimer;
import flash.events.Event;

public dynamic class AttractorScreen extends BaseControl {

	private var m_view:AttractorScreenView;
	private var m_totalFrames:int;
	private var m_deltaTime:Number;
	private var m_prevFrame:Number;
	private var m_currentFrame:Number;
	private var m_frameFactor:Number = 0;
	private var m_frame:int;

	public function AttractorScreen() {
		this.m_view = new AttractorScreenView();
		this.m_view.lines.alpha = 0.4;
		MenuUtils.setTintColor(this.m_view.lines, MenuUtils.TINT_COLOR_MEDIUM_GREY_3, false);
		this.m_totalFrames = (this.m_view.lines.totalFrames - 1);
		addChild(this.m_view);
	}

	private function update(_arg_1:Event):void {
		this.m_currentFrame = getTimer();
		this.m_deltaTime = ((this.m_currentFrame - this.m_prevFrame) * 0.001);
		this.m_prevFrame = this.m_currentFrame;
		this.m_frameFactor = (this.m_frameFactor + (24 / (1 / this.m_deltaTime)));
		this.m_frame = Math.ceil(this.m_frameFactor);
		if (this.m_frame > this.m_totalFrames) {
			this.m_frameFactor = 0;
		}
		;
		this.m_view.lines.gotoAndStop(this.m_frame);
		this.m_view.planes.gotoAndStop(this.m_frame);
	}

	public function startAnim():void {
		stage.addEventListener(Event.ENTER_FRAME, this.update);
		this.m_prevFrame = getTimer();
	}

	public function stopAnim():void {
		stage.removeEventListener(Event.ENTER_FRAME, this.update);
	}


}
}//package menu3

