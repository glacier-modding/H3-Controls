// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.OptionsInfoSplashHintPreview

package menu3.basic {
import flash.display.Shape;

import menu3.splashhints.SplashHintBackground;
import menu3.splashhints.SplashHintContent;

import common.Localization;
import common.menu.MenuConstants;

public dynamic class OptionsInfoSplashHintPreview extends OptionsInfoPreview {

	private var m_mask:Shape = new Shape();
	private var m_overlay:Shape = new Shape();
	private var m_shBackground:SplashHintBackground = new SplashHintBackground();
	private var m_shContent:SplashHintContent = new SplashHintContent();
	private const m_lstrHeader:String = Localization.get("UI_AID_GLOBAL_HINTS_EXAMPLE_HEADER");
	private const m_lstrTitle:String = Localization.get("UI_AID_GLOBAL_HINTS_EXAMPLE_TITLE");
	private const m_lstrDescription:String = Localization.get("UI_AID_GLOBAL_HINTS_EXAMPLE_BODY");

	public function OptionsInfoSplashHintPreview(_arg_1:Object) {
		super(_arg_1);
		this.m_mask.name = "m_mask";
		getPreviewContentContainer().addChild(this.m_mask);
		getPreviewContentContainer().mask = this.m_mask;
		this.m_overlay.name = "m_overlay";
		getPreviewContentContainer().addChild(this.m_overlay);
		this.m_shBackground.name = "m_shBackground";
		getPreviewContentContainer().addChild(this.m_shBackground);
		this.m_shContent.name = "m_shContent";
		getPreviewContentContainer().addChild(this.m_shContent);
		this.m_shBackground.AnimationDelayIn = 0;
		this.m_shContent.AnimationDelayIn = 0;
		this.m_shBackground.AnimationDelayOut = 0;
		this.m_shContent.AnimationDelayOut = 0;
		this.onSetData(_arg_1);
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		if (!_arg_1.previewData.showGlobalHints) {
			this.m_overlay.visible = false;
			this.m_shBackground.hide();
			this.m_shContent.hide();
		} else {
			this.m_overlay.visible = true;
			this.m_shBackground.show();
			this.m_shContent.onSetData({
				"header": this.m_lstrHeader,
				"title": this.m_lstrTitle,
				"description": this.m_lstrDescription,
				"imageRID": "",
				"hinttype": MenuConstants.SPLASH_HINT_TYPE_GLOBAL,
				"iconID": "disguise"
			});
			this.m_shContent.show();
		}

	}

	override protected function onPreviewBackgroundImageLoaded():void {
		super.onPreviewBackgroundImageLoaded();
		var _local_1:Number = getPreviewBackgroundImage().width;
		var _local_2:Number = getPreviewBackgroundImage().height;
		this.m_mask.graphics.clear();
		this.m_mask.graphics.beginFill(0);
		this.m_mask.graphics.drawRect(0, 0, _local_1, _local_2);
		this.m_overlay.graphics.clear();
		this.m_overlay.graphics.beginFill(991039, 0.3);
		this.m_overlay.graphics.drawRect(-5, -5, (_local_1 + 10), (_local_2 + 10));
		this.m_shBackground.onSetSize(_local_1, _local_2);
		this.m_shContent.onSetSize(_local_1, _local_2);
	}


}
}//package menu3.basic

