package menu3
{
   import common.DateTimeUtils;
   import common.Log;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   
   public class CountDownTimer
   {
       
      
      private var countTimer:Timer;
      
      private var countTimerFunctions:Array;
      
      private var m_millisecondsLeft:Number;
      
      private var m_parentObj:Object;
      
      public function CountDownTimer()
      {
         super();
      }
      
      public function validateTimeStamp(param1:String) : Boolean
      {
         var _loc2_:Number = DateTimeUtils.getUTCClockNow().getTime();
         var _loc3_:Number = DateTimeUtils.parseUTCTimeStamp(param1).getTime();
         return _loc3_ - _loc2_ > 0;
      }
      
      public function startCountDown(param1:TextField, param2:String, param3:Object, param4:int = 38, param5:String = "#EBEBEB") : void
      {
         this.m_parentObj = param3;
         this.m_millisecondsLeft = 0;
         if(this.countTimer)
         {
            this.countTimer.reset();
            this.countTimer.removeEventListener(TimerEvent.TIMER,this.countTimerFunctions[0]);
            this.countTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.countTimerFunctions[1]);
         }
         this.m_millisecondsLeft = this.getRemainingMilliseconds(param2);
         MenuUtils.setupTextUpper(param1,this.formatDurationHHMMSS(this.m_millisecondsLeft),param4,MenuConstants.FONT_TYPE_MEDIUM,param5);
         var _loc6_:Number;
         if((_loc6_ = Math.ceil(this.m_millisecondsLeft / 1000)) >= int.MAX_VALUE)
         {
            Log.warning(Log.ChannelDebug,this,"startCountDown: Timer not started, because the time period is too big. Only int.MAX_VALUE seconds are supported (or 69.8 years)");
            return;
         }
         this.countTimer = new Timer(1000,_loc6_);
         this.countTimer.start();
         var _loc7_:Function = this.timerHandler(param1,param4,param5);
         var _loc8_:Function = this.completeHandler(param1,param4,param5);
         this.countTimerFunctions = new Array(_loc7_,_loc8_);
         this.countTimer.addEventListener(TimerEvent.TIMER,_loc7_);
         this.countTimer.addEventListener(TimerEvent.TIMER_COMPLETE,_loc8_);
      }
      
      private function timerHandler(param1:TextField, param2:int, param3:String) : Function
      {
         var textfield:TextField = param1;
         var fontSize:int = param2;
         var fontColor:String = param3;
         return function(param1:TimerEvent):void
         {
            m_millisecondsLeft -= 1000;
            MenuUtils.setupTextUpper(textfield,formatDurationHHMMSS(m_millisecondsLeft),fontSize,MenuConstants.FONT_TYPE_MEDIUM,fontColor);
         };
      }
      
      private function completeHandler(param1:TextField, param2:int, param3:String) : Function
      {
         var textfield:TextField = param1;
         var fontSize:int = param2;
         var fontColor:String = param3;
         return function(param1:TimerEvent):void
         {
            MenuUtils.setupTextUpper(textfield,"00:00:00",fontSize,MenuConstants.FONT_TYPE_MEDIUM,fontColor);
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
