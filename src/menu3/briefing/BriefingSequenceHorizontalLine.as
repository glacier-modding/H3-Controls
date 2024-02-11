// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.briefing.BriefingSequenceHorizontalLine

package menu3.briefing {
import common.BaseControl;

import flash.display.Sprite;

import common.menu.MenuConstants;
import common.Animate;
import common.menu.MenuUtils;

public class BriefingSequenceHorizontalLine extends BaseControl {

	private var m_lineWidth:Number;
	private var m_linePositionRow:Number;
	private var m_linePositionCol:Number;
	private var m_animateInDuration:Number;
	private var m_animateInEasingType:int;
	private var m_animateOutDuration:Number;
	private var m_animateOutEasingType:int;
	private var m_line:Sprite;
	private var m_unitWidth:Number = (MenuConstants.BaseWidth / 10);
	private var m_unitHeight:Number = (MenuConstants.BaseHeight / 6);

	public function BriefingSequenceHorizontalLine() {
		trace("ETBriefing | BriefingSequenceHorizontalLine CALLED!!!");
		this.m_line = new Sprite();
		this.m_line.name = "m_line";
		this.m_line.alpha = 0;
		addChild(this.m_line);
	}

	public function start(_arg_1:Number, _arg_2:Number):void {
		this.m_line.graphics.clear();
		this.m_line.graphics.beginFill(MenuConstants.COLOR_GREY_ULTRA_LIGHT, 1);
		this.m_line.graphics.drawRect(0, 0, (this.m_unitWidth * this.m_lineWidth), 1);
		this.m_line.graphics.endFill();
		this.m_line.x = (this.m_unitWidth * this.m_linePositionRow);
		this.m_line.y = (this.m_unitHeight * this.m_linePositionCol);
		Animate.delay(this, _arg_2, this.startSequence, _arg_1);
	}

	private function startSequence(baseduration:Number):void {
		var delayDuration:Number;
		Animate.kill(this);
		delayDuration = ((baseduration - this.m_animateInDuration) - this.m_animateOutDuration);
		this.m_line.scaleX = 0;
		this.m_line.alpha = 1;
		Animate.to(this.m_line, this.m_animateInDuration, 0, {"scaleX": 1}, this.m_animateInEasingType, function ():void {
			Animate.to(m_line, m_animateOutDuration, delayDuration, {"scaleX": 0}, m_animateOutEasingType);
		});
	}

	override public function getContainer():Sprite {
		return (this.m_line);
	}

	public function set LineWidthInRows(_arg_1:Number):void {
		this.m_lineWidth = _arg_1;
	}

	public function set LinePositionRow(_arg_1:Number):void {
		this.m_linePositionRow = _arg_1;
	}

	public function set LinePositionCol(_arg_1:Number):void {
		this.m_linePositionCol = _arg_1;
	}

	public function set AnimateInDuration(_arg_1:Number):void {
		this.m_animateInDuration = _arg_1;
	}

	public function set AnimateInEasingType(_arg_1:String):void {
		this.m_animateInEasingType = MenuUtils.getEaseType(_arg_1);
	}

	public function set AnimateOutDuration(_arg_1:Number):void {
		this.m_animateOutDuration = _arg_1;
	}

	public function set AnimateOutEasingType(_arg_1:String):void {
		this.m_animateOutEasingType = MenuUtils.getEaseType(_arg_1);
	}


}
}//package menu3.briefing

