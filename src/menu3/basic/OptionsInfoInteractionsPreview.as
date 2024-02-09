package menu3.basic
{
	import basic.ButtonPromtUtil;
	import basic.IButtonPromptOwner;
	import common.CommonUtils;
	import common.Localization;
	import common.menu.MenuConstants;
	import hud.InteractionIndicator;
	
	public dynamic class OptionsInfoInteractionsPreview extends OptionsInfoPreview implements IButtonPromptOwner
	{
		
		private var m_indicator:InteractionIndicator;
		
		private const m_lstrLabel:String = Localization.get("EUI_TEXT_OPTIONS_GAMEPLAY_INTERACTION_PROMPT_EXAMPLE_LABEL");
		
		private const m_lstrDescription:String = Localization.get("EUI_TEXT_OPTIONS_GAMEPLAY_INTERACTION_PROMPT_EXAMPLE_DESCRIPTION");
		
		public function OptionsInfoInteractionsPreview(param1:Object)
		{
			this.m_indicator = new InteractionIndicator();
			super(param1);
			this.m_indicator.name = "m_indicator";
			getPreviewContentContainer().addChild(this.m_indicator);
			this.m_indicator.x = 251;
			this.m_indicator.y = 153;
			this.m_indicator.rotationX = 23;
			this.m_indicator.rotationY = 0;
			this.m_indicator.rotation = 0;
			ButtonPromtUtil.registerButtonPromptOwner(this);
			this.onSetData(param1);
		}
		
		override public function onSetData(param1:Object):void
		{
			super.onSetData(param1);
			this.refreshIndicator();
		}
		
		override public function updateButtonPrompts():void
		{
			this.refreshIndicator();
		}
		
		private function refreshIndicator():void
		{
			var _loc1_:Number = ControlsMain.getDisplaySize() == ControlsMain.DISPLAY_SIZE_SMALL ? MenuConstants.INTERACTIONPROMPTSIZE_FORCEDONSMALLDISPLAY : CommonUtils.getUIOptionValueNumber("UI_OPTION_GAME_AID_INTERACTION_PROMPT");
			var _loc2_:Number = 2;
			this.m_indicator.onSetData({"m_eState": InteractionIndicator.STATE_AVAILABLE, "m_eTypeId": InteractionIndicator.TYPE_HOLD, "m_nIconId": (ControlsMain.getControllerType() == CommonUtils.CONTROLLER_TYPE_KEY ? -1 : _loc2_), "m_sGlyph": "G", "m_fProgress": 0, "m_sLabel": this.m_lstrLabel, "m_sDescription": this.m_lstrDescription, "m_nFontSize": _loc1_});
		}
		
		override protected function onPreviewRemovedFromStage():void
		{
			ButtonPromtUtil.unregisterButtonPromptOwner(this);
			super.onPreviewRemovedFromStage();
		}
	}
}
