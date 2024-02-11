// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.evergreen.WorldMapTerritoryWidget

package hud.evergreen {
import common.BaseControl;

import flash.display.Shape;

import common.menu.MenuConstants;
import common.Animate;

public class WorldMapTerritoryWidget extends BaseControl {

	public static const NotVisited:int = 0;
	public static const VisitedAndWon:int = 1;
	public static const VisitedAndLost:int = 2;

	private var m_mapMarker:MapMarker = new MapMarker();
	private var m_tooltipBackground:Shape = new Shape();
	private var m_collapsedTooltipContent:CollapsedTooltipContent = new CollapsedTooltipContent();
	private var m_expandedTooltipContent:ExpandedTooltipContent = new ExpandedTooltipContent();
	private var m_expandDetailsLeft:Boolean;
	private var m_expandDetailsUp:Boolean;
	private var m_yMaxInfoPanel:Number;

	public function WorldMapTerritoryWidget() {
		this.m_mapMarker.name = "m_mapMarker";
		this.m_tooltipBackground.name = "m_tooltipBackground";
		this.m_collapsedTooltipContent.name = "m_collapsedTooltipContent";
		this.m_expandedTooltipContent.name = "m_expandedTooltipContent";
		addChild(this.m_tooltipBackground);
		addChild(this.m_collapsedTooltipContent);
		addChild(this.m_expandedTooltipContent);
		addChild(this.m_mapMarker);
		this.m_collapsedTooltipContent.y = (-(this.m_mapMarker.height) / 2);
		this.m_collapsedTooltipContent.scaleX = 0.5;
		this.m_collapsedTooltipContent.scaleY = 0.5;
		this.m_expandedTooltipContent.scaleX = 0.7;
		this.m_expandedTooltipContent.scaleY = 0.7;
	}

	[PROPERTY(HELPTEXT="Possible values: down_left, down_right, up_left, up_right")]
	public function set ExpandDetailsToDirection(_arg_1:String):void {
		switch (_arg_1) {
			case "down_left":
			case "down_right":
			case "up_left":
			case "up_right":
				break;
			default:
				_arg_1 = "down_left";
		}
		;
		this.m_expandDetailsLeft = ((_arg_1 == "down_left") || (_arg_1 == "up_left"));
		this.m_expandDetailsUp = ((_arg_1 == "up_left") || (_arg_1 == "up_right"));
		this.m_tooltipBackground.graphics.clear();
		this.m_tooltipBackground.graphics.beginFill(MenuConstants.COLOR_MENU_BUTTON_TILE_DESELECTED, 0.85);
		this.m_tooltipBackground.graphics.drawRect(0, 0, ((this.m_expandDetailsLeft) ? -100 : 100), 100);
		this.m_tooltipBackground.graphics.endFill();
		this.m_tooltipBackground.x = ((((this.m_expandDetailsLeft) ? -1 : 1) * this.m_mapMarker.width) * 0.75);
	}

	[PROPERTY(CONSTRAINT="Step(1)")]
	public function set YMaxInfoPanel(_arg_1:Number):void {
		this.m_yMaxInfoPanel = _arg_1;
	}

	public function send_dxExpandedCenter(_arg_1:Number):void {
		sendEventWithValue("dxExpandedCenter", _arg_1);
	}

	public function send_dyExpandedCenter(_arg_1:Number):void {
		sendEventWithValue("dyExpandedCenter", _arg_1);
	}

	public function onSetData(_arg_1:Object):void {
		this.m_collapsedTooltipContent.visible = false;
		this.m_expandedTooltipContent.visible = false;
		this.m_tooltipBackground.visible = false;
		Animate.to(this, 0.2, 0, {"alpha": ((_arg_1.isAnotherSelectedToTravelNext) ? 0.25 : 1)}, Animate.Linear);
		if (!_arg_1.isInCampaign) {
			this.m_mapMarker.gotoAndStop("not_in_campaign");
			return;
		}
		;
		if (_arg_1.visited == VisitedAndWon) {
			this.m_mapMarker.gotoAndStop("mission_completed");
			return;
		}
		;
		if (_arg_1.visited == VisitedAndLost) {
			this.m_mapMarker.gotoAndStop("mission_failed");
			return;
		}
		;
		if (_arg_1.isHotMission) {
			this.m_mapMarker.gotoAndStop(((_arg_1.isSelectedInMenu) ? "selected_mission_showdown" : "mission_showdown"));
			if (((this.m_mapMarker.icon_mc) && (_arg_1.isSelectedInMenu))) {
				this.m_mapMarker.icon_mc.gotoAndPlay(1);
			}
			;
		} else {
			if (_arg_1.isAlerted) {
				this.m_mapMarker.gotoAndStop(((_arg_1.isSelectedInMenu) ? "selected_mission_alerted" : "mission_alerted"));
			} else {
				this.m_mapMarker.gotoAndStop(((_arg_1.isSelectedInMenu) ? "selected_mission" : "mission"));
			}
			;
		}
		;
		var _local_2:Boolean = ((_arg_1.isThisSelectedToTravelNext) || (_arg_1.isMenuZoomedIn));
		if (this.m_mapMarker.blink_mc) {
			if (!_local_2) {
				this.m_mapMarker.blink_mc.gotoAndPlay(1);
			} else {
				this.m_mapMarker.blink_mc.gotoAndStop(1);
			}
			;
		}
		;
		if (_arg_1.isSelectedInMenu) {
			parent.setChildIndex(this, (parent.numChildren - 1));
		}
		;
		if (((!(_arg_1.isSelectedInMenu)) || (_local_2))) {
			Animate.kill(this.m_collapsedTooltipContent);
			this.m_collapsedTooltipContent.alpha = 0;
		} else {
			this.m_collapsedTooltipContent.visible = true;
			this.m_collapsedTooltipContent.onSetData(_arg_1);
			if (!this.m_expandDetailsLeft) {
				this.m_collapsedTooltipContent.x = (this.m_mapMarker.width * 0.75);
			} else {
				this.m_collapsedTooltipContent.x = -((this.m_mapMarker.width * 0.75) + (this.m_collapsedTooltipContent.backgroundWidth * this.m_collapsedTooltipContent.scaleX));
			}
			;
			Animate.to(this.m_collapsedTooltipContent, 0.2, 0.2, {"alpha": 1}, Animate.SineOut);
		}
		;
		if (((!(_arg_1.isSelectedInMenu)) || (!(_local_2)))) {
			Animate.kill(this.m_expandedTooltipContent);
			this.m_expandedTooltipContent.alpha = 0;
			this.m_expandedTooltipContent.stopLoopingAnimations();
		} else {
			this.m_expandedTooltipContent.visible = true;
			this.m_expandedTooltipContent.onSetData(_arg_1);
			if (!this.m_expandDetailsLeft) {
				this.m_expandedTooltipContent.x = (this.m_mapMarker.width * 0.75);
			} else {
				this.m_expandedTooltipContent.x = -((this.m_mapMarker.width * 0.75) + (this.m_expandedTooltipContent.backgroundWidth * this.m_expandedTooltipContent.scaleX));
			}
			;
			this.m_expandedTooltipContent.y = (-(this.m_expandedTooltipContent.backgroundHeight * this.m_expandedTooltipContent.scaleY) / 2);
			Animate.to(this.m_expandedTooltipContent, 0.2, 0.2, {"alpha": 1}, Animate.SineOut);
		}
		;
		if (!_arg_1.isSelectedInMenu) {
			Animate.kill(this.m_tooltipBackground);
			this.m_tooltipBackground.width = 1;
		} else {
			if (!_local_2) {
				this.m_tooltipBackground.visible = true;
				if (this.m_tooltipBackground.width == 1) {
					this.m_tooltipBackground.y = this.m_collapsedTooltipContent.y;
					this.m_tooltipBackground.height = (this.m_collapsedTooltipContent.backgroundHeight * this.m_collapsedTooltipContent.scaleY);
				}
				;
				Animate.to(this.m_tooltipBackground, 0.2, 0, {
					"y": this.m_collapsedTooltipContent.y,
					"width": (this.m_collapsedTooltipContent.backgroundWidth * this.m_collapsedTooltipContent.scaleX),
					"height": (this.m_collapsedTooltipContent.backgroundHeight * this.m_collapsedTooltipContent.scaleY)
				}, Animate.SineOut);
			} else {
				this.m_tooltipBackground.visible = true;
				if (this.m_tooltipBackground.width == 1) {
					this.m_tooltipBackground.y = this.m_expandedTooltipContent.y;
					this.m_tooltipBackground.height = (this.m_expandedTooltipContent.backgroundHeight * this.m_expandedTooltipContent.scaleY);
				}
				;
				Animate.to(this.m_tooltipBackground, 0.2, 0, {
					"y": this.m_expandedTooltipContent.y,
					"width": (this.m_expandedTooltipContent.backgroundWidth * this.m_expandedTooltipContent.scaleX),
					"height": (this.m_expandedTooltipContent.backgroundHeight * this.m_expandedTooltipContent.scaleY)
				}, Animate.SineOut);
				this.send_dxExpandedCenter((this.m_expandedTooltipContent.x + ((this.m_expandedTooltipContent.backgroundWidth * this.m_expandedTooltipContent.scaleX) / 2)));
				this.send_dyExpandedCenter((this.m_expandedTooltipContent.y + ((this.m_expandedTooltipContent.backgroundHeight * this.m_expandedTooltipContent.scaleY) / 2)));
			}
			;
		}
		;
	}


}
}//package hud.evergreen

