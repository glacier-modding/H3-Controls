package common
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.NetStatusEvent;
   import flash.media.Video;
   import flash.net.NetConnection;
   import flash.net.NetStream;
   import scaleform.gfx.*;
   
   public class VideoLoader extends MovieClip
   {
       
      
      private var m_startCallback:Function;
      
      private var m_stopCallback:Function;
      
      private var m_subCallback:Function;
      
      private var m_metadataCallback:Function;
      
      private var m_netConnection:NetConnection;
      
      private var m_netStream:Object;
      
      private var m_video:Video;
      
      private var m_inMemory:Boolean;
      
      private var m_TrackIndex:int = -1;
      
      private var m_duration:Number = -1;
      
      private var m_clearOnStop:Boolean = true;
      
      public function VideoLoader()
      {
         super();
         this.m_inMemory = false;
         this.m_netConnection = new NetConnection();
         this.m_netConnection.connect(null);
         var _loc1_:NetStream = new NetStream(this.m_netConnection);
         this.m_netStream = _loc1_;
         this.m_netStream.openTimeout = 0;
         this.m_netStream.addEventListener(NetStatusEvent.NET_STATUS,this.netStatusHandler);
         this.m_video = new Video();
         this.m_video.attachNetStream(_loc1_);
         addChild(this.m_video);
         var _loc2_:Object = new Object();
         _loc2_.onMetaData = this.onMetaData;
         _loc2_.onSubtitle = this.onSubtitles;
         this.m_netStream.client = _loc2_;
         this.m_duration = 0;
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
      }
      
      public function onMetaData(param1:Object) : void
      {
         Log.info(Log.ChannelVideo,this,"Video Loader on MetaData track: " + this.m_TrackIndex + " duration " + param1.duration);
         this.m_duration = param1.duration;
         if(this.m_TrackIndex != -1)
         {
            this.m_netStream.subtitleTrack = this.m_TrackIndex;
         }
         if(this.m_metadataCallback != null)
         {
            this.m_metadataCallback(param1);
         }
      }
      
      public function onSubtitles(param1:String, param2:String = "") : void
      {
         Log.info(Log.ChannelVideo,this,"Subtitle (Loader): [" + param2 + "] " + param1);
         if(this.m_subCallback != null)
         {
            this.m_subCallback(param1,param2);
         }
      }
      
      public function setSubCallback(param1:Function) : void
      {
         this.m_subCallback = param1;
      }
      
      public function setMetadataCallback(param1:Function) : void
      {
         this.m_metadataCallback = param1;
      }
      
      public function playVideo(param1:String, param2:Number, param3:Function, param4:Function) : void
      {
         this.stopStream();
         this.m_TrackIndex = param2;
         this.m_startCallback = param3;
         this.m_stopCallback = param4;
         this.startStream(param1);
      }
      
      public function stopVideo() : void
      {
         this.stopStream();
      }
      
      public function seekAbsoluteVideo(param1:Number) : void
      {
         Log.info(Log.ChannelVideo,this,"Video seekAbsoluteVideo");
         this.m_netStream.seek(param1);
      }
      
      public function seekOffsetVideo(param1:Number) : void
      {
         Log.info(Log.ChannelVideo,this,"Video seekOffsetVideo " + param1);
         this.m_netStream.seek(this.m_netStream.time + param1);
      }
      
      public function getVideoCurrentTime() : Number
      {
         if(!this.m_netStream || !this.m_netStream.time)
         {
            return -1;
         }
         return this.m_netStream.time;
      }
      
      public function setPause(param1:Boolean) : void
      {
         if(param1)
         {
            Log.info(Log.ChannelVideo,this,"Video Loader netstream paused");
            this.m_netStream.pause();
         }
         else
         {
            Log.info(Log.ChannelVideo,this,"Video Loader netstream resumed");
            this.m_netStream.resume();
         }
      }
      
      public function setLoop(param1:Boolean) : void
      {
         this.m_netStream.loop = param1;
      }
      
      public function getClearOnStop(param1:Boolean) : Boolean
      {
         return this.m_clearOnStop;
      }
      
      public function setClearOnStop(param1:Boolean) : void
      {
         this.m_clearOnStop = param1;
      }
      
      public function setInMemory(param1:Boolean) : void
      {
         this.m_inMemory = param1;
      }
      
      public function getNetStream() : Object
      {
         return this.m_netStream;
      }
      
      public function getVideoDuration() : Number
      {
         return this.m_duration;
      }
      
      private function startStream(param1:String) : void
      {
         Log.info(Log.ChannelVideo,this,"Video Loader netstream start");
         this.m_video.clear();
         var _loc2_:String = this.m_inMemory ? "[GFXMRV]" : "[GFXV]";
         this.m_netStream.play(_loc2_ + param1);
      }
      
      private function sendStart() : void
      {
         if(this.m_startCallback != null)
         {
            this.m_startCallback();
            this.m_startCallback = null;
         }
      }
      
      private function stopStream() : void
      {
         if(this.m_clearOnStop)
         {
            this.m_video.clear();
         }
         this.m_netStream.close();
         this.m_duration = 0;
         Log.info(Log.ChannelVideo,this,"Video Loader netstream stop");
      }
      
      private function sendStop() : void
      {
         if(this.m_stopCallback != null)
         {
            this.m_stopCallback();
            this.m_stopCallback = null;
         }
      }
      
      private function netStatusHandler(param1:NetStatusEvent) : void
      {
         Log.info(Log.ChannelVideo,this,"Video Loader netstream event " + param1.info.code);
         switch(param1.info.code)
         {
            case "NetStream.Play.Start":
               this.sendStart();
               break;
            case "NetStream.Play.Stop":
               if(this.m_clearOnStop)
               {
                  this.m_video.clear();
               }
               this.sendStop();
               break;
            case "NetStream.Play.StreamNotFound":
         }
      }
      
      private function onRemoved(param1:Event) : void
      {
         this.stopVideo();
      }
   }
}
