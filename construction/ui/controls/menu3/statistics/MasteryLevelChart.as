package menu3.statistics
{
   import basic.PieChart;
   import common.Animate;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   
   public class MasteryLevelChart extends PieChart
   {
       
      
      private var m_data:Object;
      
      private var m_chartSize:Number = 142;
      
      private var m_gapSize:Number = 0.01;
      
      private var m_initialRotation:Number = -90;
      
      private var m_sliceSize:Number;
      
      private var m_rotationStep:Number;
      
      private var m_totalNumberOfSlices:int;
      
      private var m_completedNumberOfSlices:int;
      
      private var m_bgContainer:Sprite;
      
      private var m_sliceContainer:Sprite;
      
      private var m_valueDisplay:ChartValueDisplayView;
      
      public function MasteryLevelChart(param1:Object)
      {
         this.m_data = {};
         super();
         this.m_data = param1;
         if(!this.m_data.isAvailable)
         {
            this.m_data.completed = "";
         }
         this.m_totalNumberOfSlices = this.m_data.total;
         this.m_completedNumberOfSlices = !!this.m_data.isAvailable ? int(this.m_data.completed) : 0;
         if(this.m_totalNumberOfSlices > 40)
         {
            this.m_completedNumberOfSlices = Math.ceil(72 * this.m_completedNumberOfSlices / this.m_totalNumberOfSlices);
            this.m_totalNumberOfSlices = 72;
            this.m_gapSize = -0.005;
         }
         this.m_sliceSize = 360 * (1 / this.m_totalNumberOfSlices - this.m_gapSize);
         this.m_rotationStep = 360 / this.m_totalNumberOfSlices;
         Animate.delay(this,0.2,this.createBackground,null);
      }
      
      private function createBackground() : void
      {
         var _loc2_:Sprite = null;
         this.m_bgContainer = new Sprite();
         var _loc1_:Sprite = new PieChartMask();
         addChild(_loc1_);
         addChild(this.m_bgContainer);
         this.m_bgContainer.mask = _loc1_;
         this.m_bgContainer.alpha = 0;
         this.m_bgContainer.scaleX = 0;
         this.m_bgContainer.scaleY = 0;
         var _loc3_:Number = this.m_initialRotation;
         var _loc4_:int = 0;
         while(_loc4_ < this.m_totalNumberOfSlices)
         {
            _loc2_ = new Sprite();
            drawSlice(_loc2_,this.m_chartSize / 2,this.m_sliceSize,MenuConstants.COLOR_MENU_SOLID_BACKGROUND);
            _loc2_.rotation = _loc3_;
            _loc3_ += this.m_rotationStep;
            this.m_bgContainer.addChild(_loc2_);
            _loc4_++;
         }
         Animate.to(this.m_bgContainer,0.2,0,{
            "alpha":1,
            "scaleX":1,
            "scaleY":1
         },Animate.ExpoOut,this.createPieChart,null);
         this.createPieChartValue();
      }
      
      private function createPieChart() : void
      {
         var _loc2_:Sprite = null;
         this.m_sliceContainer = new Sprite();
         var _loc1_:Sprite = new PieChartMask();
         addChild(_loc1_);
         addChild(this.m_sliceContainer);
         this.m_sliceContainer.mask = _loc1_;
         var _loc3_:Number = this.m_initialRotation;
         var _loc4_:Number = 0;
         var _loc5_:int = 0;
         while(_loc5_ < this.m_completedNumberOfSlices)
         {
            _loc2_ = new Sprite();
            _loc2_.alpha = 0;
            drawSlice(_loc2_,this.m_chartSize / 2,this.m_sliceSize,MenuConstants.COLOR_WHITE);
            _loc2_.rotation = _loc3_;
            _loc3_ += this.m_rotationStep;
            this.m_sliceContainer.addChild(_loc2_);
            Animate.to(_loc2_,0.3,_loc4_,{"alpha":1},Animate.ExpoOut);
            _loc4_ += 0.02;
            _loc5_++;
         }
      }
      
      private function createPieChartValue() : void
      {
         this.m_valueDisplay = new ChartValueDisplayView();
         MenuUtils.setColor(this.m_valueDisplay,MenuConstants.COLOR_WHITE);
         this.m_valueDisplay.alpha = 0;
         this.m_valueDisplay.scaleX = 0;
         this.m_valueDisplay.scaleY = 0;
         addChild(this.m_valueDisplay);
         this.m_valueDisplay.label.text = this.m_data.completed;
         Animate.to(this.m_valueDisplay,0.3,0.1,{
            "alpha":1,
            "scaleX":1,
            "scaleY":1
         },Animate.ExpoOut);
      }
      
      public function destroy() : void
      {
         this.m_sliceContainer = null;
         this.m_bgContainer = null;
         this.m_valueDisplay = null;
      }
   }
}
