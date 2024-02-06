package menu3.basic
{
	import common.CommonUtils;
	import common.Localization;
	import flash.display.Shape;
	import menu3.ChallengeDetailTile;
	
	public dynamic class OptionsInfoChallengeListPreview extends OptionsInfoPreview
	{
		
		private static const CHALLENGEDESCRIPTION_FULL:int = 0;
		
		private static const CHALLENGEDESCRIPTION_MINIMAL:int = 1;
		
		private static const CHALLENGEDESCRIPTION_OFF:int = 2;
		
		private var m_mask:Shape;
		
		private var m_detailTile:ChallengeDetailTile;
		
		private const m_lstrHeader:String = Localization.get("UI_MENU_PAGE_PROFILE_CHALLENGES_CATEGORY_COMMUNITY");
		
		private const m_lstrTitle:String = Localization.get("UI_CHALLENGES_PROLOGUE_BOARD_AS_GUARD_NAME");
		
		private const m_lstrDescription:String = Localization.get("UI_CHALLENGES_PROLOGUE_BOARD_AS_GUARD_DESC");
		
		private const m_lstrVerboseWarn:String = Localization.get("UI_MENU_PAGE_CHALLENGES_VERBOSITY_WARNING");
		
		public function OptionsInfoChallengeListPreview(param1:Object)
		{
			this.m_mask = new Shape();
			this.m_detailTile = new ChallengeDetailTile({});
			super(param1);
			this.m_mask.name = "m_mask";
			getPreviewContentContainer().addChild(this.m_mask);
			getPreviewContentContainer().mask = this.m_mask;
			this.m_detailTile.name = "m_detailTile";
			getPreviewContentContainer().addChild(this.m_detailTile);
			this.m_detailTile.x = 300;
			this.m_detailTile.y = 215;
			this.m_detailTile.scaleX = 0.6;
			this.m_detailTile.scaleY = 0.6;
			ChallengeDetailsView(this.m_detailTile.getChildAt(0)).bodyClip.description.width = 500;
			this.onSetData(param1);
		}
		
		override public function onSetData(param1:Object):void
		{
			super.onSetData(param1);
			var _loc2_:Object = {"rewardsTitle": "Rewards", "unlocks": [], "status": "Not Accomplished", "rewards": []};
			switch (CommonUtils.getUIOptionValueNumber("UI_OPTION_GAME_AID_CHALLENGEDESCRIPTION"))
			{
			case CHALLENGEDESCRIPTION_FULL: 
				_loc2_.header = this.m_lstrHeader;
				_loc2_.title = this.m_lstrTitle;
				_loc2_.icon = "disguise";
				_loc2_.description = this.m_lstrDescription;
				break;
			case CHALLENGEDESCRIPTION_MINIMAL: 
				_loc2_.header = this.m_lstrHeader;
				_loc2_.title = this.m_lstrTitle;
				_loc2_.icon = "disguise";
				_loc2_.description = this.m_lstrVerboseWarn;
				break;
			case CHALLENGEDESCRIPTION_OFF: 
				_loc2_.header = "";
				_loc2_.title = "";
				_loc2_.icon = "";
				_loc2_.description = this.m_lstrVerboseWarn;
			}
			this.m_detailTile.onSetData(_loc2_);
		}
		
		override protected function onPreviewBackgroundImageLoaded():void
		{
			super.onPreviewBackgroundImageLoaded();
			var _loc1_:Number = getPreviewBackgroundImage().width;
			var _loc2_:Number = getPreviewBackgroundImage().height;
			this.m_mask.graphics.clear();
			this.m_mask.graphics.beginFill(0);
			this.m_mask.graphics.drawRect(0, 0, _loc1_, _loc2_);
		}
	}
}
