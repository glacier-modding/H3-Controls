package hud.evergreen
{
	import common.BaseControl;
	import common.ImageLoader;
	import common.Localization;
	import common.menu.MenuUtils;
	import flash.display.CapsStyle;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class CampaignActivatorPage extends BaseControl
	{
		
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
		
		private var m_view:CampaignActivatorPageView;
		
		private var m_iconLoader:ImageLoader;
		
		private var m_iconLoader2:ImageLoader;
		
		public function CampaignActivatorPage()
		{
			this.m_view = new CampaignActivatorPageView();
			this.m_iconLoader = new ImageLoader();
			this.m_iconLoader2 = new ImageLoader();
			super();
			this.m_view.name = "m_view";
			addChild(this.m_view);
			this.m_iconLoader.name = "m_iconLoader";
			this.m_iconLoader2.name = "m_iconLoader2";
		}
		
		private static function setupIcon(param1:iconsAll76x76View, param2:String):void
		{
			MenuUtils.setupIcon(param1, param2, 0, false, false, 4605510, 0, 0, true);
		}
		
		[PROPERTY(CONSTRAINT = "MinValue(1) MaxValue(3)", HELPTEXT = "1 = outer cover,  2 = inner left,  3 = inner right")]
		public function set WhichPage(param1:int):void
		{
			var _loc3_:MovieClip = null;
			var _loc4_:iconsAll76x76View = null;
			var _loc5_:MovieClip = null;
			var _loc6_:iconsAll76x76View = null;
			this.m_view.gotoAndStop(param1);
			EvergreenUtils.disableMaskingInTextFields(this.m_view);
			if (this.m_view.labelLeader_txt != null)
			{
				this.m_view.labelLeader_txt.text = this.m_lstrLeader.toUpperCase();
			}
			if (this.m_view.labelTargets_txt != null)
			{
				this.m_view.labelTargets_txt.text = this.m_lstrTargets.toUpperCase();
			}
			if (this.m_view.labelCampProgress_txt != null)
			{
				this.m_view.labelCampProgress_txt.text = this.m_lstrCampProgress.toUpperCase();
			}
			if (this.m_view.iconHolder_mc != null)
			{
				this.m_view.iconHolder_mc.addChild(this.m_iconLoader);
			}
			var _loc2_:int = 0;
			while (true)
			{
				_loc3_ = this.m_view["flavour" + _loc2_ + "_mc"];
				if (_loc3_ == null)
				{
					break;
				}
				if (this.m_view.currentFrame == Page_InnerLeft)
				{
					_loc4_ = new iconsAll76x76View();
					_loc4_.width = _loc4_.height = 18;
					_loc3_.iconHolder_mc.addChild(_loc4_);
				}
				else
				{
					_loc3_.iconHolder_mc.removeChildren();
				}
				_loc2_++;
			}
			param1 = 0;
			while ((_loc5_ = this.m_view["territory" + param1 + "_mc"]) != null)
			{
				if (this.m_view.currentFrame == Page_InnerRight)
				{
					_loc6_ = new iconsAll76x76View();
					setupIcon(_loc6_, "location");
					_loc6_.width = _loc6_.height = 18;
					_loc5_.iconHolder_mc.addChild(_loc6_);
				}
				else
				{
					_loc5_.iconHolder_mc.removeChildren();
				}
				param1++;
			}
		}
		
		public function onSetData(param1:Object):void
		{
			if (this.m_view.currentFrame == Page_OuterCover)
			{
				this.applyData_OuterCover(param1);
			}
			if (this.m_view.currentFrame == Page_InnerLeft)
			{
				this.applyData_InnerLeft(param1);
			}
			if (this.m_view.currentFrame == Page_InnerRight)
			{
				this.applyData_InnerRight(param1);
			}
		}
		
		private function applyData_OuterCover(param1:Object):void
		{
			var g:Graphics;
			var xHeaderLeft:Number;
			var xHeaderRight:Number;
			var pxHeaderPadding:Number;
			var yHeaderBottom:Number;
			var yHeaderMidCrimeSector:Number;
			var isCampaignAvailable:Boolean;
			var yFooterTop:Number = NaN;
			var territory:Object = null;
			var notAvailable_txt:TextField = null;
			var getAccess_txt:TextField = null;
			var dxMaxTextWidth:Number = NaN;
			var data:Object = param1;
			this.m_view.crimeSector_txt.text = data.lstrCrimeSector.toUpperCase();
			this.m_view.leader_txt.text = data.lstrFactionLieutenantCodename.toUpperCase();
			MenuUtils.shrinkTextToFit(this.m_view.leader_txt, 360, -1, 10, 2);
			g = this.m_view.graphics;
			g.clear();
			g.lineStyle(3, 14540253, 1, false, null, CapsStyle.SQUARE);
			xHeaderLeft = this.m_view.leader_txt.x;
			xHeaderRight = this.m_view.leader_txt.x + this.m_view.leader_txt.width;
			pxHeaderPadding = 8;
			yHeaderBottom = 450;
			this.m_view.leader_txt.y = yHeaderBottom - this.m_view.leader_txt.textHeight;
			this.m_view.crimeSector_txt.y = this.m_view.leader_txt.y - this.m_view.crimeSector_txt.textHeight;
			yHeaderMidCrimeSector = this.m_view.crimeSector_txt.y + this.m_view.crimeSector_txt.height / 2;
			g.moveTo(xHeaderLeft, yHeaderMidCrimeSector);
			g.lineTo(this.m_view.crimeSector_txt.x + this.m_view.crimeSector_txt.width / 2 - this.m_view.crimeSector_txt.textWidth / 2 - pxHeaderPadding, yHeaderMidCrimeSector);
			g.moveTo(this.m_view.crimeSector_txt.x + this.m_view.crimeSector_txt.width / 2 + this.m_view.crimeSector_txt.textWidth / 2 + pxHeaderPadding, yHeaderMidCrimeSector);
			g.lineTo(xHeaderRight, yHeaderMidCrimeSector);
			g.moveTo(xHeaderLeft, yHeaderBottom + pxHeaderPadding);
			g.lineTo(xHeaderRight, yHeaderBottom + pxHeaderPadding);
			yFooterTop = this.m_view.crimeSector_txt.y;
			this.m_view.iconHolder_mc.y = yFooterTop / 2;
			this.m_iconLoader.loadImage(data.ridCampaignIcon, function():void
			{
				var _loc1_:Number = NaN;
				var _loc2_:Number = NaN;
				_loc1_ = 40;
				_loc2_ = yFooterTop - _loc1_;
				var _loc3_:Number = _loc2_ / m_iconLoader.height;
				m_view.iconHolder_mc.scaleX = _loc3_;
				m_view.iconHolder_mc.scaleY = _loc3_;
				m_iconLoader.x = -m_iconLoader.width / 2;
				m_iconLoader.y = -m_iconLoader.height / 2;
			});
			this.m_view.notAvailable_mc.y = yFooterTop / 2;
			isCampaignAvailable = true;
			for each (territory in data.territories)
			{
				isCampaignAvailable &&= Boolean(territory.isEntitlementAvailable);
			}
			if (isCampaignAvailable)
			{
				this.m_view.notAvailable_mc.visible = false;
			}
			else
			{
				this.m_view.notAvailable_mc.visible = true;
				notAvailable_txt = this.m_view.notAvailable_mc.notAvailable_txt;
				getAccess_txt = this.m_view.notAvailable_mc.getAccess_txt;
				notAvailable_txt.text = this.m_lstrNotAvailable.toUpperCase();
				getAccess_txt.text = this.m_lstrGetAccess.toUpperCase();
				dxMaxTextWidth = Math.max(notAvailable_txt.textWidth, getAccess_txt.textWidth) + 24;
				g = this.m_view.notAvailable_mc.graphics;
				g.clear();
				g.beginFill(14540253, 1);
				g.drawRect(-dxMaxTextWidth / 2, notAvailable_txt.y, dxMaxTextWidth, getAccess_txt.y + getAccess_txt.height - notAvailable_txt.y);
			}
		}
		
		private function applyData_InnerLeft(param1:Object):void
		{
			var _loc2_:int = 0;
			var _loc3_:MovieClip = null;
			this.m_view.labelCrimeType_txt.text = this.m_lstrCrimeType.toUpperCase();
			this.m_view.crimeType_txt.text = param1.lstrCrimeSector.toUpperCase();
			this.m_view.labelFlavours_txt.text = this.m_lstrFlaours.toUpperCase();
			this.m_view.leader_txt.text = param1.lstrFactionLieutenantCodename.toUpperCase();
			this.m_view.biography_txt.htmlText = param1.lstrBiography;
			MenuUtils.shrinkTextToFit(this.m_view.leader_txt, this.m_view.dividerTop_mc.width, -1, -1, 1);
			MenuUtils.shrinkTextToFit(this.m_view.crimeType_txt, this.m_view.dividerTop_mc.width, -1, -1, 1);
			this.m_view.objdesc_txt.visible = param1.hasAllBonusRequirements;
			this.m_view.objdesc_txt.htmlText = this.m_lstrSickGames;
			_loc2_ = 0;
			while (true)
			{
				_loc3_ = this.m_view["flavour" + _loc2_ + "_mc"];
				if (_loc3_ == null)
				{
					break;
				}
				if (Boolean(param1.bonusRequirements[_loc2_]) && !param1.hasAllBonusRequirements)
				{
					_loc3_.visible = true;
					_loc3_.territoryName_txt.htmlText = param1.bonusRequirements[_loc2_].lstrTitle;
					MenuUtils.shrinkTextToFit(_loc3_.territoryName_txt, 300, -1);
					setupIcon(_loc3_.iconHolder_mc.getChildAt(0), param1.bonusRequirements[_loc2_].icon);
				}
				else
				{
					_loc3_.visible = false;
				}
				_loc2_++;
			}
		}
		
		private function applyData_InnerRight(param1:Object):void
		{
			var mapDots_mc:MovieClip;
			var i:int = 0;
			var territory_mc:MovieClip = null;
			var territoryName_txt:TextField = null;
			var mapDot:DisplayObject = null;
			var data:Object = param1;
			this.m_view.labelDestinations_txt.text = this.m_lstrDestinations.toUpperCase();
			this.m_view.iconHolder2_mc.addChild(this.m_iconLoader2);
			this.m_iconLoader2.loadImage(data.ridCampaignIcon, function():void
			{
				m_iconLoader2.height = 180;
				m_iconLoader2.scaleX = m_iconLoader2.scaleY;
				m_iconLoader2.x = -90;
				m_iconLoader2.y = -90;
			});
			mapDots_mc = this.m_view.mapDots_mc;
			i = 0;
			while (i < mapDots_mc.numChildren)
			{
				mapDots_mc.getChildAt(i).visible = false;
				i++;
			}
			this.m_view.miniProgress_mc.gotoAndStop(data.nDifficultyRank);
			data.territories.sortOn("lstrDestinationFullName");
			i = 0;
			while (true)
			{
				territory_mc = this.m_view["territory" + i + "_mc"];
				if (territory_mc == null)
				{
					break;
				}
				if (i >= data.territories.length)
				{
					territory_mc.visible = false;
				}
				else
				{
					territory_mc.visible = true;
					territoryName_txt = territory_mc.territoryName_txt;
					territoryName_txt.htmlText = data.territories[i].lstrDestinationFullName;
					MenuUtils.shrinkTextToFit(territoryName_txt, 300, -1);
					mapDot = mapDots_mc[data.territories[i].destination];
					if (mapDot != null)
					{
						mapDot.visible = true;
					}
				}
				i++;
			}
		}
	}
}
