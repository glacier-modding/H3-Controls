// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.InventoryItemTile

package menu3.basic {
import menu3.MenuElementTileBase;

import flash.display.Sprite;

import menu3.MenuImageLoader;

import flash.text.TextField;

import common.Log;
import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.MouseUtil;
import common.Animate;

import fl.motion.Color;

public dynamic class InventoryItemTile extends MenuElementTileBase {

	public static const ITEM_SIZE_WIDTH:int = 140;
	public static const ITEM_SIZE_HEIGHT:int = 80;
	public static const ITEM_SIZE_SMALL_WIDTH:int = 98;
	public static const ITEM_SIZE_SMALL_HEIGHT:int = 56;
	private static const ITEM_STATE_NORMAL:int = 0;
	private static const ITEM_STATE_SELECTED:int = 1;
	private static const ITEM_STATE_NOT_PRESSABLE:int = 2;
	private static const ITEM_STATE_NOT_PRESSABLE_SELECTED:int = 3;
	private static const ITEM_STATE_HIGHLIGHTED:int = 4;
	private static const ITEM_STATE_HIGHLIGHTED_SELECTED:int = 5;

	private const WIGGLE_ROTATION:int = 1;

	private var m_rot:Number = 1;
	protected var m_isSmallView:Boolean = false;
	protected var m_view:*;
	protected var m_rotationBase:Sprite;
	private var m_loader:MenuImageLoader;
	private var m_textObj:Object = new Object();
	private var m_pressable:Boolean = true;
	private var m_isHighlighted:Boolean = false;
	private var m_isPressable:Boolean = true;
	public var m_itemName:String = "";
	public var m_itemCount:int = 0;
	public var m_uniqueId:int;
	private var m_infoIndicatorWithTitle:InfoIndicatorWithTitleSmallView;
	private var m_saveSlotHeaderIndicator:SaveSlotHeaderIndicatorView;
	private var m_itemNaxe_txt:TextField;
	private var m_iconRid:String = "";
	private var m_details:InventoryItemDetail = null;
	private var m_rarityIndicator:Sprite = null;

	public function InventoryItemTile(_arg_1:Object) {
		super(_arg_1);
		this.m_isSmallView = (_arg_1.small === true);
		if (this.m_isSmallView) {
			this.m_view = new InventorySmallItemTileView();
		} else {
			this.m_view = new InventoryItemTileView();
		}
		;
		this.m_view.tileSelect.alpha = 0;
		this.m_view.tileSelectPulsate.alpha = 0;
		this.m_view.tileBg.alpha = 0;
		this.m_view.tileBorder.alpha = 0;
		this.m_rotationBase = new Sprite();
		this.m_rotationBase.x = (this.m_view.x + (this.m_view.width * 0.5));
		this.m_rotationBase.y = (this.m_view.y + (this.m_view.height * 0.5));
		this.m_view.x = (this.m_view.x - (this.m_view.width * 0.5));
		this.m_view.y = (this.m_view.y - (this.m_view.height * 0.5));
		this.m_rotationBase.addChild(this.m_view);
		addChild(this.m_rotationBase);
		this.m_details = new InventoryItemDetail();
		this.m_details.x = (ITEM_SIZE_WIDTH + 30);
		addChild(this.m_details);
		this.m_rarityIndicator = new Sprite();
		this.m_view.addChild(this.m_rarityIndicator);
	}

	override public function onSetData(_arg_1:Object):void {
		var _local_5:int;
		super.onSetData(_arg_1);
		Log.debugData(this, _arg_1);
		var _local_2:String = this.m_itemName;
		this.m_itemName = _arg_1.label;
		this.m_itemCount = _arg_1.count;
		this.m_uniqueId = _arg_1.uniqueId;
		var _local_3:* = "";
		if (_arg_1.count != undefined) {
			_local_5 = _arg_1.count;
			if (_local_5 > 1) {
				_local_3 = ("x" + _local_5.toString());
			}
			;
		}
		;
		MenuUtils.setupText(this.m_view.countLabel, _local_3, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
		this.m_isPressable = true;
		if (getNodeProp(this, "pressable") == false) {
			this.m_isPressable = false;
		}
		;
		if (getNodeProp(this, "selectable") == false) {
			m_mouseMode = MouseUtil.MODE_ONOVER_HOVER_ONUP_SELECT;
		} else {
			m_mouseMode = MouseUtil.MODE_ONOVER_SELECT_ONUP_CLICK;
		}
		;
		if (_arg_1.highlighted != undefined) {
			this.m_isHighlighted = _arg_1.highlighted;
		}
		;
		var _local_4:* = "";
		if (((!(this.m_itemName == null)) && (this.m_itemName.length > 0))) {
			_local_4 = _arg_1.icon;
		}
		;
		if (this.m_iconRid != _local_4) {
			this.m_iconRid = _local_4;
			this.destroyImageLoader();
			if (((!(_local_4 == null)) && (_local_4.length > 0))) {
				this.m_loader = new MenuImageLoader();
				if (this.m_isSmallView) {
					this.m_loader.x = (ITEM_SIZE_WIDTH - (ITEM_SIZE_SMALL_WIDTH * 0.5));
					this.m_loader.y = (ITEM_SIZE_SMALL_HEIGHT * 0.5);
				} else {
					this.m_loader.x = (ITEM_SIZE_WIDTH * 0.5);
					this.m_loader.y = (ITEM_SIZE_HEIGHT * 0.5);
				}
				;
				this.m_view.addChild(this.m_loader);
				this.loadIconImage(this.m_loader, _local_4);
			}
			;
		}
		;
		if (_arg_1.enableColor === false) {
			MenuUtils.setTintColor(this.m_view.tileDarkBg, MenuUtils.TINT_COLOR_GREY);
			MenuUtils.setTintColor(this.m_view.tileBorder, MenuUtils.TINT_COLOR_GREY);
		} else {
			MenuUtils.setTintColor(this.m_view.tileDarkBg, MenuUtils.TINT_COLOR_RED);
			MenuUtils.setTintColor(this.m_view.tileBorder, MenuUtils.TINT_COLOR_RED);
		}
		;
		this.m_details.onSetData(_arg_1);
		this.m_details.visible = false;
		this.updateRarity(_arg_1.rarity);
		this.updateStates();
	}

	private function updateRarity(_arg_1:String):void {
		this.m_rarityIndicator.graphics.clear();
		if (((_arg_1 == null) || (_arg_1.length == 0))) {
			return;
		}
		;
		var _local_2:uint = 14409180;
		if (_arg_1 == "ITEMRARITY_UNCOMMON") {
			_local_2 = 6222732;
		} else {
			if (_arg_1 == "ITEMRARITY_RARE") {
				_local_2 = 7845610;
			}
			;
		}
		;
		var _local_3:Number = 24;
		var _local_4:Number = ((this.m_isSmallView) ? (ITEM_SIZE_WIDTH + 3) : (ITEM_SIZE_WIDTH - 2));
		var _local_5:Number = (_local_4 - _local_3);
		var _local_6:Number = ((this.m_isSmallView) ? (ITEM_SIZE_SMALL_HEIGHT - 2) : (ITEM_SIZE_HEIGHT - 2));
		var _local_7:Number = (_local_6 - _local_3);
		this.m_rarityIndicator.graphics.beginFill(_local_2, 1);
		this.m_rarityIndicator.graphics.moveTo(_local_4, _local_6);
		this.m_rarityIndicator.graphics.lineTo(_local_5, _local_6);
		this.m_rarityIndicator.graphics.lineTo(_local_4, _local_7);
		this.m_rarityIndicator.graphics.lineTo(_local_4, _local_6);
		this.m_rarityIndicator.graphics.endFill();
	}

	override public function getView():Sprite {
		return (this.m_view.tileBg);
	}

	override protected function handleSelectionChange():void {
		super.handleSelectionChange();
		if (m_loading) {
			return;
		}
		;
		this.updateStates();
	}

	public function onSetHighlighted(_arg_1:Boolean):void {
		if (_arg_1 == this.m_isHighlighted) {
			return;
		}
		;
		this.m_isHighlighted = _arg_1;
		this.updateStates();
	}

	private function updateStates():void {
		if (!this.m_isPressable) {
			if (m_isSelected) {
				this.setState(ITEM_STATE_NOT_PRESSABLE_SELECTED);
			} else {
				this.setState(ITEM_STATE_NOT_PRESSABLE);
			}
			;
		} else {
			if (this.m_isHighlighted) {
				if (m_isSelected) {
					this.setState(ITEM_STATE_HIGHLIGHTED_SELECTED);
				} else {
					this.setState(ITEM_STATE_HIGHLIGHTED);
				}
				;
			} else {
				if (m_isSelected) {
					this.setState(ITEM_STATE_SELECTED);
				} else {
					this.setState(ITEM_STATE_NORMAL);
				}
				;
			}
			;
		}
		;
	}

	private function setState(_arg_1:int):void {
		this.animateWiggleStop();
		Animate.complete(this.m_view.tileSelect);
		this.m_view.tileBorder.alpha = 0;
		this.m_view.tileDarkBg.alpha = 1;
		this.m_details.visible = false;
		if (_arg_1 == ITEM_STATE_HIGHLIGHTED_SELECTED) {
			this.animateWiggle();
			this.m_details.visible = true;
			Animate.to(this.m_view.tileSelect, MenuConstants.HiliteTime, 0, {"alpha": 1}, Animate.Linear);
			MenuUtils.pulsate(this.m_view.tileSelectPulsate, true);
		} else {
			if (_arg_1 == ITEM_STATE_HIGHLIGHTED) {
				this.animateWiggle();
				MenuUtils.pulsate(this.m_view.tileSelectPulsate, false);
				this.m_view.tileSelectPulsate.alpha = 0.5;
				this.m_view.tileSelect.alpha = 1;
			} else {
				if (_arg_1 == ITEM_STATE_NOT_PRESSABLE_SELECTED) {
					Animate.to(this.m_view.tileSelect, MenuConstants.HiliteTime, 0, {"alpha": 1}, Animate.Linear);
					MenuUtils.pulsate(this.m_view.tileSelectPulsate, true);
					this.m_view.tileDarkBg.alpha = 0.3;
				} else {
					if (_arg_1 == ITEM_STATE_NOT_PRESSABLE) {
						this.m_view.tileSelect.alpha = 0;
						MenuUtils.pulsate(this.m_view.tileSelectPulsate, false);
						this.m_view.tileBorder.alpha = 1;
						this.m_view.tileDarkBg.alpha = 0.3;
					} else {
						if (_arg_1 == ITEM_STATE_SELECTED) {
							this.m_details.visible = true;
							Animate.to(this.m_view.tileSelect, MenuConstants.HiliteTime, 0, {"alpha": 1}, Animate.Linear);
							MenuUtils.pulsate(this.m_view.tileSelectPulsate, true);
						} else {
							this.m_view.tileSelect.alpha = 0;
							MenuUtils.pulsate(this.m_view.tileSelectPulsate, false);
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
	}

	private function animateWiggle():void {
		Animate.to(this.m_rotationBase, 0.15, 0, {"rotation": this.m_rot}, Animate.SineInOut, this.animateWiggle);
		this.m_rot = (this.m_rot * -1);
	}

	private function animateWiggleStop():void {
		Animate.kill(this.m_rotationBase);
		this.m_rotationBase.rotation = 0;
		this.m_rot = this.WIGGLE_ROTATION;
	}

	override public function onUnregister():void {
		if (this.m_view) {
			this.completeAnimations();
			this.destroyImageLoader();
			removeChild(this.m_view);
			this.m_view = null;
		}
		;
		if (this.m_details) {
			this.m_details.onUnregister();
			removeChild(this.m_details);
		}
		;
		super.onUnregister();
	}

	private function destroyImageLoader():void {
		if (this.m_loader != null) {
			this.m_loader.cancelIfLoading();
			this.m_view.removeChild(this.m_loader);
			this.m_loader = null;
		}
		;
	}

	private function completeAnimations():void {
		this.animateWiggleStop();
		Animate.complete(this.m_view.tileSelect);
		MenuUtils.pulsate(this.m_view.tileSelectPulsate, false);
	}

	private function loadIconImage(imageLoader:MenuImageLoader, rid:String):void {
		var max_width:Number;
		var max_height:Number;
		Log.info(Log.ChannelDebug, this, ("loadIconImage: " + rid));
		var/*const*/ BORDER:int = 20;
		if (this.m_isSmallView) {
			max_width = (ITEM_SIZE_SMALL_WIDTH - BORDER);
			max_height = (ITEM_SIZE_SMALL_HEIGHT - BORDER);
		} else {
			max_width = (ITEM_SIZE_WIDTH - BORDER);
			max_height = (ITEM_SIZE_HEIGHT - BORDER);
		}
		;
		imageLoader.rotation = 0;
		imageLoader.scaleX = (imageLoader.scaleY = 1);
		imageLoader.loadImage(rid, function ():void {
			var _local_1:Color = new Color();
			var _local_2:Boolean;
			if ((imageLoader.width * 1.05) < imageLoader.height) {
				imageLoader.rotation = 90;
				_local_2 = true;
			}
			;
			imageLoader.width = max_width;
			imageLoader.scaleY = imageLoader.scaleX;
			if (imageLoader.height > max_height) {
				imageLoader.height = max_height;
				imageLoader.scaleX = imageLoader.scaleY;
			}
			;
			_local_1.setTint(0xFFFFFF, 1);
			imageLoader.transform.colorTransform = _local_1;
			imageLoader.alpha = 1;
		});
	}


}
}//package menu3.basic

