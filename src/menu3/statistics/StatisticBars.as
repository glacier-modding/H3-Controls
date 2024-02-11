// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.statistics.StatisticBars

package menu3.statistics {
import flash.display.Sprite;
import flash.display.MovieClip;

import common.Animate;

public class StatisticBars extends Sprite {

	private var m_view:StatisticsBarView;
	private var m_data:Object;
	private var m_showValues:Boolean = true;
	private var m_statisticBars:Array = [];

	public function StatisticBars(_arg_1:Object):void {
		this.m_data = _arg_1;
		this.m_showValues = this.m_data.isAvailable;
		this.m_view = new StatisticsBarView();
		addChild(this.m_view);
		this.init();
	}

	private function init():void {
		var _local_1:MovieClip;
		var _local_2:StatisticBar;
		var _local_3:int;
		while (_local_3 < this.m_view.numChildren) {
			_local_1 = (this.m_view.getChildByName(("bar" + (_local_3 + 1))) as MovieClip);
			if (this.m_data[_local_3]) {
				_local_2 = new StatisticBar(_local_1, this.m_showValues);
				this.m_statisticBars.push(_local_2);
				_local_2.init(this.m_data[_local_3].title, this.m_data[_local_3].completed, this.m_data[_local_3].total);
			} else {
				_local_1.visible = false;
			}
			;
			_local_3++;
		}
		;
		this.show();
	}

	private function show():void {
		var _local_1:MovieClip;
		var _local_4:StatisticBar;
		Animate.fromTo(this.m_view, 0.3, 0, {"alpha": 0}, {"alpha": 1}, Animate.ExpoOut);
		var _local_2:Number = 0;
		var _local_3:int;
		while (_local_3 < this.m_statisticBars.length) {
			_local_4 = this.m_statisticBars[_local_3];
			_local_4.show(_local_2);
			_local_2 = (_local_2 + 0.05);
			_local_3++;
		}
		;
	}

	public function destroy():void {
		var _local_2:StatisticBar;
		Animate.kill(this.m_view);
		var _local_1:int;
		while (_local_1 < this.m_statisticBars.length) {
			_local_2 = this.m_statisticBars[_local_1];
			_local_2.destroy();
			_local_1++;
		}
		;
		this.m_statisticBars.length = 0;
		while (this.m_view.numChildren > 0) {
			if ((this.m_view.getChildAt(0) is MovieClip)) {
				MovieClip(this.m_view.getChildAt(0)).gotoAndStop(1);
			}
			;
			this.m_view.removeChild(this.m_view.getChildAt(0));
		}
		;
		removeChild(this.m_view);
		this.m_view = null;
	}


}
}//package menu3.statistics

