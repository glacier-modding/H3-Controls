package menu3.basic
{
	import common.CommonUtils;
	import common.Localization;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.*;
	import hud.AIinformation;
	import hud.DifficultyIcon;
	import hud.SilentAssassinIcon;
	import hud.StatusMarkers;
	import hud.evergreen.VitalInfoBar;
	import hud.maptrackers.NorthIndicatorMapTracker;
	import hud.maptrackers.NpcMapTracker;
	import hud.maptrackers.PlayerHeroMapTracker;
	
	public dynamic class OptionsInfoLowerLeftPreview extends OptionsInfoSlideshowPreview
	{
		
		private static const UIOPTION_MINIMAP_SHOWTARGETS_OFF:Number = 0;
		
		private static const UIOPTION_MINIMAP_SHOWTARGETS_MINIMAL:Number = 1;
		
		private static const UIOPTION_MINIMAP_SHOWTARGETS_ON:Number = 2;
		
		private var m_minimapNorthMarker:NorthIndicatorMapTracker;
		
		private var m_minimapTargetMarker1:NpcMapTracker;
		
		private var m_minimapTargetMarker2:NpcMapTracker;
		
		private var m_minimapNpcMarkers:Vector.<NpcMapTracker>;
		
		private var m_minimapPseudoView:MinimapPseudoView;
		
		private var m_minimapMask:Shape;
		
		private var m_statusMarkers:StatusMarkers;
		
		private var m_aiInformation:AIinformation;
		
		private var m_difficultyIcon:DifficultyIcon;
		
		private var m_silentAssassinIcon:SilentAssassinIcon;
		
		private var m_evergreenVitalInfoBar:VitalInfoBar;
		
		private var m_degMinimapRotationMin:Number;
		
		private var m_degMinimapRotationMax:Number;
		
		private const m_lstrAiInformationSample:String = Localization.get("EGAME_TEXT_SL_GUNSHOTHEARD");
		
		public function OptionsInfoLowerLeftPreview(param1:Object)
		{
			var tracker:DisplayObject = null;
			var heroMapTracker:PlayerHeroMapTracker = null;
			var createNpcMapTracker:Function = null;
			var data:Object = param1;
			this.m_minimapNorthMarker = new NorthIndicatorMapTracker();
			this.m_minimapTargetMarker1 = new NpcMapTracker();
			this.m_minimapTargetMarker2 = new NpcMapTracker();
			this.m_minimapNpcMarkers = new Vector.<NpcMapTracker>(0);
			this.m_minimapPseudoView = new MinimapPseudoView();
			this.m_minimapMask = new Shape();
			this.m_statusMarkers = new StatusMarkers();
			this.m_aiInformation = new AIinformation();
			this.m_difficultyIcon = new DifficultyIcon();
			this.m_silentAssassinIcon = new SilentAssassinIcon();
			this.m_evergreenVitalInfoBar = new VitalInfoBar();
			this.m_evergreenVitalInfoBar.textShowDuration = 1.5;
			this.m_evergreenVitalInfoBar.animationFlags = VitalInfoBar.ANIMFLAG_POSITIONS_NO_SLIDE;
			super(data);
			this.m_minimapPseudoView.name = "m_minimapPseudoView";
			getPreviewContentContainer().addChild(this.m_minimapPseudoView);
			this.m_minimapNorthMarker.name = "m_minimapNorthMarker";
			this.m_minimapTargetMarker2.name = "m_minimapTargetMarker2";
			this.m_minimapTargetMarker1.name = "m_minimapTargetMarker1";
			for each (tracker in[this.m_minimapNorthMarker, this.m_minimapTargetMarker1, this.m_minimapTargetMarker2])
			{
				tracker.scaleX = tracker.scaleY = 0.35;
				getPreviewContentContainer().addChild(tracker);
			}
			heroMapTracker = new PlayerHeroMapTracker();
			heroMapTracker.name = "heroMapTracker";
			heroMapTracker.scaleX = heroMapTracker.scaleY = 0.45;
			heroMapTracker.rotation = 163;
			this.m_minimapPseudoView.addChild(heroMapTracker);
			createNpcMapTracker = function(param1:Number, param2:Number, param3:Boolean):void
			{
				var _loc4_:NpcMapTracker;
				(_loc4_ = new NpcMapTracker()).x = param1;
				_loc4_.y = param2;
				_loc4_.scaleX = _loc4_.scaleY = 0.35;
				_loc4_.onSetData({"isTarget": false, "threatLevel": (param3 ? 1 : 0)});
				m_minimapPseudoView.addChild(_loc4_);
				m_minimapNpcMarkers.push(_loc4_);
			};
			createNpcMapTracker(58, -72, true);
			createNpcMapTracker(62, 22, false);
			createNpcMapTracker(81, -5, false);
			createNpcMapTracker(-69, -54, false);
			createNpcMapTracker(-49, -51, true);
			createNpcMapTracker(-67, 59, true);
			createNpcMapTracker(-84, 52, true);
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
			this.m_difficultyIcon.scaleX = this.m_difficultyIcon.scaleY = 0.65;
			getPreviewContentContainer().addChild(this.m_difficultyIcon);
			this.m_silentAssassinIcon.name = "m_silentAssassinIcon";
			this.m_silentAssassinIcon.scaleX = this.m_silentAssassinIcon.scaleY = 0.65;
			getPreviewContentContainer().addChild(this.m_silentAssassinIcon);
			this.m_evergreenVitalInfoBar.name = "m_evergreenVitalInfoBar";
			this.m_evergreenVitalInfoBar.scaleX = this.m_evergreenVitalInfoBar.scaleY = 1;
			getPreviewContentContainer().addChild(this.m_evergreenVitalInfoBar);
			addEventListener(Event.ENTER_FRAME, this.updateMinimapRotation);
			this.onSetData(data);
			this.m_evergreenVitalInfoBar.animationFlags &= ~VitalInfoBar.ANIMFLAG_POSITIONS_NO_SLIDE;
		}
		
		override public function onSetData(param1:Object):void
		{
			var xMinimapCenter:Number;
			var yMinimapCenter:Number;
			var showNpcs:Boolean;
			var isEvergreenMode:Boolean;
			var isMinimapEnabled:Number;
			var nMinimapShowTargets:Number;
			var isMinimapNpcsEnabled:Boolean;
			var isMinimapFixed:Boolean;
			var isMinimapNorthEnabled:Boolean;
			var isDiffIconEnabled:Boolean;
			var isSAIconEnabled:Boolean;
			var isEvergreenAlertedTerritoryEnabled:Boolean;
			var isEvergreenAssassinProximityEnabled:Boolean;
			var isEvergreenLookoutProximityEnabled:Boolean;
			var pxBGWidth:Number = NaN;
			var pxBGHeight:Number = NaN;
			var flags:uint = 0;
			var tracker:NpcMapTracker = null;
			var data:Object = param1;
			super.onSetData(data);
			pxBGWidth = OptionsInfoPreview.PX_PREVIEW_BACKGROUND_WIDTH;
			pxBGHeight = pxBGWidth / 1920 * 1080;
			xMinimapCenter = 145;
			yMinimapCenter = pxBGHeight - 135;
			showNpcs = Boolean(data.previewData) && Boolean(data.previewData.showNpcs);
			isEvergreenMode = Boolean(data.previewData) && Boolean(data.previewData.isEvergreenMode);
			isMinimapEnabled = CommonUtils.getUIOptionValueNumber("UI_OPTION_GAME_AID_MINI_MAP");
			nMinimapShowTargets = CommonUtils.getUIOptionValueNumber("UI_OPTION_GAME_MINI_MAP_SHOW_TARGETS");
			isMinimapNpcsEnabled = CommonUtils.getUIOptionValue("UI_OPTION_GAME_MINI_MAP_SHOW_NPCS");
			isMinimapFixed = CommonUtils.getUIOptionValue("UI_OPTION_GAME_FIXED_MAP");
			isMinimapNorthEnabled = CommonUtils.getUIOptionValue("UI_OPTION_GAME_MAP_SHOW_NORTH_INDICATOR");
			isDiffIconEnabled = CommonUtils.getUIOptionValue("UI_OPTION_GAME_DIFFICULTY_LEVEL_HUD");
			isSAIconEnabled = CommonUtils.getUIOptionValue("UI_OPTION_GAME_AID_SA_HUD");
			isEvergreenAlertedTerritoryEnabled = CommonUtils.getUIOptionValue("UI_OPTION_GAME_FREELANCER_ALERTED_TERRITORY");
			isEvergreenAssassinProximityEnabled = CommonUtils.getUIOptionValue("UI_OPTION_GAME_FREELANCER_ASSASSIN_PROXIMITY");
			isEvergreenLookoutProximityEnabled = CommonUtils.getUIOptionValue("UI_OPTION_GAME_FREELANCER_LOOKOUT_PROXIMITY");
			this.m_difficultyIcon.visible = !isEvergreenMode && isDiffIconEnabled;
			this.m_silentAssassinIcon.visible = !isEvergreenMode && isSAIconEnabled;
			this.m_difficultyIcon.y = yMinimapCenter + 105 - this.m_difficultyIcon.height / 2;
			this.m_silentAssassinIcon.y = this.m_difficultyIcon.y - this.m_silentAssassinIcon.height - 5;
			this.m_evergreenVitalInfoBar.y = yMinimapCenter + 105 - 24;
			if (isEvergreenMode)
			{
				flags = uint(this.m_evergreenVitalInfoBar.animationFlags | VitalInfoBar.ANIMFLAG_TERRITORY_LABEL_NO_FLASH | VitalInfoBar.ANIMFLAG_ASSASSIN_LABEL_NO_FLASH | VitalInfoBar.ANIMFLAG_LOOKOUT_LABEL_NO_FLASH);
				switch (data.previewData.animateEvergreenBar)
				{
				case "territory": 
					flags &= ~VitalInfoBar.ANIMFLAG_TERRITORY_LABEL_NO_FLASH;
					break;
				case "assassin": 
					flags &= ~VitalInfoBar.ANIMFLAG_ASSASSIN_LABEL_NO_FLASH;
					break;
				case "lookout": 
					flags &= ~VitalInfoBar.ANIMFLAG_LOOKOUT_LABEL_NO_FLASH;
				}
				this.m_evergreenVitalInfoBar.animationFlags = flags;
				this.m_evergreenVitalInfoBar.onSetData({"isAssassinNearby": isEvergreenAssassinProximityEnabled, "isAssassinAlerted": false, "isLookoutNearby": isEvergreenLookoutProximityEnabled, "isLookoutAlerted": false, "isAllertedTerritory": isEvergreenAlertedTerritoryEnabled, "isPrestigeObjectiveActive": false});
			}
			if (isMinimapFixed)
			{
				this.m_degMinimapRotationMin = 0;
				this.m_degMinimapRotationMax = 0;
			}
			else
			{
				this.m_degMinimapRotationMin = !data.previewData || data.previewData.degMinimapRotationMin == null ? 155 : Number(data.previewData.degMinimapRotationMin);
				this.m_degMinimapRotationMax = !data.previewData || data.previewData.degMinimapRotationMax == null ? 155 : Number(data.previewData.degMinimapRotationMax);
			}
			if (!isMinimapEnabled)
			{
				this.m_minimapPseudoView.visible = false;
				this.m_statusMarkers.visible = false;
				this.m_minimapTargetMarker1.visible = false;
				this.m_minimapTargetMarker2.visible = false;
				this.m_minimapNorthMarker.visible = false;
				this.m_difficultyIcon.x = xMinimapCenter - 105 + this.m_difficultyIcon.width / 2 + 5;
				this.m_silentAssassinIcon.x = xMinimapCenter - 105 + this.m_silentAssassinIcon.width / 2 + 5;
				this.m_evergreenVitalInfoBar.x = xMinimapCenter - 105 + 10;
			}
			else
			{
				this.m_minimapPseudoView.visible = true;
				this.m_statusMarkers.visible = true;
				this.m_difficultyIcon.x = xMinimapCenter + 105 + this.m_difficultyIcon.width / 2 + 5;
				this.m_silentAssassinIcon.x = xMinimapCenter + 105 + this.m_silentAssassinIcon.width / 2 + 5;
				this.m_evergreenVitalInfoBar.x = xMinimapCenter + 105 + 10;
				this.m_minimapNorthMarker.visible = isMinimapNorthEnabled;
				this.m_minimapPseudoView.x = xMinimapCenter;
				this.m_minimapPseudoView.y = yMinimapCenter;
				this.m_minimapMask.x = xMinimapCenter;
				this.m_minimapMask.y = yMinimapCenter;
				this.m_statusMarkers.x = xMinimapCenter;
				this.m_statusMarkers.y = yMinimapCenter;
				for each (tracker in this.m_minimapNpcMarkers)
				{
					tracker.visible = showNpcs && isMinimapNpcsEnabled;
				}
				if (!showNpcs || nMinimapShowTargets == UIOPTION_MINIMAP_SHOWTARGETS_OFF)
				{
					this.m_minimapTargetMarker1.visible = false;
					this.m_minimapTargetMarker2.visible = false;
				}
				else
				{
					this.m_minimapTargetMarker1.visible = true;
					this.m_minimapTargetMarker2.visible = true;
					this.m_minimapTargetMarker1.onSetData({"isTarget": nMinimapShowTargets == UIOPTION_MINIMAP_SHOWTARGETS_ON, "threatLevel": 0, "levelCheckResult": 0});
					this.m_minimapTargetMarker2.onSetData({"isTarget": nMinimapShowTargets == UIOPTION_MINIMAP_SHOWTARGETS_ON, "threatLevel": 0, "levelCheckResult": 0});
				}
			}
			if (!data.previewData || !data.previewData.showVitalInfo)
			{
				this.m_aiInformation.visible = false;
			}
			else
			{
				this.m_aiInformation.x = xMinimapCenter - 210 / 2;
				this.m_aiInformation.y = yMinimapCenter - 210 / 2 - 55;
				setTimeout(function():void
				{
					m_aiInformation.visible = true;
					m_aiInformation.showAIinformation(m_lstrAiInformationSample);
				}, 250);
			}
			this.updateMinimapRotation();
		}
		
		private function updateMinimapRotation():void
		{
			var _loc2_:Number = NaN;
			var _loc3_:Number = NaN;
			var _loc1_:Number = this.m_degMinimapRotationMax;
			if (this.m_degMinimapRotationMax != this.m_degMinimapRotationMin && nFrames > 1)
			{
				_loc2_ = Number(iCurrentFrame) / Number(nFrames - 1);
				_loc3_ = 0.5 - 0.5 * Math.cos(Math.PI * _loc2_);
				_loc1_ = this.m_degMinimapRotationMin + _loc3_ * (this.m_degMinimapRotationMax - this.m_degMinimapRotationMin);
			}
			this.m_minimapPseudoView.rotation = _loc1_;
			this.projectToMinimapEdge(this.m_minimapNorthMarker, 270);
			this.projectToMinimapEdge(this.m_minimapTargetMarker1, 115);
			this.projectToMinimapEdge(this.m_minimapTargetMarker2, 62);
		}
		
		private function projectToMinimapEdge(param1:DisplayObject, param2:Number):void
		{
			var _loc7_:Number = NaN;
			var _loc3_:Number = this.m_minimapPseudoView.x;
			var _loc4_:Number = this.m_minimapPseudoView.y;
			var _loc5_:Number = 210;
			var _loc6_:Number = param2 + this.m_minimapPseudoView.rotation;
			while (_loc6_ < 0)
			{
				_loc6_ += 360;
			}
			while (_loc6_ > 360)
			{
				_loc6_ -= 360;
			}
			if (_loc6_ >= 45 && _loc6_ < 135)
			{
				_loc7_ = (_loc6_ - 90) * Math.PI / 180;
				param1.y = _loc4_ + _loc5_ / 2 - param1.height / 2;
				param1.x = _loc3_ - (_loc5_ / 2 - param1.width / 2) * Math.tan(_loc7_);
			}
			else if (_loc6_ >= 135 && _loc6_ < 225)
			{
				_loc7_ = (_loc6_ - 180) * Math.PI / 180;
				param1.x = _loc3_ - _loc5_ / 2 + param1.width / 2;
				param1.y = _loc4_ - (_loc5_ / 2 - param1.height / 2) * Math.tan(_loc7_);
			}
			else if (_loc6_ >= 225 && _loc6_ < 315)
			{
				_loc7_ = (_loc6_ - 270) * Math.PI / 180;
				param1.y = _loc4_ - _loc5_ / 2 + param1.height / 2;
				param1.x = _loc3_ + (_loc5_ / 2 - param1.width / 2) * Math.tan(_loc7_);
			}
			else
			{
				_loc7_ = (_loc6_ - 0) * Math.PI / 180;
				param1.x = _loc3_ + _loc5_ / 2 - param1.width / 2;
				param1.y = _loc4_ + (_loc5_ / 2 - param1.height / 2) * Math.tan(_loc7_);
			}
		}
		
		override protected function onPreviewRemovedFromStage():void
		{
			removeEventListener(Event.ENTER_FRAME, this.updateMinimapRotation);
			super.onPreviewRemovedFromStage();
		}
	}
}
