package hud
{
	import common.Animate;
	import common.BaseControl;
	import common.CommonUtils;
	import common.Localization;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	
	public class WeaponHints extends BaseControl
	{
		
		private var m_view:WeaponHintsView;
		
		private var m_reloadFlashTimes:int = 0;
		
		private var m_reloadUrgent:Boolean;
		
		private var m_lastWeaponData:Object;
		
		private var m_wasHolstered:Boolean;
		
		private var m_reloadAnimCalled:Boolean;
		
		private var m_reloadAnimIsRunning:Boolean;
		
		private var m_sniperModeIsEntered:Boolean;
		
		private var m_reloadTimerAnimCalled:Boolean;
		
		public function WeaponHints()
		{
			this.m_lastWeaponData = new Object();
			super();
			if (ControlsMain.isVrModeActive())
			{
				return;
			}
			this.m_view = new WeaponHintsView();
			MenuUtils.setupText(this.m_view.reloadHolder.reload_mc.reload_txt, Localization.get("EUI_TEXT_BUTTON_RELOAD"), 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraDark);
			CommonUtils.changeFontToGlobalIfNeeded(this.m_view.reloadHolder.reload_mc.reload_txt);
			this.m_view.reloadHolder.reload_mc.visible = false;
			this.m_view.reloadTimerMc.visible = false;
			this.m_view.bulletChamberingTimerMc.visible = false;
			addChild(this.m_view);
		}
		
		public function onSetData(param1:Object):void
		{
			if (ControlsMain.isVrModeActive())
			{
				return;
			}
			this.m_view.visible = param1.nDisplayMode == 2 ? true : false;
			var _loc2_:Object = param1.weaponStatus;
			if (_loc2_.bHasItemToShow)
			{
				if (_loc2_.bHolstered)
				{
					this.m_view.reloadHolder.reload_mc.visible = false;
					this.pulsateReloadMc(0, false);
					this.m_reloadUrgent = false;
					this.m_wasHolstered = true;
				}
				else if (_loc2_.bIsFirearm)
				{
					if (this.m_lastWeaponData.nAmmoRemaining != _loc2_.nAmmoRemaining || this.m_lastWeaponData.nAmmoTotal != _loc2_.nAmmoTotal || this.m_lastWeaponData.nAmmoInClip != _loc2_.nAmmoInClip || this.m_lastWeaponData.nWeaponType != _loc2_.nWeaponType || this.m_lastWeaponData.icon != _loc2_.icon)
					{
						this.setWeaponAmmoInfo(_loc2_.nAmmoRemaining, _loc2_.nAmmoTotal, _loc2_.nAmmoInClip, _loc2_.nWeaponType, _loc2_.bCanReload, _loc2_.bIsReloading);
					}
					else if (this.m_lastWeaponData.nAmmoRemaining == _loc2_.nAmmoRemaining && this.m_lastWeaponData.nAmmoTotal == _loc2_.nAmmoTotal && this.m_lastWeaponData.nAmmoInClip == _loc2_.nAmmoInClip && this.m_lastWeaponData.nWeaponType == _loc2_.nWeaponType && this.m_lastWeaponData.icon == _loc2_.icon)
					{
						if (this.m_wasHolstered)
						{
							this.setWeaponAmmoInfo(_loc2_.nAmmoRemaining, _loc2_.nAmmoTotal, _loc2_.nAmmoInClip, _loc2_.nWeaponType, _loc2_.bCanReload, _loc2_.bIsReloading);
						}
					}
					if (_loc2_.nWeaponType == 4 && _loc2_.bIsReloading && !this.m_reloadTimerAnimCalled && _loc2_.fReloadDuration > 0)
					{
						this.runReloadTimer(_loc2_.fReloadDuration, _loc2_.nAmmoInClip, _loc2_.nAmmoRemaining, _loc2_.nCurrentAmmoType, true);
					}
					else if (_loc2_.nWeaponType == 4 && _loc2_.fTimeBetweenBullets > 0 && this.m_sniperModeIsEntered)
					{
						this.runBulletChamberingTimer(_loc2_.fTimeBetweenBullets, _loc2_.nAmmoInClip, _loc2_.nAmmoRemaining, _loc2_.nCurrentAmmoType, true);
					}
					if (this.m_wasHolstered)
					{
						this.m_wasHolstered = false;
					}
				}
			}
			this.m_lastWeaponData = _loc2_;
		}
		
		private function setWeaponAmmoInfo(param1:int, param2:int, param3:int, param4:Number, param5:Boolean = true, param6:Boolean = false):void
		{
			this.m_reloadAnimCalled = false;
			if (param6)
			{
				this.m_view.reloadHolder.reload_mc.visible = false;
				this.pulsateReloadMc(0, false);
				this.m_reloadUrgent = false;
			}
			else if (param1 >= 0 && param2 >= 0)
			{
				if (param5)
				{
					this.m_view.reloadHolder.reload_mc.visible = false;
					this.pulsateReloadMc(0, false);
					this.m_reloadUrgent = false;
					if (param2 > 0)
					{
						if (param1 == 1 && param3 != 1)
						{
							this.m_reloadAnimCalled = true;
							this.m_view.reloadHolder.reload_mc.visible = true;
							this.pulsateReloadMc(0.15, true);
						}
						else if (param1 == 0)
						{
							this.m_reloadAnimCalled = true;
							this.m_view.reloadHolder.reload_mc.visible = true;
							this.m_reloadUrgent = true;
							this.pulsateReloadMc(0.15, true);
						}
					}
				}
			}
		}
		
		private function pulsateReloadMc(param1:Number, param2:Boolean):void
		{
			this.m_reloadAnimIsRunning = false;
			Animate.kill(this);
			Animate.kill(this.m_view.reloadHolder.reload_mc.reload_txt);
			Animate.kill(this.m_view.reloadHolder.reload_mc.bg);
			MenuUtils.removeTint(this.m_view.reloadHolder.reload_mc.bg);
			if (this.m_reloadUrgent)
			{
				MenuUtils.setTintColor(this.m_view.reloadHolder.reload_mc.reload_txt, MenuUtils.TINT_COLOR_WHITE, false);
			}
			else
			{
				MenuUtils.setTintColor(this.m_view.reloadHolder.reload_mc.reload_txt, MenuUtils.TINT_COLOR_ULTRA_DARK_GREY, false);
			}
			this.m_view.reloadHolder.reload_mc.bg.alpha = 1;
			this.m_reloadFlashTimes = 6;
			if (param2)
			{
				this.m_reloadAnimIsRunning = true;
				if (this.m_reloadUrgent)
				{
					MenuUtils.setTintColor(this.m_view.reloadHolder.reload_mc.bg, MenuUtils.TINT_COLOR_MAGENTA_DARK, false);
				}
				Animate.delay(this, param1, this.pulsateFadeIn, param1);
			}
		}
		
		private function pulsateFadeIn(param1:Number):void
		{
			if (this.m_reloadFlashTimes <= 0)
			{
				if (!(this.m_sniperModeIsEntered && this.m_reloadUrgent))
				{
					this.pulsateReloadMc(0, false);
					this.m_view.reloadHolder.reload_mc.visible = false;
					return;
				}
				this.m_reloadFlashTimes = 6;
			}
			if (this.m_reloadUrgent)
			{
				MenuUtils.setTintColor(this.m_view.reloadHolder.reload_mc.reload_txt, MenuUtils.TINT_COLOR_MAGENTA_DARK, false);
			}
			else
			{
				MenuUtils.setTintColor(this.m_view.reloadHolder.reload_mc.reload_txt, MenuUtils.TINT_COLOR_YELLOW_LIGHT, false);
			}
			this.m_view.reloadHolder.reload_mc.bg.alpha = 0;
			Animate.delay(this, param1, this.pulsateFadeOut, param1);
			--this.m_reloadFlashTimes;
		}
		
		private function pulsateFadeOut(param1:Number):void
		{
			if (this.m_reloadFlashTimes <= 0)
			{
				if (!(this.m_sniperModeIsEntered && this.m_reloadUrgent))
				{
					this.pulsateReloadMc(0, false);
					this.m_view.reloadHolder.reload_mc.visible = false;
					return;
				}
				this.m_reloadFlashTimes = 6;
			}
			if (this.m_reloadUrgent)
			{
				MenuUtils.setTintColor(this.m_view.reloadHolder.reload_mc.reload_txt, MenuUtils.TINT_COLOR_WHITE, false);
			}
			else
			{
				MenuUtils.setTintColor(this.m_view.reloadHolder.reload_mc.reload_txt, MenuUtils.TINT_COLOR_ULTRA_DARK_GREY, false);
			}
			this.m_view.reloadHolder.reload_mc.bg.alpha = 1;
			Animate.delay(this, param1, this.pulsateFadeIn, param1);
			--this.m_reloadFlashTimes;
		}
		
		private function runReloadTimer(param1:Number, param2:int, param3:int, param4:int, param5:Boolean):void
		{
			var nAmmoTypeFrameOffset:int = 0;
			var duration:Number = param1;
			var nAmmoInClip:int = param2;
			var nAmmoRemaining:int = param3;
			var nCurrentAmmoType:int = param4;
			var start:Boolean = param5;
			this.m_view.reloadTimerMc.visible = false;
			Animate.kill(this.m_view.reloadTimerMc.bulletActiveMc);
			Animate.kill(this.m_view.reloadTimerMc.bulletsStaticMc);
			Animate.kill(this.m_view.reloadTimerMc.bulletActiveMc.bulletAnimMc);
			Animate.kill(this.m_view.reloadTimerMc.bar);
			Animate.kill(this.m_view.reloadTimerMc);
			if (start)
			{
				if (this.m_reloadAnimIsRunning)
				{
					this.m_view.reloadHolder.reload_mc.visible = false;
					this.pulsateReloadMc(0, false);
					this.m_reloadUrgent = false;
				}
				this.m_reloadTimerAnimCalled = true;
				nAmmoTypeFrameOffset = 0;
				this.m_view.reloadTimerMc.bulletActiveMc.gotoAndStop(1);
				if (nCurrentAmmoType == 1)
				{
					this.m_view.reloadTimerMc.bulletActiveMc.gotoAndStop(2);
					nAmmoTypeFrameOffset = 14;
				}
				else if (nCurrentAmmoType == 2)
				{
					this.m_view.reloadTimerMc.bulletActiveMc.gotoAndStop(3);
					nAmmoTypeFrameOffset = 28;
				}
				this.m_view.reloadTimerMc.alpha = 1;
				this.m_view.reloadTimerMc.bar.scaleX = 0;
				this.m_view.reloadTimerMc.bulletActiveMc.y = 23;
				this.m_view.reloadTimerMc.bulletActiveMc.bulletAnimMc.gotoAndStop(0);
				this.m_view.reloadTimerMc.bulletsStaticMc.y = 37;
				this.m_view.reloadTimerMc.bulletsStaticMc.gotoAndStop(nAmmoRemaining + nAmmoTypeFrameOffset);
				this.m_view.reloadTimerMc.visible = true;
				Animate.to(this.m_view.reloadTimerMc.bulletsStaticMc, duration - 0.1, 0, {"frames": nAmmoInClip + nAmmoTypeFrameOffset}, Animate.Linear, function():void
				{
					Animate.to(m_view.reloadTimerMc.bulletActiveMc.bulletAnimMc, 0.1, 0, {"frames": 21}, Animate.Linear);
					Animate.to(m_view.reloadTimerMc.bulletActiveMc, 0.1, 0, {"y": -1}, Animate.ExpoOut);
					Animate.to(m_view.reloadTimerMc.bulletsStaticMc, 0.1, 0, {"y": 23}, Animate.ExpoOut);
				});
				Animate.to(this.m_view.reloadTimerMc.bar, duration, 0, {"scaleX": 2.1}, Animate.Linear, function():void
				{
					Animate.to(m_view.reloadTimerMc, 0.2, 0, {"alpha": 0}, Animate.ExpoOut);
					m_reloadTimerAnimCalled = false;
				});
			}
		}
		
		private function runBulletChamberingTimer(param1:Number, param2:int, param3:int, param4:int, param5:Boolean):void
		{
			var nAmmoTypeFrameOffset:int = 0;
			var duration:Number = param1;
			var nAmmoInClip:int = param2;
			var nAmmoRemaining:int = param3;
			var nCurrentAmmoType:int = param4;
			var start:Boolean = param5;
			this.m_view.bulletChamberingTimerMc.visible = false;
			Animate.kill(this.m_view.bulletChamberingTimerMc.bulletActiveMc);
			Animate.kill(this.m_view.bulletChamberingTimerMc.bulletsStaticMc);
			Animate.kill(this.m_view.bulletChamberingTimerMc.bulletActiveMc.bulletAnimMc);
			Animate.kill(this.m_view.bulletChamberingTimerMc.bar);
			Animate.kill(this.m_view.bulletChamberingTimerMc);
			if (start)
			{
				if (nAmmoRemaining < 1 || nAmmoInClip == nAmmoRemaining)
				{
					return;
				}
				nAmmoTypeFrameOffset = 0;
				this.m_view.bulletChamberingTimerMc.bulletActiveMc.gotoAndStop(1);
				if (nCurrentAmmoType == 1)
				{
					this.m_view.bulletChamberingTimerMc.bulletActiveMc.gotoAndStop(2);
					nAmmoTypeFrameOffset = 14;
				}
				else if (nCurrentAmmoType == 2)
				{
					this.m_view.bulletChamberingTimerMc.bulletActiveMc.gotoAndStop(3);
					nAmmoTypeFrameOffset = 28;
				}
				this.m_view.bulletChamberingTimerMc.alpha = 1;
				this.m_view.bulletChamberingTimerMc.bar.scaleX = 0;
				this.m_view.bulletChamberingTimerMc.bulletActiveMc.y = 23;
				this.m_view.bulletChamberingTimerMc.bulletActiveMc.bulletAnimMc.gotoAndStop(0);
				this.m_view.bulletChamberingTimerMc.bulletsStaticMc.y = 37;
				this.m_view.bulletChamberingTimerMc.bulletsStaticMc.gotoAndStop(nAmmoRemaining + nAmmoTypeFrameOffset);
				this.m_view.bulletChamberingTimerMc.visible = true;
				Animate.to(this.m_view.bulletChamberingTimerMc.bulletActiveMc, 0.1, duration - 0.1, {"y": -1}, Animate.ExpoOut);
				Animate.to(this.m_view.bulletChamberingTimerMc.bulletsStaticMc, 0.1, duration - 0.1, {"y": 23}, Animate.ExpoOut);
				Animate.to(this.m_view.bulletChamberingTimerMc.bulletActiveMc.bulletAnimMc, 0.1, duration - 0.1, {"frames": 21}, Animate.Linear);
				Animate.to(this.m_view.bulletChamberingTimerMc.bar, duration, 0, {"scaleX": 2.1}, Animate.Linear, function():void
				{
					Animate.to(m_view.bulletChamberingTimerMc, 0.2, 0, {"alpha": 0}, Animate.ExpoOut);
				});
			}
		}
		
		public function EnterSniperMode():void
		{
			if (ControlsMain.isVrModeActive())
			{
				return;
			}
			this.m_sniperModeIsEntered = true;
			if (this.m_reloadAnimCalled && this.m_reloadUrgent)
			{
				if (this.m_reloadAnimIsRunning)
				{
					this.m_reloadFlashTimes = 6;
				}
				else
				{
					Animate.kill(this);
					Animate.delay(this, 0.6, function():void
					{
						m_view.reloadHolder.reload_mc.visible = true;
						pulsateReloadMc(0.15, true);
					});
				}
			}
		}
		
		public function ExitSniperMode():void
		{
			if (ControlsMain.isVrModeActive())
			{
				return;
			}
			this.m_sniperModeIsEntered = false;
			this.runBulletChamberingTimer(0, 0, 0, 0, false);
			if (this.m_reloadAnimCalled)
			{
				this.m_view.reloadHolder.reload_mc.visible = false;
				this.pulsateReloadMc(0, false);
			}
		}
	}
}
