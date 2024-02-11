// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.OptionsInfoWeaponHudPreview

package menu3.basic {
import common.Localization;

import hud.Weapon;

import flash.text.TextField;
import flash.text.TextFormat;

import common.menu.MenuUtils;
import common.menu.MenuConstants;

import flash.text.TextFormatAlign;

import common.CommonUtils;

public dynamic class OptionsInfoWeaponHudPreview extends OptionsInfoPreview {

	private static const WEAPONHUD_OFF:Number = 0;
	private static const WEAPONHUD_MINIMAL:Number = 1;
	private static const WEAPONHUD_FULL:Number = 2;

	private const m_lstrWeaponHolstered:String = Localization.get("UI_AID_WEAPON_HUD_PREVIEW_HOLSTERED");
	private const m_lstrWeaponEquipped:String = Localization.get("UI_AID_WEAPON_HUD_PREVIEW_EQUIPPED");

	private var m_weaponHolstered:Weapon = new Weapon();
	private var m_weaponEquipped:Weapon = new Weapon();
	private var m_ridIcon:String;

	public function OptionsInfoWeaponHudPreview(_arg_1:Object) {
		var _local_4:TextField;
		var _local_5:TextFormat;
		super(_arg_1);
		var _local_2:TextField = new TextField();
		var _local_3:TextField = new TextField();
		this.m_weaponHolstered.name = "m_weaponHolstered";
		this.m_weaponEquipped.name = "m_weaponEquipped";
		_local_2.name = "txtWeaponHolstered";
		_local_3.name = "txtWeaponEquipped";
		this.m_weaponHolstered.scaleX = (this.m_weaponHolstered.scaleY = 0.5);
		this.m_weaponEquipped.scaleX = (this.m_weaponEquipped.scaleY = 0.5);
		_local_2.width = 300;
		_local_3.width = 300;
		MenuUtils.setupText(_local_2, this.m_lstrWeaponHolstered, 20, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		MenuUtils.setupText(_local_3, this.m_lstrWeaponEquipped, 20, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		for each (_local_4 in [_local_2, _local_3]) {
			_local_5 = _local_4.getTextFormat();
			_local_5.align = TextFormatAlign.CENTER;
			_local_4.setTextFormat(_local_5);
		}
		;
		this.m_weaponHolstered.x = 280;
		this.m_weaponHolstered.y = 335;
		this.m_weaponEquipped.x = 600;
		this.m_weaponEquipped.y = 335;
		_local_2.x = 0;
		_local_2.y = 352;
		_local_3.x = 320;
		_local_3.y = 352;
		getPreviewContentContainer().addChild(this.m_weaponHolstered);
		getPreviewContentContainer().addChild(this.m_weaponEquipped);
		getPreviewContentContainer().addChild(_local_2);
		getPreviewContentContainer().addChild(_local_3);
		this.onSetData(_arg_1);
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		this.m_ridIcon = _arg_1.previewData.icon;
		var _local_2:Number = CommonUtils.getUIOptionValueNumber("UI_OPTION_GAME_AID_WEAPON_HUD");
		if (_local_2 == WEAPONHUD_OFF) {
			this.m_weaponHolstered.visible = false;
			this.m_weaponEquipped.visible = false;
		} else {
			this.m_weaponHolstered.visible = true;
			this.m_weaponEquipped.visible = true;
			this.m_weaponHolstered.onSetData(this.makeData(_local_2, true));
			this.m_weaponEquipped.onSetData(this.makeData(_local_2, false));
		}
		;
	}

	private function makeData(_arg_1:Number, _arg_2:Boolean):Object {
		return ({
			"weaponStatus": {
				"icon": this.m_ridIcon,
				"containedIcon": null,
				"sWeaponName": "ICA 19",
				"sContainedItemName": "",
				"nWeaponType": 0,
				"nItemHUDType": 0,
				"nAmmoRemaining": 7,
				"nAmmoTotal": 14,
				"nAmmoInClip": 7,
				"bSilenced": true,
				"bIsFirearm": true,
				"bHolstered": _arg_2,
				"bCannotBeHolstered": false,
				"bHasItemToShow": true,
				"bSuspicious": false,
				"bIllegal": true,
				"bCanReload": true,
				"bIsReloading": false,
				"fReloadDuration": 1,
				"bInfiniteAmmo": false,
				"bIsContainer": false,
				"bContainsItem": false,
				"nContainedItemHUDType": 0,
				"bContainedItemIllegal": false,
				"bContainedItemSuspicious": false,
				"bContainedItemDetectedDuringFrisk": false,
				"fLastBulletFiredTime": 0,
				"fTimeBetweenBullets": 0.5,
				"aPerks": [],
				"aAmmoTypes": [],
				"nCurrentAmmoType": 0
			},
			"itemLeftHandStatus": {},
			"itemOnBackStatus": {},
			"bShowHolstered": (_arg_1 == WEAPONHUD_FULL),
			"nDisplayMode": 0
		});
	}


}
}//package menu3.basic

