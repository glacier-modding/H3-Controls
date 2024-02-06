package basic
{
   import common.BaseControl;
   import common.CommonUtils;
   import common.menu.MenuUtils;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import scaleform.gfx.TextFormatEx;
   
   public class TextBox extends BaseControl
   {
       
      
      protected var m_view:LabelView;
      
      protected var m_textfield:TextField;
      
      protected var m_textformat:TextFormat;
      
      protected var m_checkForGlobalFont:Boolean;
      
      protected var m_shrinkToFit:Boolean = false;
      
      protected var m_uppercase:Boolean = false;
      
      protected var m_text:String = "";
      
      protected var m_font:String = "$normal";
      
      protected var m_fontSize:int = 12;
      
      protected var m_fontColor:String = "#000000";
      
      public function TextBox()
      {
         this.m_view = new LabelView();
         this.m_textfield = this.m_view.m_textfield;
         this.m_textformat = new TextFormat();
         this.m_textfield.antiAliasType = AntiAliasType.ADVANCED;
         this.m_checkForGlobalFont = false;
         super();
      }
      
      override public function onAttached() : void
      {
         this.m_textfield.wordWrap = true;
         this.m_textfield.embedFonts = false;
         this.applyFormat();
         addChild(this.m_textfield);
      }
      
      public function GetTextField() : TextField
      {
         return this.m_textfield;
      }
      
      public function set Text(param1:String) : void
      {
         this.m_text = param1;
         this.applyFormat();
      }
      
      public function SetText(param1:String) : void
      {
         this.Text = param1;
      }
      
      public function set CheckForGlobalFont(param1:Boolean) : void
      {
         this.m_checkForGlobalFont = param1;
         this.applyFormat();
      }
      
      public function set ShrinkToFit(param1:Boolean) : void
      {
         this.m_shrinkToFit = param1;
         this.applyFormat();
      }
      
      public function set Uppercase(param1:Boolean) : void
      {
         this.m_uppercase = param1;
         this.applyFormat();
      }
      
      public function set WrapText(param1:Boolean) : void
      {
         this.m_textfield.wordWrap = param1;
      }
      
      public function set TextAlignment(param1:String) : void
      {
         this.m_textformat.align = param1;
         this.applyFormat();
      }
      
      public function set CompactBulletLists(param1:Boolean) : void
      {
         TextFormatEx.setBulletIndent(this.m_textformat,param1 ? 0 : null);
         this.applyFormat();
      }
      
      public function set ParagraphLeading(param1:Number) : void
      {
         var _loc2_:int = int(param1);
         TextFormatEx.setParagraphLeading(this.m_textformat,_loc2_ > 0 ? _loc2_ : null);
         this.applyFormat();
      }
      
      public function set Font(param1:String) : void
      {
         this.m_font = param1;
         this.applyFormat();
      }
      
      public function set FontSize(param1:Number) : void
      {
         var _loc2_:int = int(param1);
         if(_loc2_ == this.m_fontSize)
         {
            return;
         }
         this.m_fontSize = _loc2_;
         this.applyFormat();
      }
      
      public function set Color(param1:String) : void
      {
         var _loc2_:Number = parseInt(param1,16);
         if(!isNaN(_loc2_))
         {
            this.m_fontColor = "#" + param1;
            this.applyFormat();
         }
      }
      
      public function SetColor(param1:String) : void
      {
         this.Color = param1;
      }
      
      public function set Alpha(param1:Number) : void
      {
         alpha = param1;
      }
      
      public function set Background(param1:Boolean) : void
      {
         this.m_textfield.background = param1;
      }
      
      public function set BackgroundColor(param1:String) : void
      {
         var _loc2_:Number = parseInt(param1,16);
         if(!isNaN(_loc2_))
         {
            this.m_textfield.backgroundColor = _loc2_;
         }
      }
      
      override public function onSetSize(param1:Number, param2:Number) : void
      {
         this.m_textfield.width = param1;
         this.m_textfield.height = param2;
      }
      
      protected function applyFormat() : void
      {
         if(this.m_uppercase)
         {
            MenuUtils.setupTextUpper(this.m_textfield,this.m_text,this.m_fontSize,this.m_font,this.m_fontColor);
         }
         else
         {
            MenuUtils.setupText(this.m_textfield,this.m_text,this.m_fontSize,this.m_font,this.m_fontColor);
         }
         if(this.m_checkForGlobalFont)
         {
            CommonUtils.changeFontToGlobalIfNeeded(this.m_textfield);
         }
         if(this.m_shrinkToFit)
         {
            this.applyShrinkToFit();
         }
         else
         {
            this.m_textfield.setTextFormat(this.m_textformat);
         }
      }
      
      private function applyShrinkToFit() : void
      {
         MenuUtils.shrinkTextToFit(this.m_textfield,this.m_textfield.width,this.m_textfield.height);
         var _loc1_:TextFormat = this.m_textfield.getTextFormat();
         _loc1_.align = this.m_textformat.align;
         TextFormatEx.setBulletIndent(_loc1_,TextFormatEx.getBulletIndent(this.m_textformat));
         TextFormatEx.setParagraphLeading(_loc1_,TextFormatEx.getParagraphLeading(this.m_textformat));
         this.m_textfield.setTextFormat(_loc1_);
      }
      
      public function onSetData(param1:Object) : void
      {
         var _loc2_:Number = NaN;
         if(param1 as Number)
         {
            _loc2_ = param1 as Number;
            if(Math.abs(_loc2_ % 1) > 0.001)
            {
               this.Text = _loc2_.toFixed(2).toString();
            }
            else
            {
               this.Text = _loc2_.toString();
            }
         }
         else
         {
            this.Text = param1.toString();
         }
      }
   }
}
