package menu3
{
   import common.Animate;
   import common.CommonUtils;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import menu3.basic.TextTickerUtil;
   
   public dynamic class TextLineElement extends MenuElementBase
   {
       
      
      private var m_once:Boolean = true;
      
      private var m_textfield:TextField;
      
      private var m_textTickerUtil:TextTickerUtil;
      
      private var m_title:String;
      
      private var m_maxtextwidth:Number;
      
      private var m_fontcolor:String;
      
      private var m_fontsize:int;
      
      private var m_fonttype:String;
      
      private var m_textfieldAnimTargetX:Number;
      
      private var m_textfieldAnimTargetY:Number;
      
      private var m_textfieldAnimTargetAlpha:Number;
      
      public function TextLineElement(param1:Object)
      {
         this.m_textTickerUtil = new TextTickerUtil();
         super(param1);
         this.m_textfield = new TextField();
         this.m_textfield.autoSize = TextFieldAutoSize.LEFT;
         addChild(this.m_textfield);
         MenuUtils.addDropShadowFilter(this.m_textfield);
      }
      
      override public function onSetData(param1:Object) : void
      {
         var isTextUpdated:Boolean;
         var title:String;
         var maxtextwidth:Number;
         var fontcolor:String;
         var fontsize:int;
         var fonttype:String;
         var vars:Object = null;
         var xoffset:Number = NaN;
         var yoffset:Number = NaN;
         var alpha:Number = NaN;
         var isTextTooLong:Boolean = false;
         var data:Object = param1;
         super.onSetData(data);
         if(this.m_once)
         {
            this.m_once = false;
            this.m_textfield.x = data.xoffset != null ? Number(data.xoffset) : 0;
            this.m_textfield.y = data.yoffset != null ? Number(data.yoffset) : 0;
            this.m_textfield.alpha = data.alpha != null ? Number(data.alpha) : 1;
            this.m_textfieldAnimTargetX = this.m_textfield.x;
            this.m_textfieldAnimTargetY = this.m_textfield.y;
            this.m_textfieldAnimTargetAlpha = this.m_textfield.alpha;
         }
         else
         {
            vars = null;
            xoffset = data.xoffset != null ? Number(data.xoffset) : 0;
            yoffset = data.yoffset != null ? Number(data.yoffset) : 0;
            alpha = data.alpha != null ? Number(data.alpha) : 1;
            if(xoffset != this.m_textfieldAnimTargetX)
            {
               vars ||= {};
               vars.x = this.m_textfieldAnimTargetX = xoffset;
            }
            if(yoffset != this.m_textfieldAnimTargetY)
            {
               vars ||= {};
               vars.y = this.m_textfieldAnimTargetY = yoffset;
            }
            if(alpha != this.m_textfieldAnimTargetAlpha)
            {
               vars ||= {};
               vars.alpha = this.m_textfieldAnimTargetAlpha = alpha;
            }
            if(vars)
            {
               if(vars.alpha != null)
               {
                  this.m_textfield.visible = true;
               }
               Animate.to(this.m_textfield,0.2,0,vars,Animate.Linear,function():void
               {
                  m_textfield.visible = m_textfield.alpha != 0;
               });
            }
         }
         isTextUpdated = false;
         title = data.title != null ? String(data.title) : "";
         maxtextwidth = data.maxtextwidth != null ? Number(data.maxtextwidth) : 250;
         fontcolor = data.colorname != null ? this.getColorString(data.colorname) : MenuConstants.FontColorWhite;
         fontsize = data.fontsize != null ? int(data.fontsize) : 26;
         fonttype = data.fonttype != null ? String(data.fonttype) : MenuConstants.FONT_TYPE_MEDIUM;
         if(title != this.m_title)
         {
            this.m_title = title;
            isTextUpdated = true;
         }
         if(maxtextwidth != this.m_maxtextwidth)
         {
            this.m_maxtextwidth = maxtextwidth;
            isTextUpdated = true;
         }
         if(fontcolor != this.m_fontcolor)
         {
            this.m_fontcolor = fontcolor;
            isTextUpdated = true;
         }
         if(fontsize != this.m_fontsize)
         {
            this.m_fontsize = fontsize;
            isTextUpdated = true;
         }
         if(fonttype != this.m_fonttype)
         {
            this.m_fonttype = fonttype;
            isTextUpdated = true;
         }
         if(isTextUpdated)
         {
            this.m_textfield.width = this.m_maxtextwidth;
            MenuUtils.setupText(this.m_textfield,this.m_title,this.m_fontsize,this.m_fonttype,this.m_fontcolor);
            this.m_textTickerUtil.addTextTicker(this.m_textfield,this.m_textfield.htmlText);
            MenuUtils.truncateTextfield(this.m_textfield,1,null,CommonUtils.changeFontToGlobalIfNeeded(this.m_textfield));
            this.m_textfield.wordWrap = true;
            this.m_textfield.multiline = true;
            isTextTooLong = this.m_textfield.numLines > 1;
            this.m_textfield.multiline = false;
            this.m_textfield.wordWrap = false;
            this.m_textfield.autoSize = isTextTooLong ? TextFieldAutoSize.NONE : TextFieldAutoSize.LEFT;
            this.m_textTickerUtil.callTextTicker(true,this.m_textfield.textColor);
         }
      }
      
      override public function onUnregister() : void
      {
         if(this.m_textTickerUtil != null)
         {
            this.m_textTickerUtil.onUnregister();
            this.m_textTickerUtil = null;
         }
         removeChild(this.m_textfield);
         this.m_textfield = null;
         super.onUnregister();
      }
      
      private function getColorString(param1:String) : String
      {
         return MenuConstants.ColorString(MenuConstants.GetColorByName(param1));
      }
   }
}