import flash.display.Sprite;
import flash.text.TextField;

import hud.evergreen.misc.DottedLineAlt;

import common.menu.MenuUtils;
import common.menu.MenuConstants;

import flash.text.TextFieldAutoSize;
import flash.display.Shape;

import common.Localization;

import __AS3__.vec.Vector;

import flash.display.LineScaleMode;
import flash.display.CapsStyle;
import flash.display.JointStyle;

import common.Animate;

import hud.evergreen.misc.LocationIntelBlock;

import __AS3__.vec.*;

class CollapsedTooltipContent extends Sprite {

	/*private*/
	static const PXPADDING:Number = 40;
	/*private*/
	static const DYGAP:Number = 30;

	/*private*/
	var m_destinationName_txt:TextField = new TextField();
	/*private*/
	var m_dottedLine:DottedLineAlt = new DottedLineAlt(5);
	/*private*/
	var m_iconTargets:iconsAll76x76View = new iconsAll76x76View();
	/*private*/
	var m_iconSafes:iconsAll76x76View = new iconsAll76x76View();
	/*private*/
	var m_iconMules:iconsAll76x76View = new iconsAll76x76View();
	/*private*/
	var m_iconSuppliers:iconsAll76x76View = new iconsAll76x76View();
	/*private*/
	var m_numTargets_txt:TextField = new TextField();
	/*private*/
	var m_numSafes_txt:TextField = new TextField();
	/*private*/
	var m_numMules_txt:TextField = new TextField();
	/*private*/
	var m_numSuppliers_txt:TextField = new TextField();
	/*private*/
	var m_bonusRequirements:Sprite = new Sprite();
	/*private*/
	var m_backgroundWidth:Number = 0;
	/*private*/
	var m_backgroundHeight:Number = 0;

