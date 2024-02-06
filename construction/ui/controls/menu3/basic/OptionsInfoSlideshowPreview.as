package menu3.basic
{
	import common.Animate;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	public dynamic class OptionsInfoSlideshowPreview extends OptionsInfo
	{
		
		public static const Dir_Forward:int = 1;
		
		public static const Dir_Backward:int = -1;
		
		private var m_previewContentContainer:Sprite;
		
		private var m_frameBitmap:Bitmap;
		
		private var m_frames:Vector.<Frame>;
		
		private var m_msAnimationOrigin:int;
		
		private var m_isImmediateLoad:Boolean = false;
		
		private var m_msDurationTotal:int = 0;
		
		private var m_isPingPong:Boolean = true;
		
		private var m_isLockedAtFirstFrame:Boolean = false;
		
		private var m_iCurrentFrame:int = 0;
		
		private var m_labelCurrentFrame:String = null;
		
		private var m_dirCurrent:int = 1;
		
		public function OptionsInfoSlideshowPreview(param1:Object)
		{
			this.m_previewContentContainer = new Sprite();
			this.m_frameBitmap = new Bitmap();
			super(param1);
			this.m_frameBitmap.name = "m_frameBitmap";
			m_view.addChild(this.m_frameBitmap);
			this.m_previewContentContainer.name = "m_previewContentContainer";
			m_view.addChild(this.m_previewContentContainer);
			addEventListener(Event.REMOVED_FROM_STAGE, this.onPreviewRemovedFromStage);
			addEventListener(Event.ENTER_FRAME, this.updateSlideshowFrame);
			this.m_msAnimationOrigin = getTimer();
			this.onSetData(param1);
		}
		
		public function get msDurationTotal():int
		{
			return this.m_msDurationTotal;
		}
		
		public function get isPingPong():Boolean
		{
			return this.m_isPingPong;
		}
		
		public function get isLockedAtFirstFrame():Boolean
		{
			return this.m_isLockedAtFirstFrame;
		}
		
		public function get iCurrentFrame():int
		{
			return this.m_iCurrentFrame;
		}
		
		public function get nFrames():int
		{
			return !!this.m_frames ? int(this.m_frames.length) : 0;
		}
		
		public function get dirCurrent():int
		{
			return this.m_dirCurrent;
		}
		
		public function getPreviewContentContainer():Sprite
		{
			return this.m_previewContentContainer;
		}
		
		override public function onSetData(param1:Object):void
		{
			var framesNew:Vector.<Frame> = null;
			var data:Object = param1;
			super.onSetData(data);
			this.m_frameBitmap.y = m_view.paragraph.y + m_view.paragraph.textHeight + 35;
			this.m_previewContentContainer.y = this.m_frameBitmap.y;
			this.m_previewContentContainer.visible = false;
			if (Boolean(data.previewData) && Boolean(data.previewData.slideshowFrames) && data.previewData.slideshowFrames.length > 0)
			{
				framesNew = new Vector.<Frame>();
				this.m_msDurationTotal = 0;
				data.previewData.slideshowFrames.forEach(function(param1:Object):void
				{
					var _loc2_:int = m_msDurationTotal;
					var _loc3_:int = m_msDurationTotal + param1.msDuration;
					var _loc4_:Frame = new Frame(param1.rid, _loc2_, _loc3_, param1.label);
					framesNew.push(_loc4_);
					m_msDurationTotal = _loc3_;
				});
			}
			else if (data.backgroundImage)
			{
				framesNew = new <Frame>[new Frame(data.backgroundImage, 0, 1, null)];
				this.m_msDurationTotal = 1;
			}
			if (this.m_frames)
			{
				this.m_frames.forEach(function(param1:Frame):void
				{
					if (m_frameBitmap.bitmapData == param1.bitmapData)
					{
						m_frameBitmap.bitmapData = null;
					}
					param1.unloadImage();
				});
			}
			this.m_frames = framesNew;
			this.m_isPingPong = Boolean(data.previewData) && Boolean(data.previewData.isPingPong);
			this.m_isLockedAtFirstFrame = Boolean(data.previewData) && Boolean(data.previewData.isLockedAtFirstFrame);
			this.m_isImmediateLoad = true;
			this.updateSlideshowFrame();
			this.m_isImmediateLoad = false;
		}
		
		private function updateSlideshowFrame():void
		{
			var _loc6_:int = 0;
			var _loc11_:Frame = null;
			var _loc12_:DisplayObject = null;
			var _loc1_:int = this.m_iCurrentFrame;
			var _loc2_:String = this.m_labelCurrentFrame;
			var _loc3_:int = this.m_dirCurrent;
			if (!this.m_frames || this.m_frames.length == 0)
			{
				this.m_previewContentContainer.visible = true;
				this.m_iCurrentFrame = 0;
				if (this.m_labelCurrentFrame)
				{
					this.onPreviewSlideshowExitedFrameLabel(this.m_labelCurrentFrame);
					this.m_labelCurrentFrame = null;
				}
				return;
			}
			var _loc4_:int = int(this.m_frames.length - 1);
			var _loc5_:int = getTimer();
			if (this.m_isLockedAtFirstFrame)
			{
				this.m_msAnimationOrigin = _loc5_;
			}
			this.m_dirCurrent = Dir_Forward;
			if (!this.m_isPingPong)
			{
				_loc6_ = (_loc5_ - this.m_msAnimationOrigin) % this.m_msDurationTotal;
			}
			else if ((_loc6_ = (_loc5_ - this.m_msAnimationOrigin) % (2 * this.m_msDurationTotal)) >= this.m_msDurationTotal)
			{
				_loc6_ = 2 * this.m_msDurationTotal - _loc6_ - 1;
				this.m_dirCurrent = Dir_Backward;
			}
			var _loc7_:int = 0;
			while (_loc7_ < this.m_frames.length)
			{
				_loc11_ = this.m_frames[_loc7_];
				if (_loc6_ >= _loc11_.msBegin && _loc6_ < _loc11_.msEnd)
				{
					this.m_frameBitmap.bitmapData = _loc11_.bitmapData;
					this.m_frameBitmap.width = OptionsInfoPreview.PX_PREVIEW_BACKGROUND_WIDTH;
					this.m_frameBitmap.scaleY = this.m_frameBitmap.scaleX;
					this.m_iCurrentFrame = _loc7_;
					this.m_labelCurrentFrame = _loc11_.label;
				}
				_loc7_++;
			}
			var _loc8_:int = _loc1_;
			var _loc9_:int = _loc3_;
			var _loc10_:String = _loc2_;
			while (!this.areFramesSynchronized(_loc8_, _loc9_, this.m_iCurrentFrame, this.m_dirCurrent))
			{
				if (_loc10_)
				{
					this.onPreviewSlideshowExitedFrameLabel(_loc10_);
				}
				if (_loc8_ <= 0 && _loc9_ == Dir_Backward)
				{
					if (this.m_isPingPong)
					{
						_loc9_ = Dir_Forward;
						_loc8_ += _loc9_;
					}
					else
					{
						_loc8_ = _loc4_;
					}
				}
				else if (_loc8_ >= _loc4_ && _loc9_ == Dir_Forward)
				{
					if (this.m_isPingPong)
					{
						_loc9_ = Dir_Backward;
						_loc8_ += _loc9_;
					}
					else
					{
						_loc8_ = 0;
					}
				}
				else
				{
					_loc8_ += _loc9_;
				}
				if (_loc10_ = this.m_frames[_loc8_].label)
				{
					this.onPreviewSlideshowEnteredFrameLabel(_loc10_);
				}
			}
			if (!this.m_previewContentContainer.visible)
			{
				this.m_previewContentContainer.visible = this.m_frames[0].isLoaded;
				if (!this.m_isImmediateLoad)
				{
					for each (_loc12_ in[this.m_previewContentContainer, this.m_frameBitmap])
					{
						_loc12_.alpha = 0;
						Animate.to(_loc12_, 0.25, 0, {"alpha": 1}, Animate.SineOut);
					}
				}
			}
		}
		
		private function areFramesSynchronized(param1:int, param2:int, param3:int, param4:int):Boolean
		{
			if (param1 == 0 && param3 == 0)
			{
				return true;
			}
			var _loc5_:int = int(this.m_frames.length - 1);
			if (param1 == _loc5_ && param3 == _loc5_)
			{
				return true;
			}
			return param1 == param3 && param2 == param4;
		}
		
		protected function onPreviewSlideshowEnteredFrameLabel(param1:String):void
		{
		}
		
		protected function onPreviewSlideshowExitedFrameLabel(param1:String):void
		{
		}
		
		protected function onPreviewRemovedFromStage():void
		{
			removeEventListener(Event.ENTER_FRAME, this.updateSlideshowFrame);
			setTimeout(function():void
			{
				var _loc1_:Frame = null;
				if (m_frames)
				{
					for each (_loc1_ in m_frames)
					{
						if (m_frameBitmap.bitmapData == _loc1_.bitmapData)
						{
							m_frameBitmap.bitmapData = null;
						}
						_loc1_.unloadImage();
					}
					m_frames = null;
				}
			}, 1000 / 20);
		}
	}
}

