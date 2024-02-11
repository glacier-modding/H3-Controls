// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.evergreen.CampaignActivatorPage

package hud.evergreen {
import common.BaseControl;
import common.Localization;
import common.ImageLoader;
import common.menu.MenuUtils;

import flash.display.MovieClip;
import flash.text.TextField;
import flash.display.Graphics;
import flash.display.CapsStyle;
import flash.display.DisplayObject;

public class CampaignActivatorPage extends BaseControl {

	public static const Page_OuterCover:int = 1;
	public static const Page_InnerLeft:int = 2;
	public static const Page_InnerRight:int = 3;

	private const m_lstrCrimeType:String = Localization.get("UI_EVEREGREEN_SAFEHOUSE_CAMPAIGNACTIVATOR_CRIMETYPE_TITLE");
	private const m_lstrPayout:String = Localization.get("UI_EVEREGREEN_SAFEHOUSE_CAMPAIGNACTIVATOR_PAYOUT_TITLE");
	private const m_lstrLeader:String = Localization.get("UI_EVEREGREEN_SAFEHOUSE_CAMPAIGNACTIVATOR_LEADERCODENAME_TITLE");
	private const m_lstrTerritories:String = Localization.get("UI_EVEREGREEN_SAFEHOUSE_CAMPAIGNACTIVATOR_TERRITORIES_TITLE");
	private const m_lstrTargets:String = Localization.get("UI_EVEREGREEN_SAFEHOUSE_CAMPAIGNACTIVATOR_TARGETS_TITLE");
	private const m_lstrMercesSymbol:String = Localization.get("UI_EVERGREEN_MERCES");
	private const m_lstrNotAvailable:String = Localization.get("UI_LEVELSELECTION_NOT_AVAILABLE");
	private const m_lstrGetAccess:String = Localization.get("UI_DIALOG_DLC_PURCHASE");
	private const m_lstrFlaours:String = Localization.get("UI_EVEREGREEN_SAFEHOUSE_CAMPAIGNACTIVATOR_PAYOUTOBJECTIVES_TITLE");
	private const m_lstrSickGames:String = Localization.get("UI_EVEREGREEN_SAFEHOUSE_CAMPAIGNACTIVATOR_SICKGAMESDESC");
	private const m_lstrDestinations:String = Localization.get("UI_EVEREGREEN_SAFEHOUSE_CAMPAIGNACTIVATOR_DESTINATIONS");
	private const m_lstrCampProgress:String = Localization.get("UI_EVEREGREEN_SAFEHOUSE_WORLDMAP_CAMPAIGNPROGRESS");

	private var m_view:CampaignActivatorPageView = new CampaignActivatorPageView();
	private var m_iconLoader:ImageLoader = new ImageLoader();
	private var m_iconLoader2:ImageLoader = new ImageLoader();

	public function CampaignActivatorPage() {
		this.m_view.name = "m_view";
		addChild(this.m_view);
		this.m_iconLoader.name = "m_iconLoader";
		this.m_iconLoader2.name = "m_iconLoader2";
	}

	private static function setupIcon(_arg_1:iconsAll76x76View, _arg_2:String):void {
		MenuUtils.setupIcon(_arg_1, _arg_2, 0, false, false, 0x464646, 0, 0, true);
	}


	[PROPERTY(CONSTRAINT="MinValue(1) MaxValue(3)", HELPTEXT="1 = outer cover,  2 = inner left,  3 = inner right")]
	public function set WhichPage(_arg_1:int):void {
		var _local_3:MovieClip;
		var _local_4:iconsAll76x76View;
		var _local_5:MovieClip;
		var _local_6:iconsAll76x76View;
		this.m_view.gotoAndStop(_arg_1);
		EvergreenUtils.disableMaskingInTextFields(this.m_view);
		if (this.m_view.labelLeader_txt != null) {
			this.m_view.labelLeader_txt.text = this.m_lstrLeader.toUpperCase();
		}
		;
		if (this.m_view.labelTargets_txt != null) {
			this.m_view.labelTargets_txt.text = this.m_lstrTargets.toUpperCase();
		}
		;
		if (this.m_view.labelCampProgress_txt != null) {
			this.m_view.labelCampProgress_txt.text = this.m_lstrCampProgress.toUpperCase();
		}
		;
		if (this.m_view.iconHolder_mc != null) {
			this.m_view.iconHolder_mc.addChild(this.m_iconLoader);
		}
		;
		var _local_2:int;
		while (true) {
			_local_3 = this.m_view[(("flavour" + _local_2) + "_mc")];
			if (_local_3 == null) break;
			if (this.m_view.currentFrame == Page_InnerLeft) {
				_local_4 = new iconsAll76x76View();
				_local_4.width = (_local_4.height = 18);
				_local_3.iconHolder_mc.addChild(_local_4);
			} else {
				_local_3.iconHolder_mc.removeChildren();
			}
			;
			_local_2++;
		}
		;
		_arg_1 = 0;
		while (true) {
			_local_5 = this.m_view[(("territory" + _arg_1) + "_mc")];
			if (_local_5 == null) break;
			if (this.m_view.currentFrame == Page_InnerRight) {
				_local_6 = new iconsAll76x76View();
				setupIcon(_local_6, "location");
				_local_6.width = (_local_6.height = 18);
				_local_5.iconHolder_mc.addChild(_local_6);
			} else {
				_local_5.iconHolder_mc.removeChildren();
			}
			;
			_arg_1++;
		}
		;
	}

	public function onSetData(_arg_1:Object):void {
		if (this.m_view.currentFrame == Page_OuterCover) {
			this.applyData_OuterCover(_arg_1);
		}
		;
		if (this.m_view.currentFrame == Page_InnerLeft) {
			this.applyData_InnerLeft(_arg_1);
		}
		;
		if (this.m_view.currentFrame == Page_InnerRight) {
			this.applyData_InnerRight(_arg_1);
		}
		;
	}

	private function applyData_OuterCover(data:Object):void {
		var yFooterTop:Number;
		var territory:Object;
		var notAvailable_txt:TextField;
		var getAccess_txt:TextField;
		var dxMaxTextWidth:Number;
		this.m_view.crimeSector_txt.text = data.lstrCrimeSector.toUpperCase();
		this.m_view.leader_txt.text = data.lstrFactionLieutenantCodename.toUpperCase();
		MenuUtils.shrinkTextToFit(this.m_view.leader_txt, 360, -1, 10, 2);
		var g:Graphics = this.m_view.graphics;
		g.clear();
		g.lineStyle(3, 0xDDDDDD, 1, false, null, CapsStyle.SQUARE);
		var xHeaderLeft:Number = this.m_view.leader_txt.x;
		var xHeaderRight:Number = (this.m_view.leader_txt.x + this.m_view.leader_txt.width);
		var/*const*/ pxHeaderPadding:Number = 8;
		var/*const*/ yHeaderBottom:Number = 450;
		this.m_view.leader_txt.y = (yHeaderBottom - this.m_view.leader_txt.textHeight);
		this.m_view.crimeSector_txt.y = (this.m_view.leader_txt.y - this.m_view.crimeSector_txt.textHeight);
		var yHeaderMidCrimeSector:Number = (this.m_view.crimeSector_txt.y + (this.m_view.crimeSector_txt.height / 2));
		g.moveTo(xHeaderLeft, yHeaderMidCrimeSector);
		g.lineTo((((this.m_view.crimeSector_txt.x + (this.m_view.crimeSector_txt.width / 2)) - (this.m_view.crimeSector_txt.textWidth / 2)) - pxHeaderPadding), yHeaderMidCrimeSector);
		g.moveTo((((this.m_view.crimeSector_txt.x + (this.m_view.crimeSector_txt.width / 2)) + (this.m_view.crimeSector_txt.textWidth / 2)) + pxHeaderPadding), yHeaderMidCrimeSector);
		g.lineTo(xHeaderRight, yHeaderMidCrimeSector);
		g.moveTo(xHeaderLeft, (yHeaderBottom + pxHeaderPadding));
		g.lineTo(xHeaderRight, (yHeaderBottom + pxHeaderPadding));
		yFooterTop = this.m_view.crimeSector_txt.y;
		this.m_view.iconHolder_mc.y = (yFooterTop / 2);
		this.m_iconLoader.loadImage(data.ridCampaignIcon, function ():void {
			var _local_1:Number;
			var _local_2:Number;
			_local_1 = 40;
			_local_2 = (yFooterTop - _local_1);
			var _local_3:Number = (_local_2 / m_iconLoader.height);
			m_view.iconHolder_mc.scaleX = _local_3;
			m_view.iconHolder_mc.scaleY = _local_3;
			m_iconLoader.x = (-(m_iconLoader.width) / 2);
			m_iconLoader.y = (-(m_iconLoader.height) / 2);
		});
		this.m_view.notAvailable_mc.y = (yFooterTop / 2);
		var isCampaignAvailable:Boolean = true;
		for each (territory in data.territories) {
			isCampaignAvailable = ((isCampaignAvailable) && (territory.isEntitlementAvailable));
		}
		;
		if (isCampaignAvailable) {
			this.m_view.notAvailable_mc.visible = false;
		} else {
			this.m_view.notAvailable_mc.visible = true;
			notAvailable_txt = this.m_view.notAvailable_mc.notAvailable_txt;
			getAccess_txt = this.m_view.notAvailable_mc.getAccess_txt;
			notAvailable_txt.text = this.m_lstrNotAvailable.toUpperCase();
			getAccess_txt.text = this.m_lstrGetAccess.toUpperCase();
			dxMaxTextWidth = (Math.max(notAvailable_txt.textWidth, getAccess_txt.textWidth) + 24);
			g = this.m_view.notAvailable_mc.graphics;
			g.clear();
			g.beginFill(0xDDDDDD, 1);
			g.drawRect((-(dxMaxTextWidth) / 2), notAvailable_txt.y, dxMaxTextWidth, ((getAccess_txt.y + getAccess_txt.height) - notAvailable_txt.y));
		}
		;
	}

	private function applyData_InnerLeft(_arg_1:Object):void {
		var _local_2:int;
		var _local_3:MovieClip;
		this.m_view.labelCrimeType_txt.text = this.m_lstrCrimeType.toUpperCase();
		this.m_view.crimeType_txt.text = _arg_1.lstrCrimeSector.toUpperCase();
		this.m_view.labelFlavours_txt.text = this.m_lstrFlaours.toUpperCase();
		this.m_view.leader_txt.text = _arg_1.lstrFactionLieutenantCodename.toUpperCase();
		this.m_view.biography_txt.htmlText = _arg_1.lstrBiography;
		MenuUtils.shrinkTextToFit(this.m_view.leader_txt, this.m_view.dividerTop_mc.width, -1, -1, 1);
		MenuUtils.shrinkTextToFit(this.m_view.crimeType_txt, this.m_view.dividerTop_mc.width, -1, -1, 1);
		this.m_view.objdesc_txt.visible = _arg_1.hasAllBonusRequirements;
		this.m_view.objdesc_txt.htmlText = this.m_lstrSickGames;
		_local_2 = 0;
		while (true) {
			_local_3 = this.m_view[(("flavour" + _local_2) + "_mc")];
			if (_local_3 == null) break;
			if (((_arg_1.bonusRequirements[_local_2]) && (!(_arg_1.hasAllBonusRequirements)))) {
				_local_3.visible = true;
				_local_3.territoryName_txt.htmlText = _arg_1.bonusRequirements[_local_2].lstrTitle;
				MenuUtils.shrinkTextToFit(_local_3.territoryName_txt, 300, -1);
				setupIcon(_local_3.iconHolder_mc.getChildAt(0), _arg_1.bonusRequirements[_local_2].icon);
			} else {
				_local_3.visible = false;
			}
			;
			_local_2++;
		}
		;
	}

	private function applyData_InnerRight(data:Object):void {
		var i:int;
		var territory_mc:MovieClip;
		var territoryName_txt:TextField;
		var mapDot:DisplayObject;
		this.m_view.labelDestinations_txt.text = this.m_lstrDestinations.toUpperCase();
		this.m_view.iconHolder2_mc.addChild(this.m_iconLoader2);
		this.m_iconLoader2.loadImage(data.ridCampaignIcon, function ():void {
			m_iconLoader2.height = 180;
			m_iconLoader2.scaleX = m_iconLoader2.scaleY;
			m_iconLoader2.x = -90;
			m_iconLoader2.y = -90;
		});
		var mapDots_mc:MovieClip = this.m_view.mapDots_mc;
		i = 0;
		while (i < mapDots_mc.numChildren) {
			mapDots_mc.getChildAt(i).visible = false;
			i = (i + 1);
		}
		;
		this.m_view.miniProgress_mc.gotoAndStop(data.nDifficultyRank);
		data.territories.sortOn("lstrDestinationFullName");
		i = 0;
		while (true) {
			territory_mc = this.m_view[(("territory" + i) + "_mc")];
			if (territory_mc == null) break;
			if (i >= data.territories.length) {
				territory_mc.visible = false;
			} else {
				territory_mc.visible = true;
				territoryName_txt = territory_mc.territoryName_txt;
				territoryName_txt.htmlText = data.territories[i].lstrDestinationFullName;
				MenuUtils.shrinkTextToFit(territoryName_txt, 300, -1);
				mapDot = mapDots_mc[data.territories[i].destination];
				if (mapDot != null) {
					mapDot.visible = true;
				}
				;
			}
			;
			i = (i + 1);
		}
		;
	}


}
}//package hud.evergreen

