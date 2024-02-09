package hud
{
	import basic.ButtonPromptImage;
	import common.Animate;
	import common.BaseControl;
	import common.CommonUtils;
	import common.Localization;
	import common.TaskletSequencer;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.external.ExternalInterface;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	import flash.utils.Dictionary;
	
	public class StatusMarkersVR extends BaseControl
	{
		
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
		
		private const m_lstrDeepTrespassing:String = Localization.get("EGAME_TEXT_SL_HOSTILEAREA").toUpperCase();
		
		private const m_lstrTrespassing:String = Localization.get("EGAME_TEXT_SL_TRESPASSING_ON").toUpperCase();
		
		private const m_lstrClear:String = Localization.get("EGAME_TEXT_SL_CLEAR").toUpperCase();
		
		private const m_lstrTimeRemaining:String = Localization.get("UI_BRIEFING_DIAL_TIME");
		
		private const m_lstrInfection:String = Localization.get("UI_HUD_INFECTION_IN_BODY");
		
		private const m_varsWitnessesNone:Object = {"x": 180, "alpha": 0};
		
		private const m_varsWitnessesSome:Object = {"x": 212, "alpha": 1};
		
		private var m_objlikeQueue:ObjlikeQueue;
		
		private var m_objectiveByCounterId:Dictionary;
		
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
		
		public function StatusMarkersVR()
		{
			var _loc3_:String = null;
			var _loc4_:MovieClip = null;
			this.m_objlikeQueue = new ObjlikeQueue();
			this.m_objectiveByCounterId = new Dictionary();
			super();
			var _loc1_:StatusMarkerView = new StatusMarkerView();
			this.m_trespassingIndicatorMc = _loc1_.trespassingIndicatorMc;
			this.m_tensionIndicatorMc = _loc1_.tensionIndicatorMc;
			addChild(this.m_tensionIndicatorMc);
			this.m_trespassingIndicatorHolder = new Sprite();
			this.m_trespassingIndicatorHolder.name = "m_trespassingIndicatorHolder";
			addChild(this.m_trespassingIndicatorHolder);
			this.m_trespassingIndicatorHolder.addChild(this.m_trespassingIndicatorMc);
			this.m_trespassingIndicatorMc.alpha = 0;
			this.m_tensionIndicatorMc.alpha = 0;
			var _loc2_:TextFormat = new TextFormat();
			_loc2_.leading = -3.5;
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
			this.m_tensionIndicatorMc.labelTxt.setTextFormat(_loc2_);
			MenuUtils.setupText(this.m_tensionIndicatorMc.unconMc.labelTxt, "", 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
			this.m_tensionIndicatorMc.bgMc.height = 23;
			this.m_tensionIndicatorMc.x = -105;
			this.m_tensionIndicatorMc.y = 0;
			for (_loc3_ in this.m_varsWitnessesNone)
			{
				this.m_tensionIndicatorMc.unconMc[_loc3_] = this.m_varsWitnessesNone[_loc3_];
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
			(_loc4_ = this.m_objectiveView.counterTimer_mc).header_txt.autoSize = "left";
			MenuUtils.setupText(_loc4_.header_txt, "", 12, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraDark);
			MenuUtils.setupText(_loc4_.value_txt, "", 24, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorGreyUltraDark);
			_loc4_.value_txt.text = "00:00";
			this.m_widthCounterFieldTimer = _loc4_.value_txt.textWidth;
			_loc4_.value_txt.text = "100%";
			this.m_widthCounterFieldPercent = _loc4_.value_txt.textWidth;
			_loc4_.value_txt.text = "0";
			this.m_widthCounterFieldSingleDigit = _loc4_.value_txt.textWidth;
			_loc4_.value_txt.text = "00";
			this.m_widthCounterFieldDoubleDigit = _loc4_.value_txt.textWidth;
			_loc4_.value_txt.text = "000";
			this.m_widthCounterFieldTripleDigit = _loc4_.value_txt.textWidth;
			_loc4_.value_txt.text = "";
			addChild(this.m_objectiveView);
		}
		
		public function set dtTimeoutTrespassingEnter(param1:Number):void
		{
			this.m_dtTimeoutTrespassingEnter = param1;
		}
		
		public function set dtTimeoutTrespassingClear(param1:Number):void
		{
			this.m_dtTimeoutTrespassingClear = param1;
		}
		
		public function set dtTimeoutTensionMessage(param1:Number):void
		{
			this.m_dtTimeoutTensionMessage = param1;
		}
		
		public function set dyGapBetweenStatusMessages(param1:Number):void
		{
			this.m_dyGapBetweenStatusMessages = param1;
		}
		
		public function set yObjlikeElements(param1:Number):void
		{
			this.m_yObjlikeElements = param1;
			this.m_oppNotification.y = param1;
			this.m_intelIndicator.y = param1;
			this.m_objectiveView.y = param1;
		}
		
		public function set widthOfObjlikeTextFields(param1:Number):void
		{
			this.m_oppNotification.desc_txt.width = param1;
			this.m_objectiveView.label_txt.width = param1;
		}
		
		public function setObjlikeEnabled(param1:Boolean):void
		{
			this.m_isObjlikeEnabled = param1;
		}
		
		public function onControlLayoutChanged():void
		{
			var _loc1_:String = null;
			var _loc2_:Boolean = false;
			var _loc5_:ButtonPromptImage = null;
			_loc1_ = ControlsMain.getControllerType();
			_loc2_ = CommonUtils.isPCVRControllerUsed(_loc1_);
			var _loc3_:String = _loc2_ ? "UI_HUD_INTEL_VIEW_INTEL_NOBUTTON" : "UI_HUD_INTEL_VIEW_INTEL";
			MenuUtils.setupText(this.m_intelIndicator.header_txt, Localization.get(_loc3_), 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			this.m_intelIndicator.x = -(this.m_intelIndicator.header_txt.x + this.m_intelIndicator.header_txt.textWidth) / 2;
			var _loc4_:TextLineMetrics = this.m_intelIndicator.header_txt.getLineMetrics(0);
			this.m_intelIndicator.header_txt.y = 16 - _loc4_.ascent;
			if (_loc2_ && this.m_intelNotebookActivationIcon == null)
			{
				this.m_intelNotebookActivationIcon = new Sprite();
				this.m_intelNotebookActivationIcon.name = "m_intelNotebookActivationIcon";
				this.m_intelNotebookActivationIcon_hold_mc = new InteractionIndicatorView().hold_mc;
				this.m_intelNotebookActivationIcon.addChild(this.m_intelNotebookActivationIcon_hold_mc);
				this.m_intelNotebookActivationIcon_hold_mc.gotoAndPlay(139);
				(_loc5_ = new ButtonPromptImage()).name = "promptimage";
				_loc5_.platform = _loc1_;
				_loc5_.button = 18;
				this.m_intelNotebookActivationIcon.addChild(_loc5_);
				this.m_intelIndicator.addChild(this.m_intelNotebookActivationIcon);
				this.m_intelNotebookActivationIcon.x = this.m_intelIndicator.header_txt.x + this.m_intelIndicator.header_txt.textWidth + 30;
				this.m_intelNotebookActivationIcon.y = this.m_intelIndicator.icon_mc.height / 2;
				this.m_intelNotebookActivationIcon.scaleX = 0.85;
				this.m_intelNotebookActivationIcon.scaleY = 0.85;
			}
			else if (!_loc2_ && this.m_intelNotebookActivationIcon != null)
			{
				this.m_intelIndicator.removeChild(this.m_intelNotebookActivationIcon);
				this.m_intelNotebookActivationIcon = null;
				this.m_intelNotebookActivationIcon_hold_mc = null;
			}
		}
		
		public function setIntelNotebookActivationProgress(param1:Number):void
		{
			if (this.m_intelNotebookActivationIcon_hold_mc != null)
			{
				this.m_intelNotebookActivationIcon_hold_mc.gotoAndStop(Math.ceil(param1 * 60));
			}
		}
		
		public function onSetData(param1:Object):void
		{
			var _loc3_:String = null;
			var _loc2_:int = this.m_state;
			this.m_state = !!param1.bDeepTrespassing ? STATE_DEEPTRESPASSING : (!!param1.bTrespassing ? STATE_TRESPASSING : STATE_CLEAR);
			if (this.m_state == _loc2_)
			{
				return;
			}
			if (this.m_state != STATE_CLEAR)
			{
				this.playSound(this.m_state == STATE_DEEPTRESPASSING ? "play_ui_deeptrespass_activate" : "play_ui_trespass_activate");
				MenuUtils.removeColor(this.m_trespassingIndicatorMc.bgMc);
				MenuUtils.removeColor(this.m_trespassingIndicatorMc.pulseMc);
				_loc3_ = this.m_state == STATE_DEEPTRESPASSING ? this.m_lstrDeepTrespassing : this.m_lstrTrespassing;
				MenuUtils.setupTextAndShrinkToFitUpper(this.m_trespassingIndicatorMc.labelTxt, _loc3_, 18, MenuConstants.FONT_TYPE_MEDIUM, 184, DISABLE_MIN_HEIGHT, MIN_FONT_SIZE, MenuConstants.FontColorGreyUltraDark);
				Animate.kill(this.m_trespassingIndicatorMc);
				this.m_trespassingIndicatorMc.alpha = 1;
				this.m_trespassingIndicatorMc.scaleY = 1;
				Animate.fromTo(this.m_trespassingIndicatorMc.pulseMc, 0.5, 0, {"alpha": 1, "scaleX": 1}, {"alpha": 0, "scaleX": 1.5}, Animate.ExpoOut, this.onTrespassingIndicatorPulseFinished, 0.5, this.m_dtTimeoutTrespassingEnter, {"alpha": 0}, this.updateStatusMarkerPositions);
			}
			else
			{
				this.playSound("play_ui_trespass_deactivate");
				Animate.kill(this.m_trespassingIndicatorMc.pulseMc);
				this.m_trespassingIndicatorMc.pulseMc.alpha = 0;
				this.m_trespassingIndicatorMc.pulseMc.scaleX = 1;
				Animate.to(this.m_trespassingIndicatorMc, 0.5, 0, {"alpha": 1}, Animate.Linear, this.onTrespassingIndicatorPulseClear);
			}
			this.updateStatusMarkerPositions();
		}
		
		private function onTrespassingIndicatorPulseClear():void
		{
			MenuUtils.setupTextAndShrinkToFitUpper(this.m_trespassingIndicatorMc.labelTxt, this.m_lstrClear, 18, MenuConstants.FONT_TYPE_MEDIUM, 184, DISABLE_MIN_HEIGHT, MIN_FONT_SIZE, MenuConstants.FontColorGreyUltraDark);
			MenuUtils.setColor(this.m_trespassingIndicatorMc.bgMc, MenuConstants.COLOR_GREEN, false);
			MenuUtils.setColor(this.m_trespassingIndicatorMc.pulseMc, MenuConstants.COLOR_GREEN, false);
			Animate.fromTo(this.m_trespassingIndicatorMc.pulseMc, 0.5, 0, {"alpha": 1, "scaleX": 1}, {"alpha": 0, "scaleX": 1.5}, Animate.ExpoOut, this.onTrespassingIndicatorPulseFinished, 0.1, this.m_dtTimeoutTrespassingClear, {"scaleY": 0}, this.setTrespassingIndicatorAlphaZero);
		}
		
		private function onTrespassingIndicatorPulseFinished(param1:Number, param2:Number, param3:Object, param4:Function = null):void
		{
			this.m_trespassingIndicatorMc.pulseMc.scaleX = 1;
			Animate.to(this.m_trespassingIndicatorMc, param1, param2, param3, Animate.Linear, param4);
		}
		
		private function setTrespassingIndicatorAlphaZero():void
		{
			this.m_trespassingIndicatorMc.alpha = 0;
			this.updateStatusMarkerPositions();
		}
		
		public function setTensionMessage(param1:String, param2:int, param3:int):void
		{
			if (param1 == "")
			{
				Animate.kill(this.m_tensionIndicatorMc.iconMc);
				Animate.kill(this.m_tensionIndicatorMc.labelTxt);
				Animate.kill(this.m_tensionIndicatorMc.unconMc);
				Animate.to(this.m_tensionIndicatorMc, 0.1, 0, {"alpha": 0}, Animate.Linear, this.updateStatusMarkerPositions);
			}
			else
			{
				if (param3 >= 1)
				{
					param2 = ICON_UNCONSCIOUSWITNESS;
				}
				this.m_tensionIndicatorMc.iconMc.gotoAndStop(param2 > 0 ? param2 : 1);
				this.m_tensionIndicatorMc.labelTxt.text = param1.toUpperCase();
				this.m_tensionIndicatorMc.bgMc.height = 23 + (this.m_tensionIndicatorMc.labelTxt.numLines - 1) * 19;
				Animate.kill(this.m_tensionIndicatorMc.iconMc);
				this.m_tensionIndicatorMc.iconMc.scaleX = 0;
				this.m_tensionIndicatorMc.iconMc.scaleY = 0;
				Animate.kill(this.m_tensionIndicatorMc.labelTxt);
				this.m_tensionIndicatorMc.labelTxt.alpha = 0;
				this.m_tensionIndicatorMc.labelTxt.x = 15;
				Animate.kill(this.m_tensionIndicatorMc.unconMc);
				this.m_tensionIndicatorMc.unconMc.alpha = this.m_varsWitnessesNone.alpha;
				this.m_tensionIndicatorMc.unconMc.x = this.m_varsWitnessesNone.x;
				Animate.fromTo(this.m_tensionIndicatorMc, 0.1, 0, {"alpha": 0}, {"alpha": 1}, Animate.Linear, this.onTensionBarAnimStep1, param3);
				this.m_tensionIndicatorMc.alpha = 0.011;
			}
			this.updateStatusMarkerPositions();
		}
		
		private function onTensionBarAnimStep1(param1:int):void
		{
			Animate.fromTo(this.m_tensionIndicatorMc.iconMc, 0.1, 0, {"scaleX": 0, "scaleY": 0}, {"scaleX": 1, "scaleY": 1}, Animate.Linear, this.onTensionBarAnimStep2, param1);
		}
		
		private function onTensionBarAnimStep2(param1:int):void
		{
			Animate.fromTo(this.m_tensionIndicatorMc.labelTxt, 0.1, 0, {"alpha": 0, "x": 15}, {"alpha": 1, "x": 21}, Animate.Linear, this.onTensionBarAnimStep3, param1);
		}
		
		private function onTensionBarAnimStep3(param1:int):void
		{
			var _loc2_:String = null;
			if (param1 >= 2)
			{
				_loc2_ = String(param1);
				this.m_tensionIndicatorMc.unconMc.labelTxt.text = _loc2_;
				this.m_tensionIndicatorMc.unconMc.bgMc.width = 29 + _loc2_.length * 12;
				this.m_tensionIndicatorMc.unconMc.bgMc.height = this.m_tensionIndicatorMc.bgMc.height;
				Animate.fromTo(this.m_tensionIndicatorMc.unconMc, 0.1, 0.1, this.m_varsWitnessesNone, this.m_varsWitnessesSome, Animate.Linear, this.onTensionBarAnimStepFinal);
			}
			else
			{
				this.onTensionBarAnimStepFinal();
			}
		}
		
		private function onTensionBarAnimStepFinal():void
		{
			Animate.addFromTo(this.m_tensionIndicatorMc, 0.5, this.m_dtTimeoutTensionMessage, {"alpha": 1}, {"alpha": 0}, Animate.Linear, this.updateStatusMarkerPositions);
		}
		
		private function updateStatusMarkerPositions():void
		{
			var _loc1_:* = false;
			_loc1_ = this.m_tensionIndicatorMc.alpha >= 0.01;
			var _loc2_:Number = _loc1_ ? this.m_tensionIndicatorMc.bgMc.height + this.m_dyGapBetweenStatusMessages : 0;
			var _loc3_:* = this.m_trespassingIndicatorMc.alpha >= 0.01;
			Animate.to(this.m_trespassingIndicatorHolder, _loc3_ ? 0.2 : 0, 0, {"y": _loc2_}, Animate.ExpoOut);
		}
		
		public function hiddenInCrowd(param1:Boolean):void
		{
			this.m_isHiddenInCrowd = param1;
			this.checkLVAState();
		}
		
		public function hiddenInVegetation(param1:Boolean):void
		{
			this.m_isHiddenInVegetation = param1;
			this.checkLVAState();
		}
		
		private function checkLVAState():void
		{
			var _loc1_:Boolean = this.m_isHidden;
			this.m_isHidden = this.m_isHiddenInCrowd || this.m_isHiddenInVegetation;
			if (this.m_isHidden != _loc1_)
			{
				this.playSound(this.m_isHidden ? "play_ui_crowd_blendin" : "play_ui_crowd_blendout");
			}
		}
		
		public function showIntel(param1:String, param2:Number):void
		{
			var prepare:Function;
			var dtLinger:Number;
			var sHeadline:String = param1;
			var showDuration:Number = param2;
			if (!this.m_isObjlikeEnabled)
			{
				return;
			}
			prepare = this.m_intelNotebookActivationIcon == null ? function():void
			{
			} : function():void
			{
				m_intelNotebookActivationIcon.alpha = 0;
				Animate.fromTo(m_intelNotebookActivationIcon, 0.3, 0.2, {"alpha": 0, "x": m_intelIndicator.header_txt.textWidth + 30}, {"alpha": 1, "x": m_intelIndicator.header_txt.textWidth + 30 + 30}, Animate.ExpoOut);
			};
			dtLinger = 1.6 + this.m_intelIndicator.header_txt.text.length / 12;
			this.m_objlikeQueue.push(OBJID_INTEL, prepare, this.m_intelIndicator, this.m_intelIndicator.icon_mc, this.m_intelIndicator.header_txt, dtLinger);
		}
		
		public function hideIntelIndicator():void
		{
			this.m_objlikeQueue.cancel(OBJID_INTEL);
		}
		
		public function showOpportunity(param1:String, param2:String, param3:Boolean):void
		{
			var prepare:Function;
			var dtLinger:Number;
			var sIcon:String = param1;
			var sTask:String = param2;
			var bNoDupes:Boolean = param3;
			if (bNoDupes && sIcon == this.m_oppLastIcon && sTask == this.m_oppLastTask)
			{
				return;
			}
			if (!this.m_isObjlikeEnabled)
			{
				return;
			}
			this.m_oppLastIcon = sIcon;
			this.m_oppLastTask = sTask;
			prepare = function():void
			{
				m_oppNotification.icon_mc.gotoAndStop(m_oppLastIcon);
				m_oppNotification.desc_txt.htmlText = m_oppLastTask;
				m_oppNotification.x = -(30 + m_oppNotification.desc_txt.textWidth) / 2;
			};
			dtLinger = 1.2 + sTask.length / 15;
			this.m_objlikeQueue.push(OBJID_OPPORTUNITY, prepare, this.m_oppNotification, this.m_oppNotification.icon_mc, this.m_oppNotification.desc_txt, dtLinger);
		}
		
		public function hideOpportunity():void
		{
			this.m_oppLastIcon = null;
			this.m_oppLastTask = null;
			this.m_objlikeQueue.cancel(OBJID_OPPORTUNITY);
		}
		
		public function showObjective(param1:Object):void
		{
			var prepare:Function;
			var dtLinger:Number;
			var objective:Object = param1;
			if (!this.m_isObjlikeEnabled)
			{
				return;
			}
			prepare = function():void
			{
				var ts:TaskletSequencer = TaskletSequencer.getGlobalInstance();
				ts.addChunk(function():void
				{
					m_objectiveView.label_txt.htmlText = objective.objTitle.toUpperCase();
					if (!objective.objSuccess && !objective.objFail)
					{
						m_objectiveView.iconAnim_mc.icon_mc.gotoAndStop(1);
						m_objectiveView.iconAnim_mc.icon_mc.type_mc.gotoAndStop(objective.objType + 1);
					}
					else
					{
						m_objectiveView.iconAnim_mc.icon_mc.gotoAndStop(Boolean(objective.objSuccess) && !objective.objFail ? 3 : (!objective.objSuccess && Boolean(objective.objFail) ? 2 : 4));
						m_objectiveView.iconAnim_mc.icon_mc.getChildAt(0).alpha = 1;
					}
					m_objectiveView.x = -(30 + m_objectiveView.label_txt.textWidth) / 2;
				});
				ts.addChunk(function():void
				{
					if (objective.timerData)
					{
						initialiseObjectiveTimer(objective.objTitle, objective.timerData);
					}
					else if (objective.percentCounterData)
					{
						initialiseObjectivePercentCounter(objective.objTitle, objective.percentCounterData);
					}
					else if (objective.counterData)
					{
						initialiseObjectiveCounter(objective.objTitle, objective.objType, objective.counterData);
						m_objectiveByCounterId[objective.counterData.id] = objective;
					}
					else
					{
						m_objectiveView.counterTimer_mc.visible = false;
					}
				});
			};
			dtLinger = 1.8 + objective.objTitle.length / 55;
			this.m_objlikeQueue.push(objective.id, prepare, this.m_objectiveView, this.m_objectiveView.iconAnim_mc, this.m_objectiveView.label_txt, dtLinger);
		}
		
		private function initialiseObjectiveTimer(param1:String, param2:Object):void
		{
			this.m_objectiveView.iconAnim_mc.icon_mc.gotoAndStop(1);
			this.m_objectiveView.iconAnim_mc.icon_mc.type_mc.gotoAndStop(4);
			var _loc3_:MovieClip = this.m_objectiveView.counterTimer_mc;
			_loc3_.static_bg.visible = false;
			_loc3_.visible = true;
			_loc3_.value_txt.autoSize = "left";
			_loc3_.value_txt.y = CommonUtils.getActiveTextLocaleIndex() == 11 ? 33 : 28;
			_loc3_.header_txt.htmlText = this.m_lstrTimeRemaining;
			_loc3_.value_txt.htmlText = param2.timerString;
			_loc3_.value_txt.x = _loc3_.header_txt.textWidth + COUNTDOWN_OBJ_TEXT_GAP + COUNTDOWN_OBJ_HEADER_XPOS;
			_loc3_.dynamic_bg.width = _loc3_.header_txt.textWidth + COUNTDOWN_OBJ_TEXT_GAP + this.m_widthCounterFieldTimer + 3;
			var _loc4_:Number = (this.m_objectiveView.label_txt.numLines - 1) * 20;
			_loc3_.y = _loc4_ - 30;
			_loc3_.alpha = 0;
			Animate.to(_loc3_, 0.3, 0.3, {"y": _loc4_, "alpha": 1}, Animate.ExpoOut);
		}
		
		private function initialiseObjectivePercentCounter(param1:String, param2:Object):void
		{
			this.m_objectiveView.iconAnim_mc.icon_mc.gotoAndStop(1);
			this.m_objectiveView.iconAnim_mc.icon_mc.type_mc.gotoAndStop(20);
			var _loc3_:MovieClip = this.m_objectiveView.counterTimer_mc;
			_loc3_.static_bg.visible = true;
			_loc3_.visible = true;
			_loc3_.value_txt.autoSize = "right";
			_loc3_.value_txt.y = CommonUtils.getActiveTextLocaleIndex() == 11 ? 33 : 28;
			_loc3_.header_txt.htmlText = this.m_lstrInfection;
			_loc3_.value_txt.text = String(param2.percent) + "%";
			_loc3_.value_txt.x = COUNTDOWN_OBJ_HEADER_XPOS + PERCENTAGE_BG_INIT_WIDTH + 3 - COUNTDOWN_OBJ_TEXT_GAP - this.m_widthCounterFieldPercent;
			_loc3_.dynamic_bg.width = PERCENTAGE_BG_INIT_WIDTH;
			_loc3_.static_bg.width = PERCENTAGE_BG_INIT_WIDTH;
			_loc3_.static_bg.alpha = 0.5;
			var _loc4_:Number = (this.m_objectiveView.label_txt.numLines - 1) * 20;
			_loc3_.y = _loc4_ - 30;
			_loc3_.alpha = 0;
			Animate.to(_loc3_, 0.3, 0.3, {"y": _loc4_, "alpha": 1}, Animate.ExpoOut);
		}
		
		private function initialiseObjectiveCounter(param1:String, param2:Number, param3:Object):void
		{
			this.m_objectiveView.iconAnim_mc.icon_mc.gotoAndStop(1);
			this.m_objectiveView.iconAnim_mc.icon_mc.type_mc.gotoAndStop(param2 + 1);
			var _loc4_:MovieClip;
			(_loc4_ = this.m_objectiveView.counterTimer_mc).static_bg.visible = false;
			_loc4_.visible = true;
			_loc4_.value_txt.autoSize = "left";
			var _loc5_:TextField = _loc4_.value_txt as TextField;
			var _loc6_:String = String(param3.counterString);
			var _loc7_:String = String(param3.counterHeader);
			var _loc8_:DisplayObject = _loc4_.dynamic_bg;
			var _loc9_:TextField = _loc4_.header_txt as TextField;
			_loc5_.y = CommonUtils.getActiveTextLocaleIndex() == 11 ? 33 : 28;
			_loc9_.htmlText = !!_loc7_ ? _loc7_ : "";
			_loc5_.htmlText = _loc6_;
			_loc5_.x = COUNTDOWN_OBJ_HEADER_XPOS;
			_loc8_.width = 5 + (_loc6_.length <= 1 ? this.m_widthCounterFieldSingleDigit : (_loc6_.length == 2 ? this.m_widthCounterFieldDoubleDigit : this.m_widthCounterFieldTripleDigit));
			_loc5_.x += _loc9_.textWidth + COUNTDOWN_OBJ_TEXT_GAP;
			_loc9_.x = COUNTDOWN_OBJ_HEADER_XPOS;
			_loc8_.width += _loc9_.textWidth + COUNTDOWN_OBJ_TEXT_GAP;
			var _loc10_:Number = (this.m_objectiveView.label_txt.numLines - 1) * 20;
			_loc4_.y = _loc10_ - 30;
			_loc4_.alpha = 0;
			Animate.to(_loc4_, 0.3, 0.3, {"y": _loc10_, "alpha": 1}, Animate.ExpoOut);
		}
		
		public function updateCounters(param1:Array):void
		{
			var _loc2_:Object = null;
			var _loc3_:Object = null;
			var _loc4_:Object = null;
			for each (_loc2_ in param1)
			{
				_loc3_ = this.m_objectiveByCounterId[_loc2_.id];
				if (_loc3_ != null)
				{
					if (!((_loc4_ = _loc3_.counterData) != null && _loc4_.counterString == _loc2_.counterString))
					{
						_loc3_.counterData = _loc2_;
						this.showObjective(_loc3_);
					}
				}
			}
		}
		
		private function playSound(param1:String):void
		{
			ExternalInterface.call("PlaySound", param1);
		}
	}
}

import common.Animate;
import common.TaskletSequencer;
import flash.display.DisplayObject;
import flash.text.TextField;

class ObjlikeQueue
{
	
	private var m_queue:Vector.<QueueItem>;
	
	private var m_idCurrentlyShown:String = null;
	
	private var m_containerCurrentlyShown:DisplayObject = null;
	
	public function ObjlikeQueue()
	{
		this.m_queue = new Vector.<QueueItem>();
		super();
	}
	
	public function push(param1:String, param2:Function, param3:DisplayObject, param4:DisplayObject, param5:TextField, param6:Number):void
	{
		var item:QueueItem = null;
		var ts:TaskletSequencer = null;
		var id:String = param1;
		var prepare:Function = param2;
		var container:DisplayObject = param3;
		var icon_mc:DisplayObject = param4;
		var txt:TextField = param5;
		var dtLinger:Number = param6;
		if (this.m_idCurrentlyShown == null || this.m_idCurrentlyShown == id)
		{
			this.m_idCurrentlyShown = id;
			this.m_containerCurrentlyShown = container;
			ts = TaskletSequencer.getGlobalInstance();
			ts.addChunk(prepare);
			ts.addChunk(function():void
			{
				animateAppearance(container, icon_mc, txt, dtLinger);
			});
			return;
		}
		for each (item in this.m_queue)
		{
			if (item.id == id)
			{
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
	
	private function animateAppearance(param1:DisplayObject, param2:DisplayObject, param3:TextField, param4:Number):void
	{
		param1.alpha = 1;
		param3.x = 0;
		param3.alpha = 0;
		param2.scaleX = 0;
		param2.scaleY = 0;
		Animate.to(param2, 0.3, 0, {"scaleX": 1, "scaleY": 1}, Animate.ExpoOut);
		Animate.to(param3, 0.3, 0.2, {"x": 30, "alpha": 1}, Animate.ExpoOut);
		Animate.kill(param1);
		Animate.delay(param1, param4, this.onComplete, param1);
	}
	
	private function onComplete(param1:DisplayObject):void
	{
		var item:QueueItem = null;
		var ts:TaskletSequencer = null;
		var containerJustFinished:DisplayObject = param1;
		if (this.m_queue.length == 0)
		{
			Animate.to(containerJustFinished, 0.5, 0, {"alpha": 0}, Animate.Linear);
			this.m_idCurrentlyShown = null;
			this.m_containerCurrentlyShown = null;
		}
		else
		{
			containerJustFinished.alpha = 0;
			item = this.m_queue.shift();
			this.m_idCurrentlyShown = item.id;
			this.m_containerCurrentlyShown = item.container;
			ts = TaskletSequencer.getGlobalInstance();
			ts.addChunk(item.prepare);
			ts.addChunk(function():void
			{
				animateAppearance(item.container, item.icon_mc, item.txt, item.dtLinger);
			});
		}
	}
	
	public function cancel(param1:String):void
	{
		var i:int = 0;
		var item:QueueItem = null;
		var ts:TaskletSequencer = null;
		var id:String = param1;
		if (id != this.m_idCurrentlyShown)
		{
			i = 0;
			while (i < this.m_queue.length)
			{
				if (this.m_queue[i].id == id)
				{
					this.m_queue.splice(i, 1);
					return;
				}
				i++;
			}
		}
		else
		{
			Animate.kill(this.m_containerCurrentlyShown);
			this.m_containerCurrentlyShown.alpha = 0;
			this.m_idCurrentlyShown = null;
			this.m_containerCurrentlyShown = null;
			if (this.m_queue.length > 0)
			{
				item = this.m_queue.shift();
				this.m_idCurrentlyShown = item.id;
				this.m_containerCurrentlyShown = item.container;
				ts = TaskletSequencer.getGlobalInstance();
				ts.addChunk(item.prepare);
				ts.addChunk(function():void
				{
					animateAppearance(item.container, item.icon_mc, item.txt, item.dtLinger);
				});
			}
		}
	}
}

import flash.display.DisplayObject;
import flash.text.TextField;

class QueueItem
{
	
	public var id:String;
	
	public var prepare:Function;
	
	public var container:DisplayObject;
	
	public var icon_mc:DisplayObject;
	
	public var txt:TextField;
	
	public var dtLinger:Number;
	
	public function QueueItem()
	{
		super();
	}
}
