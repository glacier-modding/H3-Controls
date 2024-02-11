// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.ProfileElement

package menu3.basic {
import menu3.MenuElementBase;

import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.Localization;
import common.CommonUtils;

public dynamic class ProfileElement extends MenuElementBase {

	public static const STATE_UNDEFINED:int = -1;
	public static const STATE_OFFLINE:int = 0;
	public static const STATE_ONLINE:int = 1;
	public static const STATE_CONNECTED:int = 2;

	private const BADGE_MAX_SIZE:Number = 40;

	private var m_view:ProfileElementView;
	private var m_badge:Badge;
	private var m_state:int = -1;
	private var m_profileLevel:int = 0;

	public function ProfileElement(_arg_1:Object) {
		super(_arg_1);
		this.m_view = new ProfileElementView();
		addChild(this.m_view);
		this.m_badge = new Badge();
		this.m_badge.setMaxSize(this.BADGE_MAX_SIZE);
		this.m_view.badgecontainer.addChild(this.m_badge);
		this.m_badge.visible = false;
	}

	override public function onUnregister():void {
		this.m_badge = null;
		this.m_view = null;
		super.onUnregister();
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
	}

	public function setProfileName(_arg_1:String):void {
		MenuUtils.setupProfileName(this.m_view.usertitle, _arg_1, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
	}

	public function setProfileLevel(_arg_1:int):void {
		if (this.m_profileLevel == _arg_1) {
			return;
		}
		;
		this.m_profileLevel = _arg_1;
		this.updateConnectionLine();
	}

	public function setState(_arg_1:int):void {
		if (this.m_state == _arg_1) {
			return;
		}
		;
		this.m_state = _arg_1;
		this.updateConnectionLine();
	}

	private function updateConnectionLine():void {
		var _local_2:String;
		if (this.m_state == STATE_UNDEFINED) {
			return;
		}
		;
		var _local_1:* = (this.m_profileLevel > 0);
		if (this.m_state == STATE_CONNECTED) {
			MenuUtils.setupTextUpper(this.m_view.onlineheader, Localization.get("UI_MENU_LOBBY_JOINED_TITLE"), 12, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorYellow);
			CommonUtils.changeFontToGlobalIfNeeded(this.m_view.onlineheader);
		} else {
			if (this.m_state == STATE_OFFLINE) {
				_local_1 = false;
				MenuUtils.setupTextUpper(this.m_view.onlineheader, Localization.get("UI_DIALOG_USER_OFFLINE"), 12, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorRed);
				CommonUtils.changeFontToGlobalIfNeeded(this.m_view.onlineheader);
			} else {
				if (this.m_state == STATE_ONLINE) {
					_local_2 = Localization.get("UI_DIALOG_USER_ONLINE");
					if (this.m_profileLevel > 0) {
						_local_2 = ((((_local_2 + " - ") + Localization.get("UI_DIALOG_ESCALATION_LEVEL")) + " ") + this.m_profileLevel.toFixed(0));
					}
					;
					MenuUtils.setupTextUpper(this.m_view.onlineheader, _local_2, 12, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorGreen);
					CommonUtils.changeFontToGlobalIfNeeded(this.m_view.onlineheader);
				}
				;
			}
			;
		}
		;
		this.updateBadgeLevel(this.m_profileLevel);
		this.m_badge.visible = _local_1;
		this.m_view.line.visible = _local_1;
	}

	private function updateBadgeLevel(_arg_1:int):void {
		this.m_badge.setLevel(_arg_1, true, false);
	}


}
}//package menu3.basic

