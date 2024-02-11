// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.sniper.TargetTimerElement

package hud.sniper {
import common.BaseControl;
import common.Animate;
import common.menu.MenuUtils;
import common.menu.MenuConstants;

public class TargetTimerElement extends BaseControl {

	public static const BAR_ELEMENT_FADE_ANIM_TIME:Number = 0.3;

	private var m_view:TargetTimerElementView;
	private var m_initialSeconds:int;
	private var m_initialScaleFactor:Number;
	private var m_initialNumberOfNPCs:int;
	private var m_prevNumberOfNPCs:int;

	public function TargetTimerElement() {
		this.m_view = new TargetTimerElementView();
		this.m_view.timer.valuebar.alpha = 0.25;
		addChild(this.m_view);
	}

	public function updateAndShowObjectives(_arg_1:Object):void {
		Animate.kill(this.m_view);
		this.m_view.alpha = 1;
	}

	public function updateTimers(_arg_1:Array):void {
		var _local_2:Object = _arg_1[0];
		MenuUtils.setupText(this.m_view.timer.time_txt, _local_2.timerString, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		var _local_3:String = _local_2.timerString.slice(0, 2);
		var _local_4:String = _local_2.timerString.slice(3, 5);
		var _local_5:int = ((int(_local_3) * 60) + int(_local_4));
		if (!this.m_initialSeconds) {
			this.m_initialSeconds = _local_5;
			this.m_initialScaleFactor = (258 / _local_5);
		}
		;
		this.m_view.timer.valuebar.width = (this.m_initialScaleFactor * _local_5);
	}

	public function updateCounters(countersArray:Array):void {
		var counterData:Object;
		var numberOfNpcsLeft:int;
		var i:Number = 0;
		while (i < countersArray.length) {
			counterData = countersArray[i];
			if (counterData.isActive) {
				numberOfNpcsLeft = int(counterData.counterString);
				if (!this.m_initialNumberOfNPCs) {
					this.m_initialNumberOfNPCs = numberOfNpcsLeft;
					Animate.fromTo(this.m_view.npcs, 1, 0, {"frames": 1}, {"frames": this.m_initialNumberOfNPCs}, Animate.ExpoIn);
				}
				;
				if (numberOfNpcsLeft == this.m_prevNumberOfNPCs) {
					return;
				}
				;
				if (numberOfNpcsLeft != this.m_initialNumberOfNPCs) {
					if (counterData.counterExtraData.TargetEscaped) {
						this.m_view.npcs[("n_" + (numberOfNpcsLeft + 1))].gotoAndStop("escaped");
					} else {
						Animate.fromTo(this.m_view.npcs[("n_" + (numberOfNpcsLeft + 1))], 0.5, 0, {"frames": 2}, {"frames": 32}, Animate.ExpoOut, function ():void {
							Animate.kill(m_view.npcs[("n_" + (numberOfNpcsLeft + 1))]);
							m_view.npcs[("n_" + (numberOfNpcsLeft + 1))].gotoAndStop("dead");
						});
					}
					;
				}
				;
				this.m_prevNumberOfNPCs = numberOfNpcsLeft;
			}
			;
			i++;
		}
		;
	}

	public function hideObjectives():void {
		Animate.kill(this.m_view);
		Animate.legacyTo(this.m_view, BAR_ELEMENT_FADE_ANIM_TIME, {"alpha": 0}, Animate.Linear, function ():void {
			Animate.kill(m_view);
			m_view.alpha = 0;
		});
	}


}
}//package hud.sniper

