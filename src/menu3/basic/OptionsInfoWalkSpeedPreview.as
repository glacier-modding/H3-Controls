// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.OptionsInfoWalkSpeedPreview

package menu3.basic {
import hud.WalkSpeedIcon;

import flash.utils.setTimeout;

public dynamic class OptionsInfoWalkSpeedPreview extends OptionsInfoHoldTogglePreview {

	private var m_walkSpeedIcon:WalkSpeedIcon = new WalkSpeedIcon();

	public function OptionsInfoWalkSpeedPreview(_arg_1:Object) {
		var _local_2:Number;
		super(_arg_1);
		_local_2 = OptionsInfoPreview.PX_PREVIEW_BACKGROUND_WIDTH;
		var _local_3:Number = ((_local_2 / 1920) * 1080);
		this.m_walkSpeedIcon.name = "m_walkSpeedIcon";
		this.m_walkSpeedIcon.scaleX = 0.6;
		this.m_walkSpeedIcon.scaleY = 0.6;
		this.m_walkSpeedIcon.x = 30;
		this.m_walkSpeedIcon.y = (_local_3 - 25);
		getPreviewContentContainer().addChild(this.m_walkSpeedIcon);
		this.m_walkSpeedIcon.visible = _arg_1.previewData.showWalkSpeedIcon;
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		this.m_walkSpeedIcon.visible = _arg_1.previewData.showWalkSpeedIcon;
	}

	override protected function onPreviewSlideshowExitedFrameLabel(label:String):void {
		super.onPreviewSlideshowExitedFrameLabel(label);
		setTimeout(function ():void {
			var _local_1:Object;
			switch (label) {
				case "running-start":
					_local_1 = {
						"isVisible": true,
						"speed": "run"
					};
					break;
				case "running-done":
					_local_1 = {
						"isVisible": false,
						"speed": "run"
					};
					break;
				case "slow-start":
					_local_1 = {
						"isVisible": true,
						"speed": "slow"
					};
					break;
				case "slow-done":
					_local_1 = {
						"isVisible": false,
						"speed": "slow"
					};
					break;
			}
			;
			m_walkSpeedIcon.onSetData(_local_1);
		}, 150);
	}


}
}//package menu3.basic

