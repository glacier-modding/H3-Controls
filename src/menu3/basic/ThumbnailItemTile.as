// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.ThumbnailItemTile

package menu3.basic {
import menu3.MenuElementTileBase;
import menu3.MenuImageLoader;

import flash.display.BitmapData;

import common.MouseUtil;

import menu3.containers.ThumbnailScrollingListContainer;

import flash.display.Sprite;

import common.Animate;
import common.menu.MenuConstants;

public dynamic class ThumbnailItemTile extends MenuElementTileBase implements IImageContainer {

	private const ExpanderAlpha:Number = 0.2;
	private const MinimumHeight:Number = 165;

	private var m_view:ThumbnailItemTileView;
	private var m_tileState:ThumbnailItemTileState;
	private var m_isFocusedOnParentList:Boolean = false;
	private var m_loader:MenuImageLoader;
	private var m_imageData:BitmapData;
	private var m_imagePath:String = null;
	private var m_expandedToHeight:int;

	public function ThumbnailItemTile(_arg_1:Object) {
		super(_arg_1);
		m_mouseMode = MouseUtil.MODE_ONOVER_HOVER_ONUP_SELECT;
		this.m_view = new ThumbnailItemTileView();
		this.m_tileState = new ThumbnailItemTileState(this.m_view.collapsed);
		if (this.m_view.mouseOverIndicator) {
			this.m_view.mouseOverIndicator.visible = false;
		}
		;
		addChild(this.m_view);
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		this.m_tileState.onSetData(_arg_1);
		if (_arg_1.image) {
			this.m_imagePath = _arg_1.image;
			if (((_arg_1.ondemand == undefined) || (!(_arg_1.ondemand)))) {
				this.loadImage();
			}
			;
		} else {
			this.m_imagePath = null;
		}
		;
		if (_arg_1.expandedHeight) {
			this.m_expandedToHeight = _arg_1.expandedHeight;
		} else {
			this.m_expandedToHeight = 300;
		}
		;
		var _local_2:ThumbnailScrollingListContainer = this.getParentThumbnailScrollingList();
		if (_local_2 != null) {
			_local_2.onReloadData(this, _arg_1);
		}
		;
	}

	override public function onUnregister():void {
		if (this.m_view) {
			this.killAnimations();
			this.unloadImage();
			if (this.m_tileState) {
				this.m_tileState.destroy();
				this.m_tileState = null;
			}
			;
			removeChild(this.m_view);
			this.m_view = null;
		}
		;
		super.onUnregister();
	}

	override public function getView():Sprite {
		return (this.m_tileState.getView());
	}

	private function completeAnimations():void {
		Animate.complete(this.m_view.expander);
		if (this.m_view.mouseOverIndicator) {
			Animate.complete(this.m_view.mouseOverIndicator);
		}
		;
	}

	private function killAnimations():void {
		Animate.kill(this.m_view.expander);
		if (this.m_view.mouseOverIndicator) {
			Animate.kill(this.m_view.mouseOverIndicator);
		}
		;
	}

	public function isImageLoaded():Boolean {
		return (!(this.m_loader == null));
	}

	public function unloadImage():void {
		if (this.m_loader == null) {
			return;
		}
		;
		this.m_loader.cancelIfLoading();
		this.m_loader = null;
		this.m_imageData = null;
		if (this.m_tileState != null) {
			this.m_tileState.unloadImage();
		}
		;
	}

	public function loadImage():void {
		if (this.m_imagePath == null) {
			return;
		}
		;
		this.unloadImage();
		this.m_loader = new MenuImageLoader();
		this.m_loader.loadImage(this.m_imagePath, function ():void {
			var _local_1:ThumbnailScrollingListContainer;
			if (m_imageData != null) {
				m_imageData = null;
			}
			;
			m_imageData = m_loader.getImageData();
			if (m_imageData != null) {
				m_tileState.setImageFrom(m_imageData);
				_local_1 = getParentThumbnailScrollingList();
				if (((m_isFocusedOnParentList) && (!(_local_1 == null)))) {
					_local_1.onImageLoaded(m_imageData);
				}
				;
			}
			;
		});
	}

	public function setFocusedOnParentList(_arg_1:Boolean):void {
		if (_arg_1 == this.m_isFocusedOnParentList) {
			return;
		}
		;
		this.m_isFocusedOnParentList = _arg_1;
		if (this.m_isFocusedOnParentList) {
			this.onExpand(true);
		} else {
			this.onCollapse(true);
		}
		;
	}

	private function getParentThumbnailScrollingList():ThumbnailScrollingListContainer {
		if (((parent == null) || (parent.parent == null))) {
			return (null);
		}
		;
		return (parent.parent as ThumbnailScrollingListContainer);
	}

	override protected function handleSelectionChange():void {
		this.completeAnimations();
		var _local_1:ThumbnailScrollingListContainer = this.getParentThumbnailScrollingList();
		if (m_isSelected) {
			if (_local_1 != null) {
				_local_1.onItemSelected(getData(), this.m_imageData);
			}
			;
		} else {
			if (_local_1 != null) {
				_local_1.onItemUnselected();
			}
			;
		}
		;
	}

	public function setItemHover(_arg_1:Boolean):void {
		if (this.m_view.mouseOverIndicator) {
			if (((m_isSelected) || (this.m_isFocusedOnParentList))) {
				this.m_view.mouseOverIndicator.visible = false;
			} else {
				this.m_view.mouseOverIndicator.visible = _arg_1;
				this.m_view.mouseOverIndicator.alpha = 0;
				Animate.legacyTo(this.m_view.mouseOverIndicator, MenuConstants.HiliteTime, {"alpha": 1}, Animate.SineIn);
			}
			;
		}
		;
	}

	private function onExpand(_arg_1:Boolean):void {
		this.completeAnimations();
		if (this.m_view.mouseOverIndicator) {
			this.m_view.mouseOverIndicator.visible = false;
		}
		;
		this.m_view.collapsed.alpha = 0;
		this.m_view.expander.alpha = this.ExpanderAlpha;
		Animate.to(this.m_view.expander, MenuConstants.HiliteTime, 0, {"height": this.m_expandedToHeight}, Animate.SineIn, this.onExpandComplete);
	}

	public function onExpandComplete():void {
		this.m_view.expander.alpha = 0;
		this.m_view.collapsed.alpha = 0;
	}

	private function onCollapse(_arg_1:Boolean):void {
		this.completeAnimations();
		this.m_view.collapsed.alpha = 0;
		this.m_view.expander.alpha = this.ExpanderAlpha;
		Animate.to(this.m_view.expander, MenuConstants.HiliteTime, 0, {"height": this.MinimumHeight}, Animate.SineIn, this.onCollapseComplete);
	}

	private function onCollapseComplete():void {
		this.m_view.expander.alpha = 0;
		this.m_view.collapsed.alpha = 1;
	}


}
}//package menu3.basic

