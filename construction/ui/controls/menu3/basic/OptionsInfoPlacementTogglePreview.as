package menu3.basic
{
	import common.Localization;
	import common.menu.MenuConstants;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import hud.InteractionIndicator;
	
	public dynamic class OptionsInfoPlacementTogglePreview extends OptionsInfoHoldTogglePreview
	{
		
		private var m_placeIndicator:InteractionIndicator;
		
		public function OptionsInfoPlacementTogglePreview(param1:Object)
		{
			this.m_placeIndicator = new InteractionIndicator();
			super(param1);
			this.m_placeIndicator.name = "m_placeIndicator";
			getPreviewContentContainer().addChild(this.m_placeIndicator);
			this.m_placeIndicator.x = 340;
			this.m_placeIndicator.y = 202;
			this.m_placeIndicator.scaleX = 0.8;
			this.m_placeIndicator.scaleY = 0.7;
			this.m_placeIndicator.visible = false;
			if (!ControlsMain.isVrModeActive())
			{
				this.m_placeIndicator.filters = [new DropShadowFilter(2, 90, 0, 1, 4, 4, 0.5, BitmapFilterQuality.HIGH, false, false, false)];
			}
			this.onSetData(param1);
		}
		
		override public function onSetData(param1:Object):void
		{
			super.onSetData(param1);
			this.m_placeIndicator.onSetData({"m_eState": InteractionIndicator.STATE_AVAILABLE, "m_eTypeId": param1.previewData.interactionDataPlace.m_eTypeId, "m_nIconId": param1.previewData.interactionDataPlace.m_nIconId, "m_sGlyph": param1.previewData.interactionDataPlace.m_sGlyph, "m_fProgress": 0, "m_sLabel": Localization.get("EUI_TEXT_OPTIONS_GAMEPLAY_ITEM_PLACEMENT_PROMPT_LABEL"), "m_sDescription": "", "m_nFontSize": MenuConstants.INTERACTIONPROMPTSIZE_LARGE});
		}
		
		override protected function onPreviewSlideshowExitedFrameLabel(param1:String):void
		{
			super.onPreviewSlideshowExitedFrameLabel(param1);
			if (param1 == "aim-start")
			{
				this.m_placeIndicator.visible = true;
			}
			if (param1 == "aim-done")
			{
				this.m_placeIndicator.visible = false;
			}
		}
	}
}
