// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.OptionsInfoSlideshowPreview

package menu3.basic {
import flash.display.Sprite;
import flash.display.Bitmap;

import __AS3__.vec.Vector;

import flash.events.Event;
import flash.utils.getTimer;
import flash.display.DisplayObject;

import common.Animate;

import flash.utils.setTimeout;

import __AS3__.vec.*;

public dynamic class OptionsInfoSlideshowPreview extends OptionsInfo {

	public static const Dir_Forward:int = 1;
	public static const Dir_Backward:int = -1;

	private var m_previewContentContainer:Sprite = new Sprite();
	private var m_frameBitmap:Bitmap = new Bitmap();
	private var m_frames:Vector.<Frame>;
	private var m_msAnimationOrigin:int;
	private var m_isImmediateLoad:Boolean = false;
	private var m_msDurationTotal:int = 0;
	private var m_isPingPong:Boolean = true;
	private var m_isLockedAtFirstFrame:Boolean = false;
	private var m_iCurrentFrame:int = 0;
	private var m_labelCurrentFrame:String = null;
	private var m_dirCurrent:int = 1;

	public function OptionsInfoSlideshowPreview(_arg_1:Object) {
		super(_arg_1);
		this.m_frameBitmap.name = "m_frameBitmap";
		m_view.addChild(this.m_frameBitmap);
		this.m_previewContentContainer.name = "m_previewContentContainer";
		m_view.addChild(this.m_previewContentContainer);
		addEventListener(Event.REMOVED_FROM_STAGE, this.onPreviewRemovedFromStage);
		addEventListener(Event.ENTER_FRAME, this.updateSlideshowFrame);
		this.m_msAnimationOrigin = getTimer();
		this.onSetData(_arg_1);
	}

	public function get msDurationTotal():int {
		return (this.m_msDurationTotal);
	}

	public function get isPingPong():Boolean {
		return (this.m_isPingPong);
	}

	public function get isLockedAtFirstFrame():Boolean {
		return (this.m_isLockedAtFirstFrame);
	}

	public function get iCurrentFrame():int {
		return (this.m_iCurrentFrame);
	}

	public function get nFrames():int {
		return ((this.m_frames) ? this.m_frames.length : 0);
	}

	public function get dirCurrent():int {
		return (this.m_dirCurrent);
	}

	public function getPreviewContentContainer():Sprite {
		return (this.m_previewContentContainer);
	}

	override public function onSetData(data:Object):void {
		var framesNew:Vector.<Frame>;
		super.onSetData(data);
		this.m_frameBitmap.y = ((m_view.paragraph.y + m_view.paragraph.textHeight) + 35);
		this.m_previewContentContainer.y = this.m_frameBitmap.y;
		this.m_previewContentContainer.visible = false;
		if ((((data.previewData) && (data.previewData.slideshowFrames)) && (data.previewData.slideshowFrames.length > 0))) {
			framesNew = new Vector.<Frame>();
			this.m_msDurationTotal = 0;
			data.previewData.slideshowFrames.forEach(function (_arg_1:Object):void {
				var _local_2:int = m_msDurationTotal;
				var _local_3:int = (m_msDurationTotal + _arg_1.msDuration);
				var _local_4:Frame = new Frame(_arg_1.rid, _local_2, _local_3, _arg_1.label);
				framesNew.push(_local_4);
				m_msDurationTotal = _local_3;
			});
		} else {
			if (data.backgroundImage) {
				framesNew = new <Frame>[new Frame(data.backgroundImage, 0, 1, null)];
				this.m_msDurationTotal = 1;
			}
			;
		}
		;
		if (this.m_frames) {
			this.m_frames.forEach(function (_arg_1:Frame):void {
				if (m_frameBitmap.bitmapData == _arg_1.bitmapData) {
					m_frameBitmap.bitmapData = null;
				}
				;
				_arg_1.unloadImage();
			});
		}
		;
		this.m_frames = framesNew;
		this.m_isPingPong = ((data.previewData) && (data.previewData.isPingPong));
		this.m_isLockedAtFirstFrame = ((data.previewData) && (data.previewData.isLockedAtFirstFrame));
		this.m_isImmediateLoad = true;
		this.updateSlideshowFrame();
		this.m_isImmediateLoad = false;
	}

	private function updateSlideshowFrame():void {
		var _local_6:int;
		var _local_11:Frame;
		var _local_12:DisplayObject;
		var _local_1:int = this.m_iCurrentFrame;
		var _local_2:String = this.m_labelCurrentFrame;
		var _local_3:int = this.m_dirCurrent;
		if (((!(this.m_frames)) || (this.m_frames.length == 0))) {
			this.m_previewContentContainer.visible = true;
			this.m_iCurrentFrame = 0;
			if (this.m_labelCurrentFrame) {
				this.onPreviewSlideshowExitedFrameLabel(this.m_labelCurrentFrame);
				this.m_labelCurrentFrame = null;
			}
			;
			return;
		}
		;
		var _local_4:int = (this.m_frames.length - 1);
		var _local_5:int = getTimer();
		if (this.m_isLockedAtFirstFrame) {
			this.m_msAnimationOrigin = _local_5;
		}
		;
		this.m_dirCurrent = Dir_Forward;
		if (!this.m_isPingPong) {
			_local_6 = ((_local_5 - this.m_msAnimationOrigin) % this.m_msDurationTotal);
		} else {
			_local_6 = ((_local_5 - this.m_msAnimationOrigin) % (2 * this.m_msDurationTotal));
			if (_local_6 >= this.m_msDurationTotal) {
				_local_6 = (((2 * this.m_msDurationTotal) - _local_6) - 1);
				this.m_dirCurrent = Dir_Backward;
			}
			;
		}
		;
		var _local_7:int;
		while (_local_7 < this.m_frames.length) {
			_local_11 = this.m_frames[_local_7];
			if (((_local_6 >= _local_11.msBegin) && (_local_6 < _local_11.msEnd))) {
				this.m_frameBitmap.bitmapData = _local_11.bitmapData;
				this.m_frameBitmap.width = OptionsInfoPreview.PX_PREVIEW_BACKGROUND_WIDTH;
				this.m_frameBitmap.scaleY = this.m_frameBitmap.scaleX;
				this.m_iCurrentFrame = _local_7;
				this.m_labelCurrentFrame = _local_11.label;
			}
			;
			_local_7++;
		}
		;
		var _local_8:int = _local_1;
		var _local_9:int = _local_3;
		var _local_10:String = _local_2;
		while ((!(this.areFramesSynchronized(_local_8, _local_9, this.m_iCurrentFrame, this.m_dirCurrent)))) {
			if (_local_10) {
				this.onPreviewSlideshowExitedFrameLabel(_local_10);
			}
			;
			if (((_local_8 <= 0) && (_local_9 == Dir_Backward))) {
				if (this.m_isPingPong) {
					_local_9 = Dir_Forward;
					_local_8 = (_local_8 + _local_9);
				} else {
					_local_8 = _local_4;
				}
				;
			} else {
				if (((_local_8 >= _local_4) && (_local_9 == Dir_Forward))) {
					if (this.m_isPingPong) {
						_local_9 = Dir_Backward;
						_local_8 = (_local_8 + _local_9);
					} else {
						_local_8 = 0;
					}
					;
				} else {
					_local_8 = (_local_8 + _local_9);
				}
				;
			}
			;
			_local_10 = this.m_frames[_local_8].label;
			if (_local_10) {
				this.onPreviewSlideshowEnteredFrameLabel(_local_10);
			}
			;
		}
		;
		if (!this.m_previewContentContainer.visible) {
			this.m_previewContentContainer.visible = this.m_frames[0].isLoaded;
			if (!this.m_isImmediateLoad) {
				for each (_local_12 in [this.m_previewContentContainer, this.m_frameBitmap]) {
					_local_12.alpha = 0;
					Animate.to(_local_12, 0.25, 0, {"alpha": 1}, Animate.SineOut);
				}
				;
			}
			;
		}
		;
	}

	private function areFramesSynchronized(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int):Boolean {
		if (((_arg_1 == 0) && (_arg_3 == 0))) {
			return (true);
		}
		;
		var _local_5:int = (this.m_frames.length - 1);
		if (((_arg_1 == _local_5) && (_arg_3 == _local_5))) {
			return (true);
		}
		;
		return ((_arg_1 == _arg_3) && (_arg_2 == _arg_4));
	}

	protected function onPreviewSlideshowEnteredFrameLabel(_arg_1:String):void {
	}

	protected function onPreviewSlideshowExitedFrameLabel(_arg_1:String):void {
	}

	protected function onPreviewRemovedFromStage():void {
		removeEventListener(Event.ENTER_FRAME, this.updateSlideshowFrame);
		setTimeout(function ():void {
			var _local_1:Frame;
			if (m_frames) {
				for each (_local_1 in m_frames) {
					if (m_frameBitmap.bitmapData == _local_1.bitmapData) {
						m_frameBitmap.bitmapData = null;
					}
					;
					_local_1.unloadImage();
				}
				;
				m_frames = null;
			}
			;
		}, (1000 / 20));
	}


}
}//package menu3.basic

