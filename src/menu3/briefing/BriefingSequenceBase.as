package menu3.briefing
{
   import common.Animate;
   import common.BaseControl;
   
   public class BriefingSequenceBase extends BaseControl
   {
       
      
      public var m_totalDuration:Number;
      
      private var m_staggeredSequencesArray:Array;
      
      public function BriefingSequenceBase()
      {
         this.m_staggeredSequencesArray = new Array();
         super();
      }
      
      public function startSequence() : void
      {
         var _loc1_:BriefingSequenceController = this.m_staggeredSequencesArray.shift() as BriefingSequenceController;
         _loc1_.startSequence();
         Animate.delay(this,_loc1_.m_totalDuration,this.onCurrentSequenceEnd,_loc1_);
      }
      
      private function onCurrentSequenceEnd(param1:BriefingSequenceController) : void
      {
         Animate.kill(this);
         if(this.m_staggeredSequencesArray.length)
         {
            trace("ETBriefing | BriefingSequenceBase | onCurrentSequenceEnd | GO NEXT");
            this.startSequence();
         }
         else
         {
            trace("ETBriefing | BriefingSequenceBase | onCurrentSequenceEnd | STOP TEH MADNESS");
         }
      }
      
      override public function onChildrenAttached() : void
      {
         super.onChildrenAttached();
         var _loc1_:int = 0;
         while(_loc1_ < getContainer().numChildren)
         {
            this.m_staggeredSequencesArray.push(getContainer().getChildAt(_loc1_));
            _loc1_++;
         }
      }
      
      public function onUnregister() : void
      {
         trace("BriefingSequenceBase | onUnregister CALLED!!!!");
      }
   }
}
