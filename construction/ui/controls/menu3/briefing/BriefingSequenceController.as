package menu3.briefing
{
   import common.Animate;
   import common.BaseControl;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   import flash.utils.*;
   
   public class BriefingSequenceController extends BaseControl
   {
       
      
      private var m_sequenceContainer:Sprite;
      
      private var m_mask:Sprite;
      
      public var m_totalDuration:Number;
      
      private var m_baseDuration:Number;
      
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
      
      private var m_unitWidth:Number;
      
      private var m_unitHeight:Number;
      
      public function BriefingSequenceController()
      {
         this.m_unitWidth = MenuConstants.BaseWidth / 10;
         this.m_unitHeight = MenuConstants.BaseHeight / 6;
         super();
         var _loc1_:Number = (MenuConstants.BaseHeight - MenuConstants.ElusiveContractsBriefingHeight) / 2;
         this.m_sequenceContainer = new Sprite();
         this.m_sequenceContainer.name = "m_sequenceContainer";
         this.m_sequenceContainer.alpha = 0;
         addChild(this.m_sequenceContainer);
         this.m_mask = new Sprite();
         this.m_mask.name = "m_mask";
         this.m_mask.graphics.clear();
         this.m_mask.graphics.beginFill(65280,1);
         this.m_mask.graphics.drawRect(0,_loc1_,MenuConstants.BaseWidth,MenuConstants.ElusiveContractsBriefingHeight);
         this.m_mask.graphics.endFill();
         this.m_sequenceContainer.addChild(this.m_mask);
         this.m_sequenceContainer.mask = this.m_mask;
      }
      
      public function startSequence() : void
      {
         var i:int;
         var sequenceChild:Sprite = null;
         this.m_sequenceContainer.alpha = 1;
         this.m_totalDuration = this.m_animateInDuration + this.m_baseDuration;
         i = 0;
         while(i < this.m_sequenceContainer.numChildren)
         {
            sequenceChild = this.m_sequenceContainer.getChildAt(i) as Sprite;
            if(sequenceChild["start"])
            {
               sequenceChild["start"](this.m_baseDuration,this.m_animateInDuration);
            }
            i++;
         }
         Animate.fromTo(this.m_sequenceContainer,this.m_animateInDuration,0,{
            "x":this.m_unitWidth * this.m_animateInStartRow,
            "y":this.m_unitHeight * this.m_animateInStartCol
         },{
            "x":this.m_unitWidth * this.m_animateInEndRow,
            "y":this.m_unitHeight * this.m_animateInEndCol
         },this.m_animateInEasingType,function():void
         {
            Animate.fromTo(m_sequenceContainer,m_animateOutDuration,m_baseDuration,{
               "x":m_unitWidth * m_animateOutStartRow,
               "y":m_unitHeight * m_animateOutStartCol
            },{
               "x":m_unitWidth * m_animateOutEndRow,
               "y":m_unitHeight * m_animateOutEndCol
            },m_animateOutEasingType,onSequenceEnd);
         });
      }
      
      private function onSequenceEnd() : void
      {
         var _loc2_:BaseControl = null;
         var _loc3_:Sprite = null;
         Animate.kill(this.m_sequenceContainer);
         var _loc1_:int = 0;
         while(_loc1_ < this.m_sequenceContainer.numChildren)
         {
            if(this.m_sequenceContainer.getChildAt(_loc1_) != this.m_mask)
            {
               _loc2_ = this.m_sequenceContainer.getChildAt(_loc1_) as BaseControl;
               trace("ETBriefing | BriefingSequenceController | onSequenceEnd | Animate.kill(" + _loc2_.getContainer().name + ");");
               Animate.kill(_loc2_.getContainer());
               _loc3_ = this.m_sequenceContainer.getChildAt(_loc1_) as Sprite;
               if(_loc3_["stopCountDownTimer"])
               {
                  _loc3_["stopCountDownTimer"];
               }
            }
            _loc1_++;
         }
         this.m_sequenceContainer.alpha = 0;
         this.m_sequenceContainer.removeChild(this.m_mask);
      }
      
      override public function getContainer() : Sprite
      {
         return this.m_sequenceContainer;
      }
      
      public function set SequenceDuration(param1:Number) : void
      {
         this.m_baseDuration = param1;
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
      
      public function onUnregister() : void
      {
         trace("ETBriefingSequenceBase | onUnregister CALLED!!!!");
      }
   }
}