import flash.display.BitmapData;

import common.ImageLoaderCache;

class Frame {

	/*private*/
	var m_rid:String;
	/*private*/
	var m_bitmapData:BitmapData;
	/*private*/
	var m_msBegin:int;
	/*private*/
	var m_msEnd:int;
	/*private*/
	var m_isLoaded:Boolean = false;
	/*private*/
	var m_label:String;

	public function Frame(_arg_1:String, _arg_2:Number, _arg_3:Number, _arg_4:String) {
		this.m_rid = _arg_1;
		this.m_msBegin = _arg_2;
		this.m_msEnd = _arg_3;
		this.m_label = _arg_4;
		ImageLoaderCache.getGlobalInstance().registerLoadImage(this.m_rid, this.onImageLoadSucceeded);
	}

	public function get rid():String {
		return (this.m_rid);
	}

	public function get bitmapData():BitmapData {
		return (this.m_bitmapData);
	}

	public function get msBegin():int {
		return (this.m_msBegin);
	}

	public function get msEnd():int {
		return (this.m_msEnd);
	}

	public function get isLoaded():Boolean {
		return (this.m_isLoaded);
	}

	public function get label():String {
		return (this.m_label);
	}

	/*private*/
	function onImageLoadSucceeded(_arg_1:BitmapData):void {
		this.m_bitmapData = _arg_1;
		this.m_isLoaded = true;
	}

	public function unloadImage():void {
		ImageLoaderCache.getGlobalInstance().unregisterLoadImage(this.m_rid, this.onImageLoadSucceeded);
	}


}