	public function CollapsedTooltipContent() {
		this.m_destinationName_txt.name = "m_destinationName_txt";
		this.m_dottedLine.name = "m_dottedLine";
		this.m_iconTargets.name = "m_iconTargets";
		this.m_iconSafes.name = "m_iconSafes";
		this.m_iconMules.name = "m_iconMules";
		this.m_iconSuppliers.name = "m_iconSuppliers";
		this.m_numTargets_txt.name = "m_numTargets_txt";
		this.m_numSafes_txt.name = "m_numSafes_txt";
		this.m_numMules_txt.name = "m_numMules_txt";
		this.m_numSuppliers_txt.name = "m_numSuppliers_txt";
		this.m_bonusRequirements.name = "m_bonusRequirements";
		addChild(this.m_destinationName_txt);
		addChild(this.m_dottedLine);
		addChild(this.m_iconTargets);
		addChild(this.m_iconSafes);
		addChild(this.m_iconMules);
		addChild(this.m_iconSuppliers);
		addChild(this.m_numTargets_txt);
		addChild(this.m_numSafes_txt);
		addChild(this.m_numMules_txt);
		addChild(this.m_numSuppliers_txt);
		addChild(this.m_bonusRequirements);
		setupCounterIcon(this.m_iconTargets, "evergreen_target");
		setupCounterIcon(this.m_iconSafes, "evergreen_safe");
		setupCounterIcon(this.m_iconMules, "evergreen_mules");
		setupCounterIcon(this.m_iconSuppliers, "evergreen_suppliers");
		MenuUtils.setupText(this.m_destinationName_txt, "", 80, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_numTargets_txt, "", 70, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_numSafes_txt, "", 70, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_numMules_txt, "", 70, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_numSuppliers_txt, "", 70, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
		this.m_destinationName_txt.autoSize = TextFieldAutoSize.LEFT;
		this.m_numTargets_txt.autoSize = TextFieldAutoSize.LEFT;
		this.m_numSafes_txt.autoSize = TextFieldAutoSize.LEFT;
		this.m_numMules_txt.autoSize = TextFieldAutoSize.LEFT;
		this.m_numSuppliers_txt.autoSize = TextFieldAutoSize.LEFT;
		this.m_destinationName_txt.x = (PXPADDING - 6);
		this.m_dottedLine.x = PXPADDING;
		this.m_bonusRequirements.x = PXPADDING;
		this.m_bonusRequirements.scaleX = 0.85;
		this.m_bonusRequirements.scaleY = 0.85;
	}

	/*private*/
	static function setupCounterIcon(_arg_1:iconsAll76x76View, _arg_2:String):void {
		MenuUtils.setupIcon(_arg_1, _arg_2, 0xFFFFFF, false, false, 0xFFFFFF, 0, 0, true);
	}

	/*private*/
	static function syncCounter(_arg_1:Number, _arg_2:Number, _arg_3:iconsAll76x76View, _arg_4:TextField):Number {
		if (!_arg_2) {
			_arg_3.alpha = 0.4;
			_arg_4.alpha = 0.4;
		} else {
			_arg_3.alpha = 1;
			_arg_4.alpha = 1;
		}
		;
		_arg_4.htmlText = (('<font face="$global">' + _arg_2.toString()) + "</font>");
		_arg_3.x = (_arg_1 + (_arg_3.width / 2));
		_arg_1 = (_arg_1 + (_arg_3.width * 1.25));
		_arg_4.x = _arg_1;
		_arg_1 = (_arg_1 + _arg_4.textWidth);
		return (_arg_1 + _arg_3.width);
	}


	public function get backgroundWidth():Number {
		return (this.m_backgroundWidth);
	}

	public function get backgroundHeight():Number {
		return (this.m_backgroundHeight);
	}

	public function onSetData(_arg_1:Object):void {
		var _local_8:iconsAll76x76View;
		var _local_12:String;
		var _local_2:Number = PXPADDING;
		var _local_3:Number = 0;
		this.m_destinationName_txt.text = _arg_1.lstrDestinationFullName.toUpperCase();
		this.m_destinationName_txt.y = _local_2;
		_local_2 = (_local_2 + (this.m_destinationName_txt.textHeight + DYGAP));
		_local_3 = DYGAP;
		this.m_dottedLine.y = (_local_2 - 6);
		_local_2 = (_local_2 + (this.m_dottedLine.dottedLineThickness + DYGAP));
		_local_3 = DYGAP;
		var _local_4:Number = PXPADDING;
		_local_4 = syncCounter(_local_4, _arg_1.nTargets, this.m_iconTargets, this.m_numTargets_txt);
		_local_4 = syncCounter(_local_4, _arg_1.nSafes, this.m_iconSafes, this.m_numSafes_txt);
		_local_4 = syncCounter(_local_4, _arg_1.nMules, this.m_iconMules, this.m_numMules_txt);
		_local_4 = syncCounter(_local_4, _arg_1.nSuppliers, this.m_iconSuppliers, this.m_numSuppliers_txt);
		var _local_5:Number = this.m_iconTargets.width;
		var _local_6:Number = this.m_iconTargets.height;
		if (_local_4 != PXPADDING) {
			_local_4 = (_local_4 - _local_5);
			this.m_iconTargets.y = (_local_2 + (_local_6 / 2));
			this.m_numTargets_txt.y = ((_local_2 + (_local_6 / 2)) - (this.m_numTargets_txt.textHeight / 2));
			this.m_iconSafes.y = (_local_2 + (_local_6 / 2));
			this.m_numSafes_txt.y = ((_local_2 + (_local_6 / 2)) - (this.m_numSafes_txt.textHeight / 2));
			this.m_iconMules.y = (_local_2 + (_local_6 / 2));
			this.m_numMules_txt.y = ((_local_2 + (_local_6 / 2)) - (this.m_numMules_txt.textHeight / 2));
			this.m_iconSuppliers.y = (_local_2 + (_local_6 / 2));
			this.m_numSuppliers_txt.y = ((_local_2 + (_local_6 / 2)) - (this.m_numSuppliers_txt.textHeight / 2));
			_local_2 = (_local_2 + (_local_6 + DYGAP));
			_local_3 = DYGAP;
		}
		;
		var _local_7:int = _arg_1.bonusRequirements.length;
		while (this.m_bonusRequirements.numChildren > _local_7) {
			this.m_bonusRequirements.removeChildAt((this.m_bonusRequirements.numChildren - 1));
		}
		;
		while (this.m_bonusRequirements.numChildren < _local_7) {
			_local_8 = new iconsAll76x76View();
			_local_8.y = (_local_8.height / 2);
			this.m_bonusRequirements.addChild(_local_8);
		}
		;
		var _local_9:int;
		while (_local_9 < _local_7) {
			_local_8 = iconsAll76x76View(this.m_bonusRequirements.getChildAt(_local_9));
			_local_12 = _arg_1.bonusRequirements[_local_9].icon;
			MenuUtils.setupIcon(_local_8, ((_local_12 == "") ? "blank" : _local_12), 0xFFFFFF, true, false, 0xFFFFFF, 0, 0, false);
			_local_8.x = ((_local_8.width / 2) + (_local_9 * (_local_8.width * 1.5)));
			_local_9++;
		}
		;
		if (_local_7 > 0) {
			this.m_bonusRequirements.y = _local_2;
			_local_2 = (_local_2 + (this.m_bonusRequirements.height + DYGAP));
			_local_3 = DYGAP;
		}
		;
		var _local_10:Number = Math.max(this.m_destinationName_txt.textWidth, (_local_4 - PXPADDING), this.m_bonusRequirements.width);
		var _local_11:Number = ((_local_2 - _local_3) - PXPADDING);
		this.m_dottedLine.updateLineLength(_local_10);
		this.m_backgroundWidth = (Math.max(_local_10, this.m_dottedLine.dottedLineLength) + (2 * PXPADDING));
		this.m_backgroundHeight = (_local_11 + (2 * PXPADDING));
	}


}

class PayoutBlock extends Sprite {