import common.ImageLoaderCache;
import flash.display.BitmapData;

class Frame
{
	
	private var m_rid:String;
	
	private var m_bitmapData:BitmapData;
	
	private var m_msBegin:int;
	
	private var m_msEnd:int;
	
	private var m_isLoaded:Boolean = false;
	
	private var m_label:String;
	
	public function Frame(param1:String, param2:Number, param3:Number, param4:String)
	{
		super();
		this.m_rid = param1;
		this.m_msBegin = param2;
		this.m_msEnd = param3;
		this.m_label = param4;
		ImageLoaderCache.getGlobalInstance().registerLoadImage(this.m_rid, this.onImageLoadSucceeded);
	}
	
	public function get rid():String
	{
		return this.m_rid;
	}
	
	public function get bitmapData():BitmapData
	{
		return this.m_bitmapData;
	}
	
	public function get msBegin():int
	{
		return this.m_msBegin;
	}
	
	public function get msEnd():int
	{
		return this.m_msEnd;
	}
	
	public function get isLoaded():Boolean
	{
		return this.m_isLoaded;
	}
	
	public function get label():String
	{
		return this.m_label;
	}
	
	private function onImageLoadSucceeded(param1:BitmapData):void
	{
		this.m_bitmapData = param1;
		this.m_isLoaded = true;
	}
	
	public function unloadImage():void
	{
		ImageLoaderCache.getGlobalInstance().unregisterLoadImage(this.m_rid, this.onImageLoadSucceeded);
	}
}
