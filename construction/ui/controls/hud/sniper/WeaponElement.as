package hud.sniper
{
	import common.Animate;
	import common.BaseControl;
	import common.CommonUtils;
	import common.ImageLoader;
	import common.Localization;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.display.MovieClip;
	import flash.external.ExternalInterface;
	import flash.filters.*;
	
	public class WeaponElement extends BaseControl
	{
		
		private var m_view:WeaponElementView;
		
		private var m_loader:ImageLoader;
		
		private var m_currentWeaponImage:String = "";
		
		private var m_aPerks:Array;
		
		private var m_aAmmoTypes:Array;
		
		private var m_aAmmoLocaStrings:Array;
		
		private var m_aAmmoAdded:Array;
		
		private var m_currentAmmoType:int = -1;
		
		private var m_currentAmmoInGun:int;
		
		private var m_prevAmmoInClip:int;
		
		private var m_iconSpacing:Number = 35;
		
		private var m_iconSize:Number = 23;
		
		private var m_iconSizeSelected:Number = 38;
		
		private var m_initialAmmoTextPosition:Number;
		
		public function WeaponElement()
		{
			this.m_aPerks = [];
			this.m_aAmmoTypes = [];
			this.m_aAmmoLocaStrings = [];
			this.m_aAmmoAdded = [];
			super();
			this.m_view = new WeaponElementView();
			addChild(this.m_view);
			this.m_initialAmmoTextPosition = this.m_view.ammoname.ammo_txt.x;
		}
		
		public function onSetData(param1:Object):void
		{
			if (param1.weaponStatus.bHasItemToShow)
			{
				this.m_view.visible = true;
				if (this.m_currentWeaponImage != param1.weaponStatus.icon)
				{
					this.loadImage(param1.weaponStatus.icon);
				}
				if (param1.weaponStatus.aPerks)
				{
					if (String(param1.weaponStatus.aPerks) != String(this.m_aPerks))
					{
						this.setWeaponPerks(param1.weaponStatus.aPerks);
					}
				}
				if (param1.weaponStatus.aAmmoTypes)
				{
					if (String(param1.weaponStatus.aAmmoTypes) != String(this.m_aAmmoTypes))
					{
						this.setCurrentWeaponAmmo(param1.weaponStatus.aAmmoTypes);
					}
				}
				this.setWeaponAmmoInfo(param1.weaponStatus.nAmmoRemaining, param1.weaponStatus.nAmmoTotal, param1.weaponStatus.nAmmoInClip, param1.weaponStatus.nWeaponType, param1.weaponStatus.bCanReload, param1.weaponStatus.bIsReloading, param1.weaponStatus.fTimeBetweenBullets, param1.weaponStatus.nCurrentAmmoType);
			}
			else
			{
				this.m_view.visible = false;
			}
		}
		
		public function setWeaponAmmoInfo(param1:int, param2:int, param3:int, param4:Number, param5:Boolean, param6:Boolean, param7:Number, param8:int):void
		{
			var ammoTypeFrameAdd:int;
			var primaryBulletOnAmmoChange:Boolean = false;
			var k:int = 0;
			var m:int = 0;
			var j:int = 0;
			var chamberingSpeed:Number = NaN;
			var primaryBullet:Boolean = false;
			var i:int = 0;
			var nAmmoRemaining:int = param1;
			var nAmmoTotal:int = param2;
			var nAmmoInClip:int = param3;
			var nWeaponType:Number = param4;
			var bCanReload:Boolean = param5;
			var bIsReloading:Boolean = param6;
			var fTimeBetweenBullets:Number = param7;
			var nCurrentAmmoType:int = param8;
			if (this.m_currentAmmoInGun == nAmmoRemaining && !bIsReloading && this.m_currentAmmoType == nCurrentAmmoType)
			{
				return;
			}
			this.m_view.totalammo.gotoAndStop(nAmmoTotal == 999 ? 2 : 1);
			ammoTypeFrameAdd = 0;
			if (this.m_aAmmoTypes[nCurrentAmmoType] == "titaniumcomposite")
			{
				ammoTypeFrameAdd = 11;
			}
			else if (this.m_aAmmoTypes[nCurrentAmmoType] == "tacticalshock")
			{
				ammoTypeFrameAdd = 22;
			}
			if (nCurrentAmmoType != this.m_currentAmmoType && !bIsReloading)
			{
				this.setCurrentWeaponAmmoSelected(nCurrentAmmoType);
				this.playSound("ChangeAmmo");
				trace("WeaponElement | setWeaponAmmoInfo | CALLING SOUND PLAYBACK!??????");
				primaryBulletOnAmmoChange = false;
				k = 0;
				while (k < this.m_prevAmmoInClip)
				{
					Animate.kill(this.m_view.bullets["b_" + (k + 1)]);
					this.m_view.bullets["b_" + (k + 1)].gotoAndStop(0);
					k++;
				}
				this.m_view.bullets.gotoAndStop(nAmmoInClip + ammoTypeFrameAdd);
				m = 0;
				while (m < nAmmoInClip)
				{
					Animate.kill(this.m_view.bullets["b_" + (m + 1)]);
					this.m_view.bullets["b_" + (m + 1)].gotoAndStop(63);
					m++;
				}
				j = 0;
				while (j < nAmmoRemaining)
				{
					if (j == nAmmoRemaining - 1)
					{
						primaryBulletOnAmmoChange = true;
					}
					this.bulletsReload(this.m_view.bullets["b_" + (j + 1)], 0.5 * ((j + 1) / 10), primaryBulletOnAmmoChange);
					j++;
				}
			}
			else
			{
				if (bIsReloading)
				{
					return;
				}
				chamberingSpeed = fTimeBetweenBullets - 0.4;
				this.m_view.bullets.gotoAndStop(nAmmoInClip + ammoTypeFrameAdd);
				if (nAmmoRemaining == nAmmoInClip)
				{
					primaryBullet = false;
					i = 0;
					while (i < nAmmoInClip)
					{
						Animate.kill(this.m_view.bullets["b_" + (i + 1)]);
						if (i == nAmmoInClip - 1)
						{
							primaryBullet = true;
						}
						this.bulletsReload(this.m_view.bullets["b_" + (i + 1)], 0.5 * ((i + 1) / 10), primaryBullet);
						i++;
					}
				}
				else
				{
					Animate.fromTo(this.m_view.bullets["b_" + (nAmmoRemaining + 1)], 0.15, 0, {"frames": 43}, {"frames": 63}, Animate.ExpoIn);
					Animate.fromTo(this.m_view.bullets["b_" + nAmmoRemaining], chamberingSpeed, 0, {"frames": 2}, {"frames": 21}, Animate.Linear, function():void
					{
						Animate.fromTo(m_view.bullets["b_" + nAmmoRemaining], 0.25, 0, {"frames": 22}, {"frames": 42}, Animate.Linear);
					});
				}
			}
			this.m_currentAmmoInGun = nAmmoRemaining;
			this.m_prevAmmoInClip = nAmmoInClip;
		}
		
		private function bulletsReload(param1:MovieClip, param2:Number, param3:Boolean):void
		{
			var bullet:MovieClip = param1;
			var delay:Number = param2;
			var primaryBullet:Boolean = param3;
			Animate.delay(bullet, delay, function():void
			{
				if (primaryBullet)
				{
					Animate.fromTo(bullet, 0.25, 0, {"frames": 22}, {"frames": 42}, Animate.Linear);
				}
				else
				{
					bullet.gotoAndStop(42);
				}
			});
		}
		
		private function setCurrentWeaponAmmo(param1:Array):void
		{
			var _loc5_:WeaponElementPerkIconsView = null;
			this.m_aAmmoTypes = param1;
			this.m_aAmmoAdded = [];
			var _loc2_:int = -((param1.length - 1) * this.m_iconSpacing);
			var _loc3_:String = "";
			var _loc4_:int = 0;
			while (_loc4_ < param1.length)
			{
				_loc5_ = new WeaponElementPerkIconsView();
				this.m_aAmmoAdded.push(_loc5_);
				_loc5_.bg.alpha = 0.25;
				_loc3_ = param1[_loc4_] == "Default" ? "highpressure" : String(param1[_loc4_]);
				this.m_aAmmoLocaStrings[_loc4_] = "UI_ITEM_PERKS_" + _loc3_.toUpperCase() + "_NAME";
				_loc5_.icons.gotoAndStop(_loc3_);
				_loc5_.width = _loc5_.height = this.m_iconSize;
				_loc5_.x = _loc2_;
				this.m_view.ammotypes.addChild(_loc5_);
				_loc2_ += this.m_iconSpacing;
				_loc4_++;
			}
		}
		
		private function setCurrentWeaponAmmoSelected(param1:int):void
		{
			this.m_currentAmmoType = param1;
			var _loc2_:int = 0;
			while (_loc2_ < this.m_aAmmoAdded.length)
			{
				Animate.kill(this.m_aAmmoAdded[_loc2_]);
				MenuUtils.removeColor(this.m_aAmmoAdded[_loc2_].icons);
				this.m_aAmmoAdded[_loc2_].bg.alpha = 0.25;
				this.m_aAmmoAdded[_loc2_].width = this.m_aAmmoAdded[_loc2_].height = this.m_iconSize;
				_loc2_++;
			}
			MenuUtils.setColor(this.m_aAmmoAdded[param1].icons, MenuConstants.COLOR_GREY_ULTRA_DARK, false);
			this.m_aAmmoAdded[param1].bg.alpha = 1;
			MenuUtils.setupText(this.m_view.ammoname.ammo_txt, Localization.get(this.m_aAmmoLocaStrings[param1]), 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			CommonUtils.changeFontToGlobalIfNeeded(this.m_view.ammoname.ammo_txt);
			Animate.to(this.m_aAmmoAdded[param1], 0.3, 0, {"width": this.m_iconSizeSelected, "height": this.m_iconSizeSelected}, Animate.ExpoOut);
			Animate.kill(this.m_view.ammoname.ammo_txt);
			this.m_view.ammoname.ammo_txt.alpha = 0;
			Animate.to(this.m_view.ammoname.ammo_txt, 0.2, 0, {"alpha": 1}, Animate.ExpoOut);
			this.m_view.ammoname.ammo_txt.x = this.m_initialAmmoTextPosition;
			Animate.addFrom(this.m_view.ammoname.ammo_txt, 0.3, 0, {"x": this.m_initialAmmoTextPosition - 40}, Animate.ExpoOut);
		}
		
		private function setWeaponPerks(param1:Array):void
		{
			var _loc4_:WeaponElementPerkIconsView = null;
			this.m_aPerks = param1;
			var _loc2_:int = 0;
			var _loc3_:int = 0;
			while (_loc3_ < param1.length)
			{
				if (param1[_loc3_] != "tacticalshock")
				{
					if (param1[_loc3_] != "highpressure")
					{
						if (param1[_loc3_] != "titaniumcomposite")
						{
							(_loc4_ = new WeaponElementPerkIconsView()).bg.alpha = 0.25;
							_loc4_.icons.gotoAndStop(param1[_loc3_]);
							_loc4_.width = _loc4_.height = this.m_iconSize;
							_loc4_.y = _loc2_;
							this.m_view.perks.addChild(_loc4_);
							_loc2_ -= this.m_iconSpacing;
						}
					}
				}
				_loc3_++;
			}
		}
		
		private function loadImage(param1:String):void
		{
			var max_width:Number = NaN;
			var x_offset:Number = NaN;
			var imagePath:String = param1;
			this.m_currentWeaponImage = imagePath;
			if (this.m_loader != null)
			{
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
			this.m_loader.loadImage(imagePath, function():void
			{
				MenuUtils.trySetCacheAsBitmap(m_view.image, true);
				m_loader.visible = true;
				m_loader.rotation = 0;
				m_loader.scaleX = m_loader.scaleY = 1;
				var _loc1_:Number = m_loader.width / m_loader.height;
				if (_loc1_ > 1)
				{
					m_loader.rotation = -90;
					_loc1_ = 1 / _loc1_;
				}
				m_loader.width = max_width;
				m_loader.scaleY = m_loader.scaleX;
				m_loader.x = x_offset;
			});
		}
		
		public function playSound(param1:String):void
		{
			ExternalInterface.call("PlaySound", param1);
		}
	}
}
