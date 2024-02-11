// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.sniper.WeaponElement

package hud.sniper {
import common.BaseControl;
import common.ImageLoader;
import common.Animate;

import flash.display.MovieClip;

import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.Localization;
import common.CommonUtils;

import flash.external.ExternalInterface;
import flash.filters.*;

public class WeaponElement extends BaseControl {

	private var m_view:WeaponElementView;
	private var m_loader:ImageLoader;
	private var m_currentWeaponImage:String = "";
	private var m_aPerks:Array = [];
	private var m_aAmmoTypes:Array = [];
	private var m_aAmmoLocaStrings:Array = [];
	private var m_aAmmoAdded:Array = [];
	private var m_currentAmmoType:int = -1;
	private var m_currentAmmoInGun:int;
	private var m_prevAmmoInClip:int;
	private var m_iconSpacing:Number = 35;
	private var m_iconSize:Number = 23;
	private var m_iconSizeSelected:Number = 38;
	private var m_initialAmmoTextPosition:Number;

	public function WeaponElement() {
		this.m_view = new WeaponElementView();
		addChild(this.m_view);
		this.m_initialAmmoTextPosition = this.m_view.ammoname.ammo_txt.x;
	}

	public function onSetData(_arg_1:Object):void {
		if (_arg_1.weaponStatus.bHasItemToShow) {
			this.m_view.visible = true;
			if (this.m_currentWeaponImage != _arg_1.weaponStatus.icon) {
				this.loadImage(_arg_1.weaponStatus.icon);
			}

			if (_arg_1.weaponStatus.aPerks) {
				if (String(_arg_1.weaponStatus.aPerks) != String(this.m_aPerks)) {
					this.setWeaponPerks(_arg_1.weaponStatus.aPerks);
				}

			}

			if (_arg_1.weaponStatus.aAmmoTypes) {
				if (String(_arg_1.weaponStatus.aAmmoTypes) != String(this.m_aAmmoTypes)) {
					this.setCurrentWeaponAmmo(_arg_1.weaponStatus.aAmmoTypes);
				}

			}

			this.setWeaponAmmoInfo(_arg_1.weaponStatus.nAmmoRemaining, _arg_1.weaponStatus.nAmmoTotal, _arg_1.weaponStatus.nAmmoInClip, _arg_1.weaponStatus.nWeaponType, _arg_1.weaponStatus.bCanReload, _arg_1.weaponStatus.bIsReloading, _arg_1.weaponStatus.fTimeBetweenBullets, _arg_1.weaponStatus.nCurrentAmmoType);
		} else {
			this.m_view.visible = false;
		}

	}

	public function setWeaponAmmoInfo(nAmmoRemaining:int, nAmmoTotal:int, nAmmoInClip:int, nWeaponType:Number, bCanReload:Boolean, bIsReloading:Boolean, fTimeBetweenBullets:Number, nCurrentAmmoType:int):void {
		var primaryBulletOnAmmoChange:Boolean;
		var k:int;
		var m:int;
		var j:int;
		var chamberingSpeed:Number;
		var primaryBullet:Boolean;
		var i:int;
		if ((((this.m_currentAmmoInGun == nAmmoRemaining) && (!(bIsReloading))) && (this.m_currentAmmoType == nCurrentAmmoType))) {
			return;
		}

		this.m_view.totalammo.gotoAndStop(((nAmmoTotal == 999) ? 2 : 1));
		var ammoTypeFrameAdd:int;
		if (this.m_aAmmoTypes[nCurrentAmmoType] == "titaniumcomposite") {
			ammoTypeFrameAdd = 11;
		} else {
			if (this.m_aAmmoTypes[nCurrentAmmoType] == "tacticalshock") {
				ammoTypeFrameAdd = 22;
			}

		}

		if (((!(nCurrentAmmoType == this.m_currentAmmoType)) && (!(bIsReloading)))) {
			this.setCurrentWeaponAmmoSelected(nCurrentAmmoType);
			this.playSound("ChangeAmmo");
			trace("WeaponElement | setWeaponAmmoInfo | CALLING SOUND PLAYBACK!??????");
			primaryBulletOnAmmoChange = false;
			k = 0;
			while (k < this.m_prevAmmoInClip) {
				Animate.kill(this.m_view.bullets[("b_" + (k + 1))]);
				this.m_view.bullets[("b_" + (k + 1))].gotoAndStop(0);
				k = (k + 1);
			}

			this.m_view.bullets.gotoAndStop((nAmmoInClip + ammoTypeFrameAdd));
			m = 0;
			while (m < nAmmoInClip) {
				Animate.kill(this.m_view.bullets[("b_" + (m + 1))]);
				this.m_view.bullets[("b_" + (m + 1))].gotoAndStop(63);
				m = (m + 1);
			}

			j = 0;
			while (j < nAmmoRemaining) {
				if (j == (nAmmoRemaining - 1)) {
					primaryBulletOnAmmoChange = true;
				}

				this.bulletsReload(this.m_view.bullets[("b_" + (j + 1))], (0.5 * ((j + 1) / 10)), primaryBulletOnAmmoChange);
				j = (j + 1);
			}

		} else {
			if (bIsReloading) {
				return;
			}

			chamberingSpeed = (fTimeBetweenBullets - 0.4);
			this.m_view.bullets.gotoAndStop((nAmmoInClip + ammoTypeFrameAdd));
			if (nAmmoRemaining == nAmmoInClip) {
				primaryBullet = false;
				i = 0;
				while (i < nAmmoInClip) {
					Animate.kill(this.m_view.bullets[("b_" + (i + 1))]);
					if (i == (nAmmoInClip - 1)) {
						primaryBullet = true;
					}

					this.bulletsReload(this.m_view.bullets[("b_" + (i + 1))], (0.5 * ((i + 1) / 10)), primaryBullet);
					i = (i + 1);
				}

			} else {
				Animate.fromTo(this.m_view.bullets[("b_" + (nAmmoRemaining + 1))], 0.15, 0, {"frames": 43}, {"frames": 63}, Animate.ExpoIn);
				Animate.fromTo(this.m_view.bullets[("b_" + nAmmoRemaining)], chamberingSpeed, 0, {"frames": 2}, {"frames": 21}, Animate.Linear, function ():void {
					Animate.fromTo(m_view.bullets[("b_" + nAmmoRemaining)], 0.25, 0, {"frames": 22}, {"frames": 42}, Animate.Linear);
				});
			}

		}

		this.m_currentAmmoInGun = nAmmoRemaining;
		this.m_prevAmmoInClip = nAmmoInClip;
	}

	private function bulletsReload(bullet:MovieClip, delay:Number, primaryBullet:Boolean):void {
		Animate.delay(bullet, delay, function ():void {
			if (primaryBullet) {
				Animate.fromTo(bullet, 0.25, 0, {"frames": 22}, {"frames": 42}, Animate.Linear);
			} else {
				bullet.gotoAndStop(42);
			}

		});
	}

	private function setCurrentWeaponAmmo(_arg_1:Array):void {
		var _local_5:WeaponElementPerkIconsView;
		this.m_aAmmoTypes = _arg_1;
		this.m_aAmmoAdded = [];
		var _local_2:int = -((_arg_1.length - 1) * this.m_iconSpacing);
		var _local_3:* = "";
		var _local_4:int;
		while (_local_4 < _arg_1.length) {
			_local_5 = new WeaponElementPerkIconsView();
			this.m_aAmmoAdded.push(_local_5);
			_local_5.bg.alpha = 0.25;
			_local_3 = ((_arg_1[_local_4] == "Default") ? "highpressure" : _arg_1[_local_4]);
			this.m_aAmmoLocaStrings[_local_4] = (("UI_ITEM_PERKS_" + _local_3.toUpperCase()) + "_NAME");
			_local_5.icons.gotoAndStop(_local_3);
			_local_5.width = (_local_5.height = this.m_iconSize);
			_local_5.x = _local_2;
			this.m_view.ammotypes.addChild(_local_5);
			_local_2 = (_local_2 + this.m_iconSpacing);
			_local_4++;
		}

	}

	private function setCurrentWeaponAmmoSelected(_arg_1:int):void {
		this.m_currentAmmoType = _arg_1;
		var _local_2:int;
		while (_local_2 < this.m_aAmmoAdded.length) {
			Animate.kill(this.m_aAmmoAdded[_local_2]);
			MenuUtils.removeColor(this.m_aAmmoAdded[_local_2].icons);
			this.m_aAmmoAdded[_local_2].bg.alpha = 0.25;
			this.m_aAmmoAdded[_local_2].width = (this.m_aAmmoAdded[_local_2].height = this.m_iconSize);
			_local_2++;
		}

		MenuUtils.setColor(this.m_aAmmoAdded[_arg_1].icons, MenuConstants.COLOR_GREY_ULTRA_DARK, false);
		this.m_aAmmoAdded[_arg_1].bg.alpha = 1;
		MenuUtils.setupText(this.m_view.ammoname.ammo_txt, Localization.get(this.m_aAmmoLocaStrings[_arg_1]), 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		CommonUtils.changeFontToGlobalIfNeeded(this.m_view.ammoname.ammo_txt);
		Animate.to(this.m_aAmmoAdded[_arg_1], 0.3, 0, {
			"width": this.m_iconSizeSelected,
			"height": this.m_iconSizeSelected
		}, Animate.ExpoOut);
		Animate.kill(this.m_view.ammoname.ammo_txt);
		this.m_view.ammoname.ammo_txt.alpha = 0;
		Animate.to(this.m_view.ammoname.ammo_txt, 0.2, 0, {"alpha": 1}, Animate.ExpoOut);
		this.m_view.ammoname.ammo_txt.x = this.m_initialAmmoTextPosition;
		Animate.addFrom(this.m_view.ammoname.ammo_txt, 0.3, 0, {"x": (this.m_initialAmmoTextPosition - 40)}, Animate.ExpoOut);
	}

	private function setWeaponPerks(_arg_1:Array):void {
		var _local_4:WeaponElementPerkIconsView;
		this.m_aPerks = _arg_1;
		var _local_2:int;
		var _local_3:int;
		while (_local_3 < _arg_1.length) {
			if (_arg_1[_local_3] != "tacticalshock") {
				if (_arg_1[_local_3] != "highpressure") {
					if (_arg_1[_local_3] != "titaniumcomposite") {
						_local_4 = new WeaponElementPerkIconsView();
						_local_4.bg.alpha = 0.25;
						_local_4.icons.gotoAndStop(_arg_1[_local_3]);
						_local_4.width = (_local_4.height = this.m_iconSize);
						_local_4.y = _local_2;
						this.m_view.perks.addChild(_local_4);
						_local_2 = (_local_2 - this.m_iconSpacing);
					}

				}

			}

			_local_3++;
		}

	}

	private function loadImage(imagePath:String):void {
		var max_width:Number;
		var x_offset:Number;
		this.m_currentWeaponImage = imagePath;
		if (this.m_loader != null) {
			this.m_loader.cancel();
			this.m_view.image.removeChild(this.m_loader);
			this.m_loader = null;
		}

		this.m_loader = new ImageLoader();
		this.m_view.image.addChild(this.m_loader);
		MenuUtils.setColor(this.m_view.image, MenuConstants.COLOR_WHITE, false);
		max_width = 90;
		x_offset = -90;
		this.m_loader.visible = false;
		this.m_loader.loadImage(imagePath, function ():void {
			MenuUtils.trySetCacheAsBitmap(m_view.image, true);
			m_loader.visible = true;
			m_loader.rotation = 0;
			m_loader.scaleX = (m_loader.scaleY = 1);
			var _local_1:Number = (m_loader.width / m_loader.height);
			if (_local_1 > 1) {
				m_loader.rotation = -90;
				_local_1 = (1 / _local_1);
			}

			m_loader.width = max_width;
			m_loader.scaleY = m_loader.scaleX;
			m_loader.x = x_offset;
		});
	}

	public function playSound(_arg_1:String):void {
		ExternalInterface.call("PlaySound", _arg_1);
	}


}
}//package hud.sniper

