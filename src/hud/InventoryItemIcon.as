// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.InventoryItemIcon

package hud {
import menu3.MenuElementTileBase;

import flash.display.Sprite;

import menu3.MenuImageLoader;

import flash.text.TextField;

import common.MouseUtil;
import common.menu.MenuUtils;
import common.Log;
import common.Animate;
import common.menu.MenuConstants;

import fl.motion.Color;

public dynamic class InventoryItemIcon extends MenuElementTileBase {

	public static const ITEM_SIZE_WIDTH:int = 140;
	public static const ITEM_SIZE_HEIGHT:int = 80;
	private static const ITEM_STATE_NORMAL:int = 0;
	private static const ITEM_STATE_SELECTED:int = 1;
	private static const ITEM_STATE_HIGHLIGHTED:int = 2;
	private static const ITEM_STATE_HIGHLIGHTED_SELECTED:int = 3;

	private const WIGGLE_ROTATION:int = 1;

	private var m_rot:Number = 1;
	protected var m_view:InventoryItemIconMC;
	protected var m_rotationBase:Sprite;
	private var m_loader:MenuImageLoader;
	private var m_textObj:Object = new Object();
	private var m_pressable:Boolean = true;
	private var m_isHighlighted:Boolean = false;
	public var m_itemName:String = "";
	public var m_itemCount:int = 0;
	public var m_uniqueId:int;
	private var m_infoIndicatorWithTitle:InfoIndicatorWithTitleSmallView;
	private var m_saveSlotHeaderIndicator:SaveSlotHeaderIndicatorView;
	private var m_itemNaxe_txt:TextField;
	private var m_iconRid:String = "";

	public function InventoryItemIcon(_arg_1:Object) {
		super(_arg_1);
		m_mouseMode = MouseUtil.MODE_DISABLE;
		this.m_view = new InventoryItemIconMC();
		this.m_view.tileSelect.alpha = 0;
		this.m_view.tileSelectPulsate.alpha = 0;
		this.m_view.tileBg.alpha = 0;
		this.m_view.tileDarkBg.alpha = 0.3;
		MenuUtils.setTintColor(this.m_view.tileDarkBg, MenuUtils.TINT_COLOR_RED);
		this.m_rotationBase = new Sprite();
		this.m_rotationBase.x = (this.m_view.x + (this.m_view.width * 0.5));
		this.m_rotationBase.y = (this.m_view.y + (this.m_view.height * 0.5));
		this.m_view.x = (this.m_view.x - (this.m_view.width * 0.5));
		this.m_view.y = (this.m_view.y - (this.m_view.height * 0.5));
		this.m_rotationBase.addChild(this.m_view);
		addChild(this.m_rotationBase);
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		Log.debugData(this, _arg_1);
		var _local_2:String = this.m_itemName;
		this.m_itemName = _arg_1.label;
		this.m_itemCount = _arg_1.count;
		this.m_uniqueId = _arg_1.uniqueId;
		var _local_3:* = "";
		if (((!(this.m_itemName == null)) && (this.m_itemName.length > 0))) {
			_local_3 = _arg_1.icon;
		}
		;
		if (this.m_iconRid != _local_3) {
			this.m_iconRid = _local_3;
			this.destroyImageLoader();
			if (((!(_local_3 == null)) && (_local_3.length > 0))) {
				this.m_loader = new MenuImageLoader();
				this.m_loader.x = (ITEM_SIZE_WIDTH * 0.5);
				this.m_loader.y = (ITEM_SIZE_HEIGHT * 0.5);
				this.m_view.addChild(this.m_loader);
				this.loadIconImage(this.m_loader, _local_3);
			}
			;
		}
		;
		this.updateStates();
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

	private function setState(_arg_1:int):void {
		this.animateWiggleStop();
		Animate.complete(this.m_view.tileSelect);
		if (_arg_1 == ITEM_STATE_HIGHLIGHTED_SELECTED) {
			this.animateWiggle();
			Animate.to(this.m_view.tileSelect, MenuConstants.HiliteTime, 0, {"alpha": 1}, Animate.Linear);
			MenuUtils.pulsate(this.m_view.tileSelectPulsate, true);
		} else {
			if (_arg_1 == ITEM_STATE_HIGHLIGHTED) {
				this.animateWiggle();
				MenuUtils.pulsate(this.m_view.tileSelectPulsate, false);
				this.m_view.tileSelectPulsate.alpha = 0.5;
				this.m_view.tileSelect.alpha = 1;
			} else {
				if (_arg_1 == ITEM_STATE_SELECTED) {
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
		max_width = (ITEM_SIZE_WIDTH - BORDER);
		max_height = (ITEM_SIZE_HEIGHT - BORDER);
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
}//package hud

