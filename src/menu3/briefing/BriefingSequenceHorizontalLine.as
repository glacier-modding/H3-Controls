package menu3.briefing
{
   import common.Animate;
   import common.BaseControl;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   
   public class BriefingSequenceHorizontalLine extends BaseControl
   {
       
      
      private var m_lineWidth:Number;
      
      private var m_linePositionRow:Number;
      
      private var m_linePositionCol:Number;
      
      private var m_animateInDuration:Number;
      
      private var m_animateInEasingType:int;
      
      private var m_animateOutDuration:Number;
      
      private var m_animateOutEasingType:int;
      
      private var m_line:Sprite;
      
      private var m_unitWidth:Number;
      
      private var m_unitHeight:Number;
      
      public function BriefingSequenceHorizontalLine()
      {
         this.m_unitWidth = MenuConstants.BaseWidth / 10;
         this.m_unitHeight = MenuConstants.BaseHeight / 6;
         super();
         trace("ETBriefing | BriefingSequenceHorizontalLine CALLED!!!");
         this.m_line = new Sprite();
         this.m_line.name = "m_line";
         this.m_line.alpha = 0;
         addChild(this.m_line);
      }
      
      public function start(param1:Number, param2:Number) : void
      {
         this.m_line.graphics.clear();
         this.m_line.graphics.beginFill(MenuConstants.COLOR_GREY_ULTRA_LIGHT,1);
         this.m_line.graphics.drawRect(0,0,this.m_unitWidth * this.m_lineWidth,1);
         this.m_line.graphics.endFill();
         this.m_line.x = this.m_unitWidth * this.m_linePositionRow;
         this.m_line.y = this.m_unitHeight * this.m_linePositionCol;
         Animate.delay(this,param2,this.startSequence,param1);
      }
      
      private function startSequence(param1:Number) : void
      {
         var delayDuration:Number = NaN;
         var baseduration:Number = param1;
         Animate.kill(this);
         delayDuration = baseduration - this.m_animateInDuration - this.m_animateOutDuration;
         this.m_line.scaleX = 0;
         this.m_line.alpha = 1;
         Animate.to(this.m_line,this.m_animateInDuration,0,{"scaleX":1},this.m_animateInEasingType,function():void
         {
            Animate.to(m_line,m_animateOutDuration,delayDuration,{"scaleX":0},m_animateOutEasingType);
         });
      }
      
      override public function getContainer() : Sprite
      {
         return this.m_line;
      }
      
      public function set LineWidthInRows(param1:Number) : void
      {
         this.m_lineWidth = param1;
      }
      
      public function set LinePositionRow(param1:Number) : void
      {
         this.m_linePositionRow = param1;
      }
      
      public function set LinePositionCol(param1:Number) : void
      {
         this.m_linePositionCol = param1;
      }
      
      public function set AnimateInDuration(param1:Number) : void
      {
         this.m_animateInDuration = param1;
      }
      
      public function set AnimateInEasingType(param1:String) : void
      {
         this.m_animateInEasingType = MenuUtils.getEaseType(param1);
      }
      
      public function set AnimateOutDuration(param1:Number) : void
      {
         this.m_animateOutDuration = param1;
      }
      
      public function set AnimateOutEasingType(param1:String) : void
      {
         this.m_animateOutEasingType = MenuUtils.getEaseType(param1);
      }
   }
}
