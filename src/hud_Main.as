// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud_Main

package {
import flash.display.Sprite;

import hud.ActorMapBlip;
import hud.AIIndicator;
import hud.AIinformation;
import hud.AreaIndicator;
import hud.AttentionIndicator;
import hud.BeingObserved;
import hud.Breadcrumb;
import hud.ButtonPrompts;
import hud.CameraGrid;
import hud.ChallengeElement;
import hud.ConnectionAlert;
import hud.CountdownTimer;
import hud.DamageDirection;
import hud.DifficultyIcon;
import hud.Disguise;
import hud.DroppedItemVR;
import hud.EmptySpace;
import hud.FaceTheCameraVR;
import hud.HintBox;
import hud.HUDActionPrompts;
import hud.HudConstants;
import hud.Intelmenu;
import hud.InteractionIndicator;
import hud.InventoryItemIcon;
import hud.InventoryPage;
import hud.ItemBreadcrumb;
import hud.MapDynamicLayer;
import hud.MapLayerIndicator;
import hud.MapLegend;
import hud.MapLegendMenu;
import hud.MapNorthIndicator;
import hud.Minimap;
import hud.MinimapBlip;
import hud.MissionTimerVR;
import hud.ObjectiveConditions;
import hud.ObjectivesBar;
import hud.OpportunityPreview;
import hud.OutfitAndStatusMarkersVR;
import hud.OutfitWidgetVR;
import hud.PipElement;
import hud.PlayerNameTag;
import hud.Reticle;
import hud.ScoreUpdater;
import hud.SilentAssassinIcon;
import hud.StatusMarkers;
import hud.StatusMarkersVR;
import hud.StatusMicroMarkersVR;
import hud.Subtitle;
import hud.SubtitleSpeakerIndicator;
import hud.ThreatDirection;
import hud.ThreatMarker;
import hud.WalkSpeedIcon;
import hud.Weapon;
import hud.WeaponAmmoVRWidget;
import hud.WeaponHints;
import hud.WeaponHolsterVRWidget;
import hud.WeaponOnBackVRWidget;
import hud.WeaponSelector;
import hud.WorldUIImage;
import hud.evergreen.CampaignActivatorPage;
import hud.evergreen.CampaignProgress;
import hud.evergreen.EconomyWidget;
import hud.evergreen.EvergreenBreadcrumb;
import hud.evergreen.EvergreenSpycameraGridlines;
import hud.evergreen.EvergreenSpycameraWidget;
import hud.evergreen.EvergreenUtils;
import hud.evergreen.IMenuOverlayComponent;
import hud.evergreen.IntelWallWidget;
import hud.evergreen.LocationIntelWidget;
import hud.evergreen.MenuCursorWidget;
import hud.evergreen.MenuOverlayContainer;
import hud.evergreen.SupplierPriceWidget;
import hud.evergreen.SuspectPerformingWidget;
import hud.evergreen.VitalInfoBar;
import hud.evergreen.VitalInfoIcons;
import hud.evergreen.WorldMapTerritoryWidget;
import hud.evergreen.menuoverlay.ButtonPromptsComponent;
import hud.evergreen.menuoverlay.HeadlineComponent;
import hud.evergreen.menuoverlay.InfoPanelRComponent;
import hud.evergreen.misc.DottedLineAlt;
import hud.evergreen.misc.IconStack;
import hud.evergreen.misc.LocationIntelBlock;
import hud.maptrackers.AreaUndiscoveredMapTracker;
import hud.maptrackers.BaseMapTracker;
import hud.maptrackers.CameraIntelMapTracker;
import hud.maptrackers.CustomObjectiveMapTracker;
import hud.maptrackers.DiscoveryAMapTracker;
import hud.maptrackers.DiscoveryBMapTracker;
import hud.maptrackers.DiscoveryCMapTracker;
import hud.maptrackers.DiscoveryMapTracker;
import hud.maptrackers.EntranceMapTracker;
import hud.maptrackers.EvergreenMeetingBusinessMapTracker;
import hud.maptrackers.EvergreenMeetingHandoverMapTracker;
import hud.maptrackers.EvergreenMeetingSecretMapTracker;
import hud.maptrackers.EvergreenMuleMapTracker;
import hud.maptrackers.EvergreenPhoneMapTracker;
import hud.maptrackers.EvergreenSafeMapTracker;
import hud.maptrackers.EvergreenStashMapTracker;
import hud.maptrackers.EvergreenSupplierMapTracker;
import hud.maptrackers.EvergreenSuspectNormalMapTracker;
import hud.maptrackers.EvergreenSuspectNotMapTracker;
import hud.maptrackers.EvergreenSuspectPrimeMapTracker;
import hud.maptrackers.EvidenceMapTracker;
import hud.maptrackers.ExitFailMapTracker;
import hud.maptrackers.ExitMapTracker;
import hud.maptrackers.GhostModeStashPointMapTracker;
import hud.maptrackers.LevelCheckedMapTracker;
import hud.maptrackers.MapTextTracker;
import hud.maptrackers.NorthIndicatorMapTracker;
import hud.maptrackers.NpcMapTracker;
import hud.maptrackers.OpponentMapTracker;
import hud.maptrackers.OpportunitiesMapTracker;
import hud.maptrackers.PlayerHeroMapTracker;
import hud.maptrackers.SecurityCameraMapTracker;
import hud.maptrackers.StairDownMapTracker;
import hud.maptrackers.StairUpDownMapTracker;
import hud.maptrackers.StairUpMapTracker;
import hud.maptrackers.StashedItemMapTracker;
import hud.maptrackers.StashPointMapTracker;
import hud.maptrackers.SuitcaseMapTracker;
import hud.maptrackers.TutorialMapTracker;
import hud.notification.ActionXpBar;
import hud.notification.ActionXpBarVr;
import hud.notification.ChallengesBar;
import hud.notification.ConnectionIndicator;
import hud.notification.NotificationListener;
import hud.photomode.PhotoModeCameraGrid;
import hud.photomode.PhotoModeEntry;
import hud.photomode.PhotoModeMessageWidget;
import hud.photomode.PhotoModeViewfinderBorder;
import hud.photomode.PhotoModeViewfinderCenter;
import hud.photomode.PhotoModeViewfinderCorner;
import hud.photomode.PhotoModeViewfinderFocusFrame;
import hud.photomode.PhotoModeViewfinderScanner;
import hud.photomode.PhotoModeWidget;
import hud.scope.Scope;
import hud.sniper.AIIndicatorElement;
import hud.sniper.AIInformationElement;
import hud.sniper.AIMarkElement;
import hud.sniper.BaseScoreElement;
import hud.sniper.ChallengeElement;
import hud.sniper.ObjectivesElement;
import hud.sniper.ScrollingScoreElement;
import hud.sniper.TargetTimerElement;
import hud.sniper.WeaponElement;
import hud.sniper.WeaponHintsElement;
import hud.tutorial.TutorialBar;
import hud.tutorial.TutorialTask;
import hud.tutorial.Waypoint2d;
import hud.tutorial.Waypoint2dArrow;
import hud.tutorial.Waypoint3d;
import hud.versus.TargetInfoElement;
import hud.versus.markers.BaseMarkerElement;
import hud.versus.markers.DistanceMarkerElement;
import hud.versus.markers.DynamicMarkerElement;
import hud.versus.markers.OpponentMarkerElement;
import hud.versus.markers.OpponentMarkerIconElement;
import hud.versus.markers.StashMarkerElement;
import hud.versus.markers.TargetMarkerElement;
import hud.versus.markers.TargetMarkerIconElement;
import hud.versus.names.BaseNameElement;
import hud.versus.names.OpponentNameElement;
import hud.versus.names.PlayerNameElement;
import hud.versus.scoring.ActionXpBarElement;
import hud.versus.scoring.UnnoticedKillElement;
import hud.versus.scoring.VersusScoreElement;

/**
 * Main class for [assembly:/ui/controls/hud.swf].pc_swf
 */
[SWF(frameRate="60", width="500", height="375")]
public class hud_Main extends Sprite {

	public function hud_Main():void {
		var dummy:Array = [ActorMapBlip, AIIndicator, AIinformation, AreaIndicator, AttentionIndicator, BeingObserved, Breadcrumb, ButtonPrompts, CameraGrid, hud.ChallengeElement, ConnectionAlert, CountdownTimer, DamageDirection, DifficultyIcon, Disguise, DroppedItemVR, EmptySpace, FaceTheCameraVR, HintBox, HUDActionPrompts, HudConstants, Intelmenu, InteractionIndicator, InventoryItemIcon, InventoryPage, ItemBreadcrumb, MapDynamicLayer, MapLayerIndicator, MapLegend, MapLegendMenu, MapNorthIndicator, Minimap, MinimapBlip, MissionTimerVR, ObjectiveConditions, ObjectivesBar, OpportunityPreview, OutfitAndStatusMarkersVR, OutfitWidgetVR, PipElement, PlayerNameTag, Reticle, ScoreUpdater, SilentAssassinIcon, StatusMarkers, StatusMarkersVR, StatusMicroMarkersVR, Subtitle, SubtitleSpeakerIndicator, ThreatDirection, ThreatMarker, WalkSpeedIcon, Weapon, WeaponAmmoVRWidget, WeaponHints, WeaponHolsterVRWidget, WeaponOnBackVRWidget, WeaponSelector, WorldUIImage, CampaignActivatorPage, CampaignProgress, EconomyWidget, EvergreenBreadcrumb, EvergreenSpycameraGridlines, EvergreenSpycameraWidget, EvergreenUtils, IMenuOverlayComponent, IntelWallWidget, LocationIntelWidget, MenuCursorWidget, MenuOverlayContainer, SupplierPriceWidget, SuspectPerformingWidget, VitalInfoBar, VitalInfoIcons, WorldMapTerritoryWidget, ButtonPromptsComponent, HeadlineComponent, InfoPanelRComponent, DottedLineAlt, IconStack, LocationIntelBlock, AreaUndiscoveredMapTracker, BaseMapTracker, CameraIntelMapTracker, CustomObjectiveMapTracker, DiscoveryAMapTracker, DiscoveryBMapTracker, DiscoveryCMapTracker, DiscoveryMapTracker, EntranceMapTracker, EvergreenMeetingBusinessMapTracker, EvergreenMeetingHandoverMapTracker, EvergreenMeetingSecretMapTracker, EvergreenMuleMapTracker, EvergreenPhoneMapTracker, EvergreenSafeMapTracker, EvergreenStashMapTracker, EvergreenSupplierMapTracker, EvergreenSuspectNormalMapTracker, EvergreenSuspectNotMapTracker, EvergreenSuspectPrimeMapTracker, EvidenceMapTracker, ExitFailMapTracker, ExitMapTracker, GhostModeStashPointMapTracker, LevelCheckedMapTracker, MapTextTracker, NorthIndicatorMapTracker, NpcMapTracker, OpponentMapTracker, OpportunitiesMapTracker, PlayerHeroMapTracker, SecurityCameraMapTracker, StairDownMapTracker, StairUpDownMapTracker, StairUpMapTracker, StashedItemMapTracker, StashPointMapTracker, SuitcaseMapTracker, TutorialMapTracker, ActionXpBar, ActionXpBarVr, ChallengesBar, ConnectionIndicator, NotificationListener, PhotoModeCameraGrid, PhotoModeEntry, PhotoModeMessageWidget, PhotoModeViewfinderBorder, PhotoModeViewfinderCenter, PhotoModeViewfinderCorner, PhotoModeViewfinderFocusFrame, PhotoModeViewfinderScanner, PhotoModeWidget, Scope, AIIndicatorElement, AIInformationElement, AIMarkElement, BaseScoreElement, hud.sniper.ChallengeElement, ObjectivesElement, ScrollingScoreElement, TargetTimerElement, WeaponElement, WeaponHintsElement, TutorialBar, TutorialTask, Waypoint2d, Waypoint2dArrow, Waypoint3d, TargetInfoElement, BaseMarkerElement, DistanceMarkerElement, DynamicMarkerElement, OpponentMarkerElement, OpponentMarkerIconElement, StashMarkerElement, TargetMarkerElement, TargetMarkerIconElement, BaseNameElement, OpponentNameElement, PlayerNameElement, ActionXpBarElement, UnnoticedKillElement, VersusScoreElement];
	}

}
}//package 

