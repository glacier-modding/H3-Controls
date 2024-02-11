// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.briefing.BriefingSequenceRedOverlay

package menu3.briefing {
import common.BaseControl;

import flash.display.Sprite;

import common.menu.MenuConstants;
import common.Animate;
import common.menu.MenuUtils;

public class BriefingSequenceRedOverlay extends BaseControl {

	private var m_animateInDuration:Number;
	private var m_animateInStartRow:Number;
	private var m_animateInEndRow:Number;
	private var m_animateInStartCol:Number;
	private var m_animateInEndCol:Number;
	private var m_animateInEasingType:int;
	private var m_animateOutDuration:Number;
	private var m_animateOutStartRow:Number;
	private var m_animateOutEndRow:Number;
	private var m_animateOutStartCol:Number;
	private var m_animateOutEndCol:Number;
	private var m_animateOutEasingType:int;
	private var m_overlay:Sprite;
	private var m_unitWidth:Number = (MenuConstants.BaseWidth / 10);
	private var m_unitHeight:Number = (MenuConstants.BaseHeight / 6);

	public function BriefingSequenceRedOverlay() {
		trace("ETBriefing | BriefingSequenceRedOverlay CALLED!!!");
		this.m_overlay = new Sprite();
		this.m_overlay.name = "m_overlay";
		this.m_overlay.graphics.clear();
		this.m_overlay.graphics.beginFill(MenuConstants.COLOR_RED, 1);
		this.m_overlay.graphics.drawRect(0, 0, MenuConstants.BaseWidth, MenuConstants.BaseHeight);
		this.m_overlay.graphics.endFill();
		addChild(this.m_overlay);
		this.m_overlay.blendMode = "multiply";
	}

	public function start(_arg_1:Number, _arg_2:Number):void {
		this.m_overlay.x = (this.m_unitWidth * this.m_animateInStartRow);
		this.m_overlay.y = (this.m_unitHeight * this.m_animateInStartCol);
		Animate.delay(this, _arg_2, this.startSequence, _arg_1);
	}

	private function startSequence(baseduration:Number):void {
		var delayDuration:Number;
		Animate.kill(this);
		delayDuration = ((baseduration - this.m_animateInDuration) - this.m_animateOutDuration);
		Animate.to(this.m_overlay, this.m_animateInDuration, 0, {
			"x": (this.m_unitWidth * this.m_animateInEndRow),
			"y": (this.m_unitHeight * this.m_animateInEndCol)
		}, this.m_animateInEasingType, function ():void {
			Animate.fromTo(m_overlay, m_animateOutDuration, delayDuration, {
				"x": (m_unitWidth * m_animateOutStartRow),
				"y": (m_unitHeight * m_animateOutStartCol)
			}, {
				"x": (m_unitWidth * m_animateOutEndRow),
				"y": (m_unitHeight * m_animateOutEndCol)
			}, m_animateOutEasingType);
		});
	}

	override public function getContainer():Sprite {
		return (this.m_overlay);
	}

	public function set AnimateInDuration(_arg_1:Number):void {
		this.m_animateInDuration = _arg_1;
	}

	public function set AnimateInStartRow(_arg_1:Number):void {
		this.m_animateInStartRow = _arg_1;
	}

	public function set AnimateInEndRow(_arg_1:Number):void {
		this.m_animateInEndRow = _arg_1;
	}

	public function set AnimateInStartCol(_arg_1:Number):void {
		this.m_animateInStartCol = _arg_1;
	}

	public function set AnimateInEndCol(_arg_1:Number):void {
		this.m_animateInEndCol = _arg_1;
	}

	public function set AnimateInEasingType(_arg_1:String):void {
		this.m_animateInEasingType = MenuUtils.getEaseType(_arg_1);
	}

	public function set AnimateOutDuration(_arg_1:Number):void {
		this.m_animateOutDuration = _arg_1;
	}

	public function set AnimateOutStartRow(_arg_1:Number):void {
		this.m_animateOutStartRow = _arg_1;
	}

	public function set AnimateOutEndRow(_arg_1:Number):void {
		this.m_animateOutEndRow = _arg_1;
	}

	public function set AnimateOutStartCol(_arg_1:Number):void {
		this.m_animateOutStartCol = _arg_1;
	}

	public function set AnimateOutEndCol(_arg_1:Number):void {
		this.m_animateOutEndCol = _arg_1;
	}

	public function set AnimateOutEasingType(_arg_1:String):void {
		this.m_animateOutEasingType = MenuUtils.getEaseType(_arg_1);
	}


}
}//package menu3.briefing

