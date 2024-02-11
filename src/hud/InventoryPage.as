// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.InventoryPage

package hud {
import common.BaseControl;

import basic.IButtonPromptOwner;

import menu3.MenuElementTileBase;
import menu3.containers.ListContainer;

import flash.text.TextField;

import common.menu.MenuConstants;

import flash.display.Sprite;

import common.ImageLoader;

import flash.events.Event;
import flash.text.TextFieldAutoSize;

import common.menu.MenuUtils;
import common.Log;

import basic.ButtonPromtUtil;

import flash.utils.getDefinitionByName;

import menu3.MenuElementBase;

import common.Animate;

import flash.events.MouseEvent;

import menu3.*;
import menu3.containers.*;

public class InventoryPage extends BaseControl implements IButtonPromptOwner {

	private var m_safeAreaRatio:Number = 1;
	private var m_selectedItem:MenuElementTileBase;
	private var previousSelectedItem:MenuElementTileBase;
	private var m_highlightedItem:InventoryItemIcon = null;
	private var m_playerInventoryContainer:ListContainer;
	private var m_worldInventoryContainer:ListContainer;
	private var m_worldInventoryName:TextField;
	private var m_itemName:TextField;
	private var m_allChildren:Object = {};
	private var m_screenWidth:Number = MenuConstants.BaseWidth;
	private var m_screenHeight:Number = MenuConstants.BaseHeight;
	private var m_container:Sprite;
	private var m_background:Sprite = new Sprite();
	private var m_backgroundFill:RedQuad;
	private var m_backgroundImageContainer:Sprite;
	private var m_backgroundImage:ImageLoader;
	private var m_playerListXPos:Number = 234;
	private var m_worldListXPos:Number = ((MenuConstants.BaseWidth * 0.75) - 70);
	private var m_scrollFocusYPos:Number = 360;
	private var m_weaponInfo:WeaponSelectorInfoView;
	private var m_itemInfo:Sprite;
	private var m_itemActions:ListContainer;
	private var m_buttonPrompts:Sprite;
	private var m_buttonPromptsData:Object;
	private var m_moveStateActive:Boolean = false;
	private var m_view:Sprite = new Sprite();
	private var m_backgroundImageRid:String;

	public function InventoryPage() {
		addEventListener(Event.ADDED_TO_STAGE, this.addedHandler);
		addEventListener(Event.REMOVED_FROM_STAGE, this.removedHandler);
		addChild(this.m_background);
		this.m_backgroundFill = new RedQuad();
		this.m_backgroundFill.width = MenuConstants.BaseWidth;
		this.m_backgroundFill.height = MenuConstants.BaseHeight;
		this.m_background.addChild(this.m_backgroundFill);
		this.m_container = new Sprite();
		addChild(this.m_container);
		this.m_backgroundImageContainer = new Sprite();
		this.m_container.addChild(this.m_backgroundImageContainer);
		this.m_backgroundImage = new ImageLoader();
		this.m_backgroundImageContainer.addChild(this.m_backgroundImage);
		this.m_container.addChild(this.m_view);
		this.m_playerInventoryContainer = this.createSlotContainer(220, this.m_screenHeight, this.m_playerListXPos, 0);
		this.m_playerInventoryContainer.getContainer().y = this.m_scrollFocusYPos;
		this.m_worldInventoryContainer = this.createSlotContainer(220, this.m_screenHeight, this.m_worldListXPos, 0);
		this.m_worldInventoryContainer.getContainer().y = this.m_scrollFocusYPos;
		this.m_itemName = new TextField();
		this.m_itemName.autoSize = TextFieldAutoSize.LEFT;
		MenuUtils.setupText(this.m_itemName, "Test", 24, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorGreyUltraLight);
		this.m_itemName.x = ((this.m_playerListXPos + InventoryItemIcon.ITEM_SIZE_WIDTH) + 20);
		this.m_itemName.y = ((this.m_scrollFocusYPos + (InventoryItemIcon.ITEM_SIZE_HEIGHT * 0.5)) - (this.m_itemName.height * 0.5));
		MenuUtils.setupText(this.m_itemName, "", 24, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorGreyUltraLight);
		this.m_itemInfo = new Sprite();
		this.m_itemInfo.x = ((this.m_playerListXPos + 220) + 20);
		this.m_itemInfo.y = this.m_itemName.y;
		this.m_itemActions = this.createSlotContainer(300, this.m_screenHeight, 0, 0);
		this.m_itemInfo.addChild(this.m_itemActions);
		this.m_worldInventoryName = new TextField();
		this.m_worldInventoryName.autoSize = TextFieldAutoSize.RIGHT;
		this.m_worldInventoryName.x = (this.m_worldListXPos - 40);
		this.m_worldInventoryName.y = this.m_scrollFocusYPos;
		MenuUtils.setupText(this.m_worldInventoryName, "Will drop", 24, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorGreyUltraLight);
		this.m_view.addChild(this.m_playerInventoryContainer);
		this.m_view.addChild(this.m_worldInventoryContainer);
		this.m_view.addChild(this.m_worldInventoryName);
		this.m_view.addChild(this.m_itemName);
		this.m_view.addChild(this.m_itemInfo);
		this.m_buttonPrompts = new Sprite();
		this.m_buttonPrompts.x = 600;
		this.m_buttonPrompts.y = (MenuConstants.BaseHeight - 75);
		this.m_view.addChild(this.m_buttonPrompts);
	}

	public function setButtonPromptData(_arg_1:Object):void {
		this.m_buttonPromptsData = _arg_1;
		this.setPrompts();
	}

	private function setPrompts():void {
		MenuUtils.parsePrompts(this.m_buttonPromptsData, null, this.m_buttonPrompts, false, this.handlePromptMouseEvent);
	}

	private function handlePromptMouseEvent(_arg_1:String):void {
		Log.info("mouse", this, ("Prompt action click: " + _arg_1));
		var _local_2:int = -1;
		if (_arg_1 == "cancel") {
			_local_2 = 0;
		}

		if (_arg_1 == "accept") {
			_local_2 = 1;
		}

		if (_arg_1 == "action-x") {
			_local_2 = 2;
		}

		if (_arg_1 == "action-y") {
			_local_2 = 5;
		}

		if (_arg_1 == "r") {
			_local_2 = 4;
		}

		if (_local_2 >= 0) {
			sendEventWithValue("onInputAction", _local_2);
		}

	}

	public function updateButtonPrompts():void {
		this.setPrompts();
	}

	public function updateButtonPromptOwners():void {
		ButtonPromtUtil.updateButtonPromptOwners();
	}

	private function addedHandler(_arg_1:Event):void {
		ButtonPromtUtil.registerButtonPromptOwner(this);
	}

	private function removedHandler(_arg_1:Event):void {
		ButtonPromtUtil.unregisterButtonPromptOwner(this);
	}

	public function onLoadSuccess():void {
		Log.info(Log.ChannelDebug, this, "background image load success!");
	}

	public function onLoadFailed():void {
		Log.info(Log.ChannelDebug, this, "background image load failed!");
	}

	public function setBackgroundImage(_arg_1:String):void {
		if (_arg_1 == this.m_backgroundImageRid) {
			return;
		}

		this.m_backgroundImageRid = _arg_1;
		this.m_backgroundImage.cancel();
		this.m_backgroundImage.loadImage(this.m_backgroundImageRid, this.onLoadSuccess, this.onLoadFailed);
	}

	public function onSetData(_arg_1:Object):void {
		Log.debugData(this, _arg_1);
		var _local_2:Boolean = (((!(_arg_1.playerInventory == null)) && (!(_arg_1.playerInventory.slots == null))) && (_arg_1.playerInventory.slots.length > 0));
		var _local_3:Boolean = (((!(_arg_1.worldInventory == null)) && (!(_arg_1.worldInventory.slots == null))) && (_arg_1.worldInventory.slots.length > 0));
		if (_local_2) {
			this.m_playerInventoryContainer.clearChildren();
			this.createInventory(_arg_1.playerInventory, this.m_playerInventoryContainer, true);
		}

		if (_local_3) {
			this.m_worldInventoryContainer.clearChildren();
			this.createInventory(_arg_1.worldInventory, this.m_worldInventoryContainer, false);
		}

		if (((_local_2) && (_local_3))) {
			this.m_playerInventoryContainer.getContainer().y = this.m_scrollFocusYPos;
			this.m_worldInventoryContainer.getContainer().y = this.m_scrollFocusYPos;
		}

	}

	private function createInventory(_arg_1:Object, _arg_2:ListContainer, _arg_3:Boolean):void {
		var _local_6:Sprite;
		var _local_7:Object;
		var _local_10:Object;
		var _local_11:TextField;
		var _local_12:Array;
		var _local_13:int;
		var _local_14:Number;
		var _local_15:Number;
		var _local_16:int;
		var _local_17:Object;
		var _local_18:Number;
		var _local_19:InventoryGroupLine;
		var _local_4:int = 12;
		var _local_5:int = 4;
		var _local_8:int = _arg_1.slots.length;
		var _local_9:int;
		while (_local_9 < _local_8) {
			if (_local_9 != 0) {
				_local_6 = this.createEmptyElement(_local_4);
				_arg_2.addChild2(_local_6);
			}

			_local_10 = _arg_1.slots[_local_9];
			_local_11 = null;
			if (_arg_3) {
				_local_11 = new TextField();
				_local_11.autoSize = TextFieldAutoSize.RIGHT;
				_local_11.x = -25;
				MenuUtils.setupText(_local_11, _local_10.label, 24, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorGreyUltraLight);
			}

			_local_12 = _local_10.items;
			_local_13 = _local_12.length;
			if (_local_13 <= 0) {
				_local_7 = {};
				_local_7.label = "";
				_local_7.uniqueId = _local_10.uniqueId;
				_local_7.parentSlot = _local_10.label;
				_local_12.push(_local_7);
			}

			_local_14 = 0;
			_local_15 = 0;
			_local_16 = 0;
			while (_local_16 < _local_12.length) {
				if (_local_16 != 0) {
					_local_6 = this.createEmptyElement(_local_5);
					_arg_2.addChild2(_local_6);
				}

				_local_17 = _local_10.items[_local_16];
				_local_6 = this.createElement("hud.InventoryItemIcon", _local_17);
				if (_local_16 == 0) {
					if (_local_11 != null) {
						_local_6.addChild(_local_11);
					}

					_local_18 = ((InventoryItemIcon.ITEM_SIZE_HEIGHT * _local_12.length) + (_local_5 * (_local_12.length - 1)));
					_local_19 = new InventoryGroupLine();
					_local_19.x = -10;
					_local_19.height = _local_18;
					_local_19.y = (_local_18 * 0.5);
					_local_6.addChild(_local_19);
				}

				_arg_2.addChild2(_local_6);
				_local_16++;
			}

			_local_9++;
		}

	}

	public function updateNode(_arg_1:Object):void {
		var _local_5:String;
		var _local_2:int = _arg_1.uniqueId;
		Log.info(Log.ChannelDebug, this, ("updateNode: " + _local_2));
		Log.debugData(this, _arg_1);
		var _local_3:InventoryItemIcon = (this.m_allChildren[_local_2] as InventoryItemIcon);
		if (!_local_3) {
			Log.info(Log.ChannelDebug, this, "updateNode target not found");
			return;
		}

		_local_3.onSetData(_arg_1);
		var _local_4:InventoryItemIcon = (this.m_selectedItem as InventoryItemIcon);
		if (((!(_local_4 == null)) && (_local_4 == _local_3))) {
			_local_5 = _local_4.m_itemName;
			if (_local_4.m_itemCount > 1) {
				_local_5 = (((_local_5 + " (") + _local_4.m_itemCount) + ")");
			}

			MenuUtils.setupText(this.m_itemName, _local_5, 24, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorGreyUltraLight);
		}

	}

	public function setMoveItem(_arg_1:int, _arg_2:int):void {
		trace("invoked setMoveItem");
		var _local_3:InventoryItemIcon = (this.m_allChildren[_arg_1] as InventoryItemIcon);
		if (!_local_3) {
			trace("setMoveItem target not found");
			return;
		}

		trace("setMoveItem found target");
		if (this.m_highlightedItem != null) {
			this.m_highlightedItem.onSetHighlighted(false);
		}

		_local_3.onSetHighlighted(true);
		this.m_highlightedItem = _local_3;
	}

	public function clearMoveItem():void {
		if (this.m_highlightedItem != null) {
			this.m_highlightedItem.onSetHighlighted(false);
			this.m_highlightedItem = null;
		}

	}

	public function setSelected(_arg_1:int, _arg_2:int):void {
		trace("invoked setSelected");
		var _local_3:Sprite = (this.m_allChildren[_arg_1] as Sprite);
		if (!_local_3) {
			trace("setSelected target not found");
			return;
		}

		trace("setSelected found target");
		this.handleSelectionChanged((_local_3 as MenuElementTileBase));
	}

	private function createElement(_arg_1:String, _arg_2:Object):Sprite {
		var _local_3:Class = (getDefinitionByName(_arg_1) as Class);
		var _local_4:Sprite = new _local_3(_arg_2);
		this.m_allChildren[_arg_2.uniqueId] = _local_4;
		if (_arg_2.mouse) {
		}

		var _local_5:MenuElementBase = (_local_4 as MenuElementBase);
		if (_local_5 != null) {
			_local_5.onSetData(_arg_2);
		}

		return (_local_4);
	}

	public function createEmptyElement(_arg_1:Number):Sprite {
		var _local_2:Object = {};
		_local_2.width = 220;
		_local_2.height = _arg_1;
		var _local_3:Sprite = this.createElement("hud.EmptySpace", _local_2);
		_local_3.alpha = 0;
		return (_local_3);
	}

	public function handleSelectionChanged(_arg_1:MenuElementTileBase):void {
		var _local_2:InventoryItemIcon;
		var _local_3:Number;
		var _local_4:ListContainer;
		var _local_5:String;
		var _local_6:Number;
		if (this.previousSelectedItem) {
			this.previousSelectedItem.setItemSelected(false);
		}

		this.previousSelectedItem = _arg_1;
		if (_arg_1) {
			trace(("new selection: " + _arg_1));
			_arg_1.setItemSelected(true);
			_local_2 = (_arg_1 as InventoryItemIcon);
			if (_local_2 != null) {
				_local_5 = _local_2.m_itemName;
				if (_local_2.m_itemCount > 1) {
					_local_5 = (((_local_5 + " (") + _local_2.m_itemCount) + ")");
				}

				MenuUtils.setupText(this.m_itemName, _local_5, 24, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorGreyUltraLight);
			}

			_local_3 = MenuConstants.ScrollTime;
			_local_4 = (_arg_1.m_parent as ListContainer);
			if (_local_4) {
				_local_6 = (this.m_scrollFocusYPos - _arg_1.y);
				if (_local_3 == 0) {
					_local_4.y = _local_6;
				} else {
					Animate.legacyTo(_local_4.getContainer(), _local_3, {"y": _local_6}, Animate.ExpoOut);
				}

			}

		}

		this.m_selectedItem = _arg_1;
	}

	private function addMouseEventListeners(elementSprite:Sprite):void {
		var elementBase:MenuElementBase;
		elementBase = (elementSprite as MenuElementBase);
		if (elementBase) {
			elementBase.addEventListener(MouseEvent.MOUSE_UP, function (_arg_1:MouseEvent):void {
				elementBase.handleMouseUp(sendEventWithValue, _arg_1);
			}, false, 0, false);
			elementBase.addEventListener(MouseEvent.MOUSE_DOWN, function (_arg_1:MouseEvent):void {
				elementBase.handleMouseDown(sendEventWithValue, _arg_1);
			}, false, 0, false);
			elementBase.addEventListener(MouseEvent.MOUSE_OVER, function (_arg_1:MouseEvent):void {
				elementBase.handleMouseOver(sendEventWithValue, _arg_1);
			}, false, 0, false);
			elementBase.addEventListener(MouseEvent.MOUSE_OUT, function (_arg_1:MouseEvent):void {
				elementBase.handleMouseOut(sendEventWithValue, _arg_1);
			}, false, 0, false);
			elementBase.addEventListener(MouseEvent.MOUSE_MOVE, function (_arg_1:MouseEvent):void {
				elementBase.handleMouseMove(sendEventWithValue, _arg_1);
			}, false, 0, false);
			elementBase.addEventListener(MouseEvent.MOUSE_WHEEL, function (_arg_1:MouseEvent):void {
				elementBase.handleMouseWheel(sendEventWithValue, _arg_1);
			}, false, 0, false);
			elementBase.addEventListener(MouseEvent.ROLL_OVER, function (_arg_1:MouseEvent):void {
				elementBase.handleMouseRollOver(sendEventWithValue, _arg_1);
			}, false, 0, false);
			elementBase.addEventListener(MouseEvent.ROLL_OUT, function (_arg_1:MouseEvent):void {
				elementBase.handleMouseRollOut(sendEventWithValue, _arg_1);
			}, false, 0, false);
			elementBase.setEngineCallbacks(sendEvent, sendEventWithValue);
		}

	}

	override public function onSetSize(_arg_1:Number, _arg_2:Number):void {
		Log.xinfo(Log.ChannelDebug, ((("InventoryPage | onSetSize sizeX=" + _arg_1) + " sizeY=") + _arg_2));
		this.m_screenWidth = _arg_1;
		this.m_screenHeight = _arg_2;
		MenuUtils.centerFillAspect(this.m_container, MenuConstants.BaseWidth, MenuConstants.BaseHeight, _arg_1, _arg_2);
		MenuUtils.centerFill(this.m_background, MenuConstants.BaseWidth, MenuConstants.BaseHeight, _arg_1, _arg_2);
	}

	private function createSlotContainer(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number):ListContainer {
		var _local_5:Object = {};
		_local_5.sizeY = 1;
		_local_5.width = _arg_1;
		_local_5.height = _arg_2;
		var _local_6:ListContainer = new ListContainer(_local_5);
		_local_6.x = _arg_3;
		_local_6.y = _arg_4;
		return (_local_6);
	}

	override public function onSetViewport(_arg_1:Number, _arg_2:Number, _arg_3:Number):void {
		Log.xinfo(Log.ChannelDebug, ((("InventoryPage | onSetViewport scaleX=" + _arg_1) + " scaleY=") + _arg_2));
		this.m_safeAreaRatio = _arg_3;
		this.m_view.scaleX = this.m_safeAreaRatio;
		this.m_view.scaleY = this.m_safeAreaRatio;
		this.m_view.x = ((MenuConstants.BaseWidth * (1 - this.m_safeAreaRatio)) / 2);
		this.m_view.y = ((MenuConstants.BaseHeight * (1 - this.m_safeAreaRatio)) / 2);
	}

	override public function onSetVisible(_arg_1:Boolean):void {
		super.onSetVisible(_arg_1);
		this.visible = _arg_1;
	}

	private function getDebugData():Object {
		var _local_1:Object = {};
		var _local_2:Object = {};
		var _local_3:Object = {};
		_local_3.label = "Pocket";
		var _local_4:Object = {};
		_local_4.label = "Right Hand";
		var _local_5:Object = {};
		_local_5.label = "Left Hand";
		var _local_6:Object = {};
		_local_6.label = "Pistol Holster";
		var _local_7:Object = {};
		_local_7.label = "crowbar";
		var _local_8:Object = {};
		_local_8.label = "screwdriver";
		var _local_9:Object = {};
		_local_9.label = "hammer";
		_local_9.uniqueId = 2;
		var _local_10:Object = {};
		_local_10.label = "pistol";
		_local_3.items = [_local_7, _local_8, _local_7, _local_8];
		_local_4.items = new Array(_local_9);
		_local_4.uniqueId = 1;
		_local_5.items = [];
		_local_6.items = new Array(_local_10);
		_local_2.slots = [_local_4, _local_5, _local_6, _local_3];
		_local_1.playerInventory = _local_2;
		_local_1.worldInventory = _local_2;
		return (_local_1);
	}


}
}//package hud

