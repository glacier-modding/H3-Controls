// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.WeaponOnBackVRWidget

package hud {
import common.BaseControl;

import flash.display.Sprite;

import common.ImageLoader;
import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.Animate;

public class WeaponOnBackVRWidget extends BaseControl {

	private var m_container:Sprite = new Sprite();
	private var m_imgWeapon:ImageLoader = new ImageLoader();
	private var m_legalState:LegalStatePulseView = new LegalStatePulseView();
	private var m_weaponOnBack:WeaponOnBackPulseView = new WeaponOnBackPulseView();
	private var m_pxImageWidth:Number;
	private var m_pxImageHeight:Number;

	public function WeaponOnBackVRWidget() {
		this.m_container.name = "container";
		this.m_imgWeapon.name = "imgWeapon";
		this.m_legalState.name = "legalState";
		this.m_weaponOnBack.name = "weaponOnBack";
		this.m_imgWeapon.rotation = -90;
		MenuUtils.setColor(this.m_imgWeapon, MenuConstants.COLOR_WHITE, true, 1);
		this.m_container.addChild(this.m_imgWeapon);
		this.m_container.addChild(this.m_weaponOnBack);
		this.m_weaponOnBack.x = -28;
		this.m_weaponOnBack.y = -12;
		this.m_container.addChild(this.m_legalState);
		this.m_legalState.x = -3;
		this.m_legalState.y = -12;
		addChild(this.m_container);
	}

	public function changeWeapon(ridImage:String, legalState:int):void {
		this.m_imgWeapon.alpha = 0;
		this.m_legalState.setLegalState(LegalStatePulseView.LEGALSTATE_CLEAR);
		this.m_weaponOnBack.setWeaponOnBack(false);
		this.m_imgWeapon.loadImage(ridImage, function ():void {
			applyImageSize();
			Animate.fromTo(m_imgWeapon, 0.75, 0.5, {"alpha": 0}, {"alpha": 0.5}, Animate.ExpoOut, function ():void {
				m_legalState.setLegalState(legalState);
				m_weaponOnBack.setWeaponOnBack(true);
			});
		});
	}

	private function applyImageSize():void {
		this.m_imgWeapon.scaleX = (this.m_imgWeapon.scaleY = 1);
		this.m_imgWeapon.width = this.m_pxImageWidth;
		this.m_imgWeapon.scaleY = this.m_imgWeapon.scaleX;
		if (this.m_imgWeapon.height > this.m_pxImageHeight) {
			this.m_imgWeapon.height = this.m_pxImageHeight;
			this.m_imgWeapon.scaleX = this.m_imgWeapon.scaleY;
		}
		;
		this.m_imgWeapon.x = ((this.m_pxImageWidth / -2) - (this.m_imgWeapon.width / 2));
		this.m_container.y = this.m_pxImageHeight;
	}

	public function set pxImageWidth(_arg_1:Number):void {
		this.m_pxImageWidth = _arg_1;
		this.applyImageSize();
	}

	public function set pxImageHeight(_arg_1:Number):void {
		this.m_pxImageHeight = _arg_1;
		this.applyImageSize();
	}

	public function set fLegalStateScale(_arg_1:Number):void {
		this.m_legalState.scaleX = (this.m_legalState.scaleY = _arg_1);
	}

	public function set fWeaponOnBackScale(_arg_1:Number):void {
		this.m_weaponOnBack.scaleX = (this.m_weaponOnBack.scaleY = _arg_1);
	}


}
}//package hud

class LegalStatePulseView extends WeaponView_illegalIcon {

	public static const LEGALSTATE_CLEAR:int = 0;
	public static const LEGALSTATE_SUSPICIOUS:int = 1;
	public static const LEGALSTATE_ILLEGAL:int = 2;

	public function LegalStatePulseView() {
		this.visible = false;
	}

	public function setLegalState(_arg_1:int):void {
		if (_arg_1 == LEGALSTATE_CLEAR) {
			this.visible = false;
		} else {
			this.visible = true;
			this.gotoAndStop(((_arg_1 == LEGALSTATE_SUSPICIOUS) ? "susarmed" : "visarmed"));
		}
		;
	}


}

class WeaponOnBackPulseView extends WeaponView_WeaponOnBackBlink {

	public static const LEGALSTATE_CLEAR:int = 0;
	public static const LEGALSTATE_SUSPICIOUS:int = 1;
	public static const LEGALSTATE_ILLEGAL:int = 2;

	public function WeaponOnBackPulseView() {
		this.visible = false;
		this.stop();
	}

	public function setWeaponOnBack(_arg_1:Boolean):void {
		if (_arg_1) {
			this.visible = true;
			this.gotoAndPlay(1);
		} else {
			this.visible = false;
			this.stop();
		}
		;
	}


}


