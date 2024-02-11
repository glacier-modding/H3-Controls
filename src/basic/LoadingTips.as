// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//basic.LoadingTips

package basic {
import common.BaseControl;

import flash.display.Shape;

import common.menu.MenuUtils;
import common.menu.MenuConstants;

import flash.events.Event;
import flash.utils.getTimer;
import flash.text.*;

public class LoadingTips extends BaseControl {

	private var m_view:LoadingTipsView;
	private var m_totalFrames:int = 20;
	private var m_deltaTime:Number;
	private var m_prevFrame:Number;
	private var m_currentFrame:Number;
	private var m_fpsToReach:int = 24;
	private var m_frameFactor:Number = 0;
	private var m_frame:int;
	private var m_animated:Boolean = false;
	private var m_background:Shape = new Shape();

	public function LoadingTips() {
		this.m_background.name = "m_background";
		this.m_background.visible = false;
		this.m_background.y = -70;
		this.m_background.graphics.beginFill(0);
		this.m_background.graphics.drawRect((-9999 / 2), 0, 9999, 70);
		addChild(this.m_background);
		this.m_view = new LoadingTipsView();
		this.m_view.line.alpha = 0.2;
		this.m_view.tips.alpha = 0;
		this.m_view.visible = false;
		addChild(this.m_view);
	}

	override public function onSetSize(_arg_1:Number, _arg_2:Number):void {
	}

	public function setBackgroundVisible(_arg_1:Boolean):void {
		this.m_background.visible = _arg_1;
	}

	public function onSetData(_arg_1:Object):void {
		var _local_2:String = (_arg_1 as String);
		if (_local_2 == "") {
			this.stopDeltaAnim();
		} else {
			this.m_view.visible = true;
			this.m_view.tips.title.autoSize = "left";
			MenuUtils.setupText(this.m_view.tips.title, _local_2, 22, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			this.startDeltaAnim();
		}
		;
	}

	public function startDeltaAnim():void {
		if (!this.m_animated) {
			this.m_view.tips.alpha = 0;
			this.m_prevFrame = 0;
			this.m_currentFrame = 0;
			this.m_frameFactor = 0;
			this.m_frame = 0;
			if (this.m_view.tips.title.numLines > 2) {
				this.m_view.tips.title.y = -6;
				this.m_view.tips.y = (((this.m_view.tips.title.numLines - 2) * -25) - 54);
			} else {
				if (this.m_view.tips.title.numLines == 2) {
					this.m_view.tips.title.y = -6;
					this.m_view.tips.y = -54;
				} else {
					this.m_view.tips.title.y = 19;
					this.m_view.tips.y = -54;
				}
				;
			}
			;
			this.m_animated = true;
			this.m_view.addEventListener(Event.ENTER_FRAME, this.updateDeltaAnim);
			this.m_prevFrame = getTimer();
		}
		;
	}

	public function stopDeltaAnim():void {
		if (this.m_animated) {
			this.m_animated = false;
			this.m_view.removeEventListener(Event.ENTER_FRAME, this.updateDeltaAnim);
			this.m_frameFactor = 0;
			this.m_frame = 0;
		}
		;
	}

	private function updateDeltaAnim(_arg_1:Event):void {
		this.m_currentFrame = getTimer();
		this.m_deltaTime = ((this.m_currentFrame - this.m_prevFrame) * 0.001);
		this.m_prevFrame = this.m_currentFrame;
		this.m_frameFactor = (this.m_frameFactor + (this.m_fpsToReach * this.m_deltaTime));
		this.m_frame = Math.ceil(this.m_frameFactor);
		if (this.m_frame >= this.m_totalFrames) {
			this.m_animated = false;
			this.m_view.removeEventListener(Event.ENTER_FRAME, this.updateDeltaAnim);
			this.m_frame = this.m_totalFrames;
		}
		;
		this.m_view.tips.alpha = (this.m_frame / this.m_totalFrames);
	}


}
}//package basic