	/*private*/
	static const PXPADDING:Number = 5;

	/*private*/
	var m_background:Shape = new Shape();
	/*private*/
	var m_amount_txt:TextField = new TextField();
	/*private*/
	var m_merces_txt:TextField = new TextField();
	/*private*/
	var m_payout_txt:TextField = new TextField();

	public function PayoutBlock() {
		this.m_background.name = "m_background";
		this.m_amount_txt.name = "m_amount_txt";
		this.m_merces_txt.name = "m_merces_txt";
		this.m_payout_txt.name = "m_payout_txt";
		this.m_background.graphics.beginFill(0xFFFFFF);
		this.m_background.graphics.drawRect(0, 0, 100, 100);
		this.m_background.graphics.endFill();
		MenuUtils.setupText(this.m_amount_txt, "", 30, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorBlack);
		MenuUtils.setupText(this.m_merces_txt, "", 15, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorBlack);
		MenuUtils.setupText(this.m_payout_txt, "", 30, MenuConstants.FONT_TYPE_LIGHT, MenuConstants.FontColorBlack);
		this.m_payout_txt.htmlText = Localization.get("UI_EVEREGREEN_SAFEHOUSE_WORLDMAP_ELIMINATIONPAYOUT").toUpperCase();
		this.m_merces_txt.htmlText = Localization.get("UI_EVERGREEN_MERCES");
		this.m_amount_txt.autoSize = TextFieldAutoSize.LEFT;
		this.m_merces_txt.autoSize = TextFieldAutoSize.LEFT;
		this.m_payout_txt.autoSize = TextFieldAutoSize.LEFT;
		addChild(this.m_background);
		addChild(this.m_payout_txt);
		addChild(this.m_amount_txt);
		addChild(this.m_merces_txt);
		this.m_payout_txt.x = PXPADDING;
		this.m_payout_txt.y = PXPADDING;
		this.m_amount_txt.x = ((PXPADDING * 2) + this.m_payout_txt.textWidth);
		this.m_amount_txt.y = PXPADDING;
		this.m_merces_txt.y = 9;
	}

