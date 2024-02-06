package hud.evergreen.menuoverlay
{
   import basic.ButtonPromptContainer;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   import hud.evergreen.IMenuOverlayComponent;
   
   public class ButtonPromptsComponent extends Sprite implements IMenuOverlayComponent
   {
      
      public static const DXPADDINGLEFT:Number = 25;
      
      public static const DYPADDINGTOP:Number = 25;
      
      public static const DYPROMPTSHEIGHT:Number = 55;
       
      
      private var m_promptsWrapper:Sprite;
      
      private var m_dataLastReceived:Object;
      
      private var m_prevPromptData:Object;
      
      private var m_yBottom:Number = 0;
      
      public function ButtonPromptsComponent()
      {
         this.m_promptsWrapper = new Sprite();
         super();
         this.m_promptsWrapper.name = "m_promptsWrapper";
         MenuUtils.addDropShadowFilter(this.m_promptsWrapper);
         addChild(this.m_promptsWrapper);
      }
      
      public function isLeftAligned() : Boolean
      {
         return true;
      }
      
      public function onControlLayoutChanged() : void
      {
         this.m_prevPromptData = null;
         this.updatePrompts();
      }
      
      public function onUsableSizeChanged(param1:Number, param2:Number, param3:Number) : void
      {
         this.m_yBottom = param3;
         this.updateLayout();
      }
      
      public function onSetData(param1:Object) : void
      {
         var _loc2_:Object = null;
         for each(_loc2_ in param1.buttonprompts)
         {
            if(_loc2_.actiontype == "lb_rb")
            {
               _loc2_.actiontype = ["lb","rb"];
            }
         }
         this.m_dataLastReceived = param1;
         this.updatePrompts();
      }
      
      private function updatePrompts() : void
      {
         this.m_prevPromptData = MenuUtils.parsePrompts(this.m_dataLastReceived,this.m_prevPromptData,this.m_promptsWrapper);
         var _loc1_:ButtonPromptContainer = ButtonPromptContainer(this.m_promptsWrapper.getChildAt(0));
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Number = 0;
         while(_loc2_ < this.m_dataLastReceived.buttonprompts.length)
         {
            _loc1_.getChildAt(_loc3_).x = _loc1_.getChildAt(_loc3_).x + _loc4_;
            if(this.m_dataLastReceived.buttonprompts[_loc2_].actiontype is Array)
            {
               _loc4_ -= 36;
               _loc3_++;
               _loc1_.getChildAt(_loc3_).x = _loc1_.getChildAt(_loc3_).x + _loc4_;
            }
            _loc2_++;
            _loc3_++;
         }
         this.updateLayout();
      }
      
      private function updateLayout() : void
      {
         var _loc1_:Number = 0;
         _loc1_ += DYPADDINGTOP;
         this.m_promptsWrapper.x = DXPADDINGLEFT;
         this.m_promptsWrapper.y = _loc1_ - 25;
         _loc1_ += DYPROMPTSHEIGHT;
         this.y = this.m_yBottom - _loc1_;
      }
   }
}
