// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.OptionsInfoLowerLeftPreview

package menu3.basic {
import hud.maptrackers.NorthIndicatorMapTracker;
import hud.maptrackers.NpcMapTracker;

import __AS3__.vec.Vector;

import flash.display.Shape;

import hud.StatusMarkers;
import hud.AIinformation;
import hud.DifficultyIcon;
import hud.SilentAssassinIcon;
import hud.evergreen.VitalInfoBar;

import common.Localization;

import flash.display.DisplayObject;

import hud.maptrackers.PlayerHeroMapTracker;

import flash.events.Event;

import common.CommonUtils;

import flash.utils.setTimeout;

import __AS3__.vec.*;

import flash.utils.*;

public dynamic class OptionsInfoLowerLeftPreview extends OptionsInfoSlideshowPreview {

	private static const UIOPTION_MINIMAP_SHOWTARGETS_OFF:Number = 0;
	private static const UIOPTION_MINIMAP_SHOWTARGETS_MINIMAL:Number = 1;
	private static const UIOPTION_MINIMAP_SHOWTARGETS_ON:Number = 2;

	private var m_degMinimapRotationMin:Number;
	private var m_degMinimapRotationMax:Number;

	private var m_minimapNorthMarker:NorthIndicatorMapTracker = new NorthIndicatorMapTracker();
	private var m_minimapTargetMarker1:NpcMapTracker = new NpcMapTracker();
	private var m_minimapTargetMarker2:NpcMapTracker = new NpcMapTracker();
	private var m_minimapNpcMarkers:Vector.<NpcMapTracker> = new Vector.<NpcMapTracker>(0);
	private var m_minimapPseudoView:MinimapPseudoView = new MinimapPseudoView();
	private var m_minimapMask:Shape = new Shape();
	private var m_statusMarkers:StatusMarkers = new StatusMarkers();
	private var m_aiInformation:AIinformation = new AIinformation();
	private var m_difficultyIcon:DifficultyIcon = new DifficultyIcon();
	private var m_silentAssassinIcon:SilentAssassinIcon = new SilentAssassinIcon();
	private var m_evergreenVitalInfoBar:VitalInfoBar = new VitalInfoBar();
	private const m_lstrAiInformationSample:String = Localization.get("EGAME_TEXT_SL_GUNSHOTHEARD");

	public function OptionsInfoLowerLeftPreview(data:Object) {
		var tracker:DisplayObject;
		var heroMapTracker:PlayerHeroMapTracker;
		var createNpcMapTracker:Function;
		this.m_evergreenVitalInfoBar.textShowDuration = 1.5;
		this.m_evergreenVitalInfoBar.animationFlags = VitalInfoBar.ANIMFLAG_POSITIONS_NO_SLIDE;
		super(data);
		this.m_minimapPseudoView.name = "m_minimapPseudoView";
		getPreviewContentContainer().addChild(this.m_minimapPseudoView);
		this.m_minimapNorthMarker.name = "m_minimapNorthMarker";
		this.m_minimapTargetMarker2.name = "m_minimapTargetMarker2";
		this.m_minimapTargetMarker1.name = "m_minimapTargetMarker1";
		for each (tracker in [this.m_minimapNorthMarker, this.m_minimapTargetMarker1, this.m_minimapTargetMarker2]) {
			tracker.scaleX = (tracker.scaleY = 0.35);
			getPreviewContentContainer().addChild(tracker);
		}

		heroMapTracker = new PlayerHeroMapTracker();
		heroMapTracker.name = "heroMapTracker";
		heroMapTracker.scaleX = (heroMapTracker.scaleY = 0.45);
		heroMapTracker.rotation = 163;
		this.m_minimapPseudoView.addChild(heroMapTracker);
		createNpcMapTracker = function (_arg_1:Number, _arg_2:Number, _arg_3:Boolean):void {
			var _local_4:NpcMapTracker = new NpcMapTracker();
			_local_4.x = _arg_1;
			_local_4.y = _arg_2;
			_local_4.scaleX = (_local_4.scaleY = 0.35);
			_local_4.onSetData({
				"isTarget": false,
				"threatLevel": ((_arg_3) ? 1 : 0)
			});
			m_minimapPseudoView.addChild(_local_4);
			m_minimapNpcMarkers.push(_local_4);
		};
		(createNpcMapTracker(58, -72, true));
		(createNpcMapTracker(62, 22, false));
		(createNpcMapTracker(81, -5, false));
		(createNpcMapTracker(-69, -54, false));
		(createNpcMapTracker(-49, -51, true));
		(createNpcMapTracker(-67, 59, true));
		(createNpcMapTracker(-84, 52, true));
		this.m_minimapMask.name = "m_minimapMask";
		this.m_minimapMask.graphics.beginFill(0);
		this.m_minimapMask.graphics.drawRect(-105, -105, 210, 210);
		getPreviewContentContainer().addChild(this.m_minimapMask);
		this.m_minimapPseudoView.mask = this.m_minimapMask;
		this.m_statusMarkers.name = "m_statusMarkers";
		this.m_statusMarkers.tensionIndicatorMc.visible = false;
		getPreviewContentContainer().addChild(this.m_statusMarkers);
		this.m_aiInformation.name = "m_aiInformation";
		getPreviewContentContainer().addChild(this.m_aiInformation);
		this.m_difficultyIcon.name = "m_difficultyIcon";
		this.m_difficultyIcon.scaleX = (this.m_difficultyIcon.scaleY = 0.65);
		getPreviewContentContainer().addChild(this.m_difficultyIcon);
		this.m_silentAssassinIcon.name = "m_silentAssassinIcon";
		this.m_silentAssassinIcon.scaleX = (this.m_silentAssassinIcon.scaleY = 0.65);
		getPreviewContentContainer().addChild(this.m_silentAssassinIcon);
		this.m_evergreenVitalInfoBar.name = "m_evergreenVitalInfoBar";
		this.m_evergreenVitalInfoBar.scaleX = (this.m_evergreenVitalInfoBar.scaleY = 1);
		getPreviewContentContainer().addChild(this.m_evergreenVitalInfoBar);
		addEventListener(Event.ENTER_FRAME, this.updateMinimapRotation);
		this.onSetData(data);
		this.m_evergreenVitalInfoBar.animationFlags = (this.m_evergreenVitalInfoBar.animationFlags & (~(VitalInfoBar.ANIMFLAG_POSITIONS_NO_SLIDE)));
	}

	override public function onSetData(data:Object):void {
		var/*const*/ pxBGWidth:Number = NaN;
		var/*const*/ pxBGHeight:Number = NaN;
		var flags:uint;
		var tracker:NpcMapTracker;
		super.onSetData(data);
		pxBGWidth = OptionsInfoPreview.PX_PREVIEW_BACKGROUND_WIDTH;
		pxBGHeight = ((pxBGWidth / 1920) * 1080);
		var/*const*/ xMinimapCenter:Number = 145;
		var/*const*/ yMinimapCenter:Number = (pxBGHeight - 135);
		var showNpcs:Boolean = ((data.previewData) && (data.previewData.showNpcs));
		var isEvergreenMode:Boolean = ((data.previewData) && (data.previewData.isEvergreenMode));
		var isMinimapEnabled:Number = CommonUtils.getUIOptionValueNumber("UI_OPTION_GAME_AID_MINI_MAP");
		var nMinimapShowTargets:Number = CommonUtils.getUIOptionValueNumber("UI_OPTION_GAME_MINI_MAP_SHOW_TARGETS");
		var isMinimapNpcsEnabled:Boolean = CommonUtils.getUIOptionValue("UI_OPTION_GAME_MINI_MAP_SHOW_NPCS");
		var isMinimapFixed:Boolean = CommonUtils.getUIOptionValue("UI_OPTION_GAME_FIXED_MAP");
		var isMinimapNorthEnabled:Boolean = CommonUtils.getUIOptionValue("UI_OPTION_GAME_MAP_SHOW_NORTH_INDICATOR");
		var isDiffIconEnabled:Boolean = CommonUtils.getUIOptionValue("UI_OPTION_GAME_DIFFICULTY_LEVEL_HUD");
		var isSAIconEnabled:Boolean = CommonUtils.getUIOptionValue("UI_OPTION_GAME_AID_SA_HUD");
		var isEvergreenAlertedTerritoryEnabled:Boolean = CommonUtils.getUIOptionValue("UI_OPTION_GAME_FREELANCER_ALERTED_TERRITORY");
		var isEvergreenAssassinProximityEnabled:Boolean = CommonUtils.getUIOptionValue("UI_OPTION_GAME_FREELANCER_ASSASSIN_PROXIMITY");
		var isEvergreenLookoutProximityEnabled:Boolean = CommonUtils.getUIOptionValue("UI_OPTION_GAME_FREELANCER_LOOKOUT_PROXIMITY");
		this.m_difficultyIcon.visible = ((!(isEvergreenMode)) && (isDiffIconEnabled));
		this.m_silentAssassinIcon.visible = ((!(isEvergreenMode)) && (isSAIconEnabled));
		this.m_difficultyIcon.y = ((yMinimapCenter + 105) - (this.m_difficultyIcon.height / 2));
		this.m_silentAssassinIcon.y = ((this.m_difficultyIcon.y - this.m_silentAssassinIcon.height) - 5);
		this.m_evergreenVitalInfoBar.y = ((yMinimapCenter + 105) - 24);
		if (isEvergreenMode) {
			flags = (((this.m_evergreenVitalInfoBar.animationFlags | VitalInfoBar.ANIMFLAG_TERRITORY_LABEL_NO_FLASH) | VitalInfoBar.ANIMFLAG_ASSASSIN_LABEL_NO_FLASH) | VitalInfoBar.ANIMFLAG_LOOKOUT_LABEL_NO_FLASH);
			switch (data.previewData.animateEvergreenBar) {
				case "territory":
					flags = (flags & (~(VitalInfoBar.ANIMFLAG_TERRITORY_LABEL_NO_FLASH)));
					break;
				case "assassin":
					flags = (flags & (~(VitalInfoBar.ANIMFLAG_ASSASSIN_LABEL_NO_FLASH)));
					break;
				case "lookout":
					flags = (flags & (~(VitalInfoBar.ANIMFLAG_LOOKOUT_LABEL_NO_FLASH)));
					break;
			}

			this.m_evergreenVitalInfoBar.animationFlags = flags;
			this.m_evergreenVitalInfoBar.onSetData({
				"isAssassinNearby": isEvergreenAssassinProximityEnabled,
				"isAssassinAlerted": false,
				"isLookoutNearby": isEvergreenLookoutProximityEnabled,
				"isLookoutAlerted": false,
				"isAllertedTerritory": isEvergreenAlertedTerritoryEnabled,
				"isPrestigeObjectiveActive": false
			});
		}

		if (isMinimapFixed) {
			this.m_degMinimapRotationMin = 0;
			this.m_degMinimapRotationMax = 0;
		} else {
			this.m_degMinimapRotationMin = (((!(data.previewData)) || (data.previewData.degMinimapRotationMin == null)) ? 155 : data.previewData.degMinimapRotationMin);
			this.m_degMinimapRotationMax = (((!(data.previewData)) || (data.previewData.degMinimapRotationMax == null)) ? 155 : data.previewData.degMinimapRotationMax);
		}

		if (!isMinimapEnabled) {
			this.m_minimapPseudoView.visible = false;
			this.m_statusMarkers.visible = false;
			this.m_minimapTargetMarker1.visible = false;
			this.m_minimapTargetMarker2.visible = false;
			this.m_minimapNorthMarker.visible = false;
			this.m_difficultyIcon.x = (((xMinimapCenter - 105) + (this.m_difficultyIcon.width / 2)) + 5);
			this.m_silentAssassinIcon.x = (((xMinimapCenter - 105) + (this.m_silentAssassinIcon.width / 2)) + 5);
			this.m_evergreenVitalInfoBar.x = ((xMinimapCenter - 105) + 10);
		} else {
			this.m_minimapPseudoView.visible = true;
			this.m_statusMarkers.visible = true;
			this.m_difficultyIcon.x = (((xMinimapCenter + 105) + (this.m_difficultyIcon.width / 2)) + 5);
			this.m_silentAssassinIcon.x = (((xMinimapCenter + 105) + (this.m_silentAssassinIcon.width / 2)) + 5);
			this.m_evergreenVitalInfoBar.x = ((xMinimapCenter + 105) + 10);
			this.m_minimapNorthMarker.visible = isMinimapNorthEnabled;
			this.m_minimapPseudoView.x = xMinimapCenter;
			this.m_minimapPseudoView.y = yMinimapCenter;
			this.m_minimapMask.x = xMinimapCenter;
			this.m_minimapMask.y = yMinimapCenter;
			this.m_statusMarkers.x = xMinimapCenter;
			this.m_statusMarkers.y = yMinimapCenter;
			for each (tracker in this.m_minimapNpcMarkers) {
				tracker.visible = ((showNpcs) && (isMinimapNpcsEnabled));
			}

			if (((!(showNpcs)) || (nMinimapShowTargets == UIOPTION_MINIMAP_SHOWTARGETS_OFF))) {
				this.m_minimapTargetMarker1.visible = false;
				this.m_minimapTargetMarker2.visible = false;
			} else {
				this.m_minimapTargetMarker1.visible = true;
				this.m_minimapTargetMarker2.visible = true;
				this.m_minimapTargetMarker1.onSetData({
					"isTarget": (nMinimapShowTargets == UIOPTION_MINIMAP_SHOWTARGETS_ON),
					"threatLevel": 0,
					"levelCheckResult": 0
				});
				this.m_minimapTargetMarker2.onSetData({
					"isTarget": (nMinimapShowTargets == UIOPTION_MINIMAP_SHOWTARGETS_ON),
					"threatLevel": 0,
					"levelCheckResult": 0
				});
			}

		}

		if (((!(data.previewData)) || (!(data.previewData.showVitalInfo)))) {
			this.m_aiInformation.visible = false;
		} else {
			this.m_aiInformation.x = (xMinimapCenter - (210 / 2));
			this.m_aiInformation.y = ((yMinimapCenter - (210 / 2)) - 55);
			setTimeout(function ():void {
				m_aiInformation.visible = true;
				m_aiInformation.showAIinformation(m_lstrAiInformationSample);
			}, 250);
		}

		this.updateMinimapRotation();
	}

	private function updateMinimapRotation():void {
		var _local_2:Number;
		var _local_3:Number;
		var _local_1:Number = this.m_degMinimapRotationMax;
		if (((!(this.m_degMinimapRotationMax == this.m_degMinimapRotationMin)) && (nFrames > 1))) {
			_local_2 = (Number(iCurrentFrame) / Number((nFrames - 1)));
			_local_3 = (0.5 - (0.5 * Math.cos((Math.PI * _local_2))));
			_local_1 = (this.m_degMinimapRotationMin + (_local_3 * (this.m_degMinimapRotationMax - this.m_degMinimapRotationMin)));
		}

		this.m_minimapPseudoView.rotation = _local_1;
		this.projectToMinimapEdge(this.m_minimapNorthMarker, 270);
		this.projectToMinimapEdge(this.m_minimapTargetMarker1, 115);
		this.projectToMinimapEdge(this.m_minimapTargetMarker2, 62);
	}

	private function projectToMinimapEdge(_arg_1:DisplayObject, _arg_2:Number):void {
		var _local_7:Number;
		var _local_3:Number = this.m_minimapPseudoView.x;
		var _local_4:Number = this.m_minimapPseudoView.y;
		var _local_5:Number = 210;
		var _local_6:Number = (_arg_2 + this.m_minimapPseudoView.rotation);
		while (_local_6 < 0) {
			_local_6 = (_local_6 + 360);
		}

		while (_local_6 > 360) {
			_local_6 = (_local_6 - 360);
		}

		if (((_local_6 >= 45) && (_local_6 < 135))) {
			_local_7 = (((_local_6 - 90) * Math.PI) / 180);
			_arg_1.y = ((_local_4 + (_local_5 / 2)) - (_arg_1.height / 2));
			_arg_1.x = (_local_3 - (((_local_5 / 2) - (_arg_1.width / 2)) * Math.tan(_local_7)));
		} else {
			if (((_local_6 >= 135) && (_local_6 < 225))) {
				_local_7 = (((_local_6 - 180) * Math.PI) / 180);
				_arg_1.x = ((_local_3 - (_local_5 / 2)) + (_arg_1.width / 2));
				_arg_1.y = (_local_4 - (((_local_5 / 2) - (_arg_1.height / 2)) * Math.tan(_local_7)));
			} else {
				if (((_local_6 >= 225) && (_local_6 < 315))) {
					_local_7 = (((_local_6 - 270) * Math.PI) / 180);
					_arg_1.y = ((_local_4 - (_local_5 / 2)) + (_arg_1.height / 2));
					_arg_1.x = (_local_3 + (((_local_5 / 2) - (_arg_1.width / 2)) * Math.tan(_local_7)));
				} else {
					_local_7 = (((_local_6 - 0) * Math.PI) / 180);
					_arg_1.x = ((_local_3 + (_local_5 / 2)) - (_arg_1.width / 2));
					_arg_1.y = (_local_4 + (((_local_5 / 2) - (_arg_1.height / 2)) * Math.tan(_local_7)));
				}

			}

		}

	}

	override protected function onPreviewRemovedFromStage():void {
		removeEventListener(Event.ENTER_FRAME, this.updateMinimapRotation);
		super.onPreviewRemovedFromStage();
	}


}
}//package menu3.basic

