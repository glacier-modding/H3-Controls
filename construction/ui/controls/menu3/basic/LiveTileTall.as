package menu3.basic
{
   import common.Animate;
   import common.MouseUtil;
   import common.menu.MenuConstants;
   import flash.display.Sprite;
   
   public dynamic class LiveTileTall extends MenuTileTall
   {
      
      private static const DotIndicatorX:Number = 170.5;
      
      private static const DotIndicatorY:Number = 16;
       
      
      private var m_dotIndicators:Sprite;
      
      private var m_dots:Array;
      
      private var m_timerdot:DotIndicatorTimerView;
      
      private var m_tileCount:int;
      
      private var m_timeremain:Number = 0;
      
      private var m_dotAnimationStarted:Boolean = false;
      
      public function LiveTileTall(param1:Object)
      {
         this.m_dots = new Array();
         super(param1);
         m_mouseWheelMode = MouseUtil.MODE_WHEEL_GROUP;
         this.m_dotIndicators = new Sprite();
         this.m_dotIndicators.x = DotIndicatorX;
         this.m_dotIndicators.y = DotIndicatorY;
         m_view.indicator.addChild(this.m_dotIndicators);
      }
      
      override public function onSetData(param1:Object) : void
      {
         super.onSetData(param1);
         Animate.complete(m_view.tileIcon.icons);
         m_view.tileIcon.icons.alpha = 0;
         m_view.tileIcon.icons.gotoAndStop(param1.icon);
         Animate.legacyTo(m_view.tileIcon.icons,MenuConstants.HiliteTime,{"alpha":1},Animate.Linear);
         this.setIndexIndicator(getNodeProp(this,"livetileindex"),getNodeProp(this,"livetilecount"),getNodeProp(this,"lifetimeinterval"),getNodeProp(this,"lifetimeremaining"));
      }
      
      public function startDotAnimation(param1:Object) : void
      {
         this.m_dotAnimationStarted = true;
         this.animateDots(param1);
      }
      
      private function setIndexIndicator(param1:int, param2:int, param3:Number, param4:Number) : void
      {
         var _loc5_:int = 0;
         var _loc6_:DotIndicatorView = null;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         this.removeTimerDot();
         if(param2 != this.m_tileCount)
         {
            this.removeDots();
            this.m_tileCount = param2;
            if(this.m_tileCount > 1)
            {
               _loc5_ = 0;
               while(_loc5_ < this.m_tileCount)
               {
                  (_loc6_ = new DotIndicatorView()).x = _loc5_ * 15;
                  _loc6_.alpha = 0.5;
                  this.m_dots.push(_loc6_);
                  this.m_dotIndicators.addChild(_loc6_);
                  this.m_dotIndicators.x = m_view.tileDarkBg.width / 2 + _loc5_ * (15 / -2);
                  _loc5_++;
               }
            }
         }
         if(this.m_dots.length)
         {
            this.m_timerdot = new DotIndicatorTimerView();
            this.m_timerdot.width = this.m_timerdot.height = 10;
            this.m_timerdot.x = this.m_dots[param1].x;
            this.m_dotIndicators.addChild(this.m_timerdot);
            _loc7_ = Math.max(param4,param3);
            _loc8_ = 100 / _loc7_;
            this.m_timeremain = param4;
            _loc9_ = _loc8_ * this.m_timeremain;
            this.m_timerdot.gotoAndStop(100 - _loc9_);
            this.animateDots(null);
         }
      }
      
      private function removeTimerDot() : void
      {
         if(this.m_timerdot)
         {
            Animate.kill(this.m_timerdot);
            this.m_dotIndicators.removeChild(this.m_timerdot);
            this.m_timerdot = null;
         }
      }
      
      private function removeDots() : void
      {
         var _loc2_:DotIndicatorView = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.m_dots.length)
         {
            _loc2_ = this.m_dots[_loc1_];
            this.m_dotIndicators.removeChild(_loc2_);
            _loc1_++;
         }
         this.m_dots = [];
      }
      
      private function animateDots(param1:Object) : void
      {
         var reset:Boolean = false;
         var data:Object = param1;
         reset = data != null && data.reset === true;
         if(Boolean(this.m_dots.length) && this.m_dotAnimationStarted)
         {
            if(reset)
            {
               this.m_timerdot.gotoAndStop(0);
            }
            Animate.to(this.m_timerdot,this.m_timeremain,0,{"frames":100},Animate.Linear,function():void
            {
               if(reset)
               {
                  m_dotAnimationStarted = false;
               }
            });
         }
      }
      
      override public function onUnregister() : void
      {
         if(m_view)
         {
            this.completeDotAnimations();
            this.removeTimerDot();
            this.removeDots();
            m_view.indicator.removeChild(this.m_dotIndicators);
            this.m_dotIndicators = null;
         }
         super.onUnregister();
      }
      
      private function completeDotAnimations() : void
      {
         var _loc1_:int = 0;
         if(this.m_dots.length)
         {
            _loc1_ = 0;
            while(_loc1_ < this.m_dots.length)
            {
               Animate.complete(this.m_dots[_loc1_]);
               _loc1_++;
            }
         }
         Animate.complete(m_view.tileIcon.icons);
      }
   }
}
