// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.LoadSaveTileSmall

package menu3.basic {
import menu3.MenuElementAvailabilityBase;
import menu3.MenuImageLoader;

import common.menu.textTicker;
import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.TaskletSequencer;
import common.Localization;
import common.CommonUtils;
import common.DateTimeUtils;

import flash.display.Sprite;

import common.Animate;

public dynamic class LoadSaveTileSmall extends MenuElementAvailabilityBase {

	private const MILLISECONDS_PER_DAY:Number = 86400000;

	private var m_view:LoadSaveTileSmallView;
	private var m_loader:MenuImageLoader;
	private var m_timeSavedIndicator:SavegameIndicatorSmallView;
	private var m_occupied:Boolean;
	private var m_textObj:Object = new Object();
	private var m_textTicker:textTicker;
	private var m_pressable:Boolean = true;
	private var m_available:Boolean = true;
	private var m_disable:Boolean = false;
	private var m_saveWasOffline:Boolean = false;
	private var m_saveSlotDisabledIndicator:InfoIndicatorSmallView;
	private var m_iconLabel:String;
	private var m_imagePath:String;

	public function LoadSaveTileSmall(_arg_1:Object) {
		super(_arg_1);
		this.m_view = new LoadSaveTileSmallView();
		this.m_timeSavedIndicator = new SavegameIndicatorSmallView();
		this.m_timeSavedIndicator.visible = false;
		this.m_view.indicator.addChild(this.m_timeSavedIndicator);
		MenuUtils.setColorFilter(this.m_view.image);
		this.m_view.tileBg.alpha = 0;
		this.m_view.tileDarkBg.alpha = 0.3;
		this.m_view.dropShadow.alpha = 0;
		this.m_view.tileSelect.alpha = 0;
		this.m_view.onlineheader.alpha = 0;
		this.m_view.onlinebg.x = 97;
		this.m_view.onlinebg.alpha = 0;
		addChild(this.m_view);
		this.m_loader = new MenuImageLoader(ControlsMain.isVrModeActive());
		this.m_view.image.addChild(this.m_loader);
		this.m_loader.center = true;
		this.m_loader.visible = false;
		this.m_saveSlotDisabledIndicator = new InfoIndicatorSmallView();
		this.m_saveSlotDisabledIndicator.visible = false;
		this.m_view.indicator.addChild(this.m_saveSlotDisabledIndicator);
	}

	override public function onSetData(data:Object):void {
		super.onSetData(data);
		this.m_iconLabel = data.icon;
		MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_RED, false);
		this.m_pressable = true;
		if (getNodeProp(this, "pressable") == false) {
			this.m_pressable = false;
		}
		;
		this.m_occupied = false;
		if (data.occupied) {
			this.m_occupied = true;
		}
		;
		this.m_disable = data.disable;
		this.m_view.difficultyIcon.visible = false;
		MenuUtils.addDropShadowFilter(this.m_view.difficultyIcon);
		if (data.difficultyIcon != null) {
			TaskletSequencer.getGlobalInstance().addChunk(function ():void {
				m_view.difficultyIcon.visible = true;
				MenuUtils.setupIcon(m_view.difficultyIcon, data.difficultyIcon, MenuConstants.COLOR_WHITE, false, false);
			});
		}
		;
		this.setupTextFields(data.header, data.title);
		if (this.m_disable) {
			TaskletSequencer.getGlobalInstance().addChunk(function ():void {
				var _local_2:int;
				MenuUtils.setColorFilter(m_view.image, "desaturated");
				MenuUtils.setupIcon(m_view.tileIcon, m_iconLabel, MenuConstants.COLOR_GREY_MEDIUM, true, false);
				changeTextColor(MenuConstants.COLOR_GREY_MEDIUM, MenuConstants.COLOR_GREY_MEDIUM);
				MenuUtils.setupIcon(m_view.difficultyIcon, "savedisabled", MenuConstants.COLOR_WHITE, false, false);
				MenuUtils.setColor(m_saveSlotDisabledIndicator.darkBg, MenuConstants.COLOR_MENU_BUTTON_TILE_DESELECTED, true, MenuConstants.MenuElementDeselectedAlpha);
				m_saveSlotDisabledIndicator.visible = true;
				m_saveSlotDisabledIndicator.alpha = 0;
				if (!m_pressable) {
					m_saveSlotDisabledIndicator.title.width = 275;
				}
				;
				m_saveSlotDisabledIndicator.y = (m_view.tileBg.height - MenuConstants.ValueIndicatorYOffset);
				var _local_1:String = data.disabletext;
				MenuUtils.setupText(m_saveSlotDisabledIndicator.title, _local_1, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
				m_saveSlotDisabledIndicator.title.multiline = true;
				m_saveSlotDisabledIndicator.title.wordWrap = true;
				m_saveSlotDisabledIndicator.title.autoSize = "left";
				if (m_saveSlotDisabledIndicator.title.numLines > 2) {
					_local_2 = ((m_saveSlotDisabledIndicator.title.numLines - 2) * 24);
					if (m_saveSlotDisabledIndicator.title.numLines > 7) {
						_local_2 = ((7 - 2) * 24);
					}
					;
					m_saveSlotDisabledIndicator.darkBg.height = (m_saveSlotDisabledIndicator.darkBg.height + _local_2);
					m_saveSlotDisabledIndicator.y = (m_saveSlotDisabledIndicator.y - _local_2);
				}
				;
				MenuUtils.truncateTextfield(m_saveSlotDisabledIndicator.title, 7);
				MenuUtils.setupIcon(m_saveSlotDisabledIndicator.valueIcon, "info", MenuConstants.COLOR_WHITE, true, true, MenuConstants.COLOR_BLACK, 0.15);
			});
		} else {
			TaskletSequencer.getGlobalInstance().addChunk(function ():void {
				MenuUtils.setupIcon(m_view.tileIcon, m_iconLabel, ((m_pressable) ? MenuConstants.COLOR_WHITE : MenuConstants.COLOR_GREY_MEDIUM), true, false);
				changeTextColor(((m_pressable) ? MenuConstants.COLOR_WHITE : MenuConstants.COLOR_GREY_MEDIUM), ((m_pressable) ? MenuConstants.COLOR_WHITE : MenuConstants.COLOR_GREY_MEDIUM));
			});
		}
		;
		if (data.availability) {
			TaskletSequencer.getGlobalInstance().addChunk(function ():void {
				setAvailablity(m_view, data, "small");
			});
		}
		;
		if (((!(data.online)) && (data.occupied))) {
			TaskletSequencer.getGlobalInstance().addChunk(function ():void {
				m_saveWasOffline = true;
				m_view.onlineheader.y = 225;
				m_view.onlinebg.y = 237.5;
				m_view.onlineheader.autoSize = "left";
				MenuUtils.setupTextUpper(m_view.onlineheader, Localization.get("UI_DIALOG_USER_OFFLINE"), 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
				CommonUtils.changeFontToGlobalIfNeeded(m_view.onlineheader);
				m_view.onlinebg.width = (m_view.onlineheader.textWidth + 20);
				MenuUtils.setColor(m_view.onlinebg, MenuConstants.COLOR_RED);
				m_view.onlineheader.alpha = 1;
				m_view.onlinebg.alpha = 1;
			});
		}
		;
		if (((!(data.availability == null)) && (data.availability.available === false))) {
			this.m_available = false;
		} else {
			this.m_available = true;
		}
		;
		if (((data.timestamp) && (data.timestampnow))) {
			TaskletSequencer.getGlobalInstance().addChunk(function ():void {
				setTimeindicator(data.timestamp, data.timestampnow);
			});
		}
		;
		TaskletSequencer.getGlobalInstance().addChunk(function ():void {
			showTileInfo(false);
		});
		if (data.image) {
			TaskletSequencer.getGlobalInstance().addChunk(function ():void {
				loadImage(data.image);
			});
		}
		;
		TaskletSequencer.getGlobalInstance().addChunk(function ():void {
			handleSelectionChange();
		});
	}

	private function setTimeindicator(_arg_1:String, _arg_2:String):void {
		var _local_9:String;
		var _local_3:Date = DateTimeUtils.parseLocalTimeStamp(_arg_1);
		var _local_4:Date = DateTimeUtils.parseLocalTimeStamp(_arg_2);
		var _local_5:Number = _local_3.getTime();
		var _local_6:Number = _local_4.setHours(0, 0, 0, 0);
		var _local_7:Boolean = ((_local_6 <= _local_5) && (_local_5 < (_local_6 + this.MILLISECONDS_PER_DAY)));
		var _local_8:Boolean = (((_local_6 - this.MILLISECONDS_PER_DAY) <= _local_5) && (_local_5 < _local_6));
		if (_local_7) {
			_local_9 = Localization.get("UI_DIALOG_TODAY");
		} else {
			if (_local_8) {
				_local_9 = Localization.get("UI_DIALOG_YESTERDAY");
			} else {
				_local_9 = DateTimeUtils.formatLocalDateLocalized(_local_3);
			}
			;
		}
		;
		var _local_10:String = DateTimeUtils.formatLocalDateHM(_local_3);
		this.m_timeSavedIndicator.y = (((this.m_view.tileBg.height - MenuConstants.ValueIndicatorYOffset) + MenuConstants.ValueIndicatorHeight) + MenuConstants.tileGap);
		MenuUtils.setupText(this.m_timeSavedIndicator.header, _local_9, 18, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_timeSavedIndicator.title, _local_10, 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		MenuUtils.truncateTextfield(this.m_timeSavedIndicator.header, 1);
		MenuUtils.truncateTextfield(this.m_timeSavedIndicator.title, 1);
		if (m_isSelected) {
			this.m_timeSavedIndicator.alpha = ((this.m_disable) ? 0 : 1);
			this.m_timeSavedIndicator.y = (this.m_view.tileBg.height - MenuConstants.ValueIndicatorYOffset);
			if (this.m_saveWasOffline) {
				this.m_view.onlineheader.alpha = ((this.m_disable) ? 0 : 1);
				this.m_view.onlinebg.alpha = ((this.m_disable) ? 0 : 1);
				this.m_view.onlineheader.y = 161;
				this.m_view.onlinebg.y = 173.5;
			}
			;
		}
		;
		this.m_timeSavedIndicator.visible = true;
	}

	private function showTileInfo(_arg_1:Boolean):void {
		if (this.m_occupied) {
			if (_arg_1) {
				this.m_view.tileIcon.alpha = 1;
				this.m_view.header.alpha = 1;
				this.m_view.title.alpha = 1;
				if ((((m_valueIndicator) || (m_infoIndicator)) || (this.m_saveSlotDisabledIndicator))) {
					this.m_timeSavedIndicator.alpha = 0;
					this.m_view.onlineheader.alpha = 0;
					this.m_view.onlinebg.alpha = 0;
				} else {
					this.m_timeSavedIndicator.alpha = 1;
					if (this.m_saveWasOffline) {
						this.m_view.onlineheader.alpha = 1;
						this.m_view.onlinebg.alpha = 1;
					}
					;
				}
				;
				if (this.m_disable) {
					this.m_timeSavedIndicator.alpha = 0;
					this.m_view.onlineheader.alpha = 0;
					this.m_view.onlinebg.alpha = 0;
					this.m_saveSlotDisabledIndicator.alpha = 1;
				}
				;
				this.m_timeSavedIndicator.y = (this.m_view.tileBg.height - MenuConstants.ValueIndicatorYOffset);
				this.m_view.onlineheader.y = 161;
				this.m_view.onlinebg.y = 173.5;
			} else {
				this.m_view.tileIcon.alpha = 0;
				this.m_view.header.alpha = 0;
				this.m_view.title.alpha = 0;
				if (this.m_disable) {
					this.m_saveSlotDisabledIndicator.alpha = 0;
				}
				;
				this.m_timeSavedIndicator.alpha = 1;
				this.m_timeSavedIndicator.y = (((this.m_view.tileBg.height - MenuConstants.ValueIndicatorYOffset) + MenuConstants.ValueIndicatorHeight) + MenuConstants.tileGap);
				if (this.m_saveWasOffline) {
					this.m_view.onlineheader.alpha = 1;
					this.m_view.onlinebg.alpha = 1;
					this.m_view.onlineheader.y = 225;
					this.m_view.onlinebg.y = 237.5;
				}
				;
			}
			;
		} else {
			this.m_view.tileIcon.alpha = 1;
			this.m_view.header.alpha = 1;
			this.m_view.title.alpha = 1;
			this.m_timeSavedIndicator.alpha = 0;
			this.m_timeSavedIndicator.y = (((this.m_view.tileBg.height - MenuConstants.ValueIndicatorYOffset) + MenuConstants.ValueIndicatorHeight) + MenuConstants.tileGap);
			this.m_view.onlineheader.alpha = 0;
			this.m_view.onlinebg.alpha = 0;
			this.m_view.onlineheader.y = 225;
			this.m_view.onlinebg.y = 237.5;
			if (this.m_disable) {
				this.m_saveSlotDisabledIndicator.alpha = ((_arg_1) ? 1 : 0);
			}
			;
		}
		;
	}

	override public function getView():Sprite {
		return (this.m_view.tileBg);
	}

	private function setupTextFields(_arg_1:String, _arg_2:String):void {
		MenuUtils.setupTextUpper(this.m_view.header, _arg_1, 14, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorRed);
		MenuUtils.setupTextUpper(this.m_view.title, _arg_2, 26, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraDark);
		this.m_textObj.header = this.m_view.header.htmlText;
		this.m_textObj.title = this.m_view.title.htmlText;
		MenuUtils.truncateTextfield(this.m_view.header, 1, null, CommonUtils.changeFontToGlobalIfNeeded(this.m_view.header));
		MenuUtils.truncateTextfield(this.m_view.title, 1, null, CommonUtils.changeFontToGlobalIfNeeded(this.m_view.title));
	}

	private function callTextTicker(_arg_1:Boolean):void {
		if (!this.m_textTicker) {
			this.m_textTicker = new textTicker();
		}
		;
		if (_arg_1) {
			this.m_textTicker.startTextTicker(this.m_view.title, this.m_textObj.title);
		} else {
			this.m_textTicker.stopTextTicker(this.m_view.title, this.m_textObj.title);
			MenuUtils.truncateTextfield(this.m_view.title, 1);
		}
		;
	}

	private function changeTextColor(_arg_1:uint, _arg_2:uint):void {
		this.m_view.header.textColor = _arg_1;
		this.m_view.title.textColor = _arg_2;
	}

	private function loadImage(imagePath:String):void {
		if (this.m_imagePath == imagePath) {
			return;
		}
		;
		this.m_imagePath = imagePath;
		this.m_loader.cancelIfLoading();
		this.m_loader.visible = true;
		this.m_loader.loadImage(imagePath, function ():void {
			Animate.legacyTo(m_view.tileDarkBg, 0.3, {"alpha": 0}, Animate.Linear);
			MenuUtils.trySetCacheAsBitmap(m_view.image, true);
			var _local_1:Number = (MenuConstants.MenuTileSmallHeight / m_view.image.height);
			var _local_2:Number = (m_view.image.width * _local_1);
			var _local_3:Number = (m_view.image.height * _local_1);
			m_view.image.width = (_local_2 + (MenuConstants.tileImageBorder * 2));
			m_view.image.height = (_local_3 + (MenuConstants.tileImageBorder * 2));
		});
	}

	override protected function handleSelectionChange():void {
		super.handleSelectionChange();
		Animate.complete(this.m_view);
		if (m_loading) {
			return;
		}
		;
		this.showTileInfo(m_isSelected);
		if (m_isSelected) {
			setPopOutScale(this.m_view, true);
			Animate.to(this.m_view.dropShadow, 0.3, 0, {"alpha": 1}, Animate.ExpoOut);
			setOverlayColor(this.m_available);
			if (this.m_pressable) {
				this.changeTextColor(MenuConstants.COLOR_WHITE, MenuConstants.COLOR_WHITE);
				MenuUtils.addDropShadowFilter(this.m_timeSavedIndicator);
				MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_RED, true, MenuConstants.MenuElementSelectedAlpha);
				MenuUtils.setupIcon(this.m_view.tileIcon, this.m_iconLabel, MenuConstants.COLOR_RED, false, true, MenuConstants.COLOR_WHITE, 1, 0, true);
			}
			;
		} else {
			setPopOutScale(this.m_view, false);
			Animate.kill(this.m_view.dropShadow);
			this.m_view.dropShadow.alpha = 0;
			setOverlayColor();
			if (this.m_pressable) {
				this.changeTextColor(MenuConstants.COLOR_WHITE, MenuConstants.COLOR_WHITE);
				MenuUtils.removeDropShadowFilter(this.m_timeSavedIndicator);
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
			if (this.m_textTicker) {
				this.m_textTicker.stopTextTicker(this.m_view.title, this.m_textObj.title);
				this.m_textTicker = null;
			}
			;
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
	}


}
}//package menu3.basic

