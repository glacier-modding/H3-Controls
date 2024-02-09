package menu3.statistics
{
   import common.Animate;
   import common.menu.*;
   import flash.display.*;
   import flash.events.Event;
   import flash.geom.Point;
   import menu3.statistics.elements.*;
   import menu3.statistics.shapes.*;
   
   public class LineChart extends Sprite
   {
       
      
      private const GRAPH_TYPE_GLOBAL:String = "global";
      
      private const GRAPH_TYPE_PLAYER:String = "player";
      
      private var m_shapeData:LineChartData;
      
      private var m_view:Sprite;
      
      private var m_chartContainer:Sprite;
      
      private var m_globalChartContainer:Sprite;
      
      private var m_playerChartContainer:Sprite;
      
      private var m_labelContainer:Sprite;
      
      private var m_globalGraph:Vector.<LineChartPoint>;
      
      private var m_playerGraph:Vector.<LineChartPoint>;
      
      private var m_graphHeightMAX:Number = 370;
      
      private var m_graphWidthMAX:Number = 650;
      
      private var m_graphSpacing:Number = 0;
      
      private var m_useAnimation:Boolean;
      
      private var m_showGlobal:Boolean;
      
      private var m_showPlayer:Boolean;
      
      public function LineChart()
      {
         super();
      }
      
      public function onUnregister() : void
      {
      }
      
      public function onSetData(param1:Object) : void
      {
         this.m_useAnimation = param1.animate != null ? Boolean(param1.animate) : true;
         this.m_showGlobal = param1.showGlobal != null ? Boolean(param1.showGlobal) : true;
         this.m_showPlayer = param1.showPlayer != null ? Boolean(param1.showPlayer) : true;
         this.m_shapeData = new LineChartData(param1);
         this.m_view = new Sprite();
         addChild(this.m_view);
         this.m_chartContainer = this.m_view.addChild(new Sprite()) as Sprite;
         this.m_globalChartContainer = this.m_chartContainer.addChild(new Sprite()) as Sprite;
         this.m_playerChartContainer = this.m_chartContainer.addChild(new Sprite()) as Sprite;
         this.m_labelContainer = this.m_chartContainer.addChild(new Sprite()) as Sprite;
         this.setupGraph();
      }
      
      private function setupGraph() : void
      {
         this.m_graphSpacing = Math.round(this.m_graphWidthMAX / (this.m_shapeData.global.length - 1));
         this.createGraphFrame();
         this.createGraphPoints();
         if(this.m_useAnimation)
         {
            if(this.m_showGlobal)
            {
               this.animateGraph(this.GRAPH_TYPE_GLOBAL);
            }
            if(this.m_showPlayer)
            {
               this.animateGraph(this.GRAPH_TYPE_PLAYER);
            }
         }
         else
         {
            if(this.m_showGlobal)
            {
               this.drawGraph(this.GRAPH_TYPE_GLOBAL);
            }
            if(this.m_showPlayer)
            {
               this.drawGraph(this.GRAPH_TYPE_PLAYER);
            }
         }
      }
      
      private function createGraphFrame() : void
      {
         var xAxisValueInfo:LineChartLabel;
         var yAxisValueInfo:LineChartLabel;
         var i:int = 0;
         var playerInfo:LineChartLabel = null;
         var globalInfo:LineChartLabel = null;
         var xPos:Number = 0;
         var graphHeight:Number = this.m_graphHeightMAX + 20;
         var graphWidth:Number = this.m_graphWidthMAX + 20;
         with(this.m_chartContainer)
         {
            graphics.clear();
            graphics.lineStyle(0,MenuConstants.COLOR_WHITE,0.8,true,LineScaleMode.NONE,CapsStyle.NONE,JointStyle.MITER,10);
            graphics.lineTo(0,-graphHeight);
            graphics.lineTo(-5,-(graphHeight - 5));
            graphics.moveTo(0,-graphHeight);
            graphics.lineTo(5,-(graphHeight - 5));
            graphics.moveTo(0,0);
            graphics.lineTo(graphWidth,0);
            graphics.lineTo(graphWidth - 5,5);
            graphics.moveTo(graphWidth,0);
            graphics.lineTo(graphWidth - 5,-5);
            graphics.lineStyle(0,MenuConstants.COLOR_WHITE,0.2,true,LineScaleMode.NONE,CapsStyle.NONE,JointStyle.MITER,10);
            graphics.moveTo(0,0);
            i = 0;
            while(i < m_shapeData.global.length - 1)
            {
               xPos += m_graphSpacing;
               graphics.moveTo(xPos,0);
               graphics.lineTo(xPos,-m_graphHeightMAX);
               ++i;
            }
         }
         xAxisValueInfo = new LineChartLabel("Playthroughs",false,MenuConstants.COLOR_WHITE,LineChartLabel.TEXT_ORIENTATION_RIGHT);
         xAxisValueInfo.x = graphWidth;
         xAxisValueInfo.y = 25;
         this.m_labelContainer.addChild(xAxisValueInfo);
         yAxisValueInfo = new LineChartLabel("Score",false,MenuConstants.COLOR_WHITE,LineChartLabel.TEXT_ORIENTATION_CENTER);
         yAxisValueInfo.y = -(graphHeight + 20);
         this.m_labelContainer.addChild(yAxisValueInfo);
         if(this.m_showPlayer)
         {
            playerInfo = new LineChartLabel("My Score",true,MenuConstants.COLOR_RED);
            playerInfo.x = 6;
            playerInfo.y = 35;
            this.m_labelContainer.addChild(playerInfo);
         }
         if(this.m_showGlobal)
         {
            globalInfo = new LineChartLabel("Global Average",true,MenuConstants.COLOR_WHITE);
            globalInfo.x = 6;
            globalInfo.y = 60;
            this.m_labelContainer.addChild(globalInfo);
         }
      }
      
      private function createGraphPoints() : void
      {
         var _loc1_:int = 0;
         var _loc2_:LineChartPoint = null;
         var _loc3_:Point = null;
         if(this.m_showGlobal)
         {
            this.m_globalGraph = new Vector.<LineChartPoint>();
            _loc1_ = 0;
            while(_loc1_ < this.m_shapeData.global.length)
            {
               _loc3_ = new Point(_loc1_ * this.m_graphSpacing,-(this.m_graphHeightMAX * (this.m_shapeData.global[_loc1_] / 100)));
               _loc2_ = new LineChartPoint(this.m_globalChartContainer,_loc3_,MenuConstants.COLOR_WHITE);
               this.m_globalGraph.push(_loc2_);
               _loc1_++;
            }
         }
         if(this.m_showPlayer)
         {
            this.m_playerGraph = new Vector.<LineChartPoint>();
            _loc1_ = 0;
            while(_loc1_ < this.m_shapeData.player.length)
            {
               _loc3_ = new Point(_loc1_ * this.m_graphSpacing,-(this.m_graphHeightMAX * (this.m_shapeData.player[_loc1_] / 100)));
               _loc2_ = new LineChartPoint(this.m_playerChartContainer,_loc3_,MenuConstants.COLOR_RED);
               this.m_playerGraph.push(_loc2_);
               _loc1_++;
            }
         }
      }
      
      private function drawGraph(param1:String) : void
      {
         var i:int = 0;
         var type:String = param1;
         var container:Sprite = type == this.GRAPH_TYPE_GLOBAL ? this.m_globalChartContainer : this.m_playerChartContainer;
         var graph:Vector.<LineChartPoint> = type == this.GRAPH_TYPE_GLOBAL ? this.m_globalGraph : this.m_playerGraph;
         var color:uint = type == this.GRAPH_TYPE_GLOBAL ? uint(MenuConstants.COLOR_WHITE) : uint(MenuConstants.COLOR_RED);
         with(container)
         {
            graphics.clear();
            graphics.lineStyle(1,color,1,true,LineScaleMode.NONE,CapsStyle.NONE,JointStyle.MITER,10);
            i = 0;
            while(i < graph.length)
            {
               graph[i].clip.y = graph[i].point.y;
               if(i == 0)
               {
                  container.graphics.moveTo(graph[0].point.x,graph[0].point.y);
               }
               else
               {
                  container.graphics.lineTo(graph[i].point.x,graph[i].point.y);
               }
               ++i;
            }
         }
      }
      
      private function animateGraph(param1:String) : void
      {
         var _loc2_:Vector.<LineChartPoint> = null;
         var _loc5_:LineChartPoint = null;
         if(param1 == this.GRAPH_TYPE_GLOBAL)
         {
            _loc2_ = this.m_globalGraph;
            this.m_view.addEventListener(Event.ENTER_FRAME,this.updateGlobalGraph);
         }
         else if(param1 == this.GRAPH_TYPE_PLAYER)
         {
            _loc2_ = this.m_playerGraph;
            this.m_view.addEventListener(Event.ENTER_FRAME,this.updatePlayerGraph);
         }
         var _loc3_:Number = 0;
         var _loc4_:int = int(_loc2_.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            (_loc5_ = _loc2_[_loc6_]).isAnimating = true;
            Animate.to(_loc5_.clip,0.4,_loc3_,{
               "x":_loc5_.point.x,
               "y":_loc5_.point.y
            },Animate.BackOut,this.setAnimationState,param1,_loc5_,false);
            _loc3_ += 0.01;
            _loc6_++;
         }
      }
      
      private function setAnimationState(param1:String, param2:LineChartPoint, param3:Boolean) : void
      {
         var _loc4_:Vector.<LineChartPoint> = null;
         param2.isAnimating = param3;
         if(param1 == this.GRAPH_TYPE_GLOBAL)
         {
            _loc4_ = this.m_globalGraph;
         }
         else if(param1 == this.GRAPH_TYPE_PLAYER)
         {
            _loc4_ = this.m_playerGraph;
         }
         var _loc5_:Boolean = true;
         var _loc6_:int = int(_loc4_.length);
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            if(_loc4_[_loc7_].isAnimating)
            {
               _loc5_ = false;
               return;
            }
            _loc7_++;
         }
         if(param1 == this.GRAPH_TYPE_GLOBAL)
         {
            this.m_view.removeEventListener(Event.ENTER_FRAME,this.updateGlobalGraph);
         }
         else if(param1 == this.GRAPH_TYPE_PLAYER)
         {
            this.m_view.removeEventListener(Event.ENTER_FRAME,this.updatePlayerGraph);
         }
      }
      
      private function updateGlobalGraph(param1:Event) : void
      {
         var i:int = 0;
         var evt:Event = param1;
         with(this.m_globalChartContainer)
         {
            graphics.clear();
            graphics.lineStyle(1,MenuConstants.COLOR_WHITE,1,true,LineScaleMode.NONE,CapsStyle.NONE,JointStyle.MITER,10);
            i = 0;
            while(i < m_globalGraph.length)
            {
               if(i == 0)
               {
                  graphics.moveTo(m_globalGraph[i].clip.x,m_globalGraph[i].clip.y);
               }
               else
               {
                  graphics.lineTo(m_globalGraph[i].clip.x,m_globalGraph[i].clip.y);
               }
               ++i;
            }
         }
      }
      
      private function updatePlayerGraph(param1:Event) : void
      {
         var i:int = 0;
         var evt:Event = param1;
         with(this.m_playerChartContainer)
         {
            graphics.clear();
            graphics.lineStyle(1,MenuConstants.COLOR_RED,1,true,LineScaleMode.NONE,CapsStyle.NONE,JointStyle.MITER,10);
            i = 0;
            while(i < m_playerGraph.length)
            {
               if(i == 0)
               {
                  graphics.moveTo(m_playerGraph[i].clip.x,m_playerGraph[i].clip.y);
               }
               else
               {
                  graphics.lineTo(m_playerGraph[i].clip.x,m_playerGraph[i].clip.y);
               }
               ++i;
            }
         }
      }
   }
}

