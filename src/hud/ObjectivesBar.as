// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.ObjectivesBar

package hud {
import common.BaseControl;
import common.Localization;

import flash.display.Sprite;
import flash.utils.Dictionary;

import common.ObjectPool;
import common.menu.MenuUtils;
import common.menu.MenuConstants;

import mx.utils.StringUtil;

import common.TaskletSequencer;
import common.Animate;
import common.CommonUtils;

import flash.external.ExternalInterface;
import flash.text.TextField;

public class ObjectivesBar extends BaseControl {

	public static const BAR_ELEMENT_FADE_ANIM_TIME:Number = 0.3;
	public static const OBJ_MARGIN_HEIGHT:Number = 10;
	public static const LABEL_TEXT_LEADING:Number = 22;
	public static const SINGLE_LINE_NOTIFICATION_HEIGHT:Number = 23;
	public static const COUNTDOWN_OBJ_HEIGHT:Number = 23;
	public static const COUNTDOWN_OBJ_BG_XPOS:Number = 33;
	public static const COUNTDOWN_OBJ_HEADER_XPOS:Number = 34;
	public static const COUNTDOWN_OBJ_TEXT_GAP:Number = 10;
	public static const PERCENTAGE_BG_INIT_WIDTH:Number = 300;
	public static const HINT_INDENTATON:Number = 33;

	private const m_lstrOptional:String = Localization.get("UI_DIALOG_OPTIONAL");

	private var m_view:Sprite;
	private var m_objectivesHolder:Sprite;
	private var m_oppHolder:Sprite;
	private var m_oppMoveHolder:Sprite;
	private var m_intelHolder:Sprite;
	private var m_intelMoveHolder:Sprite;
	private var m_securityHolder:Sprite;
	private var m_securityMoveHolder:Sprite;
	private var m_startX:Number = 0;
	private var m_startY:Number = 0;
	private var m_intelPrevposY:Number = 0;
	private var m_OpportunityPrevPosY:Number = 0;
	private var m_SecurityPrevPosY:Number = 0;
	private var m_objectivesPosY:Number;
	private var m_timers:Dictionary;
	private var m_percentCounters:Dictionary;
	private var m_counters:Dictionary;
	private var m_oppLastIcon:String;
	private var m_oppLastTask:String;
	private var m_oppNotification:OpportunityBarView;
	private var m_intelIndicator:IntelIndicatorView;
	private var m_securityIndicator:SecurityIndicatorView;
	private var m_counterFieldTimerWidth:Number = -1;
	private var m_counterFieldPercentWidth:Number = -1;
	private var m_counterFieldSingleDigitWidth:Number = -1;
	private var m_counterFieldDoubleDigitWidth:Number = -1;
	private var m_counterFieldTripleDigitWidth:Number = -1;
	private var m_prevData:Object = null;
	private var m_objectiveViewPool:ObjectPool = null;
	private var m_zIconsVR:Number;
	private var m_evergreenHardcore:Boolean = false;

	public function ObjectivesBar() {
		this.m_view = new Sprite();
		addChild(this.m_view);
		this.m_objectivesHolder = new Sprite();
		this.m_view.addChild(this.m_objectivesHolder);
		this.m_oppLastIcon = "";
		this.m_oppLastTask = "";
		this.m_oppHolder = new Sprite();
		this.m_oppNotification = new OpportunityBarView();
		this.m_oppNotification.icon_mc.z = this.m_zIconsVR;
		this.m_oppMoveHolder = new Sprite();
		this.m_view.addChild(this.m_oppHolder);
		this.m_oppHolder.addChild(this.m_oppMoveHolder);
		this.m_oppMoveHolder.addChild(this.m_oppNotification);
		this.m_oppHolder.visible = false;
		this.m_intelHolder = new Sprite();
		this.m_intelIndicator = new IntelIndicatorView();
		this.m_intelIndicator.icon_mc.z = this.m_zIconsVR;
		this.m_intelMoveHolder = new Sprite();
		this.m_view.addChild(this.m_intelHolder);
		this.m_intelHolder.addChild(this.m_intelMoveHolder);
		this.m_intelMoveHolder.addChild(this.m_intelIndicator);
		this.m_intelHolder.visible = false;
		this.m_securityHolder = new Sprite();
		this.m_securityIndicator = new SecurityIndicatorView();
		this.m_securityMoveHolder = new Sprite();
		this.m_view.addChild(this.m_securityHolder);
		this.m_securityHolder.addChild(this.m_securityMoveHolder);
		this.m_securityMoveHolder.addChild(this.m_securityIndicator);
		this.m_securityHolder.visible = false;
		this.m_securityIndicator.header_txt.autoSize = "left";
		this.m_objectivesPosY = this.m_startY;
		this.onControlLayoutChanged();
		MenuUtils.setupText(this.m_oppNotification.desc_txt, "", 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		this.m_objectiveViewPool = new ObjectPool(LevelObjectiveView, 10, this.initialiseObjectiveView);
		this.m_timers = new Dictionary();
		this.m_percentCounters = new Dictionary();
		this.m_counters = new Dictionary();
	}

	public function set zIconsVR(_arg_1:Number):void {
		this.m_zIconsVR = _arg_1;
		this.m_oppNotification.icon_mc.z = _arg_1;
		this.m_intelIndicator.icon_mc.z = _arg_1;
		var _local_2:int;
		while (_local_2 < this.m_objectivesHolder.numChildren) {
			(this.m_objectivesHolder.getChildAt(_local_2) as LevelObjectiveView).iconAnim_mc.z = _arg_1;
			_local_2++;
		}

	}

	public function setEvergreenHardcore(_arg_1:Boolean):void {
		this.m_evergreenHardcore = _arg_1;
	}

	private function initialiseObjectiveView(_arg_1:LevelObjectiveView):void {
		_arg_1.visible = false;
		_arg_1.counterTimer_mc.visible = false;
		_arg_1.iconAnim_mc.z = this.m_zIconsVR;
		_arg_1.label_txt.autoSize = "left";
		_arg_1.label_txt.multiline = true;
		_arg_1.label_txt.wordWrap = true;
		_arg_1.label_txt.y = -1;
		MenuUtils.setupText(_arg_1.label_txt, "", 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		_arg_1.counterTimer_mc.header_txt.autoSize = "left";
		MenuUtils.setupText(_arg_1.counterTimer_mc.header_txt, "", 12, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraDark);
		MenuUtils.setupText(_arg_1.counterTimer_mc.value_txt, "", 24, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorGreyUltraDark);
		if (this.m_counterFieldTimerWidth == -1) {
			_arg_1.counterTimer_mc.value_txt.text = "00:00";
			this.m_counterFieldTimerWidth = _arg_1.counterTimer_mc.value_txt.textWidth;
			_arg_1.counterTimer_mc.value_txt.text = "100%";
			this.m_counterFieldPercentWidth = _arg_1.counterTimer_mc.value_txt.textWidth;
			_arg_1.counterTimer_mc.value_txt.text = "0";
			this.m_counterFieldSingleDigitWidth = _arg_1.counterTimer_mc.value_txt.textWidth;
			_arg_1.counterTimer_mc.value_txt.text = "00";
			this.m_counterFieldDoubleDigitWidth = _arg_1.counterTimer_mc.value_txt.textWidth;
			_arg_1.counterTimer_mc.value_txt.text = "000";
			this.m_counterFieldTripleDigitWidth = _arg_1.counterTimer_mc.value_txt.textWidth;
			_arg_1.counterTimer_mc.value_txt.text = "";
		}

	}

	private function resetObjectiveView(_arg_1:LevelObjectiveView):void {
		_arg_1.visible = false;
		_arg_1.counterTimer_mc.visible = false;
		_arg_1.label_txt.text = "";
		_arg_1.counterTimer_mc.header_txt.text = "";
		_arg_1.counterTimer_mc.value_txt.text = "";
	}

	public function onControlLayoutChanged():void {
		MenuUtils.setupText(this.m_intelIndicator.header_txt, Localization.get("UI_HUD_INTEL_VIEW_INTEL"), 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
	}

	public function onSetData(_arg_1:Object):void {
		this.updateAndShowObjectives(_arg_1);
	}

	public function updateAndShowObjectives(data:Object, bAnimate:Boolean = true):void {
		var obj:Object;
		var lstr:String;
		if (data.contracttype == "arcade") {
			for each (obj in data.secondary) {
				for each (lstr in [this.m_lstrOptional, "[Доп.]", "[Дополнительно]"]) {
					obj.objTitle = obj.objTitle.replace(lstr, "");
				}

				obj.objTitle = ((this.m_lstrOptional + " ") + StringUtil.trim(obj.objTitle));
			}

		}

		TaskletSequencer.getGlobalInstance().addChunk(function ():void {
			Animate.kill(m_objectivesHolder);
			m_objectivesHolder.visible = true;
			m_objectivesHolder.alpha = 1;
			m_objectivesHolder.removeChildren();
			m_objectivesPosY = m_startY;
			if (data.primary.length > 0) {
				addObjLines(data.primary);
			}

			if (data.secondary.length > 0) {
				addObjLines(data.secondary);
			}

			updateHeights(bAnimate);
		});
		if (this.m_prevData != null) {
			TaskletSequencer.getGlobalInstance().addChunk(function ():void {
				releaseObjectiveViews(m_prevData.primary);
				releaseObjectiveViews(m_prevData.secondary);
			});
		}

		TaskletSequencer.getGlobalInstance().addChunk(function ():void {
			m_prevData = data;
		});
	}

	private function releaseObjectiveViews(_arg_1:Array):void {
		var _local_2:Number = 0;
		while (_local_2 < _arg_1.length) {
			if (_arg_1[_local_2].view != null) {
				this.resetObjectiveView(_arg_1[_local_2].view);
				this.m_objectiveViewPool.releaseObject(_arg_1[_local_2].view);
				_arg_1[_local_2].view = null;
				if (_arg_1[_local_2].timerData) {
					this.m_timers[_arg_1[_local_2].timerData.id] = null;
				}

				if (_arg_1[_local_2].percentCounterData) {
					this.m_percentCounters[_arg_1[_local_2].percentCounterData.id] = null;
				}

				if (_arg_1[_local_2].counterData) {
					this.m_counters[_arg_1[_local_2].counterData.id] = null;
				}

			}

			_local_2++;
		}

	}

	public function updateTimers(timersArray:Array):void {
		if (timersArray.length == 0) {
			return;
		}

		TaskletSequencer.getGlobalInstance().addChunk(function ():void {
			var _local_1:Object;
			for each (_local_1 in timersArray) {
				if (m_timers[_local_1.id]) {
					if (CommonUtils.getActiveTextLocaleIndex() == 11) {
						m_timers[_local_1.id].y = 33;
						m_timers[_local_1.id].htmlText = _local_1.timerString;
					} else {
						m_timers[_local_1.id].y = 28;
						m_timers[_local_1.id].htmlText = _local_1.timerString;
					}

				}

			}

		});
	}

	public function updatePercentCounters(percentCountersArray:Array):void {
		if (percentCountersArray.length == 0) {
			return;
		}

		TaskletSequencer.getGlobalInstance().addChunk(function ():void {
			var _local_2:Object;
			var _local_3:Object;
			var _local_1:Number = 0;
			while (_local_1 < percentCountersArray.length) {
				_local_2 = percentCountersArray[_local_1];
				_local_3 = m_percentCounters[_local_2.id];
				if (_local_3 != null) {
					if (CommonUtils.getActiveTextLocaleIndex() == 11) {
						_local_3.theField.y = 33;
						_local_3.theField = (String(_local_2.percent) + "%");
					} else {
						_local_3.theField.y = 28;
						_local_3.theField = (String(_local_2.percent) + "%");
					}

					_local_3.theBackground.width = (PERCENTAGE_BG_INIT_WIDTH * (_local_2.percent / 100));
				}

				_local_1++;
			}

		});
	}

	public function updateCounters(countersArray:Array):void {
		if (countersArray.length == 0) {
			return;
		}

		TaskletSequencer.getGlobalInstance().addChunk(function ():void {
			var _local_2:Object;
			var _local_3:Object;
			var _local_1:Number = 0;
			while (_local_1 < countersArray.length) {
				_local_2 = countersArray[_local_1];
				_local_3 = m_counters[_local_2.id];
				if (_local_3 != null) {
					updateCounter(_local_3, _local_2.counterString, _local_2.counterHeader);
				}

				_local_1++;
			}

		});
	}

	private function findPrevObjectiveWithAvailableView(_arg_1:String, _arg_2:String):Object {
		var _local_3:Object;
		if (this.m_prevData != null) {
			if (this.m_prevData.primary != null) {
				_local_3 = this.findPrevObjectiveHelper(_arg_1, _arg_2, this.m_prevData.primary);
			}

			if (((_local_3 == null) && (!(this.m_prevData.secondary == null)))) {
				_local_3 = this.findPrevObjectiveHelper(_arg_1, _arg_2, this.m_prevData.secondary);
			}

		}

		return (_local_3);
	}

	private function findPrevObjectiveHelper(_arg_1:String, _arg_2:String, _arg_3:Array):Object {
		var _local_4:Number = 0;
		while (_local_4 < _arg_3.length) {
			if ((((_arg_3[_local_4].id == _arg_1) && (_arg_3[_local_4].objTitle == _arg_2)) && (!(_arg_3[_local_4].view == null)))) {
				return (_arg_3[_local_4]);
			}

			_local_4++;
		}

		return (null);
	}

	private function addObjLines(_arg_1:Array):void {
		var _local_3:Object;
		var _local_2:Number = 0;
		for (; _local_2 < _arg_1.length; _local_2++) {
			if (this.m_prevData != null) {
				_local_3 = this.findPrevObjectiveWithAvailableView(_arg_1[_local_2].id, _arg_1[_local_2].objTitle);
				if (_local_3 != null) {
					if (_arg_1[_local_2].isHint) {
						this.updateHint(_arg_1[_local_2], _local_3);
					} else {
						this.updateObjective(_arg_1[_local_2], _local_3);
					}

					continue;
				}

			}

			if (_arg_1[_local_2].isHint) {
				this.addHint(_arg_1[_local_2]);
			} else {
				this.addObjective(_arg_1[_local_2]);
			}

		}

	}

	private function updateYPosition(_arg_1:Object):void {
		_arg_1.view.y = this.m_objectivesPosY;
		var _local_2:Number = 0;
		if ((_arg_1.view.label_txt.numLines - 1) > 0) {
			_local_2 = -6;
		}

		this.m_objectivesPosY = (this.m_objectivesPosY + (((SINGLE_LINE_NOTIFICATION_HEIGHT + ((_arg_1.view.label_txt.numLines - 1) * LABEL_TEXT_LEADING)) + _local_2) + OBJ_MARGIN_HEIGHT));
		if ((((_arg_1.timerData) || (_arg_1.percentCounterData)) || (_arg_1.counterData))) {
			_arg_1.view.counterTimer_mc.y = (((_arg_1.view.label_txt.numLines - 1) * LABEL_TEXT_LEADING) + _local_2);
			this.m_objectivesPosY = (this.m_objectivesPosY + (OBJ_MARGIN_HEIGHT + COUNTDOWN_OBJ_HEIGHT));
		}

	}

	private function addObjective(_arg_1:Object):void {
		var _local_2:String;
		_arg_1.view = this.m_objectiveViewPool.acquireObject();
		_arg_1.view.visible = true;
		_arg_1.view.label_txt.width = 670;
		if (((!(_arg_1.objSuccess)) && (!(_arg_1.objFail)))) {
			_local_2 = MenuConstants.FontColorWhite;
			this.setObjectiveOpenIcon(_arg_1);
		} else {
			_local_2 = MenuConstants.FontColorGreyMedium;
			this.setObjectiveResolvedIcon(_arg_1);
		}

		if (_arg_1.objChanged) {
			_arg_1.view.x = (this.m_startX + 150);
			Animate.legacyTo(_arg_1.view, 1, {"x": this.m_startX}, Animate.ExpoOut);
		} else {
			_arg_1.view.x = this.m_startX;
		}

		if (_arg_1.timerData) {
			this.initialiseObjectiveTimer(_arg_1.view, _arg_1.objTitle, _arg_1.timerData);
			_local_2 = MenuConstants.FontColorWhite;
		} else {
			if (_arg_1.percentCounterData) {
				this.initialiseObjectivePercentCounter(_arg_1.view, _arg_1.objTitle, _arg_1.percentCounterData);
				_local_2 = MenuConstants.FontColorWhite;
			} else {
				if (_arg_1.counterData) {
					this.initialiseObjectiveCounter(_arg_1.view, _arg_1.objTitle, _arg_1.objType, _arg_1.counterData);
					_local_2 = MenuConstants.FontColorWhite;
				}

			}

		}

		_arg_1.view.label_txt.htmlText = _arg_1.objTitle.toUpperCase();
		MenuUtils.setTextColor(_arg_1.view.label_txt, MenuConstants.ColorNumber(_local_2));
		this.updateYPosition(_arg_1);
		this.m_objectivesHolder.addChild(_arg_1.view);
	}

	private function updateObjective(_arg_1:Object, _arg_2:Object):void {
		var _local_3:String;
		_arg_1.view = _arg_2.view;
		_arg_2.view = null;
		if (((_arg_1.timerData) && (this.m_timers[_arg_1.timerData.id] == null))) {
			this.initialiseObjectiveTimer(_arg_1.view, _arg_1.objTitle, _arg_1.timerData);
		} else {
			if (((_arg_1.timerData == null) && (!(this.m_timers[_arg_1.id] == null)))) {
				this.m_timers[_arg_1.id] = null;
				_arg_1.view.counterTimer_mc.visible = false;
			}

		}

		if (((_arg_1.percentCounterData) && (this.m_percentCounters[_arg_1.percentCounterData.id] == null))) {
			this.initialiseObjectivePercentCounter(_arg_1.view, _arg_1.objTitle, _arg_1.percentCounterData);
		} else {
			if (((_arg_1.percentCounterData == null) && (!(this.m_percentCounters[_arg_1.id] == null)))) {
				this.m_percentCounters[_arg_1.id] = null;
				_arg_1.view.counterTimer_mc.visible = false;
			}

		}

		if (((_arg_1.counterData) && (this.m_counters[_arg_1.counterData.id] == null))) {
			this.initialiseObjectiveCounter(_arg_1.view, _arg_1.objTitle, _arg_1.objType, _arg_1.counterData);
		} else {
			if (((_arg_1.counterData == null) && (!(this.m_counters[_arg_1.id] == null)))) {
				this.m_counters[_arg_1.id] = null;
				_arg_1.view.counterTimer_mc.visible = false;
			}

		}

		this.updateYPosition(_arg_1);
		if (_arg_1.objChanged) {
			_arg_1.view.x = (this.m_startX + 150);
			Animate.legacyTo(_arg_1.view, 1, {"x": this.m_startX}, Animate.ExpoOut);
			if (((!(_arg_1.objSuccess)) && (!(_arg_1.objFail)))) {
				_local_3 = MenuConstants.FontColorWhite;
				this.setObjectiveOpenIcon(_arg_1);
			} else {
				_local_3 = MenuConstants.FontColorGreyMedium;
				this.setObjectiveResolvedIcon(_arg_1);
			}

			if ((((!(_arg_1.timerData)) && (!(_arg_1.percentCounterData))) && (!(_arg_1.counterData)))) {
				MenuUtils.setTextColor(_arg_1.view.label_txt, MenuConstants.ColorNumber(_local_3));
			}

		}

		this.m_objectivesHolder.addChild(_arg_1.view);
	}

	private function setObjectiveOpenIcon(_arg_1:Object):void {
		_arg_1.view.iconAnim_mc.z = this.m_zIconsVR;
		_arg_1.view.iconAnim_mc.icon_mc.gotoAndStop(1);
		_arg_1.view.iconAnim_mc.icon_mc.type_mc.gotoAndStop(this.iconNormalOrEvergreenHardcore(this.m_evergreenHardcore, _arg_1.objType));
	}

	private function setObjectiveResolvedIcon(_arg_1:Object):void {
		_arg_1.view.iconAnim_mc.z = 0;
		if (((_arg_1.objSuccess) && (!(_arg_1.objFail)))) {
			_arg_1.view.iconAnim_mc.icon_mc.gotoAndStop(3);
		} else {
			if (((!(_arg_1.objSuccess)) && (_arg_1.objFail))) {
				_arg_1.view.iconAnim_mc.icon_mc.gotoAndStop(2);
			} else {
				_arg_1.view.iconAnim_mc.icon_mc.gotoAndStop(4);
			}

		}

	}

	private function addHint(_arg_1:Object):void {
		_arg_1.view = this.m_objectiveViewPool.acquireObject();
		_arg_1.view.visible = true;
		var _local_2:Number = (this.m_startX + HINT_INDENTATON);
		_arg_1.view.iconAnim_mc.icon_mc.gotoAndStop(1);
		_arg_1.view.iconAnim_mc.icon_mc.type_mc.gotoAndStop((_arg_1.objType + 1));
		_arg_1.view.label_txt.width = (670 - HINT_INDENTATON);
		if (_arg_1.objChanged) {
			_arg_1.view.x = (_local_2 + 150);
			Animate.legacyTo(_arg_1.view, 1, {"x": _local_2}, Animate.ExpoOut);
		} else {
			_arg_1.view.x = _local_2;
		}

		var _local_3:Boolean = (((_arg_1.objType == 14) || (_arg_1.objType == 15)) || (_arg_1.objType == 16));
		_arg_1.view.label_txt.htmlText = _arg_1.objTitle.toUpperCase();
		MenuUtils.setTextColor(_arg_1.view.label_txt, MenuConstants.ColorNumber(((_local_3) ? MenuConstants.FontColorGreyMedium : MenuConstants.FontColorWhite)));
		_arg_1.view.iconAnim_mc.z = ((_local_3) ? 0 : this.m_zIconsVR);
		this.updateYPosition(_arg_1);
		this.m_objectivesHolder.addChild(_arg_1.view);
	}

	private function updateHint(_arg_1:Object, _arg_2:Object):void {
		_arg_1.view = _arg_2.view;
		_arg_2.view = null;
		this.updateYPosition(_arg_1);
		if (_arg_1.objChanged) {
			_arg_1.view.x = ((this.m_startX + HINT_INDENTATON) + 150);
			Animate.legacyTo(_arg_1.view, 1, {"x": (this.m_startX + HINT_INDENTATON)}, Animate.ExpoOut);
		}

		this.m_objectivesHolder.addChild(_arg_1.view);
	}

	private function iconNormalOrEvergreenHardcore(_arg_1:Boolean, _arg_2:int):int {
		if ((((_arg_1) && (_arg_2 >= 60)) && (_arg_2 <= 62))) {
			return (_arg_2 + 6);
		}

		if (((_arg_1) && (_arg_2 == 59))) {
			return (73);
		}

		if ((((_arg_1) && (_arg_2 >= 4)) && (_arg_2 <= 7))) {
			return (72);
		}

		return (_arg_2 + 1);
	}

	public function showOpportunity(sIcon:String, sTask:String, bNoDupes:Boolean):void {
		TaskletSequencer.getGlobalInstance().addChunk(function ():void {
			if (((((bNoDupes) && (m_oppHolder.visible)) && (sIcon == m_oppLastIcon)) && (sTask == m_oppLastTask))) {
				return;
			}

			Animate.kill(m_oppHolder);
			Animate.kill(m_oppNotification.icon_mc);
			Animate.kill(m_oppNotification);
			m_oppHolder.visible = true;
			m_oppHolder.alpha = 0;
			updateHeights();
			Animate.legacyTo(m_oppHolder, BAR_ELEMENT_FADE_ANIM_TIME, {"alpha": 1}, Animate.ExpoIn);
			m_oppNotification.desc_txt.htmlText = sTask;
			m_oppNotification.icon_mc.gotoAndStop(sIcon);
			m_oppNotification.x = 100;
			Animate.legacyTo(m_oppNotification, 1, {"x": 0}, Animate.ExpoOut);
			m_oppNotification.icon_mc.scaleX = (m_oppNotification.icon_mc.scaleY = 2.5);
			Animate.legacyTo(m_oppNotification.icon_mc, 2, {
				"scaleX": 1,
				"scaleY": 1
			}, Animate.ExpoOut);
			m_oppLastIcon = sIcon;
			m_oppLastTask = sTask;
		});
	}

	public function hideOpportunity():void {
		TaskletSequencer.getGlobalInstance().addChunk(function ():void {
			Animate.kill(m_oppNotification);
			Animate.kill(m_oppHolder);
			Animate.kill(m_oppMoveHolder);
			m_oppHolder.visible = false;
			updateHeights();
		});
	}

	public function hideObjectives(bAnimate:Boolean = true):void {
		TaskletSequencer.getGlobalInstance().addChunk(function ():void {
			Animate.kill(m_objectivesHolder);
			fadeOutObjectives(bAnimate);
		});
	}

	public function showIntelData(_arg_1:Object):void {
		this.showIntel(_arg_1.headline, _arg_1.showDuration);
	}

	public function showIntel(sHeadline:String, showDuration:Number):void {
		TaskletSequencer.getGlobalInstance().addChunk(function ():void {
			Animate.kill(m_intelHolder);
			Animate.kill(m_intelIndicator.icon_mc);
			Animate.kill(m_intelIndicator);
			m_intelHolder.visible = true;
			m_intelHolder.alpha = 0;
			updateHeights();
			Animate.legacyTo(m_intelHolder, BAR_ELEMENT_FADE_ANIM_TIME, {"alpha": 1}, Animate.ExpoIn);
			m_intelIndicator.x = 100;
			Animate.legacyTo(m_intelIndicator, 1, {"x": 0}, Animate.ExpoOut);
			m_intelIndicator.icon_mc.scaleX = (m_intelIndicator.icon_mc.scaleY = 2.5);
			Animate.legacyTo(m_intelIndicator.icon_mc, 2, {
				"scaleX": 1,
				"scaleY": 1
			}, Animate.ExpoOut);
			Animate.delay(m_intelIndicator, (showDuration + 2), fadeOutIntelIndicator);
		});
	}

	public function showSecurityIndicator(sText:String):void {
		TaskletSequencer.getGlobalInstance().addChunk(function ():void {
			Animate.kill(m_securityHolder);
			Animate.kill(m_securityIndicator.icon_mc);
			Animate.kill(m_securityIndicator);
			m_securityHolder.visible = true;
			m_securityHolder.alpha = 0;
			updateHeights();
			Animate.legacyTo(m_securityHolder, BAR_ELEMENT_FADE_ANIM_TIME, {"alpha": 1}, Animate.ExpoIn);
			MenuUtils.setupText(m_securityIndicator.header_txt, sText, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			m_securityIndicator.x = 100;
			Animate.legacyTo(m_securityIndicator, 1, {"x": 0}, Animate.ExpoOut);
			m_securityIndicator.icon_mc.scaleX = (m_securityIndicator.icon_mc.scaleY = 1);
			Animate.legacyTo(m_securityIndicator.icon_mc, 2, {
				"scaleX": 1,
				"scaleY": 1
			}, Animate.ExpoOut);
			Animate.delay(m_securityIndicator, 14, fadeOutSecurityIndicator);
		});
	}

	private function fadeOutIntelIndicator():void {
		Animate.legacyTo(this.m_intelHolder, BAR_ELEMENT_FADE_ANIM_TIME, {"alpha": 0}, Animate.Linear, this.hideIntelIndicator);
	}

	public function hideIntelIndicator():void {
		TaskletSequencer.getGlobalInstance().addChunk(function ():void {
			ExternalInterface.call("OnIntelNotificationHidden");
			Animate.kill(m_intelIndicator);
			Animate.kill(m_intelHolder);
			Animate.kill(m_intelMoveHolder);
			m_intelHolder.visible = false;
			m_intelHolder.alpha = 0;
			updateHeights();
		});
	}

	private function fadeOutSecurityIndicator():void {
		Animate.legacyTo(this.m_securityHolder, BAR_ELEMENT_FADE_ANIM_TIME, {"alpha": 0}, Animate.Linear, this.hideSecurityIndicator);
	}

	private function hideSecurityIndicator():void {
		Animate.kill(this.m_securityIndicator);
		Animate.kill(this.m_securityHolder);
		Animate.kill(this.m_securityMoveHolder);
		this.m_securityHolder.visible = false;
		this.m_securityHolder.alpha = 0;
		this.updateHeights();
	}

	private function fadeOutObjectives(_arg_1:Boolean = true):void {
		Animate.legacyTo(this.m_objectivesHolder, ((_arg_1) ? BAR_ELEMENT_FADE_ANIM_TIME : 0), {"alpha": 0}, Animate.Linear, this.hideObjectivesHolder, _arg_1);
	}

	private function hideObjectivesHolder(_arg_1:Boolean = true):void {
		Animate.kill(this.m_objectivesHolder);
		this.m_objectivesHolder.visible = false;
		this.m_objectivesHolder.alpha = 0;
		this.updateHeights(_arg_1);
	}

	private function updateHeights(_arg_1:Boolean = true):void {
		var _local_2:Number = ((_arg_1) ? 1 : 0);
		var _local_3:Number = ((ControlsMain.getDisplaySize() == ControlsMain.DISPLAY_SIZE_SMALL) ? 1.2 : 1);
		this.m_view.scaleX = _local_3;
		this.m_view.scaleY = _local_3;
		if (!this.m_objectivesHolder.visible) {
			this.m_objectivesPosY = this.m_startY;
		}

		var _local_4:Number = this.m_objectivesPosY;
		var _local_5:Number = _local_4;
		if (this.m_oppHolder.visible) {
			_local_5 = ((_local_5 + SINGLE_LINE_NOTIFICATION_HEIGHT) + OBJ_MARGIN_HEIGHT);
		}

		var _local_6:Number = _local_5;
		if (this.m_intelHolder.visible) {
			_local_6 = ((_local_6 + SINGLE_LINE_NOTIFICATION_HEIGHT) + OBJ_MARGIN_HEIGHT);
		}

		if (this.m_OpportunityPrevPosY != _local_4) {
			if (this.m_oppHolder.visible) {
				Animate.kill(this.m_oppMoveHolder);
				Animate.legacyTo(this.m_oppMoveHolder, _local_2, {"y": _local_4}, Animate.ExpoOut);
			} else {
				this.m_oppMoveHolder.y = _local_4;
			}

		}

		if (this.m_intelPrevposY != _local_5) {
			if (this.m_intelHolder.visible) {
				Animate.kill(this.m_intelMoveHolder);
				Animate.legacyTo(this.m_intelMoveHolder, _local_2, {"y": _local_5}, Animate.ExpoOut);
			} else {
				this.m_intelMoveHolder.y = _local_5;
			}

		}

		if (this.m_SecurityPrevPosY != _local_6) {
			if (this.m_securityHolder.visible) {
				Animate.kill(this.m_securityMoveHolder);
				Animate.legacyTo(this.m_securityMoveHolder, _local_2, {"y": _local_6}, Animate.ExpoOut);
			} else {
				this.m_securityMoveHolder.y = _local_6;
			}

		}

		this.m_OpportunityPrevPosY = _local_4;
		this.m_intelPrevposY = _local_5;
		this.m_SecurityPrevPosY = _local_6;
	}

	private function initialiseObjectiveTimer(_arg_1:LevelObjectiveView, _arg_2:String, _arg_3:Object):void {
		_arg_1.iconAnim_mc.icon_mc.gotoAndStop(1);
		_arg_1.iconAnim_mc.icon_mc.type_mc.gotoAndStop(this.iconNormalOrEvergreenHardcore(this.m_evergreenHardcore, 4));
		if (this.m_evergreenHardcore) {
			MenuUtils.setColor(_arg_1.counterTimer_mc.value_txt, MenuConstants.COLOR_WHITE, false);
			MenuUtils.setColor(_arg_1.counterTimer_mc.header_txt, MenuConstants.COLOR_WHITE, false);
			MenuUtils.setColor(_arg_1.counterTimer_mc.static_bg, MenuConstants.COLOR_RED, false);
			MenuUtils.setColor(_arg_1.counterTimer_mc.dynamic_bg, MenuConstants.COLOR_RED, false);
		}

		_arg_1.counterTimer_mc.static_bg.visible = false;
		_arg_1.counterTimer_mc.visible = true;
		_arg_1.counterTimer_mc.value_txt.autoSize = "left";
		if (CommonUtils.getActiveTextLocaleIndex() == 11) {
			_arg_1.counterTimer_mc.value_txt.y = 33;
		} else {
			_arg_1.counterTimer_mc.value_txt.y = 28;
		}

		_arg_3.timerHeader = Localization.get("UI_BRIEFING_DIAL_TIME");
		if (_arg_3.timerHeader) {
			_arg_1.counterTimer_mc.header_txt.htmlText = _arg_3.timerHeader;
		}

		_arg_1.counterTimer_mc.value_txt.htmlText = _arg_3.timerString;
		if (_arg_3.timerHeader) {
			_arg_1.counterTimer_mc.value_txt.x = ((COUNTDOWN_OBJ_HEADER_XPOS + _arg_1.counterTimer_mc.header_txt.textWidth) + COUNTDOWN_OBJ_TEXT_GAP);
			_arg_1.counterTimer_mc.dynamic_bg.width = (((_arg_1.counterTimer_mc.header_txt.textWidth + COUNTDOWN_OBJ_TEXT_GAP) + this.m_counterFieldTimerWidth) + 3);
		} else {
			_arg_1.counterTimer_mc.value_txt.x = COUNTDOWN_OBJ_HEADER_XPOS;
			_arg_1.counterTimer_mc.dynamic_bg.width = (this.m_counterFieldTimerWidth + 3);
		}

		this.m_timers[_arg_3.id] = _arg_1.counterTimer_mc.value_txt;
	}

	private function initialiseObjectivePercentCounter(_arg_1:LevelObjectiveView, _arg_2:String, _arg_3:Object):void {
		var _local_4:Number = 0;
		_arg_1.iconAnim_mc.icon_mc.gotoAndStop(1);
		_arg_1.iconAnim_mc.icon_mc.type_mc.gotoAndStop(20);
		_arg_1.counterTimer_mc.static_bg.visible = true;
		_arg_1.counterTimer_mc.visible = true;
		_arg_1.counterTimer_mc.value_txt.autoSize = "right";
		if (CommonUtils.getActiveTextLocaleIndex() == 11) {
			_arg_1.counterTimer_mc.value_txt.y = 33;
		} else {
			_arg_1.counterTimer_mc.value_txt.y = 28;
		}

		_arg_3.percentCounterHeader = Localization.get("UI_HUD_INFECTION_IN_BODY");
		if (_arg_3.percentCounterHeader) {
			_arg_1.counterTimer_mc.header_txt.htmlText = _arg_3.percentCounterHeader;
		}

		_arg_1.counterTimer_mc.value_txt.text = (String(_arg_3.percent) + "%");
		_arg_1.counterTimer_mc.value_txt.x = ((((COUNTDOWN_OBJ_HEADER_XPOS + PERCENTAGE_BG_INIT_WIDTH) + 3) - COUNTDOWN_OBJ_TEXT_GAP) - this.m_counterFieldPercentWidth);
		_arg_1.counterTimer_mc.dynamic_bg.width = PERCENTAGE_BG_INIT_WIDTH;
		_arg_1.counterTimer_mc.static_bg.width = PERCENTAGE_BG_INIT_WIDTH;
		_arg_1.counterTimer_mc.static_bg.alpha = 0.5;
		var _local_5:TextField = (_arg_1.counterTimer_mc.value_txt as TextField);
		this.m_percentCounters[_arg_3.id] = {
			"theField": _local_5,
			"theBackground": _arg_1.counterTimer_mc.dynamic_bg
		};
	}

	private function initialiseObjectiveCounter(_arg_1:LevelObjectiveView, _arg_2:String, _arg_3:Number, _arg_4:Object):void {
		_arg_1.iconAnim_mc.icon_mc.gotoAndStop(1);
		_arg_1.iconAnim_mc.icon_mc.type_mc.gotoAndStop(this.iconNormalOrEvergreenHardcore(this.m_evergreenHardcore, (_arg_3 + 1)));
		_arg_1.counterTimer_mc.static_bg.visible = false;
		_arg_1.counterTimer_mc.visible = true;
		_arg_1.counterTimer_mc.value_txt.autoSize = "left";
		var _local_5:TextField = (_arg_1.counterTimer_mc.value_txt as TextField);
		this.m_counters[_arg_4.id] = {
			"theField": _local_5,
			"background": _arg_1.counterTimer_mc.dynamic_bg,
			"headerField": _arg_1.counterTimer_mc.header_txt,
			"counterString": _arg_4.counterString
		};
		_local_5.scaleX = 1;
		_local_5.scaleY = 1;
		var _local_6:Object = this.m_counters[_arg_4.id];
		this.updateCounter(_local_6, _arg_4.counterString, _arg_4.counterHeader);
	}

	private function updateCounter(_arg_1:Object, _arg_2:String, _arg_3:String):void {
		var _local_4:TextField = (_arg_1.theField as TextField);
		var _local_5:Object = _arg_1.background;
		var _local_6:TextField = (_arg_1.headerField as TextField);
		var _local_7:String = _arg_1.counterString;
		Animate.kill(_local_4);
		_local_4.scaleX = (_local_4.scaleY = 1);
		if (CommonUtils.getActiveTextLocaleIndex() == 11) {
			_local_4.y = 33;
		} else {
			_local_4.y = 28;
		}

		if (_arg_3) {
			_local_6.htmlText = _arg_3;
		}

		_local_4.htmlText = _arg_2;
		_local_4.x = COUNTDOWN_OBJ_HEADER_XPOS;
		_local_5.width = (this.determineCounterBackgroundCounterTextWidth(_arg_2) + 5);
		if (_arg_3) {
			_local_4.x = (_local_4.x + (_local_6.textWidth + COUNTDOWN_OBJ_TEXT_GAP));
			_local_6.x = COUNTDOWN_OBJ_HEADER_XPOS;
			_local_5.width = (_local_5.width + (_local_6.textWidth + COUNTDOWN_OBJ_TEXT_GAP));
		}

		if (_arg_2 != _local_7) {
			this.animateCounterTextScale(_local_4, _local_6);
		}

	}

	private function animateCounterTextScale(_arg_1:TextField, _arg_2:TextField):void {
		var _local_3:Number = _arg_1.scaleX;
		var _local_4:Number = _arg_1.scaleY;
		var _local_5:Number = _arg_1.width;
		var _local_6:Number = _arg_1.height;
		var _local_7:Number = _arg_1.x;
		var _local_8:Number = _arg_1.y;
		_arg_1.scaleX = (_arg_1.scaleY = 1.3);
		_arg_1.x = (_local_7 - ((_arg_1.width - _local_5) / 2));
		_arg_1.y = (_local_8 - ((_arg_1.height - _local_6) / 2));
		Animate.to(_arg_1, 0.6, 0, {
			"x": _local_7,
			"y": _local_8,
			"scaleX": _local_3,
			"scaleY": _local_4
		}, Animate.ExpoOut);
	}

	private function determineCounterBackgroundCounterTextWidth(_arg_1:String):Number {
		if (_arg_1.length <= 1) {
			return (this.m_counterFieldSingleDigitWidth);
		}

		if (_arg_1.length == 2) {
			return (this.m_counterFieldDoubleDigitWidth);
		}

		return (this.m_counterFieldTripleDigitWidth);
	}


}
}//package hud

