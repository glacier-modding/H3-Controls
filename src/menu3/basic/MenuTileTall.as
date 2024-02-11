// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.MenuTileTall

package menu3.basic {
import menu3.MenuElementLockableContentBase;
import menu3.MenuImageLoader;

import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.CommonUtils;
import common.Animate;

import flash.display.Sprite;

public dynamic class MenuTileTall extends MenuElementLockableContentBase {

	protected var m_view:MenuTileTallView;
	private var m_loader:MenuImageLoader;
	private var m_pressable:Boolean = true;
	private var m_iconLabel:String;
	private var m_currentImage:String;

	public function MenuTileTall(_arg_1:Object) {
		super(_arg_1);
		this.m_view = new MenuTileTallView();
		this.m_view.tileBg.alpha = 0;
		this.m_view.tileDarkBg.alpha = 0.3;
		this.m_view.dropShadow.alpha = 0;
		addChild(this.m_view);
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_MENU_TABS_BACKGROUND, true, MenuConstants.MenuElementBackgroundAlpha);
		this.m_pressable = getNodeProp(this, "pressable");
		this.m_iconLabel = _arg_1.icon;
		MenuUtils.setupIcon(this.m_view.tileIcon, this.m_iconLabel, ((this.m_pressable) ? MenuConstants.COLOR_WHITE : MenuConstants.COLOR_GREY), true, false);
		this.setupTextFields(_arg_1.header, _arg_1.title);
		this.changeTextColor(((this.m_pressable) ? MenuConstants.COLOR_WHITE : MenuConstants.COLOR_GREY), ((this.m_pressable) ? MenuConstants.COLOR_WHITE : MenuConstants.COLOR_GREY));
		if (_arg_1.image) {
			this.loadImage(_arg_1.image);
		}
		;
		if (_arg_1.availability) {
			setAvailablity(this.m_view, _arg_1, "small");
		}
		;
		this.handleSelectionChange();
	}

	private function setupTextFields(_arg_1:String, _arg_2:String):void {
		MenuUtils.setupTextUpper(this.m_view.header, _arg_1, 14, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		MenuUtils.setupTextUpper(this.m_view.title, _arg_2, 26, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		MenuUtils.truncateTextfield(this.m_view.header, 1, MenuConstants.FontColorWhite, CommonUtils.changeFontToGlobalIfNeeded(this.m_view.header));
		MenuUtils.truncateTextfield(this.m_view.title, 1, MenuConstants.FontColorWhite, CommonUtils.changeFontToGlobalIfNeeded(this.m_view.title));
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
		if (this.m_currentImage == imagePath) {
			return;
		}
		;
		this.m_currentImage = imagePath;
		if (this.m_loader != null) {
			this.m_loader.cancelIfLoading();
			this.m_view.image.removeChild(this.m_loader);
			this.m_loader = null;
		}
		;
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
			;
		});
	}

	override public function getView():Sprite {
		return (this.m_view.tileBg);
	}

	override protected function handleSelectionChange():void {
		super.handleSelectionChange();
		Animate.complete(this.m_view);
		if (m_loading) {
			return;
		}
		;
		if (m_isSelected) {
			setPopOutScale(this.m_view, true);
			Animate.to(this.m_view.dropShadow, 0.3, 0, {"alpha": 1}, Animate.ExpoOut);
			if (this.m_pressable) {
				MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_RED, true, MenuConstants.MenuElementSelectedAlpha);
				MenuUtils.setupIcon(this.m_view.tileIcon, this.m_iconLabel, MenuConstants.COLOR_RED, false, true, MenuConstants.COLOR_WHITE, 1, 0, true);
			}
			;
		} else {
			setPopOutScale(this.m_view, false);
			Animate.kill(this.m_view.dropShadow);
			this.m_view.dropShadow.alpha = 0;
			if (this.m_pressable) {
				MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_MENU_TABS_BACKGROUND, true, MenuConstants.MenuElementBackgroundAlpha);
				MenuUtils.setupIcon(this.m_view.tileIcon, this.m_iconLabel, MenuConstants.COLOR_WHITE, true, false);
			}
			;
		}
		;
	}

	override public function onUnregister():void {
		super.onUnregister();
		if (this.m_view) {
			this.completeAnimations();
			if (this.m_loader) {
				this.m_loader.cancelIfLoading();
				this.m_view.image.removeChild(this.m_loader);
				this.m_loader = null;
			}
			;
			removeChild(this.m_view);
			this.m_view = null;
		}
		;
	}

	private function completeAnimations():void {
		Animate.complete(this.m_view.tileDarkBg);
		if (m_infoIndicator != null) {
			Animate.complete(m_infoIndicator);
		}
		;
	}


}
}//package menu3.basic

