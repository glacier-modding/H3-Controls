// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.OptionsInfoChallengeListPreview

package menu3.basic {
import flash.display.Shape;

import menu3.ChallengeDetailTile;

import common.Localization;
import common.CommonUtils;

public dynamic class OptionsInfoChallengeListPreview extends OptionsInfoPreview {

	private static const CHALLENGEDESCRIPTION_FULL:int = 0;
	private static const CHALLENGEDESCRIPTION_MINIMAL:int = 1;
	private static const CHALLENGEDESCRIPTION_OFF:int = 2;

	private var m_mask:Shape = new Shape();
	private var m_detailTile:ChallengeDetailTile = new ChallengeDetailTile({});
	private const m_lstrHeader:String = Localization.get("UI_MENU_PAGE_PROFILE_CHALLENGES_CATEGORY_COMMUNITY");
	private const m_lstrTitle:String = Localization.get("UI_CHALLENGES_PROLOGUE_BOARD_AS_GUARD_NAME");
	private const m_lstrDescription:String = Localization.get("UI_CHALLENGES_PROLOGUE_BOARD_AS_GUARD_DESC");
	private const m_lstrVerboseWarn:String = Localization.get("UI_MENU_PAGE_CHALLENGES_VERBOSITY_WARNING");

	public function OptionsInfoChallengeListPreview(_arg_1:Object) {
		super(_arg_1);
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
		this.onSetData(_arg_1);
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		var _local_2:Object = {
			"rewardsTitle": "Rewards",
			"unlocks": [],
			"status": "Not Accomplished",
			"rewards": []
		};
		switch (CommonUtils.getUIOptionValueNumber("UI_OPTION_GAME_AID_CHALLENGEDESCRIPTION")) {
			case CHALLENGEDESCRIPTION_FULL:
				_local_2.header = this.m_lstrHeader;
				_local_2.title = this.m_lstrTitle;
				_local_2.icon = "disguise";
				_local_2.description = this.m_lstrDescription;
				break;
			case CHALLENGEDESCRIPTION_MINIMAL:
				_local_2.header = this.m_lstrHeader;
				_local_2.title = this.m_lstrTitle;
				_local_2.icon = "disguise";
				_local_2.description = this.m_lstrVerboseWarn;
				break;
			case CHALLENGEDESCRIPTION_OFF:
				_local_2.header = "";
				_local_2.title = "";
				_local_2.icon = "";
				_local_2.description = this.m_lstrVerboseWarn;
				break;
		}

		this.m_detailTile.onSetData(_local_2);
	}

	override protected function onPreviewBackgroundImageLoaded():void {
		super.onPreviewBackgroundImageLoaded();
		var _local_1:Number = getPreviewBackgroundImage().width;
		var _local_2:Number = getPreviewBackgroundImage().height;
		this.m_mask.graphics.clear();
		this.m_mask.graphics.beginFill(0);
		this.m_mask.graphics.drawRect(0, 0, _local_1, _local_2);
	}


}
}//package menu3.basic

