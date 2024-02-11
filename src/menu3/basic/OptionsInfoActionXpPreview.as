// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.OptionsInfoActionXpPreview

package menu3.basic {
import common.Localization;

import hud.notification.ActionXpBar;

import flash.utils.clearInterval;
import flash.utils.setInterval;
import flash.utils.*;

public dynamic class OptionsInfoActionXpPreview extends OptionsInfoPreview {

	private const m_lstrDoorUnlocked:String = Localization.get("UI_CHALLENGES_GLOBAL_DOOR_UNLOCKED_NAME");

	private var m_actionXpBar:ActionXpBar = new ActionXpBar();
	private var m_idIntervalRefresh:uint = 0;

	public function OptionsInfoActionXpPreview(_arg_1:Object) {
		var _local_2:Number;
		super(_arg_1);
		this.m_actionXpBar.name = "m_actionXpBar";
		getPreviewContentContainer().addChild(this.m_actionXpBar);
		_local_2 = PX_PREVIEW_BACKGROUND_WIDTH;
		var _local_3:Number = ((_local_2 / 1920) * 1080);
		this.m_actionXpBar.x = (_local_2 / 2);
		this.m_actionXpBar.y = (_local_3 / 2);
		this.onSetData(_arg_1);
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		if (((!(_arg_1.previewData)) || (!(_arg_1.previewData.showXpNotification)))) {
			this.m_actionXpBar.visible = false;
			clearInterval(this.m_idIntervalRefresh);
			this.m_idIntervalRefresh = 0;
		} else {
			if (this.m_idIntervalRefresh == 0) {
				this.m_actionXpBar.visible = true;
				this.m_idIntervalRefresh = setInterval(this.showNotification, 3000);
				this.showNotification();
			}
			;
		}
		;
	}

	private function showNotification():void {
		this.m_actionXpBar.ShowNotification("", this.m_lstrDoorUnlocked, {"xpGain": 25});
	}

	override protected function onPreviewRemovedFromStage():void {
		clearInterval(this.m_idIntervalRefresh);
		this.m_idIntervalRefresh = 0;
		super.onPreviewRemovedFromStage();
	}


}
}//package menu3.basic

