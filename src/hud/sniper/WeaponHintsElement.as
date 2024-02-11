// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.sniper.WeaponHintsElement

package hud.sniper {
import common.BaseControl;
import common.Animate;
import common.Localization;
import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.CommonUtils;

import flash.external.ExternalInterface;
import flash.filters.*;

public class WeaponHintsElement extends BaseControl {

	private var m_view:WeaponHintsElementView;
	private var m_reloadUrgent:Boolean = false;
	private var m_lastWeaponData:Object = new Object();
	private var m_delay:Number;
	private var m_bgOrigScaleFactorX:Number;
	private var m_topPosY:Number;
	private var m_centerPosY:Number;
	private var m_lowPosY:Number;
	private var m_setInitialPosY:Boolean = false;
	private var m_reloadAnimIsRunning:Boolean;
	private var m_sniperModeIsEntered:Boolean;
	private var m_reloadTimerAnimCalled:Boolean;

	public function WeaponHintsElement() {
		this.m_view = new WeaponHintsElementView();
		this.m_view.reload.visible = false;
		this.m_view.reloadTimerMc.visible = false;
		this.m_view.bulletChamberingTimerMc.visible = false;
		addChild(this.m_view);
	}

	public function onSetData(_arg_1:Object):void {
		this.m_view.visible = ((_arg_1.nDisplayMode == 2) ? true : false);
		if (!this.m_setInitialPosY) {
			this.m_view.y = this.m_topPosY;
			this.m_view.reload.y = this.m_centerPosY;
			this.m_view.reloadTimerMc.y = this.m_centerPosY;
			this.m_view.bulletChamberingTimerMc.y = this.m_centerPosY;
			this.m_setInitialPosY = true;
		}
		;
		this.m_view.reload.reload_txt.alpha = 0;
		this.m_view.reload.overlay.alpha = 0;
		this.m_view.reload.bg.alpha = 0;
		if (_arg_1.weaponStatus.bHasItemToShow) {
			if (_arg_1.weaponStatus.bIsFirearm) {
				this.setWeaponAmmoInfo(_arg_1.weaponStatus.nAmmoRemaining, _arg_1.weaponStatus.nAmmoTotal, _arg_1.weaponStatus.nAmmoInClip, _arg_1.weaponStatus.nWeaponType, _arg_1.weaponStatus.bInfiniteAmmo, _arg_1.weaponStatus.bIsReloading, _arg_1.weaponStatus.bCanReload);
			}
			;
			if ((((_arg_1.weaponStatus.bIsReloading) && (!(this.m_reloadTimerAnimCalled))) && (_arg_1.weaponStatus.fReloadDuration > 0))) {
				this.runReloadTimer(_arg_1.weaponStatus.fReloadDuration, _arg_1.weaponStatus.nAmmoInClip, _arg_1.weaponStatus.nAmmoRemaining, _arg_1.weaponStatus.nCurrentAmmoType, true);
			} else {
				if ((((_arg_1.weaponStatus.fTimeBetweenBullets > 0) && (this.m_sniperModeIsEntered)) && (_arg_1.weaponStatus.nCurrentAmmoType == this.m_lastWeaponData.nCurrentAmmoType))) {
					this.runBulletChamberingTimer(_arg_1.weaponStatus.fTimeBetweenBullets, _arg_1.weaponStatus.nAmmoInClip, _arg_1.weaponStatus.nAmmoRemaining, _arg_1.weaponStatus.nCurrentAmmoType, true);
				}
				;
			}
			;
		}
		;
		this.m_lastWeaponData = _arg_1.weaponStatus;
	}

	public function setWeaponAmmoInfo(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:Number, _arg_5:Boolean, _arg_6:Boolean, _arg_7:Boolean = true):void {
		if (_arg_6) {
			Animate.kill(this.m_view);
			Animate.kill(this.m_view.reload.overlay);
			Animate.kill(this.m_view.reload.bg);
			Animate.kill(this.m_view.reload.reload_txt);
			this.m_reloadUrgent = false;
			this.pulsateReloadMc(false);
			this.m_view.reload.visible = false;
			this.m_view.alpha = 1;
			return;
		}
		;
		if (((_arg_1 >= 0) && (_arg_2 >= 0))) {
			if (_arg_4 == 4) {
				this.m_reloadUrgent = false;
				this.pulsateReloadMc(false);
				this.m_view.reload.visible = false;
				if (((_arg_1 == 0) && (_arg_2 == 0))) {
					this.setElementFormats(Localization.get("UI_HUD_NO_AMMO_LEFT"));
					MenuUtils.setColor(this.m_view.reload.bg, MenuConstants.COLOR_RED);
					this.m_view.reload.visible = true;
					this.m_reloadUrgent = true;
					this.pulsateReloadMc(true);
				} else {
					if (_arg_2 > 0) {
						if (_arg_1 == 1) {
							this.setElementFormats(Localization.get("EUI_TEXT_BUTTON_RELOAD"));
							MenuUtils.setColor(this.m_view.reload.bg, MenuConstants.COLOR_YELLOW);
							this.m_view.reload.visible = true;
							this.pulsateReloadMc(true);
						} else {
							if (_arg_1 == 0) {
								this.setElementFormats(Localization.get("EUI_TEXT_BUTTON_RELOAD"));
								MenuUtils.setColor(this.m_view.reload.bg, MenuConstants.COLOR_RED);
								this.m_view.reload.visible = true;
								this.m_reloadUrgent = true;
								this.pulsateReloadMc(true);
							}
							;
						}
						;
					}
					;
				}
				;
			}
			;
		}
		;
	}

	private function pulsateReloadMc(_arg_1:Boolean):void {
		this.m_reloadAnimIsRunning = false;
		Animate.kill(this.m_view.reload.overlay);
		Animate.kill(this.m_view.reload.bg);
		Animate.kill(this.m_view.reload.reload_txt);
		this.m_view.reload.reload_txt.alpha = 0;
		this.m_view.reload.overlay.alpha = 0;
		this.m_view.reload.bg.alpha = 0;
		this.m_delay = ((this.m_reloadUrgent) ? 0.4 : 1.2);
		if (_arg_1) {
			this.m_reloadAnimIsRunning = true;
			this.pulsateFadeIn();
		}
		;
	}

	private function pulsateFadeIn():void {
		this.playSound(((this.m_reloadUrgent) ? "Reload_White" : "Reload_Red"));
		Animate.fromTo(this.m_view.reload.bg, (0.4 + this.m_delay), 0, {"alpha": 1}, {"alpha": 0}, Animate.ExpoIn);
		Animate.fromTo(this.m_view.reload.overlay, 0.4, 0, {
			"scaleX": this.m_bgOrigScaleFactorX,
			"alpha": 1
		}, {
			"scaleX": (this.m_bgOrigScaleFactorX + 2),
			"alpha": 0
		}, Animate.ExpoOut);
		Animate.fromTo(this.m_view.reload.reload_txt, (0.4 + this.m_delay), 0, {"alpha": 1}, {"alpha": 0.4}, Animate.ExpoIn, function ():void {
			pulsateFadeIn();
		});
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
				;
			}
			;
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
		;
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
			;
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
				;
			}
			;
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
		;
	}

	private function setElementFormats(_arg_1:String):void {
		MenuUtils.setupText(this.m_view.reload.reload_txt, _arg_1, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		CommonUtils.changeFontToGlobalIfNeeded(this.m_view.reload.reload_txt);
		this.m_view.reload.overlay.width = (this.m_view.reload.reload_txt.textWidth + 120);
		this.m_view.reload.bg.width = (this.m_view.reload.reload_txt.textWidth + 120);
		this.m_bgOrigScaleFactorX = this.m_view.reload.overlay.scaleX;
	}

	public function showWeaponHints():void {
		this.m_sniperModeIsEntered = true;
		Animate.kill(this.m_view);
		Animate.kill(this.m_view.reload);
		this.m_view.alpha = 0;
		Animate.to(this.m_view, 1, 0, {"alpha": 1}, Animate.ExpoOut);
		Animate.to(this.m_view.reload, 1, 0, {"y": this.m_centerPosY}, Animate.ExpoOut);
	}

	public function hideWeaponHints():void {
		this.m_sniperModeIsEntered = false;
		this.runBulletChamberingTimer(0, 0, 0, 0, false);
		Animate.kill(this.m_view);
		Animate.kill(this.m_view.reload);
		this.m_view.alpha = 1;
		Animate.to(this.m_view.reload, 0.6, 0, {"y": this.m_lowPosY}, Animate.ExpoOut);
	}

	public function playSound(_arg_1:String):void {
		ExternalInterface.call("PlaySound", _arg_1);
	}

	override public function onSetSize(_arg_1:Number, _arg_2:Number):void {
		Animate.kill(this.m_view.reload);
		var _local_3:Number = MenuUtils.getFillAspectScale(MenuConstants.BaseWidth, MenuConstants.BaseHeight, _arg_1, _arg_2);
		this.m_topPosY = (55 * _local_3);
		this.m_centerPosY = (((_arg_2 / 2) + (75 * _local_3)) / _local_3);
		this.m_lowPosY = ((_arg_2 - (123.5 * _local_3)) / _local_3);
		this.m_view.scaleX = (this.m_view.scaleY = _local_3);
		this.m_view.x = (_arg_1 / 2);
		this.m_view.y = this.m_topPosY;
		this.m_view.reload.y = this.m_centerPosY;
		this.m_view.reloadTimerMc.y = this.m_centerPosY;
		this.m_view.bulletChamberingTimerMc.y = this.m_centerPosY;
	}


}
}//package hud.sniper

