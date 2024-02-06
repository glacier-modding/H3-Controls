package basic
{
   import common.BaseControl;
   import common.CommonUtils;
   import common.Localization;
   import common.Log;
   import common.VideoLoader;
   import flash.display.Sprite;
   
   public class VideoBox extends BaseControl
   {
       
      
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
      
      public function VideoBox()
      {
         super();
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
         var _loc1_:Object = {};
         _loc1_["skipString"] = Localization.get("UI_MENU_ELEMENT_ACTION_SKIP");
         _loc1_["loadingString"] = Localization.get("UI_DIALOG_LOADING");
         _loc1_["platformString"] = ControlsMain.getControllerType();
         Log.info(Log.ChannelVideo,this,"VideoBox Instance - Skip:" + _loc1_.skipString);
         this.m_videoInfo = new VideoBoxInfo(_loc1_);
         this.m_videoInfo.x = 1824;
         this.m_videoInfo.y = 1026;
         this.m_containerInfoBox.addChild(this.m_videoInfo);
         this.m_tipsView = new LoadingTips();
         this.m_containerTips.addChild(this.m_tipsView);
         this.alignTips();
         this.updatePositionAndScale();
      }
      
      override public function onSetConstrained(param1:Boolean) : void
      {
         if(this.m_bConstrained != param1)
         {
            this.m_bConstrained = param1;
            this.updatePause();
         }
      }
      
      public function pause() : void
      {
         if(this.m_bPaused)
         {
            return;
         }
         this.m_bPaused = true;
         this.updatePause();
      }
      
      public function resume() : void
      {
         if(!this.m_bPaused)
         {
            return;
         }
         this.m_bPaused = false;
         this.updatePause();
      }
      
      private function updatePause() : void
      {
         this.m_loader.setPause(this.m_bPaused || this.m_bConstrained);
      }
      
      public function play(param1:String) : void
      {
         var subtitleTrackIndex:Number;
         var rid:String = param1;
         this.m_characterNameLastShown = "";
         if(ControlsMain.isVrModeActive())
         {
            this.m_enableSubtitle = CommonUtils.getUIOptionValue("UI_OPTION_GRAPHICS_SUBTITLES_VR");
         }
         else
         {
            this.m_enableSubtitle = CommonUtils.getUIOptionValue("UI_OPTION_GRAPHICS_SUBTITLES");
         }
         if(this.m_subView)
         {
            this.m_containerVideo.removeChild(this.m_subView);
            this.m_subView = null;
         }
         this.m_subView = new Subtitle();
         this.m_containerVideo.addChild(this.m_subView);
         this.m_subView.onSetData("");
         this.alignSubs();
         subtitleTrackIndex = -1;
         this.m_loader.playVideo(rid,subtitleTrackIndex,function():void
         {
            onStart();
         },function():void
         {
            onStop();
         });
      }
      
      public function startIndicatorAnim() : void
      {
         this.m_videoInfo.startIndicatorAnim();
      }
      
      public function stopIndicatorAnim() : void
      {
         this.m_videoInfo.stopIndicatorAnim();
      }
      
      public function setInfoState(param1:String) : void
      {
         this.m_videoInfo.setInfoState(param1);
      }
      
      public function stop() : void
      {
         this.m_loader.stopVideo();
      }
      
      public function seekabsolute(param1:Number) : void
      {
         this.m_loader.seekAbsoluteVideo(param1);
      }
      
      public function seekoffset(param1:Number) : void
      {
         this.m_loader.seekOffsetVideo(param1);
      }
      
      public function onSetData(param1:Object) : void
      {
         var _loc2_:String = param1 as String;
         if(Boolean(_loc2_) && this.m_autoplay)
         {
            this.play(_loc2_);
         }
      }
      
      public function getVideoDuration() : Number
      {
         if(this.m_loader == null)
         {
            return -1;
         }
         return this.m_loader.getVideoDuration();
      }
      
      public function getVideoCurrentTime() : Number
      {
         if(this.m_loader == null)
         {
            return -1;
         }
         return this.m_loader.getVideoCurrentTime();
      }
      
      public function onSetScaleToFill(param1:Boolean) : void
      {
         if(this.m_bScaleToFill == param1)
         {
            return;
         }
         this.m_bScaleToFill = param1;
         this.updatePositionAndScale();
      }
      
      override public function onSetSize(param1:Number, param2:Number) : void
      {
         this.m_screenWidth = param1;
         this.m_screenHeight = param2;
         this.updatePositionAndScale();
      }
      
      override public function onSetViewport(param1:Number, param2:Number, param3:Number) : void
      {
         if(this.m_safeAreaScaleX == param1 && this.m_safeAreaScaleY == param2 && param3 == this.m_safeAreaRatio)
         {
            return;
         }
         this.m_safeAreaRatio = param3;
         this.m_safeAreaScaleX = param1;
         this.m_safeAreaScaleY = param2;
      }
      
      private function updatePositionAndScale() : void
      {
         var _loc1_:Number = Math.max(this.m_screenWidth / this.BASE_WIDTH,this.m_screenHeight / this.BASE_HEIGHT);
         var _loc2_:Number = Math.min(this.m_screenWidth / this.BASE_WIDTH,this.m_screenHeight / this.BASE_HEIGHT);
         var _loc3_:Number = 1;
         if(this.m_bScaleToFill)
         {
            _loc3_ = _loc1_;
         }
         else
         {
            _loc3_ = _loc2_;
         }
         this.updatePositionAndScaleForObject(this.m_containerVideo,_loc3_);
         this.updatePositionAndScaleForObject(this.m_containerInfoBox,_loc2_);
         this.updatePositionAndScaleForObject(this.m_containerTips,_loc2_);
         this.updatePositionAndScaleForObject(this.m_containerObjectives,_loc2_);
         this.updatePositionAndScaleForObject(this.m_containerInformation,_loc2_);
      }
      
      private function updatePositionAndScaleForObject(param1:Sprite, param2:Number) : void
      {
         var _loc3_:Number = this.BASE_WIDTH * param2;
         var _loc4_:Number = this.BASE_HEIGHT * param2;
         param1.scaleX = param2;
         param1.scaleY = param2;
         param1.x = (this.m_screenWidth - _loc3_) / 2;
         param1.y = (this.m_screenHeight - _loc4_) / 2;
      }
      
      public function set CenterVideo(param1:Boolean) : void
      {
         this.m_center = param1;
         this.applyCenter();
      }
      
      public function set Loop(param1:Boolean) : void
      {
         this.m_loader.setLoop(param1);
      }
      
      public function set ClearOnStop(param1:Boolean) : void
      {
         this.m_loader.setClearOnStop(param1);
      }
      
      public function set AutoPlay(param1:Boolean) : void
      {
         this.m_autoplay = param1;
      }
      
      public function set InMemory(param1:Boolean) : void
      {
         this.m_loader.setInMemory(param1);
      }
      
      public function get NetStream() : Object
      {
         return this.m_loader.getNetStream();
      }
      
      private function applyCenter() : void
      {
         if(this.m_center)
         {
            this.m_loader.x = -this.m_loader.width / 2;
            this.m_loader.y = -this.m_loader.height / 2;
         }
         if(this.m_subView)
         {
            this.alignSubs();
         }
         this.alignTips();
      }
      
      private function onStart() : void
      {
         this.send_OnStart();
      }
      
      private function onStop() : void
      {
         this.send_OnStop();
      }
      
      public function send_OnStart() : void
      {
         sendEvent("OnStart");
      }
      
      public function send_OnStop() : void
      {
         sendEvent("OnStop");
      }
      
      public function send_Metadata(param1:Object) : void
      {
         sendEvent("OnMetadata");
      }
      
      public function setLoadProgress(param1:Number) : void
      {
         Log.info(Log.ChannelVideo,this,"setting progress " + param1);
         this.m_videoInfo.setLoadProgress(param1);
      }
      
      public function setVideoInfoStateUiData(param1:Object) : void
      {
         this.m_videoInfo.setData(param1);
      }
      
      public function setLoadingScreenData(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         if(param1 != null)
         {
            _loc2_ = param1.ObjectiveData;
            _loc3_ = param1.LoadingInformationData;
         }
         this.setObjectiveData(_loc2_);
         this.setExtraInfoData(_loc3_);
      }
      
      public function setObjectiveData(param1:Object) : void
      {
         var _loc4_:Object = null;
         var _loc5_:LoadingScreenObjectiveTile = null;
         while(this.m_containerObjectives.numChildren > 0)
         {
            this.m_containerObjectives.removeChildAt(0);
         }
         if(param1 == null)
         {
            return;
         }
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(_loc2_ >= 5)
            {
               trace("Error: Cannot show more than 5 objctives on loading screen");
               return;
            }
            _loc2_++;
            _loc4_ = param1[_loc3_];
            (_loc5_ = new LoadingScreenObjectiveTile()).x = 79 + _loc3_ * 352 + 1;
            _loc5_.y = 292;
            _loc5_.setData(_loc4_);
            this.m_containerObjectives.addChild(_loc5_);
            _loc3_++;
         }
      }
      
      private function setExtraInfoData(param1:Object) : void
      {
         if(param1 != null)
         {
            this.m_infoBoxWithBackgroundView.onSetData(param1);
            this.m_infoBoxWithBackgroundView.visible = true;
         }
         else
         {
            this.m_infoBoxWithBackgroundView.visible = false;
         }
      }
      
      public function onMetadata(param1:Object) : void
      {
         this.send_Metadata(param1);
      }
      
      public function setFontSize(param1:int) : void
      {
         if(param1 < 0)
         {
            param1 = CommonUtils.getSubtitleSize();
         }
         this.m_subtitleFontSize = param1;
      }
      
      public function setSubtitleBGAlpha(param1:Number) : void
      {
         if(param1 < 0)
         {
            param1 = CommonUtils.getSubtitleBGAlpha();
         }
         this.m_subtitleBGAlpha = param1;
      }
      
      public function onSubtitles(param1:String, param2:String = "") : void
      {
         if(!this.m_enableSubtitle)
         {
            Log.info(Log.ChannelVideo,this,"Subtitle (disabled) (Videobox): [" + param2 + "] " + param1);
            return;
         }
         Log.info(Log.ChannelVideo,this,"Subtitle (Videobox): [" + param2 + "] " + param1);
         var _loc3_:Object = new Object();
         _loc3_.text = param1;
         _loc3_.fontsize = this.m_subtitleFontSize;
         _loc3_.pctBGAlpha = this.m_subtitleBGAlpha;
         if(param1 != null && param1 != "" && this.m_characterNameLastShown != param2)
         {
            this.m_characterNameLastShown = param2;
            _loc3_.characterName = param2;
         }
         this.m_subView.onSetData(_loc3_);
      }
      
      private function alignSubs() : void
      {
         this.m_subView.scaleX = this.m_subView.scaleY = 1.25;
         this.m_subView.x = this.m_loader.width / 2 - this.m_subView.scaleX * this.m_subView.getTextFieldWidth() / 2;
         this.m_subView.y = this.m_loader.height * 0.95 - 14;
      }
      
      public function showTip(param1:String, param2:Boolean) : void
      {
         Log.info(Log.ChannelVideo,this,"Tip" + param1);
         this.m_tipsView.setBackgroundVisible(param2);
         this.m_tipsView.onSetData(param1);
      }
      
      public function hideTip() : void
      {
         Log.info(Log.ChannelVideo,this,"Tip: Hide");
         this.m_tipsView.onSetData("");
      }
      
      private function alignTips() : void
      {
         this.m_tipsView.x = this.m_loader.width / 2;
         this.m_tipsView.y = 958;
      }
   }
}
