// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.statistics.LineChart

package menu3.statistics {
import flash.display.Sprite;


import menu3.statistics.elements.LineChartLabel;

import common.menu.MenuConstants;

import flash.geom.Point;
import flash.events.Event;

import common.Animate;

import flash.display.*;


import menu3.statistics.*;

import common.menu.*;

import menu3.statistics.elements.*;
import menu3.statistics.shapes.*;

public class LineChart extends Sprite {

	private const GRAPH_TYPE_GLOBAL:String = "global";
	private const GRAPH_TYPE_PLAYER:String = "player";

	private var m_shapeData:LineChartData;
	private var m_view:Sprite;
	private var m_chartContainer:Sprite;
	private var m_globalChartContainer:Sprite;
	private var m_playerChartContainer:Sprite;
	private var m_labelContainer:Sprite;
	private var m_globalGraph:Vector.<LineChartPoint>;
	private var m_playerGraph:Vector.<LineChartPoint>;
	private var m_graphHeightMAX:Number = 370;
	private var m_graphWidthMAX:Number = 650;
	private var m_graphSpacing:Number = 0;
	private var m_useAnimation:Boolean;
	private var m_showGlobal:Boolean;
	private var m_showPlayer:Boolean;


	public function onUnregister():void {
	}

	public function onSetData(_arg_1:Object):void {
		this.m_useAnimation = ((_arg_1.animate != null) ? _arg_1.animate : true);
		this.m_showGlobal = ((_arg_1.showGlobal != null) ? _arg_1.showGlobal : true);
		this.m_showPlayer = ((_arg_1.showPlayer != null) ? _arg_1.showPlayer : true);
		this.m_shapeData = new LineChartData(_arg_1);
		this.m_view = new Sprite();
		addChild(this.m_view);
		this.m_chartContainer = (this.m_view.addChild(new Sprite()) as Sprite);
		this.m_globalChartContainer = (this.m_chartContainer.addChild(new Sprite()) as Sprite);
		this.m_playerChartContainer = (this.m_chartContainer.addChild(new Sprite()) as Sprite);
		this.m_labelContainer = (this.m_chartContainer.addChild(new Sprite()) as Sprite);
		this.setupGraph();
	}

	private function setupGraph():void {
		this.m_graphSpacing = Math.round((this.m_graphWidthMAX / (this.m_shapeData.global.length - 1)));
		this.createGraphFrame();
		this.createGraphPoints();
		if (this.m_useAnimation) {
			if (this.m_showGlobal) {
				this.animateGraph(this.GRAPH_TYPE_GLOBAL);
			}

			if (this.m_showPlayer) {
				this.animateGraph(this.GRAPH_TYPE_PLAYER);
			}

		} else {
			if (this.m_showGlobal) {
				this.drawGraph(this.GRAPH_TYPE_GLOBAL);
			}

			if (this.m_showPlayer) {
				this.drawGraph(this.GRAPH_TYPE_PLAYER);
			}

		}

	}

	private function createGraphFrame():void {
		var i:int;
		var playerInfo:LineChartLabel;
		var globalInfo:LineChartLabel;
		var xPos:Number = 0;
		var graphHeight:Number = (this.m_graphHeightMAX + 20);
		var graphWidth:Number = (this.m_graphWidthMAX + 20);
		var _local_2:* = this.m_chartContainer;
		with (_local_2) {
			graphics.clear();
			graphics.lineStyle(0, MenuConstants.COLOR_WHITE, 0.8, true, LineScaleMode.NONE, CapsStyle.NONE, JointStyle.MITER, 10);
			graphics.lineTo(0, -(graphHeight));
			graphics.lineTo(-5, -(graphHeight - 5));
			graphics.moveTo(0, -(graphHeight));
			graphics.lineTo(5, -(graphHeight - 5));
			graphics.moveTo(0, 0);
			graphics.lineTo(graphWidth, 0);
			graphics.lineTo((graphWidth - 5), 5);
			graphics.moveTo(graphWidth, 0);
			graphics.lineTo((graphWidth - 5), -5);
			graphics.lineStyle(0, MenuConstants.COLOR_WHITE, 0.2, true, LineScaleMode.NONE, CapsStyle.NONE, JointStyle.MITER, 10);
			graphics.moveTo(0, 0);
			i = 0;
			while (i < (m_shapeData.global.length - 1)) {
				xPos = (xPos + m_graphSpacing);
				graphics.moveTo(xPos, 0);
				graphics.lineTo(xPos, -(m_graphHeightMAX));
				i++;
			}

		}

		var xAxisValueInfo:LineChartLabel = new LineChartLabel("Playthroughs", false, MenuConstants.COLOR_WHITE, LineChartLabel.TEXT_ORIENTATION_RIGHT);
		xAxisValueInfo.x = graphWidth;
		xAxisValueInfo.y = 25;
		this.m_labelContainer.addChild(xAxisValueInfo);
		var yAxisValueInfo:LineChartLabel = new LineChartLabel("Score", false, MenuConstants.COLOR_WHITE, LineChartLabel.TEXT_ORIENTATION_CENTER);
		yAxisValueInfo.y = -(graphHeight + 20);
		this.m_labelContainer.addChild(yAxisValueInfo);
		if (this.m_showPlayer) {
			playerInfo = new LineChartLabel("My Score", true, MenuConstants.COLOR_RED);
			playerInfo.x = 6;
			playerInfo.y = 35;
			this.m_labelContainer.addChild(playerInfo);
		}

		if (this.m_showGlobal) {
			globalInfo = new LineChartLabel("Global Average", true, MenuConstants.COLOR_WHITE);
			globalInfo.x = 6;
			globalInfo.y = 60;
			this.m_labelContainer.addChild(globalInfo);
		}

	}

	private function createGraphPoints():void {
		var _local_1:int;
		var _local_2:LineChartPoint;
		var _local_3:Point;
		if (this.m_showGlobal) {
			this.m_globalGraph = new Vector.<LineChartPoint>();
			_local_1 = 0;
			while (_local_1 < this.m_shapeData.global.length) {
				_local_3 = new Point((_local_1 * this.m_graphSpacing), -(this.m_graphHeightMAX * (this.m_shapeData.global[_local_1] / 100)));
				_local_2 = new LineChartPoint(this.m_globalChartContainer, _local_3, MenuConstants.COLOR_WHITE);
				this.m_globalGraph.push(_local_2);
				_local_1++;
			}

		}

		if (this.m_showPlayer) {
			this.m_playerGraph = new Vector.<LineChartPoint>();
			_local_1 = 0;
			while (_local_1 < this.m_shapeData.player.length) {
				_local_3 = new Point((_local_1 * this.m_graphSpacing), -(this.m_graphHeightMAX * (this.m_shapeData.player[_local_1] / 100)));
				_local_2 = new LineChartPoint(this.m_playerChartContainer, _local_3, MenuConstants.COLOR_RED);
				this.m_playerGraph.push(_local_2);
				_local_1++;
			}

		}

	}

	private function drawGraph(type:String):void {
		var i:int;
		var container:Sprite = ((type == this.GRAPH_TYPE_GLOBAL) ? this.m_globalChartContainer : this.m_playerChartContainer);
		var graph:Vector.<LineChartPoint> = ((type == this.GRAPH_TYPE_GLOBAL) ? this.m_globalGraph : this.m_playerGraph);
		var color:uint = ((type == this.GRAPH_TYPE_GLOBAL) ? MenuConstants.COLOR_WHITE : MenuConstants.COLOR_RED);
		var _local_3:* = container;
		with (_local_3) {
			graphics.clear();
			graphics.lineStyle(1, color, 1, true, LineScaleMode.NONE, CapsStyle.NONE, JointStyle.MITER, 10);
			i = 0;
			while (i < graph.length) {
				graph[i].clip.y = graph[i].point.y;
				if (i == 0) {
					container.graphics.moveTo(graph[0].point.x, graph[0].point.y);
				} else {
					container.graphics.lineTo(graph[i].point.x, graph[i].point.y);
				}

				i++;
			}

		}

	}

	private function animateGraph(_arg_1:String):void {
		var _local_2:Vector.<LineChartPoint>;
		var _local_5:LineChartPoint;
		if (_arg_1 == this.GRAPH_TYPE_GLOBAL) {
			_local_2 = this.m_globalGraph;
			this.m_view.addEventListener(Event.ENTER_FRAME, this.updateGlobalGraph);
		} else {
			if (_arg_1 == this.GRAPH_TYPE_PLAYER) {
				_local_2 = this.m_playerGraph;
				this.m_view.addEventListener(Event.ENTER_FRAME, this.updatePlayerGraph);
			}

		}

		var _local_3:Number = 0;
		var _local_4:int = _local_2.length;
		var _local_6:int;
		while (_local_6 < _local_4) {
			_local_5 = _local_2[_local_6];
			_local_5.isAnimating = true;
			Animate.to(_local_5.clip, 0.4, _local_3, {
				"x": _local_5.point.x,
				"y": _local_5.point.y
			}, Animate.BackOut, this.setAnimationState, _arg_1, _local_5, false);
			_local_3 = (_local_3 + 0.01);
			_local_6++;
		}

	}

	private function setAnimationState(_arg_1:String, _arg_2:LineChartPoint, _arg_3:Boolean):void {
		var _local_4:Vector.<LineChartPoint>;
		_arg_2.isAnimating = _arg_3;
		if (_arg_1 == this.GRAPH_TYPE_GLOBAL) {
			_local_4 = this.m_globalGraph;
		} else {
			if (_arg_1 == this.GRAPH_TYPE_PLAYER) {
				_local_4 = this.m_playerGraph;
			}

		}

		var _local_5:Boolean = true;
		var _local_6:int = _local_4.length;
		var _local_7:int;
		while (_local_7 < _local_6) {
			if (_local_4[_local_7].isAnimating) {
				_local_5 = false;
				return;
			}

			_local_7++;
		}

		if (_arg_1 == this.GRAPH_TYPE_GLOBAL) {
			this.m_view.removeEventListener(Event.ENTER_FRAME, this.updateGlobalGraph);
		} else {
			if (_arg_1 == this.GRAPH_TYPE_PLAYER) {
				this.m_view.removeEventListener(Event.ENTER_FRAME, this.updatePlayerGraph);
			}

		}

	}

	private function updateGlobalGraph(evt:Event):void {
		var i:int;
		var _local_3:* = this.m_globalChartContainer;
		with (_local_3) {
			graphics.clear();
			graphics.lineStyle(1, MenuConstants.COLOR_WHITE, 1, true, LineScaleMode.NONE, CapsStyle.NONE, JointStyle.MITER, 10);
			i = 0;
			while (i < m_globalGraph.length) {
				if (i == 0) {
					graphics.moveTo(m_globalGraph[i].clip.x, m_globalGraph[i].clip.y);
				} else {
					graphics.lineTo(m_globalGraph[i].clip.x, m_globalGraph[i].clip.y);
				}

				i++;
			}

		}

	}

	private function updatePlayerGraph(evt:Event):void {
		var i:int;
		var _local_3:* = this.m_playerChartContainer;
		with (_local_3) {
			graphics.clear();
			graphics.lineStyle(1, MenuConstants.COLOR_RED, 1, true, LineScaleMode.NONE, CapsStyle.NONE, JointStyle.MITER, 10);
			i = 0;
			while (i < m_playerGraph.length) {
				if (i == 0) {
					graphics.moveTo(m_playerGraph[i].clip.x, m_playerGraph[i].clip.y);
				} else {
					graphics.lineTo(m_playerGraph[i].clip.x, m_playerGraph[i].clip.y);
				}

				i++;
			}

		}

	}


}
}//package menu3.statistics

