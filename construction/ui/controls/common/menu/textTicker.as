package common.menu
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.clearTimeout;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   
   public class textTicker
   {
       
      
      private var m_totalFrames:int;
      
      private var m_deltaTime:Number;
      
      private var m_prevFrame:Number;
      
      private var m_currentFrame:Number;
      
      private var m_frameFactor:Number = 0;
      
      private var m_frame:int;
      
      private var m_allValues:Object;
      
      private var m_fakeStage:Sprite;
      
      private var initDelayValue:Number = 500;
      
      private var initDelayID:Number;
      
      private var m_resetDelayValue:Number = 500;
      
      private var m_resetDelayID:Number;
      
      private var m_isRunning:Boolean = false;
      
      public function textTicker()
      {
         this.m_allValues = {};
         super();
      }
      
      public function startTextTicker(param1:TextField, param2:String, param3:Function = null) : void
      {
         var _loc4_:Boolean = true;
         this.startTextTickerInternal(param1,param2,_loc4_,param3);
      }
      
      public function startTextTickerHtml(param1:TextField, param2:String, param3:Function = null, param4:Number = 0) : void
      {
         var _loc5_:Boolean = false;
         this.startTextTickerInternal(param1,param2,_loc5_,param3,param4);
      }
      
      public function isRunning() : Boolean
      {
         return this.m_isRunning;
      }
      
      private function startTextTickerInternal(param1:TextField, param2:String, param3:Boolean, param4:Function, param5:Number = 0) : void
      {
         this.m_totalFrames = 0;
         this.m_deltaTime = 0;
         this.m_prevFrame = 0;
         this.m_currentFrame = 0;
         this.m_frameFactor = 0;
         this.m_frame = 0;
         this.m_resetDelayValue = param5;
         this.m_allValues = {};
         this.m_allValues.textfield = param1;
         if(param3)
         {
            this.m_allValues.textcolor = param1.textColor;
         }
         this.m_allValues.fullString = param2;
         this.m_allValues.onTextChanged = param4;
         if(!this.m_fakeStage)
         {
            this.m_fakeStage = new Sprite();
         }
         clearTimeout(this.m_resetDelayID);
         clearTimeout(this.initDelayID);
         this.initDelayID = setTimeout(this.initTicker,this.initDelayValue,this.m_allValues);
         this.m_isRunning = true;
      }
      
      public function stopTextTicker(param1:TextField, param2:String) : void
      {
         this.m_isRunning = false;
         clearTimeout(this.initDelayID);
         if(this.m_fakeStage)
         {
            this.m_fakeStage.removeEventListener(Event.ENTER_FRAME,this.update);
         }
         param1.scrollH = 0;
         param1.htmlText = param2;
         if(this.m_allValues.onTextChanged != null)
         {
            this.m_allValues.onTextChanged(this.m_allValues.textfield);
         }
      }
      
      private function initTicker(param1:Object) : void
      {
         this.m_allValues.textfield.htmlText = this.m_allValues.fullString;
         this.m_allValues.textfield.multiline = false;
         this.m_allValues.textfield.wordWrap = false;
         if(this.m_allValues.textcolor != null)
         {
            this.m_allValues.textfield.textColor = this.m_allValues.textcolor;
         }
         if(this.m_allValues.onTextChanged != null)
         {
            this.m_allValues.onTextChanged(this.m_allValues.textfield);
         }
         var _loc2_:int = int(this.m_allValues.textfield.maxScrollH);
         if(this.m_allValues.textfield.maxScrollH <= 0)
         {
            return;
         }
         var _loc3_:String = null;
         var _loc4_:int = -1;
         var _loc5_:TextFormat;
         if((_loc5_ = this.m_allValues.textfield.getTextFormat()) != null)
         {
            _loc3_ = _loc5_.font;
            _loc4_ = _loc5_.size != null ? int(_loc5_.size) : -1;
         }
         var _loc6_:* = "      ";
         if(_loc3_ != null && _loc4_ > 0)
         {
            _loc6_ = "<font face=\"" + _loc3_ + "\" size=\"" + _loc4_ + "\">" + _loc6_ + "</font>";
         }
         this.m_allValues.textfield.htmlText = this.m_allValues.fullString + _loc6_ + this.m_allValues.fullString;
         if(this.m_allValues.textcolor != null)
         {
            this.m_allValues.textfield.textColor = this.m_allValues.textcolor;
         }
         if(this.m_allValues.onTextChanged != null)
         {
            this.m_allValues.onTextChanged(this.m_allValues.textfield);
         }
         this.m_totalFrames = param1.textfield.maxScrollH - _loc2_;
         this.goTextTicker();
      }
      
      private function goTextTicker() : void
      {
         if(this.m_fakeStage)
         {
            this.m_fakeStage.addEventListener(Event.ENTER_FRAME,this.update);
         }
         this.m_prevFrame = getTimer();
      }
      
      private function update(param1:Event) : void
      {
         this.m_currentFrame = getTimer();
         this.m_deltaTime = (this.m_currentFrame - this.m_prevFrame) * 0.001;
         this.m_prevFrame = this.m_currentFrame;
         this.m_frameFactor += 100 / (1 / this.m_deltaTime);
         this.m_frame = Math.ceil(this.m_frameFactor);
         if(this.m_frame > this.m_totalFrames)
         {
            this.m_frame = this.m_totalFrames;
            this.m_frameFactor = 0;
            if(this.m_resetDelayValue > 0)
            {
               if(this.m_fakeStage != null)
               {
                  this.m_fakeStage.removeEventListener(Event.ENTER_FRAME,this.update);
               }
               clearTimeout(this.m_resetDelayID);
               this.m_resetDelayID = setTimeout(this.goTextTicker,this.m_resetDelayValue);
            }
         }
         this.m_allValues.textfield.scrollH = this.m_frame;
      }
      
      public function setTextColor(param1:int) : void
      {
         this.m_allValues.textcolor = param1;
      }
   }
}
