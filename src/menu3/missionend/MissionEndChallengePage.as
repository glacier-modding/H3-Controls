package menu3.missionend
{
   import basic.DottedLine;
   import common.Animate;
   import common.CalcUtil;
   import common.Localization;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   import flash.external.ExternalInterface;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import menu3.MenuElementBase;
   
   public dynamic class MissionEndChallengePage extends MenuElementBase
   {
      
      public static const CHALLENGE_STATE_NEW:String = "new";
      
      public static const CHALLENGE_STATE_NEW_UNLOCKED:String = "unlocked";
      
      public static const CHALLENGE_STATE_COMPLETE:String = "complete";
      
      public static const CHALLENGE_STATE_UNCOMPLETE:String = "uncomplete";
       
      
      private const IMAGE_REQUEST_MAX:Number = 3;
      
      private const TILE_GAP:int = 2;
      
      private var m_view:MissionEndChallengePageView;
      
      private var m_challengeArea:Rectangle;
      
      private var m_totalChallengeCount:int = 0;
      
      private var m_challengeCounter:int = 0;
      
      private var m_tileWidth:int = 0;
      
      private var m_tileHeight:int = 0;
      
      private var m_tileScale:Number = 1;
      
      private var m_tileCountX:int = 0;
      
      private var m_challenges:Array;
      
      private var m_challengeImages:Array;
      
      private var m_challengeTiles:Array;
      
      private var m_shuffledTileIndexes:Array;
      
      private var m_loadImageQueue:Array;
      
      private var m_loadImageLoaded:Array;
      
      private var m_stopLoading:Boolean = false;
      
      private var m_unloadingImagesInProgress:Boolean = false;
      
      private var m_loadingImagesInProgress:int = 0;
      
      private var m_gainedXp:int = 0;
      
      private var m_gainedMultiplier:Number = 0;
      
      private var m_imageScaleDown:Number = 0.25;
      
      private var m_dottedLineContainer:Sprite;
      
      private var m_isTotalXpBgVisible:Boolean = false;
      
      private var m_tickSoundStarted:Boolean;
      
      private var m_tilesAppearSoundStarted:Boolean;
      
      public function MissionEndChallengePage(param1:Object)
      {
         this.m_challenges = [];
         this.m_challengeImages = [];
         this.m_challengeTiles = [];
         this.m_shuffledTileIndexes = [];
         this.m_loadImageQueue = [];
         this.m_loadImageLoaded = [];
         super(param1);
         this.m_view = new MissionEndChallengePageView();
         this.m_view.x = -MenuConstants.menuXOffset;
         this.m_view.y = -MenuConstants.menuYOffset;
         addChild(this.m_view);
         var _loc2_:Sprite = this.m_view.challengeArea;
         this.m_challengeArea = new Rectangle(_loc2_.x,_loc2_.y,_loc2_.width,_loc2_.height);
         _loc2_.visible = false;
         var _loc3_:ImageItemView = new ImageItemView();
         this.m_tileWidth = _loc3_.getImageWidth();
         this.m_tileHeight = _loc3_.getImageHeight();
         _loc3_ = null;
         this.m_dottedLineContainer = new Sprite();
         this.m_dottedLineContainer.x = _loc2_.x + 2;
         this.m_dottedLineContainer.y = _loc2_.y + _loc2_.height + 15;
         var _loc4_:DottedLine = new DottedLine(_loc2_.width,MenuConstants.COLOR_WHITE,DottedLine.TYPE_HORIZONTAL,1,2);
         this.m_dottedLineContainer.addChild(_loc4_);
         this.m_view.addChild(this.m_dottedLineContainer);
      }
      
      override public function onSetData(param1:Object) : void
      {
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:int = 0;
         super.onSetData(param1);
         this.m_view.totalXP_bg.scaleX = 0;
         this.m_isTotalXpBgVisible = false;
         this.m_view.totalXP.alpha = 1;
         this.m_dottedLineContainer.alpha = 0;
         var _loc2_:Array = param1.Challenges;
         this.m_challenges = _loc2_;
         if(_loc2_ == null)
         {
            this.m_challenges = new Array();
         }
         this.m_challengeImages = param1.ChallengeImages;
         if(this.m_challengeImages == null)
         {
            this.m_challengeImages = new Array();
            this.m_challengeImages.length = this.m_challenges.length;
         }
         var _loc3_:Dictionary = new Dictionary();
         var _loc4_:int = 0;
         while(_loc4_ < this.m_challenges.length)
         {
            _loc7_ = "";
            if(this.m_challenges[_loc4_].ChallengeId !== undefined)
            {
               _loc7_ = String(this.m_challenges[_loc4_].ChallengeId);
            }
            else if(this.m_challenges[_loc4_].Id !== undefined)
            {
               _loc7_ = String(this.m_challenges[_loc4_].Id);
            }
            if(_loc7_.length > 0)
            {
               _loc3_[_loc7_] = _loc4_;
            }
            _loc4_++;
         }
         var _loc5_:Array = param1.NewChallenges;
         var _loc6_:Array = param1.NewChallengeImages;
         if(_loc5_ != null)
         {
            if(_loc6_ == null)
            {
               _loc6_ = new Array();
            }
            if(_loc6_.length != _loc5_.length)
            {
               _loc6_.length = _loc5_.length;
            }
            _loc8_ = 0;
            while(_loc8_ < _loc5_.length)
            {
               if(_loc5_[_loc8_].IsActionReward !== true)
               {
                  _loc9_ = String(_loc5_[_loc8_].ChallengeId);
                  if(_loc3_[_loc9_] !== undefined)
                  {
                     _loc10_ = int(_loc3_[_loc9_]);
                     this.m_challenges[_loc10_].IsNewChallenge = true;
                     this.m_challenges[_loc10_].XPGain = _loc5_[_loc8_].XPGain;
                  }
                  else
                  {
                     _loc5_[_loc8_].IsNewChallenge = true;
                     this.m_challenges.push(_loc5_[_loc8_]);
                     this.m_challengeImages.push(_loc6_[_loc8_]);
                  }
               }
               _loc8_++;
            }
         }
         this.m_totalChallengeCount = this.m_challenges.length;
         if(this.m_totalChallengeCount == 0)
         {
            return;
         }
         if(this.m_totalChallengeCount > 200)
         {
            this.m_imageScaleDown = 0.1;
         }
         else if(this.m_totalChallengeCount > 170)
         {
            this.m_imageScaleDown = 0.2;
         }
         else
         {
            this.m_imageScaleDown = 0.25;
         }
         this.calculateTileScale(1);
         this.createChallengeTiles();
         this.m_stopLoading = false;
      }
      
      public function startAnimation() : void
      {
         this.m_stopLoading = false;
         if(this.m_loadingImagesInProgress == 0)
         {
            this.startLoadImageFromQueue();
         }
         this.setTexts("","");
         this.setXpText(0);
         this.m_gainedXp = 0;
         this.killAllAnimations();
         var _loc1_:int = 0;
         while(_loc1_ < this.m_challengeTiles.length)
         {
            this.m_challengeTiles[_loc1_].view.setVisible(false);
            _loc1_++;
         }
         Animate.to(this.m_dottedLineContainer,0.4,0.1,{"alpha":1},Animate.ExpoOut);
         Animate.delay(this.m_view,1,this.showTileGrid);
      }
      
      public function startLoadImages() : void
      {
         if(this.m_loadingImagesInProgress == 0)
         {
            this.startLoadImageFromQueue();
         }
      }
      
      public function unloadImages() : void
      {
         this.unloadImagesFromQueue();
      }
      
      public function playSound(param1:String) : void
      {
         ExternalInterface.call("PlaySound",param1);
      }
      
      private function showTileGrid() : void
      {
         var _loc5_:Object = null;
         var _loc6_:ImageItemView = null;
         var _loc7_:int = 0;
         this.playSound("ui_debrief_achievement_tiles_appear");
         this.m_tilesAppearSoundStarted = true;
         var _loc1_:Number = 0.01;
         var _loc2_:Number = 0.01;
         var _loc3_:Number = 0.3;
         var _loc4_:int = 0;
         while(_loc4_ < this.m_shuffledTileIndexes.length)
         {
            (_loc6_ = (_loc5_ = this.m_challengeTiles[this.m_shuffledTileIndexes[_loc4_]]).view).setVisible(true,0);
            MenuUtils.addColorFilter(_loc6_.image,[MenuConstants.COLOR_MATRIX_BW]);
            if((_loc7_ = this.getRandomDir()) == 1)
            {
               Animate.from(_loc6_,0.2,_loc1_,{"y":_loc6_.y - 10},Animate.ExpoOut);
            }
            else if(_loc7_ == 2)
            {
               Animate.from(_loc6_,0.2,_loc1_,{"y":_loc6_.y + 10},Animate.ExpoOut);
            }
            else if(_loc7_ == 3)
            {
               Animate.from(_loc6_,0.2,_loc1_,{"x":_loc6_.x - 10},Animate.ExpoOut);
            }
            else if(_loc7_ == 4)
            {
               Animate.from(_loc6_,0.2,_loc1_,{"x":_loc6_.x + 10},Animate.ExpoOut);
            }
            Animate.to(_loc6_.image,_loc3_,_loc1_,{"alpha":0.5},Animate.ExpoOut);
            _loc1_ += _loc2_;
            _loc4_++;
         }
         Animate.delay(this,_loc1_ + _loc3_,this.animateTile,0);
      }
      
      private function animateTile(param1:int) : void
      {
         if(param1 >= this.m_challengeTiles.length)
         {
            return;
         }
         if(this.m_tilesAppearSoundStarted)
         {
            this.playSound("ui_debrief_achievement_tiles_appear_stop");
            this.m_tilesAppearSoundStarted = false;
         }
         if(!this.m_tickSoundStarted)
         {
            this.playSound("ui_debrief_achievement_scorescreen_tick_lp");
            this.m_tickSoundStarted = true;
         }
         var _loc2_:Object = this.m_challengeTiles[param1];
         var _loc3_:ImageItemView = _loc2_.view;
         var _loc4_:String = CHALLENGE_STATE_UNCOMPLETE;
         if(_loc2_.IsNewChallenge === true)
         {
            _loc4_ = CHALLENGE_STATE_NEW;
         }
         else if(_loc2_.Completed === true)
         {
            _loc4_ = CHALLENGE_STATE_COMPLETE;
         }
         _loc3_.animateIn(_loc4_);
         if(_loc4_ == CHALLENGE_STATE_NEW)
         {
            this.unlockChallenge(_loc2_);
            if(this.m_tickSoundStarted)
            {
               this.playSound("ui_debrief_achievement_scorescreen_tick_lp_stop");
               this.m_tickSoundStarted = false;
            }
            this.playSound("ui_debrief_achievement_scorescreen_tile_highlight");
            Animate.delay(this.m_view,1,this.animateTile,param1 + 1);
         }
         else
         {
            Animate.delay(this.m_view,0.03,this.animateTile,param1 + 1);
         }
         this.checkChallengeCountCompleted(_loc4_);
      }
      
      private function unlockChallenge(param1:Object) : void
      {
         var drops:Array;
         var header:String;
         var title:String;
         var imageItemView:ImageItemView;
         var originalScale:Point;
         var originalPos:Point;
         var localBound:Rectangle;
         var POPOUT_GAIN_MAX_WIDTH:Number;
         var POPOUT_GAIN_MAX_HEIGHT:Number;
         var animationVars:Object;
         var multiplier:Number = NaN;
         var i:int = 0;
         var headerLoca:String = null;
         var challengeTile:Object = param1;
         var currentXpReward:int = 0;
         var previousGainedXP:int = this.m_gainedXp;
         if(challengeTile.XPGain !== undefined)
         {
            this.m_gainedXp += challengeTile.XPGain;
            currentXpReward = int(challengeTile.XPGain);
         }
         multiplier = 0;
         drops = challengeTile.Drops;
         if(drops != null)
         {
            i = 0;
            while(i < drops.length)
            {
               if(drops[i].Type == "challengemultiplier")
               {
                  multiplier += drops[i].Properties.Multiplier;
               }
               i++;
            }
         }
         this.m_gainedMultiplier += multiplier;
         if(!this.m_isTotalXpBgVisible)
         {
            this.m_isTotalXpBgVisible = true;
            Animate.to(this.m_view.totalXP_bg,0.3,0,{"scaleX":1},Animate.ExpoInOut);
         }
         header = "";
         if(multiplier > 0)
         {
            multiplier += 1;
            header = Localization.get("UI_MENU_SCORE_MULTIPLIER_CHALLENGE") + ": " + multiplier.toFixed(2);
            Animate.to(this.m_view.totalXP,0.2,0,{"alpha":0},Animate.ExpoIn,function():void
            {
               setMultiplierText(multiplier);
               Animate.addTo(m_view.totalXP,0.3,0.2,{"alpha":1},Animate.ExpoOut);
            });
         }
         else
         {
            headerLoca = challengeTile.CategoryName != null ? String(challengeTile.CategoryName) : "UI_DIALOG_TITLE_CHALLENGE_COMPLETED";
            header = Localization.get(headerLoca);
            if(currentXpReward > 0)
            {
               Animate.addFromTo(this.m_view.totalXP,0.5,0.2,{"intAnimation":0},{"intAnimation":currentXpReward},Animate.Linear,this.setXpText,currentXpReward);
               this.playSound("ui_debrief_achievement_scorescreen_tick_xp_lp");
            }
            else
            {
               this.setXpText(0);
            }
         }
         title = "";
         if(challengeTile.ChallengeName !== undefined)
         {
            title = Localization.get(challengeTile.ChallengeName);
         }
         else
         {
            title = Localization.get(challengeTile.Name);
         }
         Animate.delay(this.m_view,0.1,this.setTexts,title,header);
         imageItemView = challengeTile.view;
         imageItemView.parent.setChildIndex(imageItemView,imageItemView.parent.numChildren - 1);
         originalScale = new Point(imageItemView.scaleX,imageItemView.scaleY);
         originalPos = new Point(imageItemView.x,imageItemView.y);
         localBound = imageItemView.getBounds(imageItemView);
         POPOUT_GAIN_MAX_WIDTH = 60;
         POPOUT_GAIN_MAX_HEIGHT = 60;
         animationVars = CalcUtil.createScalingAnimationParameters(originalPos,originalScale,localBound,POPOUT_GAIN_MAX_WIDTH,POPOUT_GAIN_MAX_HEIGHT);
         Animate.to(imageItemView,0.2,0,animationVars,Animate.ExpoOut);
         Animate.addFromTo(imageItemView,0.3,0.2,animationVars,{
            "x":originalPos.x,
            "y":originalPos.y,
            "scaleX":originalScale.x,
            "scaleY":originalScale.y
         },Animate.ExpoIn,function(param1:ImageItemView):void
         {
            param1.animateIn(CHALLENGE_STATE_NEW_UNLOCKED);
         },imageItemView);
      }
      
      private function checkChallengeCountCompleted(param1:String) : void
      {
         var delay:Number = NaN;
         var awardType:String = null;
         var endTitle:String = null;
         var endHeader:String = null;
         var endValue:Number = NaN;
         var lastChallengeState:String = param1;
         ++this.m_challengeCounter;
         if(this.m_challengeCounter == this.m_totalChallengeCount)
         {
            this.m_challengeCounter = 0;
            this.playSound("ui_debrief_achievement_scorescreen_tick_lp_stop");
            if(this.m_gainedXp <= 0 && this.m_gainedMultiplier <= 0)
            {
               return;
            }
            delay = lastChallengeState == CHALLENGE_STATE_NEW ? 1 : 0.4;
            awardType = "";
            endTitle = "";
            endHeader = Localization.get("UI_MENU_SCOREOVERVIEW_CHALLENGESCOMPLETED");
            endValue = 0;
            if(this.m_gainedXp > 0)
            {
               awardType = "xp";
               endTitle = Localization.get("UI_MENU_MISSION_END_SCOREDETAIL_XP_TITLE");
               endValue = this.m_gainedXp;
            }
            else if(this.m_gainedMultiplier > 0)
            {
               awardType = "multiplier";
               endTitle = Localization.get("UI_MENU_SCORE_MULTIPLIER_CHALLENGE");
               endValue = this.m_gainedMultiplier + 1;
            }
            Animate.delay(this.m_view,delay,function():void
            {
               m_view.title.alpha = 0;
               m_view.header.alpha = 0;
               m_view.totalXP.alpha = 0;
               setTexts(endTitle,endHeader);
               if(awardType == "xp")
               {
                  setXpText(endValue);
               }
               else if(awardType == "multiplier")
               {
                  setMultiplierText(endValue);
               }
               Animate.fromTo(m_view.totalXP_bg.inner,0.4,0,{
                  "scaleX":0.7,
                  "scaleY":0.7
               },{
                  "scaleX":1.02,
                  "scaleY":1.1
               },Animate.BackOut);
               Animate.to(m_view.totalXP,0.3,0,{"alpha":1},Animate.ExpoIn);
               Animate.to(m_view.header,0.2,0.1,{"alpha":1},Animate.ExpoOut);
               Animate.addTo(m_view.header,0.4,0.1,{"x":m_view.header.x + 15},Animate.ExpoOut);
               Animate.to(m_view.title,0.2,0.15,{"alpha":1},Animate.ExpoOut);
               Animate.addTo(m_view.title,0.4,0.15,{"x":m_view.title.x + 15},Animate.ExpoOut);
               playSound("ui_debrief_achievement_scorescreen_total_xp");
            });
         }
      }
      
      private function setTexts(param1:String, param2:String) : void
      {
         MenuUtils.setupTextAndShrinkToFitUpper(this.m_view.title,param1,68,MenuConstants.FONT_TYPE_BOLD,this.m_view.title.width,-1,30,MenuConstants.FontColorWhite);
         MenuUtils.setupTextUpper(this.m_view.header,param2,22,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
      }
      
      private function setXpText(param1:int) : void
      {
         var _loc2_:String = MenuUtils.formatNumber(param1) + " " + Localization.get("UI_PERFORMANCE_MASTERY_XP");
         this.playSound("ui_debrief_achievement_scorescreen_tick_xp_lp_stop");
         if(param1 == 0)
         {
            _loc2_ = "";
         }
         MenuUtils.setupTextAndShrinkToFit(this.m_view.totalXP,_loc2_,70,MenuConstants.FONT_TYPE_MEDIUM,this.m_view.totalXP.width,-1,50,MenuConstants.FontColorBlack);
      }
      
      private function setMultiplierText(param1:Number) : void
      {
         MenuUtils.setupTextAndShrinkToFit(this.m_view.totalXP,param1.toFixed(2),70,MenuConstants.FONT_TYPE_MEDIUM,this.m_view.totalXP.width,-1,50,MenuConstants.FontColorBlack);
      }
      
      private function createChallengeTiles() : void
      {
         var _loc4_:Object = null;
         var _loc5_:ImageItemView = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         this.m_loadImageQueue = [];
         this.m_challengeTiles.length = 0;
         var _loc1_:Number = (this.m_tileWidth + this.TILE_GAP) * this.m_tileScale;
         var _loc2_:Number = (this.m_tileHeight + this.TILE_GAP) * this.m_tileScale;
         var _loc3_:int = 0;
         while(_loc3_ < this.m_challenges.length)
         {
            _loc4_ = this.m_challenges[_loc3_];
            _loc5_ = new ImageItemView();
            if((_loc6_ = String(this.m_challengeImages[_loc3_])) != null && _loc6_.length > 0)
            {
               this.m_loadImageQueue.push({
                  "view":_loc5_,
                  "path":_loc6_
               });
            }
            _loc5_.scaleX = this.m_tileScale;
            _loc5_.scaleY = this.m_tileScale;
            _loc8_ = (_loc7_ = _loc3_ % this.m_tileCountX) * _loc1_;
            _loc9_ = Math.floor(_loc3_ / this.m_tileCountX) * _loc2_;
            _loc5_.x = this.m_challengeArea.x + _loc8_;
            _loc5_.y = this.m_challengeArea.y + _loc9_;
            this.m_view.addChild(_loc5_);
            _loc4_.view = _loc5_;
            this.m_challengeTiles.push(_loc4_);
            this.m_shuffledTileIndexes.push(_loc3_);
            _loc3_++;
         }
         this.m_shuffledTileIndexes = MenuUtils.shuffleArray(this.m_shuffledTileIndexes);
      }
      
      private function getRandomDir() : int
      {
         var _loc1_:Number = MenuUtils.getRandomInRange(0,1000);
         if(_loc1_ >= 750)
         {
            return 1;
         }
         if(_loc1_ >= 500)
         {
            return 2;
         }
         if(_loc1_ >= 250)
         {
            return 3;
         }
         return 4;
      }
      
      private function calculateTileScale(param1:Number) : void
      {
         var _loc8_:Boolean = false;
         var _loc9_:int = 0;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc2_:Number = param1;
         var _loc3_:Number = this.m_challengeArea.width + this.TILE_GAP;
         var _loc4_:Number = this.m_challengeArea.height + this.TILE_GAP;
         var _loc5_:Number = this.m_tileWidth + this.TILE_GAP;
         var _loc6_:Number = this.m_tileHeight + this.TILE_GAP;
         this.m_tileCountX = this.m_totalChallengeCount;
         var _loc7_:Number;
         if((_loc7_ = _loc5_ * _loc2_ * this.m_totalChallengeCount) > _loc3_)
         {
            _loc8_ = false;
            this.m_tileCountX = Math.ceil(_loc3_ / (_loc5_ * _loc2_));
            while(!_loc8_)
            {
               _loc9_ = Math.ceil(this.m_totalChallengeCount / this.m_tileCountX);
               _loc2_ = _loc3_ / (this.m_tileCountX * _loc5_);
               if((_loc11_ = (_loc10_ = _loc6_ * _loc2_) * _loc9_) > _loc4_)
               {
                  this.m_tileCountX += 1;
               }
               else
               {
                  _loc8_ = true;
               }
            }
         }
         this.m_tileScale = _loc2_;
      }
      
      private function startLoadImageFromQueue() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < Math.min(this.IMAGE_REQUEST_MAX,this.m_loadImageQueue.length))
         {
            this.loadImageFromQueue();
            _loc1_++;
         }
      }
      
      private function loadImageFromQueue() : void
      {
         var _loc1_:Object = null;
         if(this.m_stopLoading)
         {
            return;
         }
         if(this.m_unloadingImagesInProgress)
         {
            Animate.delay(this.m_view,0.01,this.loadImageFromQueue);
            return;
         }
         if(this.m_loadImageQueue.length > 0)
         {
            _loc1_ = this.m_loadImageQueue.shift();
            ++this.m_loadingImagesInProgress;
            _loc1_.view.loadImage(_loc1_.path,this.loadImageDone,this.loadImageDone,this.m_imageScaleDown);
            this.m_loadImageLoaded.push(_loc1_);
         }
      }
      
      private function loadImageDone() : void
      {
         --this.m_loadingImagesInProgress;
         this.loadImageFromQueue();
      }
      
      private function unloadImagesFromQueue() : void
      {
         var _loc1_:Object = null;
         this.m_stopLoading = true;
         this.m_unloadingImagesInProgress = true;
         while(this.m_loadImageLoaded.length > 0)
         {
            _loc1_ = this.m_loadImageLoaded.pop();
            _loc1_.view.unloadImage();
            this.m_loadImageQueue.unshift(_loc1_);
         }
         this.m_unloadingImagesInProgress = false;
      }
      
      private function killAllAnimations() : void
      {
         Animate.kill(this.m_view.totalXP_bg);
         Animate.kill(this.m_view.totalXP);
         Animate.kill(this.m_view.header);
         Animate.kill(this.m_view.title);
         Animate.kill(this.m_view);
         Animate.kill(this);
      }
      
      override public function onUnregister() : void
      {
         this.killAllAnimations();
         var _loc1_:int = 0;
         while(_loc1_ < this.m_challengeTiles.length)
         {
            this.m_challengeTiles[_loc1_].view.killAnimation();
            _loc1_++;
         }
         this.playSound("ui_debrief_achievement_scorescreen_tick_xp_lp_stop");
         this.playSound("ui_debrief_achievement_scorescreen_tick_lp_stop");
         if(this.m_tilesAppearSoundStarted)
         {
            this.playSound("ui_debrief_achievement_tiles_appear_stop");
            this.m_tilesAppearSoundStarted = false;
         }
         this.unloadImages();
         this.m_challengeTiles.length = 0;
         this.m_view = null;
         super.onUnregister();
      }
   }
}
