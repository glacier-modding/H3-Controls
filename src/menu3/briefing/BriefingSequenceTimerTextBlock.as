package menu3.briefing
{
   import common.Animate;
   import common.BaseControl;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextLineMetrics;
   
   public class BriefingSequenceTimerTextBlock extends BaseControl
   {
       
      
      public var m_countDownTimer:BriefingSequenceTimer;
      
      private var m_theTextField:TextField;
      
      private var m_playableUntil:String = "";
      
      private var m_countDownTextContainer:Sprite;
      
      private var m_textFieldRows:Number = 0;
      
      private var m_flickerIn:Boolean;
      
      private var m_flickerOut:Boolean;
      
      private var m_fontStyle:String;
      
      private var m_fontSize:int;
      
      private var m_fontColorBlack:Boolean;
      
      private var m_textRightAligned:Boolean;
      
      private var m_appendUpwards:Boolean;
      
      private var m_showRegPoint:Boolean;
      
      private var m_animateInDuration:Number;
      
      private var m_animateInStartRow:Number;
      
      private var m_animateInEndRow:Number;
      
      private var m_animateInStartCol:Number;
      
      private var m_animateInEndCol:Number;
      
      private var m_animateInEasingType:int;
      
      private var m_animateOutDuration:Number;
      
      private var m_animateOutStartRow:Number;
      
      private var m_animateOutEndRow:Number;
      
      private var m_animateOutStartCol:Number;
      
      private var m_animateOutEndCol:Number;
      
      private var m_animateOutEasingType:int;
      
      private var m_unitWidth:Number;
      
      private var m_unitHeight:Number;
      
      public function BriefingSequenceTimerTextBlock()
      {
         this.m_unitWidth = MenuConstants.BaseWidth / 10;
         this.m_unitHeight = MenuConstants.BaseHeight / 6;
         super();
         trace("ETBriefing | BriefingSequenceTimerTextBlock CALLED!!!");
         this.m_countDownTextContainer = new Sprite();
         this.m_countDownTextContainer.name = "m_countDownTextContainer";
         addChild(this.m_countDownTextContainer);
      }
      
      private function startCountDownTimer(param1:TextField, param2:String) : void
      {
         if(this.m_countDownTimer)
         {
            this.m_countDownTimer.stopCountDown();
            this.m_countDownTimer = null;
         }
         if(Boolean(param2) && !this.m_countDownTimer)
         {
            this.m_countDownTimer = new BriefingSequenceTimer();
            this.m_countDownTimer.startCountDown(param1,param2,this,this.m_fontStyle,this.m_fontSize,this.m_fontColorBlack);
         }
      }
      
      public function stopCountDownTimer() : void
      {
         trace("ETBriefing | BriefingSequenceTimerTextBlock | stopCountDownTimer CALLED!!!");
         this.m_countDownTimer.stopCountDown();
         this.m_countDownTimer = null;
      }
      
      public function timerComplete() : void
      {
         this.m_countDownTimer.stopCountDown();
         this.m_countDownTimer = null;
      }
      
      public function start(param1:Number, param2:Number) : void
      {
         var _loc8_:DotIndicatorView = null;
         this.m_countDownTextContainer.x = this.m_unitWidth * this.m_animateInStartRow;
         this.m_countDownTextContainer.y = this.m_unitHeight * this.m_animateInStartCol;
         var _loc3_:TextFormat = new TextFormat();
         if(this.m_textRightAligned)
         {
            _loc3_.align = "right";
         }
         this.m_theTextField = new TextField();
         this.m_theTextField.alpha = 0;
         this.m_theTextField.autoSize = "left";
         this.m_theTextField.width = this.m_unitWidth * this.m_textFieldRows;
         MenuUtils.setupText(this.m_theTextField,"PgpqjMNOPQwWx:0123456789",this.m_fontSize,this.m_fontStyle,this.m_fontColorBlack ? MenuConstants.FontColorBlack : MenuConstants.FontColorGreyUltraLight);
         var _loc4_:TextLineMetrics = this.m_theTextField.getLineMetrics(0);
         this.m_theTextField.setTextFormat(_loc3_);
         this.m_countDownTextContainer.addChild(this.m_theTextField);
         this.startCountDownTimer(this.m_theTextField,this.m_playableUntil);
         this.m_theTextField.setTextFormat(_loc3_);
         this.m_theTextField.alpha = 1;
         var _loc5_:Number = _loc4_.ascent;
         var _loc6_:int = 3;
         var _loc7_:int = Math.ceil(this.m_fontSize * 0.23);
         this.m_theTextField.x = -_loc6_;
         this.m_theTextField.y = -_loc7_;
         if(this.m_appendUpwards)
         {
            this.m_theTextField.y = -_loc5_;
         }
         if(this.m_showRegPoint)
         {
            _loc8_ = new DotIndicatorView();
            this.m_countDownTextContainer.addChild(_loc8_);
         }
         Animate.delay(this,param2,this.startSequence,param1);
      }
      
      private function startSequence(param1:Number) : void
      {
         var delayDuration:Number = NaN;
         var flickerInDurations:Vector.<Number> = null;
         var flickerOutDurations:Vector.<Number> = null;
         var flickerOutTotalDuration:Number = NaN;
         var i:int = 0;
         var baseduration:Number = param1;
         Animate.kill(this);
         Animate.kill(this.m_theTextField);
         delayDuration = baseduration - this.m_animateInDuration - this.m_animateOutDuration;
         if(this.m_flickerIn)
         {
            flickerInDurations = new Vector.<Number>();
            this.pushFlickerValues(flickerInDurations);
            this.startFlicker(flickerInDurations);
         }
         if(this.m_flickerOut)
         {
            flickerOutDurations = new Vector.<Number>();
            this.pushFlickerValues(flickerOutDurations);
            flickerOutTotalDuration = 0;
            i = 0;
            while(i < flickerOutDurations.length)
            {
               flickerOutTotalDuration += flickerOutDurations[i];
               i++;
            }
            Animate.delay(this,baseduration - flickerOutTotalDuration,this.startFlicker,flickerOutDurations);
         }
         Animate.to(this.m_countDownTextContainer,this.m_animateInDuration,0,{
            "x":this.m_unitWidth * this.m_animateInEndRow,
            "y":this.m_unitHeight * this.m_animateInEndCol
         },this.m_animateInEasingType,function():void
         {
            Animate.fromTo(m_countDownTextContainer,m_animateOutDuration,delayDuration,{
               "x":m_unitWidth * m_animateOutStartRow,
               "y":m_unitHeight * m_animateOutStartCol
            },{
               "x":m_unitWidth * m_animateOutEndRow,
               "y":m_unitHeight * m_animateOutEndCol
            },m_animateOutEasingType);
         });
      }
      
      private function startFlicker(param1:Vector.<Number>) : void
      {
         Animate.kill(this.m_theTextField);
         if(this.m_theTextField.alpha > 0)
         {
            this.m_theTextField.alpha = 0;
         }
         else if(this.m_theTextField.alpha == 0)
         {
            this.m_theTextField.alpha = this.getRandomRange(2,10) / 10;
         }
         if(param1.length >= 1)
         {
            Animate.delay(this.m_theTextField,param1.pop(),this.startFlicker,param1);
         }
         else if(this.m_flickerIn)
         {
            this.m_theTextField.alpha = 1;
            this.m_flickerIn = false;
         }
         else if(this.m_flickerOut)
         {
            this.m_theTextField.alpha = 0;
            this.m_flickerOut = false;
         }
      }
      
      private function getRandomRange(param1:Number, param2:Number) : Number
      {
         return Math.floor(Math.random() * (param2 - param1 + 1)) + param1;
      }
      
      private function pushFlickerValues(param1:Vector.<Number>) : void
      {
         var _loc2_:int = this.getRandomRange(3,10);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            param1.push(this.getRandomRange(2,20) / 300);
            _loc3_++;
         }
      }
      
      override public function getContainer() : Sprite
      {
         return this.m_countDownTextContainer;
      }
      
      public function set PlayableUntil(param1:String) : void
      {
         this.m_playableUntil = param1;
      }
      
      public function set TextFieldWidthInRows(param1:Number) : void
      {
         this.m_textFieldRows = param1;
      }
      
      public function set FontStyle(param1:String) : void
      {
         switch(param1)
         {
            case "Light":
               this.m_fontStyle = MenuConstants.FONT_TYPE_LIGHT;
               break;
            case "Normal":
               this.m_fontStyle = MenuConstants.FONT_TYPE_NORMAL;
               break;
            case "Medium":
               this.m_fontStyle = MenuConstants.FONT_TYPE_MEDIUM;
               break;
            case "Bold":
               this.m_fontStyle = MenuConstants.FONT_TYPE_BOLD;
               break;
            default:
               this.m_fontStyle = MenuConstants.FONT_TYPE_NORMAL;
         }
      }
      
      public function set FontSize(param1:int) : void
      {
         this.m_fontSize = param1;
      }
      
      public function set FontColorBlack(param1:Boolean) : void
      {
         this.m_fontColorBlack = param1;
      }
      
      public function set TextRightAligned(param1:Boolean) : void
      {
         this.m_textRightAligned = param1;
      }
      
      public function set TextAppendUpwards(param1:Boolean) : void
      {
         this.m_appendUpwards = param1;
      }
      
      public function set ShowHelperRegistrationPoint(param1:Boolean) : void
      {
         this.m_showRegPoint = param1;
      }
      
      public function set FlickerInFx(param1:Boolean) : void
      {
         this.m_flickerIn = param1;
      }
      
      public function set FlickerOutFx(param1:Boolean) : void
      {
         this.m_flickerOut = param1;
      }
      
      public function set AnimateInDuration(param1:Number) : void
      {
         this.m_animateInDuration = param1;
      }
      
      public function set AnimateInStartRow(param1:Number) : void
      {
         this.m_animateInStartRow = param1;
      }
      
      public function set AnimateInEndRow(param1:Number) : void
      {
         this.m_animateInEndRow = param1;
      }
      
      public function set AnimateInStartCol(param1:Number) : void
      {
         this.m_animateInStartCol = param1;
      }
      
      public function set AnimateInEndCol(param1:Number) : void
      {
         this.m_animateInEndCol = param1;
      }
      
      public function set AnimateInEasingType(param1:String) : void
      {
         this.m_animateInEasingType = MenuUtils.getEaseType(param1);
      }
      
      public function set AnimateOutDuration(param1:Number) : void
      {
         this.m_animateOutDuration = param1;
      }
      
      public function set AnimateOutStartRow(param1:Number) : void
      {
         this.m_animateOutStartRow = param1;
      }
      
      public function set AnimateOutEndRow(param1:Number) : void
      {
         this.m_animateOutEndRow = param1;
      }
      
      public function set AnimateOutStartCol(param1:Number) : void
      {
         this.m_animateOutStartCol = param1;
      }
      
      public function set AnimateOutEndCol(param1:Number) : void
      {
         this.m_animateOutEndCol = param1;
      }
      
      public function set AnimateOutEasingType(param1:String) : void
      {
         this.m_animateOutEasingType = MenuUtils.getEaseType(param1);
      }
   }
}
