// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.WeaponHints

package hud {
import common.BaseControl;
import common.menu.MenuUtils;
import common.Localization;
import common.menu.MenuConstants;
import common.CommonUtils;
import common.Animate;

public class WeaponHints extends BaseControl {

	private var m_view:WeaponHintsView;
	private var m_reloadFlashTimes:int = 0;
	private var m_reloadUrgent:Boolean;
	private var m_lastWeaponData:Object = {};
	private var m_wasHolstered:Boolean;
	private var m_reloadAnimCalled:Boolean;
	private var m_reloadAnimIsRunning:Boolean;
	private var m_sniperModeIsEntered:Boolean;
	private var m_reloadTimerAnimCalled:Boolean;

	public function WeaponHints() {
		if (ControlsMain.isVrModeActive()) {
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

	public function onSetData(_arg_1:Object):void {
		if (ControlsMain.isVrModeActive()) {
			return;
		}

		this.m_view.visible = ((_arg_1.nDisplayMode == 2) ? true : false);
		var _local_2:Object = _arg_1.weaponStatus;
		if (_local_2.bHasItemToShow) {
			if (_local_2.bHolstered) {
				this.m_view.reloadHolder.reload_mc.visible = false;
				this.pulsateReloadMc(0, false);
				this.m_reloadUrgent = false;
				this.m_wasHolstered = true;
			} else {
				if (_local_2.bIsFirearm) {
					if ((((((!(this.m_lastWeaponData.nAmmoRemaining == _local_2.nAmmoRemaining)) || (!(this.m_lastWeaponData.nAmmoTotal == _local_2.nAmmoTotal))) || (!(this.m_lastWeaponData.nAmmoInClip == _local_2.nAmmoInClip))) || (!(this.m_lastWeaponData.nWeaponType == _local_2.nWeaponType))) || (!(this.m_lastWeaponData.icon == _local_2.icon)))) {
						this.setWeaponAmmoInfo(_local_2.nAmmoRemaining, _local_2.nAmmoTotal, _local_2.nAmmoInClip, _local_2.nWeaponType, _local_2.bCanReload, _local_2.bIsReloading);
					} else {
						if ((((((this.m_lastWeaponData.nAmmoRemaining == _local_2.nAmmoRemaining) && (this.m_lastWeaponData.nAmmoTotal == _local_2.nAmmoTotal)) && (this.m_lastWeaponData.nAmmoInClip == _local_2.nAmmoInClip)) && (this.m_lastWeaponData.nWeaponType == _local_2.nWeaponType)) && (this.m_lastWeaponData.icon == _local_2.icon))) {
							if (this.m_wasHolstered) {
								this.setWeaponAmmoInfo(_local_2.nAmmoRemaining, _local_2.nAmmoTotal, _local_2.nAmmoInClip, _local_2.nWeaponType, _local_2.bCanReload, _local_2.bIsReloading);
							}

						}

					}

					if (((((_local_2.nWeaponType == 4) && (_local_2.bIsReloading)) && (!(this.m_reloadTimerAnimCalled))) && (_local_2.fReloadDuration > 0))) {
						this.runReloadTimer(_local_2.fReloadDuration, _local_2.nAmmoInClip, _local_2.nAmmoRemaining, _local_2.nCurrentAmmoType, true);
					} else {
						if ((((_local_2.nWeaponType == 4) && (_local_2.fTimeBetweenBullets > 0)) && (this.m_sniperModeIsEntered))) {
							this.runBulletChamberingTimer(_local_2.fTimeBetweenBullets, _local_2.nAmmoInClip, _local_2.nAmmoRemaining, _local_2.nCurrentAmmoType, true);
						}

					}

					if (this.m_wasHolstered) {
						this.m_wasHolstered = false;
					}

				}

			}

		}

		this.m_lastWeaponData = _local_2;
	}

	private function setWeaponAmmoInfo(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:Number, _arg_5:Boolean = true, _arg_6:Boolean = false):void {
		this.m_reloadAnimCalled = false;
		if (_arg_6) {
			this.m_view.reloadHolder.reload_mc.visible = false;
			this.pulsateReloadMc(0, false);
			this.m_reloadUrgent = false;
		} else {
			if (((_arg_1 >= 0) && (_arg_2 >= 0))) {
				if (_arg_5) {
					this.m_view.reloadHolder.reload_mc.visible = false;
					this.pulsateReloadMc(0, false);
					this.m_reloadUrgent = false;
					if (_arg_2 > 0) {
						if (((_arg_1 == 1) && (!(_arg_3 == 1)))) {
							this.m_reloadAnimCalled = true;
							this.m_view.reloadHolder.reload_mc.visible = true;
							this.pulsateReloadMc(0.15, true);
						} else {
							if (_arg_1 == 0) {
								this.m_reloadAnimCalled = true;
								this.m_view.reloadHolder.reload_mc.visible = true;
								this.m_reloadUrgent = true;
								this.pulsateReloadMc(0.15, true);
							}

						}

					}

				}

			}

		}

	}

	private function pulsateReloadMc(_arg_1:Number, _arg_2:Boolean):void {
		this.m_reloadAnimIsRunning = false;
		Animate.kill(this);
		Animate.kill(this.m_view.reloadHolder.reload_mc.reload_txt);
		Animate.kill(this.m_view.reloadHolder.reload_mc.bg);
		MenuUtils.removeTint(this.m_view.reloadHolder.reload_mc.bg);
		if (this.m_reloadUrgent) {
			MenuUtils.setTintColor(this.m_view.reloadHolder.reload_mc.reload_txt, MenuUtils.TINT_COLOR_WHITE, false);
		} else {
			MenuUtils.setTintColor(this.m_view.reloadHolder.reload_mc.reload_txt, MenuUtils.TINT_COLOR_ULTRA_DARK_GREY, false);
		}

		this.m_view.reloadHolder.reload_mc.bg.alpha = 1;
		this.m_reloadFlashTimes = 6;
		if (_arg_2) {
			this.m_reloadAnimIsRunning = true;
			if (this.m_reloadUrgent) {
				MenuUtils.setTintColor(this.m_view.reloadHolder.reload_mc.bg, MenuUtils.TINT_COLOR_MAGENTA_DARK, false);
			}

			Animate.delay(this, _arg_1, this.pulsateFadeIn, _arg_1);
		}

	}

	private function pulsateFadeIn(_arg_1:Number):void {
		if (this.m_reloadFlashTimes <= 0) {
			if (((this.m_sniperModeIsEntered) && (this.m_reloadUrgent))) {
				this.m_reloadFlashTimes = 6;
			} else {
				this.pulsateReloadMc(0, false);
				this.m_view.reloadHolder.reload_mc.visible = false;
				return;
			}

		}

		if (this.m_reloadUrgent) {
			MenuUtils.setTintColor(this.m_view.reloadHolder.reload_mc.reload_txt, MenuUtils.TINT_COLOR_MAGENTA_DARK, false);
		} else {
			MenuUtils.setTintColor(this.m_view.reloadHolder.reload_mc.reload_txt, MenuUtils.TINT_COLOR_YELLOW_LIGHT, false);
		}

		this.m_view.reloadHolder.reload_mc.bg.alpha = 0;
		Animate.delay(this, _arg_1, this.pulsateFadeOut, _arg_1);
		this.m_reloadFlashTimes--;
	}

	private function pulsateFadeOut(_arg_1:Number):void {
		if (this.m_reloadFlashTimes <= 0) {
			if (((this.m_sniperModeIsEntered) && (this.m_reloadUrgent))) {
				this.m_reloadFlashTimes = 6;
			} else {
				this.pulsateReloadMc(0, false);
				this.m_view.reloadHolder.reload_mc.visible = false;
				return;
			}

		}

		if (this.m_reloadUrgent) {
			MenuUtils.setTintColor(this.m_view.reloadHolder.reload_mc.reload_txt, MenuUtils.TINT_COLOR_WHITE, false);
		} else {
			MenuUtils.setTintColor(this.m_view.reloadHolder.reload_mc.reload_txt, MenuUtils.TINT_COLOR_ULTRA_DARK_GREY, false);
		}

		this.m_view.reloadHolder.reload_mc.bg.alpha = 1;
		Animate.delay(this, _arg_1, this.pulsateFadeIn, _arg_1);
		this.m_reloadFlashTimes--;
	}

	private function runReloadTimer(duration:Number, nAmmoInClip:int, nAmmoRemaining:int, nCurrentAmmoType:int, start:Boolean):void {
		var nAmmoTypeFrameOffset:int;
		this.m_view.reloadTimerMc.visible = false;
		Animate.kill(this.m_view.reloadTimerMc.bulletActiveMc);
		Animate.kill(this.m_view.reloadTimerMc.bulletsStaticMc);
		Animate.kill(this.m_view.reloadTimerMc.bulletActiveMc.bulletAnimMc);
		Animate.kill(this.m_view.reloadTimerMc.bar);
		Animate.kill(this.m_view.reloadTimerMc);
		if (start) {
			if (this.m_reloadAnimIsRunning) {
				this.m_view.reloadHolder.reload_mc.visible = false;
				this.pulsateReloadMc(0, false);
				this.m_reloadUrgent = false;
			}

			this.m_reloadTimerAnimCalled = true;
			nAmmoTypeFrameOffset = 0;
			this.m_view.reloadTimerMc.bulletActiveMc.gotoAndStop(1);
			if (nCurrentAmmoType == 1) {
				this.m_view.reloadTimerMc.bulletActiveMc.gotoAndStop(2);
				nAmmoTypeFrameOffset = 14;
			} else {
				if (nCurrentAmmoType == 2) {
					this.m_view.reloadTimerMc.bulletActiveMc.gotoAndStop(3);
					nAmmoTypeFrameOffset = 28;
				}

			}

			this.m_view.reloadTimerMc.alpha = 1;
			this.m_view.reloadTimerMc.bar.scaleX = 0;
			this.m_view.reloadTimerMc.bulletActiveMc.y = 23;
			this.m_view.reloadTimerMc.bulletActiveMc.bulletAnimMc.gotoAndStop(0);
			this.m_view.reloadTimerMc.bulletsStaticMc.y = 37;
			this.m_view.reloadTimerMc.bulletsStaticMc.gotoAndStop((nAmmoRemaining + nAmmoTypeFrameOffset));
			this.m_view.reloadTimerMc.visible = true;
			Animate.to(this.m_view.reloadTimerMc.bulletsStaticMc, (duration - 0.1), 0, {"frames": (nAmmoInClip + nAmmoTypeFrameOffset)}, Animate.Linear, function ():void {
				Animate.to(m_view.reloadTimerMc.bulletActiveMc.bulletAnimMc, 0.1, 0, {"frames": 21}, Animate.Linear);
				Animate.to(m_view.reloadTimerMc.bulletActiveMc, 0.1, 0, {"y": -1}, Animate.ExpoOut);
				Animate.to(m_view.reloadTimerMc.bulletsStaticMc, 0.1, 0, {"y": 23}, Animate.ExpoOut);
			});
			Animate.to(this.m_view.reloadTimerMc.bar, duration, 0, {"scaleX": 2.1}, Animate.Linear, function ():void {
				Animate.to(m_view.reloadTimerMc, 0.2, 0, {"alpha": 0}, Animate.ExpoOut);
				m_reloadTimerAnimCalled = false;
			});
		}

	}

	private function runBulletChamberingTimer(duration:Number, nAmmoInClip:int, nAmmoRemaining:int, nCurrentAmmoType:int, start:Boolean):void {
		var nAmmoTypeFrameOffset:int;
		this.m_view.bulletChamberingTimerMc.visible = false;
		Animate.kill(this.m_view.bulletChamberingTimerMc.bulletActiveMc);
		Animate.kill(this.m_view.bulletChamberingTimerMc.bulletsStaticMc);
		Animate.kill(this.m_view.bulletChamberingTimerMc.bulletActiveMc.bulletAnimMc);
		Animate.kill(this.m_view.bulletChamberingTimerMc.bar);
		Animate.kill(this.m_view.bulletChamberingTimerMc);
		if (start) {
			if (((nAmmoRemaining < 1) || (nAmmoInClip == nAmmoRemaining))) {
				return;
			}

			nAmmoTypeFrameOffset = 0;
			this.m_view.bulletChamberingTimerMc.bulletActiveMc.gotoAndStop(1);
			if (nCurrentAmmoType == 1) {
				this.m_view.bulletChamberingTimerMc.bulletActiveMc.gotoAndStop(2);
				nAmmoTypeFrameOffset = 14;
			} else {
				if (nCurrentAmmoType == 2) {
					this.m_view.bulletChamberingTimerMc.bulletActiveMc.gotoAndStop(3);
					nAmmoTypeFrameOffset = 28;
				}

			}

			this.m_view.bulletChamberingTimerMc.alpha = 1;
			this.m_view.bulletChamberingTimerMc.bar.scaleX = 0;
			this.m_view.bulletChamberingTimerMc.bulletActiveMc.y = 23;
			this.m_view.bulletChamberingTimerMc.bulletActiveMc.bulletAnimMc.gotoAndStop(0);
			this.m_view.bulletChamberingTimerMc.bulletsStaticMc.y = 37;
			this.m_view.bulletChamberingTimerMc.bulletsStaticMc.gotoAndStop((nAmmoRemaining + nAmmoTypeFrameOffset));
			this.m_view.bulletChamberingTimerMc.visible = true;
			Animate.to(this.m_view.bulletChamberingTimerMc.bulletActiveMc, 0.1, (duration - 0.1), {"y": -1}, Animate.ExpoOut);
			Animate.to(this.m_view.bulletChamberingTimerMc.bulletsStaticMc, 0.1, (duration - 0.1), {"y": 23}, Animate.ExpoOut);
			Animate.to(this.m_view.bulletChamberingTimerMc.bulletActiveMc.bulletAnimMc, 0.1, (duration - 0.1), {"frames": 21}, Animate.Linear);
			Animate.to(this.m_view.bulletChamberingTimerMc.bar, duration, 0, {"scaleX": 2.1}, Animate.Linear, function ():void {
				Animate.to(m_view.bulletChamberingTimerMc, 0.2, 0, {"alpha": 0}, Animate.ExpoOut);
			});
		}

	}

	public function EnterSniperMode():void {
		if (ControlsMain.isVrModeActive()) {
			return;
		}

		this.m_sniperModeIsEntered = true;
		if (((this.m_reloadAnimCalled) && (this.m_reloadUrgent))) {
			if (this.m_reloadAnimIsRunning) {
				this.m_reloadFlashTimes = 6;
			} else {
				Animate.kill(this);
				Animate.delay(this, 0.6, function ():void {
					m_view.reloadHolder.reload_mc.visible = true;
					pulsateReloadMc(0.15, true);
				});
			}

		}

	}

	public function ExitSniperMode():void {
		if (ControlsMain.isVrModeActive()) {
			return;
		}

		this.m_sniperModeIsEntered = false;
		this.runBulletChamberingTimer(0, 0, 0, 0, false);
		if (this.m_reloadAnimCalled) {
			this.m_view.reloadHolder.reload_mc.visible = false;
			this.pulsateReloadMc(0, false);
		}

	}


}
}//package hud

