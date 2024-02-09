package menu3.tests.elusivetargetbriefingsequence
{
   import common.Animate;
   import common.Localization;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.text.TextField;
   import menu3.CountDownTimer;
   import menu3.MenuElementBase;
   import menu3.basic.TextTickerUtil;
   
   public dynamic class ElusiveTargetTesterSequenceBase extends MenuElementBase
   {
       
      
      public var m_countDownTimer:CountDownTimer;
      
      private var m_textTickerUtil:TextTickerUtil;
      
      public var m_textFieldVars:Object;
      
      public var m_unitWidth:Number;
      
      public var m_unitHeight:Number;
      
      public function ElusiveTargetTesterSequenceBase(param1:Object)
      {
         this.m_textTickerUtil = new TextTickerUtil();
         this.m_unitWidth = MenuConstants.BaseWidth / 10;
         this.m_unitHeight = MenuConstants.BaseHeight / 6;
         super(param1);
      }
      
      public function createRedOverlay(param1:Object, param2:Number, param3:Sprite) : void
      {
         var delayDuration:Number = NaN;
         var redOverlaySplit01:Sprite = null;
         var redOverlaySplit02:Sprite = null;
         var data:Object = param1;
         var totalduration:Number = param2;
         var container:Sprite = param3;
         delayDuration = totalduration - data.animatein.duration - data.animateout.duration;
         redOverlaySplit01 = new Sprite();
         redOverlaySplit01.name = "redOverlaySplit01";
         redOverlaySplit01.graphics.clear();
         redOverlaySplit01.graphics.beginFill(MenuConstants.COLOR_RED,1);
         redOverlaySplit02 = new Sprite();
         redOverlaySplit02.name = "redOverlaySplit02";
         redOverlaySplit02.graphics.clear();
         redOverlaySplit02.graphics.beginFill(MenuConstants.COLOR_RED,1);
         if(data.animatedirection == "horizontal")
         {
            redOverlaySplit01.graphics.drawRect(0,0,-MenuConstants.BaseWidth,MenuConstants.BaseHeight);
            redOverlaySplit01.graphics.endFill();
            redOverlaySplit01.x = this.m_unitWidth * data.animatein.first_startpos;
            redOverlaySplit02.graphics.drawRect(0,0,MenuConstants.BaseWidth,MenuConstants.BaseHeight);
            redOverlaySplit02.graphics.endFill();
            redOverlaySplit02.x = this.m_unitWidth * data.animatein.second_startpos;
            container.addChild(redOverlaySplit01);
            container.addChild(redOverlaySplit02);
            Animate.to(redOverlaySplit01,data.animatein.duration,0,{"x":this.m_unitWidth * data.animatein.first_endpos},Animate.ExpoOut,function():void
            {
               Animate.fromTo(redOverlaySplit01,data.animateout.duration,delayDuration,{"x":m_unitWidth * data.animateout.first_startpos},{"x":m_unitWidth * data.animateout.first_endpos},Animate.ExpoOut);
            });
            Animate.to(redOverlaySplit02,data.animatein.duration,0,{"x":this.m_unitWidth * data.animatein.second_endpos},Animate.ExpoOut,function():void
            {
               Animate.fromTo(redOverlaySplit02,data.animateout.duration,delayDuration,{"x":m_unitWidth * data.animateout.second_startpos},{"x":m_unitWidth * data.animateout.second_endpos},Animate.ExpoOut);
            });
         }
         else if(data.animatedirection == "vertical")
         {
            redOverlaySplit01.graphics.drawRect(0,0,MenuConstants.BaseWidth,-MenuConstants.BaseHeight);
            redOverlaySplit01.graphics.endFill();
            redOverlaySplit01.y = this.m_unitHeight * data.animatein.first_startpos;
            redOverlaySplit02.graphics.drawRect(0,0,MenuConstants.BaseWidth,MenuConstants.BaseHeight);
            redOverlaySplit02.graphics.endFill();
            redOverlaySplit02.y = this.m_unitHeight * data.animatein.second_startpos;
            container.addChild(redOverlaySplit01);
            container.addChild(redOverlaySplit02);
            Animate.to(redOverlaySplit01,data.animatein.duration,0,{"y":this.m_unitHeight * data.animatein.first_endpos},Animate.ExpoOut,function():void
            {
               Animate.fromTo(redOverlaySplit01,data.animateout.duration,delayDuration,{"y":m_unitHeight * data.animateout.first_startpos},{"y":m_unitHeight * data.animateout.first_endpos},Animate.ExpoOut);
            });
            Animate.to(redOverlaySplit02,data.animatein.duration,0,{"y":this.m_unitHeight * data.animatein.second_endpos},Animate.ExpoOut,function():void
            {
               Animate.fromTo(redOverlaySplit02,data.animateout.duration,delayDuration,{"y":m_unitHeight * data.animateout.second_startpos},{"y":m_unitHeight * data.animateout.second_endpos},Animate.ExpoOut);
            });
         }
      }
      
      public function animateSequenceContainer(param1:Object, param2:Sprite) : void
      {
         var delayDuration:Number = NaN;
         var data:Object = param1;
         var currentSequenceContainer:Sprite = param2;
         delayDuration = data.sequence.totalduration - data.sequence.animatein.duration;
         if(data.sequence.animatedirection == "horizontal")
         {
            currentSequenceContainer.x = this.m_unitWidth * data.sequence.animatein.startpos;
            currentSequenceContainer.y = 0;
            currentSequenceContainer.alpha = 1;
            Animate.to(currentSequenceContainer,data.sequence.animatein.duration,0,{"x":this.m_unitWidth * data.sequence.animatein.endpos},Animate.ExpoInOut,function():void
            {
               currentSequenceContainer.x = m_unitWidth * data.sequence.animateout.startpos;
               Animate.to(currentSequenceContainer,data.sequence.animateout.duration,delayDuration,{"x":m_unitWidth * data.sequence.animateout.endpos},Animate.ExpoInOut);
            });
         }
         else if(data.sequence.animatedirection == "vertical")
         {
            currentSequenceContainer.x = 0;
            currentSequenceContainer.y = this.m_unitHeight * data.sequence.animatein.startpos;
            currentSequenceContainer.alpha = 1;
            Animate.to(currentSequenceContainer,data.sequence.animatein.duration,0,{"y":this.m_unitHeight * data.sequence.animatein.endpos},Animate.ExpoInOut,function():void
            {
               currentSequenceContainer.y = m_unitHeight * data.sequence.animateout.startpos;
               Animate.to(currentSequenceContainer,data.sequence.animateout.duration,delayDuration,{"y":m_unitHeight * data.sequence.animateout.endpos},Animate.ExpoInOut);
            });
         }
      }
      
      public function animateImageContainer(param1:DisplayObjectContainer, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:String) : void
      {
         var _loc10_:int = this.getEasing(param9);
         var _loc11_:Number = (param2 - param2 * param7) / 2;
         var _loc12_:Number = (param2 - param2 * param8) / 2;
         var _loc13_:Number = (param3 - param3 * param7) / 2;
         var _loc14_:Number = (param3 - param3 * param8) / 2;
         param1.x = this.m_unitWidth * param5 + _loc11_;
         param1.y = _loc13_;
         param1.scaleX = param1.scaleY = param7;
         Animate.to(param1,param4,0,{
            "x":this.m_unitWidth * param6 + _loc12_,
            "y":_loc14_,
            "scaleX":param8,
            "scaleY":param8
         },_loc10_);
      }
      
      public function insertTextBlock(param1:Object, param2:Number, param3:*) : void
      {
         if(param1.type == "etsequencetimer")
         {
            param3.x = this.m_unitWidth * param1.xpos;
            param3.y = this.m_unitHeight * param1.ypos;
            EtSequenceTextBlocks.setupTimerBlock(param1,param3,this);
            this.animateTextBlock(param3,param1.animatedirection,param1.animatein,param1.animateout,param2);
         }
      }
      
      private function animateTextBlock(param1:*, param2:String, param3:Object, param4:Object, param5:Number) : void
      {
         var theEasingOut:int = 0;
         var delayDuration:Number = NaN;
         var container:* = param1;
         var animatedirection:String = param2;
         var animatein:Object = param3;
         var animateout:Object = param4;
         var totalduration:Number = param5;
         var theEasingIn:int = this.getEasing(animatein.easing);
         theEasingOut = this.getEasing(animateout.easing);
         delayDuration = totalduration - animatein.duration - animateout.duration;
         if(animatedirection == "horizontal")
         {
            Animate.fromTo(container,animatein.duration,0,{"x":this.m_unitWidth * animatein.startpos},{"x":this.m_unitWidth * animatein.endpos},theEasingIn,function():void
            {
               Animate.fromTo(container,animateout.duration,delayDuration,{"x":m_unitWidth * animateout.startpos},{"x":m_unitWidth * animateout.endpos},theEasingOut);
            });
         }
         else if(animatedirection == "vertical")
         {
            Animate.fromTo(container,animatein.duration,0,{"y":this.m_unitHeight * animatein.startpos},{"y":this.m_unitHeight * animatein.endpos},theEasingIn,function():void
            {
               Animate.fromTo(container,animateout.duration,delayDuration,{"y":m_unitHeight * animateout.startpos},{"y":m_unitHeight * animateout.endpos},theEasingOut);
            });
         }
      }
      
      public function getEasing(param1:String) : int
      {
         var _loc2_:int = 0;
         switch(param1)
         {
            case "Linear":
               _loc2_ = Animate.Linear;
               break;
            case "SineIn":
               _loc2_ = Animate.SineIn;
               break;
            case "SineOut":
               _loc2_ = Animate.SineOut;
               break;
            case "SineInOut":
               _loc2_ = Animate.SineInOut;
               break;
            case "ExpoIn":
               _loc2_ = Animate.ExpoIn;
               break;
            case "ExpoOut":
               _loc2_ = Animate.ExpoOut;
               break;
            case "ExpoInOut":
               _loc2_ = Animate.ExpoInOut;
               break;
            case "BackIn":
               _loc2_ = Animate.BackIn;
               break;
            case "BackOut":
               _loc2_ = Animate.BackOut;
               break;
            case "BackInOut":
               _loc2_ = Animate.BackInOut;
               break;
            default:
               _loc2_ = Animate.Linear;
         }
         return _loc2_;
      }
      
      public function startCountDownTimer(param1:String, param2:TextField, param3:int) : void
      {
         this.m_textFieldVars = {
            "theTextField":param2,
            "theStyle":param3
         };
         if(this.m_countDownTimer)
         {
            this.m_countDownTimer.stopCountDown();
            this.m_countDownTimer = null;
         }
         if(Boolean(param1) && !this.m_countDownTimer)
         {
            this.m_countDownTimer = new CountDownTimer();
            this.m_countDownTimer.startCountDown(param2,param1,this,param3);
         }
      }
      
      public function stopCountDownTimer() : void
      {
         this.m_countDownTimer.stopCountDown();
         this.m_countDownTimer = null;
      }
      
      public function timerComplete() : void
      {
         this.m_countDownTimer.stopCountDown();
         this.m_countDownTimer = null;
      }
      
      private function showTimeRanOut() : void
      {
         MenuUtils.setupText(this.m_textFieldVars.theTextField,Localization.get("UI_CONTRACT_ELUSIVE_STATE_TIME_RAN_OUT"),148,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorRed);
         MenuUtils.truncateTextfield(this.m_textFieldVars.theTextField,1,MenuConstants.FontColorRed);
         this.m_textTickerUtil.addTextTicker(this.m_textFieldVars.theTextField,Localization.get("UI_CONTRACT_ELUSIVE_STATE_TIME_RAN_OUT"),MenuConstants.FontColorRed,MenuConstants.COLOR_RED);
      }
      
      override public function onUnregister() : void
      {
         if(this.m_countDownTimer)
         {
            trace("XXXXXXXXXXXXXXXXX ElusiveTargetTesterSequenceBase | onUnregister | Stopping m_countDownTimer!!!");
            this.m_countDownTimer.stopCountDown();
            this.m_countDownTimer = null;
         }
         super.onUnregister();
      }
   }
}
