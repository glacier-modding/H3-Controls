package menu3
{
   import common.BaseControl;
   import common.CommonUtils;
   import common.Log;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class TextBoxBoot extends BaseControl
   {
       
      
      protected var m_view:LabelView;
      
      protected var m_textfield:TextField;
      
      protected var m_textformat:TextFormat;
      
      protected var m_checkForGlobalFont:Boolean;
      
      public function TextBoxBoot()
      {
         this.m_view = new LabelView();
         this.m_textfield = this.m_view.m_textfield;
         this.m_textformat = new TextFormat("$normal");
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
      
      public function set Text(param1:String) : void
      {
         this.m_textfield.htmlText = param1;
         this.applyFormat();
         if(this.m_checkForGlobalFont)
         {
            CommonUtils.changeFontToGlobalIfNeeded(this.m_textfield);
         }
      }
      
      public function SetText(param1:String) : void
      {
         this.Text = param1;
      }
      
      public function set CheckForGlobalFont(param1:Boolean) : void
      {
         this.m_checkForGlobalFont = param1;
         this.SetText(this.m_textfield.htmlText);
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
      
      public function set Font(param1:String) : void
      {
         this.m_textformat.font = param1;
         this.applyFormat();
      }
      
      public function set FontSize(param1:Number) : void
      {
         this.m_textformat.size = param1;
         this.applyFormat();
      }
      
      public function set LetterSpacing(param1:Number) : void
      {
         this.m_textformat.letterSpacing = param1;
         this.applyFormat();
      }
      
      public function set Color(param1:String) : void
      {
         var _loc2_:Number = parseInt(param1,16);
         if(!isNaN(_loc2_))
         {
            this.m_textformat.color = _loc2_;
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
      
      override public function onSetSize(param1:Number, param2:Number) : void
      {
         this.m_textfield.width = param1;
         this.m_textfield.height = param2;
      }
      
      protected function applyFormat() : void
      {
         this.m_textfield.setTextFormat(this.m_textformat);
      }
      
      public function onSetData(param1:Object) : void
      {
         var _loc2_:String = String(param1.prependedstring);
         if(param1.username)
         {
            _loc2_ = _loc2_.replace("{0}",param1.username);
         }
         Log.xinfo(Log.ChannelCommon,"text: " + _loc2_);
         this.Text = _loc2_;
      }
   }
}
