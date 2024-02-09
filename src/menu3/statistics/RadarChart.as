package menu3.statistics
{
   import common.Animate;
   import common.menu.*;
   import flash.display.*;
   import flash.events.Event;
   import flash.geom.Point;
   import menu3.statistics.elements.*;
   import menu3.statistics.shapes.*;
   
   public class RadarChart extends Sprite
   {
       
      
      private const GRAPH_TYPE_GLOBAL:String = "global";
      
      private const GRAPH_TYPE_PLAYER:String = "player";
      
      private var m_shapeData:RadarChartData;
      
      private var m_view:Sprite;
      
      private var m_bgContainer:Sprite;
      
      private var m_labelContainer:Sprite;
      
      private var m_globalChartContainer:ChartContainer;
      
      private var m_playerChartContainer:ChartContainer;
      
      private var m_globalGraph:Vector.<RadarChartPoint>;
      
      private var m_playerGraph:Vector.<RadarChartPoint>;
      
      private var m_useAnimation:Boolean;
      
      private var m_showGlobal:Boolean;
      
      private var m_showPlayer:Boolean;
      
      public function RadarChart()
      {
         super();
      }
      
      public function onUnregister() : void
      {
         this.m_view.removeEventListener(Event.ENTER_FRAME,this.updateGlobalGraph);
         this.m_view.removeEventListener(Event.ENTER_FRAME,this.updatePlayerGraph);
      }
      
      public function onSetData(param1:Object) : void
      {
         this.m_useAnimation = param1.animate != null ? Boolean(param1.animate) : true;
         this.m_showGlobal = param1.showGlobal != null ? Boolean(param1.showGlobal) : true;
         this.m_showPlayer = param1.showPlayer != null ? Boolean(param1.showPlayer) : true;
         this.m_shapeData = new RadarChartData(param1);
         this.m_shapeData.apothem = 170;
         this.m_view = new Sprite();
         addChild(this.m_view);
         this.m_bgContainer = this.m_view.addChild(new Sprite()) as Sprite;
         this.m_labelContainer = this.m_view.addChild(new Sprite()) as Sprite;
         this.m_globalChartContainer = new ChartContainer();
         this.m_playerChartContainer = new ChartContainer();
         this.m_view.addChild(this.m_globalChartContainer);
         this.m_view.addChild(this.m_playerChartContainer);
         this.setupGraph();
      }
      
      private function setupGraph() : void
      {
         var _loc1_:int = 0;
         var _loc3_:Polygon = null;
         var _loc4_:RadarChartLabel = null;
         var _loc5_:RadarChartLine = null;
         var _loc2_:Array = [1,0.77,0.53,0.29];
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            _loc3_ = new Polygon(this.m_shapeData.radius,this.m_shapeData.numberOfSides,MenuConstants.COLOR_BLACK,MenuConstants.COLOR_WHITE,2);
            _loc3_.scaleX = _loc3_.scaleY = _loc2_[_loc1_];
            this.m_bgContainer.addChild(_loc3_);
            _loc1_++;
         }
         var _loc6_:Number = this.getInitialRotation();
         _loc1_ = 0;
         while(_loc1_ < this.m_shapeData.numberOfSides)
         {
            (_loc5_ = new RadarChartLine(this.m_shapeData.apothem)).rotation = _loc6_;
            _loc4_ = new RadarChartLabel(this.m_shapeData.statistics[_loc1_].title,_loc5_.rotation,34,this.m_shapeData.statistics[_loc1_].player > 0 && this.m_showPlayer,this.m_shapeData.sideLength,this.m_shapeData.apothem,this.m_shapeData.centralAngle);
            _loc5_.addChild(_loc4_);
            this.m_labelContainer.addChild(_loc5_);
            _loc6_ += this.m_shapeData.centralAngle;
            _loc1_++;
         }
         if(this.m_useAnimation)
         {
            if(this.m_showGlobal)
            {
               Animate.delay(this,0.1,this.drawGraph,[this.GRAPH_TYPE_GLOBAL]);
            }
            if(this.m_showPlayer)
            {
               Animate.delay(this,0.4,this.drawGraph,[this.GRAPH_TYPE_PLAYER]);
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
      
      private function drawGraph(param1:String) : void
      {
         var _loc10_:Sprite = null;
         var _loc11_:Number = NaN;
         var _loc2_:Number = this.getInitialRotation();
         var _loc3_:Point = new Point(0,-10);
         var _loc4_:Point = new Point(0,-this.m_shapeData.apothem);
         var _loc5_:Point = new Point();
         var _loc6_:Point = new Point();
         var _loc7_:Number = 0;
         var _loc8_:Number = 0;
         var _loc9_:Vector.<RadarChartPoint> = new Vector.<RadarChartPoint>();
         if(param1 == this.GRAPH_TYPE_GLOBAL)
         {
            this.m_globalGraph = _loc9_;
            _loc10_ = this.m_globalChartContainer.pointContainer;
         }
         else if(param1 == this.GRAPH_TYPE_PLAYER)
         {
            this.m_playerGraph = _loc9_;
            _loc10_ = this.m_playerChartContainer.pointContainer;
         }
         var _loc12_:int = 0;
         while(_loc12_ < this.m_shapeData.numberOfSides)
         {
            if(param1 == this.GRAPH_TYPE_GLOBAL)
            {
               _loc11_ = Number(this.m_shapeData.statistics[_loc12_].global);
            }
            else if(param1 == this.GRAPH_TYPE_PLAYER)
            {
               _loc11_ = Number(this.m_shapeData.statistics[_loc12_].player);
            }
            _loc7_ = _loc11_ / this.m_shapeData.dataTotal;
            _loc5_ = Point.interpolate(_loc4_,_loc3_,_loc7_ * 4);
            _loc8_ = MenuUtils.toRadians(_loc2_);
            _loc6_ = new Point(_loc5_.x * Math.cos(_loc8_) - _loc5_.y * Math.sin(_loc8_),_loc5_.x * Math.sin(_loc8_) + _loc5_.y * Math.cos(_loc8_));
            _loc9_.push(new RadarChartPoint(_loc10_,_loc6_,true));
            _loc2_ += this.m_shapeData.centralAngle;
            _loc12_++;
         }
         if(this.m_useAnimation)
         {
            this.animateGraph(param1);
         }
         else
         {
            this.showGraph(param1);
         }
      }
      
      private function getInitialRotation() : Number
      {
         return this.m_shapeData.numberOfSides % 2 == 1 ? 0 : this.m_shapeData.centralAngle / 2;
      }
      
      private function showGraph(param1:String) : void
      {
         var graph:Vector.<RadarChartPoint> = null;
         var container:Sprite = null;
         var lineAlpha:Number = NaN;
         var fillColor:uint = 0;
         var fillAlpha:Number = NaN;
         var i:int = 0;
         var type:String = param1;
         if(type == this.GRAPH_TYPE_GLOBAL)
         {
            graph = this.m_globalGraph;
            container = this.m_globalChartContainer.graphContainer;
            lineAlpha = 0.8;
            fillColor = uint(MenuConstants.COLOR_WHITE);
            fillAlpha = 0.4;
         }
         else if(type == this.GRAPH_TYPE_PLAYER)
         {
            graph = this.m_playerGraph;
            container = this.m_playerChartContainer.graphContainer;
            lineAlpha = 0.5;
            fillColor = uint(MenuConstants.COLOR_RED);
            fillAlpha = 1;
         }
         with(container)
         {
            graphics.clear();
            graphics.lineStyle(0,MenuConstants.COLOR_WHITE,lineAlpha,true,LineScaleMode.NONE,CapsStyle.NONE,JointStyle.MITER,10);
            graphics.beginFill(fillColor,fillAlpha);
            i = 0;
            while(i < graph.length)
            {
               if(i == 0)
               {
                  graphics.moveTo(graph[i].point.x,graph[i].point.y);
               }
               else
               {
                  graphics.lineTo(graph[i].point.x,graph[i].point.y);
               }
               graph[i].clip.x = graph[i].point.x;
               graph[i].clip.y = graph[i].point.y;
               ++i;
            }
            graphics.lineTo(graph[0].point.x,graph[0].point.y);
            graphics.endFill();
         }
      }
      
      private function animateGraph(param1:String) : void
      {
         var _loc2_:Vector.<RadarChartPoint> = null;
         var _loc5_:RadarChartPoint = null;
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
      
      private function setAnimationState(param1:String, param2:RadarChartPoint, param3:Boolean) : void
      {
         var _loc4_:Vector.<RadarChartPoint> = null;
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
         with(this.m_globalChartContainer.graphContainer)
         {
            graphics.clear();
            graphics.lineStyle(0,MenuConstants.COLOR_WHITE,0.8,true,LineScaleMode.NONE,CapsStyle.NONE,JointStyle.MITER,10);
            graphics.beginFill(MenuConstants.COLOR_WHITE,0.4);
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
            graphics.lineTo(m_globalGraph[0].clip.x,m_globalGraph[0].clip.y);
            graphics.endFill();
         }
      }
      
      private function updatePlayerGraph(param1:Event) : void
      {
         var i:int = 0;
         var evt:Event = param1;
         with(this.m_playerChartContainer.graphContainer)
         {
            graphics.clear();
            graphics.beginFill(MenuConstants.COLOR_RED,1);
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
            graphics.lineTo(m_playerGraph[0].clip.x,m_playerGraph[0].clip.y);
            graphics.endFill();
         }
      }
   }
}

import common.menu.MenuUtils;

class RadarChartData
{
    
   
   private var m_apothem:Number = 170;
   
   private var m_radius:Number = 0;
   
   private var m_sideLength:Number = 0;
   
   private var m_numberOfSides:Number = 0;
   
   private var m_centralAngle:Number = 0;
   
   private var m_dataTotal:Number = 0;
   
   private var m_statistics:Array;
   
   public function RadarChartData(param1:Object)
   {
      this.m_statistics = [];
      super();
      this.m_dataTotal = param1.total;
      this.m_statistics = param1.statistics;
      this.m_numberOfSides = this.m_statistics.length;
      this.m_centralAngle = 360 / this.m_numberOfSides;
      this.m_sideLength = Math.tan(MenuUtils.toRadians(360 / (this.m_numberOfSides * 2))) * this.m_apothem * 2;
      this.m_radius = this.m_apothem / Math.cos(MenuUtils.toRadians(180 / this.m_numberOfSides));
   }
   
   public function set apothem(param1:Number) : void
   {
      this.m_apothem = param1;
      this.m_radius = this.m_apothem / Math.cos(MenuUtils.toRadians(180 / this.m_numberOfSides));
      this.m_sideLength = Math.tan(MenuUtils.toRadians(360 / (this.m_numberOfSides * 2))) * this.m_apothem * 2;
   }
   
   public function get apothem() : Number
   {
      return this.m_apothem;
   }
   
   public function get radius() : Number
   {
      return this.m_radius;
   }
   
   public function get sideLength() : Number
   {
      return this.m_sideLength;
   }
   
   public function get dataTotal() : Number
   {
      return this.m_dataTotal;
   }
   
   public function get statistics() : Array
   {
      return this.m_statistics;
   }
   
   public function get numberOfSides() : Number
   {
      return this.m_numberOfSides;
   }
   
   public function get centralAngle() : Number
   {
      return this.m_centralAngle;
   }
}

import common.menu.MenuConstants;
import flash.display.Sprite;
import flash.geom.Point;

class RadarChartPoint
{
    
   
   public var point:Point;
   
   public var isAnimating:Boolean;
   
   public var clip:Sprite;
   
   public function RadarChartPoint(param1:Sprite, param2:Point, param3:Boolean = false, param4:Boolean = false)
   {
      super();
      this.point = param2;
      this.isAnimating = param4;
      this.clip = new Sprite();
      this.clip.x = 0;
      this.clip.y = 0;
      param1.addChild(this.clip);
      if(param3)
      {
         this.drawClip();
      }
   }
   
   private function drawClip() : void
   {
      this.clip.visible = true;
      this.clip.graphics.clear();
      this.clip.graphics.beginFill(MenuConstants.COLOR_WHITE,1);
      this.clip.graphics.drawCircle(0,0,3);
      this.clip.graphics.endFill();
   }
}

import flash.display.Sprite;

class ChartContainer extends Sprite
{
    
   
   public var graphContainer:Sprite;
   
   public var pointContainer:Sprite;
   
   public function ChartContainer()
   {
      super();
      this.graphContainer = addChild(new Sprite()) as Sprite;
      this.pointContainer = addChild(new Sprite()) as Sprite;
   }
}
