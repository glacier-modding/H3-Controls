// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.ObjectiveConditions

package hud {
import common.BaseControl;

import flash.display.Sprite;

import common.menu.ObjectiveUtil;
import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.Localization;
import common.CommonUtils;

import flash.display.MovieClip;

import scaleform.gfx.Extensions;

public class ObjectiveConditions extends BaseControl {

	private var m_container:Sprite = new Sprite();
	private var m_aTargetInfos:Array = [];
	private var m_targetInfosActive:int = 0;
	private var i:int;
	private var j:int;
	private var conditionsXOffset:int = 25;
	private var lineYOffset:int = 30;
	private var lineXWidthOffset:int = 15;
	private var targetInfoYOffset:int = -50;
	private var maxNrOfConditions:int = 3;
	private var nrOfPooledTargets:int = 5;
	private var scaleFactor:Number = 1;

	public function ObjectiveConditions() {
		var _local_1:TargetInfoContainer;
		super();
		addChild(this.m_container);
		this.m_container.x = 0;
		this.m_container.y = 0;
		this.i = 0;
		while (this.i < this.nrOfPooledTargets) {
			_local_1 = this.instantiateTargetInfo();
			this.m_aTargetInfos.push(_local_1);
			this.m_container.addChild(_local_1);
			this.i++;
		}

	}

	public function instantiateTargetInfo():TargetInfoContainer {
		var _local_4:ValueIndicatorSmallView;
		var _local_1:TargetInfoContainer = new TargetInfoContainer();
		_local_1.visible = false;
		_local_1.alpha = 1;
		var _local_2:int;
		while (_local_2 < this.maxNrOfConditions) {
			_local_4 = new ValueIndicatorSmallView();
			_local_1.addChild(_local_4);
			_local_4.x = this.conditionsXOffset;
			_local_1.m_aObjectiveConditions.push(_local_4);
			_local_2++;
		}

		var _local_3:line = new line();
		_local_3.width = (this.conditionsXOffset + this.lineXWidthOffset);
		_local_3.height = 1;
		_local_1.addChild(_local_3);
		_local_3.x = 0;
		_local_3.y = this.lineYOffset;
		return (_local_1);
	}

	private function ResetConditions(_arg_1:TargetInfoContainer):void {
		var _local_2:Number = _arg_1.m_aObjectiveConditions.length;
		var _local_3:int;
		while (_local_3 < _local_2) {
			_arg_1.m_aObjectiveConditions[_local_3].visible = false;
			_local_3++;
		}

	}

	public function hideAll():void {
		this.m_container.visible = false;
	}

	public function onSetData(_arg_1:Array):void {
		var _local_2:TargetInfoContainer;
		var _local_3:Object;
		var _local_4:Object;
		var _local_5:String;
		var _local_6:Array;
		this.m_container.visible = true;
		while (_arg_1.length > this.m_aTargetInfos.length) {
			_local_2 = this.instantiateTargetInfo();
			this.m_aTargetInfos.push(_local_2);
			this.m_container.addChild(_local_2);
		}

		this.i = 0;
		while (this.i < _arg_1.length) {
			_local_3 = _arg_1[this.i];
			_local_2 = this.m_aTargetInfos[this.i];
			this.ResetConditions(_local_2);
			_local_2.visible = true;
			_local_2.x = _local_3.fX;
			_local_2.y = (_local_3.fY + (this.targetInfoYOffset * this.scaleFactor));
			_local_2.scaleX = (_local_2.scaleY = this.scaleFactor);
			_local_2.alpha = _local_3.fAlpha;
			_local_2.bIsTarget = _local_3.bIsTarget;
			_local_5 = "npc";
			if (_local_3.bIsTarget) {
				_local_5 = "target";
			}

			if (_local_3.disguiseName == _local_3.npcName) {
				_local_4 = {
					"header": "",
					"title": _local_3.npcName,
					"icon": _local_5,
					"line": true,
					"hardCondition": true
				};
			} else {
				_local_4 = {
					"header": _local_3.disguiseName,
					"title": _local_3.npcName,
					"icon": _local_5,
					"line": true,
					"hardCondition": true
				};
			}

			if (_local_3.objectiveConditions) {
				if (_local_3.bIsTarget) {
					_local_6 = _local_3.objectiveConditions;
					if (_local_3.objectiveType == "kill") {
						_local_6 = ObjectiveUtil.prepareConditions(_local_6, false, false, false);
					}

					_local_6.unshift(_local_4);
					this.addConditions(_local_6, _local_2);
				} else {
					this.addConditions([_local_4], _local_2);
				}

			} else {
				this.addConditions([_local_4], _local_2);
			}

			this.i++;
		}

		while (this.i < this.m_aTargetInfos.length) {
			this.m_aTargetInfos[this.i].visible = false;
			this.i++;
		}

	}

	private function addConditions(_arg_1:Array, _arg_2:MovieClip):void {
		var _local_5:ValueIndicatorSmallView;
		var _local_6:String;
		var _local_3:int;
		var _local_4:int;
		while (((_local_4 < _arg_1.length) && (_local_4 < _arg_2.m_aObjectiveConditions.length))) {
			_local_5 = _arg_2.m_aObjectiveConditions[_local_4];
			_local_5.visible = true;
			_local_5.y = _local_3;
			if (_local_4 == 0) {
				if (_arg_2.bIsTarget) {
					MenuUtils.setupIcon(_local_5.valueIcon, _arg_1[_local_4].icon, MenuConstants.COLOR_WHITE, true, true, MenuConstants.COLOR_RED);
				} else {
					MenuUtils.setupIcon(_local_5.valueIcon, _arg_1[_local_4].icon, MenuConstants.COLOR_WHITE, true, false);
				}

			} else {
				MenuUtils.setupIcon(_local_5.valueIcon, _arg_1[_local_4].icon, MenuConstants.COLOR_BLACK, false, true, MenuConstants.COLOR_WHITE);
			}

			_local_6 = (((_arg_1[_local_4].hardCondition) || (_arg_1[_local_4].hardcondition)) ? _arg_1[_local_4].header : ((Localization.get("UI_DIALOG_OPTIONAL") + " ") + _arg_1[_local_4].header));
			MenuUtils.setupText(_local_5.header, _local_6, 18, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorGreyUltraLight);
			_local_5.header.width = (_local_5.header.textWidth + 10);
			MenuUtils.setupText(_local_5.title, _arg_1[_local_4].title, 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
			CommonUtils.changeFontToGlobalIfNeeded(_local_5.title);
			_local_5.title.width = (_local_5.title.textWidth + 10);
			_local_3 = (_local_3 + (_local_5.valueIcon.height + 10));
			_local_4++;
		}

	}

	public function test(_arg_1:Number):void {
		var _local_5:Object;
		var _local_2:Array = [];
		var _local_3:Number = 5;
		var _local_4:Number = 0;
		while (_local_4 < _local_3) {
			_local_5 = {};
			_local_5.icon = "target";
			_local_5.targetName = "Mr. Kill Me Mr. Kill Me Mr. Kill Me Mr. Kill Me";
			_local_5.fX = (_local_4 * _arg_1);
			_local_5.fY = 200;
			_local_5.bWithinScreen = true;
			_local_5.disguiseName = "Bodyguard";
			_local_5.fAlpha = 1;
			_local_5.bIsTarget = ((_local_4 == 2) ? true : false);
			_local_2.push(_local_5);
			_local_4++;
		}

		this.onSetData(_local_2);
	}

	override public function onSetSize(_arg_1:Number, _arg_2:Number):void {
		if (ControlsMain.isVrModeActive()) {
			this.scaleFactor = 1;
		} else {
			this.scaleFactor = (Extensions.visibleRect.height / 1080);
		}

	}


}
}//package hud

import flash.display.MovieClip;

class TargetInfoContainer extends MovieClip {

	public var m_aObjectiveConditions:Array = [];
	public var bIsTarget:Boolean = false;


}


