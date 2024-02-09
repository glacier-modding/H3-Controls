package hud
{
	import basic.ButtonPromtUtil;
	import basic.IButtonPromptOwner;
	import common.Animate;
	import common.BaseControl;
	import common.ImageLoader;
	import common.Log;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getDefinitionByName;
	import menu3.*;
	import menu3.containers.*;
	
	public class InventoryPage extends BaseControl implements IButtonPromptOwner
	{
		
		private var m_safeAreaRatio:Number = 1;
		
		private var m_selectedItem:MenuElementTileBase;
		
		private var previousSelectedItem:MenuElementTileBase;
		
		private var m_highlightedItem:InventoryItemIcon = null;
		
		private var m_playerInventoryContainer:ListContainer;
		
		private var m_worldInventoryContainer:ListContainer;
		
		private var m_worldInventoryName:TextField;
		
		private var m_itemName:TextField;
		
		private var m_allChildren:Object;
		
		private var m_screenWidth:Number;
		
		private var m_screenHeight:Number;
		
		private var m_container:Sprite;
		
		private var m_background:Sprite;
		
		private var m_backgroundFill:RedQuad;
		
		private var m_backgroundImageContainer:Sprite;
		
		private var m_backgroundImage:ImageLoader;
		
		private var m_playerListXPos:Number = 234;
		
		private var m_worldListXPos:Number;
		
		private var m_scrollFocusYPos:Number = 360;
		
		private var m_weaponInfo:WeaponSelectorInfoView;
		
		private var m_itemInfo:Sprite;
		
		private var m_itemActions:ListContainer;
		
		private var m_buttonPrompts:Sprite;
		
		private var m_buttonPromptsData:Object;
		
		private var m_moveStateActive:Boolean = false;
		
		private var m_view:Sprite;
		
		private var m_backgroundImageRid:String;
		
		public function InventoryPage()
		{
			this.m_allChildren = {};
			this.m_screenWidth = MenuConstants.BaseWidth;
			this.m_screenHeight = MenuConstants.BaseHeight;
			this.m_background = new Sprite();
			this.m_worldListXPos = MenuConstants.BaseWidth * 0.75 - 70;
			this.m_view = new Sprite();
			super();
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
			this.m_itemName.x = this.m_playerListXPos + InventoryItemIcon.ITEM_SIZE_WIDTH + 20;
			this.m_itemName.y = this.m_scrollFocusYPos + InventoryItemIcon.ITEM_SIZE_HEIGHT * 0.5 - this.m_itemName.height * 0.5;
			MenuUtils.setupText(this.m_itemName, "", 24, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorGreyUltraLight);
			this.m_itemInfo = new Sprite();
			this.m_itemInfo.x = this.m_playerListXPos + 220 + 20;
			this.m_itemInfo.y = this.m_itemName.y;
			this.m_itemActions = this.createSlotContainer(300, this.m_screenHeight, 0, 0);
			this.m_itemInfo.addChild(this.m_itemActions);
			this.m_worldInventoryName = new TextField();
			this.m_worldInventoryName.autoSize = TextFieldAutoSize.RIGHT;
			this.m_worldInventoryName.x = this.m_worldListXPos - 40;
			this.m_worldInventoryName.y = this.m_scrollFocusYPos;
			MenuUtils.setupText(this.m_worldInventoryName, "Will drop", 24, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorGreyUltraLight);
			this.m_view.addChild(this.m_playerInventoryContainer);
			this.m_view.addChild(this.m_worldInventoryContainer);
			this.m_view.addChild(this.m_worldInventoryName);
			this.m_view.addChild(this.m_itemName);
			this.m_view.addChild(this.m_itemInfo);
			this.m_buttonPrompts = new Sprite();
			this.m_buttonPrompts.x = 600;
			this.m_buttonPrompts.y = MenuConstants.BaseHeight - 75;
			this.m_view.addChild(this.m_buttonPrompts);
		}
		
		public function setButtonPromptData(param1:Object):void
		{
			this.m_buttonPromptsData = param1;
			this.setPrompts();
		}
		
		private function setPrompts():void
		{
			MenuUtils.parsePrompts(this.m_buttonPromptsData, null, this.m_buttonPrompts, false, this.handlePromptMouseEvent);
		}
		
		private function handlePromptMouseEvent(param1:String):void
		{
			Log.info("mouse", this, "Prompt action click: " + param1);
			var _loc2_:int = -1;
			if (param1 == "cancel")
			{
				_loc2_ = 0;
			}
			if (param1 == "accept")
			{
				_loc2_ = 1;
			}
			if (param1 == "action-x")
			{
				_loc2_ = 2;
			}
			if (param1 == "action-y")
			{
				_loc2_ = 5;
			}
			if (param1 == "r")
			{
				_loc2_ = 4;
			}
			if (_loc2_ >= 0)
			{
				sendEventWithValue("onInputAction", _loc2_);
			}
		}
		
		public function updateButtonPrompts():void
		{
			this.setPrompts();
		}
		
		public function updateButtonPromptOwners():void
		{
			ButtonPromtUtil.updateButtonPromptOwners();
		}
		
		private function addedHandler(param1:Event):void
		{
			ButtonPromtUtil.registerButtonPromptOwner(this);
		}
		
		private function removedHandler(param1:Event):void
		{
			ButtonPromtUtil.unregisterButtonPromptOwner(this);
		}
		
		public function onLoadSuccess():void
		{
			Log.info(Log.ChannelDebug, this, "background image load success!");
		}
		
		public function onLoadFailed():void
		{
			Log.info(Log.ChannelDebug, this, "background image load failed!");
		}
		
		public function setBackgroundImage(param1:String):void
		{
			if (param1 == this.m_backgroundImageRid)
			{
				return;
			}
			this.m_backgroundImageRid = param1;
			this.m_backgroundImage.cancel();
			this.m_backgroundImage.loadImage(this.m_backgroundImageRid, this.onLoadSuccess, this.onLoadFailed);
		}
		
		public function onSetData(param1:Object):void
		{
			Log.debugData(this, param1);
			var _loc2_:Boolean = param1.playerInventory != null && param1.playerInventory.slots != null && param1.playerInventory.slots.length > 0;
			var _loc3_:Boolean = param1.worldInventory != null && param1.worldInventory.slots != null && param1.worldInventory.slots.length > 0;
			if (_loc2_)
			{
				this.m_playerInventoryContainer.clearChildren();
				this.createInventory(param1.playerInventory, this.m_playerInventoryContainer, true);
			}
			if (_loc3_)
			{
				this.m_worldInventoryContainer.clearChildren();
				this.createInventory(param1.worldInventory, this.m_worldInventoryContainer, false);
			}
			if (_loc2_ && _loc3_)
			{
				this.m_playerInventoryContainer.getContainer().y = this.m_scrollFocusYPos;
				this.m_worldInventoryContainer.getContainer().y = this.m_scrollFocusYPos;
			}
		}
		
		private function createInventory(param1:Object, param2:ListContainer, param3:Boolean):void
		{
			var _loc6_:Sprite = null;
			var _loc7_:Object = null;
			var _loc10_:Object = null;
			var _loc11_:TextField = null;
			var _loc12_:Array = null;
			var _loc13_:int = 0;
			var _loc14_:Number = NaN;
			var _loc15_:Number = NaN;
			var _loc16_:int = 0;
			var _loc17_:Object = null;
			var _loc18_:Number = NaN;
			var _loc19_:InventoryGroupLine = null;
			var _loc4_:int = 12;
			var _loc5_:int = 4;
			var _loc8_:int = int(param1.slots.length);
			var _loc9_:int = 0;
			while (_loc9_ < _loc8_)
			{
				if (_loc9_ != 0)
				{
					_loc6_ = this.createEmptyElement(_loc4_);
					param2.addChild2(_loc6_);
				}
				_loc10_ = param1.slots[_loc9_];
				_loc11_ = null;
				if (param3)
				{
					(_loc11_ = new TextField()).autoSize = TextFieldAutoSize.RIGHT;
					_loc11_.x = -25;
					MenuUtils.setupText(_loc11_, _loc10_.label, 24, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorGreyUltraLight);
				}
				if ((_loc13_ = int((_loc12_ = _loc10_.items).length)) <= 0)
				{
					(_loc7_ = new Object()).label = "";
					_loc7_.uniqueId = _loc10_.uniqueId;
					_loc7_.parentSlot = _loc10_.label;
					_loc12_.push(_loc7_);
				}
				_loc14_ = 0;
				_loc15_ = 0;
				_loc16_ = 0;
				while (_loc16_ < _loc12_.length)
				{
					if (_loc16_ != 0)
					{
						_loc6_ = this.createEmptyElement(_loc5_);
						param2.addChild2(_loc6_);
					}
					_loc17_ = _loc10_.items[_loc16_];
					_loc6_ = this.createElement("hud.InventoryItemIcon", _loc17_);
					if (_loc16_ == 0)
					{
						if (_loc11_ != null)
						{
							_loc6_.addChild(_loc11_);
						}
						_loc18_ = InventoryItemIcon.ITEM_SIZE_HEIGHT * _loc12_.length + _loc5_ * (_loc12_.length - 1);
						(_loc19_ = new InventoryGroupLine()).x = -10;
						_loc19_.height = _loc18_;
						_loc19_.y = _loc18_ * 0.5;
						_loc6_.addChild(_loc19_);
					}
					param2.addChild2(_loc6_);
					_loc16_++;
				}
				_loc9_++;
			}
		}
		
		public function updateNode(param1:Object):void
		{
			var _loc5_:* = null;
			var updateNode:int = int(param1.uniqueId);
			Log.info(Log.ChannelDebug, this, "updateNode: " + updateNode);
			Log.debugData(this, param1);
			var _loc3_:InventoryItemIcon = this.m_allChildren[updateNode] as InventoryItemIcon;
			if (!_loc3_)
			{
				Log.info(Log.ChannelDebug, this, "updateNode target not found");
				return;
			}
			_loc3_.onSetData(param1);
			var _loc4_:InventoryItemIcon;
			if ((_loc4_ = this.m_selectedItem as InventoryItemIcon) != null && _loc4_ == _loc3_)
			{
				_loc5_ = _loc4_.m_itemName;
				if (_loc4_.m_itemCount > 1)
				{
					_loc5_ = _loc5_ + " (" + _loc4_.m_itemCount + ")";
				}
				MenuUtils.setupText(this.m_itemName, _loc5_, 24, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorGreyUltraLight);
			}
		}
		
		public function setMoveItem(param1:int, param2:int):void
		{
			trace("invoked setMoveItem");
			var _loc3_:InventoryItemIcon = this.m_allChildren[param1] as InventoryItemIcon;
			if (!_loc3_)
			{
				trace("setMoveItem target not found");
				return;
			}
			trace("setMoveItem found target");
			if (this.m_highlightedItem != null)
			{
				this.m_highlightedItem.onSetHighlighted(false);
			}
			_loc3_.onSetHighlighted(true);
			this.m_highlightedItem = _loc3_;
		}
		
		public function clearMoveItem():void
		{
			if (this.m_highlightedItem != null)
			{
				this.m_highlightedItem.onSetHighlighted(false);
				this.m_highlightedItem = null;
			}
		}
		
		public function setSelected(param1:int, param2:int):void
		{
			trace("invoked setSelected");
			var _loc3_:Sprite = this.m_allChildren[param1] as Sprite;
			if (!_loc3_)
			{
				trace("setSelected target not found");
				return;
			}
			trace("setSelected found target");
			this.handleSelectionChanged(_loc3_ as MenuElementTileBase);
		}
		
		private function createElement(param1:String, param2:Object):Sprite
		{
			var _loc3_:Class = getDefinitionByName(param1) as Class;
			var _loc4_:Sprite = new _loc3_(param2);
			this.m_allChildren[param2.uniqueId] = _loc4_;
			if (!param2.mouse)
			{
			}
			var _loc5_:MenuElementBase;
			if ((_loc5_ = _loc4_ as MenuElementBase) != null)
			{
				_loc5_.onSetData(param2);
			}
			return _loc4_;
		}
		
		public function createEmptyElement(param1:Number):Sprite
		{
			var _loc2_:Object = new Object();
			_loc2_.width = 220;
			_loc2_.height = param1;
			var _loc3_:Sprite = this.createElement("hud.EmptySpace", _loc2_);
			_loc3_.alpha = 0;
			return _loc3_;
		}
		
		public function handleSelectionChanged(param1:MenuElementTileBase):void
		{
			var _loc2_:InventoryItemIcon = null;
			var _loc3_:Number = NaN;
			var _loc4_:ListContainer = null;
			var _loc5_:* = null;
			var _loc6_:Number = NaN;
			if (this.previousSelectedItem)
			{
				this.previousSelectedItem.setItemSelected(false);
			}
			this.previousSelectedItem = param1;
			if (param1)
			{
				trace("new selection: " + param1);
				param1.setItemSelected(true);
				_loc2_ = param1 as InventoryItemIcon;
				if (_loc2_ != null)
				{
					_loc5_ = _loc2_.m_itemName;
					if (_loc2_.m_itemCount > 1)
					{
						_loc5_ = _loc5_ + " (" + _loc2_.m_itemCount + ")";
					}
					MenuUtils.setupText(this.m_itemName, _loc5_, 24, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorGreyUltraLight);
				}
				_loc3_ = MenuConstants.ScrollTime;
				if (_loc4_ = param1.m_parent as ListContainer)
				{
					_loc6_ = this.m_scrollFocusYPos - param1.y;
					if (_loc3_ == 0)
					{
						_loc4_.y = _loc6_;
					}
					else
					{
						Animate.legacyTo(_loc4_.getContainer(), _loc3_, {"y": _loc6_}, Animate.ExpoOut);
					}
				}
			}
			this.m_selectedItem = param1;
		}
		
		private function addMouseEventListeners(param1:Sprite):void
		{
			var elementBase:MenuElementBase = null;
			var elementSprite:Sprite = param1;
			elementBase = elementSprite as MenuElementBase;
			if (elementBase)
			{
				elementBase.addEventListener(MouseEvent.MOUSE_UP, function(param1:MouseEvent):void
				{
					elementBase.handleMouseUp(sendEventWithValue, param1);
				}, false, 0, false);
				elementBase.addEventListener(MouseEvent.MOUSE_DOWN, function(param1:MouseEvent):void
				{
					elementBase.handleMouseDown(sendEventWithValue, param1);
				}, false, 0, false);
				elementBase.addEventListener(MouseEvent.MOUSE_OVER, function(param1:MouseEvent):void
				{
					elementBase.handleMouseOver(sendEventWithValue, param1);
				}, false, 0, false);
				elementBase.addEventListener(MouseEvent.MOUSE_OUT, function(param1:MouseEvent):void
				{
					elementBase.handleMouseOut(sendEventWithValue, param1);
				}, false, 0, false);
				elementBase.addEventListener(MouseEvent.MOUSE_MOVE, function(param1:MouseEvent):void
				{
					elementBase.handleMouseMove(sendEventWithValue, param1);
				}, false, 0, false);
				elementBase.addEventListener(MouseEvent.MOUSE_WHEEL, function(param1:MouseEvent):void
				{
					elementBase.handleMouseWheel(sendEventWithValue, param1);
				}, false, 0, false);
				elementBase.addEventListener(MouseEvent.ROLL_OVER, function(param1:MouseEvent):void
				{
					elementBase.handleMouseRollOver(sendEventWithValue, param1);
				}, false, 0, false);
				elementBase.addEventListener(MouseEvent.ROLL_OUT, function(param1:MouseEvent):void
				{
					elementBase.handleMouseRollOut(sendEventWithValue, param1);
				}, false, 0, false);
				elementBase.setEngineCallbacks(sendEvent, sendEventWithValue);
			}
		}
		
		override public function onSetSize(sizeX:Number, sizeY:Number):void
		{
			Log.xinfo(Log.ChannelDebug, "InventoryPage | onSetSize sizeX=" + sizeX + " sizeY=" + sizeY);
			this.m_screenWidth = sizeX;
			this.m_screenHeight = sizeY;
			MenuUtils.centerFillAspect(this.m_container, MenuConstants.BaseWidth, MenuConstants.BaseHeight, sizeX, sizeY);
			MenuUtils.centerFill(this.m_background, MenuConstants.BaseWidth, MenuConstants.BaseHeight, sizeX, sizeY);
		}
		
		private function createSlotContainer(param1:Number, param2:Number, param3:Number, param4:Number):ListContainer
		{
			var _loc5_:Object;
			(_loc5_ = new Object()).sizeY = 1;
			_loc5_.width = param1;
			_loc5_.height = param2;
			var _loc6_:ListContainer;
			(_loc6_ = new ListContainer(_loc5_)).x = param3;
			_loc6_.y = param4;
			return _loc6_;
		}
		
		override public function onSetViewport(scaleX:Number, scaleY:Number, param3:Number):void
		{
			Log.xinfo(Log.ChannelDebug, "InventoryPage | onSetViewport this.scaleX=" + scaleX + " scaleY=" + scaleY);
			this.m_safeAreaRatio = param3;
			this.m_view.scaleX = this.m_safeAreaRatio;
			this.m_view.scaleY = this.m_safeAreaRatio;
			this.m_view.x = MenuConstants.BaseWidth * (1 - this.m_safeAreaRatio) / 2;
			this.m_view.y = MenuConstants.BaseHeight * (1 - this.m_safeAreaRatio) / 2;
		}
		
		override public function onSetVisible(param1:Boolean):void
		{
			super.onSetVisible(param1);
			this.visible = param1;
		}
		
		private function getDebugData():Object
		{
			var _loc1_:Object = new Object();
			var _loc2_:Object = new Object();
			var _loc3_:Object = new Object();
			_loc3_.label = "Pocket";
			var _loc4_:Object;
			(_loc4_ = new Object()).label = "Right Hand";
			var _loc5_:Object;
			(_loc5_ = new Object()).label = "Left Hand";
			var _loc6_:Object;
			(_loc6_ = new Object()).label = "Pistol Holster";
			var _loc7_:Object;
			(_loc7_ = new Object()).label = "crowbar";
			var _loc8_:Object;
			(_loc8_ = new Object()).label = "screwdriver";
			var _loc9_:Object;
			(_loc9_ = new Object()).label = "hammer";
			_loc9_.uniqueId = 2;
			var _loc10_:Object;
			(_loc10_ = new Object()).label = "pistol";
			_loc3_.items = new Array(_loc7_, _loc8_, _loc7_, _loc8_);
			_loc4_.items = new Array(_loc9_);
			_loc4_.uniqueId = 1;
			_loc5_.items = new Array();
			_loc6_.items = new Array(_loc10_);
			_loc2_.slots = new Array(_loc4_, _loc5_, _loc6_, _loc3_);
			_loc1_.playerInventory = _loc2_;
			_loc1_.worldInventory = _loc2_;
			return _loc1_;
		}
	}
}
