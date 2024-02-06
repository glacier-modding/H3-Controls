package menu3.statistics
{
   import common.Animate;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class StatisticBars extends Sprite
   {
       
      
      private var m_view:StatisticsBarView;
      
      private var m_data:Object;
      
      private var m_showValues:Boolean = true;
      
      private var m_statisticBars:Array;
      
      public function StatisticBars(param1:Object)
      {
         this.m_statisticBars = [];
         super();
         this.m_data = param1;
         this.m_showValues = this.m_data.isAvailable;
         this.m_view = new StatisticsBarView();
         addChild(this.m_view);
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:StatisticBar = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.m_view.numChildren)
         {
            _loc1_ = this.m_view.getChildByName("bar" + (_loc3_ + 1)) as MovieClip;
            if(this.m_data[_loc3_])
            {
               _loc2_ = new StatisticBar(_loc1_,this.m_showValues);
               this.m_statisticBars.push(_loc2_);
               _loc2_.init(this.m_data[_loc3_].title,this.m_data[_loc3_].completed,this.m_data[_loc3_].total);
            }
            else
            {
               _loc1_.visible = false;
            }
            _loc3_++;
         }
         this.show();
      }
      
      private function show() : void
      {
         var _loc1_:MovieClip = null;
         var _loc4_:StatisticBar = null;
         Animate.fromTo(this.m_view,0.3,0,{"alpha":0},{"alpha":1},Animate.ExpoOut);
         var _loc2_:Number = 0;
         var _loc3_:int = 0;
         while(_loc3_ < this.m_statisticBars.length)
         {
            (_loc4_ = this.m_statisticBars[_loc3_]).show(_loc2_);
            _loc2_ += 0.05;
            _loc3_++;
         }
      }
      
      public function destroy() : void
      {
         var _loc2_:StatisticBar = null;
         Animate.kill(this.m_view);
         var _loc1_:int = 0;
         while(_loc1_ < this.m_statisticBars.length)
         {
            _loc2_ = this.m_statisticBars[_loc1_];
            _loc2_.destroy();
            _loc1_++;
         }
         this.m_statisticBars.length = 0;
         while(this.m_view.numChildren > 0)
         {
            if(this.m_view.getChildAt(0) is MovieClip)
            {
               MovieClip(this.m_view.getChildAt(0)).gotoAndStop(1);
            }
            this.m_view.removeChild(this.m_view.getChildAt(0));
         }
         removeChild(this.m_view);
         this.m_view = null;
      }
   }
}
