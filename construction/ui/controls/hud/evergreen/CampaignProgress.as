package hud.evergreen
{
   import common.Animate;
   import common.BaseControl;
   import common.Localization;
   import common.Log;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.external.ExternalInterface;
   
   public class CampaignProgress extends BaseControl
   {
       
      
      private var m_view:CampaignProgressView;
      
      private var m_progressStep:int;
      
      private var m_showBackground:Boolean = false;
      
      private var m_slimView:Boolean = false;
      
      private var m_showMarker:Boolean = false;
      
      private var m_onMissionEnd:Boolean = false;
      
      private var m_onFolderScreen:Boolean = false;
      
      private var m_waitWithAnimation:Boolean = false;
      
      private var m_campaignLayout:Array;
      
      private var m_transitionBar:CampaignProgressBarView;
      
      private var m_transitionFrom:int;
      
      private var m_transitionTo:int;
      
      private var m_soundId:String;
      
      private var m_fadeUps:Vector.<CampaignProgressBarView>;
      
      public function CampaignProgress()
      {
         this.m_view = new CampaignProgressView();
         this.m_campaignLayout = new Array(0,0,1,0,0,0,1,0,0,0,0,1,0,0,0,0,0,1);
         super();
         this.m_view.header_txt.text = Localization.get("UI_EVEREGREEN_SAFEHOUSE_WORLDMAP_CAMPAIGNPROGRESS").toUpperCase();
         addChild(this.m_view);
      }
      
      public function onSetData(param1:Object) : void
      {
         this.m_progressStep = param1.step;
         this.m_onFolderScreen = Boolean(param1.campaignActivatorInUse) && !this.m_showBackground;
         if(this.m_onMissionEnd)
         {
            --this.m_progressStep;
         }
         this.createBars(param1.campaign,param1.completed,param1.goToExitObjectivesDone,param1.goToExitObjectivesFail);
         if(param1.hardcore)
         {
            MenuUtils.setColor(this.m_view.holder_mc,MenuConstants.COLOR_RED,false,10);
         }
         else
         {
            MenuUtils.removeColor(this.m_view.holder_mc);
         }
      }
      
      private function createBars(param1:Array, param2:Array, param3:Boolean = false, param4:Boolean = false) : void
      {
         var _loc15_:CampaignProgressBarView = null;
         var _loc20_:CampaignProgressBarView = null;
         var _loc5_:Number = 15;
         var _loc6_:int = int(param1.length);
         var _loc7_:int = int(param2.length);
         var _loc8_:int = 0;
         var _loc9_:Boolean = false;
         this.m_fadeUps = new Vector.<CampaignProgressBarView>();
         var _loc10_:int = 0;
         var _loc11_:int = _loc6_;
         var _loc12_:int = 0;
         while(_loc12_ < _loc6_)
         {
            if(param1[_loc12_] == 1 && _loc12_ < this.m_progressStep - 1)
            {
               _loc10_ = _loc12_ + 1;
               _loc8_++;
            }
            if(param1[_loc12_] == 1 && _loc12_ >= this.m_progressStep - 1 && _loc11_ == _loc6_)
            {
               _loc11_ = _loc12_ + 1;
            }
            _loc12_++;
         }
         Animate.kill(this.m_transitionBar);
         var _loc13_:int = this.m_slimView && !this.m_onFolderScreen ? _loc10_ : 0;
         var _loc14_:int = this.m_slimView && !this.m_onFolderScreen ? _loc11_ : _loc6_;
         var _loc16_:int = 0;
         var _loc17_:int = _loc13_;
         while(_loc17_ < _loc14_)
         {
            if(_loc17_ == _loc10_)
            {
               this.m_view.frame_mc.x = _loc5_ - 17;
               _loc5_ += 3;
            }
            if(this.m_view.holder_mc.numChildren <= _loc16_)
            {
               _loc15_ = new CampaignProgressBarView();
               this.m_view.holder_mc.addChild(_loc15_);
            }
            else
            {
               _loc15_ = this.m_view.holder_mc.getChildAt(_loc16_) as CampaignProgressBarView;
               Animate.kill(_loc15_.flash_mc);
               _loc15_.alpha = 1;
               _loc15_.scaleX = 1;
               _loc15_.scaleY = 1;
               _loc15_.visible = true;
            }
            _loc16_++;
            if(this.m_onFolderScreen && _loc17_ == 0)
            {
               _loc9_ = true;
            }
            if(_loc9_)
            {
               this.m_fadeUps.push(_loc15_);
            }
            switch(param1[_loc17_])
            {
               case 0:
                  _loc15_.x = _loc5_;
                  _loc15_.y = 21;
                  if(_loc17_ + 1 == _loc7_ && this.m_onMissionEnd)
                  {
                     this.m_transitionBar = _loc15_;
                     this.m_transitionFrom = 1;
                     this.m_transitionTo = 4 - param2[_loc17_];
                     if(this.m_waitWithAnimation)
                     {
                        _loc15_.gotoAndStop(this.m_transitionFrom);
                        this.m_soundId = param2[_loc17_] == 1 ? "ui_debrief_scorescreen_evergreen_campaign_mildwin" : "ui_debrief_scorescreen_evergreen_campaign_mildfail";
                     }
                     else
                     {
                        _loc15_.gotoAndStop(this.m_transitionTo);
                     }
                  }
                  else if(_loc17_ < _loc7_)
                  {
                     _loc15_.gotoAndStop(4 - param2[_loc17_]);
                     _loc15_.flash_mc.visible = false;
                  }
                  else if(this.m_progressStep == _loc17_ + 1 && !this.m_onMissionEnd && !this.m_onFolderScreen)
                  {
                     if(param3)
                     {
                        this.cycleIcon(_loc15_,5,7);
                     }
                     else if(param4)
                     {
                        this.cycleIcon(_loc15_,6,7);
                     }
                     else
                     {
                        _loc15_.gotoAndStop(1);
                     }
                     this.animateMarker(_loc15_);
                  }
                  else
                  {
                     if(_loc17_ < _loc11_)
                     {
                        _loc15_.gotoAndStop(this.m_onFolderScreen ? 9 : 1);
                     }
                     else
                     {
                        _loc15_.gotoAndStop(9);
                        _loc15_.alpha = 0.3;
                     }
                     _loc15_.flash_mc.visible = false;
                  }
                  _loc5_ += 34;
                  break;
               case 1:
                  _loc15_.x = _loc5_ + 6;
                  _loc15_.y = 15;
                  if(_loc17_ + 1 == _loc7_ && this.m_onMissionEnd)
                  {
                     this.m_transitionBar = _loc15_;
                     this.m_transitionFrom = 10;
                     this.m_transitionTo = param2[_loc17_] == 1 ? 12 : 13;
                     if(param2[_loc17_] == 1)
                     {
                        _loc9_ = true;
                     }
                     if(this.m_waitWithAnimation)
                     {
                        this.m_soundId = param2[_loc17_] == 1 ? "ui_debrief_scorescreen_evergreen_campaign_hotwin" : "ui_debrief_scorescreen_evergreen_campaign_hotfail";
                        _loc15_.gotoAndStop(this.m_transitionFrom);
                     }
                     else
                     {
                        _loc15_.gotoAndStop(this.m_transitionTo);
                     }
                  }
                  else if(this.m_progressStep == _loc17_ + 1 && !this.m_onMissionEnd)
                  {
                     if(param3)
                     {
                        this.cycleIcon(_loc15_,14,16);
                     }
                     else if(param4)
                     {
                        this.cycleIcon(_loc15_,15,16);
                     }
                     else
                     {
                        _loc15_.gotoAndStop(10);
                     }
                  }
                  else if(this.m_progressStep > _loc17_)
                  {
                     _loc15_.gotoAndStop(param2[_loc17_] == 1 ? 12 : 13);
                  }
                  else
                  {
                     _loc15_.gotoAndStop(10);
                     _loc9_ = false;
                     if(_loc17_ > _loc11_ - 1)
                     {
                        _loc15_.alpha = 0.3;
                     }
                  }
                  if(this.m_progressStep == _loc17_ + 1 && !this.m_onMissionEnd)
                  {
                     this.animateMarker(_loc15_);
                  }
                  else
                  {
                     _loc15_.flash_mc.visible = false;
                  }
                  _loc5_ += 47;
                  break;
            }
            if(_loc17_ == _loc11_ - 1)
            {
               this.m_view.frame_mc.campDots_mc.gotoAndStop(_loc8_ + 1);
               this.m_view.frame_mc.mid_mc.x = 9;
               this.m_view.frame_mc.mid_mc.width = 34 * (_loc11_ - _loc10_);
               this.m_view.frame_mc.end_mc.x = 8 + this.m_view.frame_mc.mid_mc.width;
               this.m_view.frame_mc.campDots_mc.x = 10 + this.m_view.frame_mc.mid_mc.width / 2;
               _loc5_ += 3;
               this.m_view.frame_mc.visible = !this.m_onFolderScreen;
            }
            _loc17_++;
         }
         this.m_view.back_mc.width = _loc5_ + 18;
         this.m_view.x = -(_loc5_ - 4) / 2;
         if(!this.m_waitWithAnimation && this.m_fadeUps.length > 0 && this.m_onMissionEnd)
         {
            for each(_loc20_ in this.m_fadeUps)
            {
               _loc20_.alpha = 1;
            }
         }
         var _loc18_:int = this.m_view.holder_mc.numChildren;
         var _loc19_:int = _loc16_;
         while(_loc19_ < _loc18_)
         {
            (_loc15_ = this.m_view.holder_mc.getChildAt(_loc19_) as CampaignProgressBarView).visible = false;
            _loc19_++;
         }
      }
      
      public function doAnimation() : void
      {
         ExternalInterface.call("PlaySound",this.m_soundId);
         this.m_transitionBar.gotoAndStop(this.m_transitionFrom);
         Animate.to(this.m_transitionBar,0.2,0,{
            "scaleX":0.01,
            "scaleY":1.3
         },Animate.SineOut,function():void
         {
            var _loc1_:CampaignProgressBarView = null;
            m_transitionBar.gotoAndStop(m_transitionTo);
            Animate.to(m_transitionBar,0.3,0,{
               "scaleX":1,
               "scaleY":1
            },Animate.SineIn);
            if(m_fadeUps.length > 0 && m_onMissionEnd)
            {
               for each(_loc1_ in m_fadeUps)
               {
                  Animate.to(_loc1_,0.3,0.3,{"alpha":1},Animate.Linear);
               }
            }
         });
         this.m_transitionBar.flash_mc.visible = true;
         this.m_transitionBar.flash_mc.alpha = 1;
         this.m_transitionBar.flash_mc.scaleX = this.m_transitionBar.flash_mc.scaleY = 1;
         Animate.to(this.m_transitionBar.flash_mc,0.4,0.4,{
            "alpha":0,
            "scaleX":2,
            "scaleY":2
         },Animate.SineOut);
      }
      
      private function cycleIcon(param1:CampaignProgressBarView, param2:int, param3:int) : void
      {
         var marker_mc:CampaignProgressBarView = param1;
         var startFrame:int = param2;
         var endFrame:int = param3;
         this.m_transitionBar = marker_mc;
         this.m_transitionBar.gotoAndStop(startFrame);
         Animate.to(this.m_transitionBar,0.1,1.5,{"scaleX":0.01},Animate.SineOut,function():void
         {
            m_transitionBar.gotoAndStop(endFrame);
            Animate.to(m_transitionBar,0.1,0,{"scaleX":1},Animate.SineIn,function():void
            {
               cycleIcon(m_transitionBar,endFrame,startFrame);
            });
         });
      }
      
      private function animateMarker(param1:CampaignProgressBarView) : void
      {
         if(this.m_showMarker)
         {
            param1.flash_mc.alpha = 1;
            param1.flash_mc.scaleX = param1.flash_mc.scaleY = 1;
            Animate.to(param1.flash_mc,0.4,0.4,{
               "alpha":0,
               "scaleX":1.8,
               "scaleY":1.8
            },Animate.SineOut,this.animateMarker,param1);
         }
         else
         {
            param1.flash_mc.visible = false;
         }
      }
      
      public function folderAnim() : void
      {
         var _loc1_:CampaignProgressBarView = null;
         Log.xinfo(Log.ChannelDebug,"CampaingProgress fadeUps length: " + this.m_fadeUps.length);
         if(this.m_onFolderScreen)
         {
            for each(_loc1_ in this.m_fadeUps)
            {
               if(_loc1_.currentFrame == 9)
               {
                  _loc1_.gotoAndStop(1);
               }
            }
            this.m_view.frame_mc.visible = true;
            this.m_view.frame_mc.alpha = 0;
            Animate.to(this.m_view.frame_mc,0.2,0,{"alpha":1},Animate.Linear);
         }
      }
      
      public function folderAnimReset() : void
      {
         var _loc1_:CampaignProgressBarView = null;
         if(this.m_onFolderScreen)
         {
            for each(_loc1_ in this.m_fadeUps)
            {
               if(_loc1_.currentFrame == 1)
               {
                  _loc1_.gotoAndStop(9);
               }
            }
            this.m_view.frame_mc.visible = false;
         }
      }
      
      public function set showMarker(param1:Boolean) : void
      {
         this.m_showMarker = param1;
      }
      
      public function set showBackground(param1:Boolean) : void
      {
         this.m_view.back_mc.visible = this.m_showBackground = param1;
         this.m_view.header_txt.visible = this.m_onMissionEnd || this.m_showBackground;
      }
      
      public function set showSlimView(param1:Boolean) : void
      {
         this.m_slimView = param1;
      }
      
      public function set waitWithAnimation(param1:Boolean) : void
      {
         this.m_waitWithAnimation = param1;
      }
      
      public function set onMissionEnd(param1:Boolean) : void
      {
         this.m_onMissionEnd = param1;
         this.m_view.header_txt.visible = this.m_onMissionEnd || this.m_showBackground;
      }
      
      public function set onFolderScreen(param1:Boolean) : void
      {
         this.m_onFolderScreen = param1;
      }
   }
}
