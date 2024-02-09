package menu3.statistics
{
   import common.Animate;
   import common.menu.MenuConstants;
   import flash.display.Sprite;
   import menu3.statistics.elements.*;
   import menu3.statistics.shapes.*;
   
   public class BarChart extends Sprite
   {
       
      
      private var m_shapeData:BarChartData;
      
      private var m_view:Sprite;
      
      private var m_chartContainer:Sprite;
      
      private var m_barHeightMAX:Number = 500;
      
      private var m_barWidth:Number = 50;
      
      private var m_barSpacing:Number = 5;
      
      private var m_useAnimation:Boolean;
      
      public function BarChart()
      {
         super();
      }
      
      public function onUnregister() : void
      {
      }
      
      public function onSetData(param1:Object) : void
      {
         this.m_useAnimation = param1.animate != null ? Boolean(param1.animate) : true;
         this.m_shapeData = new BarChartData(param1);
         this.m_view = new Sprite();
         addChild(this.m_view);
         this.m_chartContainer = this.m_view.addChild(new Sprite()) as Sprite;
         this.setupGraph();
      }
      
      private function setupGraph() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         var _loc6_:int = 0;
         while(_loc6_ < this.m_shapeData.scorePercentages.length)
         {
            _loc3_ = this.m_shapeData.scorePercentages[_loc6_] / 100;
            if(_loc3_ == 0)
            {
               _loc3_ = 0.01;
            }
            _loc4_ = this.m_barHeightMAX * _loc3_;
            _loc1_ = this.drawBar(this.m_barWidth,_loc4_,this.m_shapeData.playerIndex == _loc6_ ? uint(MenuConstants.COLOR_RED) : uint(MenuConstants.COLOR_WHITE));
            _loc1_.x = _loc2_;
            this.m_chartContainer.addChild(_loc1_);
            _loc1_.height = 1;
            Animate.to(_loc1_,0.2,_loc5_,{"height":_loc4_},Animate.ExpoInOut);
            _loc2_ += this.m_barWidth + this.m_barSpacing;
            _loc5_ += 0.02;
            _loc6_++;
         }
         var _loc7_:BarChartLabel;
         (_loc7_ = new BarChartLabel("Overview of where you are located compared to the global scores",400)).y = 50;
         this.m_chartContainer.addChild(_loc7_);
      }
      
      private function drawBar(param1:Number, param2:Number, param3:uint) : Sprite
      {
         var _loc4_:Sprite = new Sprite();
         var _loc5_:Sprite;
         (_loc5_ = new Sprite()).graphics.beginFill(param3);
         _loc5_.graphics.drawRect(0,0,param1,-param2);
         _loc5_.graphics.endFill();
         _loc5_.alpha = 0.8;
         _loc4_.addChild(_loc5_);
         return _loc4_;
      }
   }
}

class BarChartData
{
    
   
   private var m_playerIndex:Number = 0;
   
   private var m_scorePercentages:Array;
   
   public function BarChartData(param1:Object)
   {
      this.m_scorePercentages = [];
      super();
      this.m_playerIndex = param1.playerIndex;
      this.m_scorePercentages = param1.scorePercentages;
   }
   
   public function get playerIndex() : Number
   {
      return this.m_playerIndex;
   }
   
   public function get scorePercentages() : Array
   {
      return this.m_scorePercentages;
   }
}
