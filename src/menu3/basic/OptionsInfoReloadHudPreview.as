// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.OptionsInfoReloadHudPreview

package menu3.basic {
import hud.Reticle;
import hud.Weapon;
import hud.WeaponHints;

import common.CommonUtils;

public dynamic class OptionsInfoReloadHudPreview extends OptionsInfoPreview {

	private static const WEAPONHUD_OFF:Number = 0;
	private static const WEAPONHUD_MINIMAL:Number = 1;
	private static const WEAPONHUD_FULL:Number = 2;
	private static const RELOADHUD_OFF:Number = 0;
	private static const RELOADHUD_MINIMAL:Number = 1;
	private static const RELOADHUD_FULL:Number = 2;

	private var m_reticle:Reticle = new Reticle();
	private var m_weapon:Weapon = new Weapon();
	private var m_weaponHints:WeaponHints = new WeaponHints();
	private var m_ridIcon:String;

	public function OptionsInfoReloadHudPreview(_arg_1:Object) {
		super(_arg_1);
		this.m_reticle.name = "m_reticle";
		this.m_weapon.name = "m_weapon";
		this.m_weaponHints.name = "m_weaponHints";
		this.m_reticle.scaleX = (this.m_reticle.scaleY = 0.5);
		this.m_weapon.scaleX = (this.m_weapon.scaleY = 0.5);
		this.m_weaponHints.scaleX = (this.m_weaponHints.scaleY = 0.5);
		this.m_reticle.x = 310;
		this.m_reticle.y = 162;
		this.m_weapon.x = 600;
		this.m_weapon.y = 335;
		this.m_weaponHints.x = 310;
		this.m_weaponHints.y = 216;
		this.m_reticle.setType(1);
		getPreviewContentContainer().addChild(this.m_reticle);
		getPreviewContentContainer().addChild(this.m_weapon);
		getPreviewContentContainer().addChild(this.m_weaponHints);
		this.onSetData(_arg_1);
	}

	override public function onSetData(_arg_1:Object):void {
		var _local_4:Object;
		super.onSetData(_arg_1);
		this.m_ridIcon = _arg_1.previewData.icon;
		var _local_2:Number = CommonUtils.getUIOptionValueNumber("UI_OPTION_GAME_AID_RELOAD_HUD");
		var _local_3:Number = CommonUtils.getUIOptionValueNumber("UI_OPTION_GAME_AID_WEAPON_HUD");
		if (_local_3 == WEAPONHUD_OFF) {
			this.m_weapon.visible = false;
		} else {
			this.m_weapon.visible = true;
			_local_4 = this.makeData(_local_3, _local_2);
			this.m_weapon.onSetData(_local_4);
			this.m_weaponHints.onSetData(_local_4);
		}

	}

	private function makeData(_arg_1:Number, _arg_2:Number):Object {
		return ({
			"weaponStatus": {
				"icon": this.m_ridIcon,
				"containedIcon": null,
				"sWeaponName": "ICA 19",
				"sContainedItemName": "",
				"nWeaponType": 0,
				"nItemHUDType": 0,
				"nAmmoRemaining": 0,
				"nAmmoTotal": 14,
				"nAmmoInClip": 14,
				"bSilenced": true,
				"bIsFirearm": true,
				"bHolstered": false,
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
			"nDisplayMode": _arg_2
		});
	}


}
}//package menu3.basic

