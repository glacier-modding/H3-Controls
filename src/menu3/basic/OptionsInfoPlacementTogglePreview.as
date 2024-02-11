// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.OptionsInfoPlacementTogglePreview

package menu3.basic {
import hud.InteractionIndicator;

import flash.filters.DropShadowFilter;
import flash.filters.BitmapFilterQuality;

import common.Localization;
import common.menu.MenuConstants;

public dynamic class OptionsInfoPlacementTogglePreview extends OptionsInfoHoldTogglePreview {

	private var m_placeIndicator:InteractionIndicator = new InteractionIndicator();

	public function OptionsInfoPlacementTogglePreview(_arg_1:Object) {
		super(_arg_1);
		this.m_placeIndicator.name = "m_placeIndicator";
		getPreviewContentContainer().addChild(this.m_placeIndicator);
		this.m_placeIndicator.x = 340;
		this.m_placeIndicator.y = 202;
		this.m_placeIndicator.scaleX = 0.8;
		this.m_placeIndicator.scaleY = 0.7;
		this.m_placeIndicator.visible = false;
		if (!ControlsMain.isVrModeActive()) {
			this.m_placeIndicator.filters = [new DropShadowFilter(2, 90, 0, 1, 4, 4, 0.5, BitmapFilterQuality.HIGH, false, false, false)];
		}
		;
		this.onSetData(_arg_1);
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		this.m_placeIndicator.onSetData({
			"m_eState": InteractionIndicator.STATE_AVAILABLE,
			"m_eTypeId": _arg_1.previewData.interactionDataPlace.m_eTypeId,
			"m_nIconId": _arg_1.previewData.interactionDataPlace.m_nIconId,
			"m_sGlyph": _arg_1.previewData.interactionDataPlace.m_sGlyph,
			"m_fProgress": 0,
			"m_sLabel": Localization.get("EUI_TEXT_OPTIONS_GAMEPLAY_ITEM_PLACEMENT_PROMPT_LABEL"),
			"m_sDescription": "",
			"m_nFontSize": MenuConstants.INTERACTIONPROMPTSIZE_LARGE
		});
	}

	override protected function onPreviewSlideshowExitedFrameLabel(_arg_1:String):void {
		super.onPreviewSlideshowExitedFrameLabel(_arg_1);
		if (_arg_1 == "aim-start") {
			this.m_placeIndicator.visible = true;
		}
		;
		if (_arg_1 == "aim-done") {
			this.m_placeIndicator.visible = false;
		}
		;
	}


}
}//package menu3.basic

