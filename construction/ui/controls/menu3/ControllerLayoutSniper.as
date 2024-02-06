package menu3
{
	import common.CommonUtils;
	import common.Localization;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.display.MovieClip;
	import flash.text.TextFieldAutoSize;
	
	public dynamic class ControllerLayoutSniper extends MenuElementBase
	{
		
		private var m_view:ControllerLayoutSniperView;
		
		private var m_labelFontSize:Number = 20;
		
		private var m_labelFontType:String = "$medium";
		
		private var m_labelFontColor:String;
		
		private var m_altLabelFontSize:Number = 19;
		
		private var m_altLabelFontType:String = "$medium";
		
		private var m_altLabelFontColor:String;
		
		public function ControllerLayoutSniper(param1:Object)
		{
			this.m_labelFontColor = MenuConstants.FontColorWhite;
			this.m_altLabelFontColor = MenuConstants.FontColorWhite;
			super(param1);
			this.m_view = new ControllerLayoutSniperView();
			addChild(this.m_view);
		}
		
		override public function onSetData(param1:Object):void
		{
			var _loc3_:Object = null;
			var _loc4_:Object = null;
			var _loc2_:String = ControlsMain.getControllerType();
			CommonUtils.gotoFrameLabelAndStop(this.m_view, _loc2_);
			if (_loc2_ == "key")
			{
				return;
			}
			for each (_loc3_ in[{"clip": this.m_view.label0, "lstr": Localization.get("EUI_TEXT_BINDING_AIM")}, {"clip": this.m_view.label4, "lstr": Localization.get("EUI_TEXT_BINDING_ZOOM_IN")}, {"clip": this.m_view.label5, "lstr": Localization.get("EUI_TEXT_BINDING_NEXT_AMMO")}, {"clip": this.m_view.label7, "lstr": Localization.get("EUI_TEXT_BINDING_MENU")}, {"clip": this.m_view.label8, "lstr": Localization.get("EUI_TEXT_BINDING_NOTEBOOK")}, {"clip": this.m_view.label9, "lstr": Localization.get("EUI_TEXT_BINDING_ZOOM_OUT")}, {"clip": this.m_view.label10, "lstr": Localization.get("EUI_TEXT_BINDING_MOVE_CAMERA")}, {"clip": this.m_view.label11, "lstr": Localization.get("EUI_TEXT_BINDING_SHOOT")}, {"clip": this.m_view.label11_02, "lstr": Localization.get("EUI_TEXT_BINDING_PRECISION_AIM"), "hideIt": !ControllerLayout.isHoldModeForPrecisionAim()}, {"clip": this.m_view.label12, "lstr": Localization.get("EUI_TEXT_BINDING_RELOAD")}, {"clip": this.m_view.label13, "lstr": Localization.get("EUI_TEXT_BINDING_INSTINCT")}, {"clip": this.m_view.label14, "lstr": Localization.get("EUI_TEXT_BINDING_PRECISION_AIM")}])
			{
				if (_loc3_.clip != null)
				{
					_loc3_.clip.visible = !_loc3_.hideIt;
					MenuUtils.setupText(_loc3_.clip.label_txt, _loc3_.lstr, this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
				}
			}
			for each (_loc4_ in[{"clip": this.m_view.alt_control_instruction0, "lstr": Localization.get("EUI_TEXT_BINDING_HOLD"), "autoSize": TextFieldAutoSize.LEFT, "hideIt": !ControllerLayout.isHoldModeForWeaponAim()}, {"clip": this.m_view.alt_control_instruction11_02, "lstr": Localization.get("EUI_TEXT_BINDING_SQUEEZE"), "autoSize": TextFieldAutoSize.RIGHT, "hideIt": !ControllerLayout.isHoldModeForPrecisionAim()}, {"clip": this.m_view.alt_control_instruction13, "lstr": Localization.get("EUI_TEXT_BINDING_HOLD"), "autoSize": TextFieldAutoSize.RIGHT}, {"clip": this.m_view.alt_control_instruction14, "lstr": Localization.get("EUI_TEXT_BINDING_HOLD"), "autoSize": TextFieldAutoSize.LEFT, "hideIt": !ControllerLayout.isHoldModeForPrecisionAim()}])
			{
				if (_loc4_.clip != null)
				{
					_loc4_.clip.visible = !_loc4_.hideIt;
					MenuUtils.setupTextUpper(_loc4_.clip.alt_label_txt, _loc4_.lstr, this.m_altLabelFontSize, this.m_altLabelFontType, this.m_altLabelFontColor);
					_loc4_.clip.alt_label_txt.autoSize = _loc4_.autoSize;
				}
			}
			this.setBgColorAndSize([this.m_view.alt_control_instruction0, this.m_view.alt_control_instruction11_02, this.m_view.alt_control_instruction13, this.m_view.alt_control_instruction14]);
			if (ControllerLayout.isHoldModeForInstinctActivation())
			{
				this.m_view.alt_control_instruction13.y = this.m_view.label13.y + 28;
			}
			else
			{
				this.m_view.alt_control_instruction13.y = this.m_view.label12.y - 20;
			}
		}
		
		private function setBgColorAndSize(param1:Array):void
		{
			var _loc2_:MovieClip = null;
			for each (_loc2_ in param1)
			{
				if (_loc2_ != null)
				{
					_loc2_.alt_label_bg_mc.width = _loc2_.alt_label_txt.width + 5;
					MenuUtils.setColor(_loc2_.alt_label_bg_mc, MenuConstants.COLOR_MENU_TABS_BACKGROUND, true, MenuConstants.MenuElementBackgroundAlpha);
				}
			}
		}
		
		override public function onUnregister():void
		{
			if (this.m_view)
			{
				removeChild(this.m_view);
				this.m_view = null;
			}
		}
	}
}
