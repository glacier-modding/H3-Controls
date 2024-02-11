// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.ItemTileTall

package menu3.basic {
import menu3.MenuElementTileBase;
import menu3.MenuImageLoader;

import common.menu.textTicker;

import menu3.CountDownTimer;

import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.Localization;

import flash.display.Sprite;

import common.CommonUtils;
import common.Animate;

public dynamic class ItemTileTall extends MenuElementTileBase {

	private var m_view:ItemTileTallView;
	private var m_loader:MenuImageLoader;
	private var m_timeindicator:TimeIndicatorSmallView;
	private var m_locked:Boolean;
	private var m_lockedIndicator:LockedIndicatorView;
	private var m_timed:Boolean;
	private var m_textObj:Object = {};
	private var m_textTicker:textTicker;
	private var m_countDownTimer:CountDownTimer;
	private var m_playableSince:String;
	private var m_playableUntil:String;
	private var m_pressable:Boolean = true;
	private var m_iconLabel:String;

	public function ItemTileTall(_arg_1:Object) {
		super(_arg_1);
		this.m_view = new ItemTileTallView();
		this.m_view.tileBg.alpha = 0;
		this.m_view.tileDarkBg.alpha = 0.3;
		this.m_view.dropShadow.alpha = 0;
		addChild(this.m_view);
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		this.m_pressable = false;
		this.m_pressable = getNodeProp(this, "pressable");
		MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_MENU_TABS_BACKGROUND, true, MenuConstants.MenuElementBackgroundAlpha);
		this.m_iconLabel = _arg_1.icon;
		MenuUtils.setupIcon(this.m_view.tileIcon, this.m_iconLabel, ((this.m_pressable) ? MenuConstants.COLOR_WHITE : MenuConstants.COLOR_GREY), true, false);
		this.setupTextFields(_arg_1.header, _arg_1.title);
		this.changeTextColor(((this.m_pressable) ? MenuConstants.COLOR_WHITE : MenuConstants.COLOR_GREY), ((this.m_pressable) ? MenuConstants.COLOR_WHITE : MenuConstants.COLOR_GREY));
		if (_arg_1.playableSince) {
			if (!this.m_countDownTimer) {
				this.m_countDownTimer = new CountDownTimer();
			}

			if (this.m_countDownTimer.validateTimeStamp(_arg_1.playableSince)) {
				this.m_playableSince = _arg_1.playableSince;
				this.m_timed = true;
			} else {
				this.m_countDownTimer = null;
			}

		}

		if (_arg_1.playableUntil) {
			if (!this.m_countDownTimer) {
				this.m_countDownTimer = new CountDownTimer();
			}

			if (this.m_countDownTimer.validateTimeStamp(_arg_1.playableUntil)) {
				this.m_playableUntil = _arg_1.playableUntil;
				this.m_timed = true;
			} else {
				this.m_countDownTimer = null;
			}

		}

		if (this.m_playableSince) {
			this.m_locked = true;
			this.m_lockedIndicator = new LockedIndicatorView();
			addChild(this.m_lockedIndicator);
			this.showTimer(this.m_playableSince, Localization.get("UI_DIALOG_TARGET_ARRIVES"));
		} else {
			if (this.m_playableUntil) {
				this.showTimer(this.m_playableUntil, Localization.get("UI_DIALOG_TARGET_ESCAPES"));
			}

		}

		if (_arg_1.image) {
			this.loadImage(_arg_1.image);
		}

	}

	override public function getView():Sprite {
		return (this.m_view.tileBg);
	}

	private function setupTextFields(_arg_1:String, _arg_2:String):void {
		MenuUtils.setupTextUpper(this.m_view.header, _arg_1, 14, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		MenuUtils.setupTextUpper(this.m_view.title, _arg_2, 26, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		this.m_textObj.header = this.m_view.header.htmlText;
		this.m_textObj.title = this.m_view.title.htmlText;
		MenuUtils.truncateTextfield(this.m_view.header, 1, MenuConstants.FontColorWhite, CommonUtils.changeFontToGlobalIfNeeded(this.m_view.header));
		MenuUtils.truncateTextfield(this.m_view.title, 1, MenuConstants.FontColorWhite, CommonUtils.changeFontToGlobalIfNeeded(this.m_view.title));
	}

	private function callTextTicker(_arg_1:Boolean):void {
		if (!this.m_textTicker) {
			this.m_textTicker = new textTicker();
		}

		if (_arg_1) {
			this.m_textTicker.startTextTicker(this.m_view.title, this.m_textObj.title);
		} else {
			this.m_textTicker.stopTextTicker(this.m_view.title, this.m_textObj.title);
			MenuUtils.truncateTextfield(this.m_view.title, 1, MenuConstants.FontColorWhite);
		}

	}

	private function changeTextColor(_arg_1:uint, _arg_2:uint):void {
		this.m_view.header.textColor = _arg_1;
		this.m_view.title.textColor = _arg_2;
	}

	private function showText(_arg_1:Boolean):void {
		this.m_view.header.visible = _arg_1;
		this.m_view.title.visible = _arg_1;
	}

	private function loadImage(imagePath:String):void {
		if (this.m_loader != null) {
			this.m_loader.cancelIfLoading();
			this.m_view.image.removeChild(this.m_loader);
			this.m_loader = null;
		}

		this.m_loader = new MenuImageLoader(ControlsMain.isVrModeActive());
		this.m_view.image.addChild(this.m_loader);
		this.m_loader.center = true;
		this.m_loader.loadImage(imagePath, function ():void {
			Animate.legacyTo(m_view.tileDarkBg, 0.3, {"alpha": 0}, Animate.Linear);
			MenuUtils.trySetCacheAsBitmap(m_view.image, true);
			m_view.image.height = MenuConstants.MenuTileLargeHeight;
			m_view.image.scaleX = m_view.image.scaleY;
			if (m_view.image.width < MenuConstants.MenuTileTallWidth) {
				m_view.image.width = MenuConstants.MenuTileTallWidth;
				m_view.image.scaleY = m_view.image.scaleX;
			}

		});
	}

	private function showTimer(_arg_1:String, _arg_2:String):void {
		if (!this.m_countDownTimer) {
			this.m_countDownTimer = new CountDownTimer();
		}

		if (!this.m_timeindicator) {
			this.m_timeindicator = new TimeIndicatorSmallView();
			this.m_timeindicator.y = (this.m_view.tileBg.height - MenuConstants.ValueIndicatorYOffset);
			addChild(this.m_timeindicator);
		}

		MenuUtils.setupText(this.m_timeindicator.header, _arg_2, 18, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		MenuUtils.truncateTextfield(this.m_timeindicator.header, 1, MenuConstants.FontColorWhite);
		this.m_countDownTimer.startCountDown(this.m_timeindicator.title, _arg_1, this);
	}

	public function timerComplete():void {
		this.m_countDownTimer = null;
		if (this.m_locked) {
			this.m_locked = false;
			removeChild(this.m_lockedIndicator);
			if (this.m_playableUntil) {
				this.showTimer(this.m_playableUntil, Localization.get("UI_DIALOG_TARGET_ESCAPES"));
			}

		} else {
			this.m_timed = false;
			removeChild(this.m_timeindicator);
		}

	}

	override protected function handleSelectionChange():void {
		Animate.complete(this.m_view);
		if (m_loading) {
			return;
		}

		if (m_isSelected) {
			setPopOutScale(this.m_view, true);
			Animate.to(this.m_view.dropShadow, 0.3, 0, {"alpha": 1}, Animate.ExpoOut);
			if (this.m_pressable) {
				MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_RED, true, MenuConstants.MenuElementSelectedAlpha);
				MenuUtils.setupIcon(this.m_view.tileIcon, this.m_iconLabel, MenuConstants.COLOR_RED, false, true, MenuConstants.COLOR_WHITE, 1, 0, true);
			}

		} else {
			setPopOutScale(this.m_view, false);
			Animate.kill(this.m_view.dropShadow);
			this.m_view.dropShadow.alpha = 0;
			if (this.m_pressable) {
				MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_MENU_TABS_BACKGROUND, true, MenuConstants.MenuElementBackgroundAlpha);
				MenuUtils.setupIcon(this.m_view.tileIcon, this.m_iconLabel, MenuConstants.COLOR_WHITE, true, false);
			}

		}

	}

	override public function onUnregister():void {
		if (this.m_view) {
			this.completeAnimations();
			if (this.m_countDownTimer) {
				this.m_countDownTimer.stopCountDown();
				this.m_countDownTimer = null;
			}

			if (this.m_loader != null) {
				this.m_loader.cancelIfLoading();
				this.m_view.image.removeChild(this.m_loader);
				this.m_loader = null;
			}

			if (this.m_timeindicator) {
				removeChild(this.m_timeindicator);
				this.m_timeindicator = null;
			}

			if (this.m_lockedIndicator) {
				removeChild(this.m_lockedIndicator);
				this.m_lockedIndicator = null;
			}

			if (this.m_textTicker) {
				this.m_textTicker.stopTextTicker(this.m_view.title, this.m_textObj.title);
				this.m_textTicker = null;
			}

			removeChild(this.m_view);
			this.m_view = null;
		}

		super.onUnregister();
	}

	private function completeAnimations():void {
		Animate.complete(this.m_view.tileDarkBg);
		Animate.complete(this.m_view.tileSelect);
		MenuUtils.pulsate(this.m_view.tileSelectPulsate, false);
		Animate.complete(this.m_view.tileBarcode);
		Animate.complete(this.m_view.barcodeBg);
	}


}
}//package menu3.basic

