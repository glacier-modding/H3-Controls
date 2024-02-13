// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.StatusMarkersVR

package hud {
import common.BaseControl;
import common.Localization;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.utils.Dictionary;
import flash.text.TextFormat;

import common.menu.MenuUtils;
import common.menu.MenuConstants;

import basic.ButtonPromptImage;

import common.CommonUtils;

import flash.text.TextLineMetrics;

import common.Animate;
import common.TaskletSequencer;

import flash.text.TextField;
import flash.display.DisplayObject;
import flash.external.ExternalInterface;

public class StatusMarkersVR extends BaseControl {

	public static const ICON_SEARCHING:int = 1;
	public static const ICON_COMPROMISED:int = 2;
	public static const ICON_HUNTED:int = 3;
	public static const ICON_COMBAT:int = 4;
	public static const ICON_SECURITYCAMERA:int = 5;
	public static const ICON_HIDDENINLVA:int = 6;
	public static const ICON_QUESTIONMARK:int = 7;
	public static const ICON_UNCONSCIOUSWITNESS:int = 8;
	public static const STATE_CLEAR:int = 0;
	public static const STATE_TRESPASSING:int = 1;
	public static const STATE_DEEPTRESPASSING:int = 2;
	private static const DISABLE_MIN_HEIGHT:Number = -1;
	private static const MIN_FONT_SIZE:Number = 9;
	private static const OBJID_INTEL:String = "INTEL";
	private static const OBJID_OPPORTUNITY:String = "OPPORTUNITY";
	private static const COUNTDOWN_OBJ_HEADER_XPOS:Number = 34;
	private static const COUNTDOWN_OBJ_TEXT_GAP:Number = 10;
	private static const PERCENTAGE_BG_INIT_WIDTH:Number = 300;

	private const m_lstrDeepTrespassing:String = Localization.get("EGAME_TEXT_SL_HOSTILEAREA").toUpperCase();
	private const m_lstrTrespassing:String = Localization.get("EGAME_TEXT_SL_TRESPASSING_ON").toUpperCase();
	private const m_lstrClear:String = Localization.get("EGAME_TEXT_SL_CLEAR").toUpperCase();
	private const m_lstrTimeRemaining:String = Localization.get("UI_BRIEFING_DIAL_TIME");
	private const m_lstrInfection:String = Localization.get("UI_HUD_INFECTION_IN_BODY");
	private const m_varsWitnessesNone:Object = {
		"x": 180,
		"alpha": 0
	};
	private const m_varsWitnessesSome:Object = {
		"x": 212,
		"alpha": 1
	};

	private var m_trespassingIndicatorMc:MovieClip;
	private var m_tensionIndicatorMc:MovieClip;
	private var m_trespassingIndicatorHolder:Sprite;
	private var m_intelIndicator:IntelIndicatorView;
	private var m_oppNotification:OpportunityBarView;
	private var m_objectiveView:LevelObjectiveView;
	private var m_intelNotebookActivationIcon:Sprite;
	private var m_intelNotebookActivationIcon_hold_mc:MovieClip;
	private var m_state:int = 0;
	private var m_isHiddenInCrowd:Boolean = false;
	private var m_isHiddenInVegetation:Boolean = false;
	private var m_isHidden:Boolean = false;
	private var m_objlikeQueue:ObjlikeQueue = new ObjlikeQueue();
	private var m_objectiveByCounterId:Dictionary = new Dictionary();
	private var m_isObjlikeEnabled:Boolean = true;
	private var m_oppLastIcon:String;
	private var m_oppLastTask:String;
	private var m_widthCounterFieldTimer:Number;
	private var m_widthCounterFieldPercent:Number;
	private var m_widthCounterFieldSingleDigit:Number;
	private var m_widthCounterFieldDoubleDigit:Number;
	private var m_widthCounterFieldTripleDigit:Number;
	private var m_dtTimeoutTrespassingEnter:Number;
	private var m_dtTimeoutTrespassingClear:Number;
	private var m_dtTimeoutTensionMessage:Number;
	private var m_dyGapBetweenStatusMessages:Number;
	private var m_yObjlikeElements:Number;

	public function StatusMarkersVR() {
		var _local_3:String;
		var _local_4:MovieClip;
		super();
		var _local_1:StatusMarkerView = new StatusMarkerView();
		this.m_trespassingIndicatorMc = _local_1.trespassingIndicatorMc;
		this.m_tensionIndicatorMc = _local_1.tensionIndicatorMc;
		addChild(this.m_tensionIndicatorMc);
		this.m_trespassingIndicatorHolder = new Sprite();
		this.m_trespassingIndicatorHolder.name = "m_trespassingIndicatorHolder";
		addChild(this.m_trespassingIndicatorHolder);
		this.m_trespassingIndicatorHolder.addChild(this.m_trespassingIndicatorMc);
		this.m_trespassingIndicatorMc.alpha = 0;
		this.m_tensionIndicatorMc.alpha = 0;
		var _local_2:TextFormat = new TextFormat();
		_local_2.leading = -3.5;
		this.m_trespassingIndicatorMc.x = -105;
		this.m_trespassingIndicatorMc.y = 0;
		this.m_trespassingIndicatorMc.pulseMc.scaleY = 1.05;
		this.m_trespassingIndicatorMc.removeChild(this.m_trespassingIndicatorMc.overlayMc);
		this.m_trespassingIndicatorMc.removeChild(this.m_trespassingIndicatorMc.bgGradient);
		this.m_tensionIndicatorMc.labelTxt.autoSize = "left";
		this.m_tensionIndicatorMc.labelTxt.multiline = true;
		this.m_tensionIndicatorMc.labelTxt.wordWrap = true;
		this.m_tensionIndicatorMc.labelTxt.width = 186;
		this.m_tensionIndicatorMc.labelTxt.text = "...";
		this.m_tensionIndicatorMc.labelTxt.setTextFormat(_local_2);
		MenuUtils.setupText(this.m_tensionIndicatorMc.unconMc.labelTxt, "", 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
		this.m_tensionIndicatorMc.bgMc.height = 23;
		this.m_tensionIndicatorMc.x = -105;
		this.m_tensionIndicatorMc.y = 0;
		for (_local_3 in this.m_varsWitnessesNone) {
			this.m_tensionIndicatorMc.unconMc[_local_3] = this.m_varsWitnessesNone[_local_3];
		}

		this.m_tensionIndicatorMc.removeChild(this.m_tensionIndicatorMc.bgGradient);
		this.m_oppNotification = new OpportunityBarView();
		this.m_oppNotification.name = "oppNotification";
		this.m_oppNotification.y = this.m_yObjlikeElements;
		this.m_oppNotification.alpha = 0;
		MenuUtils.setupText(this.m_oppNotification.desc_txt, "", 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		addChild(this.m_oppNotification);
		this.m_intelIndicator = new IntelIndicatorView();
		this.m_intelIndicator.name = "intelIndicator";
		this.m_intelIndicator.y = this.m_yObjlikeElements;
		this.m_intelIndicator.alpha = 0;
		this.onControlLayoutChanged();
		addChild(this.m_intelIndicator);
		this.m_objectiveView = new LevelObjectiveView();
		this.m_objectiveView.name = "objectiveView";
		this.m_objectiveView.y = this.m_yObjlikeElements;
		this.m_objectiveView.alpha = 0;
		this.m_objectiveView.label_txt.autoSize = "left";
		this.m_objectiveView.label_txt.multiline = true;
		this.m_objectiveView.label_txt.wordWrap = true;
		this.m_objectiveView.label_txt.y = -1;
		MenuUtils.setupText(this.m_objectiveView.label_txt, "", 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		_local_4 = this.m_objectiveView.counterTimer_mc;
		_local_4.header_txt.autoSize = "left";
		MenuUtils.setupText(_local_4.header_txt, "", 12, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraDark);
		MenuUtils.setupText(_local_4.value_txt, "", 24, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorGreyUltraDark);
		_local_4.value_txt.text = "00:00";
		this.m_widthCounterFieldTimer = _local_4.value_txt.textWidth;
		_local_4.value_txt.text = "100%";
		this.m_widthCounterFieldPercent = _local_4.value_txt.textWidth;
		_local_4.value_txt.text = "0";
		this.m_widthCounterFieldSingleDigit = _local_4.value_txt.textWidth;
		_local_4.value_txt.text = "00";
		this.m_widthCounterFieldDoubleDigit = _local_4.value_txt.textWidth;
		_local_4.value_txt.text = "000";
		this.m_widthCounterFieldTripleDigit = _local_4.value_txt.textWidth;
		_local_4.value_txt.text = "";
		addChild(this.m_objectiveView);
	}

	public function set dtTimeoutTrespassingEnter(_arg_1:Number):void {
		this.m_dtTimeoutTrespassingEnter = _arg_1;
	}

	public function set dtTimeoutTrespassingClear(_arg_1:Number):void {
		this.m_dtTimeoutTrespassingClear = _arg_1;
	}

	public function set dtTimeoutTensionMessage(_arg_1:Number):void {
		this.m_dtTimeoutTensionMessage = _arg_1;
	}

	public function set dyGapBetweenStatusMessages(_arg_1:Number):void {
		this.m_dyGapBetweenStatusMessages = _arg_1;
	}

	public function set yObjlikeElements(_arg_1:Number):void {
		this.m_yObjlikeElements = _arg_1;
		this.m_oppNotification.y = _arg_1;
		this.m_intelIndicator.y = _arg_1;
		this.m_objectiveView.y = _arg_1;
	}

	public function set widthOfObjlikeTextFields(_arg_1:Number):void {
		this.m_oppNotification.desc_txt.width = _arg_1;
		this.m_objectiveView.label_txt.width = _arg_1;
	}

	public function setObjlikeEnabled(_arg_1:Boolean):void {
		this.m_isObjlikeEnabled = _arg_1;
	}

	public function onControlLayoutChanged():void {
		var _local_1:String;
		var _local_2:Boolean;
		var _local_5:ButtonPromptImage;
		_local_1 = ControlsMain.getControllerType();
		_local_2 = CommonUtils.isPCVRControllerUsed(_local_1);
		var _local_3:String = ((_local_2) ? "UI_HUD_INTEL_VIEW_INTEL_NOBUTTON" : "UI_HUD_INTEL_VIEW_INTEL");
		MenuUtils.setupText(this.m_intelIndicator.header_txt, Localization.get(_local_3), 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		this.m_intelIndicator.x = (-(this.m_intelIndicator.header_txt.x + this.m_intelIndicator.header_txt.textWidth) / 2);
		var _local_4:TextLineMetrics = this.m_intelIndicator.header_txt.getLineMetrics(0);
		this.m_intelIndicator.header_txt.y = (16 - _local_4.ascent);
		if (((_local_2) && (this.m_intelNotebookActivationIcon == null))) {
			this.m_intelNotebookActivationIcon = new Sprite();
			this.m_intelNotebookActivationIcon.name = "m_intelNotebookActivationIcon";
			this.m_intelNotebookActivationIcon_hold_mc = new InteractionIndicatorView().hold_mc;
			this.m_intelNotebookActivationIcon.addChild(this.m_intelNotebookActivationIcon_hold_mc);
			this.m_intelNotebookActivationIcon_hold_mc.gotoAndPlay(139);
			_local_5 = new ButtonPromptImage();
			_local_5.name = "promptimage";
			_local_5.platform = _local_1;
			_local_5.button = 18;
			this.m_intelNotebookActivationIcon.addChild(_local_5);
			this.m_intelIndicator.addChild(this.m_intelNotebookActivationIcon);
			this.m_intelNotebookActivationIcon.x = ((this.m_intelIndicator.header_txt.x + this.m_intelIndicator.header_txt.textWidth) + 30);
			this.m_intelNotebookActivationIcon.y = (this.m_intelIndicator.icon_mc.height / 2);
			this.m_intelNotebookActivationIcon.scaleX = 0.85;
			this.m_intelNotebookActivationIcon.scaleY = 0.85;
		} else {
			if (((!(_local_2)) && (!(this.m_intelNotebookActivationIcon == null)))) {
				this.m_intelIndicator.removeChild(this.m_intelNotebookActivationIcon);
				this.m_intelNotebookActivationIcon = null;
				this.m_intelNotebookActivationIcon_hold_mc = null;
			}

		}

	}

	public function setIntelNotebookActivationProgress(_arg_1:Number):void {
		if (this.m_intelNotebookActivationIcon_hold_mc != null) {
			this.m_intelNotebookActivationIcon_hold_mc.gotoAndStop(Math.ceil((_arg_1 * 60)));
		}

	}

	public function onSetData(_arg_1:Object):void {
		var _local_3:String;
		var _local_2:int = this.m_state;
		this.m_state = ((_arg_1.bDeepTrespassing) ? STATE_DEEPTRESPASSING : ((_arg_1.bTrespassing) ? STATE_TRESPASSING : STATE_CLEAR));
		if (this.m_state == _local_2) {
			return;
		}

		if (this.m_state != STATE_CLEAR) {
			this.playSound(((this.m_state == STATE_DEEPTRESPASSING) ? "play_ui_deeptrespass_activate" : "play_ui_trespass_activate"));
			MenuUtils.removeColor(this.m_trespassingIndicatorMc.bgMc);
			MenuUtils.removeColor(this.m_trespassingIndicatorMc.pulseMc);
			_local_3 = ((this.m_state == STATE_DEEPTRESPASSING) ? this.m_lstrDeepTrespassing : this.m_lstrTrespassing);
			MenuUtils.setupTextAndShrinkToFitUpper(this.m_trespassingIndicatorMc.labelTxt, _local_3, 18, MenuConstants.FONT_TYPE_MEDIUM, 184, DISABLE_MIN_HEIGHT, MIN_FONT_SIZE, MenuConstants.FontColorGreyUltraDark);
			Animate.kill(this.m_trespassingIndicatorMc);
			this.m_trespassingIndicatorMc.alpha = 1;
			this.m_trespassingIndicatorMc.scaleY = 1;
			Animate.fromTo(this.m_trespassingIndicatorMc.pulseMc, 0.5, 0, {
				"alpha": 1,
				"scaleX": 1
			}, {
				"alpha": 0,
				"scaleX": 1.5
			}, Animate.ExpoOut, this.onTrespassingIndicatorPulseFinished, 0.5, this.m_dtTimeoutTrespassingEnter, {"alpha": 0}, this.updateStatusMarkerPositions);
		} else {
			this.playSound("play_ui_trespass_deactivate");
			Animate.kill(this.m_trespassingIndicatorMc.pulseMc);
			this.m_trespassingIndicatorMc.pulseMc.alpha = 0;
			this.m_trespassingIndicatorMc.pulseMc.scaleX = 1;
			Animate.to(this.m_trespassingIndicatorMc, 0.5, 0, {"alpha": 1}, Animate.Linear, this.onTrespassingIndicatorPulseClear);
		}

		this.updateStatusMarkerPositions();
	}

	private function onTrespassingIndicatorPulseClear():void {
		MenuUtils.setupTextAndShrinkToFitUpper(this.m_trespassingIndicatorMc.labelTxt, this.m_lstrClear, 18, MenuConstants.FONT_TYPE_MEDIUM, 184, DISABLE_MIN_HEIGHT, MIN_FONT_SIZE, MenuConstants.FontColorGreyUltraDark);
		MenuUtils.setColor(this.m_trespassingIndicatorMc.bgMc, MenuConstants.COLOR_GREEN, false);
		MenuUtils.setColor(this.m_trespassingIndicatorMc.pulseMc, MenuConstants.COLOR_GREEN, false);
		Animate.fromTo(this.m_trespassingIndicatorMc.pulseMc, 0.5, 0, {
			"alpha": 1,
			"scaleX": 1
		}, {
			"alpha": 0,
			"scaleX": 1.5
		}, Animate.ExpoOut, this.onTrespassingIndicatorPulseFinished, 0.1, this.m_dtTimeoutTrespassingClear, {"scaleY": 0}, this.setTrespassingIndicatorAlphaZero);
	}

	private function onTrespassingIndicatorPulseFinished(_arg_1:Number, _arg_2:Number, _arg_3:Object, _arg_4:Function = null):void {
		this.m_trespassingIndicatorMc.pulseMc.scaleX = 1;
		Animate.to(this.m_trespassingIndicatorMc, _arg_1, _arg_2, _arg_3, Animate.Linear, _arg_4);
	}

	private function setTrespassingIndicatorAlphaZero():void {
		this.m_trespassingIndicatorMc.alpha = 0;
		this.updateStatusMarkerPositions();
	}

	public function setTensionMessage(_arg_1:String, _arg_2:int, _arg_3:int):void {
		if (_arg_1 == "") {
			Animate.kill(this.m_tensionIndicatorMc.iconMc);
			Animate.kill(this.m_tensionIndicatorMc.labelTxt);
			Animate.kill(this.m_tensionIndicatorMc.unconMc);
			Animate.to(this.m_tensionIndicatorMc, 0.1, 0, {"alpha": 0}, Animate.Linear, this.updateStatusMarkerPositions);
		} else {
			if (_arg_3 >= 1) {
				_arg_2 = ICON_UNCONSCIOUSWITNESS;
			}

			this.m_tensionIndicatorMc.iconMc.gotoAndStop(((_arg_2 > 0) ? _arg_2 : 1));
			this.m_tensionIndicatorMc.labelTxt.text = _arg_1.toUpperCase();
			this.m_tensionIndicatorMc.bgMc.height = (23 + ((this.m_tensionIndicatorMc.labelTxt.numLines - 1) * 19));
			Animate.kill(this.m_tensionIndicatorMc.iconMc);
			this.m_tensionIndicatorMc.iconMc.scaleX = 0;
			this.m_tensionIndicatorMc.iconMc.scaleY = 0;
			Animate.kill(this.m_tensionIndicatorMc.labelTxt);
			this.m_tensionIndicatorMc.labelTxt.alpha = 0;
			this.m_tensionIndicatorMc.labelTxt.x = 15;
			Animate.kill(this.m_tensionIndicatorMc.unconMc);
			this.m_tensionIndicatorMc.unconMc.alpha = this.m_varsWitnessesNone.alpha;
			this.m_tensionIndicatorMc.unconMc.x = this.m_varsWitnessesNone.x;
			Animate.fromTo(this.m_tensionIndicatorMc, 0.1, 0, {"alpha": 0}, {"alpha": 1}, Animate.Linear, this.onTensionBarAnimStep1, _arg_3);
			this.m_tensionIndicatorMc.alpha = 0.011;
		}

		this.updateStatusMarkerPositions();
	}

	private function onTensionBarAnimStep1(_arg_1:int):void {
		Animate.fromTo(this.m_tensionIndicatorMc.iconMc, 0.1, 0, {
			"scaleX": 0,
			"scaleY": 0
		}, {
			"scaleX": 1,
			"scaleY": 1
		}, Animate.Linear, this.onTensionBarAnimStep2, _arg_1);
	}

	private function onTensionBarAnimStep2(_arg_1:int):void {
		Animate.fromTo(this.m_tensionIndicatorMc.labelTxt, 0.1, 0, {
			"alpha": 0,
			"x": 15
		}, {
			"alpha": 1,
			"x": 21
		}, Animate.Linear, this.onTensionBarAnimStep3, _arg_1);
	}

	private function onTensionBarAnimStep3(_arg_1:int):void {
		var _local_2:String;
		if (_arg_1 >= 2) {
			_local_2 = String(_arg_1);
			this.m_tensionIndicatorMc.unconMc.labelTxt.text = _local_2;
			this.m_tensionIndicatorMc.unconMc.bgMc.width = (29 + (_local_2.length * 12));
			this.m_tensionIndicatorMc.unconMc.bgMc.height = this.m_tensionIndicatorMc.bgMc.height;
			Animate.fromTo(this.m_tensionIndicatorMc.unconMc, 0.1, 0.1, this.m_varsWitnessesNone, this.m_varsWitnessesSome, Animate.Linear, this.onTensionBarAnimStepFinal);
		} else {
			this.onTensionBarAnimStepFinal();
		}

	}

	private function onTensionBarAnimStepFinal():void {
		Animate.addFromTo(this.m_tensionIndicatorMc, 0.5, this.m_dtTimeoutTensionMessage, {"alpha": 1}, {"alpha": 0}, Animate.Linear, this.updateStatusMarkerPositions);
	}

	private function updateStatusMarkerPositions():void {
		var _local_1:Boolean;
		_local_1 = (this.m_tensionIndicatorMc.alpha >= 0.01);
		var _local_2:Number = ((_local_1) ? (this.m_tensionIndicatorMc.bgMc.height + this.m_dyGapBetweenStatusMessages) : 0);
		var _local_3:* = (this.m_trespassingIndicatorMc.alpha >= 0.01);
		Animate.to(this.m_trespassingIndicatorHolder, ((_local_3) ? 0.2 : 0), 0, {"y": _local_2}, Animate.ExpoOut);
	}

	public function hiddenInCrowd(_arg_1:Boolean):void {
		this.m_isHiddenInCrowd = _arg_1;
		this.checkLVAState();
	}

	public function hiddenInVegetation(_arg_1:Boolean):void {
		this.m_isHiddenInVegetation = _arg_1;
		this.checkLVAState();
	}

	private function checkLVAState():void {
		var _local_1:Boolean = this.m_isHidden;
		this.m_isHidden = ((this.m_isHiddenInCrowd) || (this.m_isHiddenInVegetation));
		if (this.m_isHidden != _local_1) {
			this.playSound(((this.m_isHidden) ? "play_ui_crowd_blendin" : "play_ui_crowd_blendout"));
		}

	}

	public function showIntel(sHeadline:String, showDuration:Number):void {
		if (!this.m_isObjlikeEnabled) {
			return;
		}

		var prepare:Function = ((this.m_intelNotebookActivationIcon == null) ? function ():void {
		} : function ():void {
			m_intelNotebookActivationIcon.alpha = 0;
			Animate.fromTo(m_intelNotebookActivationIcon, 0.3, 0.2, {
				"alpha": 0,
				"x": (m_intelIndicator.header_txt.textWidth + 30)
			}, {
				"alpha": 1,
				"x": ((m_intelIndicator.header_txt.textWidth + 30) + 30)
			}, Animate.ExpoOut);
		});
		var dtLinger:Number = (1.6 + (this.m_intelIndicator.header_txt.text.length / 12));
		this.m_objlikeQueue.push(OBJID_INTEL, prepare, this.m_intelIndicator, this.m_intelIndicator.icon_mc, this.m_intelIndicator.header_txt, dtLinger);
	}

	public function hideIntelIndicator():void {
		this.m_objlikeQueue.cancel(OBJID_INTEL);
	}

	public function showOpportunity(sIcon:String, sTask:String, bNoDupes:Boolean):void {
		if ((((bNoDupes) && (sIcon == this.m_oppLastIcon)) && (sTask == this.m_oppLastTask))) {
			return;
		}

		if (!this.m_isObjlikeEnabled) {
			return;
		}

		this.m_oppLastIcon = sIcon;
		this.m_oppLastTask = sTask;
		var prepare:Function = function ():void {
			m_oppNotification.icon_mc.gotoAndStop(m_oppLastIcon);
			m_oppNotification.desc_txt.htmlText = m_oppLastTask;
			m_oppNotification.x = (-(30 + m_oppNotification.desc_txt.textWidth) / 2);
		};
		var dtLinger:Number = (1.2 + (sTask.length / 15));
		this.m_objlikeQueue.push(OBJID_OPPORTUNITY, prepare, this.m_oppNotification, this.m_oppNotification.icon_mc, this.m_oppNotification.desc_txt, dtLinger);
	}

	public function hideOpportunity():void {
		this.m_oppLastIcon = null;
		this.m_oppLastTask = null;
		this.m_objlikeQueue.cancel(OBJID_OPPORTUNITY);
	}

	public function showObjective(objective:Object):void {
		if (!this.m_isObjlikeEnabled) {
			return;
		}

		var prepare:Function = function ():void {
			var ts:TaskletSequencer = TaskletSequencer.getGlobalInstance();
			ts.addChunk(function ():void {
				m_objectiveView.label_txt.htmlText = objective.objTitle.toUpperCase();
				if (((!(objective.objSuccess)) && (!(objective.objFail)))) {
					m_objectiveView.iconAnim_mc.icon_mc.gotoAndStop(1);
					m_objectiveView.iconAnim_mc.icon_mc.type_mc.gotoAndStop((objective.objType + 1));
				} else {
					m_objectiveView.iconAnim_mc.icon_mc.gotoAndStop((((objective.objSuccess) && (!(objective.objFail))) ? 3 : (((!(objective.objSuccess)) && (objective.objFail)) ? 2 : 4)));
					m_objectiveView.iconAnim_mc.icon_mc.getChildAt(0).alpha = 1;
				}

				m_objectiveView.x = (-(30 + m_objectiveView.label_txt.textWidth) / 2);
			});
			ts.addChunk(function ():void {
				if (objective.timerData) {
					initialiseObjectiveTimer(objective.objTitle, objective.timerData);
				} else {
					if (objective.percentCounterData) {
						initialiseObjectivePercentCounter(objective.objTitle, objective.percentCounterData);
					} else {
						if (objective.counterData) {
							initialiseObjectiveCounter(objective.objTitle, objective.objType, objective.counterData);
							m_objectiveByCounterId[objective.counterData.id] = objective;
						} else {
							m_objectiveView.counterTimer_mc.visible = false;
						}

					}

				}

			});
		};
		var dtLinger:Number = (1.8 + (objective.objTitle.length / 55));
		this.m_objlikeQueue.push(objective.id, prepare, this.m_objectiveView, this.m_objectiveView.iconAnim_mc, this.m_objectiveView.label_txt, dtLinger);
	}

	private function initialiseObjectiveTimer(_arg_1:String, _arg_2:Object):void {
		this.m_objectiveView.iconAnim_mc.icon_mc.gotoAndStop(1);
		this.m_objectiveView.iconAnim_mc.icon_mc.type_mc.gotoAndStop(4);
		var _local_3:MovieClip = this.m_objectiveView.counterTimer_mc;
		_local_3.static_bg.visible = false;
		_local_3.visible = true;
		_local_3.value_txt.autoSize = "left";
		_local_3.value_txt.y = ((CommonUtils.getActiveTextLocaleIndex() == 11) ? 33 : 28);
		_local_3.header_txt.htmlText = this.m_lstrTimeRemaining;
		_local_3.value_txt.htmlText = _arg_2.timerString;
		_local_3.value_txt.x = ((_local_3.header_txt.textWidth + COUNTDOWN_OBJ_TEXT_GAP) + COUNTDOWN_OBJ_HEADER_XPOS);
		_local_3.dynamic_bg.width = (((_local_3.header_txt.textWidth + COUNTDOWN_OBJ_TEXT_GAP) + this.m_widthCounterFieldTimer) + 3);
		var _local_4:Number = ((this.m_objectiveView.label_txt.numLines - 1) * 20);
		_local_3.y = (_local_4 - 30);
		_local_3.alpha = 0;
		Animate.to(_local_3, 0.3, 0.3, {
			"y": _local_4,
			"alpha": 1
		}, Animate.ExpoOut);
	}

	private function initialiseObjectivePercentCounter(_arg_1:String, _arg_2:Object):void {
		this.m_objectiveView.iconAnim_mc.icon_mc.gotoAndStop(1);
		this.m_objectiveView.iconAnim_mc.icon_mc.type_mc.gotoAndStop(20);
		var _local_3:MovieClip = this.m_objectiveView.counterTimer_mc;
		_local_3.static_bg.visible = true;
		_local_3.visible = true;
		_local_3.value_txt.autoSize = "right";
		_local_3.value_txt.y = ((CommonUtils.getActiveTextLocaleIndex() == 11) ? 33 : 28);
		_local_3.header_txt.htmlText = this.m_lstrInfection;
		_local_3.value_txt.text = (String(_arg_2.percent) + "%");
		_local_3.value_txt.x = ((((COUNTDOWN_OBJ_HEADER_XPOS + PERCENTAGE_BG_INIT_WIDTH) + 3) - COUNTDOWN_OBJ_TEXT_GAP) - this.m_widthCounterFieldPercent);
		_local_3.dynamic_bg.width = PERCENTAGE_BG_INIT_WIDTH;
		_local_3.static_bg.width = PERCENTAGE_BG_INIT_WIDTH;
		_local_3.static_bg.alpha = 0.5;
		var _local_4:Number = ((this.m_objectiveView.label_txt.numLines - 1) * 20);
		_local_3.y = (_local_4 - 30);
		_local_3.alpha = 0;
		Animate.to(_local_3, 0.3, 0.3, {
			"y": _local_4,
			"alpha": 1
		}, Animate.ExpoOut);
	}

	private function initialiseObjectiveCounter(_arg_1:String, _arg_2:Number, _arg_3:Object):void {
		this.m_objectiveView.iconAnim_mc.icon_mc.gotoAndStop(1);
		this.m_objectiveView.iconAnim_mc.icon_mc.type_mc.gotoAndStop((_arg_2 + 1));
		var _local_4:MovieClip = this.m_objectiveView.counterTimer_mc;
		_local_4.static_bg.visible = false;
		_local_4.visible = true;
		_local_4.value_txt.autoSize = "left";
		var _local_5:TextField = (_local_4.value_txt as TextField);
		var _local_6:String = _arg_3.counterString;
		var _local_7:String = _arg_3.counterHeader;
		var _local_8:DisplayObject = _local_4.dynamic_bg;
		var _local_9:TextField = (_local_4.header_txt as TextField);
		_local_5.y = ((CommonUtils.getActiveTextLocaleIndex() == 11) ? 33 : 28);
		_local_9.htmlText = ((_local_7) ? _local_7 : "");
		_local_5.htmlText = _local_6;
		_local_5.x = COUNTDOWN_OBJ_HEADER_XPOS;
		_local_8.width = (5 + ((_local_6.length <= 1) ? this.m_widthCounterFieldSingleDigit : ((_local_6.length == 2) ? this.m_widthCounterFieldDoubleDigit : this.m_widthCounterFieldTripleDigit)));
		_local_5.x = (_local_5.x + (_local_9.textWidth + COUNTDOWN_OBJ_TEXT_GAP));
		_local_9.x = COUNTDOWN_OBJ_HEADER_XPOS;
		_local_8.width = (_local_8.width + (_local_9.textWidth + COUNTDOWN_OBJ_TEXT_GAP));
		var _local_10:Number = ((this.m_objectiveView.label_txt.numLines - 1) * 20);
		_local_4.y = (_local_10 - 30);
		_local_4.alpha = 0;
		Animate.to(_local_4, 0.3, 0.3, {
			"y": _local_10,
			"alpha": 1
		}, Animate.ExpoOut);
	}

	public function updateCounters(_arg_1:Array):void {
		var _local_2:Object;
		var _local_3:Object;
		var _local_4:Object;
		for each (_local_2 in _arg_1) {
			_local_3 = this.m_objectiveByCounterId[_local_2.id];
			if (_local_3 != null) {
				_local_4 = _local_3.counterData;
				if (!((!(_local_4 == null)) && (_local_4.counterString == _local_2.counterString))) {
					_local_3.counterData = _local_2;
					this.showObjective(_local_3);
				}

			}

		}

	}

	private function playSound(_arg_1:String):void {
		ExternalInterface.call("PlaySound", _arg_1);
	}


}
}//package hud

import flash.display.DisplayObject;

import common.TaskletSequencer;

import flash.text.TextField;

import common.Animate;


class ObjlikeQueue {

	/*private*/
	internal var m_queue:Vector.<QueueItem> = new Vector.<QueueItem>();
	/*private*/
	internal var m_idCurrentlyShown:String = null;
	/*private*/
	internal var m_containerCurrentlyShown:DisplayObject = null;


	public function push(id:String, prepare:Function, container:DisplayObject, icon_mc:DisplayObject, txt:TextField, dtLinger:Number):void {
		var item:QueueItem;
		var ts:TaskletSequencer;
		if (((this.m_idCurrentlyShown == null) || (this.m_idCurrentlyShown == id))) {
			this.m_idCurrentlyShown = id;
			this.m_containerCurrentlyShown = container;
			ts = TaskletSequencer.getGlobalInstance();
			ts.addChunk(prepare);
			ts.addChunk(function ():void {
				animateAppearance(container, icon_mc, txt, dtLinger);
			});
			return;
		}

		for each (item in this.m_queue) {
			if (item.id == id) {
				item.prepare = prepare;
				item.container = container;
				item.icon_mc = icon_mc;
				item.txt = txt;
				item.dtLinger = dtLinger;
				return;
			}

		}

		item = new QueueItem();
		item.id = id;
		item.prepare = prepare;
		item.container = container;
		item.icon_mc = icon_mc;
		item.txt = txt;
		item.dtLinger = dtLinger;
		this.m_queue.push(item);
	}

	/*private*/
	internal function animateAppearance(_arg_1:DisplayObject, _arg_2:DisplayObject, _arg_3:TextField, _arg_4:Number):void {
		_arg_1.alpha = 1;
		_arg_3.x = 0;
		_arg_3.alpha = 0;
		_arg_2.scaleX = 0;
		_arg_2.scaleY = 0;
		Animate.to(_arg_2, 0.3, 0, {
			"scaleX": 1,
			"scaleY": 1
		}, Animate.ExpoOut);
		Animate.to(_arg_3, 0.3, 0.2, {
			"x": 30,
			"alpha": 1
		}, Animate.ExpoOut);
		Animate.kill(_arg_1);
		Animate.delay(_arg_1, _arg_4, this.onComplete, _arg_1);
	}

	/*private*/
	internal function onComplete(containerJustFinished:DisplayObject):void {
		var item:QueueItem;
		var ts:TaskletSequencer;
		if (this.m_queue.length == 0) {
			Animate.to(containerJustFinished, 0.5, 0, {"alpha": 0}, Animate.Linear);
			this.m_idCurrentlyShown = null;
			this.m_containerCurrentlyShown = null;
		} else {
			containerJustFinished.alpha = 0;
			item = this.m_queue.shift();
			this.m_idCurrentlyShown = item.id;
			this.m_containerCurrentlyShown = item.container;
			ts = TaskletSequencer.getGlobalInstance();
			ts.addChunk(item.prepare);
			ts.addChunk(function ():void {
				animateAppearance(item.container, item.icon_mc, item.txt, item.dtLinger);
			});
		}

	}

	public function cancel(id:String):void {
		var i:int;
		var item:QueueItem;
		var ts:TaskletSequencer;
		if (id != this.m_idCurrentlyShown) {
			i = 0;
			while (i < this.m_queue.length) {
				if (this.m_queue[i].id == id) {
					this.m_queue.splice(i, 1);
					return;
				}

				i = (i + 1);
			}

		} else {
			Animate.kill(this.m_containerCurrentlyShown);
			this.m_containerCurrentlyShown.alpha = 0;
			this.m_idCurrentlyShown = null;
			this.m_containerCurrentlyShown = null;
			if (this.m_queue.length > 0) {
				item = this.m_queue.shift();
				this.m_idCurrentlyShown = item.id;
				this.m_containerCurrentlyShown = item.container;
				ts = TaskletSequencer.getGlobalInstance();
				ts.addChunk(item.prepare);
				ts.addChunk(function ():void {
					animateAppearance(item.container, item.icon_mc, item.txt, item.dtLinger);
				});
			}

		}

	}


}

class QueueItem {

	public var id:String;
	public var prepare:Function;
	public var container:DisplayObject;
	public var icon_mc:DisplayObject;
	public var txt:TextField;
	public var dtLinger:Number;


}


