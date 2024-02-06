package hud
{
   import basic.ButtonPromptImage;
   import common.BaseControl;
   import common.Localization;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   
   public class ButtonPrompts extends BaseControl
   {
       
      
      private var m_promptsContainer:Sprite;
      
      public function ButtonPrompts()
      {
         super();
         this.m_promptsContainer = new Sprite();
         addChild(this.m_promptsContainer);
      }
      
      public function onSetData(param1:Object) : void
      {
         var _loc4_:MenuButtonLegendViewHUD = null;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:* = false;
         while(this.m_promptsContainer.numChildren > 0)
         {
            this.m_promptsContainer.removeChildAt(0);
         }
         var _loc2_:Number = 0;
         var _loc3_:int = 0;
         while(_loc3_ < param1.buttonprompts.length)
         {
            trace(_loc3_);
            _loc5_ = param1.buttonprompts[_loc3_].actiontype as String;
            _loc6_ = param1.buttonprompts[_loc3_].actiontype as Array;
            if(_loc5_ != null)
            {
               _loc4_ = this.addPrompt(param1.buttonprompts[_loc3_],_loc2_);
               _loc2_ += _loc4_.width + 24;
            }
            else if(_loc6_ != null)
            {
               _loc7_ = 0;
               while(_loc7_ < _loc6_.length)
               {
                  _loc8_ = _loc7_ == _loc6_.length - 1;
                  _loc4_ = this.addPrompt({
                     "actiontype":_loc6_[_loc7_],
                     "actionlabel":(_loc8_ ? param1.buttonprompts[_loc3_].actionlabel : "")
                  },_loc2_);
                  _loc2_ += _loc8_ ? _loc4_.width + 24 : _loc4_.button.width;
                  _loc7_++;
               }
            }
            _loc3_++;
         }
      }
      
      private function addPrompt(param1:Object, param2:Number) : MenuButtonLegendViewHUD
      {
         var _loc3_:MenuButtonLegendViewHUD = new MenuButtonLegendViewHUD();
         var _loc4_:ButtonPromptImage;
         (_loc4_ = new ButtonPromptImage()).x = 27;
         _loc4_.y = 49;
         _loc4_.platform = ControlsMain.getControllerType();
         _loc4_.action = param1.actiontype;
         _loc3_.addChild(_loc4_);
         _loc3_.header.autoSize = "left";
         MenuUtils.setupText(_loc3_.header,Localization.get(param1.actionlabel),16,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorGreyUltraLight);
         _loc3_.x = param2;
         this.m_promptsContainer.addChild(_loc3_);
         return _loc3_;
      }
   }
}
