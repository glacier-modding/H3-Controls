// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.containers.SimpleButtonTileScrollingListContainer

package menu3.containers {
import flash.display.Sprite;

import common.menu.MenuConstants;

import menu3.basic.SimpleButtonTile;

import flash.geom.Rectangle;
import flash.events.Event;

import menu3.ScreenResizeEvent;

import common.menu.MenuUtils;

public dynamic class SimpleButtonTileScrollingListContainer extends ScrollingListContainer {

	private var m_background:Sprite;
	private var m_screenWidth:Number;
	private var m_screenHeight:Number;
	private var m_safeAreaRatio:Number;
	private var m_originalBarPosX:Number = ((MenuConstants.MenuWidth - MenuConstants.BaseWidth) * 0.5);
	private var m_yPos:Number;
	private var m_tileFound:Boolean;

	public function SimpleButtonTileScrollingListContainer(_arg_1:Object) {
		super(_arg_1);
		this.m_screenWidth = ((isNaN(_arg_1.sizeX)) ? MenuConstants.BaseWidth : _arg_1.sizeX);
		this.m_screenHeight = ((isNaN(_arg_1.sizeY)) ? MenuConstants.BaseHeight : _arg_1.sizeY);
		this.m_safeAreaRatio = ((isNaN(_arg_1.safeAreaRatio)) ? 1 : _arg_1.safeAreaRatio);
		this.m_background = new Sprite();
		this.m_background.visible = false;
		this.createBackgroundGraphics();
		addChildAt(this.m_background, 0);
		this.m_background.x = this.m_originalBarPosX;
	}

	override public function onUnregister():void {
		if (this.m_background) {
			removeChild(this.m_background);
			this.m_background = null;
		}
		;
		super.onUnregister();
	}

	override public function repositionChild(_arg_1:Sprite):void {
		var _local_2:SimpleButtonTile;
		var _local_3:Rectangle;
		super.repositionChild(_arg_1);
		if (!this.m_tileFound) {
			_local_2 = this.GetFirstSimpleButtonTile(this);
			if (_local_2 != null) {
				_local_3 = _local_2.getView().getRect(this);
				this.m_yPos = _local_3.y;
				this.m_background.y = (this.m_yPos + 1);
				this.m_background.visible = true;
				this.m_tileFound = true;
			}
			;
		}
		;
	}

	private function GetFirstSimpleButtonTile(_arg_1:BaseContainer):SimpleButtonTile {
		var _local_3:SimpleButtonTile;
		var _local_4:BaseContainer;
		var _local_2:int;
		while (_local_2 < _arg_1.m_children.length) {
			_local_3 = null;
			_local_4 = (_arg_1.m_children[_local_2] as BaseContainer);
			if (_local_4 != null) {
				_local_3 = this.GetFirstSimpleButtonTile(_local_4);
			} else {
				_local_3 = (_arg_1.m_children[_local_2] as SimpleButtonTile);
			}
			;
			if (_local_3 != null) {
				return (_local_3);
			}
			;
			_local_2++;
		}
		;
		return (null);
	}

	private function createBackgroundGraphics():void {
		this.m_background.graphics.clear();
		this.m_background.graphics.beginFill(MenuConstants.COLOR_MENU_TABS_BACKGROUND, MenuConstants.MenuElementBackgroundAlpha);
		this.m_background.graphics.drawRect(0, 0, MenuConstants.BaseWidth, MenuConstants.SimpleButtonTileScrollingListContainerHeight);
		this.m_background.graphics.endFill();
	}

	override protected function onAddedToStage(_arg_1:Event):void {
		super.onAddedToStage(_arg_1);
		this.scaleBackground();
	}

	override protected function onScreenResize(_arg_1:ScreenResizeEvent):void {
		super.onScreenResize(_arg_1);
		var _local_2:Object = _arg_1.screenSize;
		this.m_screenWidth = _local_2.sizeX;
		this.m_screenHeight = _local_2.sizeY;
		this.m_safeAreaRatio = _local_2.safeAreaRatio;
		this.scaleBackground();
	}

	private function scaleBackground():void {
		var _local_3:Number;
		var _local_4:Number;
		var _local_1:Number = MenuConstants.BaseWidth;
		var _local_2:Number = 0;
		if (ControlsMain.isVrModeActive()) {
			_local_1 = (MenuConstants.MenuWidth + (MenuConstants.ScrollingList_VR_ExtendWidth * 2));
			_local_2 = (MenuConstants.ScrollingList_VR_ExtendWidth * -1);
		} else {
			_local_3 = (MenuUtils.getFillAspectScale(MenuConstants.BaseWidth, MenuConstants.BaseHeight, this.m_screenWidth, this.m_screenHeight) * this.m_safeAreaRatio);
			_local_4 = (this.m_screenWidth / _local_3);
			_local_1 = _local_4;
			_local_2 = (this.m_originalBarPosX + ((MenuConstants.BaseWidth - _local_1) / 2));
		}
		;
		this.m_background.width = _local_1;
		this.m_background.x = _local_2;
	}


}
}//package menu3.containers

