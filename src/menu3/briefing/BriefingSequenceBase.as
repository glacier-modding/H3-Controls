// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.briefing.BriefingSequenceBase

package menu3.briefing {
import common.BaseControl;
import common.Animate;

public class BriefingSequenceBase extends BaseControl {

	public var m_totalDuration:Number;
	private var m_staggeredSequencesArray:Array = new Array();


	public function startSequence():void {
		var _local_1:BriefingSequenceController = (this.m_staggeredSequencesArray.shift() as BriefingSequenceController);
		_local_1.startSequence();
		Animate.delay(this, _local_1.m_totalDuration, this.onCurrentSequenceEnd, _local_1);
	}

	private function onCurrentSequenceEnd(_arg_1:BriefingSequenceController):void {
		Animate.kill(this);
		if (this.m_staggeredSequencesArray.length) {
			trace("ETBriefing | BriefingSequenceBase | onCurrentSequenceEnd | GO NEXT");
			this.startSequence();
		} else {
			trace("ETBriefing | BriefingSequenceBase | onCurrentSequenceEnd | STOP TEH MADNESS");
		}
		;
	}

	override public function onChildrenAttached():void {
		super.onChildrenAttached();
		var _local_1:int;
		while (_local_1 < getContainer().numChildren) {
			this.m_staggeredSequencesArray.push(getContainer().getChildAt(_local_1));
			_local_1++;
		}
		;
	}

	public function onUnregister():void {
		trace("BriefingSequenceBase | onUnregister CALLED!!!!");
	}


}
}//package menu3.briefing

