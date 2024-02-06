package hud.sniper
{
   import common.Animate;
   import common.BaseControl;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   
   public class TargetTimerElement extends BaseControl
   {
      
      public static const BAR_ELEMENT_FADE_ANIM_TIME:Number = 0.3;
       
      
      private var m_view:TargetTimerElementView;
      
      private var m_initialSeconds:int;
      
      private var m_initialScaleFactor:Number;
      
      private var m_initialNumberOfNPCs:int;
      
      private var m_prevNumberOfNPCs:int;
      
      public function TargetTimerElement()
      {
         super();
         this.m_view = new TargetTimerElementView();
         this.m_view.timer.valuebar.alpha = 0.25;
         addChild(this.m_view);
      }
      
      public function updateAndShowObjectives(param1:Object) : void
      {
         Animate.kill(this.m_view);
         this.m_view.alpha = 1;
      }
      
      public function updateTimers(param1:Array) : void
      {
         var _loc2_:Object = param1[0];
         MenuUtils.setupText(this.m_view.timer.time_txt,_loc2_.timerString,18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         var _loc3_:String = String(_loc2_.timerString.slice(0,2));
         var _loc4_:String = String(_loc2_.timerString.slice(3,5));
         var _loc5_:int = int(_loc3_) * 60 + int(_loc4_);
         if(!this.m_initialSeconds)
         {
            this.m_initialSeconds = _loc5_;
            this.m_initialScaleFactor = 258 / _loc5_;
         }
         this.m_view.timer.valuebar.width = this.m_initialScaleFactor * _loc5_;
      }
      
      public function updateCounters(param1:Array) : void
      {
         var counterData:Object = null;
         var numberOfNpcsLeft:int = 0;
         var countersArray:Array = param1;
         var i:Number = 0;
         while(i < countersArray.length)
         {
            counterData = countersArray[i];
            if(counterData.isActive)
            {
               numberOfNpcsLeft = int(counterData.counterString);
               if(!this.m_initialNumberOfNPCs)
               {
                  this.m_initialNumberOfNPCs = numberOfNpcsLeft;
                  Animate.fromTo(this.m_view.npcs,1,0,{"frames":1},{"frames":this.m_initialNumberOfNPCs},Animate.ExpoIn);
               }
               if(numberOfNpcsLeft == this.m_prevNumberOfNPCs)
               {
                  return;
               }
               if(numberOfNpcsLeft != this.m_initialNumberOfNPCs)
               {
                  if(counterData.counterExtraData.TargetEscaped)
                  {
                     this.m_view.npcs["n_" + (numberOfNpcsLeft + 1)].gotoAndStop("escaped");
                  }
                  else
                  {
                     Animate.fromTo(this.m_view.npcs["n_" + (numberOfNpcsLeft + 1)],0.5,0,{"frames":2},{"frames":32},Animate.ExpoOut,function():void
                     {
                        Animate.kill(m_view.npcs["n_" + (numberOfNpcsLeft + 1)]);
                        m_view.npcs["n_" + (numberOfNpcsLeft + 1)].gotoAndStop("dead");
                     });
                  }
               }
               this.m_prevNumberOfNPCs = numberOfNpcsLeft;
            }
            i++;
         }
      }
      
      public function hideObjectives() : void
      {
         Animate.kill(this.m_view);
         Animate.legacyTo(this.m_view,BAR_ELEMENT_FADE_ANIM_TIME,{"alpha":0},Animate.Linear,function():void
         {
            Animate.kill(m_view);
            m_view.alpha = 0;
         });
      }
   }
}
