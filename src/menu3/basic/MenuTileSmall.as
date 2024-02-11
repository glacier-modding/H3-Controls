// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.MenuTileSmall

package menu3.basic {
import menu3.MenuElementLockableContentBase;
import menu3.MenuImageLoader;

import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.CommonUtils;
import common.Animate;

import flash.display.Sprite;

import menu3.indicator.InPlaylistIndicator;

public dynamic class MenuTileSmall extends MenuElementLockableContentBase {

	protected var m_view:MenuTileSmallView;
	private var m_loader:MenuImageLoader;
	private var m_pressable:Boolean = true;
	private var m_hidebarcode:Boolean;
	private var m_infoIndicatorWithTitle:InfoIndicatorWithTitleSmallView;
	private var m_iconLabel:String;
	private var m_currentImage:String;
	private var m_hadValidAgencyPickupData:Boolean = false;

	public function MenuTileSmall(_arg_1:Object) {
		super(_arg_1);
		this.m_view = new MenuTileSmallView();
		this.m_view.tileBg.alpha = 0;
		this.m_view.tileDarkBg.alpha = 0.3;
		this.m_view.dropShadow.alpha = 0;
		addChild(this.m_view);
	}

	override public function onSetData(_arg_1:Object):void {
		var _local_3:Boolean;
		var _local_4:String;
		var _local_5:String;
		var _local_6:String;
		super.onSetData(_arg_1);
		this.removeIndicators();
		MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_MENU_TABS_BACKGROUND, true, MenuConstants.MenuElementBackgroundAlpha);
		this.m_pressable = getNodeProp(this, "pressable");
		this.m_iconLabel = _arg_1.icon;
		MenuUtils.setupIcon(this.m_view.tileIcon, this.m_iconLabel, ((this.m_pressable) ? MenuConstants.COLOR_WHITE : MenuConstants.COLOR_GREY), true, false);
		this.m_hidebarcode = _arg_1.hidebarcode;
		var _local_2:* = (!(_arg_1.agencypickup == null));
		if (((!(_local_2)) && (this.m_hadValidAgencyPickupData))) {
			setAgencyPickup(this.m_view, _arg_1, "small");
		}

		this.m_hadValidAgencyPickupData = _local_2;
		if (_arg_1.image) {
			this.loadImage(_arg_1.image);
		}

		if (_arg_1.availability) {
			setAvailablity(this.m_view, _arg_1, "small");
		}

		if (_local_2) {
			setAgencyPickup(this.m_view, _arg_1, "small");
		}

		if (_arg_1.setassaveslotheader) {
			_local_3 = false;
			_local_4 = "";
			_local_5 = "";
			_local_6 = "";
			if (_arg_1.saveslotheaderdata != null) {
				_local_3 = ((_arg_1.saveslotheaderdata.disable != undefined) ? _arg_1.saveslotheaderdata.disable : false);
				_local_4 = ((_arg_1.saveslotheaderdata.infotitle != undefined) ? _arg_1.saveslotheaderdata.infotitle : "");
				_local_5 = ((_arg_1.saveslotheaderdata.infotext != undefined) ? _arg_1.saveslotheaderdata.infotext : "");
				_local_6 = ((_arg_1.saveslotheaderdata.infoicon != undefined) ? _arg_1.saveslotheaderdata.infoicon : "");
			}

			this.m_view.tileSelect.alpha = 0;
			this.m_view.dropShadow.alpha = 0;
			this.m_view.tileDarkBg.alpha = 1;
			MenuUtils.setColor(this.m_view.tileDarkBg, MenuConstants.COLOR_MENU_TABS_BACKGROUND, true, MenuConstants.MenuElementBackgroundAlpha);
			this.m_view.tileIcon.x = 317;
			MenuUtils.setupIcon(this.m_view.tileIcon, "arrowright", MenuConstants.COLOR_WHITE, false, false);
			this.m_view.title.width = 280;
			this.m_view.title.multiline = true;
			this.m_view.title.wordWrap = true;
			this.m_view.title.autoSize = "left";
			MenuUtils.setupTextUpper(this.m_view.header, _arg_1.header, 14, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
			MenuUtils.setupTextUpper(this.m_view.title, _arg_1.title, 26, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			this.m_view.header.x = 14;
			this.m_view.header.y = (208 - (25 * (this.m_view.title.numLines - 1)));
			this.m_view.title.x = 13;
			this.m_view.title.y = (220 - (25 * (this.m_view.title.numLines - 1)));
			if (((_local_5.length > 0) || (_local_4.length > 0))) {
				this.setupInfoIndicatorWithTitle(_local_4, _local_5, _local_6);
			}

		} else {
			this.setupTextFields(_arg_1.header, _arg_1.title);
			this.changeTextColor(((this.m_pressable) ? MenuConstants.COLOR_WHITE : MenuConstants.COLOR_GREY), ((this.m_pressable) ? MenuConstants.COLOR_WHITE : MenuConstants.COLOR_GREY));
		}

		this.handleSelectionChange();
	}

	private function removeIndicators():void {
		if (this.m_infoIndicatorWithTitle != null) {
			this.m_view.indicator.removeChild(this.m_infoIndicatorWithTitle);
			this.m_infoIndicatorWithTitle = null;
		}

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

		this.m_currentImage = imagePath;
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
			m_view.image.height = MenuConstants.MenuTileSmallHeight;
			m_view.image.scaleX = m_view.image.scaleY;
			if (m_view.image.width < MenuConstants.MenuTileSmallWidth) {
				m_view.image.width = MenuConstants.MenuTileSmallWidth;
				m_view.image.scaleY = m_view.image.scaleX;
			}

		});
	}

	override public function getView():Sprite {
		return (this.m_view.tileBg);
	}

	override protected function handleSelectionChange():void {
		var _local_1:InPlaylistIndicator;
		super.handleSelectionChange();
		Animate.complete(this.m_view);
		if (!this.m_hidebarcode) {
			_local_1 = (getIndicator(EInPlaylistIndicator) as InPlaylistIndicator);
			if (_local_1 != null) {
				_local_1.setColorInvert(false);
			}

		}

		if (m_loading) {
			return;
		}

		if (m_isSelected) {
			setPopOutScale(this.m_view, true);
			Animate.to(this.m_view.dropShadow, 0.3, 0, {"alpha": 1}, Animate.ExpoOut);
			if (this.m_pressable) {
				MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_RED, true, MenuConstants.MenuElementSelectedAlpha);
				MenuUtils.setupIcon(this.m_view.tileIcon, this.m_iconLabel, MenuConstants.COLOR_RED, false, true, MenuConstants.COLOR_WHITE, 1, 0, true);
				if (!this.m_hidebarcode) {
					_local_1 = (getIndicator(EInPlaylistIndicator) as InPlaylistIndicator);
					if (_local_1 != null) {
						_local_1.setColorInvert(true);
					}

				}

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
		super.onUnregister();
		if (this.m_view) {
			this.completeAnimations();
			if (this.m_loader) {
				this.m_loader.cancelIfLoading();
				this.m_view.image.removeChild(this.m_loader);
				this.m_loader = null;
			}

			this.removeIndicators();
			removeChild(this.m_view);
			this.m_view = null;
		}

	}

	private function completeAnimations():void {
		Animate.complete(this.m_view.tileDarkBg);
		if (!this.m_hidebarcode) {
			if (m_infoIndicator != null) {
				Animate.complete(m_infoIndicator);
			}

		}

	}

	private function setupInfoIndicatorWithTitle(_arg_1:String, _arg_2:String, _arg_3:String):void {
		var _local_4:int;
		var _local_5:int;
		var _local_6:int;
		var _local_7:Number;
		this.m_infoIndicatorWithTitle = new InfoIndicatorWithTitleSmallView();
		this.m_infoIndicatorWithTitle.y = 3;
		this.m_infoIndicatorWithTitle.title.x = 13;
		this.m_infoIndicatorWithTitle.title.y = 57;
		this.m_infoIndicatorWithTitle.text.x = 14;
		this.m_infoIndicatorWithTitle.text.y = 92;
		this.m_infoIndicatorWithTitle.title.width = 325;
		this.m_infoIndicatorWithTitle.text.width = 325;
		this.m_infoIndicatorWithTitle.darkBg.visible = false;
		this.m_infoIndicatorWithTitle.line.visible = false;
		MenuUtils.setupText(this.m_infoIndicatorWithTitle.title, _arg_1, 28, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
		MenuUtils.shrinkTextToFit(this.m_infoIndicatorWithTitle.title, this.m_infoIndicatorWithTitle.title.width, 0);
		MenuUtils.setupText(this.m_infoIndicatorWithTitle.text, _arg_2, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		if (_arg_2.length > 0) {
			this.m_infoIndicatorWithTitle.text.multiline = true;
			this.m_infoIndicatorWithTitle.text.wordWrap = true;
			this.m_infoIndicatorWithTitle.text.autoSize = "left";
			_local_4 = 24;
			_local_5 = 5;
			_local_6 = Math.min(this.m_infoIndicatorWithTitle.text.numLines, _local_5);
			_local_7 = 5;
			MenuUtils.truncateTextfield(this.m_infoIndicatorWithTitle.text, _local_5);
		}

		if (_arg_3.length > 0) {
			MenuUtils.setupIcon(this.m_infoIndicatorWithTitle.icon, _arg_3, MenuConstants.COLOR_WHITE, true, false);
		} else {
			this.m_infoIndicatorWithTitle.icon.visible = false;
		}

		this.m_view.indicator.addChild(this.m_infoIndicatorWithTitle);
	}


}
}//package menu3.basic

