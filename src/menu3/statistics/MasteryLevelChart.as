// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.statistics.MasteryLevelChart

package menu3.statistics {
import basic.PieChart;

import flash.display.Sprite;

import common.Animate;
import common.menu.MenuConstants;
import common.menu.MenuUtils;

public class MasteryLevelChart extends PieChart {

	private var m_data:Object = {};
	private var m_chartSize:Number = 142;
	private var m_gapSize:Number = 0.01;
	private var m_initialRotation:Number = -90;
	private var m_sliceSize:Number;
	private var m_rotationStep:Number;
	private var m_totalNumberOfSlices:int;
	private var m_completedNumberOfSlices:int;
	private var m_bgContainer:Sprite;
	private var m_sliceContainer:Sprite;
	private var m_valueDisplay:ChartValueDisplayView;

	public function MasteryLevelChart(_arg_1:Object):void {
		this.m_data = _arg_1;
		if (!this.m_data.isAvailable) {
			this.m_data.completed = "";
		}

		this.m_totalNumberOfSlices = this.m_data.total;
		this.m_completedNumberOfSlices = ((this.m_data.isAvailable) ? this.m_data.completed : 0);
		if (this.m_totalNumberOfSlices > 40) {
			this.m_completedNumberOfSlices = Math.ceil(((72 * this.m_completedNumberOfSlices) / this.m_totalNumberOfSlices));
			this.m_totalNumberOfSlices = 72;
			this.m_gapSize = -0.005;
		}

		this.m_sliceSize = (360 * ((1 / this.m_totalNumberOfSlices) - this.m_gapSize));
		this.m_rotationStep = (360 / this.m_totalNumberOfSlices);
		Animate.delay(this, 0.2, this.createBackground, null);
	}

	private function createBackground():void {
		var _local_2:Sprite;
		this.m_bgContainer = new Sprite();
		var _local_1:Sprite = new PieChartMask();
		addChild(_local_1);
		addChild(this.m_bgContainer);
		this.m_bgContainer.mask = _local_1;
		this.m_bgContainer.alpha = 0;
		this.m_bgContainer.scaleX = 0;
		this.m_bgContainer.scaleY = 0;
		var _local_3:Number = this.m_initialRotation;
		var _local_4:int;
		while (_local_4 < this.m_totalNumberOfSlices) {
			_local_2 = new Sprite();
			drawSlice(_local_2, (this.m_chartSize / 2), this.m_sliceSize, MenuConstants.COLOR_MENU_SOLID_BACKGROUND);
			_local_2.rotation = _local_3;
			_local_3 = (_local_3 + this.m_rotationStep);
			this.m_bgContainer.addChild(_local_2);
			_local_4++;
		}

		Animate.to(this.m_bgContainer, 0.2, 0, {
			"alpha": 1,
			"scaleX": 1,
			"scaleY": 1
		}, Animate.ExpoOut, this.createPieChart, null);
		this.createPieChartValue();
	}

	private function createPieChart():void {
		var _local_2:Sprite;
		this.m_sliceContainer = new Sprite();
		var _local_1:Sprite = new PieChartMask();
		addChild(_local_1);
		addChild(this.m_sliceContainer);
		this.m_sliceContainer.mask = _local_1;
		var _local_3:Number = this.m_initialRotation;
		var _local_4:Number = 0;
		var _local_5:int;
		while (_local_5 < this.m_completedNumberOfSlices) {
			_local_2 = new Sprite();
			_local_2.alpha = 0;
			drawSlice(_local_2, (this.m_chartSize / 2), this.m_sliceSize, MenuConstants.COLOR_WHITE);
			_local_2.rotation = _local_3;
			_local_3 = (_local_3 + this.m_rotationStep);
			this.m_sliceContainer.addChild(_local_2);
			Animate.to(_local_2, 0.3, _local_4, {"alpha": 1}, Animate.ExpoOut);
			_local_4 = (_local_4 + 0.02);
			_local_5++;
		}

	}

	private function createPieChartValue():void {
		this.m_valueDisplay = new ChartValueDisplayView();
		MenuUtils.setColor(this.m_valueDisplay, MenuConstants.COLOR_WHITE);
		this.m_valueDisplay.alpha = 0;
		this.m_valueDisplay.scaleX = 0;
		this.m_valueDisplay.scaleY = 0;
		addChild(this.m_valueDisplay);
		this.m_valueDisplay.label.text = this.m_data.completed;
		Animate.to(this.m_valueDisplay, 0.3, 0.1, {
			"alpha": 1,
			"scaleX": 1,
			"scaleY": 1
		}, Animate.ExpoOut);
	}

	public function destroy():void {
		this.m_sliceContainer = null;
		this.m_bgContainer = null;
		this.m_valueDisplay = null;
	}


}
}//package menu3.statistics

