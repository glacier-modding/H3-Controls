package menu3.basic
{
	import common.CommonUtils;
	import hud.Reticle;
	import hud.Weapon;
	import hud.WeaponHints;
	
	public dynamic class OptionsInfoReloadHudPreview extends OptionsInfoPreview
	{
		
		private static const WEAPONHUD_OFF:Number = 0;
		
		private static const WEAPONHUD_MINIMAL:Number = 1;
		
		private static const WEAPONHUD_FULL:Number = 2;
		
		private static const RELOADHUD_OFF:Number = 0;
		
		private static const RELOADHUD_MINIMAL:Number = 1;
		
		private static const RELOADHUD_FULL:Number = 2;
		
		private var m_reticle:Reticle;
		
		private var m_weapon:Weapon;
		
		private var m_weaponHints:WeaponHints;
		
		private var m_ridIcon:String;
		
		public function OptionsInfoReloadHudPreview(param1:Object)
		{
			this.m_reticle = new Reticle();
			this.m_weapon = new Weapon();
			this.m_weaponHints = new WeaponHints();
			super(param1);
			this.m_reticle.name = "m_reticle";
			this.m_weapon.name = "m_weapon";
			this.m_weaponHints.name = "m_weaponHints";
			this.m_reticle.scaleX = this.m_reticle.scaleY = 0.5;
			this.m_weapon.scaleX = this.m_weapon.scaleY = 0.5;
			this.m_weaponHints.scaleX = this.m_weaponHints.scaleY = 0.5;
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
			this.onSetData(param1);
		}
		
		override public function onSetData(param1:Object):void
		{
			var _loc4_:Object = null;
			super.onSetData(param1);
			this.m_ridIcon = param1.previewData.icon;
			var _loc2_:Number = CommonUtils.getUIOptionValueNumber("UI_OPTION_GAME_AID_RELOAD_HUD");
			var _loc3_:Number = CommonUtils.getUIOptionValueNumber("UI_OPTION_GAME_AID_WEAPON_HUD");
			if (_loc3_ == WEAPONHUD_OFF)
			{
				this.m_weapon.visible = false;
			}
			else
			{
				this.m_weapon.visible = true;
				_loc4_ = this.makeData(_loc3_, _loc2_);
				this.m_weapon.onSetData(_loc4_);
				this.m_weaponHints.onSetData(_loc4_);
			}
		}
		
		private function makeData(param1:Number, param2:Number):Object
		{
			return {"weaponStatus": {"icon": this.m_ridIcon, "containedIcon": null, "sWeaponName": "ICA 19", "sContainedItemName": "", "nWeaponType": 0, "nItemHUDType": 0, "nAmmoRemaining": 0, "nAmmoTotal": 14, "nAmmoInClip": 14, "bSilenced": true, "bIsFirearm": true, "bHolstered": false, "bCannotBeHolstered": false, "bHasItemToShow": true, "bSuspicious": false, "bIllegal": true, "bCanReload": true, "bIsReloading": false, "fReloadDuration": 1, "bInfiniteAmmo": false, "bIsContainer": false, "bContainsItem": false, "nContainedItemHUDType": 0, "bContainedItemIllegal": false, "bContainedItemSuspicious": false, "bContainedItemDetectedDuringFrisk": false, "fLastBulletFiredTime": 0, "fTimeBetweenBullets": 0.5, "aPerks": [], "aAmmoTypes": [], "nCurrentAmmoType": 0}, "itemLeftHandStatus": {}, "itemOnBackStatus": {}, "bShowHolstered": param1 == WEAPONHUD_FULL, "nDisplayMode": param2};
		}
	}
}
