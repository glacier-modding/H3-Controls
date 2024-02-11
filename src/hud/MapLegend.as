// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.MapLegend

package hud {
import common.BaseControl;

import flash.display.Sprite;

import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.TaskletSequencer;
import common.Localization;

public class MapLegend extends BaseControl {

	private static const Y_START:Number = 77;

	private var m_container:Sprite;
	private var m_background_mc:MapLegendView;
	private var m_headerLine:MapLegendListItemView;
	private var m_rowByControlName:Object = {};

	public function MapLegend():void {
		this.m_container = new Sprite();
		this.m_container.visible = false;
		addChild(this.m_container);
		this.m_background_mc = new MapLegendView();
		MenuUtils.setColor(this.m_background_mc.back_mc, MenuConstants.COLOR_MENU_TABS_BACKGROUND, true, MenuConstants.MenuElementBackgroundAlpha);
		this.m_container.addChild(this.m_background_mc);
		MenuUtils.setupTextUpper(this.m_background_mc.info_mapname_txt, "", 24, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
		this.m_headerLine = new MapLegendListItemView();
		this.m_headerLine.gotoAndStop(2);
		this.m_headerLine.y = Y_START;
		this.m_container.addChild(this.m_headerLine);
		this.getOrCreateRow("hud.maptrackers.NpcMapTracker").visible = false;
		this.getOrCreateRow("hud.maptrackers.SuitcaseMapTracker").visible = false;
		this.getOrCreateRow("hud.maptrackers.AreaUndiscoveredMapTracker").visible = false;
		this.getOrCreateRow("hud.maptrackers.PlayerHeroMapTracker").visible = false;
		this.getOrCreateRow("hud.maptrackers.StairDownMapTracker").visible = false;
		this.getOrCreateRow("hud.maptrackers.StairUpMapTracker").visible = false;
		this.getOrCreateRow("hud.maptrackers.StairUpDownMapTracker").visible = false;
	}

	private function getOrCreateRow(_arg_1:String):MapLegendRow {
		var _local_2:MapLegendRow = this.m_rowByControlName[_arg_1];
		if (_local_2 == null) {
			_local_2 = new MapLegendRow(_arg_1);
			this.m_rowByControlName[_arg_1] = _local_2;
			this.m_container.addChild(_local_2);
		}

		return (_local_2);
	}

	public function onMapChanged(_arg_1:Object):void {
		this.onSetData(_arg_1);
	}

	public function onSetData(data:Object):void {
		if (data == null) {
			this.m_container.visible = false;
			return;
		}

		TaskletSequencer.getGlobalInstance().addChunk(function ():void {
			var _local_2:MapLegendRow;
			var _local_3:Object;
			m_container.visible = true;
			m_background_mc.visible = true;
			m_background_mc.info_mapname_txt.htmlText = (((!(data.lstrLocation == null)) && (!(data.lstrLocation == ""))) ? data.lstrLocation : (((!(data.Location == null)) && (!(data.Location == ""))) ? Localization.get((("UI_" + data.Location) + "_CITY")) : ""));
			var _local_1:Number = Y_START;
			for each (_local_2 in m_rowByControlName) {
				_local_2.visible = false;
			}

			for each (_local_3 in data.LegendTrackers) {
				_local_2 = getOrCreateRow(_local_3.ControlName);
				_local_2.visible = true;
				_local_2.y = _local_1;
				_local_1 = (_local_1 + _local_2.dyTotal);
			}

			_local_1 = (_local_1 + 10);
			m_background_mc.back_mc.height = _local_1;
		});
	}


}
}//package hud

import flash.display.Sprite;
import flash.display.DisplayObject;

import common.Localization;

import flash.utils.getDefinitionByName;

import hud.maptrackers.BaseMapTracker;

import common.menu.MenuUtils;
import common.menu.MenuConstants;

class MapLegendRow extends Sprite {

	/*private*/
	static const Y_SPACING:Number = 50;

	public var dyTotal:Number = 0;

	public function MapLegendRow(_arg_1:String) {
		var _local_2:DisplayObject;
		var _local_3:Array;
		var _local_4:String;
		var _local_5:Class;
		var _local_6:String;
		super();
		this.name = ("row_" + _arg_1);
		if (_arg_1 == "hud.maptrackers.NpcMapTracker") {
			_local_2 = new minimapBlipTargetView();
			_local_3 = [Localization.get("UI_MAP_TARGET")];
		} else {
			_local_5 = (getDefinitionByName(_arg_1) as Class);
			_local_2 = new (_local_5)();
			_local_6 = BaseMapTracker(_local_2).getTextForLegend();
			if (_local_6 == "") {
				_local_3 = [];
			} else {
				_local_3 = _local_6.split(";");
			}

		}

		if (_arg_1 == "hud.maptrackers.PlayerHeroMapTracker") {
			_local_2.scaleX = (_local_2.scaleY = 0.7);
			_local_2.x = -7;
		} else {
			_local_2.scaleX = (_local_2.scaleY = 0.769);
		}

		for each (_local_4 in _local_3) {
			this.addMapLegendListItemView(_local_4, _local_2);
		}

	}

	/*private*/
	function addMapLegendListItemView(_arg_1:String, _arg_2:DisplayObject):void {
		var _local_3:MapLegendListItemView = new MapLegendListItemView();
		if (_arg_1 == "DIVIDERLINE") {
			_local_3.gotoAndStop(2);
			this.dyTotal = (this.dyTotal + 10);
			_local_3.y = this.dyTotal;
		} else {
			_local_3.gotoAndStop(1);
			_local_3.label_txt.visible = true;
			MenuUtils.setupTextUpper(_local_3.label_txt, ((_arg_1) || ("")), 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			_local_3.label_txt.y = (29 - Math.floor((_local_3.label_txt.textHeight / 2)));
			_local_3.icon_mc.addChild(_arg_2);
			_local_3.y = this.dyTotal;
			this.dyTotal = (this.dyTotal + Y_SPACING);
		}

		addChild(_local_3);
	}


}


