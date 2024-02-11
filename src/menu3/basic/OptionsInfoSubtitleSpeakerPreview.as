// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.OptionsInfoSubtitleSpeakerPreview

package menu3.basic {
import flash.display.Bitmap;

import basic.Subtitle;

import hud.SubtitleSpeakerIndicator;

import common.Localization;

import flash.events.Event;

import common.CommonUtils;

import scaleform.gfx.DisplayObjectEx;

import flash.display.DisplayObject;

import common.ImageLoaderCache;

import __AS3__.vec.Vector;

import flash.display.BitmapData;

import common.Animate;

public dynamic class OptionsInfoSubtitleSpeakerPreview extends OptionsInfo {

	private var m_bitmapCinematic:Bitmap = new Bitmap();
	private var m_bitmapGameplay:Bitmap = new Bitmap();
	private var m_subtitleCinematic:Subtitle = new Subtitle();
	private var m_subtitleGameplay:Subtitle = new Subtitle();
	private var m_indicator:SubtitleSpeakerIndicator = new SubtitleSpeakerIndicator();
	private var m_ridCurrentImageCinematic:String;
	private var m_ridCurrentImageGameplay:String;
	private var m_isImmediateLoad:Boolean = false;
	private var m_lstrSpeakerName:String = Localization.get("UI_PREFERENCE_SUBTITLES_SPEAKER_INDICATOR_EXAMPLE_NAME");
	private var m_lstrSubtitleCinematic:String = Localization.get("UI_PREFERENCE_SUBTITLES_SPEAKER_INDICATOR_EXAMPLE_CINEMATIC");
	private var m_lstrSubtitleGameplay:String = Localization.get("UI_PREFERENCE_SUBTITLES_SPEAKER_INDICATOR_EXAMPLE_GAMEPLAY");

	public function OptionsInfoSubtitleSpeakerPreview(_arg_1:Object) {
		super(_arg_1);
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
		this.onSetData(_arg_1);
	}

	override public function onSetData(data:Object):void {
		var optionSubtitleFontSize:Number;
		var optionSubtitleBGAlpha:Number;
		var optionSubtitleSpeaker:Boolean;
		var/*const*/ pxBGWidth:Number = NaN;
		var/*const*/ pxBGHeight:Number = NaN;
		super.onSetData(data);
		optionSubtitleFontSize = CommonUtils.getUIOptionValueNumber("UI_OPTION_GRAPHICS_SUBTITLES_SIZE");
		optionSubtitleBGAlpha = CommonUtils.getUIOptionValueNumber("UI_OPTION_GRAPHICS_SUBTITLES_BGALPHA");
		optionSubtitleSpeaker = CommonUtils.getUIOptionValue("UI_OPTION_GRAPHICS_SUBTITLES_SPEAKER");
		DisplayObjectEx.skipNextMatrixLerp(this.m_subtitleCinematic);
		DisplayObjectEx.skipNextMatrixLerp(this.m_subtitleGameplay);
		this.m_bitmapGameplay.y = ((m_view.paragraph.y + m_view.paragraph.textHeight) + 35);
		this.m_bitmapCinematic.y = (this.m_bitmapGameplay.y + ((((OptionsInfoPreview.PX_PREVIEW_BACKGROUND_WIDTH / 1920) * 1080) / 2) * 0.85));
		this.m_bitmapGameplay.x = (OptionsInfoPreview.PX_PREVIEW_BACKGROUND_WIDTH * (1 - 0.85));
		this.m_indicator.x = (this.m_bitmapGameplay.x + 323);
		this.m_indicator.y = (this.m_bitmapGameplay.y + 124);
		this.m_isImmediateLoad = true;
		this.m_ridCurrentImageCinematic = this.loadImage(this.m_ridCurrentImageCinematic, data.previewData.ridImageCinematic, this.onImageCinematicLoadSucceeded, new <DisplayObject>[this.m_bitmapCinematic, this.m_subtitleCinematic]);
		this.m_ridCurrentImageGameplay = this.loadImage(this.m_ridCurrentImageGameplay, data.previewData.ridImageGameplay, this.onImageGameplayLoadSucceeded, new <DisplayObject>[this.m_bitmapGameplay, this.m_subtitleGameplay, this.m_indicator]);
		this.m_isImmediateLoad = false;
		pxBGWidth = (OptionsInfoPreview.PX_PREVIEW_BACKGROUND_WIDTH * 0.85);
		pxBGHeight = (((OptionsInfoPreview.PX_PREVIEW_BACKGROUND_WIDTH / 1920) * 1080) * 0.85);
		var applySubtitle:Function = function (_arg_1:Bitmap, _arg_2:Subtitle, _arg_3:String, _arg_4:String):void {
			var _local_5:Number = ((pxBGWidth / 1920) * 1.95);
			_arg_2.onSetSize(800, 100);
			_arg_2.scaleX = _local_5;
			_arg_2.scaleY = _local_5;
			_arg_2.x = ((_arg_1.x + (pxBGWidth / 2)) - ((_local_5 * 800) / 2));
			_arg_2.y = ((_arg_1.y + pxBGHeight) - 20);
			_arg_2.onSetData({
				"characterName": ((optionSubtitleSpeaker) ? _arg_3 : null),
				"text": _arg_4,
				"fontsize": (Subtitle.MIN_FONT_SIZE + ((optionSubtitleFontSize - Subtitle.MIN_FONT_SIZE) / 2)),
				"pctBGAlpha": optionSubtitleBGAlpha
			});
		};
		(applySubtitle(this.m_bitmapCinematic, this.m_subtitleCinematic, this.m_lstrSpeakerName, this.m_lstrSubtitleCinematic));
		(applySubtitle(this.m_bitmapGameplay, this.m_subtitleGameplay, null, this.m_lstrSubtitleGameplay));
		if (!optionSubtitleSpeaker) {
			this.m_indicator.hideIcon();
		} else {
			this.m_indicator.showNewIcon(SubtitleSpeakerIndicator.ICON_BUBBLE_BR);
			this.m_indicator.scaleX = 0.85;
			this.m_indicator.scaleY = 0.85;
		}

	}

	private function loadImage(_arg_1:String, _arg_2:String, _arg_3:Function, _arg_4:Vector.<DisplayObject> = null):String {
		var _local_5:DisplayObject;
		if (_arg_2 == _arg_1) {
			return (_arg_1);
		}

		if (_arg_1) {
			ImageLoaderCache.getGlobalInstance().unregisterLoadImage(_arg_1, _arg_3);
		}

		if (_arg_4) {
			for each (_local_5 in _arg_4) {
				_local_5.visible = false;
			}

		}

		_arg_1 = _arg_2;
		if (_arg_1) {
			ImageLoaderCache.getGlobalInstance().registerLoadImage(_arg_1, _arg_3);
		}

		return (_arg_1);
	}

	private function onImageCinematicLoadSucceeded(_arg_1:BitmapData):void {
		this.onImageLoadSucceeded(this.m_bitmapCinematic, _arg_1, new <DisplayObject>[this.m_bitmapCinematic, this.m_subtitleCinematic]);
	}

	private function onImageGameplayLoadSucceeded(_arg_1:BitmapData):void {
		this.onImageLoadSucceeded(this.m_bitmapGameplay, _arg_1, new <DisplayObject>[this.m_bitmapGameplay, this.m_subtitleGameplay, this.m_indicator]);
	}

	private function onImageLoadSucceeded(_arg_1:Bitmap, _arg_2:BitmapData, _arg_3:Vector.<DisplayObject>):void {
		var _local_4:DisplayObject;
		_arg_1.bitmapData = _arg_2;
		_arg_1.width = (OptionsInfoPreview.PX_PREVIEW_BACKGROUND_WIDTH * 0.85);
		_arg_1.scaleY = _arg_1.scaleX;
		for each (_local_4 in _arg_3) {
			_local_4.visible = true;
			if (!this.m_isImmediateLoad) {
				_local_4.alpha = 0;
				Animate.to(_local_4, 0.25, 0, {"alpha": 1}, Animate.SineOut);
			}

		}

	}

	protected function onPreviewRemovedFromStage():void {
		this.m_ridCurrentImageCinematic = this.loadImage(this.m_ridCurrentImageCinematic, null, this.onImageCinematicLoadSucceeded);
		this.m_ridCurrentImageGameplay = this.loadImage(this.m_ridCurrentImageGameplay, null, this.onImageGameplayLoadSucceeded);
	}


}
}//package menu3.basic

