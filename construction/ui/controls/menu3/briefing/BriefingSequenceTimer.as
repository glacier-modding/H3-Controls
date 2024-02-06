package menu3.briefing
{
   import common.DateTimeUtils;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   
   public class BriefingSequenceTimer
   {
       
      
      private var countTimer:Timer;
      
      private var countTimerFunctions:Array;
      
      private var m_millisecondsLeft:Number;
      
      private var m_parentObj:Object;
      
      private var m_fontStyle:String;
      
      private var m_fontSize:int;
      
      private var m_fontColorBlack:Boolean;
      
      public function BriefingSequenceTimer()
      {
         super();
      }
      
      public function validateTimeStamp(param1:String) : Boolean
      {
         var _loc2_:Number = DateTimeUtils.getUTCClockNow().getTime();
         var _loc3_:Number = DateTimeUtils.parseUTCTimeStamp(param1).getTime();
         return _loc3_ - _loc2_ > 0;
      }
      
      public function startCountDown(param1:TextField, param2:String, param3:Object, param4:String, param5:int, param6:Boolean) : void
      {
         this.m_fontStyle = param4;
         this.m_fontSize = param5;
         this.m_fontColorBlack = param6;
         this.m_parentObj = param3;
         this.m_millisecondsLeft = 0;
         if(this.countTimer)
         {
            this.countTimer.reset();
            this.countTimer.removeEventListener(TimerEvent.TIMER,this.countTimerFunctions[0]);
            this.countTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.countTimerFunctions[1]);
         }
         this.m_millisecondsLeft = this.getRemainingMilliseconds(param2);
         MenuUtils.setupText(param1,this.formatDurationHHMMSS(this.m_millisecondsLeft),this.m_fontSize,this.m_fontStyle,this.m_fontColorBlack ? MenuConstants.FontColorBlack : MenuConstants.FontColorGreyUltraLight);
         this.countTimer = new Timer(1000,Math.ceil(this.m_millisecondsLeft / 1000));
         this.countTimer.start();
         var _loc7_:Function = this.timerHandler(param1);
         var _loc8_:Function = this.completeHandler(param1);
         this.countTimerFunctions = new Array(_loc7_,_loc8_);
         this.countTimer.addEventListener(TimerEvent.TIMER,_loc7_);
         this.countTimer.addEventListener(TimerEvent.TIMER_COMPLETE,_loc8_);
      }
      
      private function timerHandler(param1:TextField) : Function
      {
         var textfield:TextField = param1;
         return function(param1:TimerEvent):void
         {
            m_millisecondsLeft -= 1000;
            MenuUtils.setupText(textfield,formatDurationHHMMSS(m_millisecondsLeft),m_fontSize,m_fontStyle,m_fontColorBlack ? MenuConstants.FontColorBlack : MenuConstants.FontColorGreyUltraLight);
         };
      }
      
      private function completeHandler(param1:TextField) : Function
      {
         var textfield:TextField = param1;
         return function(param1:TimerEvent):void
         {
            MenuUtils.setupText(textfield,"00:00:00",m_fontSize,m_fontStyle,m_fontColorBlack ? MenuConstants.FontColorBlack : MenuConstants.FontColorGreyUltraLight);
            countTimer.reset();
            countTimer.removeEventListener(TimerEvent.TIMER,countTimerFunctions[0]);
            countTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,countTimerFunctions[1]);
            countTimerFunctions = [];
            m_parentObj.timerComplete();
         };
      }
      
      public function stopCountDown() : void
      {
         if(this.countTimer)
         {
            this.countTimer.reset();
            this.countTimer.removeEventListener(TimerEvent.TIMER,this.countTimerFunctions[0]);
            this.countTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.countTimerFunctions[1]);
            this.countTimerFunctions = [];
         }
      }
      
      private function getRemainingMilliseconds(param1:String) : Number
      {
         var _loc2_:Number = DateTimeUtils.getUTCClockNow().getTime();
         var _loc3_:Number = DateTimeUtils.parseUTCTimeStamp(param1).getTime();
         if(_loc3_ - _loc2_ <= 0)
         {
            return 0;
         }
         return _loc3_ - _loc2_;
      }
      
      private function formatDurationHHMMSS(param1:Number) : String
      {
         return DateTimeUtils.formatDurationHHMMSS(param1);
      }
   }
}
