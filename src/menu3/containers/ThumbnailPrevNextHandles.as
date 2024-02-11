// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.containers.ThumbnailPrevNextHandles

package menu3.containers {
import menu3.basic.IConfigurableMenuResource;

import common.menu.MenuConstants;
import common.Animate;

import flash.display.MovieClip;

import common.menu.MenuUtils;

import flash.display.Sprite;

import menu3.basic.ThumbnailItemTile;

import flash.geom.Rectangle;
import flash.geom.Point;
import flash.events.MouseEvent;

public dynamic class ThumbnailPrevNextHandles implements IConfigurableMenuResource {

	private static var PreviousNextScopeOffset:int = 40;

	private var m_PreviousScope:ChallengePreviousScope;
	private var m_NextScope:ChallengeNextScope;
	private var m_pageHasPrevious:Boolean;
	private var m_pagePreviousIcon:String;
	private var m_pageHasNext:Boolean;
	private var m_pageNextIcon:String;
	private var m_thumbnailScrollingList:ThumbnailScrollingListContainer;

	public function ThumbnailPrevNextHandles(_arg_1:ThumbnailScrollingListContainer) {
		this.m_thumbnailScrollingList = _arg_1;
	}

	public static function arePrevNextCategoryHandlesNeeded(_arg_1:Object):Boolean {
		var _local_2:Boolean = ((_arg_1.hasOwnProperty("hasprevious")) && (_arg_1["hasprevious"] == true));
		var _local_3:Boolean = ((_arg_1.hasOwnProperty("hasnext")) && (_arg_1["hasnext"] == true));
		return ((_local_2) || (_local_3));
	}


	public function onSetData(_arg_1:Object):void {
		this.m_PreviousScope = new ChallengePreviousScope();
		this.m_PreviousScope.x = -40;
		this.m_thumbnailScrollingList.addChild(this.m_PreviousScope);
		this.m_NextScope = new ChallengeNextScope();
		this.m_NextScope.x = ((MenuConstants.GridUnitWidth * 2) + 40);
		this.m_thumbnailScrollingList.addChild(this.m_NextScope);
		this.m_pageHasPrevious = ((_arg_1.hasOwnProperty("hasprevious")) && (_arg_1["hasprevious"] == true));
		this.m_pagePreviousIcon = (((_arg_1.hasOwnProperty("previousicon")) && (_arg_1["previousicon"].toString().length > 0)) ? _arg_1["previousicon"] : "");
		this.m_pageHasNext = ((_arg_1.hasOwnProperty("hasnext")) && (_arg_1["hasnext"] == true));
		this.m_pageNextIcon = (((_arg_1.hasOwnProperty("nexticon")) && (_arg_1["nexticon"].toString().length > 0)) ? _arg_1["nexticon"] : "");
		if (((this.m_thumbnailScrollingList.hasValidContent()) || (!(this.m_thumbnailScrollingList.isEmptyContainerFeedbackTileActive())))) {
			this.m_PreviousScope.visible = false;
			this.m_NextScope.visible = false;
		} else {
			if (this.m_thumbnailScrollingList.isEmptyContainerFeedbackTileActive()) {
				this.setPrevNextIcon(this.m_PreviousScope, this.m_pagePreviousIcon);
				this.setPrevNextIcon(this.m_NextScope, this.m_pageNextIcon);
				this.m_PreviousScope.visible = this.m_pageHasPrevious;
				this.m_NextScope.visible = this.m_pageHasNext;
			}
			;
		}
		;
	}

	public function onUnregister():void {
		if (this.m_PreviousScope != null) {
			Animate.kill(this.m_PreviousScope);
			this.m_thumbnailScrollingList.removeChild(this.m_PreviousScope);
			this.m_PreviousScope = null;
		}
		;
		if (this.m_NextScope != null) {
			Animate.kill(this.m_NextScope);
			this.m_thumbnailScrollingList.removeChild(this.m_NextScope);
			this.m_NextScope = null;
		}
		;
	}

	private function setPrevNextIcon(_arg_1:Sprite, _arg_2:String):void {
		var _local_3:MovieClip = _arg_1["icon"];
		_local_3.visible = ((_arg_2) && (_arg_2.length > 0));
		if (_local_3.visible) {
			MenuUtils.setupIcon(_local_3, _arg_2, MenuConstants.COLOR_GREY_MEDIUM, false, true, MenuConstants.COLOR_GREY);
		}
		;
	}

	public function onSetFocusAfterChildren(_arg_1:Rectangle, _arg_2:Rectangle, _arg_3:Number):void {
		var _local_9:Number;
		var _local_10:Number;
		var _local_4:Boolean = ((this.m_thumbnailScrollingList.m_children.length > 0) && (this.m_thumbnailScrollingList.m_children[0] is ThumbnailItemTile));
		var _local_5:Number = this.m_thumbnailScrollingList.getContainer().x;
		var _local_6:Boolean = (((this.m_pageHasPrevious) && (_local_4)) && (this.m_thumbnailScrollingList.focusedElementIndex == 0));
		if (((_local_6) && (!(this.m_PreviousScope.visible)))) {
			this.setPrevNextIcon(this.m_PreviousScope, this.m_pagePreviousIcon);
			this.m_PreviousScope.x = (_local_5 - PreviousNextScopeOffset);
		}
		;
		this.m_PreviousScope.visible = _local_6;
		if (this.m_PreviousScope.visible) {
			_local_9 = ((_local_5 - PreviousNextScopeOffset) - _arg_1.x);
			Animate.kill(this.m_PreviousScope);
			Animate.legacyTo(this.m_PreviousScope, _arg_3, {"x": _local_9}, Animate.ExpoOut);
		}
		;
		var _local_7:int = 10;
		var _local_8:Boolean = (((this.m_pageHasNext) && (_local_4)) && (this.m_thumbnailScrollingList.focusedElementIndex > (this.m_thumbnailScrollingList.m_children.length - _local_7)));
		if (((_local_8) && (!(this.m_NextScope.visible)))) {
			this.setPrevNextIcon(this.m_NextScope, this.m_pageNextIcon);
			this.m_NextScope.x = (((_local_5 + _arg_2.width) + MenuConstants.GridUnitWidth) + PreviousNextScopeOffset);
		}
		;
		this.m_NextScope.visible = _local_8;
		if (this.m_NextScope.visible) {
			_local_10 = ((((_local_5 + _arg_2.width) + MenuConstants.GridUnitWidth) + PreviousNextScopeOffset) - _arg_1.x);
			Animate.kill(this.m_NextScope);
			Animate.legacyTo(this.m_NextScope, _arg_3, {"x": _local_10}, Animate.ExpoOut);
		}
		;
	}

	public function handleMouseUp(_arg_1:Function, _arg_2:MouseEvent):Boolean {
		var _local_5:Rectangle;
		var _local_3:Point = new Point(_arg_2.stageX, _arg_2.stageY);
		var _local_4:Point = this.m_thumbnailScrollingList.globalToLocal(_local_3);
		if (this.m_PreviousScope.visible) {
			_local_5 = this.m_PreviousScope.getBounds(this.m_thumbnailScrollingList);
			if (_local_5.containsPoint(_local_4)) {
				_arg_2.stopImmediatePropagation();
				if (this.m_thumbnailScrollingList.hasValidContent()) {
					this.m_thumbnailScrollingList.selectChildWithMouseEvent(0);
				}
				;
				this.sendEventWithId(_arg_1, "onElementPrev");
				return (true);
			}
			;
		}
		;
		if (this.m_NextScope.visible) {
			_local_5 = this.m_NextScope.getBounds(this.m_thumbnailScrollingList);
			if (_local_5.containsPoint(_local_4)) {
				_arg_2.stopImmediatePropagation();
				if (this.m_thumbnailScrollingList.hasValidContent()) {
					this.m_thumbnailScrollingList.selectChildWithMouseEvent((this.m_thumbnailScrollingList.m_children.length - 1));
				}
				;
				this.sendEventWithId(_arg_1, "onElementNext");
				return (true);
			}
			;
		}
		;
		return (false);
	}

	private function sendEventWithId(_arg_1:Function, _arg_2:String):void {
		var _local_3:int;
		if (this.m_thumbnailScrollingList["_nodedata"]) {
			_local_3 = (this.m_thumbnailScrollingList["_nodedata"]["id"] as int);
			(_arg_1(_arg_2, _local_3));
		}
		;
	}


}
}//package menu3.containers

