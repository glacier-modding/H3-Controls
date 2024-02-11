// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.ControllerLayoutSniper

package menu3 {
import common.menu.MenuConstants;
import common.CommonUtils;
import common.Localization;
import common.menu.MenuUtils;

import flash.text.TextFieldAutoSize;
import flash.display.MovieClip;

public dynamic class ControllerLayoutSniper extends MenuElementBase {

	private var m_view:ControllerLayoutSniperView;
	private var m_labelFontSize:Number = 20;
	private var m_labelFontType:String = "$medium";
	private var m_labelFontColor:String = MenuConstants.FontColorWhite;
	private var m_altLabelFontSize:Number = 19;
	private var m_altLabelFontType:String = "$medium";
	private var m_altLabelFontColor:String = MenuConstants.FontColorWhite;

	public function ControllerLayoutSniper(_arg_1:Object):void {
		super(_arg_1);
		this.m_view = new ControllerLayoutSniperView();
		addChild(this.m_view);
	}

	override public function onSetData(_arg_1:Object):void {
		var _local_3:Object;
		var _local_4:Object;
		var _local_2:String = ControlsMain.getControllerType();
		CommonUtils.gotoFrameLabelAndStop(this.m_view, _local_2);
		if (_local_2 == "key") {
			return;
		}
		;
		for each (_local_3 in [{
			"clip": this.m_view.label0,
			"lstr": Localization.get("EUI_TEXT_BINDING_AIM")
		}, {
			"clip": this.m_view.label4,
			"lstr": Localization.get("EUI_TEXT_BINDING_ZOOM_IN")
		}, {
			"clip": this.m_view.label5,
			"lstr": Localization.get("EUI_TEXT_BINDING_NEXT_AMMO")
		}, {
			"clip": this.m_view.label7,
			"lstr": Localization.get("EUI_TEXT_BINDING_MENU")
		}, {
			"clip": this.m_view.label8,
			"lstr": Localization.get("EUI_TEXT_BINDING_NOTEBOOK")
		}, {
			"clip": this.m_view.label9,
			"lstr": Localization.get("EUI_TEXT_BINDING_ZOOM_OUT")
		}, {
			"clip": this.m_view.label10,
			"lstr": Localization.get("EUI_TEXT_BINDING_MOVE_CAMERA")
		}, {
			"clip": this.m_view.label11,
			"lstr": Localization.get("EUI_TEXT_BINDING_SHOOT")
		}, {
			"clip": this.m_view.label11_02,
			"lstr": Localization.get("EUI_TEXT_BINDING_PRECISION_AIM"),
			"hideIt": (!(ControllerLayout.isHoldModeForPrecisionAim()))
		}, {
			"clip": this.m_view.label12,
			"lstr": Localization.get("EUI_TEXT_BINDING_RELOAD")
		}, {
			"clip": this.m_view.label13,
			"lstr": Localization.get("EUI_TEXT_BINDING_INSTINCT")
		}, {
			"clip": this.m_view.label14,
			"lstr": Localization.get("EUI_TEXT_BINDING_PRECISION_AIM")
		}]) {
			if (_local_3.clip != null) {
				_local_3.clip.visible = (!(_local_3.hideIt));
				MenuUtils.setupText(_local_3.clip.label_txt, _local_3.lstr, this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
			}
			;
		}
		;
		for each (_local_4 in [{
			"clip": this.m_view.alt_control_instruction0,
			"lstr": Localization.get("EUI_TEXT_BINDING_HOLD"),
			"autoSize": TextFieldAutoSize.LEFT,
			"hideIt": (!(ControllerLayout.isHoldModeForWeaponAim()))
		}, {
			"clip": this.m_view.alt_control_instruction11_02,
			"lstr": Localization.get("EUI_TEXT_BINDING_SQUEEZE"),
			"autoSize": TextFieldAutoSize.RIGHT,
			"hideIt": (!(ControllerLayout.isHoldModeForPrecisionAim()))
		}, {
			"clip": this.m_view.alt_control_instruction13,
			"lstr": Localization.get("EUI_TEXT_BINDING_HOLD"),
			"autoSize": TextFieldAutoSize.RIGHT
		}, {
			"clip": this.m_view.alt_control_instruction14,
			"lstr": Localization.get("EUI_TEXT_BINDING_HOLD"),
			"autoSize": TextFieldAutoSize.LEFT,
			"hideIt": (!(ControllerLayout.isHoldModeForPrecisionAim()))
		}]) {
			if (_local_4.clip != null) {
				_local_4.clip.visible = (!(_local_4.hideIt));
				MenuUtils.setupTextUpper(_local_4.clip.alt_label_txt, _local_4.lstr, this.m_altLabelFontSize, this.m_altLabelFontType, this.m_altLabelFontColor);
				_local_4.clip.alt_label_txt.autoSize = _local_4.autoSize;
			}
			;
		}
		;
		this.setBgColorAndSize([this.m_view.alt_control_instruction0, this.m_view.alt_control_instruction11_02, this.m_view.alt_control_instruction13, this.m_view.alt_control_instruction14]);
		if (ControllerLayout.isHoldModeForInstinctActivation()) {
			this.m_view.alt_control_instruction13.y = (this.m_view.label13.y + 28);
		} else {
			this.m_view.alt_control_instruction13.y = (this.m_view.label12.y - 20);
		}
		;
	}

	private function setBgColorAndSize(_arg_1:Array):void {
		var _local_2:MovieClip;
		for each (_local_2 in _arg_1) {
			if (_local_2 != null) {
				_local_2.alt_label_bg_mc.width = (_local_2.alt_label_txt.width + 5);
				MenuUtils.setColor(_local_2.alt_label_bg_mc, MenuConstants.COLOR_MENU_TABS_BACKGROUND, true, MenuConstants.MenuElementBackgroundAlpha);
			}
			;
		}
		;
	}

	override public function onUnregister():void {
		if (this.m_view) {
			removeChild(this.m_view);
			this.m_view = null;
		}
		;
	}


}
}//package menu3

