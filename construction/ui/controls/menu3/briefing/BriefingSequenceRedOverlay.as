package menu3.briefing
{
   import common.Animate;
   import common.BaseControl;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   
   public class BriefingSequenceRedOverlay extends BaseControl
   {
       
      
      private var m_animateInDuration:Number;
      
      private var m_animateInStartRow:Number;
      
      private var m_animateInEndRow:Number;
      
      private var m_animateInStartCol:Number;
      
      private var m_animateInEndCol:Number;
      
      private var m_animateInEasingType:int;
      
      private var m_animateOutDuration:Number;
      
      private var m_animateOutStartRow:Number;
      
      private var m_animateOutEndRow:Number;
      
      private var m_animateOutStartCol:Number;
      
      private var m_animateOutEndCol:Number;
      
      private var m_animateOutEasingType:int;
      
      private var m_overlay:Sprite;
      
      private var m_unitWidth:Number;
      
      private var m_unitHeight:Number;
      
      public function BriefingSequenceRedOverlay()
      {
         this.m_unitWidth = MenuConstants.BaseWidth / 10;
         this.m_unitHeight = MenuConstants.BaseHeight / 6;
         super();
         trace("ETBriefing | BriefingSequenceRedOverlay CALLED!!!");
         this.m_overlay = new Sprite();
         this.m_overlay.name = "m_overlay";
         this.m_overlay.graphics.clear();
         this.m_overlay.graphics.beginFill(MenuConstants.COLOR_RED,1);
         this.m_overlay.graphics.drawRect(0,0,MenuConstants.BaseWidth,MenuConstants.BaseHeight);
         this.m_overlay.graphics.endFill();
         addChild(this.m_overlay);
         this.m_overlay.blendMode = "multiply";
      }
      
      public function start(param1:Number, param2:Number) : void
      {
         this.m_overlay.x = this.m_unitWidth * this.m_animateInStartRow;
         this.m_overlay.y = this.m_unitHeight * this.m_animateInStartCol;
         Animate.delay(this,param2,this.startSequence,param1);
      }
      
      private function startSequence(param1:Number) : void
      {
         var delayDuration:Number = NaN;
         var baseduration:Number = param1;
         Animate.kill(this);
         delayDuration = baseduration - this.m_animateInDuration - this.m_animateOutDuration;
         Animate.to(this.m_overlay,this.m_animateInDuration,0,{
            "x":this.m_unitWidth * this.m_animateInEndRow,
            "y":this.m_unitHeight * this.m_animateInEndCol
         },this.m_animateInEasingType,function():void
         {
            Animate.fromTo(m_overlay,m_animateOutDuration,delayDuration,{
               "x":m_unitWidth * m_animateOutStartRow,
               "y":m_unitHeight * m_animateOutStartCol
            },{
               "x":m_unitWidth * m_animateOutEndRow,
               "y":m_unitHeight * m_animateOutEndCol
            },m_animateOutEasingType);
         });
      }
      
      override public function getContainer() : Sprite
      {
         return this.m_overlay;
      }
      
      public function set AnimateInDuration(param1:Number) : void
      {
         this.m_animateInDuration = param1;
      }
      
      public function set AnimateInStartRow(param1:Number) : void
      {
         this.m_animateInStartRow = param1;
      }
      
      public function set AnimateInEndRow(param1:Number) : void
      {
         this.m_animateInEndRow = param1;
      }
      
      public function set AnimateInStartCol(param1:Number) : void
      {
         this.m_animateInStartCol = param1;
      }
      
      public function set AnimateInEndCol(param1:Number) : void
      {
         this.m_animateInEndCol = param1;
      }
      
      public function set AnimateInEasingType(param1:String) : void
      {
         this.m_animateInEasingType = MenuUtils.getEaseType(param1);
      }
      
      public function set AnimateOutDuration(param1:Number) : void
      {
         this.m_animateOutDuration = param1;
      }
      
      public function set AnimateOutStartRow(param1:Number) : void
      {
         this.m_animateOutStartRow = param1;
      }
      
      public function set AnimateOutEndRow(param1:Number) : void
      {
         this.m_animateOutEndRow = param1;
      }
      
      public function set AnimateOutStartCol(param1:Number) : void
      {
         this.m_animateOutStartCol = param1;
      }
      
      public function set AnimateOutEndCol(param1:Number) : void
      {
         this.m_animateOutEndCol = param1;
      }
      
      public function set AnimateOutEasingType(param1:String) : void
      {
         this.m_animateOutEasingType = MenuUtils.getEaseType(param1);
      }
   }
}
