package menu3.tests.elusivetargetbriefingsequence
{
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.text.TextField;
   
   public class EtSequenceTextBlocks
   {
      
      public static var m_unitWidth:Number = MenuConstants.BaseWidth / 10;
      
      public static var m_unitHeight:Number = MenuConstants.BaseHeight / 6;
       
      
      public function EtSequenceTextBlocks()
      {
         super();
      }
      
      public static function setupTimerBlock(param1:Object, param2:*, param3:*) : void
      {
         var _loc4_:TextField;
         (_loc4_ = new TextField()).name = "timerBlockHeaderTextField";
         _loc4_.autoSize = "left";
         _loc4_.x = -4;
         _loc4_.y = -70;
         MenuUtils.setupText(_loc4_,param1.header,60,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorBlack);
         param2.addChild(_loc4_);
         var _loc5_:TextField;
         (_loc5_ = new TextField()).name = "timerBlockTimeTextField";
         _loc5_.autoSize = "left";
         _loc5_.x = -4;
         _loc5_.y = -32;
         MenuUtils.setupText(_loc5_,"",148,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorGreyUltraLight);
         param2.addChild(_loc5_);
         if(param1.playableUntil)
         {
            param3.startCountDownTimer(param1.playableUntil,_loc5_,148);
         }
      }
   }
}
