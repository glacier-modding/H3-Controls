// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.ControllerLayout

package menu3 {
import common.menu.MenuConstants;
import common.CommonUtils;

import flash.text.TextField;

import common.Localization;
import common.menu.MenuUtils;

import flash.text.TextFieldAutoSize;
import flash.display.MovieClip;
import flash.geom.Rectangle;
import flash.text.TextLineMetrics;

import __AS3__.vec.Vector;

import mx.utils.StringUtil;

import __AS3__.vec.*;

public dynamic class ControllerLayout extends MenuElementBase {

	private var m_view:ControllerLayoutView;
	private var m_labelFontSize:Number = 20;
	private var m_labelFontType:String = "$medium";
	private var m_labelFontColor:String = MenuConstants.FontColorWhite;
	private var m_altLabelFontSize:Number = 19;
	private var m_altLabelFontType:String = "$medium";
	private var m_altLabelFontColor:String = MenuConstants.FontColorWhite;

	public function ControllerLayout(_arg_1:Object):void {
		super(_arg_1);
		this.m_view = new ControllerLayoutView();
		addChild(this.m_view);
	}

	public static function isHoldModeForWeaponAim():Boolean {
		return (CommonUtils.getUIOptionValueNumber("UI_OPTION_GAME_AID_AIM_TOGGLE") == 0);
	}

	public static function isHoldModeForWalkSpeed():Boolean {
		return (CommonUtils.getUIOptionValueNumber("UI_OPTION_GAME_AID_WALK_SPEED_TOGGLE") == 0);
	}

	public static function isHoldModeForInstinctActivation():Boolean {
		return (CommonUtils.getUIOptionValueNumber("UI_OPTION_GAME_AID_INSTINCT_ACTIVATION_TOGGLE") == 0);
	}

	public static function isHoldModeForPrecisionAim():Boolean {
		return (CommonUtils.getUIOptionValueNumber("UI_OPTION_GAME_AID_PRECISION_AIM_TOGGLE") == 0);
	}

	public static function isHoldModeForItemPlacement():Boolean {
		return (CommonUtils.getUIOptionValueNumber("UI_OPTION_GAME_AID_ITEM_PLACEMENT_TOGGLE") == 0);
	}


	override public function onSetData(_arg_1:Object):void {
		var _local_2:String = ControlsMain.getControllerType();
		if (((_local_2 == CommonUtils.CONTROLLER_TYPE_PS4) && (ControlsMain.isVrModeActive()))) {
			CommonUtils.gotoFrameLabelAndStop(this.m_view, "ps4_vr");
			this.setVrControls(false);
			return;
		}
		;
		if (_local_2 == CommonUtils.CONTROLLER_TYPE_OCULUSVR) {
			CommonUtils.gotoFrameLabelAndStop(this.m_view, _local_2);
			this.setVrControls(true);
			return;
		}
		;
		CommonUtils.gotoFrameLabelAndStop(this.m_view, _local_2);
		if (((_local_2 == CommonUtils.CONTROLLER_TYPE_KEY) || (_local_2 == CommonUtils.CONTROLLER_TYPE_OPENVR))) {
			return;
		}
		;
		this.setRegularControls(_arg_1);
	}

	private function setVrControls(_arg_1:Boolean):void {
		var _local_2:Object;
		var _local_3:Object;
		var _local_4:TextField;
		var _local_5:TextField;
		var _local_6:Number;
		var _local_9:Number;
		for each (_local_2 in [{
			"clip": this.m_view.label0,
			"lstr": Localization.get("UI_VR_TEXT_BINDING_AIM_ITEMS")
		}, {
			"clip": this.m_view.label1,
			"lstr": Localization.get("UI_VR_TEXT_BINDING_RUN")
		}, {
			"clip": this.m_view.label2,
			"lstr": Localization.get("UI_VR_TEXT_BINDING_INSTINCT")
		}, {
			"clip": this.m_view.label3,
			"lstr": Localization.get("UI_VR_TEXT_BINDING_INVENTORY")
		}, {
			"clip": this.m_view.label4,
			"lstr": Localization.get("UI_VR_TEXT_BINDING_DROP_ITEM")
		}, {
			"clip": this.m_view.label5,
			"lstr": Localization.get("UI_VR_TEXT_BINDING_PLACE_ITEM")
		}, {
			"clip": this.m_view.label6,
			"lstr": Localization.get("UI_VR_TEXT_BINDING_MOVE")
		}, {
			"clip": this.m_view.label7,
			"lstr": Localization.get("UI_VR_TEXT_BINDING_ROTATE")
		}, {
			"clip": this.m_view.label8,
			"lstr": Localization.get("UI_VR_TEXT_BINDING_CROUCH")
		}, {
			"clip": this.m_view.label9,
			"lstr": ((Localization.get("UI_VR_TEXT_BINDING_SHOOT") + " / ") + Localization.get("UI_VR_TEXT_BINDING_THROW_ITEMS"))
		}, {
			"clip": this.m_view.label10,
			"lstr": Localization.get("UI_VR_TEXT_BINDING_CLOSE_COMBAT_PRIMING")
		}, {
			"clip": this.m_view.label11,
			"lstr": ((Localization.get("UI_VR_TEXT_BINDING_GRAB") + " / ") + Localization.get("UI_VR_TEXT_BINDING_DROP"))
		}, {
			"clip": this.m_view.label12,
			"lstr": Localization.get("UI_VR_TEXT_BINDING_INTERACT")
		}, {
			"clip": this.m_view.label13,
			"lstr": Localization.get("UI_VR_TEXT_BINDING_AGILITY_ACTIONS")
		}, {
			"clip": this.m_view.label14,
			"lstr": Localization.get("UI_VR_TEXT_BINDING_TAKE_DISGUISE")
		}, {
			"clip": this.m_view.label15,
			"lstr": Localization.get("UI_VR_TEXT_BINDING_RELOAD")
		}, {
			"clip": this.m_view.label16,
			"lstr": Localization.get("UI_VR_TEXT_BINDING_MENU")
		}, {
			"clip": this.m_view.label17,
			"lstr": Localization.get("UI_VR_TEXT_BINDING_NOTEBOOK")
		}, {
			"clip": this.m_view.label18,
			"lstr": Localization.get("UI_PREFERENCE_AIM_ASSIST")
		}, {
			"clip": this.m_view.label19,
			"lstr": ((Localization.get("UI_VR_TEXT_BINDING_INTERACT") + " / ") + Localization.get("UI_VR_TEXT_BINDING_RELOAD"))
		}, {
			"clip": this.m_view.label20,
			"lstr": Localization.get("UI_VR_TEXT_BINDING_SHOOT")
		}, {
			"clip": this.m_view.label23,
			"lstr": Localization.get("UI_VR_TEXT_BINDING_RECENTER")
		}]) {
			if (_local_2.clip != null) {
				MenuUtils.setupText(_local_2.clip.label_txt, _local_2.lstr, this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
			}
			;
		}
		;
		for each (_local_3 in [{
			"clip": this.m_view.alt_control_instruction0,
			"lstr": Localization.get("UI_VR_TEXT_BINDING_HOLD")
		}, {
			"clip": this.m_view.alt_control_instruction1,
			"lstr": Localization.get("UI_VR_TEXT_BINDING_HOLD"),
			"hideIt": (!(isHoldModeForWalkSpeed()))
		}, {
			"clip": this.m_view.alt_control_instruction3,
			"lstr": Localization.get("UI_VR_TEXT_BINDING_HOLD")
		}, {
			"clip": this.m_view.alt_control_instruction13,
			"lstr": Localization.get("UI_VR_TEXT_BINDING_HOLD")
		}, {
			"clip": this.m_view.alt_control_instruction19,
			"lstr": Localization.get("UI_VR_TEXT_BINDING_HOLD")
		}, {
			"clip": this.m_view.alt_control_instruction20,
			"lstr": Localization.get("UI_VR_TEXT_BINDING_HOLD"),
			"hideIt": (!(isHoldModeForInstinctActivation()))
		}, {
			"clip": this.m_view.alt_control_instruction21,
			"lstr": Localization.get("UI_VR_TEXT_BINDING_PRESS")
		}, {
			"clip": this.m_view.alt_control_instruction22,
			"lstr": Localization.get("UI_VR_TEXT_BINDING_PRESS")
		}, {
			"clip": this.m_view.alt_control_instruction23,
			"lstr": Localization.get("EUI_TEXT_BINDING_SQUEEZE")
		}, {
			"clip": this.m_view.alt_control_instruction24,
			"lstr": Localization.get("UI_VR_TEXT_BINDING_PRESS")
		}]) {
			if (_local_3.clip != null) {
				_local_3.clip.visible = (!(_local_3.hideIt));
				MenuUtils.setupTextUpper(_local_3.clip.alt_label_txt, _local_3.lstr, this.m_altLabelFontSize, this.m_altLabelFontType, this.m_altLabelFontColor);
			}
			;
		}
		;
		this.setBgColorAndSize([this.m_view.alt_control_instruction0, this.m_view.alt_control_instruction1, this.m_view.alt_control_instruction3, this.m_view.alt_control_instruction13, this.m_view.alt_control_instruction19, this.m_view.alt_control_instruction20, this.m_view.alt_control_instruction21, this.m_view.alt_control_instruction22, this.m_view.alt_control_instruction23, this.m_view.alt_control_instruction24]);
		this.checkOverlaps();
		_local_4 = new TextField();
		_local_4.name = "txtMissionStatus";
		addChild(_local_4);
		MenuUtils.setupText(_local_4, Localization.get("UI_VR_TEXT_MOTION_MISSION_STATUS"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
		_local_4.autoSize = TextFieldAutoSize.LEFT;
		_local_5 = new TextField();
		_local_5.name = "txtLookAtBackOfHand";
		addChild(_local_5);
		MenuUtils.setupTextUpper(_local_5, Localization.get("UI_VR_TEXT_MOTION_LOOK_AT_BACK_OF_HAND"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
		_local_5.autoSize = TextFieldAutoSize.LEFT;
		_local_6 = ((_arg_1) ? 230 : 700);
		var _local_7:Number = 630;
		var _local_8:Number = 6;
		_local_9 = Math.max(_local_4.width, _local_5.width);
		_local_4.x = (_local_6 - (_local_4.width / 2));
		_local_4.y = ((_local_7 - _local_4.height) - (_local_8 / 2));
		_local_5.x = (_local_6 - (_local_5.width / 2));
		_local_5.y = (_local_7 + (_local_8 / 2));
		graphics.beginFill(MenuConstants.COLOR_MENU_TABS_BACKGROUND, MenuConstants.MenuElementBackgroundAlpha);
		graphics.drawRect((_local_5.x - 3), _local_5.y, (_local_5.width + 6), _local_5.height);
		graphics.endFill();
		var _local_10:Number = (_local_6 - (_local_9 / 2));
		var _local_11:Number = (_local_6 + (_local_9 / 2));
		graphics.lineStyle(1, 0xFFFFFF, 0.8);
		graphics.moveTo(_local_11, (_local_7 - ((_local_4.height - _local_4.textHeight) / 2)));
		graphics.lineTo(_local_10, (_local_7 - ((_local_4.height - _local_4.textHeight) / 2)));
	}

	private function setRegularControls(_arg_1:Object):void {
		var _local_2:Object;
		MenuUtils.setupText(this.m_view.label0.label_txt, Localization.get("EUI_TEXT_BINDING_AIM"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
		MenuUtils.setupText(this.m_view.label1.label_txt, Localization.get("EUI_TEXT_BINDING_RUN"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
		MenuUtils.setupText(this.m_view.label2.label_txt, Localization.get("EUI_TEXT_BINDING_MOVE"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
		MenuUtils.setupText(this.m_view.label3.label_txt, Localization.get("EUI_TEXT_BINDING_CAMERA_SHOULDER"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
		MenuUtils.setupText(this.m_view.label4.label_txt, ((Localization.get("EUI_TEXT_BINDING_HOLSTER") + " / ") + Localization.get("EUI_TEXT_BINDING_UNHOLSTER")), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
		MenuUtils.setupText(this.m_view.label5.label_txt, (((_arg_1.emotesenabled) ? (Localization.get("EUI_TEXT_BINDING_EMOTE") + " / ") : "") + Localization.get("EUI_TEXT_BINDING_INVENTORY")), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
		MenuUtils.setupText(this.m_view.label6.label_txt, Localization.get("EUI_TEXT_BINDING_PLACE_ITEM"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
		MenuUtils.setupText(this.m_view.label7.label_txt, Localization.get("EUI_TEXT_BINDING_MENU"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
		MenuUtils.setupText(this.m_view.label8.label_txt, Localization.get("EUI_TEXT_BINDING_NOTEBOOK"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
		MenuUtils.setupText(this.m_view.label9.label_txt, Localization.get("EUI_TEXT_BINDING_DROP_ITEM"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
		MenuUtils.setupText(this.m_view.label10.label_txt, Localization.get("EUI_TEXT_BINDING_MOVE_CAMERA"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
		MenuUtils.setupText(this.m_view.label11.label_txt, Localization.get("EUI_TEXT_BINDING_SHOOT_THROW"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
		MenuUtils.setupText(this.m_view.label12.label_txt, Localization.get("EUI_TEXT_BINDING_RELOAD"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
		MenuUtils.setupText(this.m_view.label13.label_txt, Localization.get("EUI_TEXT_BINDING_INSTINCT"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
		MenuUtils.setupText(this.m_view.label14.label_txt, Localization.get("EUI_TEXT_BINDING_INTERACT"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
		MenuUtils.setupText(this.m_view.label15.label_txt, Localization.get("EUI_TEXT_BINDING_PICK_UP"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
		MenuUtils.setupText(this.m_view.label16.label_txt, ((Localization.get("EUI_TEXT_BINDING_TAKE_COVER") + " / ") + Localization.get("EUI_TEXT_BINDING_DROP_BODY")), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
		MenuUtils.setupText(this.m_view.label17.label_txt, Localization.get("EUI_TEXT_BINDING_DRAG_BODY"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
		MenuUtils.setupText(this.m_view.label18.label_txt, Localization.get("EUI_TEXT_BINDING_AGILITY_ACTIONS"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
		MenuUtils.setupText(this.m_view.label19.label_txt, Localization.get("EUI_TEXT_BINDING_TAKE_DISGUISE"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
		MenuUtils.setupText(this.m_view.label20.label_txt, Localization.get("EUI_TEXT_BINDING_MELEE"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
		MenuUtils.setupText(this.m_view.label21.label_txt, Localization.get("EUI_TEXT_BINDING_USE_ITEM"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
		MenuUtils.setupText(this.m_view.label22.label_txt, Localization.get("EUI_TEXT_BINDING_SNEAK"), this.m_labelFontSize, this.m_labelFontType, this.m_labelFontColor);
		for each (_local_2 in [{
			"clip": this.m_view.alt_control_instruction0,
			"lstr": Localization.get("EUI_TEXT_BINDING_HOLD"),
			"hideIt": (!(isHoldModeForWeaponAim()))
		}, {
			"clip": this.m_view.alt_control_instruction1,
			"lstr": Localization.get("EUI_TEXT_BINDING_HOLD"),
			"hideIt": (!(isHoldModeForWalkSpeed()))
		}, {
			"clip": this.m_view.alt_control_instruction3,
			"lstr": Localization.get("EUI_TEXT_BINDING_CLICK")
		}, {
			"clip": this.m_view.alt_control_instruction6,
			"lstr": Localization.get(((isHoldModeForItemPlacement()) ? "EUI_TEXT_BINDING_HOLD_BOTH" : "EUI_TEXT_BINDING_PRESS_BOTH"))
		}, {
			"clip": this.m_view.alt_control_instruction13,
			"lstr": Localization.get("EUI_TEXT_BINDING_HOLD"),
			"anchor": ((isHoldModeForInstinctActivation()) ? this.m_view.label13 : this.m_view.label12)
		}, {
			"clip": this.m_view.alt_control_instruction15,
			"lstr": Localization.get("EUI_TEXT_BINDING_HOLD")
		}, {
			"clip": this.m_view.alt_control_instruction17,
			"lstr": Localization.get("EUI_TEXT_BINDING_HOLD")
		}, {
			"clip": this.m_view.alt_control_instruction19,
			"lstr": Localization.get("EUI_TEXT_BINDING_HOLD")
		}, {
			"clip": this.m_view.alt_control_instruction21,
			"lstr": Localization.get("EUI_TEXT_BINDING_HOLD")
		}, {
			"clip": this.m_view.alt_control_instruction22,
			"lstr": Localization.get("EUI_TEXT_BINDING_CLICK")
		}]) {
			if (_local_2.clip != null) {
				_local_2.clip.visible = (!(_local_2.hideIt));
				if (_local_2.anchor != null) {
					_local_2.clip.y = (_local_2.anchor.y - 23);
				}
				;
				MenuUtils.setupTextUpper(_local_2.clip.alt_label_txt, _local_2.lstr, this.m_altLabelFontSize, this.m_altLabelFontType, this.m_altLabelFontColor);
			}
			;
		}
		;
		this.setBgColorAndSize([this.m_view.alt_control_instruction0, this.m_view.alt_control_instruction1, this.m_view.alt_control_instruction3, this.m_view.alt_control_instruction6, this.m_view.alt_control_instruction13, this.m_view.alt_control_instruction15, this.m_view.alt_control_instruction17, this.m_view.alt_control_instruction19, this.m_view.alt_control_instruction21, this.m_view.alt_control_instruction22]);
		this.checkOverlaps();
	}

	private function setBgColorAndSize(_arg_1:Array):void {
		var _local_2:MovieClip;
		for each (_local_2 in _arg_1) {
			if (_local_2 != null) {
				_local_2.alt_label_txt.autoSize = TextFieldAutoSize.RIGHT;
				_local_2.alt_label_bg_mc.width = (_local_2.alt_label_txt.width + 5);
				MenuUtils.setColor(_local_2.alt_label_bg_mc, MenuConstants.COLOR_MENU_TABS_BACKGROUND, true, MenuConstants.MenuElementBackgroundAlpha);
			}
			;
		}
		;
	}

	private function checkOverlaps():void {
		var _local_4:SizedItem;
		var _local_5:SizedItem;
		var _local_7:MovieClip;
		var _local_8:Rectangle;
		var _local_9:Number;
		var _local_10:TextLineMetrics;
		var _local_11:Number;
		var _local_12:Number;
		var _local_1:Vector.<SizedItem> = new Vector.<SizedItem>(0);
		var _local_2:Vector.<SizedItem> = new Vector.<SizedItem>(0);
		var _local_3:int;
		for (; _local_3 < this.m_view.numChildren; _local_3++) {
			_local_7 = (this.m_view.getChildAt(_local_3) as MovieClip);
			if (_local_7 != null) {
				_local_9 = 16;
				if (_local_7.name.search(/^label\d+$/) == 0) {
					if (((!(_local_7.visible)) || (StringUtil.trim(_local_7.label_txt.text).length == 0))) continue;
					_local_8 = _local_7.label_txt.getBounds(this);
					_local_10 = _local_7.label_txt.getLineMetrics(0);
					_local_11 = 2;
					_local_8.width = (_local_8.width * ((((2 * _local_11) + _local_10.width) + (2 * _local_10.x)) / _local_7.label_txt.width));
					_local_8.height = (_local_8.height * (((2 * _local_11) + _local_10.height) / _local_7.label_txt.height));
					_local_8.width = (_local_8.width + _local_9);
					_local_1.push(new SizedItem(_local_7, _local_8));
				} else {
					if (_local_7.name.search(/^alt_control_instruction\d+$/) == 0) {
						if (!((!(_local_7.visible)) || (StringUtil.trim(_local_7.alt_label_txt.text).length == 0))) {
							_local_8 = _local_7.getBounds(this);
							_local_8.x = (_local_8.x - _local_9);
							_local_8.width = (_local_8.width + _local_9);
							_local_2.push(new SizedItem(_local_7, _local_8));
						}
						;
					}
					;
				}
				;
			}
			;
		}
		;
		var _local_6:Number = 1;
		for each (_local_4 in _local_1) {
			for each (_local_5 in _local_2) {
				if (_local_4.rect.intersects(_local_5.rect)) {
					_local_12 = ((_local_5.mc.x - _local_4.mc.x) / (_local_4.rect.width + _local_5.rect.width));
					_local_6 = Math.min(_local_6, _local_12);
				}
				;
			}
			;
		}
		;
		for each (_local_4 in _local_1) {
			_local_4.mc.scaleX = (_local_4.mc.scaleX * _local_6);
		}
		;
		for each (_local_5 in _local_2) {
			_local_5.mc.scaleX = (_local_5.mc.scaleX * _local_6);
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

import flash.display.MovieClip;
import flash.geom.Rectangle;

class SizedItem {

	public var mc:MovieClip;
	public var rect:Rectangle;

	public function SizedItem(_arg_1:MovieClip, _arg_2:Rectangle) {
		this.mc = _arg_1;
		this.rect = _arg_2;
	}

}


