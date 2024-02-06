package menu3.basic
{
	import common.CommonUtils;
	import common.Localization;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import hud.Weapon;
	
	public dynamic class OptionsInfoWeaponHudPreview extends OptionsInfoPreview
	{
		
		private static const WEAPONHUD_OFF:Number = 0;
		
		private static const WEAPONHUD_MINIMAL:Number = 1;
		
		private static const WEAPONHUD_FULL:Number = 2;
		
		private const m_lstrWeaponHolstered:String = Localization.get("UI_AID_WEAPON_HUD_PREVIEW_HOLSTERED");
		
		private const m_lstrWeaponEquipped:String = Localization.get("UI_AID_WEAPON_HUD_PREVIEW_EQUIPPED");
		
		private var m_weaponHolstered:Weapon;
		
		private var m_weaponEquipped:Weapon;
		
		private var m_ridIcon:String;
		
		public function OptionsInfoWeaponHudPreview(param1:Object)
		{
			var _loc4_:TextField = null;
			var _loc5_:TextFormat = null;
			this.m_weaponHolstered = new Weapon();
			this.m_weaponEquipped = new Weapon();
			super(param1);
			var _loc2_:TextField = new TextField();
			var _loc3_:TextField = new TextField();
			this.m_weaponHolstered.name = "m_weaponHolstered";
			this.m_weaponEquipped.name = "m_weaponEquipped";
			_loc2_.name = "txtWeaponHolstered";
			_loc3_.name = "txtWeaponEquipped";
			this.m_weaponHolstered.scaleX = this.m_weaponHolstered.scaleY = 0.5;
			this.m_weaponEquipped.scaleX = this.m_weaponEquipped.scaleY = 0.5;
			_loc2_.width = 300;
			_loc3_.width = 300;
			MenuUtils.setupText(_loc2_, this.m_lstrWeaponHolstered, 20, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
			MenuUtils.setupText(_loc3_, this.m_lstrWeaponEquipped, 20, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
			for each (_loc4_ in[_loc2_, _loc3_])
			{
				(_loc5_ = _loc4_.getTextFormat()).align = TextFormatAlign.CENTER;
				_loc4_.setTextFormat(_loc5_);
			}
			this.m_weaponHolstered.x = 280;
			this.m_weaponHolstered.y = 335;
			this.m_weaponEquipped.x = 600;
			this.m_weaponEquipped.y = 335;
			_loc2_.x = 0;
			_loc2_.y = 352;
			_loc3_.x = 320;
			_loc3_.y = 352;
			getPreviewContentContainer().addChild(this.m_weaponHolstered);
			getPreviewContentContainer().addChild(this.m_weaponEquipped);
			getPreviewContentContainer().addChild(_loc2_);
			getPreviewContentContainer().addChild(_loc3_);
			this.onSetData(param1);
		}
		
		override public function onSetData(param1:Object):void
		{
			super.onSetData(param1);
			this.m_ridIcon = param1.previewData.icon;
			var _loc2_:Number = CommonUtils.getUIOptionValueNumber("UI_OPTION_GAME_AID_WEAPON_HUD");
			if (_loc2_ == WEAPONHUD_OFF)
			{
				this.m_weaponHolstered.visible = false;
				this.m_weaponEquipped.visible = false;
			}
			else
			{
				this.m_weaponHolstered.visible = true;
				this.m_weaponEquipped.visible = true;
				this.m_weaponHolstered.onSetData(this.makeData(_loc2_, true));
				this.m_weaponEquipped.onSetData(this.makeData(_loc2_, false));
			}
		}
		
		private function makeData(param1:Number, param2:Boolean):Object
		{
			return {"weaponStatus": {"icon": this.m_ridIcon, "containedIcon": null, "sWeaponName": "ICA 19", "sContainedItemName": "", "nWeaponType": 0, "nItemHUDType": 0, "nAmmoRemaining": 7, "nAmmoTotal": 14, "nAmmoInClip": 7, "bSilenced": true, "bIsFirearm": true, "bHolstered": param2, "bCannotBeHolstered": false, "bHasItemToShow": true, "bSuspicious": false, "bIllegal": true, "bCanReload": true, "bIsReloading": false, "fReloadDuration": 1, "bInfiniteAmmo": false, "bIsContainer": false, "bContainsItem": false, "nContainedItemHUDType": 0, "bContainedItemIllegal": false, "bContainedItemSuspicious": false, "bContainedItemDetectedDuringFrisk": false, "fLastBulletFiredTime": 0, "fTimeBetweenBullets": 0.5, "aPerks": [], "aAmmoTypes": [], "nCurrentAmmoType": 0}, "itemLeftHandStatus": {}, "itemOnBackStatus": {}, "bShowHolstered": param1 == WEAPONHUD_FULL, "nDisplayMode": 0};
		}
	}
}
