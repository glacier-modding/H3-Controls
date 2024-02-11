// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.ThumbnailSelectedltemTile

package menu3.basic {
import flash.display.Sprite;

import menu3.containers.ThumbnailScrollingListContainer;

import flash.events.MouseEvent;

import common.menu.MenuUtils;

import flash.display.BitmapData;

public dynamic class ThumbnailSelectedltemTile extends Sprite implements IConfigurableMenuResource {

	private static const SelectedItemOffsetY:Number = 22;

	private var m_view:ThumbnailSelectedItemTileView;
	private var m_tileState:IItemTileState;
	private var m_thumbnailScrollingList:ThumbnailScrollingListContainer;

	public function ThumbnailSelectedltemTile(_arg_1:ThumbnailScrollingListContainer) {
		this.m_thumbnailScrollingList = _arg_1;
		this.m_view = new ThumbnailSelectedItemTileView();
		this.m_tileState = new ThumbnailItemTileState(this.m_view);
		this.m_view.x = 0;
		this.m_view.y = SelectedItemOffsetY;
		addChild(this.m_view);
		this.m_view.addEventListener(MouseEvent.ROLL_OVER, this.handleMouseRollOverSelection, false, 0, false);
	}

	public function onSetData(_arg_1:Object):void {
		this.m_tileState.onSetData(_arg_1);
	}

	public function onUnregister():void {
		if (this.m_view == null) {
			return;
		}
		;
		this.unloadImage();
		this.m_view.removeEventListener(MouseEvent.ROLL_OVER, this.handleMouseRollOverSelection, false);
		this.m_thumbnailScrollingList = null;
		this.m_tileState.destroy();
		this.m_tileState = null;
		removeChild(this.m_view);
		this.m_view = null;
	}

	public function onItemSelectionChanged(_arg_1:Object, _arg_2:BitmapData):void {
		this.onSetData(_arg_1);
		this.m_tileState.setImageFrom(_arg_2);
		MenuUtils.setColorFilter(this.m_view.image);
		this.m_tileState.setTileSelect();
	}

	public function setImageFrom(_arg_1:BitmapData):void {
		this.m_tileState.setImageFrom(_arg_1);
		MenuUtils.setColorFilter(this.m_view.image);
	}

	public function unloadImage():void {
		this.m_tileState.unloadImage();
	}

	public function onItemUnselected():void {
		this.m_tileState.hideTileSelect();
	}

	private function handleMouseRollOverSelection(_arg_1:MouseEvent):void {
		this.m_thumbnailScrollingList.onSelectedItemRollOver();
	}


}
}//package menu3.basic

