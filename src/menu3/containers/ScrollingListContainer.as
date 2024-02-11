// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.containers.ScrollingListContainer

package menu3.containers {
import flash.geom.Rectangle;
import flash.geom.Point;
import flash.display.Sprite;
import flash.events.Event;

import common.menu.MenuConstants;

import flash.events.MouseEvent;

import common.Animate;
import common.Log;

import menu3.MenuElementBase;
import menu3.IScreenVisibilityReceiver;

import common.menu.MenuUtils;

import menu3.ScreenResizeEvent;

public dynamic class ScrollingListContainer extends ListContainer {

	protected var m_alwaysClampToMaxBounds:Boolean = true;
	private var m_scrollBarVertical:scrollIndicatorVerticalView;
	private var m_scrollBarHorizontal:scrollIndicatorHorizontalView;
	private var m_scrollBounds:Rectangle;
	private var m_scrollMaxBounds:Rectangle;
	protected var m_mask:MaskView;
	protected var m_maskArea:Rectangle;
	protected var m_visibilityArea:Rectangle;
	private var m_maskStartLeftOffset:Number;
	private var m_isStartMaskActive:Boolean = false;
	private var m_scrollingDisabled:Boolean;
	private var m_hideScrollBar:Boolean;
	private var m_overflowScrollingFactor:Number = 0;
	private var m_reverseStartPos:Boolean = false;
	private var m_mouseWheelStepSizeX:Number = 240;
	private var m_mouseWheelStepSizeY:Number = 120;
	private var m_sliderDragIsHorizontal:Boolean = false;
	private var m_mouseDragPos:Point;
	private var m_isMouseDragActive:Boolean;
	private var m_useMaskScrolling:Boolean = false;
	private var m_maskScrollingIsActive:Boolean = false;
	private var m_maskLastMousePos:Point;
	private var m_maskLastTargetBoundsRelativeToContainer:Rectangle;
	private var m_lastScrollWasTriggeredByMask:Boolean = false;
	private var m_dragAreaScrollBarH:Rectangle;
	private var m_dragAreaScrollBarV:Rectangle;
	private var m_clickAreaScrollBarH:Rectangle;
	private var m_clickAreaScrollBarV:Rectangle;
	private var m_screenScale:Number = 1;
	private var m_indicatorHandler:IndicatorHandler = null;
	private var m_clickArea:Sprite;
	private var m_mouseWheelScrollActive:Boolean;
	private var m_instantFirstScroll:Boolean = false;
	private var m_usePersistentReloadData:Boolean = false;
	private var m_debug:Boolean = false;
	private var m_experimentalFastMode:Boolean = false;

	public function ScrollingListContainer(_arg_1:Object) {
		var _local_12:Number;
		super(_arg_1);
		this.updateScreenScale(_arg_1.sizeY);
		addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage, true, 0, true);
		var _local_2:Number = ((_arg_1.width) || (MenuConstants.BaseWidth));
		var _local_3:Number = ((_arg_1.height) || (MenuConstants.BaseHeight));
		var _local_4:Number = ((_arg_1.offsetCol != undefined) ? (_arg_1.offsetCol * MenuConstants.GridUnitWidth) : 0);
		var _local_5:Number = ((_arg_1.offsetRow != undefined) ? (_arg_1.offsetRow * MenuConstants.GridUnitHeight) : 0);
		_local_2 = (_local_2 - _local_4);
		_local_3 = (_local_3 - _local_5);
		this.m_scrollBounds = new Rectangle(_local_4, _local_5, (_local_2 + MenuConstants.tileGap), (_local_3 + MenuConstants.tileGap));
		this.setupIndicatorHandler(_arg_1);
		this.m_scrollingDisabled = ((_arg_1.scrollingdisabled) || (_arg_1.novalidcontent));
		this.m_hideScrollBar = ((_arg_1.hidescrollbar) || (this.m_scrollingDisabled));
		this.m_scrollBarVertical = new scrollIndicatorVerticalView();
		this.m_scrollBarVertical.x = (this.m_scrollBounds.width + MenuConstants.verticalScrollGapRight);
		this.m_scrollBarVertical.visible = false;
		addChild(this.m_scrollBarVertical);
		this.m_scrollBarHorizontal = new scrollIndicatorHorizontalView();
		this.m_scrollBarHorizontal.y = (MenuConstants.MenuTileLargeHeight + 4);
		this.m_scrollBarHorizontal.visible = false;
		addChild(this.m_scrollBarHorizontal);
		this.setScrollIndicatorColors();
		this.m_scrollBarHorizontal.x = (this.m_scrollBarHorizontal.x + _local_4);
		this.m_scrollBarVertical.y = (this.m_scrollBarVertical.y + _local_5);
		if (_arg_1.scrollbarspaceoffset) {
			this.m_scrollBarVertical.x = (this.m_scrollBarVertical.x + _arg_1.scrollbarspaceoffset);
			this.m_scrollBarHorizontal.y = (this.m_scrollBarHorizontal.y + _arg_1.scrollbarspaceoffset);
		}
		;
		var _local_6:Number = ((_arg_1.masktopoffset) || (0));
		var _local_7:Number = ((_arg_1.maskleftoffset) || (0));
		var _local_8:Number = ((_arg_1.maskwidthoffset) || (0));
		var _local_9:Number = ((_arg_1.maskheightoffset) || (0));
		var _local_10:Number = ((_arg_1.maskstartleftoffset) || (0));
		this.m_useMaskScrolling = false;
		var _local_11:* = (_arg_1.forceMask === true);
		if ((((!(_local_11)) && (this.isHorizontal())) && (ControlsMain.isVrModeActive()))) {
			_local_11 = true;
			if (((_local_8 == 0) && (_local_7 == 0))) {
				_local_12 = MenuConstants.ScrollingList_VR_ExtendWidth;
				_local_7 = _local_12;
				_local_8 = _local_12;
				_local_6 = _local_12;
				_local_9 = _local_12;
			}
			;
		}
		;
		if (((!(_arg_1.novalidcontent)) && ((this.isVertical()) || (_local_11)))) {
			this.m_maskStartLeftOffset = _local_10;
			this.m_mask = new MaskView();
			this.m_mask.x = ((this.m_scrollBounds.x - ((MenuConstants.tileBorder + MenuConstants.tileGap) / 2)) - _local_7);
			this.m_mask.y = ((this.m_scrollBounds.y - ((MenuConstants.tileBorder + MenuConstants.tileGap) / 2)) - _local_6);
			this.m_mask.width = (((this.m_scrollBounds.width + (MenuConstants.tileBorder + MenuConstants.tileGap)) + _local_7) + _local_8);
			this.m_mask.height = (((this.m_scrollBounds.height + ((MenuConstants.tileBorder + MenuConstants.tileGap) / 2)) + _local_6) + _local_9);
			addChild(this.m_mask);
			getContainer().mask = this.m_mask;
			this.m_maskArea = new Rectangle(this.m_mask.x, this.m_mask.y, this.m_mask.width, this.m_mask.height);
			if (((this.isHorizontal()) && ((ControlsMain.isVrModeActive()) || (_arg_1.usemaskvisibilitycheck === true)))) {
				this.m_visibilityArea = this.m_maskArea.clone();
			}
			;
			if (_arg_1.outsidemaskscrolling) {
				this.m_useMaskScrolling = _arg_1.outsidemaskscrolling;
			}
			;
		}
		;
		if (_arg_1.overflowscrolling) {
			this.m_overflowScrollingFactor = _arg_1.overflowscrolling;
		}
		;
		if (_arg_1.mousewheelstepsize) {
			this.m_mouseWheelStepSizeX = _arg_1.mousewheelstepsize;
			this.m_mouseWheelStepSizeY = _arg_1.mousewheelstepsize;
		}
		;
		this.m_reverseStartPos = (_arg_1.reversestartpos === true);
		this.m_instantFirstScroll = (_arg_1.instantfirstscroll === true);
		this.m_usePersistentReloadData = (_arg_1.usepersistentreloaddata === true);
		this.m_experimentalFastMode = (_arg_1.experimentalfastmode === true);
		this.checkMaskScrolling();
		this.m_clickArea = new Sprite();
		addChildAt(this.m_clickArea, 0);
		this.m_clickArea.graphics.clear();
		this.m_clickArea.graphics.beginFill(0xFF0000, 0);
		this.m_clickArea.graphics.drawRect(0, 0, getWidth(), getHeight());
		this.m_clickArea.graphics.endFill();
	}

	override public function onUnregister():void {
		this.disableMaskScrolling();
		if (this.m_isMouseDragActive) {
			this.handleDragEnd(new MouseEvent(MouseEvent.MOUSE_UP));
		}
		;
		if (this.m_indicatorHandler) {
			this.m_indicatorHandler.destroy();
			this.m_indicatorHandler = null;
		}
		;
		if (this.m_clickArea) {
			removeChild(this.m_clickArea);
			this.m_clickArea = null;
		}
		;
		super.onUnregister();
	}

	override public function getPersistentReloadData():Object {
		var _local_1:Object = super.getPersistentReloadData();
		if (_local_1 == null) {
			_local_1 = new Object();
		}
		;
		var _local_2:Sprite = getContainer();
		var _local_3:Rectangle = this.getScrollBounds();
		_local_3.offset(-(_local_2.x), -(_local_2.y));
		_local_1["scrollbounds"] = _local_3;
		return (_local_1);
	}

	override public function onPersistentReloadData(_arg_1:Object):void {
		super.onPersistentReloadData(_arg_1);
		if (((((!(this.m_usePersistentReloadData)) || (_arg_1 == null)) || (m_children == null)) || (m_children.length <= 0))) {
			return;
		}
		;
		var _local_2:Rectangle = _arg_1.scrollbounds;
		if (_local_2 != null) {
			this.scrollToBoundsInternal(_local_2, 0, false);
		}
		;
	}

	override public function setEngineCallbacks(_arg_1:Function, _arg_2:Function):void {
		super.setEngineCallbacks(_arg_1, _arg_2);
		this.m_indicatorHandler.setEngineCallback(_arg_2);
		this.checkMaskScrolling();
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

	public function updateScrollBar():void {
		pausePopOutScale();
		this.recalculateTotalBounds();
		resumePopOutScale();
	}

	public function finishScrollingNow():void {
		Animate.complete(getContainer());
		Animate.complete(this.m_scrollBarHorizontal.indicator);
		Animate.complete(this.m_scrollBarVertical.indicator);
	}

	public function getPositionX():Number {
		return (getContainer().x);
	}

	public function scrollToBounds(_arg_1:Rectangle, _arg_2:Number = -1):void {
		if (_arg_2 < 0) {
			_arg_2 = MenuConstants.ScrollTime;
		}
		;
		var _local_3:Boolean = true;
		this.scrollToBoundsInternal(_arg_1, _arg_2, _local_3);
	}

	private function setupIndicatorHandler(_arg_1:Object):void {
		this.m_indicatorHandler = new IndicatorHandler(this, _arg_1);
	}

	private function scrollToMouseWheelTarget(_arg_1:Rectangle):void {
		var _local_2:Boolean;
		var _local_3:Boolean = this.scrollToBoundsInternal(_arg_1, MenuConstants.ScrollTime, _local_2);
		if (!_local_3) {
			this.m_mouseWheelScrollActive = false;
		}
		;
	}

	protected function scrollToBoundsInternal(targetBounds:Rectangle, scrollTime:Number, useOverflowScrolling:Boolean):Boolean {
		var overflowTargetBound:Rectangle;
		var scrollOffsetX:Number;
		var centerX:Number;
		var centerTargetX:Number;
		var rectUnionX:Rectangle;
		var currentX:Number;
		var scrollOffsetY:Number;
		var centerY:Number;
		var centerTargetY:Number;
		var rectUnionY:Rectangle;
		var currentY:Number;
		var targetIsTopLeft:Boolean;
		var scrollAnimationTime:Number;
		if (this.m_scrollingDisabled) {
			return (false);
		}
		;
		this.m_lastScrollWasTriggeredByMask = false;
		var clampToMaxBounds:Boolean = this.m_alwaysClampToMaxBounds;
		if (((useOverflowScrolling) && (this.m_overflowScrollingFactor > 0))) {
			overflowTargetBound = targetBounds.clone();
			overflowTargetBound.inflate((targetBounds.width * this.m_overflowScrollingFactor), (targetBounds.height * this.m_overflowScrollingFactor));
			targetBounds = overflowTargetBound;
			clampToMaxBounds = true;
		}
		;
		if (this.m_debug) {
			Log.info(Log.ChannelDebug, this, ((((((("scrollBounds: x=" + this.m_scrollBounds.x) + " y=") + this.m_scrollBounds.y) + " w=") + this.m_scrollBounds.width) + " h=") + this.m_scrollBounds.height));
			Log.info(Log.ChannelDebug, this, ((((((("targetBounds: x=" + targetBounds.x) + " y=") + targetBounds.y) + " w=") + targetBounds.width) + " h=") + targetBounds.height));
		}
		;
		if (clampToMaxBounds) {
			targetBounds = this.clampTargetBoundsToMaxScrollBounds(targetBounds);
			if (this.m_debug) {
				Log.info(Log.ChannelDebug, this, ((((((("clamped targetBounds: x=" + targetBounds.x) + " y=") + targetBounds.y) + " w=") + targetBounds.width) + " h=") + targetBounds.height));
			}
			;
		}
		;
		if (this.m_scrollBounds.containsRect(targetBounds)) {
			Animate.kill(getContainer());
			Animate.kill(this.m_scrollBarHorizontal.indicator);
			Animate.kill(this.m_scrollBarVertical.indicator);
			return (false);
		}
		;
		var scrollCheckResult:Object = new Object();
		if (((this.isHorizontal()) || (this.isDual()))) {
			scrollOffsetX = 0;
			centerX = ((this.m_scrollBounds.left + this.m_scrollBounds.right) * 0.5);
			centerTargetX = ((targetBounds.left + targetBounds.right) * 0.5);
			if (targetBounds.width > this.m_scrollBounds.width) {
				scrollOffsetX = Math.abs((centerTargetX - centerX));
			} else {
				rectUnionX = this.m_scrollBounds.union(targetBounds);
				scrollOffsetX = (rectUnionX.width - this.m_scrollBounds.width);
			}
			;
			if (scrollOffsetX > 0) {
				currentX = getContainer().x;
				if (centerX > centerTargetX) {
					currentX = (currentX + scrollOffsetX);
					scrollCheckResult.dirX = 1;
				} else {
					currentX = (currentX - scrollOffsetX);
					scrollCheckResult.dirX = -1;
				}
				;
				scrollCheckResult["x"] = currentX;
			}
			;
		}
		;
		if (((this.isVertical()) || (this.isDual()))) {
			scrollOffsetY = 0;
			centerY = ((this.m_scrollBounds.top + this.m_scrollBounds.bottom) * 0.5);
			centerTargetY = ((targetBounds.top + targetBounds.bottom) * 0.5);
			if (targetBounds.height > this.m_scrollBounds.height) {
				scrollOffsetY = Math.abs((centerTargetY - centerY));
			} else {
				rectUnionY = this.m_scrollBounds.union(targetBounds);
				scrollOffsetY = (rectUnionY.height - this.m_scrollBounds.height);
			}
			;
			if (scrollOffsetY > 0) {
				currentY = getContainer().y;
				if (centerY > centerTargetY) {
					currentY = (currentY + scrollOffsetY);
					scrollCheckResult.dirY = 1;
				} else {
					currentY = (currentY - scrollOffsetY);
					scrollCheckResult.dirY = -1;
				}
				;
				scrollCheckResult["y"] = currentY;
			}
			;
		}
		;
		if (((!(scrollCheckResult["x"] === undefined)) || (!(scrollCheckResult["y"] === undefined)))) {
			targetIsTopLeft = true;
			scrollAnimationTime = MenuConstants.SwipeInTime;
			if (scrollTime == 0) {
				scrollAnimationTime = 0;
			}
			;
			Animate.kill(getContainer());
			if (scrollCheckResult["x"] !== undefined) {
				if (scrollCheckResult["x"] < -0.01) {
					targetIsTopLeft = false;
				}
				;
				if (scrollTime != 0) {
					Animate.legacyTo(getContainer(), scrollTime, {"x": scrollCheckResult["x"]}, Animate.ExpoOut, function ():void {
						onScrollComplete();
					});
				} else {
					getContainer().x = scrollCheckResult["x"];
				}
				;
				if (this.m_scrollBarHorizontal.visible) {
					this.updateHorizontalScrollIndicator(scrollCheckResult["x"], scrollAnimationTime);
				}
				;
			}
			;
			if (scrollCheckResult["y"] !== undefined) {
				if (scrollCheckResult["y"] < -0.01) {
					targetIsTopLeft = false;
				}
				;
				if (scrollTime != 0) {
					Animate.legacyTo(getContainer(), scrollTime, {"y": scrollCheckResult["y"]}, Animate.ExpoOut, function ():void {
						onScrollComplete();
					});
				} else {
					getContainer().y = scrollCheckResult["y"];
				}
				;
				if (this.m_scrollBarVertical.visible) {
					this.updateVerticalScrollIndicator(scrollCheckResult["y"], scrollAnimationTime);
				}
				;
			}
			;
			if (((!(this.m_mask == null)) && (!(this.m_maskStartLeftOffset == 0)))) {
				this.setStartMaskActive(targetIsTopLeft, (scrollTime / 2));
			}
			;
			this.updateChildrenVisibility(false, targetBounds);
		} else {
			scrollTime = 0;
		}
		;
		if (scrollTime == 0) {
			Animate.delay(getContainer(), scrollTime, function ():void {
				onScrollComplete();
			});
		}
		;
		return (true);
	}

	protected function onScrollComplete():void {
		this.m_mouseWheelScrollActive = false;
		this.updateChildrenVisibility(true);
	}

	override public function onChildrenChanged():void {
		super.onChildrenChanged();
		if (this.m_experimentalFastMode) {
			this.recalculateTotalBounds();
		}
		;
		this.updateChildrenVisibility(true);
	}

	protected function updateChildrenVisibility(_arg_1:Boolean, _arg_2:Rectangle = null):void {
		if (this.m_visibilityArea == null) {
			return;
		}
		;
		this.updateChildrenVisibiltyOnRect(this.m_visibilityArea, _arg_1, _arg_2);
	}

	protected function updateChildrenVisibiltyOnRect(_arg_1:Rectangle, _arg_2:Boolean, _arg_3:Rectangle = null):void {
		if (_arg_1 == null) {
			return;
		}
		;
		var _local_4:Rectangle = _arg_1.clone();
		if (_arg_3 != null) {
			_local_4 = _local_4.union(_arg_3);
			if (this.m_debug) {
				Log.info(Log.ChannelDebug, this, ("updateChildrenVisibilty: targetBounds: " + _arg_3));
				Log.info(Log.ChannelDebug, this, ("updateChildrenVisibilty: Visible Area0: " + _arg_1));
			}
			;
		}
		;
		_local_4.inflate(MenuConstants.GridUnitWidth, 0);
		if (this.m_debug) {
			Log.info(Log.ChannelDebug, this, ("updateChildrenVisibilty: Visible Area: " + _arg_1));
		}
		;
		this.updateContainerElementVisibility(_arg_2, _local_4, this);
	}

	private function updateContainerElementVisibility(_arg_1:Boolean, _arg_2:Rectangle, _arg_3:BaseContainer):void {
		var _local_7:Rectangle;
		var _local_4:BaseContainer;
		var _local_5:MenuElementBase;
		var _local_6:int;
		while (_local_6 < _arg_3.m_children.length) {
			_local_5 = (_arg_3.m_children[_local_6] as MenuElementBase);
			if (_local_5 != null) {
				_local_7 = _local_5.getBounds(this);
				if (_arg_2.intersects(_local_7)) {
					if (this.m_debug) {
						Log.info(Log.ChannelDebug, this, (((("updateChildrenVisibilty: Child " + _local_6) + " bounds = ") + _local_7) + " in visible area"));
					}
					;
					this.setElementVisibility(_arg_1, _local_5, true);
					_local_4 = (_local_5 as BaseContainer);
					if (_local_4 != null) {
						this.updateContainerElementVisibility(_arg_1, _arg_2, _local_4);
					}
					;
				} else {
					if (this.m_debug) {
						Log.info(Log.ChannelDebug, this, ((("updateChildrenVisibilty: Child " + _local_6) + " bounds = ") + _local_7));
					}
					;
					this.setElementVisibility(_arg_1, _local_5, false);
				}
				;
			}
			;
			_local_6++;
		}
		;
	}

	protected function setElementVisibility(_arg_1:Boolean, _arg_2:MenuElementBase, _arg_3:Boolean):void {
		_arg_2.alpha = ((_arg_3) ? 1 : 0);
		var _local_4:IScreenVisibilityReceiver = (_arg_2 as IScreenVisibilityReceiver);
		if (_local_4 != null) {
			_local_4.setVisibleOnScreen(_arg_3);
		}
		;
	}

	private function setStartMaskActive(_arg_1:Boolean, _arg_2:Number):void {
		var _local_3:Number;
		var _local_4:Number;
		if (((!(getContainer().mask == this.m_mask)) || (this.m_mask == null))) {
			return;
		}
		;
		if (this.m_isStartMaskActive == _arg_1) {
			return;
		}
		;
		this.m_isStartMaskActive = _arg_1;
		if (_arg_1) {
			_local_3 = (this.m_maskArea.x - this.m_maskStartLeftOffset);
			_local_4 = (this.m_maskArea.width + this.m_maskStartLeftOffset);
			if (ControlsMain.isVrModeActive()) {
				Animate.kill(this.m_mask);
				this.m_mask.x = _local_3;
				this.m_mask.width = _local_4;
			} else {
				Animate.to(this.m_mask, _arg_2, 0, {
					"x": _local_3,
					"width": _local_4
				}, Animate.Linear);
			}
			;
		} else {
			Animate.kill(this.m_mask);
			this.m_mask.x = this.m_maskArea.x;
			this.m_mask.width = this.m_maskArea.width;
		}
		;
	}

	protected function setScrollIndicatorColors():void {
		if (this.m_scrollBarVertical != null) {
			MenuUtils.setColor(this.m_scrollBarVertical.indicator, MenuConstants.COLOR_RED, true, MenuConstants.MenuElementSelectedAlpha);
			MenuUtils.setColor(this.m_scrollBarVertical.indicatorbg, MenuConstants.COLOR_MENU_TABS_BACKGROUND, true, MenuConstants.MenuElementBackgroundAlpha);
		}
		;
		if (this.m_scrollBarHorizontal != null) {
			MenuUtils.setColor(this.m_scrollBarHorizontal.indicator, MenuConstants.COLOR_RED, true, MenuConstants.MenuElementSelectedAlpha);
			MenuUtils.setColor(this.m_scrollBarHorizontal.indicatorbg, MenuConstants.COLOR_MENU_TABS_BACKGROUND, true, MenuConstants.MenuElementBackgroundAlpha);
		}
		;
	}

	private function setScrollIndicator(_arg_1:Number, _arg_2:Number, _arg_3:Boolean):void {
		var _local_4:Number;
		var _local_5:Number;
		if (_arg_3) {
			this.m_scrollBarVertical.indicatorbg.height = _arg_1;
			this.m_scrollBarVertical.arrowup.alpha = 0;
			this.m_scrollBarVertical.arrowdown.alpha = 0;
			this.m_scrollBarVertical.arrowdown.y = _arg_1;
			_local_4 = ((_arg_1 / _arg_2) * 100);
			this.m_scrollBarVertical.indicator.height = ((_local_4 * _arg_1) / 100);
			this.m_scrollBarVertical.visible = true;
			this.m_dragAreaScrollBarV = this.m_scrollBarVertical.indicator.getBounds(this);
			this.m_dragAreaScrollBarV.inflate(20, 0);
			this.m_clickAreaScrollBarV = this.m_scrollBarVertical.indicatorbg.getBounds(this);
			this.m_clickAreaScrollBarV.inflate(20, 0);
		} else {
			this.m_scrollBarHorizontal.indicatorbg.width = _arg_1;
			this.m_scrollBarHorizontal.arrowleft.alpha = 0;
			this.m_scrollBarHorizontal.arrowright.alpha = 0;
			this.m_scrollBarHorizontal.arrowright.x = _arg_1;
			_local_5 = ((_arg_1 / _arg_2) * 100);
			this.m_scrollBarHorizontal.indicator.width = ((_local_5 * _arg_1) / 100);
			this.m_scrollBarHorizontal.visible = true;
			this.m_dragAreaScrollBarH = this.m_scrollBarHorizontal.indicator.getBounds(this);
			this.m_dragAreaScrollBarH.inflate(0, 20);
			this.m_clickAreaScrollBarH = this.m_scrollBarHorizontal.indicatorbg.getBounds(this);
			this.m_clickAreaScrollBarH.inflate(0, 20);
		}
		;
	}

	private function updateVerticalScrollIndicator(_arg_1:int, _arg_2:Number):void {
		var _local_3:Number = ((_arg_1 / this.m_scrollBounds.height) * this.m_scrollBarVertical.indicator.height);
		if (_arg_2 > 0) {
			Animate.legacyTo(this.m_scrollBarVertical.indicator, _arg_2, {"y": -(_local_3)}, Animate.ExpoOut);
		} else {
			this.m_scrollBarVertical.indicator.y = -(_local_3);
		}
		;
		this.m_dragAreaScrollBarV.y = -(_local_3);
	}

	private function updateHorizontalScrollIndicator(_arg_1:int, _arg_2:Number):void {
		var _local_3:Number = ((_arg_1 / this.m_scrollBounds.width) * this.m_scrollBarHorizontal.indicator.width);
		if (_arg_2 > 0) {
			Animate.legacyTo(this.m_scrollBarHorizontal.indicator, _arg_2, {"x": -(_local_3)}, Animate.ExpoOut);
		} else {
			this.m_scrollBarHorizontal.indicator.x = -(_local_3);
		}
		;
		this.m_dragAreaScrollBarH.x = -(_local_3);
	}

	protected function recalculateTotalBounds():void {
		var _local_9:Rectangle;
		var _local_10:Rectangle;
		var _local_1:Rectangle = getVisibleContainerBounds();
		this.m_scrollMaxBounds = _local_1.clone();
		var _local_2:Sprite = getContainer();
		if (_local_2 != null) {
			this.m_scrollMaxBounds.x = (this.m_scrollMaxBounds.x - _local_2.x);
			this.m_scrollMaxBounds.y = (this.m_scrollMaxBounds.y - _local_2.y);
		}
		;
		this.m_scrollBarVertical.visible = false;
		this.m_scrollBarHorizontal.visible = false;
		if (((((this.isVertical()) || (this.isDual())) && (!(this.m_hideScrollBar))) && (Math.floor(this.m_scrollMaxBounds.height) > this.m_scrollBounds.height))) {
			this.setScrollIndicator(this.m_scrollBounds.height, this.m_scrollMaxBounds.height, true);
			this.updateVerticalScrollIndicator(getContainer().y, 0);
		}
		;
		if (((((this.isHorizontal()) || (this.isDual())) && (!(this.m_hideScrollBar))) && (Math.floor(this.m_scrollMaxBounds.width) > this.m_scrollBounds.width))) {
			this.setScrollIndicator(this.m_scrollBounds.width, this.m_scrollMaxBounds.width, false);
			this.updateHorizontalScrollIndicator(getContainer().x, 0);
		}
		;
		var _local_3:Number = (getContainer().x * -1);
		var _local_4:Number = (getContainer().y * -1);
		var _local_5:Number = Math.max(((_local_3 + this.m_scrollBounds.width) - this.m_scrollMaxBounds.width), 0);
		var _local_6:Number = Math.max(((_local_4 + this.m_scrollBounds.height) - this.m_scrollMaxBounds.height), 0);
		var _local_7:Number = (Math.min(_local_5, _local_3) * -1);
		var _local_8:Number = (Math.min(_local_6, _local_4) * -1);
		if (this.m_debug) {
			Log.info(Log.ChannelDebug, this, ((("xPos: " + _local_3) + " yPos:") + _local_4));
			Log.info(Log.ChannelDebug, this, ((("m_scrollMaxBounds width: " + this.m_scrollMaxBounds.width) + " height:") + this.m_scrollMaxBounds.height));
			Log.info(Log.ChannelDebug, this, ((("m_scrollBounds width: " + this.m_scrollBounds.width) + " height:") + this.m_scrollBounds.height));
			Log.info(Log.ChannelDebug, this, ((("offsetX: " + _local_7) + " offsetY:") + _local_8));
		}
		;
		if (((_local_7 < 0) || (_local_8 < 0))) {
			_local_9 = this.getScrollTargetFromOffset(_local_7, _local_8);
			this.scrollToBounds(_local_9, 0);
		}
		;
		if (this.m_reverseStartPos) {
			_local_10 = new Rectangle(((_local_1.x + _local_1.width) - 1), ((_local_1.y + _local_1.height) - 1), 1, 1);
			this.scrollToBounds(_local_10, 0);
		}
		;
	}

	public function setFocusTarget(target:Sprite):void {
		if (this.m_mouseWheelScrollActive) {
			return;
		}
		;
		var menuElem:MenuElementBase = (target as MenuElementBase);
		if (((this.m_debug) && (!(menuElem == null)))) {
			Log.info(Log.ChannelDebug, this, ("setFocusTarget: " + menuElem.name));
			Log.info(Log.ChannelDebug, menuElem, ("y: " + menuElem.y));
		}
		;
		var targetBounds:Rectangle = getMenuElementBounds(menuElem, this, function (_arg_1:MenuElementBase):Boolean {
			return (_arg_1.visible);
		});
		if (this.m_instantFirstScroll) {
			this.m_instantFirstScroll = false;
			this.scrollToBounds(targetBounds, 0);
		} else {
			this.scrollToBounds(targetBounds);
		}
		;
	}

	override protected function handleSelectionChange():void {
		if (m_isSelected) {
			bubbleEvent("scrollingListContainerSelected", this);
		}
		;
	}

	override public function repositionChild(_arg_1:Sprite):void {
		super.repositionChild(_arg_1);
		if (!this.m_experimentalFastMode) {
			this.recalculateTotalBounds();
		}
		;
	}

	override public function handleEvent(_arg_1:String, _arg_2:Sprite):Boolean {
		if (_arg_1 == "itemSelected") {
			this.setFocusTarget(_arg_2);
			bubbleEvent("scrollingListContainerScrolled", this);
		}
		;
		if (_arg_1 == "itemHoverOn") {
			this.setFocusTarget(_arg_2);
			bubbleEvent("scrollingListContainerScrolled", this);
		}
		;
		return (super.handleEvent(_arg_1, _arg_2));
	}

	override public function handleMouseDown(_arg_1:Function, _arg_2:MouseEvent):void {
		var _local_3:Point;
		var _local_4:Point;
		var _local_5:Boolean;
		var _local_6:Number;
		var _local_7:Rectangle;
		var _local_8:Number;
		var _local_9:Rectangle;
		if (((this.m_scrollBarVertical.visible) || (this.m_scrollBarHorizontal.visible))) {
			_local_3 = new Point(_arg_2.stageX, _arg_2.stageY);
			_local_4 = globalToLocal(_local_3);
			_local_5 = false;
			if (this.m_scrollBarVertical.visible) {
				if (this.m_dragAreaScrollBarV.containsPoint(_local_4)) {
					_arg_2.stopImmediatePropagation();
					_local_5 = true;
					this.m_sliderDragIsHorizontal = false;
				} else {
					if (this.m_clickAreaScrollBarV.containsPoint(_local_4)) {
						_arg_2.stopImmediatePropagation();
						_local_6 = ((_local_4.y < this.m_dragAreaScrollBarV.y) ? -1 : 1);
						_local_7 = this.getScrollTargetFromOffset(0, (this.m_scrollBounds.height * _local_6));
						this.scrollToMouseWheelTarget(_local_7);
						bubbleEvent("scrollingListContainerScrolled", this);
						return;
					}
					;
				}
				;
			}
			;
			if (((!(_local_5)) && (this.m_scrollBarHorizontal.visible))) {
				if (this.m_dragAreaScrollBarH.containsPoint(_local_4)) {
					_arg_2.stopImmediatePropagation();
					_local_5 = true;
					this.m_sliderDragIsHorizontal = true;
				} else {
					if (this.m_clickAreaScrollBarH.containsPoint(_local_4)) {
						_arg_2.stopImmediatePropagation();
						_local_8 = ((_local_4.x < this.m_dragAreaScrollBarH.x) ? -1 : 1);
						_local_9 = this.getScrollTargetFromOffset((this.m_scrollBounds.width * _local_8), 0);
						this.scrollToMouseWheelTarget(_local_9);
						bubbleEvent("scrollingListContainerScrolled", this);
						return;
					}
					;
				}
				;
			}
			;
			if (_local_5) {
				this.m_isMouseDragActive = true;
				stage.addEventListener(MouseEvent.MOUSE_MOVE, this.handleDragMouseMove, true);
				stage.addEventListener(MouseEvent.MOUSE_UP, this.handleDragEnd, true);
				stage.addEventListener(MouseEvent.MOUSE_DOWN, this.handleDragEnd, true);
				this.m_mouseDragPos = _local_3;
				return;
			}
			;
		}
		;
		super.handleMouseDown(_arg_1, _arg_2);
	}

	public function handleDragMouseMove(_arg_1:MouseEvent):void {
		var _local_7:Rectangle;
		_arg_1.stopImmediatePropagation();
		var _local_2:Point = new Point(_arg_1.stageX, _arg_1.stageY);
		var _local_3:Point = _local_2.subtract(this.m_mouseDragPos);
		this.m_mouseDragPos = _local_2;
		var _local_4:Number = ((this.m_scrollMaxBounds.width / this.m_scrollBounds.width) * this.m_screenScale);
		var _local_5:Number = ((this.m_scrollMaxBounds.height / this.m_scrollBounds.height) * this.m_screenScale);
		var _local_6:Point = new Point((_local_3.x * _local_4), (_local_3.y * _local_5));
		if (this.m_sliderDragIsHorizontal) {
			_local_7 = this.getScrollTargetFromOffset(_local_6.x, 0);
		} else {
			_local_7 = this.getScrollTargetFromOffset(0, _local_6.y);
		}
		;
		var _local_8:Number = 0;
		var _local_9:Boolean;
		this.scrollToBoundsInternal(_local_7, _local_8, _local_9);
		bubbleEvent("scrollingListContainerScrolled", this);
	}

	private function handleDragEnd(_arg_1:MouseEvent):void {
		this.m_isMouseDragActive = false;
		_arg_1.stopImmediatePropagation();
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.handleDragMouseMove, true);
		stage.removeEventListener(MouseEvent.MOUSE_UP, this.handleDragEnd, true);
		stage.removeEventListener(MouseEvent.MOUSE_DOWN, this.handleDragEnd, true);
	}

	override public function handleMouseWheel(_arg_1:Function, _arg_2:MouseEvent):void {
		if (_arg_2.delta == 0) {
			return;
		}
		;
		if (((this.m_mouseWheelStepSizeX == 0) && (this.m_mouseWheelStepSizeY == 0))) {
			return;
		}
		;
		_arg_2.stopImmediatePropagation();
		var _local_3:Number = 0;
		var _local_4:Number = 0;
		if (this.isHorizontal()) {
			_local_3 = (-(_arg_2.delta) * this.m_mouseWheelStepSizeX);
		} else {
			_local_4 = (-(_arg_2.delta) * this.m_mouseWheelStepSizeY);
		}
		;
		var _local_5:Rectangle = this.getScrollTargetFromOffset(_local_3, _local_4);
		this.m_mouseWheelScrollActive = true;
		this.scrollToMouseWheelTarget(_local_5);
		bubbleEvent("scrollingListContainerScrolled", this);
	}

	private function getScrollTargetFromOffset(_arg_1:Number, _arg_2:Number):Rectangle {
		var _local_3:Rectangle = this.m_scrollBounds.clone();
		_local_3.offset(this.m_scrollMaxBounds.x, this.m_scrollMaxBounds.y);
		_local_3.offset(_arg_1, _arg_2);
		return (this.clampTargetBoundsToMaxScrollBounds(_local_3));
	}

	private function clampTargetBoundsToMaxScrollBounds(_arg_1:Rectangle):Rectangle {
		if (this.m_scrollMaxBounds != null) {
			_arg_1.offset((getContainer().x * -1), (getContainer().y * -1));
			_arg_1 = _arg_1.intersection(this.m_scrollMaxBounds);
			_arg_1.offset(getContainer().x, getContainer().y);
		}
		;
		return (_arg_1);
	}

	protected function onAddedToStage(_arg_1:Event):void {
		removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage, true);
		stage.addEventListener(ScreenResizeEvent.SCREEN_RESIZED, this.onScreenResize, true, 0, true);
		addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage, false);
	}

	protected function onRemovedFromStage(_arg_1:Event):void {
		removeEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage, false);
		stage.removeEventListener(ScreenResizeEvent.SCREEN_RESIZED, this.onScreenResize, true);
	}

	protected function onScreenResize(_arg_1:ScreenResizeEvent):void {
		var _local_2:Object = _arg_1.screenSize;
		this.updateScreenScale(_local_2.sizeY);
	}

	private function updateScreenScale(_arg_1:Number):void {
		if (_arg_1 <= 0) {
			_arg_1 = 1;
		}
		;
		this.m_screenScale = (MenuConstants.BaseHeight / _arg_1);
	}

	private function checkMaskScrolling():void {
		var _local_1:Boolean;
		var _local_2:* = (!(m_sendEventWithValue == null));
		if (((this.m_useMaskScrolling) && (_local_2))) {
			_local_1 = true;
		}
		;
		if (_local_1 == this.m_maskScrollingIsActive) {
			return;
		}
		;
		if (_local_1) {
			this.enableMaskScrolling();
		} else {
			this.disableMaskScrolling();
		}
		;
	}

	private function enableMaskScrolling():void {
		if (!this.m_maskScrollingIsActive) {
			this.m_maskScrollingIsActive = true;
			getContainer().addEventListener(Event.ENTER_FRAME, this.updateMaskScrolling);
		}
		;
	}

	private function disableMaskScrolling():void {
		if (this.m_maskScrollingIsActive) {
			this.m_maskScrollingIsActive = false;
			getContainer().removeEventListener(Event.ENTER_FRAME, this.updateMaskScrolling);
		}
		;
	}

	private function updateMaskScrolling():void {
		if (((!(this.m_maskScrollingIsActive)) || (stage == null))) {
			return;
		}
		;
		var _local_1:Point = new Point(stage.mouseX, stage.mouseY);
		if ((((!(this.m_maskLastMousePos == null)) && (this.m_maskLastMousePos.equals(_local_1))) && (!(this.m_lastScrollWasTriggeredByMask)))) {
			this.m_maskLastTargetBoundsRelativeToContainer = null;
			return;
		}
		;
		this.m_maskLastMousePos = _local_1;
		var _local_2:Point = globalToLocal(_local_1);
		if (this.m_maskArea.containsPoint(_local_2)) {
			return;
		}
		;
		var _local_3:Rectangle = this.m_scrollMaxBounds.clone();
		var _local_4:Sprite = getContainer();
		_local_3.x = (_local_3.x + _local_4.x);
		_local_3.y = (_local_3.y + _local_4.y);
		if (!_local_3.containsPoint(_local_2)) {
			return;
		}
		;
		var _local_5:Rectangle;
		var _local_6:Rectangle = this.getLeafElementBounds(m_children, _local_2);
		if (_local_6 != null) {
			_local_5 = _local_6.clone();
			_local_5.offset(-(_local_4.x), -(_local_4.y));
			_local_5.inflate(-10, -10);
			if (((this.m_maskLastTargetBoundsRelativeToContainer == null) || (!(this.m_maskLastTargetBoundsRelativeToContainer.intersects(_local_5))))) {
				this.scrollToBounds(_local_6);
				this.m_lastScrollWasTriggeredByMask = true;
			}
			;
		}
		;
		this.m_maskLastTargetBoundsRelativeToContainer = _local_5;
	}

	private function getLeafElementBounds(m_children:Array, pos:Point):Rectangle {
		var element:MenuElementBase;
		var elementBounds:Rectangle;
		var bounds:Rectangle;
		var i:int;
		while (i < m_children.length) {
			element = (m_children[i] as MenuElementBase);
			if (element != null) {
				elementBounds = getMenuElementBounds(element, this, function (_arg_1:MenuElementBase):Boolean {
					return (_arg_1.visible);
				});
				if (elementBounds.containsPoint(pos)) {
					if (element.m_children.length > 0) {
						bounds = this.getLeafElementBounds(element.m_children, pos);
						return (bounds);
					}
					;
					return (elementBounds);
				}
				;
			}
			;
			i = (i + 1);
		}
		;
		return (null);
	}


}
}//package menu3.containers