import flash.display.Sprite;
import flash.geom.Point;

class LineChartData {

	/*private*/
	internal var m_global:Array = [];
	/*private*/
	internal var m_player:Array = [];

	public function LineChartData(_arg_1:Object) {
		this.m_global = _arg_1.global;
		this.m_player = _arg_1.player;
	}

	public function get global():Array {
		return (this.m_global);
	}

	public function get player():Array {
		return (this.m_player);
	}


}

class LineChartPoint {

	public var clip:Sprite;
	public var point:Point;
	public var isAnimating:Boolean;
	public var color:uint;

	public function LineChartPoint(_arg_1:Sprite, _arg_2:Point, _arg_3:uint = 0xFFFFFF, _arg_4:Boolean = false) {
		this.point = _arg_2;
		this.color = _arg_3;
		this.isAnimating = _arg_4;
		this.clip = new Sprite();
		this.clip.x = _arg_2.x;
		this.clip.y = 0;
		this.drawClip();
		_arg_1.addChild(this.clip);
	}

	/*private*/
	internal function drawClip():void {
		this.clip.visible = true;
		this.clip.graphics.clear();
		this.clip.graphics.beginFill(this.color, 1);
		this.clip.graphics.drawCircle(0, 0, 8);
		this.clip.graphics.endFill();
	}


}


