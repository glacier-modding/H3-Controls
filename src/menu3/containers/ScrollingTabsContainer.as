// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.containers.ScrollingTabsContainer

package menu3.containers {
import basic.IButtonPromptOwner;

import common.menu.MenuConstants;

import flash.geom.Rectangle;
import flash.display.Sprite;

import menu3.basic.TopNavigationHandler;

import flash.events.Event;

import menu3.basic.ICategoryElement;

import common.menu.MenuUtils;
import common.Animate;

import menu3.MenuElementBase;

import basic.ButtonPromtUtil;

import menu3.ScreenResizeEvent;

public dynamic class ScrollingTabsContainer extends ListContainer implements IButtonPromptOwner {

	private const SUB_MENU_START_Y:Number = (MenuConstants.TabsBgOffsetYPos + 76);
	private const SUB_MENU_HEIGHT:Number = 38;

	private var m_scrollBounds:Rectangle;
	private var m_mask:MaskView;
	private var m_tabBackground:Sprite;
	private var m_scrollMaxBounds:Rectangle;
	private var m_overflowScrollingFactor:Number = 0;
	private var m_topNavigation:TopNavigationHandler = null;
	private var m_isSubMenu:Boolean = false;
	private var m_screenWidth:Number;
	private var m_screenHeight:Number;
	private var m_safeAreaRatio:Number;
	private var m_originalBarPosX:Number = ((MenuConstants.MenuWidth - MenuConstants.BaseWidth) * 0.5);
	private var m_showLine:Boolean = false;
	private var m_previousVisibilityConfig:Object = null;

	public function ScrollingTabsContainer(_arg_1:Object) {
		var _local_6:Number;
		var _local_7:Number;
		var _local_8:Number;
		var _local_9:Number;
		var _local_10:Number;
		super(_arg_1);
		this.m_screenWidth = ((isNaN(_arg_1.sizeX)) ? MenuConstants.BaseWidth : _arg_1.sizeX);
		this.m_screenHeight = ((isNaN(_arg_1.sizeY)) ? MenuConstants.BaseHeight : _arg_1.sizeY);
		this.m_safeAreaRatio = ((isNaN(_arg_1.safeAreaRatio)) ? 1 : _arg_1.safeAreaRatio);
		this.m_isSubMenu = (_arg_1.submenu === true);
		var _local_2:Number = ((_arg_1.width) || (MenuConstants.BaseWidth));
		var _local_3:Number = ((_arg_1.height) || (MenuConstants.BaseHeight));
		this.m_scrollBounds = new Rectangle(0, 0, _local_2, _local_3);
		if (_arg_1.overflowscrolling) {
			this.m_overflowScrollingFactor = _arg_1.overflowscrolling;
		}
		;
		if (!this.m_isSubMenu) {
			this.m_previousVisibilityConfig = null;
			this.m_topNavigation = new TopNavigationHandler();
			this.m_topNavigation.onSetData(_arg_1.topnavigation);
		}
		;
		if (!this.m_isSubMenu) {
			this.updateButtonPrompts();
		}
		;
		var _local_4:Number = ((this.m_isSubMenu) ? this.SUB_MENU_START_Y : MenuConstants.TabsBgOffsetYPos);
		var _local_5:Number = ((this.m_isSubMenu) ? this.SUB_MENU_HEIGHT : (MenuConstants.TabsLineLowerYPos - MenuConstants.TabsLineMidYPos));
		this.m_tabBackground = new Sprite();
		this.m_tabBackground.graphics.clear();
		this.m_tabBackground.graphics.beginFill(MenuConstants.COLOR_MENU_TABS_BACKGROUND, MenuConstants.MenuElementBackgroundAlpha);
		this.m_tabBackground.graphics.drawRect(0, _local_4, MenuConstants.BaseWidth, _local_5);
		this.m_tabBackground.graphics.endFill();
		this.m_tabBackground.alpha = 0;
		addChildAt(this.m_tabBackground, 0);
		this.m_tabBackground.x = this.m_originalBarPosX;
		if (ControlsMain.isVrModeActive()) {
			_local_6 = MenuConstants.ScrollingList_VR_ExtendWidth;
			_local_7 = _local_6;
			_local_8 = _local_6;
			_local_9 = _local_6;
			_local_10 = _local_6;
			this.m_mask = new MaskView();
			this.m_mask.x = ((this.m_scrollBounds.x - ((MenuConstants.tileBorder + MenuConstants.tileGap) / 2)) - _local_8);
			this.m_mask.y = ((this.m_scrollBounds.y - ((MenuConstants.tileBorder + MenuConstants.tileGap) / 2)) - _local_7);
			this.m_mask.width = (((this.m_scrollBounds.width + (MenuConstants.tileBorder + MenuConstants.tileGap)) + _local_8) + _local_9);
			this.m_mask.height = (((this.m_scrollBounds.height + ((MenuConstants.tileBorder + MenuConstants.tileGap) / 2)) + _local_7) + _local_10);
			addChild(this.m_mask);
			getContainer().mask = this.m_mask;
		}
		;
		addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		if (!this.m_isSubMenu) {
			this.m_previousVisibilityConfig = null;
			this.m_topNavigation = new TopNavigationHandler();
			this.m_topNavigation.onSetData(_arg_1.topnavigation);
		}
		;
	}

	override public function addChild2(_arg_1:Sprite, _arg_2:int = -1):void {
		var _local_3:ICategoryElement;
		if (((this.m_isSubMenu) && (getContainer().numChildren > 0))) {
			_local_3 = (_arg_1 as ICategoryElement);
			if (_local_3 != null) {
				_local_3.enableSpacer();
			}
			;
		}
		;
		super.addChild2(_arg_1, _arg_2);
	}

	override public function onUnregister():void {
		if (this.m_topNavigation != null) {
			this.m_topNavigation.onUnregister();
			this.m_topNavigation = null;
			this.m_previousVisibilityConfig = null;
		}
		;
		super.onUnregister();
	}

	public function updateButtonPromptVisibility(_arg_1:Object):void {
		var _local_3:Boolean;
		var _local_4:Object;
		var _local_2:Object = getData();
		if (_local_2.buttonprompts) {
			if (!MenuUtils.isDataEqual(this.m_previousVisibilityConfig, _arg_1)) {
				this.m_previousVisibilityConfig = _arg_1;
				_local_3 = (!(this.m_topNavigation == null));
				for each (_local_4 in _local_2.buttonprompts) {
					this.replaceButtonPrompt(_local_4.actiontype, "rb", {
						"name": "rb",
						"transparentPrompt": ((!(_arg_1.rb)) && (!(_local_3))),
						"hidePrompt": ((!(_arg_1.rb)) && (_local_3))
					});
					this.replaceButtonPrompt(_local_4.actiontype, "lb", {
						"name": "lb",
						"transparentPrompt": ((!(_arg_1.lb)) && (!(_local_3))),
						"hidePrompt": ((!(_arg_1.lb)) && (_local_3))
					});
				}
				;
				this.updateButtonPrompts();
			}
			;
		}
		;
	}

	private function replaceButtonPrompt(_arg_1:Object, _arg_2:String, _arg_3:Object):void {
		var _local_5:Object;
		var _local_4:int;
		while (_local_4 < _arg_1.length) {
			_local_5 = _arg_1[_local_4];
			if ((_local_5 is Array)) {
				this.replaceButtonPrompt((_local_5 as Array), _arg_2, _arg_3);
			} else {
				if ((_local_5 is String)) {
					if (_local_5 == _arg_2) {
						_arg_1[_local_4] = _arg_3;
					}
					;
				} else {
					if ((_local_5 is Object)) {
						if (_local_5["name"] == _arg_2) {
							_arg_1[_local_4] = _arg_3;
						}
						;
					}
					;
				}
				;
			}
			;
			_local_4++;
		}
		;
	}

	public function updateButtonPrompts():void {
		var _local_2:Function;
		var _local_1:Object = getData();
		if (_local_1.buttonprompts) {
			_local_2 = null;
			if (m_sendEventWithValue != null) {
				_local_2 = this.handlePromptMouseEvent;
			}
			;
			MenuUtils.parsePrompts(_local_1, null, this.m_topNavigation.m_promptsContainer, true, _local_2);
		}
		;
	}

	private function handlePromptMouseEvent(_arg_1:String):void {
		var _local_2:int;
		if (m_sendEventWithValue == null) {
			return;
		}
		;
		if (this["_nodedata"]) {
			_local_2 = (this["_nodedata"]["id"] as int);
			if (_arg_1 == "lb") {
				m_sendEventWithValue("onElementPagePrev", _local_2);
			} else {
				if (_arg_1 == "rb") {
					m_sendEventWithValue("onElementPageNext", _local_2);
				}
				;
			}
			;
		}
		;
	}

	public function getScrollBounds():Rectangle {
		return (this.m_scrollBounds);
	}

	public function isHorizontal():Boolean {
		return (m_direction == "horizontal");
	}

	public function isVertical():Boolean {
		return (m_direction == "vertical");
	}

	public function isDual():Boolean {
		return (m_direction == "dual");
	}

	public function scrollToBounds(_arg_1:Rectangle, _arg_2:Number = -1):void {
		var _local_7:Rectangle;
		var _local_8:Rectangle;
		var _local_9:Number;
		if (_arg_2 < 0) {
			_arg_2 = MenuConstants.ScrollTime;
		}
		;
		if (this.m_overflowScrollingFactor > 0) {
			_local_7 = _arg_1.clone();
			_local_7.inflate((_arg_1.width * this.m_overflowScrollingFactor), (_arg_1.height * this.m_overflowScrollingFactor));
			_local_7.offset((getContainer().x * -1), (getContainer().y * -1));
			_local_7 = _local_7.intersection(this.m_scrollMaxBounds);
			_local_7.offset(getContainer().x, getContainer().y);
			_arg_1 = _local_7;
		}
		;
		if (this.m_scrollBounds.containsRect(_arg_1)) {
			Animate.kill(getContainer());
			return;
		}
		;
		var _local_3:Object = new Object();
		var _local_4:Number = 0;
		var _local_5:Number = ((this.m_scrollBounds.left + this.m_scrollBounds.right) * 0.5);
		var _local_6:Number = ((_arg_1.left + _arg_1.right) * 0.5);
		if (_arg_1.width > this.m_scrollBounds.width) {
			_local_4 = Math.abs((_local_6 - _local_5));
		} else {
			_local_8 = this.m_scrollBounds.union(_arg_1);
			_local_4 = (_local_8.width - this.m_scrollBounds.width);
		}
		;
		if (_local_4 > 0) {
			_local_9 = getContainer().x;
			if (_local_5 > _local_6) {
				_local_9 = (_local_9 + _local_4);
			} else {
				_local_9 = (_local_9 - _local_4);
			}
			;
			_local_3["x"] = _local_9;
		}
		;
		if (_local_3["x"] !== undefined) {
			Animate.kill(getContainer());
			if (_local_3["x"] !== undefined) {
				Animate.legacyTo(getContainer(), _arg_2, {"x": _local_3["x"]}, Animate.ExpoOut);
			}
			;
		}
		;
	}

	public function setFocusTarget(_arg_1:Sprite):void {
		this.setFocusTargetWithScrollTime(_arg_1, MenuConstants.ScrollTime);
		if (this.m_topNavigation != null) {
			this.m_topNavigation.updateFrom(_arg_1);
		}
		;
	}

	public function setFocusTargetWithScrollTime(target:Sprite, scrollTime:Number):void {
		var menuElem:MenuElementBase = (target as MenuElementBase);
		var targetBounds:Rectangle = getMenuElementBounds(menuElem, this, function (_arg_1:MenuElementBase):Boolean {
			return (_arg_1.visible);
		});
		this.scrollToBounds(targetBounds, scrollTime);
	}

	override protected function handleSelectionChange():void {
		if (m_isSelected) {
			bubbleEvent("scrollingListContainerSelected", this);
		}
		;
	}

	override public function repositionChild(_arg_1:Sprite):void {
		super.repositionChild(_arg_1);
		this.m_scrollMaxBounds = getVisibleContainerBounds();
	}

	override public function handleEvent(_arg_1:String, _arg_2:Sprite):Boolean {
		if (_arg_1 == "categorySelected") {
			this.setFocusTarget(_arg_2);
			bubbleEvent("scrollingListContainerScrolled", this);
		} else {
			if (_arg_1 == "itemSelected") {
				this.setFocusTarget(_arg_2);
				bubbleEvent("scrollingListContainerScrolled", this);
			} else {
				if (_arg_1 == "itemHoverOn") {
					this.setFocusTargetWithScrollTime(_arg_2, MenuConstants.TabsHoverScrollTime);
					bubbleEvent("scrollingListContainerScrolled", this);
				}
				;
			}
			;
		}
		;
		return (super.handleEvent(_arg_1, _arg_2));
	}

	private function onAddedToStage(_arg_1:Event):void {
		removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
		ButtonPromtUtil.registerButtonPromptOwner(this);
		if (!this.m_isSubMenu) {
			Animate.to(this.m_tabBackground, MenuConstants.PageOpenTime, 0, {"alpha": 1}, Animate.Linear);
		}
		;
		this.scaleBackground();
		stage.addEventListener(ScreenResizeEvent.SCREEN_RESIZED, this.onScreenResize, true, 0, true);
		addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
	}

	private function onRemovedFromStage(_arg_1:Event):void {
		stage.removeEventListener(ScreenResizeEvent.SCREEN_RESIZED, this.onScreenResize, true);
		removeEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
		ButtonPromtUtil.unregisterButtonPromptOwner(this);
	}

	protected function onScreenResize(_arg_1:ScreenResizeEvent):void {
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
		this.m_tabBackground.width = _local_1;
		this.m_tabBackground.x = _local_2;
	}


}
}//package menu3.containers

