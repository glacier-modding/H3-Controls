package basic
{
   import common.Animate;
   import common.BaseControl;
   import common.CommonUtils;
   import common.menu.MenuUtils;
   import flash.display.MovieClip;
   import flash.text.*;
   import mx.utils.StringUtil;
   
   public class Subtitle extends BaseControl
   {
      
      public static const MIN_FONT_SIZE:int = 22;
      
      public static const MAX_FONT_SIZE:int = 46;
      
      public static const LOCKBIT_None:int = 0;
      
      public static const LOCKBIT_Left:int = 1;
      
      public static const LOCKBIT_Top:int = 2;
      
      public static const LOCKBIT_Right:int = 4;
      
      public static const LOCKBIT_Bot:int = 8;
       
      
      private var m_view:SubTitleView;
      
      private var m_sub_txt:TextField;
      
      private var m_characterName_txt:TextField;
      
      private var m_textFieldSetWidth:Number;
      
      private var m_icon2DSpeaker_mc:MovieClip;
      
      private var m_arrowL_mc:MovieClip;
      
      private var m_arrowR_mc:MovieClip;
      
      private var m_fontSize:Number = 22;
      
      private var m_fBGAlpha:Number = 0;
      
      private var m_alignToBottom:Boolean = true;
      
      private var m_fCinematicMode:Number = 1;
      
      private var m_isAntiFreakoutDisabled:Boolean = true;
      
      public function Subtitle()
      {
         super();
         this.m_view = new SubTitleView();
         addChild(this.m_view);
         this.m_characterName_txt = this.m_view.characterName_txt;
         this.m_sub_txt = this.m_view.sub_txt;
         this.m_textFieldSetWidth = this.m_sub_txt.width;
         this.m_fontSize = CommonUtils.getUIOptionValueNumber("UI_OPTION_GRAPHICS_SUBTITLES_SIZE");
         this.m_fBGAlpha = CommonUtils.getUIOptionValueNumber("UI_OPTION_GRAPHICS_SUBTITLES_BGALPHA") / 100;
         this.m_icon2DSpeaker_mc = this.m_view.icon2DSpeaker_mc;
         this.m_arrowL_mc = this.m_view.arrowL_mc;
         this.m_arrowR_mc = this.m_view.arrowR_mc;
         if(ControlsMain.isVrModeActive())
         {
            this.m_arrowL_mc.filters = [];
            this.m_arrowR_mc.filters = [];
            this.m_icon2DSpeaker_mc.filters = [];
         }
         this.updateViewportLockBits(LOCKBIT_None);
         this.m_characterName_txt.alpha = 1;
         this.m_icon2DSpeaker_mc.alpha = 0;
         this.m_arrowL_mc.alpha = 0;
         this.m_arrowR_mc.alpha = 0;
      }
      
      private static function easeInOut(param1:Number) : Number
      {
         var _loc2_:Number = NaN;
         if(param1 < 0.5)
         {
            return 2 * param1 * param1;
         }
         _loc2_ = 2 * param1 - 2;
         return 1 - 0.5 * _loc2_ * _loc2_;
      }
      
      public function set isAntiFreakoutDisabled(param1:Boolean) : void
      {
         this.m_isAntiFreakoutDisabled = param1;
      }
      
      public function setCinematicMode(param1:Number) : void
      {
         this.m_fCinematicMode = param1;
         this.m_characterName_txt.alpha = easeInOut(Math.max(0,2 * param1 - 1));
         this.m_icon2DSpeaker_mc.alpha = this.m_arrowL_mc.alpha = this.m_arrowR_mc.alpha = easeInOut(Math.max(0,1 - 2 * param1));
         this.updateSpeakerIndicatorLayout();
         this.updateDarkBack();
      }
      
      public function getTextFieldWidth() : Number
      {
         return this.m_textFieldSetWidth;
      }
      
      override public function onSetSize(param1:Number, param2:Number) : void
      {
         this.m_sub_txt.width = param1;
         this.m_textFieldSetWidth = param1;
         this.m_sub_txt.height = param2;
         this.updateSpeakerIndicatorLayout();
         this.updateDarkBack();
      }
      
      public function onSetData(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         if("text" in param1)
         {
            _loc2_ = String(param1.text);
         }
         else
         {
            _loc2_ = param1 as String;
         }
         if("fontsize" in param1)
         {
            this.m_fontSize = param1.fontsize;
         }
         if("pctBGAlpha" in param1)
         {
            this.m_fBGAlpha = param1.pctBGAlpha / 100;
         }
         if("align" in param1)
         {
            this.m_alignToBottom = param1.align == "bottom";
         }
         else
         {
            this.m_alignToBottom = true;
         }
         this.m_fontSize = Math.max(this.m_fontSize,MIN_FONT_SIZE);
         this.m_fontSize = Math.min(this.m_fontSize,MAX_FONT_SIZE);
         if("characterName" in param1)
         {
            _loc3_ = String(param1.characterName);
         }
         _loc3_ = _loc3_ == null ? "" : StringUtil.trim(_loc3_.replace(/_+/g," "));
         if(_loc3_ == "")
         {
            this.m_characterName_txt.visible = false;
         }
         else
         {
            this.m_characterName_txt.visible = true;
            _loc2_ = _loc2_.replace(/^[-‒–—―⸺⸻] */,"");
         }
         if(_loc2_ == "")
         {
            this.m_view.visible = false;
         }
         else
         {
            this.m_sub_txt.autoSize = TextFieldAutoSize.CENTER;
            this.m_sub_txt.width = this.m_textFieldSetWidth;
            MenuUtils.setupText(this.m_sub_txt,_loc2_,this.m_fontSize);
            if(this.m_characterName_txt.visible)
            {
               this.m_characterName_txt.autoSize = TextFieldAutoSize.LEFT;
               MenuUtils.setupText(this.m_characterName_txt,_loc3_ + ":",this.m_fontSize,"$medium","#ebeb92");
            }
            if(!(param1.icon2DSpeaker is String) || param1.icon2DSpeaker == "")
            {
               this.m_icon2DSpeaker_mc.visible = false;
            }
            else
            {
               this.m_icon2DSpeaker_mc.visible = true;
               this.m_icon2DSpeaker_mc.gotoAndStop(param1.icon2DSpeaker);
            }
            this.m_view.visible = true;
            this.updateSpeakerIndicatorLayout();
            this.updateDarkBack();
            if(!this.m_isAntiFreakoutDisabled)
            {
               this.m_view.alpha = 0;
               Animate.to(this.m_view,0,0.05,{"alpha":1},Animate.Linear);
            }
         }
         if(this.m_alignToBottom)
         {
            this.m_view.y = -this.m_sub_txt.textHeight;
         }
         else
         {
            this.m_view.y = 0;
         }
      }
      
      public function updateViewportLockBits(param1:int) : void
      {
         this.m_arrowL_mc.visible = (param1 & LOCKBIT_Left) != 0;
         this.m_arrowR_mc.visible = (param1 & LOCKBIT_Right) != 0;
         this.updateDarkBack();
      }
      
      private function updateSpeakerIndicatorLayout() : void
      {
         var _loc3_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc1_:Number = this.m_fontSize * 0.75;
         var _loc2_:Number = 0;
         if(this.m_characterName_txt.visible)
         {
            _loc2_ = this.m_characterName_txt.textWidth + _loc1_;
         }
         this.m_sub_txt.x = _loc2_ / 2 * (1 - this.m_icon2DSpeaker_mc.alpha);
         _loc3_ = this.m_sub_txt.x + this.m_sub_txt.width / 2;
         var _loc4_:Number = this.m_sub_txt.y + this.m_sub_txt.height / 2;
         var _loc5_:Number = _loc3_ - this.m_sub_txt.textWidth / 2;
         var _loc6_:Number = _loc3_ + this.m_sub_txt.textWidth / 2;
         var _loc7_:Number = this.m_fontSize / MIN_FONT_SIZE;
         this.m_arrowL_mc.x = _loc5_;
         this.m_arrowL_mc.y = _loc4_;
         this.m_arrowL_mc.scaleX = _loc7_;
         this.m_arrowL_mc.scaleY = _loc7_;
         this.m_arrowR_mc.x = _loc6_;
         this.m_arrowR_mc.y = _loc4_;
         this.m_arrowR_mc.scaleX = _loc7_;
         this.m_arrowR_mc.scaleY = _loc7_;
         if(this.m_icon2DSpeaker_mc.visible)
         {
            this.m_icon2DSpeaker_mc.scaleX = _loc7_;
            this.m_icon2DSpeaker_mc.scaleY = _loc7_;
            _loc8_ = 35 * _loc7_;
            this.m_icon2DSpeaker_mc.x = _loc5_ - _loc8_ - this.m_sub_txt.x;
            this.m_icon2DSpeaker_mc.y = _loc4_;
         }
         if(this.m_characterName_txt.visible)
         {
            this.m_characterName_txt.x = _loc3_ - this.m_sub_txt.getLineMetrics(0).width / 2 - _loc2_;
            this.m_characterName_txt.y = this.m_sub_txt.y;
         }
      }
      
      private function updateDarkBack() : void
      {
         var _loc10_:Number = NaN;
         if(this.m_view == null)
         {
            return;
         }
         if(this.m_fBGAlpha == 0)
         {
            this.m_view.box_mc.visible = false;
            return;
         }
         var _loc1_:Number = 50;
         var _loc2_:Number = 15;
         var _loc3_:Number = 45;
         var _loc4_:Number = 50;
         var _loc5_:Number = this.m_fontSize * 0.75;
         var _loc6_:Number = this.m_fCinematicMode * (!this.m_characterName_txt.visible ? 0 : this.m_characterName_txt.textWidth + _loc5_);
         var _loc7_:Number = this.m_fCinematicMode == 1 ? 0 : (!this.m_icon2DSpeaker_mc.visible ? 0 : _loc3_ * this.m_icon2DSpeaker_mc.scaleX);
         var _loc8_:Number = this.m_arrowL_mc.alpha * (!this.m_arrowL_mc.visible ? 0 : _loc4_ * this.m_arrowL_mc.scaleX);
         var _loc9_:Number = this.m_arrowR_mc.alpha * (!this.m_arrowR_mc.visible ? 0 : _loc4_ * this.m_arrowR_mc.scaleX);
         var _loc11_:Number = (_loc10_ = this.m_sub_txt.x + this.m_sub_txt.width / 2) - this.m_sub_txt.textWidth / 2;
         this.m_view.box_mc.visible = true;
         this.m_view.box_mc.alpha = this.m_fBGAlpha;
         this.m_view.box_mc.width = this.m_sub_txt.textWidth + Math.max(_loc6_,_loc7_) + _loc8_ + _loc9_ + _loc1_;
         this.m_view.box_mc.height = this.m_sub_txt.textHeight + _loc2_;
         this.m_view.box_mc.x = _loc11_ - Math.max(_loc6_,_loc7_) - _loc8_ - _loc1_ / 2;
         this.m_view.box_mc.y = -(_loc2_ - 5) / 2;
      }
   }
}