class LineChartData
{
    
   
   private var m_global:Array;
   
   private var m_player:Array;
   
   public function LineChartData(param1:Object)
   {
      this.m_global = [];
      this.m_player = [];
      super();
      this.m_global = param1.global;
      this.m_player = param1.player;
   }
   
   public function get global() : Array
   {
      return this.m_global;
   }
   
   public function get player() : Array
   {
      return this.m_player;
   }
}

import flash.display.Sprite;
import flash.geom.Point;

class LineChartPoint
{
    
   
   public var clip:Sprite;
   
   public var point:Point;
   
   public var isAnimating:Boolean;
   
   public var color:uint;
   
   public function LineChartPoint(param1:Sprite, param2:Point, param3:uint = 16777215, param4:Boolean = false)
   {
      super();
      this.point = param2;
      this.color = param3;
      this.isAnimating = param4;
      this.clip = new Sprite();
      this.clip.x = param2.x;
      this.clip.y = 0;
      this.drawClip();
      param1.addChild(this.clip);
   }
   
   private function drawClip() : void
   {
      this.clip.visible = true;
      this.clip.graphics.clear();
      this.clip.graphics.beginFill(this.color,1);
      this.clip.graphics.drawCircle(0,0,8);
      this.clip.graphics.endFill();
   }
}
