// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.modal.ModalDialogItemDetails

package menu3.modal {
import menu3.MenuImageLoader;

import flash.display.Sprite;

import basic.DottedLine;

import menu3.basic.TextTickerUtil;

import common.menu.MenuConstants;
import common.menu.MenuUtils;
import common.Localization;

import hud.evergreen.EvergreenUtils;

import flash.display.DisplayObject;
import flash.text.TextFieldAutoSize;
import flash.text.TextField;

import common.CommonUtils;

public dynamic class ModalDialogItemDetails extends ModalDialogContainerBase {

	private const ITEM_IMAGE_WIDTH:Number = 650;
	private const ITEM_IMAGE_HEIGHT:Number = 490;
	private const PADDING:Number = 10;

	private var m_itemImageLoader:MenuImageLoader;
	private var m_view:ModalDialogItemDetailsTileView;
	private var m_perkHolder:Sprite;
	private var m_killTypesHolder:Sprite;
	private var m_newObjectiveIndicator:NewObjectiveIndicatorView;
	private var m_headerSeparatorLine:DottedLine;
	private var m_perkSeparatorLine:DottedLine;
	private var m_killTypeSeparatorLine:DottedLine;
	private var m_backButton:Object;
	private var m_scrollingContainer:ModalScrollingContainer;
	private var m_scrollPosX:Number;
	private var m_scrollPosY:Number;
	private var m_scrollWidth:Number;
	private var m_scrollHeight:Number;
	private var m_itemInfoPosX:Number = 0;
	private var m_textTickerUtil:TextTickerUtil = new TextTickerUtil();
	private var m_isAvailable:Boolean = true;

	public function ModalDialogItemDetails(_arg_1:Object) {
		super(_arg_1);
		m_dialogInformation.IsButtonSelectionEnabled = false;
		this.m_view = new ModalDialogItemDetailsTileView();
		this.m_view.scrollAreaReferenceClip.visible = false;
		addChild(this.m_view);
		this.m_headerSeparatorLine = new DottedLine(696, MenuConstants.COLOR_WHITE, DottedLine.TYPE_HORIZONTAL, 1, 2);
		this.m_perkSeparatorLine = new DottedLine(696, MenuConstants.COLOR_WHITE, DottedLine.TYPE_HORIZONTAL, 1, 2);
		this.m_killTypeSeparatorLine = new DottedLine(696, MenuConstants.COLOR_WHITE, DottedLine.TYPE_HORIZONTAL, 1, 2);
		this.m_view.headerClip.addChild(this.m_headerSeparatorLine).y = 79;
		this.m_scrollWidth = this.m_view.scrollAreaReferenceClip.width;
		this.m_scrollHeight = this.m_view.scrollAreaReferenceClip.height;
		this.m_scrollPosX = this.m_view.scrollAreaReferenceClip.x;
		this.m_scrollPosY = this.m_view.scrollAreaReferenceClip.y;
		this.createScrollContainer();
	}

	override public function onScroll(_arg_1:Number, _arg_2:Boolean):void {
		super.onScroll(_arg_1, _arg_2);
		this.m_scrollingContainer.scroll(_arg_1, _arg_2);
	}

	override public function getModalWidth():Number {
		return (1406);
	}

	override public function getModalHeight():Number {
		return (490);
	}

	override public function onSetData(data:Object):void {
		var isEvergreenGameMode:Boolean;
		var iconLabel:String;
		var subtypeLocaKey:String;
		var nameStr:String;
		var poisonType:int;
		var poisonTypeString:String;
		var showPoisonType:Boolean;
		super.onSetData(data);
		this.clean();
		if (data.name) {
			MenuUtils.setupTextUpper(this.m_view.headerClip.itemNameLabel, data.name, 40, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
			this.m_textTickerUtil.addTextTickerHtml(this.m_view.headerClip.itemNameLabel, 2000);
			this.m_textTickerUtil.callTextTicker(true, this.m_view.headerClip.itemNameLabel.textColor);
		}

		if (data.description) {
			this.createDescriptionText(data.description);
		}

		if (data.subtype) {
			iconLabel = data.subtype;
			if (data.type == "access") {
				iconLabel = "starting";
			} else {
				if (data.type == "agencypickup") {
					iconLabel = "stashpointempty";
				} else {
					if (data.type == "loadoutunlock") {
						iconLabel = "pistol";
					} else {
						if (data.type == "difficultyunlock") {
							iconLabel = "difficultylevel";
						} else {
							if (data.type == "evergreenmastery") {
								if (iconLabel == "safehouse_area") {
									iconLabel = "safehouse_unlock";
								}

								iconLabel = ("evergreen_" + iconLabel);
							} else {
								if (data.type == "disguise") {
									iconLabel = "disguise";
								}

							}

						}

					}

				}

			}

			MenuUtils.setupIcon(this.m_view.headerClip.itemIcon, iconLabel, MenuConstants.COLOR_WHITE, true, false);
		} else {
			if (data.icon) {
				MenuUtils.setupIcon(this.m_view.headerClip.itemIcon, data.icon, MenuConstants.COLOR_WHITE, true, false);
			}

		}

		if (data.type) {
			MenuUtils.setupTextUpper(this.m_view.headerClip.itemTypeLabel, data.type, 23, MenuConstants.FONT_TYPE_LIGHT, MenuConstants.FontColorWhite);
		}

		if (data.subtype) {
			subtypeLocaKey = ("UI_ITEM_SUBTYPE_" + data.subtype);
			subtypeLocaKey = subtypeLocaKey.toUpperCase();
			MenuUtils.setupTextUpper(this.m_view.headerClip.itemTypeLabel, Localization.get(subtypeLocaKey), 23, MenuConstants.FONT_TYPE_LIGHT, MenuConstants.FontColorWhite);
		}

		isEvergreenGameMode = (data.currentContractType == "evergreen");
		var evergreenRarity:int = (((isEvergreenGameMode) && (!(data.item == null))) ? data.item.Evergreen_Rarity : EvergreenUtils.ITEMRARITY_NONE);
		var evergreenCapacityCost:int = (((isEvergreenGameMode) && (!(data.item == null))) ? data.item.Evergreen_CapacityCost : 0);
		if (data.perks) {
			this.setPerksAndEvergreenAttribs(data.perks, evergreenRarity, evergreenCapacityCost);
		}

		if (data.item) {
			if (((!(data.description)) && (data.item.Description))) {
				this.createDescriptionText(Localization.get(data.item.Description));
			}

			if (!data.name) {
				nameStr = "";
				if (data.item.Name_LOC) {
					nameStr = Localization.get(data.item.Name_LOC);
				} else {
					if (data.item.Name) {
						nameStr = Localization.get(data.item.Name);
					}

				}

				MenuUtils.setupTextUpper(this.m_view.headerClip.itemNameLabel, nameStr, 40, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
				this.m_textTickerUtil.addTextTickerHtml(this.m_view.headerClip.itemNameLabel, 2000);
				this.m_textTickerUtil.callTextTicker(true, this.m_view.headerClip.itemNameLabel.textColor);
			}

			if (data.item.InventoryCategoryIcon) {
				MenuUtils.setupIcon(this.m_view.headerClip.itemIcon, data.item.InventoryCategoryIcon, MenuConstants.COLOR_WHITE, true, false);
			}

			if (((!(data.perks)) && (data.item.Perks))) {
				this.setPerksAndEvergreenAttribs(data.item.Perks, evergreenRarity, evergreenCapacityCost);
			}

		}

		var isGhostItem:Boolean = (((!(data.item == null)) && (!(data.item.ItemHUDType == null))) && (data.item.ItemHUDType == "EIHT_GhostItem"));
		if (((!(data.actionAndKillTypes == undefined)) || (isGhostItem))) {
			if (((data.actionAndKillTypes.length > 0) || (isGhostItem))) {
				this.setupKillTypes(data.actionAndKillTypes, isGhostItem);
			}

		}

		if (((!(data.item == null)) && (!(data.item.PoisonType == undefined)))) {
			showPoisonType = true;
			switch (data.item.PoisonType) {
				case "POISONTYPE_LETHAL":
					poisonType = 1;
					poisonTypeString = Localization.get("UI_HUD_INVENTORY_POISON_TYPE_LETHAL");
					break;
				case "POISONTYPE_SEDATIVE":
					poisonType = 2;
					poisonTypeString = Localization.get("UI_HUD_INVENTORY_POISON_TYPE_SEDATIVE");
					break;
				case "POISONTYPE_EMETIC":
					poisonType = 3;
					poisonTypeString = Localization.get("UI_HUD_INVENTORY_POISON_TYPE_EMETIC");
					break;
				default:
					showPoisonType = false;
			}

			if (showPoisonType) {
				this.setupPoisonType(poisonType, poisonTypeString);
			}

		}

		if (this.m_killTypesHolder != null) {
			if (this.m_perkHolder != null) {
				this.m_scrollingContainer.addGap(15);
			}

			this.m_scrollingContainer.appendEntry(this.m_killTypeSeparatorLine, false, this.m_killTypeSeparatorLine.height);
			this.m_scrollingContainer.addGap(15);
			this.m_scrollingContainer.appendEntry(this.m_killTypesHolder, false, this.m_killTypesHolder.height);
		}

		this.alignInfo();
		this.m_isAvailable = (((data.resourceAvailability == null) || (data.resourceAvailability.Availability == null)) || (data.resourceAvailability.Availability.available == true));
		if (this.m_isAvailable) {
			this.m_view.entitlementBar.visible = false;
		} else {
			this.m_view.entitlementBar.visible = true;
			this.m_view.entitlementBar.y = (this.m_view.headerClip.y - 9);
			MenuUtils.setupIcon(this.m_view.entitlementBar.icon, "locked", MenuConstants.COLOR_GREY_ULTRA_DARK, false, true, MenuConstants.COLOR_WHITE, 1, 0, true);
			MenuUtils.setupText(this.m_view.entitlementBar.header, Localization.get("UI_MENU_MISSION_END_LOCKED_MASTERY_REQUIRES"), 24, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
			MenuUtils.setupText(this.m_view.entitlementBar.title, data.missingEntitlementTitle, 25, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
		}

		var imagePath:String = data.image;
		if (imagePath != null) {
			this.m_itemImageLoader = new MenuImageLoader();
			this.m_view.itemImage.addChild(this.m_itemImageLoader);
			this.m_itemImageLoader.center = false;
			this.m_itemImageLoader.loadImage(imagePath, function ():void {
				m_itemImageLoader.getImage().smoothing = true;
				MenuUtils.scaleProportionalByHeight(DisplayObject(m_itemImageLoader.getImage()), ITEM_IMAGE_HEIGHT);
			});
			if (!this.m_isAvailable) {
				MenuUtils.setColorFilter(this.m_itemImageLoader, "shop");
			}

		}

		var obj:Object = {};
		obj.buttonprompts = data.displaybuttons;
		this.setButtonPrompts(obj);
	}

	private function clean():void {
		this.m_itemInfoPosX = 0;
		if (this.m_view == null) {
			return;
		}

		this.createScrollContainer();
		if (this.m_perkHolder != null) {
			this.m_perkHolder = null;
		}

		if (this.m_killTypesHolder != null) {
			this.m_killTypesHolder = null;
		}

		if (this.m_itemImageLoader != null) {
			this.m_itemImageLoader.cancelIfLoading();
			this.m_view.removeChild(this.m_itemImageLoader);
			this.m_itemImageLoader = null;
		}

	}

	private function setPerksAndEvergreenAttribs(perks:Array, evergreenRarity:int, evergreenCapacityCost:int):void {
		var xOffset:int;
		var yOffset:int;
		var colCount:int;
		var highestPerk:int;
		var addPerk:Function;
		var i:int;
		xOffset = 0;
		yOffset = 0;
		colCount = 0;
		highestPerk = 0;
		var hasPerks:Boolean = (((!(perks == null)) && (perks.length > 0)) && (!(perks[0] == "NONE")));
		var hasEvergreenAttribs:Boolean = ((EvergreenUtils.isValidRarityLabel(evergreenRarity)) || (evergreenCapacityCost > 0));
		if (((hasPerks) || (hasEvergreenAttribs))) {
			this.m_perkHolder = new Sprite();
			addPerk = function (_arg_1:String, _arg_2:Boolean, _arg_3:uint, _arg_4:String, _arg_5:String):void {
				var _local_6:ModalItemPerkView = new ModalItemPerkView();
				MenuUtils.setupIcon(_local_6.icon, _arg_1, MenuConstants.COLOR_WHITE, true, _arg_2, _arg_3);
				MenuUtils.setupText(_local_6.header, _arg_4, 21, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
				MenuUtils.setupText(_local_6.description, _arg_5, 17, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
				_local_6.description.autoSize = TextFieldAutoSize.LEFT;
				_local_6.x = (xOffset + ((_local_6.width + PADDING) * colCount));
				_local_6.y = yOffset;
				if (_local_6.height > highestPerk) {
					highestPerk = _local_6.height;
				}

				colCount++;
				if (colCount > 1) {
					colCount = 0;
					yOffset = (yOffset + (highestPerk + (PADDING * 2)));
					highestPerk = 0;
				}

				m_perkHolder.addChild(_local_6);
			};
			switch (evergreenRarity) {
				case EvergreenUtils.ITEMRARITY_COMMON:
					(addPerk("featured", true, EvergreenUtils.LABELBGCOLOR[EvergreenUtils.LABELPURPOSE_ITEMRARITY_COMMON], Localization.get("UI_INVENTORY_EVERGREEN_ITEMRARITY_COMMON"), Localization.get("UI_INVENTORY_EVERGREEN_ITEMRARITY")));
					break;
				case EvergreenUtils.ITEMRARITY_RARE:
					(addPerk("featured", true, EvergreenUtils.LABELBGCOLOR[EvergreenUtils.LABELPURPOSE_ITEMRARITY_RARE], Localization.get("UI_INVENTORY_EVERGREEN_ITEMRARITY_RARE"), Localization.get("UI_INVENTORY_EVERGREEN_ITEMRARITY")));
					break;
				case EvergreenUtils.ITEMRARITY_EPIC:
					(addPerk("featured", true, EvergreenUtils.LABELBGCOLOR[EvergreenUtils.LABELPURPOSE_ITEMRARITY_EPIC], Localization.get("UI_INVENTORY_EVERGREEN_ITEMRARITY_EPIC"), Localization.get("UI_INVENTORY_EVERGREEN_ITEMRARITY")));
					break;
				case EvergreenUtils.ITEMRARITY_LEGENDARY:
					(addPerk("featured", true, EvergreenUtils.LABELBGCOLOR[EvergreenUtils.LABELPURPOSE_ITEMRARITY_LEGENDARY], Localization.get("UI_INVENTORY_EVERGREEN_ITEMRARITY_LEGENDARY"), Localization.get("UI_INVENTORY_EVERGREEN_ITEMRARITY")));
					break;
			}

			if (evergreenCapacityCost > 0) {
				(addPerk(("evergreen_gearcost_" + evergreenCapacityCost.toString()), false, 0, Localization.get("Evergreen_Setpieces_GearWall_Item_GearCapacityCost").replace("{0}", evergreenCapacityCost.toString()), Localization.get("Evergreen_Setpieces_GearWall_Item_GearCapacityCost_Description")));
			}

			if (hasPerks) {
				i = 0;
				while (i < perks.length) {
					(addPerk(perks[i], false, 0, Localization.get((("UI_ITEM_PERKS_" + perks[i].toUpperCase()) + "_NAME")), Localization.get((("UI_ITEM_PERKS_" + perks[i].toUpperCase()) + "_DESC"))));
					i = (i + 1);
				}

			}

			this.m_scrollingContainer.appendEntry(this.m_perkSeparatorLine, false, this.m_perkSeparatorLine.height);
			this.m_scrollingContainer.addGap(15);
			this.m_scrollingContainer.appendEntry(this.m_perkHolder, false, this.m_perkHolder.height);
		}

	}

	private function setupPoisonType(_arg_1:int, _arg_2:String):void {
		this.setupKillTypeHolder();
		var _local_3:ModalDialogItemDetailsPoisonTypeView = new ModalDialogItemDetailsPoisonTypeView();
		var _local_4:Number = 8;
		MenuUtils.setupText(_local_3.label_txt, _arg_2, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		_local_3.label_txt.autoSize = "left";
		_local_3.back_mc.gotoAndStop(_arg_1);
		_local_3.back_mc.width = (Math.ceil(_local_3.label_txt.textWidth) + 18);
		_local_3.x = this.m_itemInfoPosX;
		this.m_itemInfoPosX = (this.m_itemInfoPosX + (_local_3.back_mc.width + _local_4));
		this.m_killTypesHolder.addChild(_local_3);
	}

	private function setupKillTypes(_arg_1:Array, _arg_2:Boolean):void {
		var _local_3:ModalDialogItemDetailsKilltypeView;
		var _local_6:ModalDialogItemDetailsGhostItemView;
		this.setupKillTypeHolder();
		var _local_4:Number = 8;
		var _local_5:int;
		while (_local_5 < _arg_1.length) {
			_local_3 = new ModalDialogItemDetailsKilltypeView();
			_local_3.label_txt.text = _arg_1[_local_5];
			_local_3.label_txt.autoSize = TextFieldAutoSize.LEFT;
			_local_3.back_mc.width = (Math.ceil(_local_3.label_txt.textWidth) + 18);
			_local_3.x = this.m_itemInfoPosX;
			this.m_itemInfoPosX = (this.m_itemInfoPosX + (_local_3.back_mc.width + _local_4));
			this.m_killTypesHolder.addChild(_local_3);
			_local_5++;
		}

		if (_arg_2) {
			_local_6 = new ModalDialogItemDetailsGhostItemView();
			MenuUtils.setupText(_local_6.label_txt, Localization.get("UI_HUD_WEAPON_GHOST"), 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			_local_6.label_txt.autoSize = "left";
			_local_6.back_mc.width = (Math.ceil(_local_6.label_txt.textWidth) + 18);
			_local_6.x = this.m_itemInfoPosX;
			this.m_itemInfoPosX = (this.m_itemInfoPosX + (_local_6.back_mc.width + _local_4));
			this.m_killTypesHolder.addChild(_local_6);
		}

	}

	private function setupKillTypeHolder():void {
		if (this.m_killTypesHolder != null) {
			return;
		}

		this.m_killTypesHolder = new Sprite();
	}

	private function alignInfo():void {
		var _local_1:int = (this.m_scrollPosY + this.m_scrollHeight);
		if (this.m_scrollingContainer.getContentHeight() < this.m_scrollHeight) {
			this.m_scrollingContainer.y = (_local_1 - this.m_scrollingContainer.getContentHeight());
		}

		this.m_view.headerClip.y = (this.m_scrollingContainer.y - (this.m_view.headerClip.height + 15));
	}

	private function setButtonPrompts(_arg_1:Object):void {
		if (_arg_1.buttonprompts) {
			this.m_backButton = _arg_1.buttonprompts[0];
		}

		this.updateButtonPromptsInternal();
	}

	private function updateButtonPromptsInternal():void {
		this.m_view.buttonPromptsMc.removeChildren();
		var _local_1:Object = {};
		_local_1.buttonprompts = [this.m_backButton];
		addMouseEventListeners(this.m_view.buttonPromptsMc, 0);
		MenuUtils.parsePrompts(_local_1, null, this.m_view.buttonPromptsMc);
	}

	override public function updateButtonPrompts():void {
		super.updateButtonPrompts();
		this.updateButtonPromptsInternal();
		this.onSetData(getData());
	}

	private function createDescriptionText(_arg_1:String):void {
		var _local_2:TextField = new TextField();
		_local_2.autoSize = TextFieldAutoSize.LEFT;
		_local_2.width = this.m_scrollWidth;
		_local_2.multiline = true;
		_local_2.wordWrap = true;
		_local_2.selectable = false;
		MenuUtils.setupText(_local_2, _arg_1, 18, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		CommonUtils.changeFontToGlobalIfNeeded(_local_2);
		this.m_scrollingContainer.appendEntry(_local_2, false, _local_2.height);
		this.m_scrollingContainer.addGap(15);
	}

	private function createScrollContainer():void {
		if (this.m_scrollingContainer != null) {
			this.m_view.removeChild(this.m_scrollingContainer);
			this.m_scrollingContainer = null;
		}

		var _local_1:Number = 30;
		this.m_scrollingContainer = new ModalScrollingContainer((this.m_scrollWidth + _local_1), this.m_scrollHeight, _local_1, true, "targetobjectives");
		this.m_view.addChild(this.m_scrollingContainer);
		this.m_scrollingContainer.x = this.m_scrollPosX;
		this.m_scrollingContainer.y = this.m_scrollPosY;
		this.m_scrollingContainer.visible = true;
		addMouseWheelEventListener(this.m_scrollingContainer);
	}

	override public function onUnregister():void {
		super.onUnregister();
		if (this.m_view) {
			this.m_textTickerUtil.onUnregister();
			this.m_textTickerUtil = null;
			removeChild(this.m_view);
			this.m_view = null;
		}

	}


}
}//package menu3.modal

