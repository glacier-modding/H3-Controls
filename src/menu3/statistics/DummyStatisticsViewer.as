// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.statistics.DummyStatisticsViewer

package menu3.statistics {
import menu3.MenuElementBase;

import flash.display.Sprite;

public dynamic class DummyStatisticsViewer extends MenuElementBase {

	private var m_radarChartContainer:Sprite;
	private var m_radarChart:RadarChart;
	private var m_barChartContainer:Sprite;
	private var m_barChart:BarChart;
	private var m_lineChartContainer:Sprite;
	private var m_lineChart:LineChart;

	public function DummyStatisticsViewer(_arg_1:Object) {
		super(_arg_1);
		this.m_radarChartContainer = new Sprite();
		this.m_radarChartContainer.graphics.beginFill(0);
		this.m_radarChartContainer.graphics.drawRect(0, 0, 500, 500);
		this.m_radarChartContainer.graphics.endFill();
		addChild(this.m_radarChartContainer);
		this.m_radarChartContainer.x = 0;
		this.m_radarChartContainer.y = 0;
		this.m_barChartContainer = new Sprite();
		this.m_barChartContainer.graphics.beginFill(0);
		this.m_barChartContainer.graphics.drawRect(0, 0, 500, 500);
		this.m_barChartContainer.graphics.endFill();
		addChild(this.m_barChartContainer);
		this.m_barChartContainer.x = ((this.m_radarChartContainer.x + this.m_radarChartContainer.width) + 10);
		this.m_barChartContainer.y = 0;
		this.m_lineChartContainer = new Sprite();
		this.m_lineChartContainer.graphics.beginFill(0);
		this.m_lineChartContainer.graphics.drawRect(0, 0, 760, 550);
		this.m_lineChartContainer.graphics.endFill();
		addChild(this.m_lineChartContainer);
		this.m_lineChartContainer.x = ((this.m_barChartContainer.x + this.m_barChartContainer.width) + 10);
		this.m_lineChartContainer.y = 0;
	}

	override public function onUnregister():void {
		if (this.m_radarChart) {
			this.m_radarChart.onUnregister();
		}
		;
		if (this.m_barChart) {
			this.m_barChart.onUnregister();
		}
		;
		if (this.m_lineChart) {
			this.m_lineChart.onUnregister();
		}
		;
		super.onUnregister();
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		this.m_radarChart = new RadarChart();
		this.m_radarChart.x = (this.m_radarChartContainer.width >> 1);
		this.m_radarChart.y = (this.m_radarChartContainer.height >> 1);
		this.m_radarChartContainer.addChild(this.m_radarChart);
		this.m_radarChart.onSetData(_arg_1.graphdata.radarchart);
		this.m_barChart = new BarChart();
		this.m_barChart.x = 50;
		this.m_barChart.y = 350;
		this.m_barChartContainer.addChild(this.m_barChart);
		this.m_barChart.onSetData(_arg_1.graphdata.barchart);
		this.m_lineChart = new LineChart();
		this.m_lineChart.x = 50;
		this.m_lineChart.y = 460;
		this.m_lineChartContainer.addChild(this.m_lineChart);
		this.m_lineChart.onSetData(_arg_1.graphdata.linechart);
	}


}
}//package menu3.statistics

