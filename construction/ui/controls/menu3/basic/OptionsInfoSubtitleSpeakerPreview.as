package menu3.basic
{
	import basic.Subtitle;
	import common.Animate;
	import common.CommonUtils;
	import common.ImageLoaderCache;
	import common.Localization;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import hud.SubtitleSpeakerIndicator;
	import scaleform.gfx.DisplayObjectEx;
	
	public dynamic class OptionsInfoSubtitleSpeakerPreview extends OptionsInfo
	{
		
		private var m_bitmapCinematic:Bitmap;
		
		private var m_bitmapGameplay:Bitmap;
		
		private var m_subtitleCinematic:Subtitle;
		
		private var m_subtitleGameplay:Subtitle;
		
		private var m_indicator:SubtitleSpeakerIndicator;
		
		private var m_ridCurrentImageCinematic:String;
		
		private var m_ridCurrentImageGameplay:String;
		
		private var m_isImmediateLoad:Boolean = false;
		
		private var m_lstrSpeakerName:String;
		
		private var m_lstrSubtitleCinematic:String;
		
		private var m_lstrSubtitleGameplay:String;
		
		public function OptionsInfoSubtitleSpeakerPreview(param1:Object)
		{
			this.m_bitmapCinematic = new Bitmap();
			this.m_bitmapGameplay = new Bitmap();
			this.m_subtitleCinematic = new Subtitle();
			this.m_subtitleGameplay = new Subtitle();
			this.m_indicator = new SubtitleSpeakerIndicator();
			this.m_lstrSpeakerName = Localization.get("UI_PREFERENCE_SUBTITLES_SPEAKER_INDICATOR_EXAMPLE_NAME");
			this.m_lstrSubtitleCinematic = Localization.get("UI_PREFERENCE_SUBTITLES_SPEAKER_INDICATOR_EXAMPLE_CINEMATIC");
			this.m_lstrSubtitleGameplay = Localization.get("UI_PREFERENCE_SUBTITLES_SPEAKER_INDICATOR_EXAMPLE_GAMEPLAY");
			super(param1);
			this.m_bitmapCinematic.name = "m_bitmapCinematic";
			this.m_bitmapGameplay.name = "m_bitmapGameplay";
			this.m_subtitleCinematic.name = "m_subtitleCinematic";
			this.m_subtitleGameplay.name = "m_subtitleGameplay";
			this.m_indicator.name = "m_indicator";
			m_view.addChild(this.m_bitmapCinematic);
			m_view.addChild(this.m_bitmapGameplay);
			m_view.addChild(this.m_subtitleCinematic);
			m_view.addChild(this.m_subtitleGameplay);
			m_view.addChild(this.m_indicator);
			this.m_subtitleCinematic.isAntiFreakoutDisabled = true;
			this.m_subtitleGameplay.isAntiFreakoutDisabled = true;
			this.m_indicator.setCinematicMode(0);
			addEventListener(Event.REMOVED_FROM_STAGE, this.onPreviewRemovedFromStage);
			this.onSetData(param1);
		}
		
		override public function onSetData(param1:Object):void
		{
			var applySubtitle:Function;
			var optionSubtitleFontSize:Number = NaN;
			var optionSubtitleBGAlpha:Number = NaN;
			var optionSubtitleSpeaker:Boolean = false;
			var pxBGWidth:Number = NaN;
			var pxBGHeight:Number = NaN;
			var data:Object = param1;
			super.onSetData(data);
			optionSubtitleFontSize = CommonUtils.getUIOptionValueNumber("UI_OPTION_GRAPHICS_SUBTITLES_SIZE");
			optionSubtitleBGAlpha = CommonUtils.getUIOptionValueNumber("UI_OPTION_GRAPHICS_SUBTITLES_BGALPHA");
			optionSubtitleSpeaker = CommonUtils.getUIOptionValue("UI_OPTION_GRAPHICS_SUBTITLES_SPEAKER");
			DisplayObjectEx.skipNextMatrixLerp(this.m_subtitleCinematic);
			DisplayObjectEx.skipNextMatrixLerp(this.m_subtitleGameplay);
			this.m_bitmapGameplay.y = m_view.paragraph.y + m_view.paragraph.textHeight + 35;
			this.m_bitmapCinematic.y = this.m_bitmapGameplay.y + OptionsInfoPreview.PX_PREVIEW_BACKGROUND_WIDTH / 1920 * 1080 / 2 * 0.85;
			this.m_bitmapGameplay.x = OptionsInfoPreview.PX_PREVIEW_BACKGROUND_WIDTH * (1 - 0.85);
			this.m_indicator.x = this.m_bitmapGameplay.x + 323;
			this.m_indicator.y = this.m_bitmapGameplay.y + 124;
			this.m_isImmediateLoad = true;
			this.m_ridCurrentImageCinematic = this.loadImage(this.m_ridCurrentImageCinematic, data.previewData.ridImageCinematic, this.onImageCinematicLoadSucceeded, new <DisplayObject>[this.m_bitmapCinematic, this.m_subtitleCinematic]);
			this.m_ridCurrentImageGameplay = this.loadImage(this.m_ridCurrentImageGameplay, data.previewData.ridImageGameplay, this.onImageGameplayLoadSucceeded, new <DisplayObject>[this.m_bitmapGameplay, this.m_subtitleGameplay, this.m_indicator]);
			this.m_isImmediateLoad = false;
			pxBGWidth = OptionsInfoPreview.PX_PREVIEW_BACKGROUND_WIDTH * 0.85;
			pxBGHeight = OptionsInfoPreview.PX_PREVIEW_BACKGROUND_WIDTH / 1920 * 1080 * 0.85;
			applySubtitle = function(param1:Bitmap, param2:Subtitle, param3:String, param4:String):void
			{
				var _loc5_:Number = pxBGWidth / 1920 * 1.95;
				param2.onSetSize(800, 100);
				param2.scaleX = _loc5_;
				param2.scaleY = _loc5_;
				param2.x = param1.x + pxBGWidth / 2 - _loc5_ * 800 / 2;
				param2.y = param1.y + pxBGHeight - 20;
				param2.onSetData({"characterName": (optionSubtitleSpeaker ? param3 : null), "text": param4, "fontsize": Subtitle.MIN_FONT_SIZE + (optionSubtitleFontSize - Subtitle.MIN_FONT_SIZE) / 2, "pctBGAlpha": optionSubtitleBGAlpha});
			};
			applySubtitle(this.m_bitmapCinematic, this.m_subtitleCinematic, this.m_lstrSpeakerName, this.m_lstrSubtitleCinematic);
			applySubtitle(this.m_bitmapGameplay, this.m_subtitleGameplay, null, this.m_lstrSubtitleGameplay);
			if (!optionSubtitleSpeaker)
			{
				this.m_indicator.hideIcon();
			}
			else
			{
				this.m_indicator.showNewIcon(SubtitleSpeakerIndicator.ICON_BUBBLE_BR);
				this.m_indicator.scaleX = 0.85;
				this.m_indicator.scaleY = 0.85;
			}
		}
		
		private function loadImage(param1:String, param2:String, param3:Function, param4:Vector.<DisplayObject> = null):String
		{
			var _loc5_:DisplayObject = null;
			if (param2 == param1)
			{
				return param1;
			}
			if (param1)
			{
				ImageLoaderCache.getGlobalInstance().unregisterLoadImage(param1, param3);
			}
			if (param4)
			{
				for each (_loc5_ in param4)
				{
					_loc5_.visible = false;
				}
			}
			param1 = param2;
			if (param1)
			{
				ImageLoaderCache.getGlobalInstance().registerLoadImage(param1, param3);
			}
			return param1;
		}
		
		private function onImageCinematicLoadSucceeded(param1:BitmapData):void
		{
			this.onImageLoadSucceeded(this.m_bitmapCinematic, param1, new <DisplayObject>[this.m_bitmapCinematic, this.m_subtitleCinematic]);
		}
		
		private function onImageGameplayLoadSucceeded(param1:BitmapData):void
		{
			this.onImageLoadSucceeded(this.m_bitmapGameplay, param1, new <DisplayObject>[this.m_bitmapGameplay, this.m_subtitleGameplay, this.m_indicator]);
		}
		
		private function onImageLoadSucceeded(param1:Bitmap, param2:BitmapData, param3:Vector.<DisplayObject>):void
		{
			var _loc4_:DisplayObject = null;
			param1.bitmapData = param2;
			param1.width = OptionsInfoPreview.PX_PREVIEW_BACKGROUND_WIDTH * 0.85;
			param1.scaleY = param1.scaleX;
			for each (_loc4_ in param3)
			{
				_loc4_.visible = true;
				if (!this.m_isImmediateLoad)
				{
					_loc4_.alpha = 0;
					Animate.to(_loc4_, 0.25, 0, {"alpha": 1}, Animate.SineOut);
				}
			}
		}
		
		protected function onPreviewRemovedFromStage():void
		{
			this.m_ridCurrentImageCinematic = this.loadImage(this.m_ridCurrentImageCinematic, null, this.onImageCinematicLoadSucceeded);
			this.m_ridCurrentImageGameplay = this.loadImage(this.m_ridCurrentImageGameplay, null, this.onImageGameplayLoadSucceeded);
		}
	}
}