	public function setAmount(_arg_1:int):void {
		this.m_amount_txt.htmlText = MenuUtils.formatNumber(_arg_1);
		this.m_merces_txt.x = ((this.m_amount_txt.x + this.m_amount_txt.textWidth) + 6);
		this.m_background.width = ((((this.m_merces_txt.x + this.m_merces_txt.textWidth) + this.m_amount_txt.textWidth) + PXPADDING) + 5);
		this.m_background.height = ((this.m_amount_txt.y + this.m_amount_txt.textHeight) + PXPADDING);
	}


}

class BonusRequirement extends Sprite {

	public static const DXGAPBETWEENICONANDTITLE:Number = 10;

	/*private*/
	var m_icon:iconsAll76x76View = new iconsAll76x76View();
	/*private*/
	var m_title_txt:TextField = new TextField();

	public function BonusRequirement() {
		this.m_icon.name = "m_icon";
		this.m_title_txt.name = "m_title_txt";
		addChild(this.m_icon);
		addChild(this.m_title_txt);
		this.m_icon.scaleX = (this.m_icon.scaleY = 0.5);
		this.m_icon.x = (this.m_icon.width / 2);
		this.m_icon.y = (this.m_icon.height / 2);
		MenuUtils.setupText(this.m_title_txt, "", 18, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		this.m_title_txt.autoSize = TextFieldAutoSize.LEFT;
		this.m_title_txt.multiline = true;
		this.m_title_txt.wordWrap = true;
		this.m_title_txt.x = ((this.m_icon.x + (this.m_icon.width / 2)) + DXGAPBETWEENICONANDTITLE);
		this.m_title_txt.width = (((ExpandedTooltipContent.DXCONTENTWIDTH / 2) - (ExpandedTooltipContent.PXPADDING / 2)) - this.m_title_txt.x);
	}

	public function onSetData(_arg_1:String, _arg_2:String):void {
		MenuUtils.setupIcon(this.m_icon, ((_arg_1 == "") ? "blank" : _arg_1), 0xFFFFFF, true, false, 0xFFFFFF, 0, 0, false);
		this.m_title_txt.htmlText = _arg_2;
		if (this.m_title_txt.numLines == 1) {
			this.m_title_txt.y = (((this.m_icon.height / 2) - (this.m_title_txt.textHeight / 2)) - 2);
		} else {
			this.m_title_txt.y = -4;
		}
		;
	}


}

class BonusRequirementsBlock extends Sprite {

	public static const DYGAP:Number = 20;

	/*private*/
	var m_header_txt:TextField = new TextField();
	/*private*/
	var m_dottedLine:DottedLineAlt = new DottedLineAlt(1);
	/*private*/
	var m_bonusRequirements:Vector.<BonusRequirement> = new Vector.<BonusRequirement>();
	/*private*/
	var m_dyContentHeight:Number = 0;

	public function BonusRequirementsBlock() {
		this.m_header_txt.name = "m_header_txt";
		this.m_dottedLine.name = "m_dottedLine";
		addChild(this.m_header_txt);
		addChild(this.m_dottedLine);
		MenuUtils.setupText(this.m_header_txt, "", 18, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
		this.m_header_txt.autoSize = TextFieldAutoSize.LEFT;
		this.m_header_txt.text = Localization.get("UI_EVEREGREEN_SAFEHOUSE_WORLDMAP_BONUSREQUIREMENTS_HEADER").toUpperCase();
		this.m_dottedLine.y = ((this.m_header_txt.y + this.m_header_txt.textHeight) + 10);
		this.m_dottedLine.updateLineLength(ExpandedTooltipContent.DXCONTENTWIDTH);
	}

	public function get dyContentHeight():Number {
		return (this.m_dyContentHeight);
	}

	public function onSetData(_arg_1:Object):void {
		var _local_3:BonusRequirement;
		var _local_9:Boolean;
		if (_arg_1.bonusRequirements.length == 0) {
			this.visible = false;
			this.m_dyContentHeight = 0;
			return;
		}
		;
		this.visible = true;
		var _local_2:int = _arg_1.bonusRequirements.length;
		while (this.m_bonusRequirements.length > _local_2) {
			removeChild(this.m_bonusRequirements.pop());
		}
		;
		while (this.m_bonusRequirements.length < _local_2) {
			_local_3 = new BonusRequirement();
			this.m_bonusRequirements.push(_local_3);
			addChild(_local_3);
		}
		;
		var _local_4:Number = ((this.m_dottedLine.y + this.m_dottedLine.dottedLineThickness) + DYGAP);
		var _local_5:Number = DYGAP;
		var _local_6:Number = 0;
		var _local_7:Boolean;
		var _local_8:int;
		while (_local_8 < _arg_1.bonusRequirements.length) {
			_local_3 = this.m_bonusRequirements[_local_8];
			_local_3.onSetData(_arg_1.bonusRequirements[_local_8].icon, _arg_1.bonusRequirements[_local_8].lstrTitle);
			_local_3.y = _local_4;
			_local_9 = ((_local_8 % 2) == 0);
			if (_local_9) {
				_local_3.x = 0;
				_local_6 = _local_3.height;
			} else {
				_local_3.x = ((ExpandedTooltipContent.DXCONTENTWIDTH / 2) + (ExpandedTooltipContent.PXPADDING / 2));
				_local_6 = Math.max(_local_6, _local_3.height);
				_local_4 = (_local_4 + _local_6);
				_local_4 = (_local_4 + DYGAP);
				_local_5 = DYGAP;
			}
			;
			_local_7 = _local_9;
			_local_8++;
		}
		;
		if (_local_7) {
			_local_4 = (_local_4 + _local_6);
			_local_4 = (_local_4 + DYGAP);
			_local_5 = DYGAP;
		}
		;
		this.m_dyContentHeight = (_local_4 - _local_5);
	}


}

class AirTicketButton extends Sprite {

