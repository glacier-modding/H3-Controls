// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.evergreen.misc.LocationIntelBlock

package hud.evergreen.misc {
import flash.display.Sprite;
import flash.text.TextField;

import common.menu.MenuUtils;
import common.menu.MenuConstants;

import flash.text.TextFieldAutoSize;

import common.Localization;

public class LocationIntelBlock extends Sprite {

	public static const DYGAP:Number = 10;

	private var m_header_txt:TextField = new TextField();
	private var m_dottedLine:DottedLineAlt = new DottedLineAlt(1);
	private var m_labelTargets_txt:TextField = new TextField();
	private var m_labelSafes_txt:TextField = new TextField();
	private var m_labelMules_txt:TextField = new TextField();
	private var m_labelSuppliers_txt:TextField = new TextField();
	private var m_numTargets_txt:TextField = new TextField();
	private var m_numSafes_txt:TextField = new TextField();
	private var m_numMules_txt:TextField = new TextField();
	private var m_numSuppliers_txt:TextField = new TextField();
	private var m_stackTargets:IconStack = new IconStack("evergreen_target");
	private var m_stackSafes:IconStack = new IconStack("evergreen_safe");
	private var m_stackMules:IconStack = new IconStack("evergreen_mules");
	private var m_stackSuppliers:IconStack = new IconStack("evergreen_suppliers");
	private var s_targetLabel_targets:String;
	private var s_targetLabel_suspects:String;
	private var m_dyContentHeight:Number = 0;
	private var m_dxContentWidth:Number = 0;
	private var m_pxPadding:Number = 0;

	public function LocationIntelBlock(_arg_1:Number, _arg_2:Number) {
		this.m_dxContentWidth = _arg_1;
		this.m_pxPadding = _arg_2;
		this.m_header_txt.name = "m_header_txt";
		this.m_dottedLine.name = "m_dottedLine";
		this.m_labelTargets_txt.name = "m_labelTargets_txt";
		this.m_labelSafes_txt.name = "m_labelSafes_txt";
		this.m_labelMules_txt.name = "m_labelMules_txt";
		this.m_labelSuppliers_txt.name = "m_labelSuppliers_txt";
		this.m_numTargets_txt.name = "m_numTargets_txt";
		this.m_numSafes_txt.name = "m_numSafes_txt";
		this.m_numMules_txt.name = "m_numMules_txt";
		this.m_numSuppliers_txt.name = "m_numSuppliers_txt";
		this.m_stackTargets.name = "m_stackTargets";
		this.m_stackSafes.name = "m_stackSafes";
		this.m_stackMules.name = "m_stackMules";
		this.m_stackSuppliers.name = "m_stackSuppliers";
		addChild(this.m_header_txt);
		addChild(this.m_dottedLine);
		addChild(this.m_labelTargets_txt);
		addChild(this.m_labelSafes_txt);
		addChild(this.m_labelMules_txt);
		addChild(this.m_labelSuppliers_txt);
		addChild(this.m_numTargets_txt);
		addChild(this.m_numSafes_txt);
		addChild(this.m_numMules_txt);
		addChild(this.m_numSuppliers_txt);
		addChild(this.m_stackTargets);
		addChild(this.m_stackSafes);
		addChild(this.m_stackMules);
		addChild(this.m_stackSuppliers);
		MenuUtils.setupText(this.m_header_txt, "", 18, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_labelTargets_txt, "", 24, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_labelSafes_txt, "", 24, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_labelMules_txt, "", 24, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_labelSuppliers_txt, "", 24, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_numTargets_txt, "", 24, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_numSafes_txt, "", 24, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_numMules_txt, "", 24, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_numSuppliers_txt, "", 24, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
		this.m_header_txt.autoSize = TextFieldAutoSize.LEFT;
		this.m_labelTargets_txt.autoSize = TextFieldAutoSize.LEFT;
		this.m_labelSafes_txt.autoSize = TextFieldAutoSize.LEFT;
		this.m_labelMules_txt.autoSize = TextFieldAutoSize.LEFT;
		this.m_labelSuppliers_txt.autoSize = TextFieldAutoSize.LEFT;
		this.m_numTargets_txt.autoSize = TextFieldAutoSize.LEFT;
		this.m_numSafes_txt.autoSize = TextFieldAutoSize.LEFT;
		this.m_numMules_txt.autoSize = TextFieldAutoSize.LEFT;
		this.m_numSuppliers_txt.autoSize = TextFieldAutoSize.LEFT;
		this.m_header_txt.text = Localization.get("UI_EVEREGREEN_SAFEHOUSE_WORLDMAP_LOCATIONINTEL_HEADER").toUpperCase();
		this.m_labelSafes_txt.text = Localization.get("UI_EVEREGREEN_SAFEHOUSE_WORLDMAP_LOCATIONINTEL_SAFES").toUpperCase();
		this.m_labelMules_txt.text = Localization.get("UI_EVEREGREEN_SAFEHOUSE_WORLDMAP_LOCATIONINTEL_MULES").toUpperCase();
		this.m_labelSuppliers_txt.text = Localization.get("UI_EVEREGREEN_SAFEHOUSE_WORLDMAP_LOCATIONINTEL_SUPPLIERS").toUpperCase();
		this.s_targetLabel_targets = Localization.get("UI_EVEREGREEN_SAFEHOUSE_WORLDMAP_LOCATIONINTEL_TARGETS").toUpperCase();
		this.s_targetLabel_suspects = Localization.get("UI_EVEREGREEN_SAFEHOUSE_WORLDMAP_LOCATIONINTEL_SUSPECTS").toUpperCase();
		this.m_dottedLine.y = ((this.m_header_txt.y + this.m_header_txt.textHeight) + 10);
		this.m_dottedLine.updateLineLength(this.m_dxContentWidth);
		this.m_stackTargets.scaleX = (this.m_stackTargets.scaleY = (this.m_stackSafes.scaleX = (this.m_stackSafes.scaleY = (this.m_stackMules.scaleX = (this.m_stackMules.scaleY = (this.m_stackSuppliers.scaleX = (this.m_stackSuppliers.scaleY = 0.5)))))));
	}

	public function get dyContentHeight():Number {
		return (this.m_dyContentHeight);
	}

	public function onSetData(data:Object):void {
		var y:Number;
		var dxMaxLabelWidth:Number;
		var dxMaxStackWidth:Number;
		var i:int;
		var stackHeight:Number;
		if (((((!(data.nTargets)) && (!(data.nMules))) && (!(data.nSafes))) && (!(data.nSuppliers)))) {
			this.visible = false;
			this.m_dyContentHeight = 0;
			return;
		}

		if (data.isHotMission) {
			this.m_labelTargets_txt.text = this.s_targetLabel_suspects;
		} else {
			this.m_labelTargets_txt.text = this.s_targetLabel_targets;
		}

		this.visible = true;
		y = ((this.m_dottedLine.y + this.m_dottedLine.dottedLineThickness) + DYGAP);
		var dyGapLastUsed:Number = DYGAP;
		this.m_stackTargets.numItemsInStack = Math.min(6, data.nTargets);
		this.m_stackMules.numItemsInStack = Math.min(6, data.nMules);
		this.m_stackSafes.numItemsInStack = Math.min(6, data.nSafes);
		this.m_stackSuppliers.numItemsInStack = Math.min(6, data.nSuppliers);
		dxMaxLabelWidth = Math.max(this.m_labelTargets_txt.textWidth, this.m_labelMules_txt.textWidth, this.m_labelSafes_txt.textWidth, this.m_labelSuppliers_txt.textWidth);
		dxMaxStackWidth = Math.max(this.m_stackTargets.width, this.m_stackMules.width, this.m_stackSafes.width, this.m_stackSuppliers.width);
		i = 0;
		var dyLastStackHeight:Number = 0;
		var isLastLeftColumn:Boolean;
		stackHeight = this.m_stackTargets.height;
		var syncCounter:Function = function (_arg_1:int, _arg_2:TextField, _arg_3:TextField, _arg_4:IconStack):void {
			if (_arg_1 == 0) {
				_arg_2.alpha = 0.4;
				_arg_3.alpha = 0.4;
				_arg_4.alpha = 0.4;
			} else {
				_arg_2.alpha = 1;
				_arg_3.alpha = 1;
				_arg_4.alpha = 1;
			}

			_arg_3.htmlText = (('<font face="$global">' + _arg_1.toString()) + "</font>");
			_arg_4.y = y;
			_arg_2.y = ((y + (_arg_4.height / 2)) - (_arg_2.height / 2));
			_arg_3.y = ((y + (_arg_4.height / 2)) - (_arg_3.height / 2));
			var _local_5:* = ((i % 2) == 0);
			if (_local_5) {
				_arg_2.x = 0;
			} else {
				_arg_2.x = ((m_dxContentWidth / 2) + (m_pxPadding / 2));
				y = (y + stackHeight);
				y = (y + DYGAP);
				dyGapLastUsed = DYGAP;
			}

			_arg_4.x = (_arg_2.x + (((dxMaxLabelWidth + 50) + (((m_dxContentWidth - m_pxPadding) / 2) - dxMaxStackWidth)) / 2));
			_arg_3.x = ((_arg_4.x - 20) - _arg_3.textWidth);
			dyLastStackHeight = stackHeight;
			isLastLeftColumn = _local_5;
			i++;
		};
		(syncCounter(data.nTargets, this.m_labelTargets_txt, this.m_numTargets_txt, this.m_stackTargets));
		(syncCounter(data.nMules, this.m_labelMules_txt, this.m_numMules_txt, this.m_stackMules));
		(syncCounter(data.nSafes, this.m_labelSafes_txt, this.m_numSafes_txt, this.m_stackSafes));
		(syncCounter(data.nSuppliers, this.m_labelSuppliers_txt, this.m_numSuppliers_txt, this.m_stackSuppliers));
		if (isLastLeftColumn) {
			y = (y + dyLastStackHeight);
			y = (y + DYGAP);
			dyGapLastUsed = DYGAP;
		}

		this.m_dyContentHeight = (y - dyGapLastUsed);
	}


}
}//package hud.evergreen.misc

