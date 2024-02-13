// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.statistics.RadarChart

package menu3.statistics {
import flash.display.Sprite;

import __AS3__.vec.Vector;

import flash.events.Event;

import menu3.statistics.shapes.Polygon;
import menu3.statistics.elements.RadarChartLabel;
import menu3.statistics.elements.RadarChartLine;

import common.menu.MenuConstants;
import common.Animate;

import flash.geom.Point;

import common.menu.MenuUtils;

import flash.display.*;

import __AS3__.vec.*;

import common.menu.*;

import menu3.statistics.elements.*;
import menu3.statistics.shapes.*;

public class RadarChart extends Sprite {

	private const GRAPH_TYPE_GLOBAL:String = "global";
	private const GRAPH_TYPE_PLAYER:String = "player";

	private var m_shapeData:RadarChartData;
	private var m_view:Sprite;
	private var m_bgContainer:Sprite;
	private var m_labelContainer:Sprite;
	private var m_globalChartContainer:ChartContainer;
	private var m_playerChartContainer:ChartContainer;
	private var m_globalGraph:Vector.<RadarChartPoint>;
	private var m_playerGraph:Vector.<RadarChartPoint>;
	private var m_useAnimation:Boolean;
	private var m_showGlobal:Boolean;
	private var m_showPlayer:Boolean;

	public function RadarChart():void {
	}

	public function onUnregister():void {
		this.m_view.removeEventListener(Event.ENTER_FRAME, this.updateGlobalGraph);
		this.m_view.removeEventListener(Event.ENTER_FRAME, this.updatePlayerGraph);
	}

	public function onSetData(_arg_1:Object):void {
		this.m_useAnimation = ((_arg_1.animate != null) ? _arg_1.animate : true);
		this.m_showGlobal = ((_arg_1.showGlobal != null) ? _arg_1.showGlobal : true);
		this.m_showPlayer = ((_arg_1.showPlayer != null) ? _arg_1.showPlayer : true);
		this.m_shapeData = new RadarChartData(_arg_1);
		this.m_shapeData.apothem = 170;
		this.m_view = new Sprite();
		addChild(this.m_view);
		this.m_bgContainer = (this.m_view.addChild(new Sprite()) as Sprite);
		this.m_labelContainer = (this.m_view.addChild(new Sprite()) as Sprite);
		this.m_globalChartContainer = new ChartContainer();
		this.m_playerChartContainer = new ChartContainer();
		this.m_view.addChild(this.m_globalChartContainer);
		this.m_view.addChild(this.m_playerChartContainer);
		this.setupGraph();
	}

	private function setupGraph():void {
		var _local_1:int;
		var _local_3:Polygon;
		var _local_4:RadarChartLabel;
		var _local_5:RadarChartLine;
		var _local_2:Array = [1, 0.77, 0.53, 0.29];
		_local_1 = 0;
		while (_local_1 < 4) {
			_local_3 = new Polygon(this.m_shapeData.radius, this.m_shapeData.numberOfSides, MenuConstants.COLOR_BLACK, MenuConstants.COLOR_WHITE, 2);
			_local_3.scaleX = (_local_3.scaleY = _local_2[_local_1]);
			this.m_bgContainer.addChild(_local_3);
			_local_1++;
		}

		var _local_6:Number = this.getInitialRotation();
		_local_1 = 0;
		while (_local_1 < this.m_shapeData.numberOfSides) {
			_local_5 = new RadarChartLine(this.m_shapeData.apothem);
			_local_5.rotation = _local_6;
			_local_4 = new RadarChartLabel(this.m_shapeData.statistics[_local_1].title, _local_5.rotation, 34, ((this.m_shapeData.statistics[_local_1].player > 0) && (this.m_showPlayer)), this.m_shapeData.sideLength, this.m_shapeData.apothem, this.m_shapeData.centralAngle);
			_local_5.addChild(_local_4);
			this.m_labelContainer.addChild(_local_5);
			_local_6 = (_local_6 + this.m_shapeData.centralAngle);
			_local_1++;
		}

		if (this.m_useAnimation) {
			if (this.m_showGlobal) {
				Animate.delay(this, 0.1, this.drawGraph, [this.GRAPH_TYPE_GLOBAL]);
			}

			if (this.m_showPlayer) {
				Animate.delay(this, 0.4, this.drawGraph, [this.GRAPH_TYPE_PLAYER]);
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

	private function drawGraph(_arg_1:String):void {
		var _local_10:Sprite;
		var _local_11:Number;
		var _local_2:Number = this.getInitialRotation();
		var _local_3:Point = new Point(0, -10);
		var _local_4:Point = new Point(0, -(this.m_shapeData.apothem));
		var _local_5:Point = new Point();
		var _local_6:Point = new Point();
		var _local_7:Number = 0;
		var _local_8:Number = 0;
		var _local_9:Vector.<RadarChartPoint> = new Vector.<RadarChartPoint>();
		if (_arg_1 == this.GRAPH_TYPE_GLOBAL) {
			this.m_globalGraph = _local_9;
			_local_10 = this.m_globalChartContainer.pointContainer;
		} else {
			if (_arg_1 == this.GRAPH_TYPE_PLAYER) {
				this.m_playerGraph = _local_9;
				_local_10 = this.m_playerChartContainer.pointContainer;
			}

		}

		var _local_12:int;
		while (_local_12 < this.m_shapeData.numberOfSides) {
			if (_arg_1 == this.GRAPH_TYPE_GLOBAL) {
				_local_11 = this.m_shapeData.statistics[_local_12].global;
			} else {
				if (_arg_1 == this.GRAPH_TYPE_PLAYER) {
					_local_11 = this.m_shapeData.statistics[_local_12].player;
				}

			}

			_local_7 = (_local_11 / this.m_shapeData.dataTotal);
			_local_5 = Point.interpolate(_local_4, _local_3, (_local_7 * 4));
			_local_8 = MenuUtils.toRadians(_local_2);
			_local_6 = new Point(((_local_5.x * Math.cos(_local_8)) - (_local_5.y * Math.sin(_local_8))), ((_local_5.x * Math.sin(_local_8)) + (_local_5.y * Math.cos(_local_8))));
			_local_9.push(new RadarChartPoint(_local_10, _local_6, true));
			_local_2 = (_local_2 + this.m_shapeData.centralAngle);
			_local_12++;
		}

		if (this.m_useAnimation) {
			this.animateGraph(_arg_1);
		} else {
			this.showGraph(_arg_1);
		}

	}

	private function getInitialRotation():Number {
		return (((this.m_shapeData.numberOfSides % 2) == 1) ? 0 : (this.m_shapeData.centralAngle / 2));
	}

	private function showGraph(type:String):void {
		var graph:Vector.<RadarChartPoint>;
		var container:Sprite;
		var lineAlpha:Number;
		var fillColor:uint;
		var fillAlpha:Number;
		var i:int;
		if (type == this.GRAPH_TYPE_GLOBAL) {
			graph = this.m_globalGraph;
			container = this.m_globalChartContainer.graphContainer;
			lineAlpha = 0.8;
			fillColor = MenuConstants.COLOR_WHITE;
			fillAlpha = 0.4;
		} else {
			if (type == this.GRAPH_TYPE_PLAYER) {
				graph = this.m_playerGraph;
				container = this.m_playerChartContainer.graphContainer;
				lineAlpha = 0.5;
				fillColor = MenuConstants.COLOR_RED;
				fillAlpha = 1;
			}

		}

		var _local_3:* = container;
		with (_local_3) {
			graphics.clear();
			graphics.lineStyle(0, MenuConstants.COLOR_WHITE, lineAlpha, true, LineScaleMode.NONE, CapsStyle.NONE, JointStyle.MITER, 10);
			graphics.beginFill(fillColor, fillAlpha);
			i = 0;
			while (i < graph.length) {
				if (i == 0) {
					graphics.moveTo(graph[i].point.x, graph[i].point.y);
				} else {
					graphics.lineTo(graph[i].point.x, graph[i].point.y);
				}

				graph[i].clip.x = graph[i].point.x;
				graph[i].clip.y = graph[i].point.y;
				i++;
			}

			graphics.lineTo(graph[0].point.x, graph[0].point.y);
			graphics.endFill();
		}

	}

	private function animateGraph(_arg_1:String):void {
		var _local_2:Vector.<RadarChartPoint>;
		var _local_5:RadarChartPoint;
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

	private function setAnimationState(_arg_1:String, _arg_2:RadarChartPoint, _arg_3:Boolean):void {
		var _local_4:Vector.<RadarChartPoint>;
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
		var _local_3:* = this.m_globalChartContainer.graphContainer;
		with (_local_3) {
			graphics.clear();
			graphics.lineStyle(0, MenuConstants.COLOR_WHITE, 0.8, true, LineScaleMode.NONE, CapsStyle.NONE, JointStyle.MITER, 10);
			graphics.beginFill(MenuConstants.COLOR_WHITE, 0.4);
			i = 0;
			while (i < m_globalGraph.length) {
				if (i == 0) {
					graphics.moveTo(m_globalGraph[i].clip.x, m_globalGraph[i].clip.y);
				} else {
					graphics.lineTo(m_globalGraph[i].clip.x, m_globalGraph[i].clip.y);
				}

				i++;
			}

			graphics.lineTo(m_globalGraph[0].clip.x, m_globalGraph[0].clip.y);
			graphics.endFill();
		}

	}

	private function updatePlayerGraph(evt:Event):void {
		var i:int;
		var _local_3:* = this.m_playerChartContainer.graphContainer;
		with (_local_3) {
			graphics.clear();
			graphics.beginFill(MenuConstants.COLOR_RED, 1);
			i = 0;
			while (i < m_playerGraph.length) {
				if (i == 0) {
					graphics.moveTo(m_playerGraph[i].clip.x, m_playerGraph[i].clip.y);
				} else {
					graphics.lineTo(m_playerGraph[i].clip.x, m_playerGraph[i].clip.y);
				}

				i++;
			}

			graphics.lineTo(m_playerGraph[0].clip.x, m_playerGraph[0].clip.y);
			graphics.endFill();
		}

	}


}
}//package menu3.statistics

import common.menu.MenuUtils;

import flash.geom.Point;
import flash.display.Sprite;

import common.menu.MenuConstants;

class RadarChartData {

	/*private*/
	internal var m_apothem:Number = 170;
	/*private*/
	internal var m_radius:Number = 0;
	/*private*/
	internal var m_sideLength:Number = 0;
	/*private*/
	internal var m_numberOfSides:Number = 0;
	/*private*/
	internal var m_centralAngle:Number = 0;
	/*private*/
	internal var m_dataTotal:Number = 0;
	/*private*/
	internal var m_statistics:Array = [];

	public function RadarChartData(_arg_1:Object) {
		this.m_dataTotal = _arg_1.total;
		this.m_statistics = _arg_1.statistics;
		this.m_numberOfSides = this.m_statistics.length;
		this.m_centralAngle = (360 / this.m_numberOfSides);
		this.m_sideLength = ((Math.tan(MenuUtils.toRadians((360 / (this.m_numberOfSides * 2)))) * this.m_apothem) * 2);
		this.m_radius = (this.m_apothem / Math.cos(MenuUtils.toRadians((180 / this.m_numberOfSides))));
	}

	public function set apothem(_arg_1:Number):void {
		this.m_apothem = _arg_1;
		this.m_radius = (this.m_apothem / Math.cos(MenuUtils.toRadians((180 / this.m_numberOfSides))));
		this.m_sideLength = ((Math.tan(MenuUtils.toRadians((360 / (this.m_numberOfSides * 2)))) * this.m_apothem) * 2);
	}

	public function get apothem():Number {
		return (this.m_apothem);
	}

	public function get radius():Number {
		return (this.m_radius);
	}

	public function get sideLength():Number {
		return (this.m_sideLength);
	}

	public function get dataTotal():Number {
		return (this.m_dataTotal);
	}

	public function get statistics():Array {
		return (this.m_statistics);
	}

	public function get numberOfSides():Number {
		return (this.m_numberOfSides);
	}

	public function get centralAngle():Number {
		return (this.m_centralAngle);
	}


}

class RadarChartPoint {

	public var point:Point;
	public var isAnimating:Boolean;
	public var clip:Sprite;

	public function RadarChartPoint(_arg_1:Sprite, _arg_2:Point, _arg_3:Boolean = false, _arg_4:Boolean = false) {
		this.point = _arg_2;
		this.isAnimating = _arg_4;
		this.clip = new Sprite();
		this.clip.x = 0;
		this.clip.y = 0;
		_arg_1.addChild(this.clip);
		if (_arg_3) {
			this.drawClip();
		}

	}

	/*private*/
	internal function drawClip():void {
		this.clip.visible = true;
		this.clip.graphics.clear();
		this.clip.graphics.beginFill(MenuConstants.COLOR_WHITE, 1);
		this.clip.graphics.drawCircle(0, 0, 3);
		this.clip.graphics.endFill();
	}


}

class ChartContainer extends Sprite {

	public var graphContainer:Sprite;
	public var pointContainer:Sprite;

	public function ChartContainer() {
		this.graphContainer = (addChild(new Sprite()) as Sprite);
		this.pointContainer = (addChild(new Sprite()) as Sprite);
	}

}