	public static const DYHEIGHT:Number = 70;
	public static const STATE_BOOKMESSAGE:int = 1;
	public static const STATE_CANCELMESSAGE:int = 2;
	/*private*/
	static const s_lstrBook:String = Localization.get("UI_EVEREGREEN_SAFEHOUSE_WORLDMAP_SETNEXTDESTINATION").toUpperCase();
	/*private*/
	static const s_lstrCancel:String = Localization.get("UI_EVEREGREEN_SAFEHOUSE_WORLDMAP_UNSETNEXTDESTINATION").toUpperCase();

	/*private*/
	var m_icon:iconsAll76x76View = new iconsAll76x76View();
	/*private*/
	var m_label_txt:TextField = new TextField();
	/*private*/
	var m_blinkOutline:Shape = new Shape();
	/*private*/
	var m_state:int;

	public function AirTicketButton() {
		this.m_icon.name = "m_icon";
		this.m_label_txt.name = "m_label_txt";
		this.m_blinkOutline.name = "m_blinkOutline";
		addChild(this.m_icon);
		addChild(this.m_label_txt);
		addChild(this.m_blinkOutline);
		this.graphics.beginFill(0xFFFFFF);
		this.graphics.drawRect(0, 0, ExpandedTooltipContent.DXCONTENTWIDTH, DYHEIGHT);
		this.graphics.endFill();
		MenuUtils.setupIcon(this.m_icon, "location", 0, false, false, 0, 0, 0, true);
		this.m_icon.height = 38;
		this.m_icon.width = 38;
		this.m_icon.x = (DYHEIGHT / 2);
		this.m_icon.y = (DYHEIGHT / 2);
		MenuUtils.setupText(this.m_label_txt, "X", 26, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorBlack);
		this.m_label_txt.autoSize = TextFieldAutoSize.LEFT;
		this.m_label_txt.x = (this.m_icon.x + this.m_icon.width);
		this.m_label_txt.y = (this.m_icon.y - (this.m_label_txt.textHeight / 2));
		this.m_blinkOutline.graphics.lineStyle(3, 0xFFFFFF, 1, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER);
		this.m_blinkOutline.graphics.drawRect((-(ExpandedTooltipContent.DXCONTENTWIDTH) / 2), (-(DYHEIGHT) / 2), ExpandedTooltipContent.DXCONTENTWIDTH, DYHEIGHT);
		this.m_blinkOutline.x = (ExpandedTooltipContent.DXCONTENTWIDTH / 2);
		this.m_blinkOutline.y = (DYHEIGHT / 2);
		this.m_label_txt.text = s_lstrBook;
		this.m_state = STATE_BOOKMESSAGE;
	}

	public function get dyContentHeight():Number {
		return (DYHEIGHT);
	}

	public function showBookMessage():void {
		this.pulse();
		this.changeState(STATE_BOOKMESSAGE, s_lstrBook);
	}

	public function showCancelMessage():void {
		this.pulse();
		this.changeState(STATE_CANCELMESSAGE, s_lstrCancel);
	}

	public function stopBlinkAnimation():void {
		Animate.kill(this.m_blinkOutline);
	}

	/*private*/
	function pulse():void {
		var PXANIMDELTA:Number = (ExpandedTooltipContent.PXPADDING * 1.5);
		Animate.fromTo(this.m_blinkOutline, (30 / 60), (40 / 60), {
			"width": ExpandedTooltipContent.DXCONTENTWIDTH,
			"height": DYHEIGHT,
			"alpha": 1
		}, {
			"width": (ExpandedTooltipContent.DXCONTENTWIDTH + PXANIMDELTA),
			"height": (DYHEIGHT + PXANIMDELTA),
			"alpha": 0
		}, Animate.ExpoOut, function ():void {
			m_blinkOutline.alpha = 0;
			m_blinkOutline.scaleX = 1;
			m_blinkOutline.scaleY = 1;
			pulse();
		});
		this.m_blinkOutline.alpha = 0;
		this.m_blinkOutline.scaleX = 1;
		this.m_blinkOutline.scaleY = 1;
	}

