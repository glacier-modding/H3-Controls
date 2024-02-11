// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.WeaponSelector

package hud {
import common.BaseControl;

import flash.display.Sprite;
import flash.display.DisplayObject;

import common.menu.textTicker;

import menu3.basic.TextTickerUtil;

import common.menu.MenuConstants;

import __AS3__.vec.Vector;

import flash.utils.Dictionary;

import common.menu.MenuUtils;
import common.Localization;
import common.ImageLoader;
import common.Animate;

import flash.events.Event;
import flash.utils.getTimer;

import common.CommonUtils;

import hud.evergreen.EvergreenUtils;

import flash.display.MovieClip;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.filters.GlowFilter;

import scaleform.gfx.Extensions;

import __AS3__.vec.*;

import flash.utils.*;

public class WeaponSelector extends BaseControl {

	private static const PX_BLUR:Number = 4;
	private static const PX_PERKICONSIZE:Number = 30;
	private static const PX_PERKICONGAP:Number = 10;

	private const PROMPT_SEP_STRING:String = "        ";

	private var m_container:Sprite;
	private var m_mainCarousel:Sprite;
	private var m_background:Sprite;
	private var m_perksHolder:Sprite;
	private var m_killTypesHolder:Sprite;
	private var m_poisonTypesHolder:Sprite;
	private var m_weaponInfoHolder:Sprite;
	private var m_warningInfoHolder:Sprite;
	private var m_ghostItemIndicatorHolder:Sprite;
	private var m_evergreenRarityLabel:DisplayObject;
	private var m_evergreenLoseOnWoundedLabel:WeaponSelectorKilltypeView;
	private var m_view:WeaponSelectorView;
	private var m_weaponInfo:WeaponSelectorInfoView;
	private var m_actionIllegalWarning:WeaponSelectorWarningView;
	private var m_actionIllegalWarningBackDrop:Sprite;
	private var m_textTicker:textTicker;
	private var m_textTickerUtilDesc:TextTickerUtil = new TextTickerUtil();
	private var m_textObj:Object = new Object();
	private var m_selectedIndex:int;
	private var m_loadingOriginIndex:int;
	private var m_previousSelectedIndex:int = -1;
	private var m_animDirection:int;
	private var m_inventoryBgWidth:int = ((MenuConstants.BaseWidth - (47 * 2)) - (210 * 2));
	private var m_inventoryBgHeight:int = 210;
	private var m_ellipseWidth:int = 600;
	private var m_ellipseHeight:int = 20;
	private var m_imageLoadCount:int = 0;
	private var m_scaleDownFactor:Number;
	private var m_isRotationRunning:Boolean = false;
	private var m_currentFrame:int = 0;
	private var m_prevFrame:int = 0;
	private var m_itemInfoPosX:Number = 0;
	private var m_animIndexStart:Number;
	private var m_itemsInView:Number;
	private var m_aChildrenPool:Array = new Array();
	private var m_aChildrenImageLoaderPool:Array = new Array();
	private var m_aChildrenImageLoader2Pool:Array = new Array();
	private var m_aWarnings:Array;
	private var m_isActionInventory:Boolean;
	private var m_initialImageLoaded:Boolean;
	private var m_isShowLineWanted:Boolean = false;
	private var m_showLine:Boolean = false;
	private var m_currentSlotData:Object = null;
	private var m_data:Object = null;
	private var m_imageRequestMax:int = 5;
	private var m_currentImageRequestIndex:int = 0;
	private var m_blockImageQueue:Boolean = false;
	private var m_poisonViewLethal:WeaponSelectorPoisonTypeView;
	private var m_poisonViewSedative:WeaponSelectorPoisonTypeView;
	private var m_poisonViewEmetic:WeaponSelectorPoisonTypeView;
	private var m_killTypeViews:Vector.<WeaponSelectorKilltypeView> = new Vector.<WeaponSelectorKilltypeView>();
	private var m_ghostItemIndicator:WeaponSelectorGhostItemView;
	private var m_perkElements:Vector.<WeaponSelectorPerksView> = new Vector.<WeaponSelectorPerksView>();
	private var m_perkIcons:Vector.<iconsAll76x76View> = new Vector.<iconsAll76x76View>();
	private var m_locNoAvailableItems:String;
	private var m_locNoItems:String;
	private var m_scaleUp:Boolean = false;
	private var m_fontSizeTiny:int = 16;
	private var m_fontSizeMedium:int = 18;
	private var m_labelOffsetY:int = 61;
	private var m_labelFont:String = "$medium";
	private var m_imagesThatHaveFilters:Dictionary = new Dictionary(true);
	private var m_fScaleAccum:Number = 1;

	public function WeaponSelector() {
		if (ControlsMain.isVrModeActive()) {
			this.m_scaleUp = true;
			this.m_fontSizeTiny = 20;
			this.m_fontSizeMedium = 22;
			this.m_labelOffsetY = 48;
			this.m_labelFont = MenuConstants.FONT_TYPE_BOLD;
		}
		;
		this.m_selectedIndex = 0;
		this.m_previousSelectedIndex = -1;
		this.m_animIndexStart = 0;
		this.m_itemsInView = 0;
		this.m_background = new Sprite();
		this.m_background.name = "m_background";
		addChild(this.m_background);
		this.m_container = new Sprite();
		this.m_container.name = "m_container";
		addChild(this.m_container);
		this.m_isActionInventory = false;
		this.m_view = new WeaponSelectorView();
		this.m_view.name = "m_view";
		this.m_view.alpha = 0;
		this.m_container.addChild(this.m_view);
		this.m_mainCarousel = new Sprite();
		this.m_mainCarousel.name = "m_mainCarousel";
		this.m_mainCarousel.y = -40;
		this.m_view.addChild(this.m_mainCarousel);
		this.m_weaponInfoHolder = new Sprite();
		this.m_weaponInfoHolder.name = "m_weaponInfoHolder";
		this.m_weaponInfoHolder.y = 16;
		this.m_view.addChild(this.m_weaponInfoHolder);
		this.m_warningInfoHolder = new Sprite();
		this.m_warningInfoHolder.name = "m_warningInfoHolder";
		if (this.m_scaleUp) {
			this.m_warningInfoHolder.scaleX = 1.2;
			this.m_warningInfoHolder.scaleY = 1.2;
		}
		;
		this.m_weaponInfoHolder.addChild(this.m_warningInfoHolder);
		this.instantiateWarningMessages();
		this.m_weaponInfo = new WeaponSelectorInfoView();
		this.m_weaponInfo.name = "m_weaponInfo";
		this.m_weaponInfoHolder.addChild(this.m_weaponInfo);
		MenuUtils.setColor(this.m_weaponInfo.line, MenuConstants.COLOR_GREY_ULTRA_LIGHT, false);
		this.m_weaponInfo.line.alpha = 0;
		MenuUtils.setupText(this.m_weaponInfo.label_text, "", 50, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorGreyUltraLight);
		MenuUtils.setupText(this.m_weaponInfo.container_label_text, "", 24, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorGreyUltraLight);
		MenuUtils.setupText(this.m_weaponInfo.action_text, "", this.m_fontSizeTiny, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
		MenuUtils.setupText(this.m_weaponInfo.desc_text, "", this.m_fontSizeTiny, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
		this.m_weaponInfo.desc_text.visible = false;
		MenuUtils.setupText(this.m_weaponInfo.missing_mc.missing_txt, "", this.m_fontSizeTiny, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		this.m_weaponInfo.missing_mc.missing_txt.autoSize = "left";
		this.m_weaponInfo.missing_mc.visible = false;
		MenuUtils.setupText(this.m_weaponInfo.ammoDisplay.ammoCurrent_txt, "", 36, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorGreyUltraLight);
		MenuUtils.setupText(this.m_weaponInfo.ammoDisplay.ammoTotal_txt, "", 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
		if (this.m_scaleUp) {
			this.m_weaponInfo.ammoDisplay.scaleX = 1.2;
			this.m_weaponInfo.ammoDisplay.scaleY = 1.2;
			this.m_weaponInfo.missing_mc.redback_mc.height = (this.m_weaponInfo.missing_mc.redback_mc.height * 1.2);
			this.m_weaponInfo.desc_text.height = (this.m_weaponInfo.desc_text.height * 1.2);
		}
		;
		this.reserveAvailableSlots(30);
		MenuUtils.setupText(this.m_view.prompt_txt, "", this.m_fontSizeMedium, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
		this.m_view.prompt_txt.autoSize = "left";
		this.m_view.prompt_txt.x = ((this.m_inventoryBgWidth / -2) + 10);
		this.m_view.prompt_txt.y = ((this.m_inventoryBgHeight / 2) - 30);
		this.m_actionIllegalWarning = new WeaponSelectorWarningView();
		this.m_actionIllegalWarning.name = "m_actionIllegalWarning";
		this.m_actionIllegalWarning.visible = false;
		this.m_warningInfoHolder.addChild(this.m_actionIllegalWarning);
		this.m_actionIllegalWarning.y = this.m_labelOffsetY;
		if (this.m_scaleUp) {
			this.m_actionIllegalWarning.scaleX = 1.2;
			this.m_actionIllegalWarning.scaleY = 1.2;
		}
		;
		MenuUtils.setupText(this.m_actionIllegalWarning.title, Localization.get("UI_HUD_ACTION_ILLEGAL"), 16, this.m_labelFont, MenuConstants.FontColorWhite);
		this.m_actionIllegalWarning.title.autoSize = "left";
		this.m_actionIllegalWarningBackDrop = new Sprite();
		this.m_actionIllegalWarningBackDrop.name = "m_actionIllegalWarningBackDrop";
		this.m_actionIllegalWarningBackDrop.graphics.beginFill(MenuConstants.COLOR_RED, 1);
		this.m_actionIllegalWarningBackDrop.graphics.drawRect(0, 0, 100, 21);
		this.m_actionIllegalWarningBackDrop.graphics.endFill();
		this.m_actionIllegalWarning.backDropHolder.addChild(this.m_actionIllegalWarningBackDrop);
		this.m_poisonTypesHolder = new Sprite();
		this.m_poisonTypesHolder.name = "m_poisonTypesHolder";
		if (this.m_scaleUp) {
			this.m_poisonTypesHolder.scaleX = 1.2;
			this.m_poisonTypesHolder.scaleY = 1.2;
		}
		;
		this.m_weaponInfo.addChild(this.m_poisonTypesHolder);
		this.m_poisonViewLethal = this.createPoisonType(1, Localization.get("UI_HUD_INVENTORY_POISON_TYPE_LETHAL"));
		this.m_poisonViewSedative = this.createPoisonType(2, Localization.get("UI_HUD_INVENTORY_POISON_TYPE_SEDATIVE"));
		this.m_poisonViewEmetic = this.createPoisonType(3, Localization.get("UI_HUD_INVENTORY_POISON_TYPE_EMETIC"));
		this.m_poisonTypesHolder.addChild(this.m_poisonViewLethal);
		this.m_poisonTypesHolder.addChild(this.m_poisonViewSedative);
		this.m_poisonTypesHolder.addChild(this.m_poisonViewEmetic);
		this.m_killTypesHolder = new Sprite();
		this.m_killTypesHolder.name = "m_killTypesHolder";
		if (this.m_scaleUp) {
			this.m_killTypesHolder.scaleX = 1.2;
			this.m_killTypesHolder.scaleY = 1.2;
		}
		;
		this.m_weaponInfo.addChild(this.m_killTypesHolder);
		this.reserveAvailableKillTypes(10);
		this.m_ghostItemIndicator = new WeaponSelectorGhostItemView();
		this.m_ghostItemIndicator.name = "m_ghostItemIndicator";
		MenuUtils.setupText(this.m_ghostItemIndicator.label_txt, Localization.get("UI_HUD_WEAPON_GHOST"), this.m_fontSizeTiny, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraDark);
		this.m_ghostItemIndicator.label_txt.autoSize = "left";
		this.m_ghostItemIndicator.back_mc.width = (Math.ceil(this.m_ghostItemIndicator.label_txt.textWidth) + 16);
		this.m_ghostItemIndicator.y = this.m_labelOffsetY;
		this.m_ghostItemIndicator.visible = false;
		this.m_killTypesHolder.addChild(this.m_ghostItemIndicator);
		this.m_perksHolder = new Sprite();
		this.m_perksHolder.name = "m_perksHolder";
		if (this.m_scaleUp) {
		}
		;
		this.m_perksHolder.visible = false;
		this.m_weaponInfo.addChild(this.m_perksHolder);
		this.reservePerks(10);
		this.m_locNoAvailableItems = Localization.get("UI_HUD_INVENTORY_NOAVAILABLEITEMS");
		this.m_locNoItems = Localization.get("UI_HUD_INVENTORY_NOITEMS");
		this.m_imageRequestMax = ((ControlsMain.isVrModeActive()) ? 1 : 5);
	}

	private function get xPerksRight():Number {
		return (((this.m_inventoryBgWidth / 2) - 25) + 15);
	}

	private function get yPerksMiddle():Number {
		return (72);
	}

	private function createPoisonType(_arg_1:int, _arg_2:String):WeaponSelectorPoisonTypeView {
		var _local_3:WeaponSelectorPoisonTypeView = new WeaponSelectorPoisonTypeView();
		var _local_4:Number = 8;
		MenuUtils.setupText(_local_3.label_txt, _arg_2, 16, this.m_labelFont, MenuConstants.FontColorWhite);
		_local_3.label_txt.autoSize = "left";
		_local_3.back_mc.gotoAndStop(_arg_1);
		_local_3.back_mc.width = (Math.ceil(_local_3.label_txt.textWidth) + 16);
		_local_3.y = this.m_labelOffsetY;
		_local_3.visible = false;
		return (_local_3);
	}

	private function reserveAvailableKillTypes(_arg_1:int):void {
		var _local_3:WeaponSelectorKilltypeView;
		if (this.m_killTypeViews.length >= _arg_1) {
			return;
		}
		;
		var _local_2:int = this.m_killTypeViews.length;
		while (_local_2 < _arg_1) {
			_local_3 = this.createKillType();
			this.m_killTypesHolder.addChild(_local_3);
			this.m_killTypeViews.push(_local_3);
			_local_2++;
		}
		;
	}

	private function createKillType():WeaponSelectorKilltypeView {
		var _local_1:WeaponSelectorKilltypeView;
		var _local_2:Number = 8;
		_local_1 = new WeaponSelectorKilltypeView();
		MenuUtils.setupText(_local_1.label_txt, "", 16, this.m_labelFont, MenuConstants.FontColorGreyUltraDark);
		_local_1.label_txt.autoSize = "left";
		_local_1.y = this.m_labelOffsetY;
		_local_1.visible = false;
		return (_local_1);
	}

	private function reservePerks(_arg_1:int):void {
		var _local_3:WeaponSelectorPerksView;
		var _local_4:iconsAll76x76View;
		if (this.m_perkIcons.length >= _arg_1) {
			return;
		}
		;
		var _local_2:Number = (this.xPerksRight - (PX_PERKICONSIZE / 2));
		var _local_5:int = this.m_perkIcons.length;
		while (_local_5 < _arg_1) {
			_local_3 = new WeaponSelectorPerksView();
			_local_3.visible = false;
			_local_4 = new iconsAll76x76View();
			_local_3.perks.addChild(_local_4);
			_local_3.width = (_local_3.height = PX_PERKICONSIZE);
			_local_3.x = (_local_2 - ((PX_PERKICONSIZE + PX_PERKICONGAP) * _local_5));
			_local_3.y = this.yPerksMiddle;
			this.m_perksHolder.addChild(_local_3);
			this.m_perkElements.push(_local_3);
			this.m_perkIcons.push(_local_4);
			_local_5++;
		}
		;
	}

	private function reserveAvailableSlots(_arg_1:int):void {
		var _local_3:WeaponSlotView;
		var _local_4:ImageLoader;
		var _local_5:ImageLoader;
		if (this.m_aChildrenPool.length >= _arg_1) {
			return;
		}
		;
		var _local_2:int = this.m_aChildrenPool.length;
		while (_local_2 < _arg_1) {
			_local_3 = new WeaponSlotView();
			this.m_mainCarousel.addChild(_local_3);
			_local_4 = new ImageLoader();
			_local_3.weaponImage_mc.addChild(_local_4);
			this.m_aChildrenImageLoaderPool.push(_local_4);
			MenuUtils.setColor(_local_3.weaponImage_mc, MenuConstants.COLOR_GREY_ULTRA_LIGHT, false);
			_local_5 = new ImageLoader();
			_local_3.containedWeaponImage_mc.addChild(_local_5);
			this.m_aChildrenImageLoader2Pool.push(_local_5);
			this.m_aChildrenPool.push(_local_3);
			_local_2++;
		}
		;
	}

	public function onSetData(_arg_1:Object):void {
		var _local_3:ImageLoader;
		var _local_4:ImageLoader;
		var _local_5:WeaponSlotView;
		var _local_6:String;
		var _local_7:int;
		this.m_blockImageQueue = true;
		this.m_data = _arg_1;
		this.m_currentSlotData = null;
		this.m_previousSelectedIndex = -1;
		this.m_currentImageRequestIndex = 0;
		this.m_view.alpha = 0;
		Animate.to(this.m_view, 0.05, 0.2, {"alpha": 1}, Animate.Linear);
		this.m_isActionInventory = _arg_1.isActionInventory;
		var _local_2:int;
		while (_local_2 < this.m_itemsInView) {
			_local_3 = this.m_aChildrenImageLoaderPool[_local_2];
			_local_3.cancel();
			_local_4 = this.m_aChildrenImageLoader2Pool[_local_2];
			_local_4.cancel();
			_local_5 = this.m_aChildrenPool[_local_2];
			_local_5.visible = false;
			_local_2++;
		}
		;
		this.m_itemsInView = _arg_1.mainslotsSlim.length;
		this.reserveAvailableSlots(this.m_itemsInView);
		this.m_scaleDownFactor = NaN;
		if (this.m_itemsInView == 0) {
			this.m_mainCarousel.visible = false;
			this.m_warningInfoHolder.visible = false;
			this.m_view.prompt_txt.htmlText = "";
			_local_6 = "";
			if (_arg_1.noItemsMessage) {
				_local_6 = Localization.get(_arg_1.noItemsMessage);
			} else {
				_local_6 = ((_arg_1.otherslotsCount > 0) ? this.m_locNoAvailableItems : this.m_locNoItems);
			}
			;
			MenuUtils.setupText(this.m_view.action_txt, _local_6, 40, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorGreyMedium);
			this.m_view.action_txt.visible = true;
			this.m_weaponInfo.visible = false;
		} else {
			this.m_mainCarousel.visible = true;
			this.m_warningInfoHolder.visible = true;
			this.m_view.action_txt.visible = false;
			this.m_weaponInfo.visible = true;
			this.m_imageLoadCount = 0;
			this.m_initialImageLoaded = false;
			this.m_selectedIndex = _arg_1.selectedIndex;
			if (this.m_selectedIndex == -1) {
				this.m_selectedIndex = 0;
			}
			;
			this.m_loadingOriginIndex = this.m_selectedIndex;
			this.m_animIndexStart = this.m_selectedIndex;
			this.m_blockImageQueue = false;
			_local_7 = 0;
			while (_local_7 < this.m_imageRequestMax) {
				this.loadImageFromQueue();
				_local_7++;
			}
			;
			this.setSelectedImage(true);
		}
		;
	}

	private function loadImageFromQueue():void {
		if (((this.m_blockImageQueue) || (this.m_currentImageRequestIndex >= this.m_itemsInView))) {
			return;
		}
		;
		var _local_1:int = int(((this.m_currentImageRequestIndex + 1) / 2));
		var _local_2:int = (((this.m_currentImageRequestIndex % 2) == 0) ? (this.m_loadingOriginIndex + _local_1) : (this.m_loadingOriginIndex - _local_1));
		_local_2 = ((_local_2 + this.m_itemsInView) % this.m_itemsInView);
		this.m_currentImageRequestIndex++;
		this.loadWeaponImage(_local_2);
		this.loadContainedWeaponImage(_local_2);
	}

	public function Rotate(_arg_1:int, _arg_2:int):void {
		this.m_selectedIndex = _arg_1;
		if (this.m_itemsInView <= 1) {
			this.m_animIndexStart = this.m_selectedIndex;
		}
		;
		this.m_animDirection = _arg_2;
		if (!this.m_isRotationRunning) {
			addEventListener(Event.ENTER_FRAME, this.onUpdateFrame);
			this.m_isRotationRunning = true;
			this.m_currentFrame = getTimer();
			this.m_prevFrame = this.m_currentFrame;
		}
		;
		this.setSelectedImage();
	}

	public function UpdateSelectedSlot(_arg_1:Object):void {
		this.m_currentSlotData = _arg_1;
		this.updateItemInformationWithSlotData(_arg_1);
		this.setPromptTextWithSlotData(this.m_itemsInView, _arg_1);
	}

	public function UpdateAmmoDisplayPosition():void {
		this.m_weaponInfo.ammoDisplay.x = (((((120 - this.m_aChildrenPool[this.m_selectedIndex].weaponImage_mc.getChildAt(0).width) / 2) - 120) - (this.m_weaponInfo.ammoDisplay.ammoTotal_txt.x + this.m_weaponInfo.ammoDisplay.ammoTotal_txt.textWidth)) - 22);
		if (this.m_scaleUp) {
			this.m_weaponInfo.ammoDisplay.x = (this.m_weaponInfo.ammoDisplay.x - 20);
		}
		;
	}

	private function updateItemInformationWithSlotData(_arg_1:Object):void {
		var _local_3:String;
		var _local_4:int;
		var _local_5:Number;
		var _local_6:Number;
		var _local_7:Number;
		var _local_8:int;
		var _local_9:Object;
		var _local_10:Number;
		var _local_11:Number;
		var _local_12:int;
		var _local_13:WeaponSelectorGhostItemParticleView;
		if (((_arg_1.nItemHUDType == 1) && (!(this.m_initialImageLoaded)))) {
			return;
		}
		;
		this.m_textTickerUtilDesc.onUnregister();
		this.m_textObj = [];
		this.m_weaponInfo.label_text.htmlText = "";
		this.m_weaponInfo.action_text.htmlText = "";
		this.m_weaponInfo.container_label_text.htmlText = "";
		this.m_weaponInfo.missing_mc.visible = false;
		this.m_weaponInfo.desc_text.visible = false;
		var _local_2:int;
		while (_local_2 < this.m_killTypeViews.length) {
			this.m_killTypeViews[_local_8].visible = false;
			_local_2++;
		}
		;
		this.m_ghostItemIndicator.visible = false;
		this.m_actionIllegalWarning.visible = false;
		MenuUtils.setColor(this.m_weaponInfo.line, ((_arg_1.notininventory) ? MenuConstants.COLOR_GREY_MEDIUM : MenuConstants.COLOR_GREY_ULTRA_LIGHT), false);
		this.m_isShowLineWanted = false;
		if (this.m_isActionInventory) {
			if (this.m_textTicker) {
				this.m_textTicker.stopTextTicker(this.m_weaponInfo.label_text, _arg_1.label);
			}
			;
			_local_3 = MenuConstants.FontColorGreyUltraLight;
			_local_4 = MenuConstants.COLOR_GREY_ULTRA_LIGHT;
			if (this.m_actionIllegalWarning) {
				this.m_warningInfoHolder.removeChild(this.m_actionIllegalWarning);
			}
			;
			this.m_poisonTypesHolder.visible = false;
			if (((!(_arg_1.notininventory)) && (_arg_1.isIllegal))) {
				this.m_isShowLineWanted = true;
				_local_5 = 8;
				_local_6 = ((21 + this.m_actionIllegalWarning.title.textWidth) + 7);
				this.m_warningInfoHolder.alpha = 1;
				this.m_warningInfoHolder.addChild(this.m_actionIllegalWarning);
				this.m_actionIllegalWarning.visible = true;
				this.m_actionIllegalWarningBackDrop.scaleX = (_local_6 / 100);
				_local_7 = (_local_6 + _local_5);
				if (_arg_1.sPoisonType != undefined) {
					this.setupPoisonType(_arg_1.sPoisonType, _local_7);
				}
				;
			}
			;
			if (_arg_1.notininventory) {
				this.m_weaponInfo.missing_mc.missing_txt.htmlText = _arg_1.missingText;
				this.m_weaponInfo.missing_mc.redback_mc.width = (Math.ceil(this.m_weaponInfo.missing_mc.missing_txt.textWidth) + 16);
				this.m_weaponInfo.missing_mc.visible = true;
				this.m_weaponInfo.desc_text.width = (650 - (this.m_weaponInfo.missing_mc.redback_mc.width + 10));
				this.m_weaponInfo.desc_text.x = (this.m_weaponInfo.missing_mc.redback_mc.width + 10);
				this.m_weaponInfo.desc_text.htmlText = ((_arg_1.longDescription) ? _arg_1.longDescription : "");
				if (MenuUtils.truncateTextfield(this.m_weaponInfo.desc_text, 1, MenuConstants.FontColorGreyUltraLight)) {
					this.m_textTickerUtilDesc.addTextTickerHtml(this.m_weaponInfo.desc_text);
					this.m_textTickerUtilDesc.callTextTicker(true);
				}
				;
				this.m_weaponInfo.desc_text.visible = true;
				this.m_isShowLineWanted = true;
				_local_3 = MenuConstants.FontColorGreyMedium;
				_local_4 = MenuConstants.COLOR_GREY_MEDIUM;
			}
			;
			this.m_weaponInfo.action_text.htmlText = _arg_1.actionName;
			MenuUtils.setTextColor(this.m_weaponInfo.action_text, _local_4);
			this.m_textObj.title = _arg_1.label;
			this.m_textObj.tf = this.m_weaponInfo.label_text;
			this.m_weaponInfo.label_text.htmlText = _arg_1.label;
			MenuUtils.setTextColor(this.m_weaponInfo.label_text, _local_4);
			if (MenuUtils.truncateTextfield(this.m_weaponInfo.label_text, 1, _local_3)) {
				if (!this.m_textTicker) {
					this.m_textTicker = new textTicker();
				}
				;
				this.m_textTicker.startTextTicker(this.m_weaponInfo.label_text, _arg_1.label, CommonUtils.changeFontToGlobalIfNeeded);
				this.m_textTicker.setTextColor(_local_4);
			}
			;
		} else {
			MenuUtils.setTextColor(this.m_weaponInfo.label_text, MenuConstants.COLOR_GREY_ULTRA_LIGHT);
			if (this.m_textTicker) {
				this.m_textTicker.stopTextTicker(this.m_weaponInfo.label_text, _arg_1.label);
			}
			;
			this.m_poisonTypesHolder.visible = false;
			if (((_arg_1.isContainer) && (_arg_1.containsItem))) {
				this.m_textObj.title = _arg_1.containedLabel;
				this.m_textObj.tf = this.m_weaponInfo.label_text;
				this.m_weaponInfo.label_text.htmlText = _arg_1.containedLabel;
				if (MenuUtils.truncateTextfield(this.m_weaponInfo.label_text, 1, MenuConstants.FontColorGreyUltraLight)) {
					if (!this.m_textTicker) {
						this.m_textTicker = new textTicker();
					}
					;
					this.m_textTicker.startTextTicker(this.m_weaponInfo.label_text, _arg_1.containedLabel, CommonUtils.changeFontToGlobalIfNeeded);
					this.m_textTicker.setTextColor(MenuConstants.COLOR_GREY_ULTRA_LIGHT);
				}
				;
				this.m_weaponInfo.container_label_text.htmlText = _arg_1.label;
				if (_arg_1.bContainedItemSuspicious) {
					this.m_isShowLineWanted = true;
					this.showWarningMessage(0, false);
					this.showWarningMessage(1, true);
				} else {
					if (_arg_1.bContainedItemIllegal) {
						this.m_isShowLineWanted = true;
						this.showWarningMessage(0, true);
						this.showWarningMessage(1, false);
						if (_arg_1.bContainedItemDetectedDuringFrisk) {
							this.showWarningMessage(2, false);
						} else {
							this.showWarningMessage(2, true);
						}
						;
					} else {
						this.showWarningMessage(0, false);
						this.showWarningMessage(1, false);
						this.showWarningMessage(2, false);
					}
					;
				}
				;
			} else {
				this.m_textObj.title = _arg_1.label;
				this.m_textObj.tf = this.m_weaponInfo.label_text;
				this.m_weaponInfo.label_text.htmlText = _arg_1.label;
				if (MenuUtils.truncateTextfield(this.m_weaponInfo.label_text, 1, MenuConstants.FontColorGreyUltraLight)) {
					if (!this.m_textTicker) {
						this.m_textTicker = new textTicker();
					}
					;
					this.m_textTicker.startTextTicker(this.m_weaponInfo.label_text, _arg_1.label, CommonUtils.changeFontToGlobalIfNeeded);
					this.m_textTicker.setTextColor(MenuConstants.COLOR_GREY_ULTRA_LIGHT);
				}
				;
				if (_arg_1.suspicious) {
					this.m_isShowLineWanted = true;
					this.showWarningMessage(0, false);
					this.showWarningMessage(1, true);
				} else {
					if (_arg_1.illegal) {
						this.m_isShowLineWanted = true;
						this.showWarningMessage(0, true);
						this.showWarningMessage(1, false);
						if (_arg_1.detectedDuringFrisk) {
							this.showWarningMessage(2, false);
						} else {
							this.showWarningMessage(2, true);
						}
						;
					} else {
						this.showWarningMessage(0, false);
						this.showWarningMessage(1, false);
						this.showWarningMessage(2, false);
					}
					;
				}
				;
				this.hideKillTypes();
				if (((!(_arg_1.actionAndKillTypes == undefined)) || (_arg_1.nItemHUDType == 1))) {
					if (((_arg_1.actionAndKillTypes.length > 0) || (_arg_1.nItemHUDType == 1))) {
						this.m_isShowLineWanted = true;
						this.setupKillTypes(_arg_1.actionAndKillTypes, ((_arg_1.nItemHUDType == 1) ? true : false));
					}
					;
				}
				;
				if (_arg_1.sPoisonType != undefined) {
					this.m_itemInfoPosX = this.setupPoisonType(_arg_1.sPoisonType, this.m_itemInfoPosX);
				}
				;
				if (this.m_ghostItemIndicatorHolder != null) {
					_local_8 = 0;
					while (_local_8 < (this.m_ghostItemIndicatorHolder.numChildren - 1)) {
						this.loopGhostItemIndicators(this.m_ghostItemIndicatorHolder.getChildAt(_local_8), false);
						_local_8++;
					}
					;
					this.m_weaponInfo.removeChild(this.m_ghostItemIndicatorHolder);
				}
				;
				if (_arg_1.nItemHUDType == 1) {
					_local_9 = this.m_aChildrenPool[this.m_selectedIndex];
					this.m_ghostItemIndicatorHolder = new Sprite();
					this.m_ghostItemIndicatorHolder.name = "m_ghostItemIndicatorHolder";
					this.m_weaponInfo.addChild(this.m_ghostItemIndicatorHolder);
					_local_10 = (120 - _local_9.weaponImage_mc.width);
					_local_11 = (190 - _local_9.weaponImage_mc.height);
					_local_12 = 0;
					while (_local_12 < 5) {
						_local_13 = new WeaponSelectorGhostItemParticleView();
						_local_13.x = (((_local_10 / 2) - 137) + (_local_9.weaponImage_mc.width / 2));
						_local_13.y = ((((_local_9.weaponImage_mc.height / -2) - 10) + (_local_11 / 2)) + (_local_9.weaponImage_mc.height / 2));
						this.m_ghostItemIndicatorHolder.addChild(_local_13);
						this.loopGhostItemIndicators(_local_13, true, (_local_9.weaponImage_mc.height / 4));
						_local_12++;
					}
					;
				}
				;
			}
			;
		}
		;
		if (_arg_1.notininventory) {
			this.m_weaponInfo.ammoDisplay.ammoCurrent_txt.htmlText = "";
			this.m_weaponInfo.ammoDisplay.ammoTotal_txt.htmlText = "";
		} else {
			if (((_arg_1.nAmmoTotal >= 0) && (_arg_1.nAmmoRemaining >= 0))) {
				this.m_weaponInfo.ammoDisplay.ammoCurrent_txt.htmlText = _arg_1.nAmmoRemaining;
				if (_arg_1.canReload) {
					this.m_weaponInfo.ammoDisplay.ammoTotal_txt.htmlText = ("/" + _arg_1.nAmmoTotal);
				} else {
					this.m_weaponInfo.ammoDisplay.ammoTotal_txt.htmlText = "";
				}
				;
			} else {
				if (_arg_1.ammo > -1) {
					this.m_weaponInfo.ammoDisplay.ammoCurrent_txt.htmlText = _arg_1.ammo;
					this.m_weaponInfo.ammoDisplay.ammoTotal_txt.htmlText = "";
				} else {
					if (((_arg_1.count > 1) && (_arg_1.ammo == -1))) {
						this.m_weaponInfo.ammoDisplay.ammoCurrent_txt.htmlText = ("x" + _arg_1.count);
						this.m_weaponInfo.ammoDisplay.ammoTotal_txt.htmlText = "";
					} else {
						this.m_weaponInfo.ammoDisplay.ammoCurrent_txt.htmlText = "";
						this.m_weaponInfo.ammoDisplay.ammoTotal_txt.htmlText = "";
					}
					;
				}
				;
			}
			;
		}
		;
		this.m_weaponInfo.ammoDisplay.ammoTotal_txt.x = (this.m_weaponInfo.ammoDisplay.ammoCurrent_txt.textWidth + 2);
		this.UpdateAmmoDisplayPosition();
		if (this.m_evergreenRarityLabel != null) {
			this.m_weaponInfo.removeChild(this.m_evergreenRarityLabel);
			this.m_evergreenRarityLabel = null;
			this.m_perksHolder.x = 0;
		}
		;
		if (EvergreenUtils.isValidRarityLabel(_arg_1.evergreenRarity)) {
			this.m_evergreenRarityLabel = EvergreenUtils.createRarityLabel(_arg_1.evergreenRarity, false);
			this.m_evergreenRarityLabel.name = "m_evergreenRarityLabel";
			this.m_evergreenRarityLabel.height = PX_PERKICONSIZE;
			this.m_evergreenRarityLabel.scaleX = this.m_evergreenRarityLabel.scaleY;
			this.m_evergreenRarityLabel.x = (this.xPerksRight - (this.m_evergreenRarityLabel.width / 2));
			this.m_evergreenRarityLabel.y = this.yPerksMiddle;
			this.m_weaponInfo.addChild(this.m_evergreenRarityLabel);
			this.m_perksHolder.x = -(this.m_evergreenRarityLabel.width + PX_PERKICONGAP);
			this.m_isShowLineWanted = true;
		}
		;
		if (((!(this.m_evergreenLoseOnWoundedLabel == null)) && (!(_arg_1.evergreenLoseOnWounded)))) {
			this.m_killTypesHolder.removeChild(this.m_evergreenLoseOnWoundedLabel);
			this.m_evergreenLoseOnWoundedLabel = null;
		}
		;
		if (_arg_1.evergreenLoseOnWounded === true) {
			if (this.m_evergreenLoseOnWoundedLabel == null) {
				this.m_evergreenLoseOnWoundedLabel = new WeaponSelectorKilltypeView();
				this.m_evergreenLoseOnWoundedLabel.name = "m_evergreenLoseOnWoundedLabel";
				this.m_evergreenLoseOnWoundedLabel.label_txt.htmlText = Localization.get("UI_INVENTORY_EVERGREEN_LOSE_ON_WOUNDED");
				this.m_evergreenLoseOnWoundedLabel.back_mc.width = (Math.ceil(this.m_evergreenLoseOnWoundedLabel.label_txt.textWidth) + 16);
				this.m_killTypesHolder.addChild(this.m_evergreenLoseOnWoundedLabel);
			}
			;
			this.m_evergreenLoseOnWoundedLabel.x = this.m_itemInfoPosX;
			this.m_itemInfoPosX = (this.m_itemInfoPosX + (this.m_evergreenLoseOnWoundedLabel.width + 8));
			this.m_evergreenLoseOnWoundedLabel.y = this.m_labelOffsetY;
			this.m_isShowLineWanted = true;
		}
		;
		this.m_perksHolder.visible = false;
		if (((!(_arg_1.perks == undefined)) && (_arg_1.perks.length > 0))) {
			this.setupPerks(_arg_1.perks);
			this.m_perksHolder.visible = true;
			this.m_isShowLineWanted = true;
		}
		;
		this.showLine(this.m_isShowLineWanted);
	}

	private function loopGhostItemIndicators(_arg_1:DisplayObject, _arg_2:Boolean, _arg_3:Number = 0):void {
		var _local_4:Number;
		Animate.kill(_arg_1);
		if (_arg_2) {
			if (Math.random() > 0.5) {
				_arg_1.rotation = MenuUtils.getRandomInRange(-60, -120);
			} else {
				_arg_1.rotation = MenuUtils.getRandomInRange(60, 120);
			}
			;
			_local_4 = _arg_1.y;
			_arg_1.y = (_local_4 + MenuUtils.getRandomInRange(-(_arg_3), _arg_3));
			this.loopStart({
				"obj": _arg_1,
				"yRange": _arg_3,
				"orignalYPos": _local_4
			});
		}
		;
	}

	private function loopStart(_arg_1:Object):void {
		Animate.fromTo(_arg_1.obj, (MenuUtils.getRandomInRange(3, 7) / 10), (MenuUtils.getRandomInRange(0, 5) / 10), {"frames": 1}, {"frames": 28}, Animate.Linear, this.loopEnd, _arg_1);
	}

	private function loopEnd(_arg_1:Object):void {
		if (Math.random() > 0.5) {
			_arg_1.obj.rotation = MenuUtils.getRandomInRange(-60, -120);
		} else {
			_arg_1.obj.rotation = MenuUtils.getRandomInRange(60, 120);
		}
		;
		_arg_1.obj.y = (_arg_1.orignalYPos + MenuUtils.getRandomInRange(-(_arg_1.yRange), _arg_1.yRange));
		this.loopStart(_arg_1);
	}

	private function showLine(_arg_1:Boolean, _arg_2:Boolean = false):void {
		if (this.m_showLine == _arg_1) {
			return;
		}
		;
		this.m_showLine = _arg_1;
		if (_arg_2) {
			Animate.kill(this.m_weaponInfo.line);
			this.m_weaponInfo.line.alpha = ((_arg_1) ? 1 : 0);
		} else {
			Animate.to(this.m_weaponInfo.line, 0.2, 0, {"alpha": ((_arg_1) ? 1 : 0)}, Animate.ExpoOut);
		}
		;
	}

	private function setupPoisonType(_arg_1:String, _arg_2:Number):Number {
		this.m_poisonViewLethal.visible = false;
		this.m_poisonViewSedative.visible = false;
		this.m_poisonViewEmetic.visible = false;
		var _local_3:WeaponSelectorPoisonTypeView;
		switch (_arg_1) {
			case "POISONTYPE_LETHAL":
				_local_3 = this.m_poisonViewLethal;
				break;
			case "POISONTYPE_SEDATIVE":
				_local_3 = this.m_poisonViewSedative;
				break;
			case "POISONTYPE_EMETIC":
				_local_3 = this.m_poisonViewEmetic;
				break;
		}
		;
		if (_local_3 == null) {
			return (_arg_2);
		}
		;
		this.m_isShowLineWanted = true;
		var _local_4:Number = 8;
		_local_3.x = _arg_2;
		_arg_2 = (_arg_2 + (_local_3.back_mc.width + _local_4));
		this.m_poisonTypesHolder.visible = true;
		_local_3.visible = true;
		return (_arg_2);
	}

	private function hideKillTypes():void {
		var _local_1:int;
		while (_local_1 < this.m_killTypeViews.length) {
			this.m_killTypeViews[_local_1].visible = false;
			_local_1++;
		}
		;
	}

	private function setupKillTypes(_arg_1:Array, _arg_2:Boolean):void {
		var _local_3:WeaponSelectorKilltypeView;
		var _local_6:Number;
		var _local_4:Number = 8;
		this.reserveAvailableKillTypes(_arg_1.length);
		var _local_5:int;
		while (_local_5 < _arg_1.length) {
			_local_3 = this.m_killTypeViews[_local_5];
			_local_3.label_txt.htmlText = _arg_1[_local_5];
			_local_6 = (Math.ceil(_local_3.label_txt.textWidth) + 16);
			_local_3.back_mc.width = _local_6;
			_local_3.x = this.m_itemInfoPosX;
			this.m_itemInfoPosX = (this.m_itemInfoPosX + (_local_6 + _local_4));
			_local_3.visible = true;
			_local_5++;
		}
		;
		if (_arg_2) {
			this.m_ghostItemIndicator.visible = true;
			this.m_ghostItemIndicator.x = this.m_itemInfoPosX;
			this.m_itemInfoPosX = (this.m_itemInfoPosX + (this.m_ghostItemIndicator.back_mc.width + _local_4));
		}
		;
	}

	private function instantiateWarningMessages():void {
		var _local_3:WeaponSelectorWarningView;
		var _local_4:Sprite;
		this.m_warningInfoHolder.alpha = 1;
		var _local_1:Array = new Array(Localization.get("UI_HUD_WEAPON_ILLEGAL"), Localization.get("UI_HUD_WEAPON_SUSPISIOUS"), Localization.get("UI_HUD_INVENTORY_NOT_DETECTED_DURING_FRISK"));
		this.m_aWarnings = new Array();
		var _local_2:int;
		while (_local_2 < _local_1.length) {
			_local_3 = new WeaponSelectorWarningView();
			this.m_warningInfoHolder.addChild(_local_3);
			_local_3.gotoAndStop((_local_2 + 1));
			_local_3.title.x = ((_local_2 == 2) ? 5 : 18);
			MenuUtils.setupText(_local_3.title, _local_1[_local_2], 16, this.m_labelFont, ((_local_2 == 2) ? MenuConstants.FontColorGreyUltraDark : MenuConstants.FontColorWhite));
			_local_3.title.autoSize = "left";
			_local_4 = new Sprite();
			_local_4.graphics.beginFill(((_local_2 == 2) ? MenuConstants.COLOR_GREEN : MenuConstants.COLOR_RED), 1);
			_local_4.graphics.drawRect(0, 0, ((_local_2 == 2) ? ((7 + _local_3.title.textWidth) + 7) : ((21 + _local_3.title.textWidth) + 7)), 21);
			_local_4.graphics.endFill();
			_local_3.backDropHolder.addChild(_local_4);
			_local_3.alpha = 0;
			_local_3.y = this.m_labelOffsetY;
			this.m_aWarnings.push(_local_3);
			_local_2++;
		}
		;
	}

	public function showWarningMessage(_arg_1:int, _arg_2:Boolean):void {
		this.m_warningInfoHolder.alpha = 1;
		if (_arg_1 == 0) {
			this.m_itemInfoPosX = 0;
		}
		;
		this.m_aWarnings[_arg_1].x = this.m_itemInfoPosX;
		if (_arg_2) {
			this.m_itemInfoPosX = (this.m_itemInfoPosX + (this.m_aWarnings[_arg_1].backDropHolder.getChildAt(0).width + 8));
		}
		;
		var _local_3:Number = ((_arg_2) ? 1 : 0);
		if (this.m_aWarnings[_arg_1].alpha != _local_3) {
			Animate.to(this.m_aWarnings[_arg_1], 0.2, 0, {"alpha": _local_3}, Animate.ExpoOut);
		} else {
			Animate.kill(this.m_aWarnings[_arg_1]);
		}
		;
	}

	private function setupPerks(_arg_1:Array):void {
		this.reservePerks(_arg_1.length);
		var _local_2:int;
		while (_local_2 < this.m_perkElements.length) {
			if (_local_2 < _arg_1.length) {
				MenuUtils.setupIcon(this.m_perkIcons[_local_2], _arg_1[_local_2], MenuConstants.COLOR_GREY_ULTRA_DARK, false, false);
				this.m_perkElements[_local_2].visible = true;
			} else {
				this.m_perkElements[_local_2].visible = false;
			}
			;
			_local_2++;
		}
		;
	}

	public function UpdatePositions():void {
		var _local_1:int;
		while (_local_1 < this.m_itemsInView) {
			if (this.m_aChildrenPool[_local_1].visible) {
				this.UpdatePosition(_local_1);
			}
			;
			_local_1++;
		}
		;
	}

	private function calcScaleDownFactor():void {
		var _local_1:int = 8;
		var _local_2:int = 16;
		var _local_3:Number = 0.6;
		this.m_scaleDownFactor = 1;
		if (this.m_itemsInView > _local_1) {
			this.m_scaleDownFactor = (1 - (((1 - _local_3) * (this.m_itemsInView - _local_1)) / (_local_2 - _local_1)));
			if (this.m_scaleDownFactor < _local_3) {
				this.m_scaleDownFactor = _local_3;
			}
			;
		}
		;
	}

	private function UpdatePosition(_arg_1:int):void {
		var _local_7:Number;
		var _local_8:Number;
		var _local_10:Number;
		var _local_12:Number;
		var _local_2:Number = (Math.PI * 2);
		var _local_3:Number = (0.5 * Math.PI);
		var _local_4:Number = (Math.PI * 0.06);
		var _local_5:Number = (this.m_ellipseHeight * 3);
		var _local_6:Number = (this.m_ellipseHeight * 2);
		if (isNaN(this.m_scaleDownFactor)) {
			this.calcScaleDownFactor();
		}
		;
		_local_7 = ((Number(_arg_1) - this.m_animIndexStart) / this.m_itemsInView);
		_local_8 = (((_local_2 * _local_7) + _local_3) + _local_4);
		var _local_9:Number = (Math.cos(_local_8) * this.m_ellipseWidth);
		_local_10 = (Math.sin(_local_8) * this.m_ellipseHeight);
		var _local_11:Number = Number((((((_local_10 * 3) + _local_5) / _local_6) * 0.09) + 0.3));
		if (_arg_1 == this.m_selectedIndex) {
			_local_12 = (_local_11 * 1.75);
			this.m_mainCarousel.swapChildrenAt((this.m_mainCarousel.numChildren - 1), this.m_mainCarousel.getChildIndex(this.m_aChildrenPool[_arg_1]));
			this.m_aChildrenPool[_arg_1].x = _local_9;
			this.m_aChildrenPool[_arg_1].y = _local_10;
			this.m_aChildrenPool[_arg_1].scaleX = (this.m_aChildrenPool[_arg_1].scaleY = (_local_11 * 1.75));
			this.m_aChildrenPool[_arg_1].alpha = _local_12;
		} else {
			_local_12 = ((this.m_isActionInventory) ? ((_local_11 * _local_11) + 0.4) : ((_local_11 * _local_11) + 0.1));
			this.m_aChildrenPool[_arg_1].x = _local_9;
			this.m_aChildrenPool[_arg_1].y = _local_10;
			this.m_aChildrenPool[_arg_1].scaleX = (this.m_aChildrenPool[_arg_1].scaleY = (_local_11 * this.m_scaleDownFactor));
			this.m_aChildrenPool[_arg_1].alpha = _local_12;
		}
		;
	}

	private function setSelectedImage(_arg_1:Boolean = false):void {
		if (this.m_previousSelectedIndex == this.m_selectedIndex) {
			return;
		}
		;
		var _local_2:Number = 1.75;
		var _local_3:Number = 25;
		if (((this.m_previousSelectedIndex >= 0) && (this.m_previousSelectedIndex < this.m_itemsInView))) {
			if (_arg_1) {
				Animate.kill(this.m_aChildrenPool[this.m_previousSelectedIndex].weaponImage_mc);
				Animate.kill(this.m_aChildrenPool[this.m_previousSelectedIndex].containedWeaponImage_mc);
				this.m_aChildrenPool[this.m_previousSelectedIndex].weaponImage_mc.y = 0;
				this.m_aChildrenPool[this.m_previousSelectedIndex].containedWeaponImage_mc.y = 0;
			} else {
				Animate.to(this.m_aChildrenPool[this.m_previousSelectedIndex].weaponImage_mc, 0.2, 0, {"y": 0}, Animate.SineOut);
				Animate.to(this.m_aChildrenPool[this.m_previousSelectedIndex].containedWeaponImage_mc, 0.2, 0, {"y": 0}, Animate.SineOut);
			}
			;
		}
		;
		if (((this.m_selectedIndex >= 0) && (this.m_selectedIndex < this.m_itemsInView))) {
			if (_arg_1) {
				Animate.kill(this.m_aChildrenPool[this.m_selectedIndex].weaponImage_mc);
				Animate.kill(this.m_aChildrenPool[this.m_selectedIndex].containedWeaponImage_mc);
				this.m_aChildrenPool[this.m_selectedIndex].weaponImage_mc.y = _local_3;
				this.m_aChildrenPool[this.m_selectedIndex].containedWeaponImage_mc.y = _local_3;
			} else {
				Animate.to(this.m_aChildrenPool[this.m_selectedIndex].weaponImage_mc, 0.2, 0, {"y": _local_3}, Animate.SineOut);
				Animate.to(this.m_aChildrenPool[this.m_selectedIndex].containedWeaponImage_mc, 0.2, 0, {"y": _local_3}, Animate.SineOut);
			}
			;
		}
		;
		this.m_previousSelectedIndex = this.m_selectedIndex;
	}

	private function onUpdateFrame():void {
		var _local_4:Number;
		var _local_1:Number = this.m_animIndexStart;
		this.m_currentFrame = getTimer();
		var _local_2:Number = ((this.m_currentFrame - this.m_prevFrame) * 0.001);
		this.m_prevFrame = this.m_currentFrame;
		var _local_3:Number = (_local_2 * 10);
		if (this.m_animDirection > 0) {
			_local_4 = (this.m_animIndexStart + _local_3);
			if (_local_4 >= this.m_itemsInView) {
				_local_4 = (_local_4 - this.m_itemsInView);
				this.m_animIndexStart = (this.m_animIndexStart - this.m_itemsInView);
			}
			;
			if (((this.m_animIndexStart <= this.m_selectedIndex) && (_local_4 >= this.m_selectedIndex))) {
				_local_4 = this.m_selectedIndex;
				removeEventListener(Event.ENTER_FRAME, this.onUpdateFrame);
				this.m_isRotationRunning = false;
			}
			;
		} else {
			_local_4 = (this.m_animIndexStart - _local_3);
			if (((this.m_animIndexStart >= this.m_selectedIndex) && (_local_4 <= this.m_selectedIndex))) {
				_local_4 = this.m_selectedIndex;
				removeEventListener(Event.ENTER_FRAME, this.onUpdateFrame);
				this.m_isRotationRunning = false;
			} else {
				if (_local_4 <= 0) {
					_local_4 = (_local_4 + this.m_itemsInView);
					this.m_animIndexStart = (this.m_animIndexStart + this.m_itemsInView);
				}
				;
			}
			;
		}
		;
		this.m_animIndexStart = _local_4;
		this.UpdatePositions();
	}

	private function loadWeaponImage(slotIndex:int):void {
		var maxHeight:Number;
		var reducedWidth:Number;
		var weaponLoader:ImageLoader;
		var weaponSlot:WeaponSlotView = this.m_aChildrenPool[slotIndex];
		var imagePath:String = (this.m_data.mainslotsSlim[slotIndex].icon as String);
		maxHeight = (this.m_inventoryBgHeight - 20);
		reducedWidth = 120;
		weaponLoader = this.m_aChildrenImageLoaderPool[slotIndex];
		weaponLoader.rotation = 0;
		weaponLoader.scaleX = (weaponLoader.scaleY = 1);
		weaponLoader.loadImage(imagePath, function ():void {
			var _local_1:Boolean;
			if (weaponLoader.width > weaponLoader.height) {
				weaponLoader.rotation = -90;
				_local_1 = true;
			}
			;
			weaponLoader.width = reducedWidth;
			weaponLoader.scaleY = weaponLoader.scaleX;
			if (weaponLoader.height > maxHeight) {
				weaponLoader.height = maxHeight;
				weaponLoader.scaleX = weaponLoader.scaleY;
			}
			;
			weaponLoader.x = ((((m_inventoryBgHeight - 20) / 2) - weaponLoader.width) - ((reducedWidth - weaponLoader.width) / 2));
			if (_local_1) {
				weaponLoader.y = ((weaponLoader.height / 2) + ((maxHeight - weaponLoader.height) / 2));
			} else {
				weaponLoader.y = ((weaponLoader.height / -2) + ((maxHeight - weaponLoader.height) / 2));
			}
			;
			m_imageLoadCount = (m_imageLoadCount + 1);
			loadImageFromQueue();
			if (((m_imageLoadCount == m_itemsInView) && (!(m_initialImageLoaded)))) {
				m_initialImageLoaded = true;
				if (m_currentSlotData != null) {
					if (m_currentSlotData.nItemHUDType == 1) {
						updateItemInformationWithSlotData(m_currentSlotData);
					}
					;
				}
				;
			}
			;
			if (slotIndex == m_selectedIndex) {
				UpdateAmmoDisplayPosition();
			}
			;
			m_aChildrenPool[slotIndex].visible = true;
			UpdatePosition(slotIndex);
		}, function ():void {
			m_imageLoadCount = (m_imageLoadCount + 1);
			loadImageFromQueue();
			if (((m_imageLoadCount == m_itemsInView) && (!(m_initialImageLoaded)))) {
				m_initialImageLoaded = true;
				if (m_currentSlotData != null) {
					if (m_currentSlotData.nItemHUDType == 1) {
						updateItemInformationWithSlotData(m_currentSlotData);
					}
					;
				}
				;
			}
			;
		});
	}

	private function loadContainedWeaponImage(slotIndex:int):void {
		var weaponSlot:WeaponSlotView;
		var containerClip:MovieClip;
		var maxHeight:Number;
		var reducedWidth:Number;
		var weaponLoader:ImageLoader;
		weaponSlot = this.m_aChildrenPool[slotIndex];
		containerClip = weaponSlot.containedWeaponImage_mc;
		containerClip.removeChildren();
		if (this.m_data.mainslotsSlim[slotIndex].containedIcon == null) {
			return;
		}
		;
		var imagePath:String = (this.m_data.mainslotsSlim[slotIndex].containedIcon as String);
		maxHeight = ((this.m_inventoryBgHeight - 20) - 40);
		reducedWidth = 95;
		weaponLoader = this.m_aChildrenImageLoader2Pool[slotIndex];
		weaponLoader.loadImage(imagePath, function ():void {
			var _local_3:Bitmap;
			var _local_4:BitmapData;
			var _local_5:Bitmap;
			var _local_6:Bitmap;
			var _local_7:Number;
			var _local_8:GlowFilter;
			var _local_1:DisplayObject = weaponLoader.content;
			if ((_local_1 is Bitmap)) {
				_local_3 = (_local_1 as Bitmap);
				_local_4 = _local_3.bitmapData;
				_local_5 = new Bitmap(_local_4);
				_local_6 = new Bitmap(_local_4);
				_local_5.name = "image01";
				_local_6.name = "image02";
				weaponLoader = null;
				containerClip.addChild(_local_5);
				containerClip.addChild(_local_6);
			}
			;
			var _local_2:Boolean;
			if (_local_5.width > _local_5.height) {
				_local_5.rotation = -90;
				_local_6.rotation = -90;
				_local_2 = true;
			}
			;
			_local_5.width = (_local_6.width = reducedWidth);
			_local_5.scaleY = (_local_6.scaleY = _local_5.scaleX);
			if (_local_5.height > maxHeight) {
				_local_5.height = (_local_6.height = maxHeight);
				_local_5.scaleX = (_local_6.scaleX = _local_5.scaleY);
			}
			;
			_local_5.x = (((((m_inventoryBgHeight - 20) / 2) - _local_5.width) - ((reducedWidth - _local_5.width) / 2)) - 40);
			if (_local_2) {
				_local_5.y = (((_local_5.height / 2) + ((maxHeight - _local_5.height) / 2)) + 20);
			} else {
				_local_5.y = (((_local_5.height / -2) + ((maxHeight - _local_5.height) / 2)) + 20);
			}
			;
			_local_6.x = _local_5.x;
			_local_6.y = _local_5.y;
			MenuUtils.setColor(_local_5, MenuConstants.COLOR_BLACK, false);
			if (ControlsMain.isVrModeActive()) {
				MenuUtils.setColor(weaponSlot.weaponImage_mc, MenuConstants.COLOR_GREY, false);
				MenuUtils.setColor(_local_6, MenuConstants.COLOR_GREY_ULTRA_LIGHT, false);
				_local_6.x = (_local_6.x - 4);
				_local_6.y = (_local_6.y + 4);
			} else {
				_local_7 = (Math.max(1, m_fScaleAccum) * PX_BLUR);
				_local_8 = new GlowFilter();
				_local_8.color = MenuConstants.COLOR_GREY_ULTRA_LIGHT;
				_local_8.blurX = (_local_8.blurY = _local_7);
				_local_8.knockout = true;
				_local_8.strength = 20;
				_local_6.filters = [_local_8];
				m_imagesThatHaveFilters[_local_6] = true;
				MenuUtils.trySetCacheAsBitmap(containerClip, true);
			}
			;
			m_aChildrenPool[slotIndex].visible = true;
			UpdatePosition(slotIndex);
		});
	}

	public function setPromptTextWithSlotData(_arg_1:Number, _arg_2:Object):void {
		var _local_3:* = "";
		if (this.m_isActionInventory) {
			if (_arg_1 > 0) {
				_local_3 = (_local_3 + Localization.get("UI_HUD_INVENTORY_ACTION_SELECT"));
				_local_3 = (_local_3 + this.PROMPT_SEP_STRING);
			}
			;
		} else {
			if (_arg_1 > 0) {
				_local_3 = (_local_3 + Localization.get("UI_HUD_INVENTORY_SELECT"));
				_local_3 = (_local_3 + this.PROMPT_SEP_STRING);
				if (_arg_2.isDroppable) {
					_local_3 = (_local_3 + Localization.get("UI_HUD_INVENTORY_DROP_ITEM"));
					_local_3 = (_local_3 + this.PROMPT_SEP_STRING);
				}
				;
				if (_arg_2.isContainer) {
					if (_arg_2.containsItem) {
						_local_3 = (_local_3 + Localization.get("UI_HUD_INVENTORY_ACTION_RETRIEVE"));
						_local_3 = (_local_3 + this.PROMPT_SEP_STRING);
					} else {
						if (_arg_1 > 1) {
							_local_3 = (_local_3 + Localization.get("UI_HUD_INVENTORY_ACTION_CONCEAL"));
							_local_3 = (_local_3 + this.PROMPT_SEP_STRING);
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
		this.m_view.prompt_txt.htmlText = _local_3;
	}

	override public function onSetVisible(_arg_1:Boolean):void {
		var _local_2:int;
		var _local_3:int;
		var _local_4:int;
		this.visible = _arg_1;
		if (!_arg_1) {
			this.m_currentSlotData = null;
			this.m_textTickerUtilDesc.onUnregister();
			if (this.m_textTicker) {
				this.m_textTicker.stopTextTicker(this.m_textObj.tf, this.m_textObj.title);
				this.m_textTicker = null;
			}
			;
			if (this.m_isRotationRunning) {
				removeEventListener(Event.ENTER_FRAME, this.onUpdateFrame);
				this.m_isRotationRunning = false;
			}
			;
			if (((this.m_previousSelectedIndex >= 0) && (this.m_previousSelectedIndex < this.m_aChildrenPool.length))) {
				Animate.kill(this.m_aChildrenPool[this.m_previousSelectedIndex].weaponImage_mc);
				Animate.kill(this.m_aChildrenPool[this.m_previousSelectedIndex].containedWeaponImage_mc);
				this.m_aChildrenPool[this.m_previousSelectedIndex].weaponImage_mc.y = 0;
				this.m_aChildrenPool[this.m_previousSelectedIndex].containedWeaponImage_mc.y = 0;
			}
			;
			if (((this.m_selectedIndex >= 0) && (this.m_selectedIndex < this.m_aChildrenPool.length))) {
				Animate.kill(this.m_aChildrenPool[this.m_selectedIndex].weaponImage_mc);
				Animate.kill(this.m_aChildrenPool[this.m_selectedIndex].containedWeaponImage_mc);
				this.m_aChildrenPool[this.m_selectedIndex].weaponImage_mc.y = 0;
				this.m_aChildrenPool[this.m_selectedIndex].containedWeaponImage_mc.y = 0;
			}
			;
			_local_2 = 0;
			while (_local_2 < this.m_itemsInView) {
				this.m_aChildrenImageLoaderPool[_local_2].cancel();
				this.m_aChildrenImageLoader2Pool[_local_2].cancel();
				_local_2++;
			}
			;
			_local_3 = 0;
			while (_local_3 < this.m_aWarnings.length) {
				Animate.kill(this.m_aWarnings[_local_3]);
				_local_3++;
			}
			;
			this.m_imageLoadCount = 0;
			this.m_initialImageLoaded = false;
			if (this.m_ghostItemIndicatorHolder != null) {
				_local_4 = 0;
				while (_local_4 < (this.m_ghostItemIndicatorHolder.numChildren - 1)) {
					this.loopGhostItemIndicators(this.m_ghostItemIndicatorHolder.getChildAt(_local_4), false);
					_local_4++;
				}
				;
			}
			;
			Animate.kill(this.m_view);
			if (this.m_weaponInfo != null) {
				Animate.kill(this.m_weaponInfo.line);
			}
			;
		}
		;
	}

	override public function onSetViewport(_arg_1:Number, _arg_2:Number, _arg_3:Number):void {
		var _local_4:Number = (MenuConstants.BaseWidth / MenuConstants.BaseHeight);
		var _local_5:Number = (Extensions.visibleRect.width / Extensions.visibleRect.height);
		var _local_6:Number = (MenuConstants.BaseHeight / Extensions.visibleRect.height);
		var _local_7:Number = ((_local_5 > _local_4) ? (((MenuConstants.BaseWidth * _local_6) * _arg_1) - (MenuConstants.BaseWidth - this.m_inventoryBgWidth)) : this.m_inventoryBgWidth);
		this.m_background.graphics.clear();
		this.m_background.graphics.beginFill(MenuConstants.COLOR_MENU_TABS_BACKGROUND, MenuConstants.MenuElementBackgroundAlpha);
		this.m_background.graphics.drawRect((_local_7 / -2), -100, _local_7, this.m_inventoryBgHeight);
	}

	override public function onSetSize(_arg_1:Number, _arg_2:Number):void {
		var _local_4:*;
		var _local_5:DisplayObject;
		var _local_6:Array;
		var _local_7:GlowFilter;
		var _local_8:Number;
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
		for (_local_4 in this.m_imagesThatHaveFilters) {
			_local_5 = _local_4;
			_local_6 = _local_5.filters;
			if (!((_local_6 == null) || (_local_6.length == 0))) {
				_local_7 = (_local_6[0] as GlowFilter);
				if (_local_7 != null) {
					_local_8 = (Math.max(1, this.m_fScaleAccum) * PX_BLUR);
					_local_7.blurX = (_local_7.blurY = _local_8);
					_local_5.filters = _local_6;
				}
				;
			}
			;
		}
		;
	}


}
}//package hud

