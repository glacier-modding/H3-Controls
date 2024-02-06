package menu3.basic
{
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public dynamic class HeadlineWithTags extends HeadlineElement
   {
       
      
      private const HEADLINE_OFFSET:Number = -22;
      
      private const TAG_OFFSET_X:Number = 10;
      
      private const TAG_OFFSET_Y:Number = 2;
      
      private const TAG_MIN_WIDTH:Number = 60;
      
      private const TAG_TEXT_SPACE_X:Number = 20;
      
      private const TAG_LINETHROUGH_SPACE_X:Number = 14;
      
      private const TAGLINE_MAX_WIDTH:Number = MenuConstants.BaseWidth - MenuConstants.menuXOffset - 300;
      
      private var m_tagContainer:Sprite;
      
      private var m_maxTagLinePosX:Number;
      
      public function HeadlineWithTags(param1:Object)
      {
         this.m_tagContainer = new Sprite();
         super(param1);
         var _loc2_:HeadlineElementView = getRootView();
         var _loc3_:TextField = _loc2_.contractby;
         this.m_tagContainer.y = _loc3_.y + _loc3_.height + this.TAG_OFFSET_Y;
         this.m_tagContainer.x = _loc2_.title.x;
         _loc2_.addChild(this.m_tagContainer);
         _loc2_.y += this.HEADLINE_OFFSET;
      }
      
      override public function onSetData(param1:Object) : void
      {
         super.onSetData(param1);
         if(param1.tags != null)
         {
            this.setupTags(param1.tags);
         }
      }
      
      private function setupTags(param1:Array) : void
      {
         var _loc5_:HeadlineTagView = null;
         var _loc6_:TextField = null;
         var _loc7_:Boolean = false;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         this.m_tagContainer.removeChildren();
         if(param1 == null || param1.length <= 0)
         {
            return;
         }
         var _loc2_:Number = 0;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         while(_loc4_ < param1.length && !_loc3_)
         {
            (_loc6_ = (_loc5_ = new HeadlineTagView()).title).autoSize = TextFieldAutoSize.LEFT;
            _loc7_ = Boolean(param1[_loc4_].active);
            MenuUtils.setupText(_loc6_,param1[_loc4_].title,18,MenuConstants.FONT_TYPE_MEDIUM,_loc7_ ? MenuConstants.FontColorGreyUltraLight : MenuConstants.FontColorGreyMedium);
            MenuUtils.setTintColor(_loc5_.bg,_loc7_ ? MenuUtils.TINT_COLOR_MEDIUM_GREY : MenuUtils.TINT_COLOR_GREY);
            MenuUtils.setTintColor(_loc5_.linethrough,MenuUtils.TINT_COLOR_NEARLY_WHITE);
            if((_loc9_ = (_loc8_ = _loc6_.width) + this.TAG_TEXT_SPACE_X) + _loc2_ > this.TAGLINE_MAX_WIDTH)
            {
               _loc9_ = Math.max(this.TAGLINE_MAX_WIDTH - _loc2_,this.TAG_MIN_WIDTH);
               _loc6_.width = _loc9_ - this.TAG_TEXT_SPACE_X;
               MenuUtils.truncateTextfield(_loc6_,1,null);
               _loc3_ = true;
            }
            _loc5_.bg.width = _loc9_;
            _loc5_.bg.x = _loc9_ / 2;
            _loc5_.linethrough.visible = !_loc7_;
            if(!_loc7_)
            {
               _loc10_ = _loc9_ - this.TAG_LINETHROUGH_SPACE_X;
               _loc5_.linethrough.width = _loc10_;
               _loc5_.linethrough.x = _loc10_ / 2 + this.TAG_LINETHROUGH_SPACE_X / 2;
            }
            this.m_tagContainer.addChild(_loc5_);
            _loc5_.x = _loc2_;
            _loc2_ += _loc9_ + this.TAG_OFFSET_X;
            _loc4_++;
         }
      }
      
      override public function onUnregister() : void
      {
         this.m_tagContainer.removeChildren();
         getRootView().removeChild(this.m_tagContainer);
         this.m_tagContainer = null;
         super.onUnregister();
      }
   }
}
