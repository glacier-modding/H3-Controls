// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.WeaponHolsterVRWidget

package hud {
import common.BaseControl;
import common.ImageLoader;
import common.menu.MenuUtils;
import common.menu.MenuConstants;

import flash.display.MovieClip;

public class WeaponHolsterVRWidget extends BaseControl {

	public static const LEGALSTATE_CLEAR:int = 0;
	public static const LEGALSTATE_SUSPICIOUS:int = 1;
	public static const LEGALSTATE_ILLEGAL:int = 2;

	private var m_view:WeaponHolsterVRWidgetView;
	private var m_primaryLoader:ImageLoader;
	private var m_secondaryLoader:ImageLoader;
	private var m_currentPrimaryImage:String;
	private var m_currentSecondaryImage:String;

	public function WeaponHolsterVRWidget() {
		this.m_view = new WeaponHolsterVRWidgetView();
		this.m_view.visible = false;
		addChild(this.m_view);
		this.m_view.iconOnBackPri_mc.stop();
		this.m_view.iconOnBackSec_mc.stop();
		this.m_primaryLoader = new ImageLoader();
		this.m_primaryLoader.visible = false;
		this.m_view.imageHolderPri_mc.addChild(this.m_primaryLoader);
		this.m_secondaryLoader = new ImageLoader();
		this.m_secondaryLoader.visible = false;
		this.m_view.imageHolderSec_mc.addChild(this.m_secondaryLoader);
		MenuUtils.setColor(this.m_view.imageHolderPri_mc, MenuConstants.COLOR_WHITE, true, 1);
		MenuUtils.setColor(this.m_view.imageHolderSec_mc, MenuConstants.COLOR_WHITE, true, 1);
		this.m_view.imageHolderSec_mc.alpha = 0.5;
		this.m_currentPrimaryImage = "";
		this.m_currentSecondaryImage = "";
	}

	public function onSetData(_arg_1:Object):void {
		if (_arg_1.itemPrimary == null) {
			this.m_view.imageHolderPri_mc.visible = false;
			this.setLegalStateIcon(this.m_view.iconPri_mc, 0.46, LEGALSTATE_CLEAR);
			this.setWeaponOnBackIcon(this.m_view.iconOnBackPri_mc, 0.46, false);
		} else {
			this.m_view.x = ((_arg_1.itemSecondary == null) ? -36 : 0);
			this.m_view.imageHolderPri_mc.visible = true;
			this.setPrimaryWeaponImage(_arg_1.itemPrimary.ridImage);
			if (_arg_1.isPrimaryInHolster) {
				this.m_view.imageHolderPri_mc.alpha = 0.8;
				this.setLegalStateIcon(this.m_view.iconPri_mc, 0.46, _arg_1.itemPrimary.legalState);
				this.m_view.iconOnBackPri_mc.x = 70.5;
				this.setWeaponOnBackIcon(this.m_view.iconOnBackPri_mc, 0.46, ((_arg_1.itemPrimary.isLarge) ? true : false));
			} else {
				this.m_view.imageHolderPri_mc.alpha = 0;
				this.setLegalStateIcon(this.m_view.iconPri_mc, 0.46, LEGALSTATE_CLEAR);
				if (_arg_1.itemPrimary.isLarge) {
					this.m_view.iconOnBackPri_mc.x = ((_arg_1.itemSecondary == null) ? 36 : 0);
					this.setWeaponOnBackIcon(this.m_view.iconOnBackPri_mc, 0.86, true);
				} else {
					this.m_view.iconOnBackPri_mc.x = 70.5;
					this.setWeaponOnBackIcon(this.m_view.iconOnBackPri_mc, 0.46, false);
				}
				;
			}
			;
		}
		;
		if (_arg_1.itemSecondary == null) {
			this.m_view.imageHolderSec_mc.visible = false;
			this.setLegalStateIcon(this.m_view.iconSec_mc, 0.23, LEGALSTATE_CLEAR);
			this.setWeaponOnBackIcon(this.m_view.iconOnBackSec_mc, 0.23, false);
		} else {
			this.m_view.imageHolderSec_mc.visible = true;
			this.setSecondaryWeaponImage(_arg_1.itemSecondary.ridImage);
			this.setLegalStateIcon(this.m_view.iconSec_mc, 0.23, _arg_1.itemSecondary.legalState);
			this.setWeaponOnBackIcon(this.m_view.iconOnBackSec_mc, 0.23, true);
		}
		;
	}

	public function onHandEnteredHolster():void {
		this.m_view.visible = true;
	}

	public function onHandExitedHolster():void {
		this.m_view.visible = false;
	}

	private function setPrimaryWeaponImage(_arg_1:String):void {
		if (this.m_currentPrimaryImage != _arg_1) {
			this.loadPrimaryImage(_arg_1);
			this.m_currentPrimaryImage = _arg_1;
		}
		;
	}

	private function setSecondaryWeaponImage(_arg_1:String):void {
		if (this.m_currentSecondaryImage != _arg_1) {
			this.loadSecondaryImage(_arg_1);
			this.m_currentSecondaryImage = _arg_1;
		}
		;
	}

	private function loadPrimaryImage(imagePath:String):void {
		var/*const*/ MAX_HEIGHT:Number = NaN;
		var/*const*/ REDUCED_WIDTH:Number = NaN;
		this.m_primaryLoader.visible = false;
		var/*const*/ MAX_WIDTH:Number = 190;
		MAX_HEIGHT = 190;
		REDUCED_WIDTH = 120;
		this.m_primaryLoader.rotation = 0;
		this.m_primaryLoader.scaleX = (this.m_primaryLoader.scaleY = 1);
		this.m_primaryLoader.loadImage(imagePath, function ():void {
			var _local_1:Boolean;
			if (m_primaryLoader.width > m_primaryLoader.height) {
				m_primaryLoader.rotation = -90;
				_local_1 = true;
			}
			;
			m_primaryLoader.width = REDUCED_WIDTH;
			m_primaryLoader.scaleY = m_primaryLoader.scaleX;
			if (m_primaryLoader.height > MAX_HEIGHT) {
				m_primaryLoader.height = MAX_HEIGHT;
				m_primaryLoader.scaleX = m_primaryLoader.scaleY;
			}
			;
			m_primaryLoader.x = ((REDUCED_WIDTH / -2) - (m_primaryLoader.width / 2));
			if (_local_1) {
				m_primaryLoader.y = ((m_primaryLoader.height / 2) + ((MAX_HEIGHT - m_primaryLoader.height) / 2));
			} else {
				m_primaryLoader.y = ((m_primaryLoader.height / -2) + ((MAX_HEIGHT - m_primaryLoader.height) / 2));
			}
			;
			m_primaryLoader.visible = true;
		});
	}

	private function loadSecondaryImage(imagePath:String):void {
		var/*const*/ MAX_HEIGHT:Number = NaN;
		var/*const*/ REDUCED_WIDTH:Number = NaN;
		this.m_secondaryLoader.visible = false;
		var/*const*/ MAX_WIDTH:Number = 140;
		MAX_HEIGHT = 140;
		REDUCED_WIDTH = 88;
		this.m_secondaryLoader.rotation = 0;
		this.m_secondaryLoader.scaleX = (this.m_secondaryLoader.scaleY = 1);
		this.m_secondaryLoader.loadImage(imagePath, function ():void {
			var _local_1:Boolean;
			if (m_secondaryLoader.width > m_secondaryLoader.height) {
				m_secondaryLoader.rotation = -90;
				_local_1 = true;
			}
			;
			m_secondaryLoader.width = REDUCED_WIDTH;
			m_secondaryLoader.scaleY = m_secondaryLoader.scaleX;
			if (m_secondaryLoader.height > MAX_HEIGHT) {
				m_secondaryLoader.height = MAX_HEIGHT;
				m_secondaryLoader.scaleX = m_secondaryLoader.scaleY;
			}
			;
			m_secondaryLoader.x = ((REDUCED_WIDTH / -2) - (m_secondaryLoader.width / 2));
			if (_local_1) {
				m_secondaryLoader.y = ((m_secondaryLoader.height / 2) + ((MAX_HEIGHT - m_secondaryLoader.height) / 2));
			} else {
				m_secondaryLoader.y = ((m_secondaryLoader.height / -2) + ((MAX_HEIGHT - m_secondaryLoader.height) / 2));
			}
			;
			m_secondaryLoader.visible = true;
		});
	}

	private function setLegalStateIcon(_arg_1:MovieClip, _arg_2:Number, _arg_3:int):void {
		if (_arg_3 != LEGALSTATE_CLEAR) {
			_arg_1.gotoAndStop(((LEGALSTATE_ILLEGAL) ? "visarmed" : "susarmed"));
			_arg_1.scaleX = _arg_2;
			_arg_1.scaleY = _arg_2;
			_arg_1.visible = true;
		} else {
			_arg_1.visible = false;
		}
		;
	}

	private function setWeaponOnBackIcon(_arg_1:MovieClip, _arg_2:Number, _arg_3:Boolean):void {
		if (_arg_3) {
			_arg_1.scaleX = _arg_2;
			_arg_1.scaleY = _arg_2;
			_arg_1.visible = true;
			_arg_1.gotoAndPlay(1);
		} else {
			_arg_1.visible = false;
		}
		;
	}


}
}//package hud

