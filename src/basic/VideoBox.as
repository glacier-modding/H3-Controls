// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//basic.VideoBox

package basic {
import common.BaseControl;

import flash.display.Sprite;

import common.VideoLoader;
import common.Localization;
import common.Log;
import common.CommonUtils;

public class VideoBox extends BaseControl {

	private const BASE_WIDTH:int = 1920;
	private const BASE_HEIGHT:int = 1080;

	private var m_containerVideo:Sprite;
	private var m_containerInfoBox:Sprite;
	private var m_containerObjectives:Sprite;
	private var m_containerTips:Sprite;
	private var m_containerInformation:Sprite;
	private var m_loader:VideoLoader;
	private var m_center:Boolean;
	private var m_autoplay:Boolean;
	private var m_subView:Subtitle;
	private var m_tipsView:LoadingTips;
	private var m_videoInfo:VideoBoxInfo;
	private var m_infoBoxWithBackgroundView:InfoBoxWithBackground;
	private var m_safeAreaRatio:Number;
	private var m_safeAreaScaleX:Number;
	private var m_safeAreaScaleY:Number;
	private var m_enableSubtitle:Boolean;
	private var m_subtitleFontSize:Number = 0;
	private var m_subtitleBGAlpha:Number = 0;
	private var m_screenWidth:int = 1920;
	private var m_screenHeight:int = 1080;
	private var m_bScaleToFill:Boolean = false;
	private var m_bConstrained:Boolean = false;
	private var m_bPaused:Boolean = false;
	private var m_characterNameLastShown:String = "";

	public function VideoBox() {
		this.m_containerVideo = new Sprite();
		this.m_containerVideo.width = this.BASE_WIDTH;
		this.m_containerVideo.height = this.BASE_HEIGHT;
		addChild(this.m_containerVideo);
		this.m_containerInfoBox = new Sprite();
		this.m_containerInfoBox.width = this.BASE_WIDTH;
		this.m_containerInfoBox.height = this.BASE_HEIGHT;
		addChild(this.m_containerInfoBox);
		this.m_containerObjectives = new Sprite();
		this.m_containerObjectives.width = this.BASE_WIDTH;
		this.m_containerObjectives.height = this.BASE_HEIGHT;
		addChild(this.m_containerObjectives);
		this.m_containerTips = new Sprite();
		this.m_containerTips.width = this.BASE_WIDTH;
		this.m_containerTips.height = this.BASE_HEIGHT;
		addChild(this.m_containerTips);
		this.m_containerInformation = new Sprite();
		this.m_containerInformation.width = this.BASE_WIDTH;
		this.m_containerInformation.height = this.BASE_HEIGHT;
		addChild(this.m_containerInformation);
		this.m_infoBoxWithBackgroundView = new InfoBoxWithBackground();
		this.m_infoBoxWithBackgroundView.x = 0;
		this.m_infoBoxWithBackgroundView.y = 45;
		this.m_infoBoxWithBackgroundView.visible = false;
		this.m_containerInformation.addChild(this.m_infoBoxWithBackgroundView);
		this.m_safeAreaScaleX = 1;
		this.m_safeAreaScaleY = 1;
		this.m_safeAreaRatio = 1;
		this.m_enableSubtitle = true;
		this.m_loader = new VideoLoader();
		this.m_loader.width = this.BASE_WIDTH;
		this.m_loader.height = this.BASE_HEIGHT;
		this.m_containerVideo.addChild(this.m_loader);
		this.m_loader.setSubCallback(this.onSubtitles);
		this.m_loader.setMetadataCallback(this.onMetadata);
		var _local_1:Object = {};
		_local_1["skipString"] = Localization.get("UI_MENU_ELEMENT_ACTION_SKIP");
		_local_1["loadingString"] = Localization.get("UI_DIALOG_LOADING");
		_local_1["platformString"] = ControlsMain.getControllerType();
		Log.info(Log.ChannelVideo, this, ("VideoBox Instance - Skip:" + _local_1.skipString));
		this.m_videoInfo = new VideoBoxInfo(_local_1);
		this.m_videoInfo.x = 1824;
		this.m_videoInfo.y = 1026;
		this.m_containerInfoBox.addChild(this.m_videoInfo);
		this.m_tipsView = new LoadingTips();
		this.m_containerTips.addChild(this.m_tipsView);
		this.alignTips();
		this.updatePositionAndScale();
	}

	override public function onSetConstrained(_arg_1:Boolean):void {
		if (this.m_bConstrained != _arg_1) {
			this.m_bConstrained = _arg_1;
			this.updatePause();
		}
		;
	}

	public function pause():void {
		if (this.m_bPaused) {
			return;
		}
		;
		this.m_bPaused = true;
		this.updatePause();
	}

	public function resume():void {
		if (!this.m_bPaused) {
			return;
		}
		;
		this.m_bPaused = false;
		this.updatePause();
	}

	private function updatePause():void {
		this.m_loader.setPause(((this.m_bPaused) || (this.m_bConstrained)));
	}

	public function play(rid:String):void {
		this.m_characterNameLastShown = "";
		if (ControlsMain.isVrModeActive()) {
			this.m_enableSubtitle = CommonUtils.getUIOptionValue("UI_OPTION_GRAPHICS_SUBTITLES_VR");
		} else {
			this.m_enableSubtitle = CommonUtils.getUIOptionValue("UI_OPTION_GRAPHICS_SUBTITLES");
		}
		;
		if (this.m_subView) {
			this.m_containerVideo.removeChild(this.m_subView);
			this.m_subView = null;
		}
		;
		this.m_subView = new Subtitle();
		this.m_containerVideo.addChild(this.m_subView);
		this.m_subView.onSetData("");
		this.alignSubs();
		var subtitleTrackIndex:Number = -1;
		this.m_loader.playVideo(rid, subtitleTrackIndex, function ():void {
			onStart();
		}, function ():void {
			onStop();
		});
	}

	public function startIndicatorAnim():void {
		this.m_videoInfo.startIndicatorAnim();
	}

	public function stopIndicatorAnim():void {
		this.m_videoInfo.stopIndicatorAnim();
	}

	public function setInfoState(_arg_1:String):void {
		this.m_videoInfo.setInfoState(_arg_1);
	}

	public function stop():void {
		this.m_loader.stopVideo();
	}

	public function seekabsolute(_arg_1:Number):void {
		this.m_loader.seekAbsoluteVideo(_arg_1);
	}

	public function seekoffset(_arg_1:Number):void {
		this.m_loader.seekOffsetVideo(_arg_1);
	}

	public function onSetData(_arg_1:Object):void {
		var _local_2:String = (_arg_1 as String);
		if (((_local_2) && (this.m_autoplay))) {
			this.play(_local_2);
		}
		;
	}

	public function getVideoDuration():Number {
		if (this.m_loader == null) {
			return (-1);
		}
		;
		return (this.m_loader.getVideoDuration());
	}

	public function getVideoCurrentTime():Number {
		if (this.m_loader == null) {
			return (-1);
		}
		;
		return (this.m_loader.getVideoCurrentTime());
	}

	public function onSetScaleToFill(_arg_1:Boolean):void {
		if (this.m_bScaleToFill == _arg_1) {
			return;
		}
		;
		this.m_bScaleToFill = _arg_1;
		this.updatePositionAndScale();
	}

	override public function onSetSize(_arg_1:Number, _arg_2:Number):void {
		this.m_screenWidth = _arg_1;
		this.m_screenHeight = _arg_2;
		this.updatePositionAndScale();
	}

	override public function onSetViewport(_arg_1:Number, _arg_2:Number, _arg_3:Number):void {
		if ((((this.m_safeAreaScaleX == _arg_1) && (this.m_safeAreaScaleY == _arg_2)) && (_arg_3 == this.m_safeAreaRatio))) {
			return;
		}
		;
		this.m_safeAreaRatio = _arg_3;
		this.m_safeAreaScaleX = _arg_1;
		this.m_safeAreaScaleY = _arg_2;
	}

	private function updatePositionAndScale():void {
		var _local_1:Number = Math.max((this.m_screenWidth / this.BASE_WIDTH), (this.m_screenHeight / this.BASE_HEIGHT));
		var _local_2:Number = Math.min((this.m_screenWidth / this.BASE_WIDTH), (this.m_screenHeight / this.BASE_HEIGHT));
		var _local_3:Number = 1;
		if (this.m_bScaleToFill) {
			_local_3 = _local_1;
		} else {
			_local_3 = _local_2;
		}
		;
		this.updatePositionAndScaleForObject(this.m_containerVideo, _local_3);
		this.updatePositionAndScaleForObject(this.m_containerInfoBox, _local_2);
		this.updatePositionAndScaleForObject(this.m_containerTips, _local_2);
		this.updatePositionAndScaleForObject(this.m_containerObjectives, _local_2);
		this.updatePositionAndScaleForObject(this.m_containerInformation, _local_2);
	}

	private function updatePositionAndScaleForObject(_arg_1:Sprite, _arg_2:Number):void {
		var _local_3:Number = (this.BASE_WIDTH * _arg_2);
		var _local_4:Number = (this.BASE_HEIGHT * _arg_2);
		_arg_1.scaleX = _arg_2;
		_arg_1.scaleY = _arg_2;
		_arg_1.x = ((this.m_screenWidth - _local_3) / 2);
		_arg_1.y = ((this.m_screenHeight - _local_4) / 2);
	}

	public function set CenterVideo(_arg_1:Boolean):void {
		this.m_center = _arg_1;
		this.applyCenter();
	}

	public function set Loop(_arg_1:Boolean):void {
		this.m_loader.setLoop(_arg_1);
	}

	public function set ClearOnStop(_arg_1:Boolean):void {
		this.m_loader.setClearOnStop(_arg_1);
	}

	public function set AutoPlay(_arg_1:Boolean):void {
		this.m_autoplay = _arg_1;
	}

	public function set InMemory(_arg_1:Boolean):void {
		this.m_loader.setInMemory(_arg_1);
	}

	public function get NetStream():Object {
		return (this.m_loader.getNetStream());
	}

	private function applyCenter():void {
		if (this.m_center) {
			this.m_loader.x = (-(this.m_loader.width) / 2);
			this.m_loader.y = (-(this.m_loader.height) / 2);
		}
		;
		if (this.m_subView) {
			this.alignSubs();
		}
		;
		this.alignTips();
	}

	private function onStart():void {
		this.send_OnStart();
	}

	private function onStop():void {
		this.send_OnStop();
	}

	public function send_OnStart():void {
		sendEvent("OnStart");
	}

	public function send_OnStop():void {
		sendEvent("OnStop");
	}

	public function send_Metadata(_arg_1:Object):void {
		sendEvent("OnMetadata");
	}

	public function setLoadProgress(_arg_1:Number):void {
		Log.info(Log.ChannelVideo, this, ("setting progress " + _arg_1));
		this.m_videoInfo.setLoadProgress(_arg_1);
	}

	public function setVideoInfoStateUiData(_arg_1:Object):void {
		this.m_videoInfo.setData(_arg_1);
	}

	public function setLoadingScreenData(_arg_1:Object):void {
		var _local_2:Object;
		var _local_3:Object;
		if (_arg_1 != null) {
			_local_2 = _arg_1.ObjectiveData;
			_local_3 = _arg_1.LoadingInformationData;
		}
		;
		this.setObjectiveData(_local_2);
		this.setExtraInfoData(_local_3);
	}

	public function setObjectiveData(_arg_1:Object):void {
		var _local_4:Object;
		var _local_5:LoadingScreenObjectiveTile;
		while (this.m_containerObjectives.numChildren > 0) {
			this.m_containerObjectives.removeChildAt(0);
		}
		;
		if (_arg_1 == null) {
			return;
		}
		;
		var _local_2:int;
		var _local_3:int;
		while (_local_3 < _arg_1.length) {
			if (_local_2 >= 5) {
				trace("Error: Cannot show more than 5 objctives on loading screen");
				return;
			}
			;
			_local_2++;
			_local_4 = _arg_1[_local_3];
			_local_5 = new LoadingScreenObjectiveTile();
			_local_5.x = ((79 + (_local_3 * 352)) + 1);
			_local_5.y = 292;
			_local_5.setData(_local_4);
			this.m_containerObjectives.addChild(_local_5);
			_local_3++;
		}
		;
	}

	private function setExtraInfoData(_arg_1:Object):void {
		if (_arg_1 != null) {
			this.m_infoBoxWithBackgroundView.onSetData(_arg_1);
			this.m_infoBoxWithBackgroundView.visible = true;
		} else {
			this.m_infoBoxWithBackgroundView.visible = false;
		}
		;
	}

	public function onMetadata(_arg_1:Object):void {
		this.send_Metadata(_arg_1);
	}

	public function setFontSize(_arg_1:int):void {
		if (_arg_1 < 0) {
			_arg_1 = CommonUtils.getSubtitleSize();
		}
		;
		this.m_subtitleFontSize = _arg_1;
	}

	public function setSubtitleBGAlpha(_arg_1:Number):void {
		if (_arg_1 < 0) {
			_arg_1 = CommonUtils.getSubtitleBGAlpha();
		}
		;
		this.m_subtitleBGAlpha = _arg_1;
	}

	public function onSubtitles(_arg_1:String, _arg_2:String = ""):void {
		if (!this.m_enableSubtitle) {
			Log.info(Log.ChannelVideo, this, ((("Subtitle (disabled) (Videobox): [" + _arg_2) + "] ") + _arg_1));
			return;
		}
		;
		Log.info(Log.ChannelVideo, this, ((("Subtitle (Videobox): [" + _arg_2) + "] ") + _arg_1));
		var _local_3:Object = new Object();
		_local_3.text = _arg_1;
		_local_3.fontsize = this.m_subtitleFontSize;
		_local_3.pctBGAlpha = this.m_subtitleBGAlpha;
		if ((((!(_arg_1 == null)) && (!(_arg_1 == ""))) && (!(this.m_characterNameLastShown == _arg_2)))) {
			this.m_characterNameLastShown = _arg_2;
			_local_3.characterName = _arg_2;
		}
		;
		this.m_subView.onSetData(_local_3);
	}

	private function alignSubs():void {
		this.m_subView.scaleX = (this.m_subView.scaleY = 1.25);
		this.m_subView.x = ((this.m_loader.width / 2) - ((this.m_subView.scaleX * this.m_subView.getTextFieldWidth()) / 2));
		this.m_subView.y = ((this.m_loader.height * 0.95) - 14);
	}

	public function showTip(_arg_1:String, _arg_2:Boolean):void {
		Log.info(Log.ChannelVideo, this, ("Tip" + _arg_1));
		this.m_tipsView.setBackgroundVisible(_arg_2);
		this.m_tipsView.onSetData(_arg_1);
	}

	public function hideTip():void {
		Log.info(Log.ChannelVideo, this, "Tip: Hide");
		this.m_tipsView.onSetData("");
	}

	private function alignTips():void {
		this.m_tipsView.x = (this.m_loader.width / 2);
		this.m_tipsView.y = 958;
	}


}
}//package basic