	/*private*/
	function changeState(state:int, lstrLabel:String):void {
		if (this.m_state != state) {
			Animate.to(this.m_icon, 0.1, 0, {
				"width": 1,
				"height": 1
			}, Animate.SineIn, Animate.to, this.m_icon, 0.1, 0, {
				"width": 38,
				"height": 38
			}, Animate.SineOut);
			Animate.to(this.m_label_txt, 0.1, 0, {"alpha": 0}, Animate.SineIn, function ():void {
				m_label_txt.text = lstrLabel;
				Animate.to(m_label_txt, 0.1, 0, {"alpha": 1}, Animate.SineOut);
			});
			this.m_state = state;
		}
		;
	}


}

class TooltipHeadline extends Sprite {

	public static const DXWIDTH:Number = (650 + (2 * 30));//710
	public static const DYHEIGHT:Number = 70;

	/*private*/
	var m_icon:iconsAll76x76View = new iconsAll76x76View();
	/*private*/
	var m_title_txt:TextField = new TextField();
	/*private*/
	var m_subtitle_txt:TextField = new TextField();

	public function TooltipHeadline(_arg_1:uint, _arg_2:String, _arg_3:String, _arg_4:String) {
		this.m_icon.name = "m_icon";
		this.m_title_txt.name = "m_title_txt";
		this.m_subtitle_txt.name = "m_subtitle_txt";
		addChild(this.m_icon);
		addChild(this.m_title_txt);
		addChild(this.m_subtitle_txt);
		this.graphics.beginFill(_arg_1, 0.65);
		this.graphics.drawRect(0, 0, DXWIDTH, DYHEIGHT);
		this.graphics.endFill();
		MenuUtils.setupIcon(this.m_icon, _arg_2, 0xFFFFFF, true, false, 0, 0, 0, false);
		this.m_icon.height = 42;
		this.m_icon.width = 42;
		this.m_icon.x = (DYHEIGHT / 2);
		this.m_icon.y = (DYHEIGHT / 2);
		MenuUtils.setupText(this.m_title_txt, Localization.get(_arg_3).toUpperCase(), 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_subtitle_txt, Localization.get(_arg_4).toUpperCase(), 14, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		this.m_title_txt.autoSize = TextFieldAutoSize.LEFT;
		this.m_subtitle_txt.autoSize = TextFieldAutoSize.LEFT;
		this.m_title_txt.x = ((this.m_icon.x + (this.m_icon.width / 2)) + 10);
		this.m_subtitle_txt.x = ((this.m_icon.x + (this.m_icon.width / 2)) + 10);
		this.m_title_txt.y = ((this.m_icon.y - (this.m_icon.height / 2)) - 4);
		this.m_subtitle_txt.y = ((this.m_icon.y + (this.m_icon.height / 2)) - this.m_subtitle_txt.textHeight);
	}

	public function set showSubtitle(_arg_1:Boolean):void {
		this.m_subtitle_txt.visible = _arg_1;
	}


}

class ExpandedTooltipContent extends Sprite {

	public static const PXPADDING:Number = 30;
	public static const DYGAP:Number = 40;
	public static const DXCONTENTWIDTH:Number = 650;

	/*private*/
	var m_headlineAlerted:TooltipHeadline = new TooltipHeadline(MenuConstants.COLOR_YELLOW, "warning", "UI_EVEREGREEN_SAFEHOUSE_WORLDMAP_TERRITORYHEADLINE_ALERTED_TITLE", "UI_EVEREGREEN_SAFEHOUSE_WORLDMAP_TERRITORYHEADLINE_ALERTED_SUBTITLE");
	/*private*/
	var m_headlineHotMission:TooltipHeadline = new TooltipHeadline(MenuConstants.COLOR_PURPLE, "evergreen_showdown_mission", "UI_EVEREGREEN_SAFEHOUSE_WORLDMAP_TERRITORYHEADLINE_HOTMISSION_TITLE", "UI_EVEREGREEN_SAFEHOUSE_WORLDMAP_TERRITORYHEADLINE_HOTMISSION_SUBTITLE");
	/*private*/
	var m_destinationCountry_txt:TextField = new TextField();
	/*private*/
	var m_destinationCity_txt:TextField = new TextField();
	/*private*/
	var m_payoutBlock:PayoutBlock = new PayoutBlock();
	/*private*/
	var m_locationIntelBlock:LocationIntelBlock = new hud.evergreen.misc.LocationIntelBlock(ExpandedTooltipContent.DXCONTENTWIDTH, ExpandedTooltipContent.PXPADDING);
	/*private*/
	var m_bonusRequirementsBlock:BonusRequirementsBlock = new BonusRequirementsBlock();
	/*private*/
	var m_airTicketButton:AirTicketButton = new AirTicketButton();
	/*private*/
	var m_backgroundWidth:Number = 0;
	/*private*/
	var m_backgroundHeight:Number = 0;

