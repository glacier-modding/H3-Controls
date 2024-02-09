package menu3.basic
{
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import menu3.MenuElementBase;
   
   public dynamic class StateText extends MenuElementBase
   {
       
      
      private const BACKGROUNDBOX_OVERFLOW:Number = 10;
      
      private const BACKGROUNDBOX_OVERFLOW_OFFSET_Y:Number = -6;
      
      private const BACKGROUNDBOX_OFFSET_Y:Number = -2;
      
      private var m_view:Sprite;
      
      private var m_background:Sprite;
      
      private var m_text:TextField;
      
      public function StateText(param1:Object)
      {
         super(param1);
         this.m_view = new Sprite();
         this.m_background = new Sprite();
         this.m_view.addChild(this.m_background);
         this.m_text = new TextField();
         this.m_text.multiline = false;
         this.m_text.autoSize = TextFieldAutoSize.LEFT;
         this.m_view.addChild(this.m_text);
         addChild(this.m_view);
      }
      
      override public function onSetData(param1:Object) : void
      {
         super.onSetData(param1);
         var _loc2_:* = param1.isdone === true;
         var _loc3_:String = param1.text != null ? String(param1.text) : "";
         MenuUtils.setupTextUpper(this.m_text,_loc3_,40,MenuConstants.FONT_TYPE_BOLD,_loc2_ ? MenuConstants.FontColorBlack : MenuConstants.FontColorWhite);
         var _loc4_:Number;
         var _loc5_:Number = (_loc4_ = param1.backgroundoverflow != null ? Number(param1.backgroundoverflow) : this.BACKGROUNDBOX_OVERFLOW) + this.BACKGROUNDBOX_OVERFLOW_OFFSET_Y;
         var _loc6_:Number = this.m_text.width + _loc4_ * 2;
         var _loc7_:Number = this.m_text.height + _loc5_ * 2;
         this.m_background.graphics.clear();
         this.m_background.graphics.beginFill(_loc2_ ? uint(MenuConstants.COLOR_GREEN) : uint(MenuConstants.COLOR_RED),1);
         this.m_background.graphics.drawRect(-_loc4_,-_loc5_ + this.BACKGROUNDBOX_OFFSET_Y,_loc6_,_loc7_);
         this.m_background.graphics.endFill();
      }
      
      override public function onUnregister() : void
      {
         if(this.m_view)
         {
            removeChild(this.m_view);
            this.m_view = null;
         }
         this.m_background = null;
         this.m_text = null;
         super.onUnregister();
      }
   }
}
