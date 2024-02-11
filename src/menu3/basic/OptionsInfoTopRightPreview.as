// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.OptionsInfoTopRightPreview

package menu3.basic {
import common.Localization;

import flash.display.Shape;

import hud.ChallengeElement;
import hud.evergreen.EconomyWidget;

import flash.utils.clearInterval;
import flash.utils.setInterval;
import flash.utils.*;

public dynamic class OptionsInfoTopRightPreview extends OptionsInfoPreview {

	private const m_lstrTitle:String = Localization.get("UI_CHALLENGES_PROLOGUE_BOARD_AS_GUARD_NAME");

	private var m_mask:Shape = new Shape();
	private var m_challengeElement:ChallengeElement = new ChallengeElement();
	private var m_economyWidget:EconomyWidget = new EconomyWidget();
	private var m_imagePath:String;
	private var m_idIntervalRefresh:uint = 0;

	public function OptionsInfoTopRightPreview(_arg_1:Object) {
		var _local_2:Number;
		super(_arg_1);
		this.m_mask.name = "m_mask";
		getPreviewContentContainer().addChild(this.m_mask);
		getPreviewContentContainer().mask = this.m_mask;
		this.m_challengeElement.name = "m_challengeElement";
		getPreviewContentContainer().addChild(this.m_challengeElement);
		this.m_economyWidget.name = "m_economyWidget";
		getPreviewContentContainer().addChild(this.m_economyWidget);
		_local_2 = PX_PREVIEW_BACKGROUND_WIDTH;
		var _local_3:Number = ((_local_2 / 1920) * 1080);
		this.m_challengeElement.x = (_local_2 - 30);
		this.m_challengeElement.y = 30;
		this.m_economyWidget.x = (_local_2 - 30);
		this.m_economyWidget.y = 30;
		this.onSetData(_arg_1);
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		if (((!(_arg_1.previewData)) || (!(_arg_1.previewData.showChallengeNotificationWithImage)))) {
			this.m_challengeElement.visible = false;
			clearInterval(this.m_idIntervalRefresh);
			this.m_idIntervalRefresh = 0;
		} else {
			this.m_challengeElement.visible = true;
			this.m_imagePath = _arg_1.previewData.showChallengeNotificationWithImage;
			clearInterval(this.m_idIntervalRefresh);
			this.m_idIntervalRefresh = setInterval(this.showNotification, 5000);
			this.showNotification();
		}
		;
		if (((!(_arg_1.previewData)) || (!(_arg_1.previewData.showEvergreenEconomyWidget)))) {
			this.m_economyWidget.visible = false;
		} else {
			this.m_economyWidget.visible = true;
			this.m_economyWidget.onSetData(1234);
		}
		;
	}

	private function showNotification():void {
		this.m_challengeElement.onSetDataWithDelay({
			"title": this.m_lstrTitle,
			"total": 1,
			"count": 1,
			"completed": true,
			"timeRemaining": 4.5,
			"imagePath": this.m_imagePath
		}, 0.25);
	}

	override protected function onPreviewBackgroundImageLoaded():void {
		super.onPreviewBackgroundImageLoaded();
		var _local_1:Number = getPreviewBackgroundImage().width;
		var _local_2:Number = getPreviewBackgroundImage().height;
		this.m_mask.graphics.clear();
		this.m_mask.graphics.beginFill(0);
		this.m_mask.graphics.drawRect(0, 0, _local_1, _local_2);
	}

	override protected function onPreviewRemovedFromStage():void {
		clearInterval(this.m_idIntervalRefresh);
		this.m_idIntervalRefresh = 0;
		super.onPreviewRemovedFromStage();
	}


}
}//package menu3.basic

