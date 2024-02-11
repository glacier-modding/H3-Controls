// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.Weapon

package hud {
import common.BaseControl;
import common.ImageLoader;

import flash.display.Sprite;

import common.menu.MenuConstants;
import common.menu.MenuUtils;
import common.Localization;
import common.CommonUtils;
import common.Animate;

import flash.display.MovieClip;
import flash.filters.GlowFilter;

import fl.motion.Color;

import flash.display.DisplayObject;

public class Weapon extends BaseControl {

	private static const LEGALSTATE_CLEAR:int = 0;
	private static const LEGALSTATE_SUSPICIOUS:int = 1;
	private static const LEGALSTATE_ILLEGAL:int = 2;
	private static const PX_BLUR:Number = 4;

	private var m_view:WeaponView;
	private var m_primaryLoader:ImageLoader;
	private var m_secondaryLoader:ImageLoader;
	private var m_leftHandLoader:ImageLoader;
	private var m_currentPrimaryImage:String;
	private var m_currentSecondaryImage:String;
	private var m_currentLeftHandImage:String;
	private var m_currentAmmoInGun:Number;
	private var m_currentAmmoInStore:Number;
	private var m_currentAmmoInClip:Number;
	private var m_currentAmmoType:Number;
	private var m_lastWeaponData:Object = new Object();
	private var m_lastBackData:Object = new Object();
	private var m_lastLeftHandData:Object = new Object();
	private var m_primaryLegalState:int = 0;
	private var m_secondaryLegalState:int = 0;
	private var m_leftHandLegalState:int = 0;
	private var m_previousPrimaryLegalState:int = 0;
	private var m_previousIsPrimaryHolsteredOnBack:Boolean = false;
	private var m_reloadUrgent:Boolean = false;
	private var m_weaponBackground:Sprite;
	private var m_primaryIsShown:Boolean;
	private var m_secondaryIsShown:Boolean;
	private var m_leftHandIsShown:Boolean;
	private var m_primaryWeaponHolstered:Boolean;
	private var m_reloadClipShownWhileHolster:Boolean;
	private var m_finalWeaponWasDropped:Boolean;
	private var m_reloadAnimIsRunning:Boolean;
	private var m_sniperModeIsEntered:Boolean;
	private var m_isReloading:Boolean = false;
	private var m_fScaleAccum:Number = 1;

	public function Weapon() {
		this.m_weaponBackground = new Sprite();
		this.m_weaponBackground.graphics.clear();
		this.m_weaponBackground.graphics.beginFill(MenuConstants.COLOR_MENU_TABS_BACKGROUND, MenuConstants.MenuElementBackgroundAlpha);
		this.m_weaponBackground.graphics.drawRect(-210, -210, 210, 210);
		this.m_weaponBackground.visible = false;
		addChild(this.m_weaponBackground);
		this.m_view = new WeaponView();
		this.m_view.iconPri_mc.alpha = 0;
		this.m_view.iconSec_mc.alpha = 0;
		this.m_view.iconLeftHand_mc.alpha = 0;
		addChild(this.m_view);
		this.m_primaryLoader = new ImageLoader();
		this.m_primaryLoader.visible = false;
		this.m_view.imageHolderPri_mc.addChild(this.m_primaryLoader);
		if (ControlsMain.isVrModeActive()) {
			this.m_view.imageHolderPri_mc.x = -245;
			this.m_view.iconPri_mc.x = ((this.m_view.ammoDisplayContainer.x - (this.m_view.iconPri_mc.width / 2)) - 10);
		}
		;
		this.m_secondaryLoader = new ImageLoader();
		this.m_secondaryLoader.visible = false;
		this.m_view.imageHolderSec_mc.addChild(this.m_secondaryLoader);
		this.m_leftHandLoader = new ImageLoader();
		this.m_leftHandLoader.visible = false;
		this.m_view.imageHolderLeftHand_mc.addChild(this.m_leftHandLoader);
		MenuUtils.trySetCacheAsBitmap(this.m_view.imageHolderPri_mc, true);
		MenuUtils.trySetCacheAsBitmap(this.m_view.imageHolderSec_mc, true);
		MenuUtils.trySetCacheAsBitmap(this.m_view.imageHolderLeftHand_mc, true);
		this.setHolsterEffect(true, this.m_view.imageHolderSec_mc);
		this.m_currentPrimaryImage = "";
		this.m_currentSecondaryImage = "";
		this.m_currentLeftHandImage = "";
		this.m_view.reloadHolder.reload_mc.visible = false;
		this.m_view.ammoDisplayContainer.ammoDisplay.visible = false;
	}

	public function onSetData(_arg_1:Object):void {
		var _local_8:Boolean;
		var _local_9:Boolean;
		this.m_view.reloadHolder.visible = ((_arg_1.nDisplayMode == 0) ? false : true);
		MenuUtils.setupText(this.m_view.reloadHolder.reload_mc.reload_txt, Localization.get("EUI_TEXT_BUTTON_RELOAD"), 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
		CommonUtils.changeFontToGlobalIfNeeded(this.m_view.reloadHolder.reload_mc.reload_txt);
		if (_arg_1.weaponStatus.bIsContainer) {
			return;
		}
		;
		var _local_2:Object = _arg_1.weaponStatus;
		var _local_3:Object = _arg_1.itemOnBackStatus;
		var _local_4:Object = _arg_1.itemLeftHandStatus;
		var _local_5:Boolean = true;
		var _local_6:Boolean = true;
		var _local_7:Boolean = true;
		_local_5 = ((!(_local_2.icon == this.m_lastWeaponData.icon)) || (!(_local_2.bHasItemToShow == this.m_lastWeaponData.bHasItemToShow)));
		_local_6 = (((!(_local_3.icon == this.m_lastBackData.icon)) || (!(_local_3.bHasItemToShow == this.m_lastBackData.bHasItemToShow))) || (this.m_lastWeaponData.icon == this.m_lastBackData.icon));
		_local_7 = ((!(_local_4.icon == this.m_lastLeftHandData.icon)) || (!(_local_4.bHasItemToShow == this.m_lastLeftHandData.bHasItemToShow)));
		if (_local_2.bHasItemToShow) {
			this.m_primaryLoader.visible = true;
			this.m_primaryIsShown = true;
			if (((_local_5) || (!(_local_2.bHolstered == this.m_lastWeaponData.bHolstered)))) {
				this.setWeaponIcon(_local_2.icon);
			}
			;
			_local_8 = false;
			if (_local_2.bHolstered != this.m_lastWeaponData.bHolstered) {
				if (_local_2.bHolstered) {
					this.holsterWeapon((!(_arg_1.bShowHolstered)));
					if (!this.m_lastWeaponData.bIsFirearm) {
						_local_8 = true;
					}
					;
				} else {
					this.unholsterWeapon();
				}
				;
			}
			;
			if (_local_8) {
				this.m_view.ammoDisplayContainer.visible = false;
			} else {
				Animate.legacyTo(this.m_view.ammoDisplayContainer, 0.5, {"alpha": ((_local_2.bHolstered) ? 0 : 1)}, Animate.ExpoOut);
			}
			;
			if (_local_2.bIsFirearm) {
				this.setWeaponAmmoInfo(_local_2.nAmmoRemaining, _local_2.nAmmoTotal, _local_2.nAmmoInClip, _local_2.nWeaponType, _arg_1.nDisplayMode, _local_2.bCanReload, _local_2.bIsReloading, _local_2.fReloadDuration);
			} else {
				this.setWeaponAmmoInfo(-1, _local_2.nAmmoRemaining, -1, _local_2.nWeaponType, _arg_1.nDisplayMode, _local_2.bCanReload, _local_2.bIsReloading);
			}
			;
			if (((((!(_local_2.bIllegal == this.m_lastWeaponData.bIllegal)) || (!(_local_2.bSuspicious == this.m_lastWeaponData.bSuspicious))) || (!(_local_2.bHolstered == this.m_lastWeaponData.bHolstered))) || (_local_5))) {
				_local_9 = false;
				if (_local_2.bIllegal) {
					if (!_local_2.bHolstered) {
						this.m_primaryLegalState = LEGALSTATE_ILLEGAL;
					} else {
						if (((_local_2.icon == _local_3.icon) && (_arg_1.bShowHolstered))) {
							this.m_primaryLegalState = LEGALSTATE_ILLEGAL;
							_local_9 = true;
						} else {
							this.m_primaryLegalState = LEGALSTATE_CLEAR;
						}
						;
					}
					;
				} else {
					if (_local_2.bSuspicious) {
						if (!_local_2.bHolstered) {
							this.m_primaryLegalState = LEGALSTATE_SUSPICIOUS;
						} else {
							if (_local_2.icon == _local_3.icon) {
								this.m_primaryLegalState = LEGALSTATE_SUSPICIOUS;
								_local_9 = true;
							} else {
								this.m_primaryLegalState = LEGALSTATE_CLEAR;
							}
							;
						}
						;
					} else {
						this.m_primaryLegalState = LEGALSTATE_CLEAR;
					}
					;
				}
				;
				this.updatePrimaryImageVisibility(_local_9, this.m_primaryLegalState);
				if (((!(this.m_primaryLegalState == this.m_previousPrimaryLegalState)) || (!(this.m_previousIsPrimaryHolsteredOnBack == _local_9)))) {
					this.setStateIcon(this.m_view.iconPri_mc, 0.46, this.m_primaryLegalState, ((_local_9) && (ControlsMain.isVrModeActive())));
					this.m_previousPrimaryLegalState = this.m_primaryLegalState;
					this.m_previousIsPrimaryHolsteredOnBack = _local_9;
				}
				;
			}
			;
		} else {
			this.m_primaryWeaponHolstered = false;
			this.pulsateReloadMc(0, false);
			this.m_view.reloadHolder.reload_mc.visible = false;
			this.m_view.ammoDisplayContainer.ammoDisplay.visible = false;
			this.setStateIcon(this.m_view.iconPri_mc, 0.46, LEGALSTATE_CLEAR);
			this.m_previousPrimaryLegalState = LEGALSTATE_CLEAR;
			this.m_previousIsPrimaryHolsteredOnBack = false;
			this.m_lastWeaponData.bHasItemToShow = false;
			this.m_finalWeaponWasDropped = true;
			this.m_primaryLoader.visible = false;
			this.m_primaryIsShown = false;
		}
		;
		if ((((_local_3.bHasItemToShow) && (!(_local_2.icon == _local_3.icon))) && (_arg_1.bShowHolstered))) {
			this.m_secondaryIsShown = true;
			if (_local_6) {
				this.setSecondaryIcon(_local_3.icon);
			}
			;
			if ((((!(_local_3.bIllegal == this.m_lastBackData.bIllegal)) || (!(_local_3.bSuspicious == this.m_lastBackData.bSuspicious))) || (_local_6))) {
				if (((_local_3.bIllegal) && (_arg_1.bShowHolstered))) {
					this.m_secondaryLegalState = LEGALSTATE_ILLEGAL;
				} else {
					if (((_local_3.bSuspicious) && (_arg_1.bShowHolstered))) {
						this.m_secondaryLegalState = LEGALSTATE_SUSPICIOUS;
					} else {
						this.m_secondaryLegalState = LEGALSTATE_CLEAR;
					}
					;
				}
				;
				this.setStateIcon(this.m_view.iconSec_mc, 0.23, this.m_secondaryLegalState, ControlsMain.isVrModeActive());
				this.m_secondaryLoader.visible = true;
			}
			;
		} else {
			if (this.m_lastBackData.bHasItemToShow) {
				this.m_secondaryLoader.visible = false;
				this.setStateIcon(this.m_view.iconSec_mc, 0.23, LEGALSTATE_CLEAR);
				this.m_secondaryLegalState = LEGALSTATE_CLEAR;
				_local_3.bHasItemToShow = false;
				this.m_secondaryIsShown = false;
			} else {
				this.m_secondaryLoader.visible = false;
				_local_3.bHasItemToShow = false;
				this.m_secondaryIsShown = false;
			}
			;
		}
		;
		if (((_local_4.bHasItemToShow) && (_local_4.bIllegal))) {
			this.m_leftHandIsShown = true;
			if (_local_7) {
				this.setLeftHandIcon(_local_4.icon);
			}
			;
			if ((((!(_local_4.bIllegal == this.m_lastLeftHandData.bIllegal)) || (!(_local_4.bSuspicious == this.m_lastLeftHandData.bSuspicious))) || (_local_7))) {
				if (_local_4.bIllegal) {
					this.m_leftHandLegalState = LEGALSTATE_ILLEGAL;
				} else {
					if (_local_4.bSuspicious) {
						this.m_leftHandLegalState = LEGALSTATE_SUSPICIOUS;
					} else {
						this.m_leftHandLegalState = LEGALSTATE_CLEAR;
					}
					;
				}
				;
				this.setStateIcon(this.m_view.iconLeftHand_mc, 0.23, this.m_leftHandLegalState);
				this.m_leftHandLoader.visible = true;
			}
			;
		} else {
			if (this.m_lastLeftHandData.bHasItemToShow) {
				this.m_leftHandLoader.visible = false;
				this.setStateIcon(this.m_view.iconLeftHand_mc, 0.23, LEGALSTATE_CLEAR);
				this.m_leftHandLegalState = LEGALSTATE_CLEAR;
				this.m_lastLeftHandData.bHasItemToShow = false;
				this.m_leftHandIsShown = false;
			} else {
				this.m_leftHandLoader.visible = false;
				this.m_lastLeftHandData.bHasItemToShow = false;
				this.m_leftHandIsShown = false;
			}
			;
		}
		;
		if (_local_2.bHasItemToShow) {
			this.m_lastWeaponData = _local_2;
		}
		;
		if (_local_3.bHasItemToShow) {
			this.m_lastBackData = _local_3;
		}
		;
		if (_local_4.bHasItemToShow) {
			this.m_lastLeftHandData = _local_4;
		}
		;
	}

	private function unholsterWeapon():void {
		this.m_primaryWeaponHolstered = false;
		this.m_view.ammoDisplayContainer.visible = true;
		this.m_primaryLoader.visible = true;
		Animate.legacyTo(this.m_view.ammoDisplayContainer, 0.3, {"alpha": 1}, Animate.ExpoOut);
		this.setHolsterEffect(false, this.m_view.imageHolderPri_mc);
	}

	private function holsterWeapon(_arg_1:Boolean):void {
		this.m_primaryWeaponHolstered = true;
		this.m_primaryLoader.visible = (!(_arg_1));
		this.m_view.ammoDisplayContainer.visible = (!(_arg_1));
		if (!_arg_1) {
			this.m_reloadClipShownWhileHolster = true;
			this.pulsateReloadMc(0, false);
			this.m_view.reloadHolder.reload_mc.visible = false;
			Animate.legacyTo(this.m_view.ammoDisplayContainer, 0.3, {"alpha": 0}, Animate.ExpoOut);
			this.setHolsterEffect(true, this.m_view.imageHolderPri_mc);
		} else {
			this.m_view.imageHolderPri_mc.alpha = 0;
		}
		;
	}

	private function setWeaponIcon(_arg_1:String):void {
		if (this.m_currentPrimaryImage != _arg_1) {
			this.loadPrimaryImage(_arg_1);
			this.m_currentPrimaryImage = _arg_1;
		}
		;
	}

	private function setSecondaryIcon(_arg_1:String):void {
		if (this.m_currentSecondaryImage != _arg_1) {
			this.loadSecondaryImage(_arg_1);
			this.m_currentSecondaryImage = _arg_1;
		}
		;
	}

	private function setLeftHandIcon(_arg_1:String):void {
		if (this.m_currentLeftHandImage != _arg_1) {
			this.loadLeftHandImage(_arg_1);
			this.m_currentLeftHandImage = _arg_1;
		}
		;
	}

	public function setWeaponAmmo(_arg_1:Number):void {
	}

	private function setWeaponAmmoInfo(nAmmoRemaining:int, nAmmoTotal:int, nAmmoInClip:int, nWeaponType:Number, nDisplayMode:int, bCanReload:Boolean = true, bIsReloading:Boolean = false, fReloadDuration:Number = 0):void {
		if ((((((((!(this.m_currentAmmoInGun == nAmmoRemaining)) || (!(this.m_currentAmmoInStore == nAmmoTotal))) || (!(this.m_currentAmmoInClip == nAmmoInClip))) || (!(this.m_currentAmmoType == nWeaponType))) || (!(this.m_isReloading == bIsReloading))) || (this.m_reloadClipShownWhileHolster)) || (this.m_finalWeaponWasDropped))) {
			if (this.m_primaryWeaponHolstered) {
				return;
			}
			;
			if (this.m_isReloading != bIsReloading) {
				this.m_isReloading = bIsReloading;
				if (this.m_isReloading) {
				}
				;
			}
			;
			this.m_reloadClipShownWhileHolster = false;
			this.m_finalWeaponWasDropped = false;
			this.m_view.reloadHolder.reload_mc.visible = false;
			this.pulsateReloadMc(0, false);
			this.m_reloadUrgent = false;
			if (((nAmmoTotal > 1) && (nAmmoRemaining < 0))) {
				this.m_view.ammoDisplayContainer.ammoDisplay.visible = true;
				this.m_view.ammoDisplayContainer.ammoDisplay.ammoCurrent_txt.visible = true;
				this.m_view.ammoDisplayContainer.ammoDisplay.ammoTotal_txt.visible = false;
				MenuUtils.setupText(this.m_view.ammoDisplayContainer.ammoDisplay.ammoCurrent_txt, ("x" + nAmmoTotal.toString()), 36, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorGreyUltraLight);
				MenuUtils.setupText(this.m_view.ammoDisplayContainer.ammoDisplay.ammoTotal_txt, "", 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
				this.m_view.ammoDisplayContainer.ammoDisplay.ammoTotal_txt.x = (this.m_view.ammoDisplayContainer.ammoDisplay.ammoCurrent_txt.textWidth + 2);
				if (!ControlsMain.isVrModeActive()) {
					this.m_view.ammoDisplayContainer.x = (((((120 - this.m_primaryLoader.width) / 2) - 120) - (this.m_view.ammoDisplayContainer.ammoDisplay.ammoTotal_txt.x + this.m_view.ammoDisplayContainer.ammoDisplay.ammoTotal_txt.textWidth)) - 16);
				}
				;
			} else {
				if (((nAmmoRemaining >= 0) && (nAmmoTotal >= 0))) {
					this.m_view.ammoDisplayContainer.ammoDisplay.visible = true;
					this.m_view.ammoDisplayContainer.ammoDisplay.ammoCurrent_txt.visible = true;
					this.m_view.ammoDisplayContainer.ammoDisplay.ammoTotal_txt.visible = true;
					MenuUtils.setupText(this.m_view.ammoDisplayContainer.ammoDisplay.ammoCurrent_txt, nAmmoRemaining.toString(), 36, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorGreyUltraLight);
					if (bCanReload) {
						MenuUtils.setupText(this.m_view.ammoDisplayContainer.ammoDisplay.ammoTotal_txt, ("/" + nAmmoTotal.toString()), 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
					} else {
						MenuUtils.setupText(this.m_view.ammoDisplayContainer.ammoDisplay.ammoTotal_txt, "", 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
					}
					;
					this.m_view.ammoDisplayContainer.ammoDisplay.ammoTotal_txt.x = (this.m_view.ammoDisplayContainer.ammoDisplay.ammoCurrent_txt.textWidth + 2);
					if (!ControlsMain.isVrModeActive()) {
						this.m_view.ammoDisplayContainer.x = (((((120 - this.m_primaryLoader.width) / 2) - 120) - (this.m_view.ammoDisplayContainer.ammoDisplay.ammoTotal_txt.x + this.m_view.ammoDisplayContainer.ammoDisplay.ammoTotal_txt.textWidth)) - 16);
					}
					;
					if (nAmmoTotal > 0) {
						if (((nAmmoRemaining == 1) && (!(nAmmoInClip == 1)))) {
							if (ControlsMain.isVrModeActive()) {
								this.m_view.reloadHolder.reload_mc.visible = true;
								this.pulsateReloadMc(0.3, true);
							} else {
								Animate.delay(this, ((nDisplayMode == 1) ? 0 : 1.2), function ():void {
									m_view.reloadHolder.reload_mc.visible = true;
									pulsateReloadMc(0.3, true);
								});
							}
							;
						} else {
							if (nAmmoRemaining == 0) {
								if (ControlsMain.isVrModeActive()) {
									this.m_reloadUrgent = true;
									this.m_view.reloadHolder.reload_mc.visible = true;
									this.pulsateReloadMc(0.15, true);
								} else {
									Animate.delay(this, ((nDisplayMode == 1) ? 0 : 1.2), function ():void {
										m_reloadUrgent = true;
										m_view.reloadHolder.reload_mc.visible = true;
										pulsateReloadMc(0.3, true);
									});
								}
								;
							}
							;
						}
						;
					}
					;
				} else {
					this.m_view.ammoDisplayContainer.ammoDisplay.ammoCurrent_txt.visible = false;
					this.m_view.ammoDisplayContainer.ammoDisplay.ammoTotal_txt.visible = false;
				}
				;
			}
			;
			this.m_currentAmmoInGun = nAmmoRemaining;
			this.m_currentAmmoInStore = nAmmoTotal;
			this.m_currentAmmoInClip = nAmmoInClip;
			this.m_currentAmmoType = nWeaponType;
		}
		;
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
		;
		this.m_view.reloadHolder.reload_mc.bg.alpha = 1;
		if (_arg_2) {
			this.m_reloadAnimIsRunning = true;
			if (this.m_reloadUrgent) {
				if (this.m_sniperModeIsEntered) {
					this.m_view.reloadHolder.alpha = 0;
				}
				;
				MenuUtils.setTintColor(this.m_view.reloadHolder.reload_mc.bg, MenuUtils.TINT_COLOR_MAGENTA_DARK, false);
			}
			;
			Animate.delay(this, _arg_1, this.pulsateFadeIn, _arg_1);
		}
		;
	}

	private function pulsateFadeIn(_arg_1:Number):void {
		if (this.m_reloadUrgent) {
			MenuUtils.setTintColor(this.m_view.reloadHolder.reload_mc.reload_txt, MenuUtils.TINT_COLOR_MAGENTA_DARK, false);
		} else {
			MenuUtils.setTintColor(this.m_view.reloadHolder.reload_mc.reload_txt, MenuUtils.TINT_COLOR_YELLOW_LIGHT, false);
		}
		;
		this.m_view.reloadHolder.reload_mc.bg.alpha = 0;
		Animate.delay(this, _arg_1, this.pulsateFadeOut, _arg_1);
	}

	private function pulsateFadeOut(_arg_1:Number):void {
		if (this.m_reloadUrgent) {
			MenuUtils.setTintColor(this.m_view.reloadHolder.reload_mc.reload_txt, MenuUtils.TINT_COLOR_WHITE, false);
		} else {
			MenuUtils.setTintColor(this.m_view.reloadHolder.reload_mc.reload_txt, MenuUtils.TINT_COLOR_ULTRA_DARK_GREY, false);
		}
		;
		this.m_view.reloadHolder.reload_mc.bg.alpha = 1;
		Animate.delay(this, _arg_1, this.pulsateFadeIn, _arg_1);
	}

	public function setPointShooing(_arg_1:Number):void {
	}

	private function setStateIcon(_arg_1:MovieClip, _arg_2:Number, _arg_3:int, _arg_4:Boolean = false):void {
		Animate.kill(_arg_1);
		_arg_1.alpha = 0;
		if (_arg_3 != LEGALSTATE_CLEAR) {
			if (_arg_3 == LEGALSTATE_ILLEGAL) {
				_arg_1.gotoAndStop("visarmed");
			} else {
				_arg_1.gotoAndStop("susarmed");
			}
			;
			_arg_1.scaleX = (_arg_1.scaleY = (_arg_2 * 1.25));
			Animate.legacyTo(_arg_1, 0.3, {
				"scaleX": _arg_2,
				"scaleY": _arg_2,
				"alpha": 1
			}, Animate.ExpoOut);
			if (_arg_4) {
				this.pulsateStateIcon_StepA(_arg_1, _arg_2);
			}
			;
		}
		;
	}

	private function pulsateStateIcon_StepA(_arg_1:MovieClip, _arg_2:Number):void {
		Animate.addFromTo(_arg_1, 0.3, 0.4, {
			"scaleX": _arg_2,
			"scaleY": _arg_2,
			"alpha": 1
		}, {
			"scaleX": (_arg_2 * 2),
			"scaleY": (_arg_2 * 2),
			"alpha": 0
		}, Animate.ExpoOut, this.pulsateStateIcon_StepB, _arg_1, _arg_2);
	}

	private function pulsateStateIcon_StepB(_arg_1:MovieClip, _arg_2:Number):void {
		Animate.addFromTo(_arg_1, 0.3, 0, {
			"scaleX": (_arg_2 / 2),
			"scaleY": (_arg_2 / 2),
			"alpha": 0
		}, {
			"scaleX": _arg_2,
			"scaleY": _arg_2,
			"alpha": 1
		}, Animate.ExpoOut, this.pulsateStateIcon_StepA, _arg_1, _arg_2);
	}

	private function setHolsterEffect(_arg_1:Boolean, _arg_2:MovieClip):void {
		var _local_6:Number;
		var _local_7:GlowFilter;
		var _local_3:Color = new Color();
		var _local_4:Number = 0.3;
		var _local_5:Number = 1;
		if (ControlsMain.isVrModeActive()) {
			_local_5 = 0;
		}
		;
		if (_arg_1) {
			Animate.legacyTo(_arg_2, 0.3, {"alpha": _local_4}, Animate.ExpoOut);
			_local_3.setTint(0xFFFFFF, 1);
			if (!ControlsMain.isVrModeActive()) {
				_local_6 = (Math.max(1, this.m_fScaleAccum) * PX_BLUR);
				_local_7 = new GlowFilter();
				_local_7.color = 0xFFFFFF;
				_local_7.blurX = (_local_7.blurY = _local_6);
				_local_7.knockout = true;
				_local_7.strength = 20;
				_arg_2.filters = [_local_7];
			}
			;
		} else {
			_local_3.setTint(0xFFFFFF, 1);
			_arg_2.filters = [];
			Animate.legacyTo(_arg_2, 0.3, {"alpha": _local_5}, Animate.ExpoOut);
		}
		;
		_arg_2.transform.colorTransform = _local_3;
	}

	private function loadPrimaryImage(imagePath:String):void {
		var maxWidth:Number;
		var maxHeight:Number;
		var reducedWidth:Number;
		var appliedHeight:Number;
		Animate.kill(this.m_primaryLoader);
		this.m_view.ammoDisplayContainer.ammoDisplay.visible = false;
		if (this.m_primaryLoader != null) {
			this.m_primaryLoader.cancel();
			this.m_view.imageHolderPri_mc.removeChild(this.m_primaryLoader);
			this.m_primaryLoader = null;
		}
		;
		this.m_primaryLoader = new ImageLoader();
		this.m_view.imageHolderPri_mc.addChild(this.m_primaryLoader);
		maxWidth = 190;
		maxHeight = 190;
		reducedWidth = 120;
		appliedHeight = maxHeight;
		if (ControlsMain.isVrModeActive()) {
			appliedHeight = 95;
		}
		;
		this.m_primaryLoader.rotation = 0;
		this.m_primaryLoader.scaleX = (this.m_primaryLoader.scaleY = 1);
		this.m_primaryLoader.loadImage(imagePath, function ():void {
			var _local_1:Boolean;
			if (m_primaryLoader.width > m_primaryLoader.height) {
				m_primaryLoader.rotation = -90;
				_local_1 = true;
			}
			;
			m_primaryLoader.width = reducedWidth;
			m_primaryLoader.scaleY = m_primaryLoader.scaleX;
			if (m_primaryLoader.height > appliedHeight) {
				m_primaryLoader.height = appliedHeight;
				m_primaryLoader.scaleX = m_primaryLoader.scaleY;
			}
			;
			m_primaryLoader.x = (((maxWidth / 2) - m_primaryLoader.width) - ((reducedWidth - m_primaryLoader.width) / 2));
			if (_local_1) {
				m_primaryLoader.y = ((m_primaryLoader.height / 2) + ((maxHeight - m_primaryLoader.height) / 2));
			} else {
				m_primaryLoader.y = ((m_primaryLoader.height / -2) + ((maxHeight - m_primaryLoader.height) / 2));
			}
			;
			if (!ControlsMain.isVrModeActive()) {
				m_view.ammoDisplayContainer.x = (((((120 - m_primaryLoader.width) / 2) - 120) - (m_view.ammoDisplayContainer.ammoDisplay.ammoTotal_txt.x + m_view.ammoDisplayContainer.ammoDisplay.ammoTotal_txt.textWidth)) - 16);
			}
			;
			m_view.ammoDisplayContainer.ammoDisplay.visible = true;
		});
	}

	private function loadSecondaryImage(imagePath:String):void {
		var maxWidth:Number;
		var maxHeight:Number;
		var appliedHeight:Number;
		Animate.kill(this.m_secondaryLoader);
		if (this.m_secondaryLoader != null) {
			this.m_secondaryLoader.cancel();
			this.m_view.imageHolderSec_mc.removeChild(this.m_secondaryLoader);
			this.m_secondaryLoader = null;
		}
		;
		this.m_secondaryLoader = new ImageLoader();
		this.m_view.imageHolderSec_mc.addChild(this.m_secondaryLoader);
		maxWidth = 70;
		maxHeight = 140;
		appliedHeight = maxHeight;
		if (ControlsMain.isVrModeActive()) {
			appliedHeight = 70;
		}
		;
		this.m_secondaryLoader.rotation = 0;
		this.m_secondaryLoader.scaleX = (this.m_secondaryLoader.scaleY = 1);
		this.m_secondaryLoader.loadImage(imagePath, function ():void {
			var _local_1:Boolean;
			if (m_secondaryLoader.width > m_secondaryLoader.height) {
				m_secondaryLoader.rotation = -90;
				_local_1 = true;
			}
			;
			m_secondaryLoader.width = maxWidth;
			m_secondaryLoader.scaleY = m_secondaryLoader.scaleX;
			if (m_secondaryLoader.height > appliedHeight) {
				m_secondaryLoader.height = appliedHeight;
				m_secondaryLoader.scaleX = m_secondaryLoader.scaleY;
			}
			;
			m_secondaryLoader.x = (-(m_secondaryLoader.width) - 4);
			var _local_2:Number = m_secondaryLoader.height;
			if (ControlsMain.isVrModeActive()) {
				_local_2 = maxHeight;
			}
			;
			if (_local_1) {
				m_secondaryLoader.y = _local_2;
			} else {
				m_secondaryLoader.y = -(_local_2);
			}
			;
		});
	}

	private function loadLeftHandImage(imagePath:String):void {
		var maxWidth:Number;
		var maxHeight:Number;
		Animate.kill(this.m_leftHandLoader);
		if (this.m_leftHandLoader != null) {
			this.m_leftHandLoader.cancel();
			this.m_view.imageHolderLeftHand_mc.removeChild(this.m_leftHandLoader);
			this.m_leftHandLoader = null;
		}
		;
		this.m_leftHandLoader = new ImageLoader();
		this.m_view.imageHolderLeftHand_mc.addChild(this.m_leftHandLoader);
		maxWidth = 50;
		maxHeight = 50;
		this.m_leftHandLoader.rotation = 0;
		this.m_leftHandLoader.scaleX = (this.m_leftHandLoader.scaleY = 1);
		this.m_leftHandLoader.loadImage(imagePath, function ():void {
			var _local_1:Boolean;
			if (m_leftHandLoader.width > m_leftHandLoader.height) {
				m_leftHandLoader.rotation = -90;
				_local_1 = true;
			}
			;
			m_leftHandLoader.width = maxWidth;
			m_leftHandLoader.scaleY = m_leftHandLoader.scaleX;
			if (m_leftHandLoader.height > maxHeight) {
				m_leftHandLoader.height = maxHeight;
				m_leftHandLoader.scaleX = m_leftHandLoader.scaleY;
			}
			;
			m_leftHandLoader.x = (-(m_leftHandLoader.width) - 4);
			if (_local_1) {
				m_leftHandLoader.y = (m_leftHandLoader.height - 5);
			} else {
				m_leftHandLoader.y = (m_leftHandLoader.height - 45);
			}
			;
		});
	}

	private function updatePrimaryImageVisibility(_arg_1:Boolean, _arg_2:int):void {
		if (!ControlsMain.isVrModeActive()) {
			this.m_view.imageHolderPri_mc.visible = true;
			return;
		}
		;
		if (!_arg_1) {
			this.m_view.imageHolderPri_mc.visible = false;
			return;
		}
		;
		this.m_view.imageHolderPri_mc.visible = (!(_arg_2 == LEGALSTATE_CLEAR));
	}

	public function showWeaponBackdrop():void {
		if (ControlsMain.isVrModeActive()) {
			return;
		}
		;
		if ((((this.m_primaryIsShown) || (this.m_secondaryIsShown)) || (this.m_leftHandIsShown))) {
			this.m_weaponBackground.visible = true;
		}
		;
	}

	public function hideWeaponBackdrop():void {
		this.m_weaponBackground.visible = false;
	}

	public function setActionSelectionMode():void {
		Animate.kill(this.m_view);
		if ((((this.m_primaryIsShown) || (this.m_secondaryIsShown)) || (this.m_leftHandIsShown))) {
			Animate.to(this.m_view, 0.2, 0, {"alpha": 0.3}, Animate.ExpoOut);
		}
		;
	}

	public function unsetActionSelectionMode():void {
		Animate.kill(this.m_view);
		if ((((this.m_primaryIsShown) || (this.m_secondaryIsShown)) || (this.m_leftHandIsShown))) {
			Animate.to(this.m_view, 0.2, 0, {"alpha": 1}, Animate.ExpoOut);
		}
		;
	}

	private function xAlignSecondary():void {
		this.m_secondaryLoader.x = (this.m_primaryLoader.x + (this.m_primaryLoader.width / this.m_view.imageHolderPri_mc.scaleX));
		this.m_view.imageHolderSec_mc.x = (this.m_view.imageHolderPri_mc.x / this.m_view.imageHolderPri_mc.scaleX);
	}

	public function EnterSniperMode():void {
		this.m_sniperModeIsEntered = true;
		if (((this.m_reloadAnimIsRunning) && (this.m_reloadUrgent))) {
			this.m_view.reloadHolder.alpha = 0;
		}
		;
	}

	public function ExitSniperMode():void {
		this.m_sniperModeIsEntered = false;
		this.m_view.reloadHolder.alpha = 1;
	}

	override public function onSetVisible(_arg_1:Boolean):void {
		this.visible = _arg_1;
	}

	override public function onSetSize(_arg_1:Number, _arg_2:Number):void {
		var _local_4:DisplayObject;
		var _local_5:Array;
		var _local_6:GlowFilter;
		var _local_7:Number;
		if (ControlsMain.isVrModeActive()) {
			return;
		}
		;
		this.m_fScaleAccum = 1;
		var _local_3:DisplayObject = this;
		do {
			this.m_fScaleAccum = (this.m_fScaleAccum * _local_3.scaleX);
			_local_3 = _local_3.parent;
		} while (_local_3 != _local_3.root);
		for each (_local_4 in [this.m_view.imageHolderSec_mc, this.m_view.imageHolderPri_mc]) {
			_local_5 = _local_4.filters;
			if (!((_local_5 == null) || (_local_5.length == 0))) {
				_local_6 = (_local_5[0] as GlowFilter);
				if (_local_6 != null) {
					_local_7 = (Math.max(1, this.m_fScaleAccum) * PX_BLUR);
					_local_6.blurX = (_local_6.blurY = _local_7);
					_local_4.filters = _local_5;
				}
				;
			}
			;
		}
		;
	}


}
}//package hud

