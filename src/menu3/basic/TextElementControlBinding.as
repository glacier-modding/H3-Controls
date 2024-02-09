package menu3.basic
{
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import menu3.MenuElementBase;
   
   public dynamic class TextElementControlBinding extends MenuElementBase
   {
       
      
      private var m_view:TextElementControlBindingView;
      
      private var m_textfield:TextField;
      
      private var m_textformat:TextFormat;
      
      public function TextElementControlBinding(param1:Object)
      {
         super(param1);
         if(param1.visible != null)
         {
            this.visible = param1.visible;
         }
         this.m_textformat = new TextFormat();
         this.m_textformat.align = TextFormatAlign.LEFT;
         this.m_textformat.size = param1.fontSize || 24;
         this.m_view = new TextElementControlBindingView();
         this.m_view.tileBg.alpha = 0;
         addChild(this.m_view);
      }
      
      override public function onSetData(param1:Object) : void
      {
         this.m_textfield = this.m_view.title;
         this.m_textfield.defaultTextFormat = this.m_textformat;
         this.m_textfield.autoSize = TextFieldAutoSize.LEFT;
         this.m_textfield.multiline = true;
         this.m_textfield.wordWrap = true;
         MenuUtils.setupText(this.m_textfield,String(param1.title) || "",20,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
         this.m_textfield.width = Number(param1.width) || 0;
         this.m_textfield.height = Number(param1.height) || 0;
         if(param1.showDebugBoundries != undefined && param1.showDebugBoundries == true)
         {
            this.m_textfield.border = true;
            this.m_textfield.borderColor = 16711935;
            this.m_view.tileBg.alpha = 0.2;
         }
         this.m_textfield.setTextFormat(this.m_textformat);
         this.m_textfield.y = (this.m_view.tileBg.height >> 1) - (this.m_textfield.height >> 1);
         this.m_view.tileBg.width = this.m_textfield.width;
         this.m_view.tileBg.x = this.m_view.tileBg.width >> 1;
      }
      
      override public function getHeight() : Number
      {
         return this.m_view.tileBg.height;
      }
      
      override public function onUnregister() : void
      {
         if(this.m_view)
         {
            this.m_textfield = null;
            this.m_textformat = null;
            removeChild(this.m_view);
            this.m_view = null;
         }
      }
   }
}
