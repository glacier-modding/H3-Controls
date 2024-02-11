// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.OptionsInfoLowerRightPreview

package menu3.basic {
import hud.Weapon;

import common.ImageLoader;
import common.CommonUtils;

public dynamic class OptionsInfoLowerRightPreview extends OptionsInfoPreview {

	private static const WEAPONHUD_OFF:Number = 0;
	private static const WEAPONHUD_MINIMAL:Number = 1;
	private static const WEAPONHUD_FULL:Number = 2;

	private var m_weapon:Weapon = new Weapon();
	private var m_noSave:ImageLoader = new ImageLoader();
	private var m_ridWeaponIcon:String;
	private var m_ridNoSaveIcon:String;

	public function OptionsInfoLowerRightPreview(_arg_1:Object) {
		super(_arg_1);
		this.m_weapon.name = "m_weapon";
		this.m_noSave.name = "m_noSave";
		this.m_weapon.scaleX = (this.m_weapon.scaleY = 0.75);
		this.m_noSave.scaleX = (this.m_noSave.scaleY = 0.75);
		this.m_weapon.x = 600;
		this.m_weapon.y = 335;
		this.m_noSave.x = 560;
		this.m_noSave.y = 115;
		this.m_noSave.alpha = 0.5;
		getPreviewContentContainer().addChild(this.m_weapon);
		getPreviewContentContainer().addChild(this.m_noSave);
		this.onSetData(_arg_1);
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		this.m_ridWeaponIcon = _arg_1.previewData.weaponIcon;
		if (this.m_ridNoSaveIcon != _arg_1.previewData.noSaveIcon) {
			this.m_ridNoSaveIcon = _arg_1.previewData.noSaveIcon;
			this.m_noSave.loadImage(this.m_ridNoSaveIcon);
		}

		var _local_2:Number = CommonUtils.getUIOptionValueNumber("UI_OPTION_GAME_AID_WEAPON_HUD");
		var _local_3:Boolean = CommonUtils.getUIOptionValue("UI_OPTION_GAME_AUTOSAVE_HUD");
		if (_local_2 == WEAPONHUD_OFF) {
			this.m_weapon.visible = false;
		} else {
			this.m_weapon.visible = true;
			this.m_weapon.onSetData(this.makeWeaponData(_local_2));
		}

		this.m_noSave.visible = _local_3;
	}

	private function makeWeaponData(_arg_1:Number):Object {
		return ({
			"weaponStatus": {
				"icon": this.m_ridWeaponIcon,
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
				"bHolstered": true,
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

