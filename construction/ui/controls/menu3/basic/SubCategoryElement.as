package menu3.basic
{
   import common.MouseUtil;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public dynamic class SubCategoryElement extends CategoryElementBase
   {
       
      
      private var m_view:SubCategoryElementView;
      
      private const HORIZONTAL_PADDING:int = 20;
      
      public function SubCategoryElement(param1:Object)
      {
         super(param1);
         m_mouseMode = MouseUtil.MODE_ONOVER_HOVER_ONUP_SELECT;
         m_mouseModeCollapsed = MouseUtil.MODE_ONOVER_HOVER_ONUP_SELECT;
         m_mouseModeUncollapsed = MouseUtil.MODE_ONOVER_HOVER_ONUP_SELECT;
         this.m_view = new SubCategoryElementView();
         this.m_view.y = 14;
         this.m_view.tileBg.alpha = 0;
         MenuUtils.setColor(this.m_view.tileSelect,MenuConstants.COLOR_MENU_TABS_BACKGROUND,true,MenuConstants.MenuElementBackgroundAlpha);
         this.setupTextFields(String(param1.title) || "");
         this.setSelectedAnimationState(STATE_DEFAULT);
         this.adjustSizeAndPosition();
         addChild(this.m_view);
      }
      
      override public function onUnregister() : void
      {
         if(this.m_view)
         {
            removeChild(this.m_view);
            this.m_view = null;
         }
         super.onUnregister();
      }
      
      private function adjustSizeAndPosition() : void
      {
         this.m_view.tileBg.width = Math.ceil(this.m_view.title.width + this.HORIZONTAL_PADDING * 2);
         this.m_view.tileSelect.width = this.m_view.tileBg.width - 4;
         this.m_view.tileSelect.x = this.m_view.tileBg.x + 2;
      }
      
      override public function getView() : Sprite
      {
         return this.m_view;
      }
      
      private function setupTextFields(param1:String) : void
      {
         MenuUtils.setupTextUpper(this.m_view.title,param1,18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         this.textfieldAutosize(this.m_view.title,TextFieldAutoSize.LEFT);
         MenuUtils.truncateTextfield(this.m_view.title,1);
         this.m_view.title.width = Math.ceil(this.m_view.title.width);
         this.m_view.title.x = this.HORIZONTAL_PADDING;
      }
      
      override protected function setSelectedAnimationState(param1:int) : void
      {
         if(param1 == STATE_SELECTED)
         {
            MenuUtils.setColor(this.m_view.tileSelect,MenuConstants.COLOR_RED,true,MenuConstants.MenuElementSelectedAlpha);
         }
         else if(param1 == STATE_HOVER)
         {
            MenuUtils.setColor(this.m_view.tileSelect,MenuConstants.COLOR_RED,true,MenuConstants.MenuElementSelectedAlpha);
         }
         else
         {
            MenuUtils.setColor(this.m_view.tileSelect,MenuConstants.COLOR_MENU_TABS_BACKGROUND,true,MenuConstants.MenuElementBackgroundAlpha);
         }
      }
      
      private function textfieldAutosize(param1:TextField, param2:String = "left") : void
      {
         var tempHeight:Number = NaN;
         var tf:TextField = param1;
         var direction:String = param2;
         try
         {
            tf.autoSize = direction;
            tempHeight = tf.height;
            tf.autoSize = TextFieldAutoSize.NONE;
            tf.height = tempHeight + 2;
         }
         catch(error:Error)
         {
            trace(this,"[TextFieldAutosize]",error);
         }
      }
   }
}
