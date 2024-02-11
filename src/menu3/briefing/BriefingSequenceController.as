// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.briefing.BriefingSequenceController

package menu3.briefing {
import common.BaseControl;

import flash.display.Sprite;

import common.menu.MenuConstants;
import common.Animate;
import common.menu.MenuUtils;

import flash.utils.*;

public class BriefingSequenceController extends BaseControl {

	private var m_sequenceContainer:Sprite;
	private var m_mask:Sprite;
	public var m_totalDuration:Number;
	private var m_baseDuration:Number;
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
	private var m_unitWidth:Number = (MenuConstants.BaseWidth / 10);
	private var m_unitHeight:Number = (MenuConstants.BaseHeight / 6);

	public function BriefingSequenceController() {
		var _local_1:Number = ((MenuConstants.BaseHeight - MenuConstants.ElusiveContractsBriefingHeight) / 2);
		this.m_sequenceContainer = new Sprite();
		this.m_sequenceContainer.name = "m_sequenceContainer";
		this.m_sequenceContainer.alpha = 0;
		addChild(this.m_sequenceContainer);
		this.m_mask = new Sprite();
		this.m_mask.name = "m_mask";
		this.m_mask.graphics.clear();
		this.m_mask.graphics.beginFill(0xFF00, 1);
		this.m_mask.graphics.drawRect(0, _local_1, MenuConstants.BaseWidth, MenuConstants.ElusiveContractsBriefingHeight);
		this.m_mask.graphics.endFill();
		this.m_sequenceContainer.addChild(this.m_mask);
		this.m_sequenceContainer.mask = this.m_mask;
	}

	public function startSequence():void {
		var sequenceChild:Sprite;
		this.m_sequenceContainer.alpha = 1;
		this.m_totalDuration = (this.m_animateInDuration + this.m_baseDuration);
		var i:int;
		while (i < this.m_sequenceContainer.numChildren) {
			sequenceChild = (this.m_sequenceContainer.getChildAt(i) as Sprite);
			if (sequenceChild["start"]) {
				var _local_2:* = sequenceChild;
				(_local_2["start"](this.m_baseDuration, this.m_animateInDuration));
			}

			i = (i + 1);
		}

		Animate.fromTo(this.m_sequenceContainer, this.m_animateInDuration, 0, {
			"x": (this.m_unitWidth * this.m_animateInStartRow),
			"y": (this.m_unitHeight * this.m_animateInStartCol)
		}, {
			"x": (this.m_unitWidth * this.m_animateInEndRow),
			"y": (this.m_unitHeight * this.m_animateInEndCol)
		}, this.m_animateInEasingType, function ():void {
			Animate.fromTo(m_sequenceContainer, m_animateOutDuration, m_baseDuration, {
				"x": (m_unitWidth * m_animateOutStartRow),
				"y": (m_unitHeight * m_animateOutStartCol)
			}, {
				"x": (m_unitWidth * m_animateOutEndRow),
				"y": (m_unitHeight * m_animateOutEndCol)
			}, m_animateOutEasingType, onSequenceEnd);
		});
	}

	private function onSequenceEnd():void {
		var _local_2:BaseControl;
		var _local_3:Sprite;
		Animate.kill(this.m_sequenceContainer);
		var _local_1:int;
		while (_local_1 < this.m_sequenceContainer.numChildren) {
			if (this.m_sequenceContainer.getChildAt(_local_1) != this.m_mask) {
				_local_2 = (this.m_sequenceContainer.getChildAt(_local_1) as BaseControl);
				trace((("ETBriefing | BriefingSequenceController | onSequenceEnd | Animate.kill(" + _local_2.getContainer().name) + ");"));
				Animate.kill(_local_2.getContainer());
				_local_3 = (this.m_sequenceContainer.getChildAt(_local_1) as Sprite);
				if (_local_3["stopCountDownTimer"]) {
					_local_3["stopCountDownTimer"];
				}

			}

			_local_1++;
		}

		this.m_sequenceContainer.alpha = 0;
		this.m_sequenceContainer.removeChild(this.m_mask);
	}

	override public function getContainer():Sprite {
		return (this.m_sequenceContainer);
	}

	public function set SequenceDuration(_arg_1:Number):void {
		this.m_baseDuration = _arg_1;
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

	public function onUnregister():void {
		trace("ETBriefingSequenceBase | onUnregister CALLED!!!!");
	}


}
}//package menu3.briefing