	public function ExpandedTooltipContent() {
		this.m_headlineAlerted.name = "m_headlineAlerted";
		this.m_headlineHotMission.name = "m_headlineHotMission";
		this.m_destinationCountry_txt.name = "m_destinationCountry_txt";
		this.m_destinationCity_txt.name = "m_destinationCity_txt";
		this.m_payoutBlock.name = "m_payoutBlock";
		this.m_locationIntelBlock.name = "m_locationIntelBlock";
		this.m_bonusRequirementsBlock.name = "m_bonusRequirementsBlock";
		this.m_airTicketButton.name = "m_airTicketButton";
		addChild(this.m_headlineAlerted);
		addChild(this.m_headlineHotMission);
		addChild(this.m_destinationCountry_txt);
		addChild(this.m_destinationCity_txt);
		addChild(this.m_payoutBlock);
		addChild(this.m_locationIntelBlock);
		addChild(this.m_bonusRequirementsBlock);
		addChild(this.m_airTicketButton);
		MenuUtils.setupText(this.m_destinationCountry_txt, "", 16, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_destinationCity_txt, "", 36, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
		this.m_destinationCountry_txt.x = PXPADDING;
		this.m_destinationCity_txt.x = PXPADDING;
		this.m_payoutBlock.x = PXPADDING;
		this.m_locationIntelBlock.x = PXPADDING;
		this.m_bonusRequirementsBlock.x = PXPADDING;
		this.m_airTicketButton.x = PXPADDING;
		this.m_destinationCountry_txt.autoSize = TextFieldAutoSize.LEFT;
		this.m_destinationCity_txt.autoSize = TextFieldAutoSize.LEFT;
		this.m_headlineAlerted.y = -(this.m_headlineAlerted.height);
		this.m_headlineHotMission.y = -(this.m_headlineHotMission.height);
	}

	public function get backgroundWidth():Number {
		return (this.m_backgroundWidth);
	}

	public function get backgroundHeight():Number {
		return (this.m_backgroundHeight);
	}

	public function onSetData(_arg_1:Object):void {
		this.m_headlineHotMission.visible = _arg_1.isHotMission;
		this.m_headlineAlerted.visible = _arg_1.isAlerted;
		if (this.m_headlineAlerted.visible) {
			this.m_headlineHotMission.y = (this.m_headlineAlerted.y - this.m_headlineHotMission.height);
			this.m_headlineAlerted.showSubtitle = (!(_arg_1.isHotMission));
		} else {
			this.m_headlineHotMission.y = -(this.m_headlineHotMission.height);
		}
		;
		var _local_2:Number = PXPADDING;
		var _local_3:Number = 0;
		this.m_destinationCountry_txt.text = _arg_1.lstrDestinationCountry.toUpperCase();
		this.m_destinationCountry_txt.y = _local_2;
		_local_2 = (_local_2 + this.m_destinationCountry_txt.textHeight);
		this.m_destinationCity_txt.text = _arg_1.lstrDestinationCity.toUpperCase();
		this.m_destinationCity_txt.y = _local_2;
		_local_2 = (_local_2 + this.m_destinationCity_txt.textHeight);
		_local_2 = (_local_2 + 5);
		_local_3 = 5;
		this.m_payoutBlock.setAmount(_arg_1.mercesPayout);
		this.m_payoutBlock.y = _local_2;
		_local_2 = (_local_2 + this.m_payoutBlock.height);
		_local_2 = (_local_2 + DYGAP);
		_local_3 = DYGAP;
		this.m_locationIntelBlock.onSetData(_arg_1);
		if (this.m_locationIntelBlock.dyContentHeight > 0) {
			this.m_locationIntelBlock.y = _local_2;
			_local_2 = (_local_2 + this.m_locationIntelBlock.dyContentHeight);
			_local_2 = (_local_2 + DYGAP);
			_local_3 = DYGAP;
		}
		;
		this.m_bonusRequirementsBlock.onSetData(_arg_1);
		if (this.m_bonusRequirementsBlock.dyContentHeight > 0) {
			this.m_bonusRequirementsBlock.y = _local_2;
			_local_2 = (_local_2 + this.m_bonusRequirementsBlock.dyContentHeight);
			_local_2 = (_local_2 + DYGAP);
			_local_3 = DYGAP;
		}
		;
		if (_arg_1.isThisSelectedToTravelNext) {
			this.m_airTicketButton.showCancelMessage();
		} else {
			this.m_airTicketButton.showBookMessage();
		}
		;
		this.m_airTicketButton.y = (_local_2 + DYGAP);
		_local_2 = (this.m_airTicketButton.y + this.m_airTicketButton.dyContentHeight);
		_local_2 = (_local_2 + DYGAP);
		_local_3 = DYGAP;
		var _local_4:Number = ((_local_2 - _local_3) - PXPADDING);
		this.m_backgroundWidth = (DXCONTENTWIDTH + (2 * PXPADDING));
		this.m_backgroundHeight = (_local_4 + (2 * PXPADDING));
	}

	public function stopLoopingAnimations():void {
		this.m_airTicketButton.stopBlinkAnimation();
	}


}


