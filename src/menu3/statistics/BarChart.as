// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.statistics.BarChart

package menu3.statistics {
import flash.display.Sprite;

import common.menu.MenuConstants;
import common.Animate;

import menu3.statistics.elements.BarChartLabel;
import menu3.statistics.elements.*;
import menu3.statistics.shapes.*;

public class BarChart extends Sprite {

	private var m_shapeData:BarChartData;
	private var m_view:Sprite;
	private var m_chartContainer:Sprite;
	private var m_barHeightMAX:Number = 500;
	private var m_barWidth:Number = 50;
	private var m_barSpacing:Number = 5;
	private var m_useAnimation:Boolean;


	public function onUnregister():void {
	}

	public function onSetData(_arg_1:Object):void {
		this.m_useAnimation = ((_arg_1.animate != null) ? _arg_1.animate : true);
		this.m_shapeData = new BarChartData(_arg_1);
		this.m_view = new Sprite();
		addChild(this.m_view);
		this.m_chartContainer = (this.m_view.addChild(new Sprite()) as Sprite);
		this.setupGraph();
	}

	private function setupGraph():void {
		var _local_1:Sprite;
		var _local_2:Number = 0;
		var _local_3:Number = 0;
		var _local_4:Number = 0;
		var _local_5:Number = 0;
		var _local_6:int;
		while (_local_6 < this.m_shapeData.scorePercentages.length) {
			_local_3 = (this.m_shapeData.scorePercentages[_local_6] / 100);
			if (_local_3 == 0) {
				_local_3 = 0.01;
			}

			_local_4 = (this.m_barHeightMAX * _local_3);
			_local_1 = this.drawBar(this.m_barWidth, _local_4, ((this.m_shapeData.playerIndex == _local_6) ? MenuConstants.COLOR_RED : MenuConstants.COLOR_WHITE));
			_local_1.x = _local_2;
			this.m_chartContainer.addChild(_local_1);
			_local_1.height = 1;
			Animate.to(_local_1, 0.2, _local_5, {"height": _local_4}, Animate.ExpoInOut);
			_local_2 = (_local_2 + (this.m_barWidth + this.m_barSpacing));
			_local_5 = (_local_5 + 0.02);
			_local_6++;
		}

		var _local_7:BarChartLabel = new BarChartLabel("Overview of where you are located compared to the global scores", 400);
		_local_7.y = 50;
		this.m_chartContainer.addChild(_local_7);
	}

	private function drawBar(_arg_1:Number, _arg_2:Number, _arg_3:uint):Sprite {
		var _local_4:Sprite = new Sprite();
		var _local_5:Sprite = new Sprite();
		_local_5.graphics.beginFill(_arg_3);
		_local_5.graphics.drawRect(0, 0, _arg_1, -(_arg_2));
		_local_5.graphics.endFill();
		_local_5.alpha = 0.8;
		_local_4.addChild(_local_5);
		return (_local_4);
	}


}
}//package menu3.statistics

class BarChartData {

	/*private*/
	internal var m_playerIndex:Number = 0;
	/*private*/
	internal var m_scorePercentages:Array = [];

	public function BarChartData(_arg_1:Object) {
		this.m_playerIndex = _arg_1.playerIndex;
		this.m_scorePercentages = _arg_1.scorePercentages;
	}

	public function get playerIndex():Number {
		return (this.m_playerIndex);
	}

	public function get scorePercentages():Array {
		return (this.m_scorePercentages);
	}


}


