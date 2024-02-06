package menu3.basic
{
   import common.CommonUtils;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import menu3.MenuElementBase;
   
   public dynamic class TextLineWithIcon extends MenuElementBase
   {
       
      
      private var m_view:Sprite = null;
      
      private var m_icon:iconsAll40x40View = null;
      
      private var m_textfield:TextField = null;
      
      private var m_textTickerUtil:TextTickerUtil;
      
      private var m_color:int = 16777215;
      
      private var m_fontcolor:String;
      
      private var m_iconLabel:String;
      
      private var m_isTextScrollingEnabled:Boolean;
      
      public function TextLineWithIcon(param1:Object)
      {
         this.m_textTickerUtil = new TextTickerUtil();
         this.m_fontcolor = MenuConstants.FontColorWhite;
         super(param1);
         this.m_view = new Sprite();
         addChild(this.m_view);
         this.m_icon = new iconsAll40x40View();
         this.m_icon.x = 36.5;
         this.m_icon.y = 32.5;
         this.m_textfield = new TextField();
         this.m_textfield.autoSize = TextFieldAutoSize.LEFT;
         this.m_textfield.x = 65;
         this.m_textfield.y = 17;
         this.m_textfield.wordWrap = false;
         this.m_textfield.multiline = false;
         this.m_view.addChild(this.m_icon);
         this.m_view.addChild(this.m_textfield);
      }
      
      override public function onSetData(param1:Object) : void
      {
         super.onSetData(param1);
         this.m_textfield.width = param1.maxtextwidth != undefined ? Number(param1.maxtextwidth) : 250;
         this.m_textfield.autoSize = TextFieldAutoSize.LEFT;
         this.m_color = MenuConstants.COLOR_WHITE;
         this.m_fontcolor = MenuConstants.FontColorWhite;
         if(param1.colorname != null)
         {
            this.m_color = MenuConstants.GetColorByName(param1.colorname);
            this.m_fontcolor = MenuConstants.ColorString(this.m_color);
         }
         this.m_iconLabel = param1.icon;
         MenuUtils.setupIcon(this.m_icon,this.m_iconLabel,this.m_color,true,false);
         this.setupTextField(param1.title);
         this.m_textfield.wordWrap = true;
         this.m_textfield.multiline = true;
         var _loc2_:int = this.m_textfield.numLines;
         this.m_textfield.multiline = false;
         this.m_textfield.wordWrap = false;
         if(_loc2_ > 1)
         {
            this.m_textfield.autoSize = TextFieldAutoSize.NONE;
         }
         this.m_view.x = 0;
         this.m_view.y = 0;
         if(param1.align == "right")
         {
            this.m_view.x = (this.m_textfield.x + this.m_textfield.width) * -1;
         }
         else if(param1.align == "center")
         {
            this.m_view.x = (this.m_textfield.x + this.m_textfield.width) * -0.5;
         }
         this.m_isTextScrollingEnabled = !!param1.force_scroll ? true : false;
         MenuUtils.addDropShadowFilter(this.m_textfield);
         MenuUtils.addDropShadowFilter(this.m_icon);
         if(this.m_isTextScrollingEnabled)
         {
            this.callTextTicker(true);
         }
      }
      
      override public function getView() : Sprite
      {
         return this;
      }
      
      private function setupTextField(param1:String) : void
      {
         MenuUtils.setupTextUpper(this.m_textfield,param1,26,MenuConstants.FONT_TYPE_MEDIUM,this.m_fontcolor);
         this.m_textTickerUtil.addTextTicker(this.m_textfield,this.m_textfield.htmlText);
         MenuUtils.truncateTextfield(this.m_textfield,1,null,CommonUtils.changeFontToGlobalIfNeeded(this.m_textfield));
      }
      
      private function changeTextColor(param1:int) : void
      {
         this.m_textfield.textColor = param1;
      }
      
      private function callTextTicker(param1:Boolean) : void
      {
         this.m_textTickerUtil.callTextTicker(param1,this.m_textfield.textColor);
      }
      
      override public function onUnregister() : void
      {
         super.onUnregister();
         if(this.m_textTickerUtil != null)
         {
            this.m_textTickerUtil.onUnregister();
            this.m_textTickerUtil = null;
         }
         this.m_textfield = null;
         this.m_icon = null;
         if(this.m_view != null)
         {
            removeChild(this.m_view);
            this.m_view = null;
         }
      }
   }
}
