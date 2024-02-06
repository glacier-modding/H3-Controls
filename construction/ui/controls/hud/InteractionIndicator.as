package hud
{
   import basic.ButtonPromptImage;
   import common.BaseControl;
   import common.CommonUtils;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.text.TextFieldAutoSize;
   import mx.utils.StringUtil;
   
   public class InteractionIndicator extends BaseControl
   {
      
      public static const STATE_AVAILABLE:int = 0;
      
      public static const STATE_COLLAPSED:int = 1;
      
      public static const STATE_ACTIVATING:int = 2;
      
      public static const STATE_NOTAVAILABLE:int = 3;
      
      public static const TYPE_UNKNOWN:int = 0;
      
      public static const TYPE_PRESS:int = 1;
      
      public static const TYPE_HOLD:int = 2;
      
      public static const TYPE_HOLD_DOWN:int = 3;
      
      public static const TYPE_REPEAT:int = 4;
      
      public static const TYPE_GUIDE:int = 5;
       
      
      private var m_view:InteractionIndicatorView;
      
      private var m_promptImage:ButtonPromptImage;
      
      private var m_currentProgress:Number;
      
      private var m_nFontSizeCurrent:int;
      
      private var m_sLabelCurrent:String = "";
      
      private var m_sDescriptionCurrent:String = "";
      
      private var m_holdAnimFrameOffset:int;
      
      private var m_viewportScale:Number = 1;
      
      public function InteractionIndicator()
      {
         super();
         this.m_view = new InteractionIndicatorView();
         addChild(this.m_view);
         this.m_promptImage = new ButtonPromptImage();
         this.m_view.promptHolder_mc.addChild(this.m_promptImage);
         this.m_nFontSizeCurrent = ControlsMain.getDisplaySize() == ControlsMain.DISPLAY_SIZE_SMALL ? MenuConstants.INTERACTIONPROMPTSIZE_FORCEDONSMALLDISPLAY : int(CommonUtils.getUIOptionValueNumber("UI_OPTION_GAME_AID_INTERACTION_PROMPT"));
         this.setupTextFields();
      }
      
      private function setupTextFields() : void
      {
         var _loc1_:Object = MenuConstants.InteractionIndicatorFontSpecs[this.m_nFontSizeCurrent];
         MenuUtils.setupText(this.m_view.prompt_mc.label_txt,this.m_sLabelCurrent,_loc1_.fontSizeLabel,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
         MenuUtils.setupText(this.m_view.prompt_mc.desc_txt,this.m_sDescriptionCurrent,_loc1_.fontSizeDesc,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
      }
      
      public function onSetData(param1:Object) : void
      {
         var _loc2_:int = !!param1.m_nFontSize ? int(param1.m_nFontSize) : 0;
         if(_loc2_ != this.m_nFontSizeCurrent)
         {
            this.m_nFontSizeCurrent = _loc2_;
            this.setupTextFields();
         }
         this.updateScale();
         if(param1.m_eState == STATE_AVAILABLE)
         {
            this.m_promptImage.alpha = !!param1.m_bNoActionAvailable ? 0.33 : 1;
            this.m_holdAnimFrameOffset = Boolean(param1.m_bIllegal) || Boolean(param1.m_bIllegalItem) || Boolean(param1.m_bSuspiciousItem) ? 81 : 1;
            this.m_view.prompt_mc.x = !!param1.m_bIsTxtDirReversed ? -28 : 28;
            if(param1.m_eTypeId == TYPE_HOLD || param1.m_eTypeId == TYPE_HOLD_DOWN)
            {
               this.m_view.tap_mc.visible = false;
               this.m_view.hold_mc.visible = true;
               this.m_view.hold_mc.gotoAndStop(this.m_holdAnimFrameOffset);
            }
            else if(param1.m_eTypeId == TYPE_REPEAT)
            {
               this.m_view.hold_mc.visible = false;
               this.m_view.tap_mc.visible = true;
               this.m_view.tap_mc.play();
            }
            else
            {
               this.m_view.tap_mc.visible = false;
               this.m_view.hold_mc.visible = false;
            }
            this.showActionButton(param1.m_nIconId,param1.m_sLabel,param1.m_sDescription,param1.m_sGlyph,param1.m_bIllegalItem,param1.m_bIllegal,param1.m_bSuspiciousItem,param1.m_bIsTxtDirReversed);
            this.m_view.collapsedEmpty_mc.alpha = 0;
            this.m_view.collapsedFull_mc.alpha = 0;
            this.m_promptImage.visible = true;
            this.m_view.prompt_mc.visible = true;
            if(ControlsMain.isVrModeActive())
            {
               this.m_view.alpha = 0.6;
            }
         }
         else if(param1.m_eState == STATE_COLLAPSED || param1.m_eState == STATE_NOTAVAILABLE)
         {
            this.m_promptImage.visible = false;
            this.m_view.prompt_mc.visible = false;
            this.m_view.tap_mc.visible = false;
            this.m_view.hold_mc.visible = false;
            this.m_view.illegalIcon_mc.visible = false;
            if(param1.m_bInRange)
            {
               this.m_view.collapsedFull_mc.alpha = 0.75;
               this.m_view.collapsedEmpty_mc.alpha = 0;
            }
            else if(param1.m_bContainsItem)
            {
               this.m_view.collapsedFull_mc.alpha = 0.4;
               this.m_view.collapsedEmpty_mc.alpha = 0;
            }
            else
            {
               this.m_view.collapsedFull_mc.alpha = 0;
               this.m_view.collapsedEmpty_mc.alpha = 0.4;
            }
            if(ControlsMain.isVrModeActive())
            {
               this.m_view.alpha = 1;
            }
         }
         else if(param1.m_eState == STATE_ACTIVATING)
         {
            this.showActionButton(param1.m_nIconId,param1.m_sLabel,param1.m_sDescription,param1.m_sGlyph,param1.m_bIllegalItem,param1.m_bIllegal,param1.m_bSuspiciousItem,param1.m_bIsTxtDirReversed);
            this.m_view.collapsedEmpty_mc.alpha = 0;
            this.m_view.collapsedFull_mc.alpha = 0;
            this.m_view.tap_mc.visible = false;
            this.m_promptImage.visible = true;
            this.m_view.prompt_mc.visible = true;
            if(param1.m_fProgress > 0)
            {
               this.m_view.hold_mc.visible = true;
               if(this.m_currentProgress != param1.m_fProgress)
               {
                  this.m_view.hold_mc.gotoAndStop(Math.ceil(param1.m_fProgress * 60) + this.m_holdAnimFrameOffset);
                  this.m_currentProgress = param1.m_fProgress;
               }
            }
            else
            {
               this.m_view.hold_mc.visible = false;
            }
            if(ControlsMain.isVrModeActive())
            {
               this.m_view.alpha = 0.6;
            }
         }
      }
      
      public function setScaleFactor3D(param1:Number) : void
      {
         this.m_view.collapsedEmpty_mc.scaleX = this.m_view.collapsedEmpty_mc.scaleY = param1;
         this.m_view.collapsedFull_mc.scaleX = this.m_view.collapsedFull_mc.scaleY = param1;
      }
      
      private function showActionButton(param1:int, param2:String, param3:String, param4:String, param5:Boolean, param6:Boolean, param7:Boolean, param8:Boolean) : void
      {
         var _loc12_:Number = NaN;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:String = null;
         if(param7 || param6 || param5)
         {
            _loc12_ = 0.46;
            _loc13_ = 58;
            _loc14_ = this.m_view.hold_mc.visible ? 39 : 35;
            if(this.m_nFontSizeCurrent == MenuConstants.INTERACTIONPROMPTSIZE_MEDIUM)
            {
               _loc12_ = 0.52;
               _loc13_ = 60;
               _loc14_ = this.m_view.hold_mc.visible ? 40 : 36;
            }
            else if(this.m_nFontSizeCurrent >= MenuConstants.INTERACTIONPROMPTSIZE_LARGE)
            {
               _loc12_ = 0.65;
               _loc13_ = 67;
               _loc14_ = this.m_view.hold_mc.visible ? 44 : 40;
            }
            this.m_view.illegalIcon_mc.scaleX = this.m_view.illegalIcon_mc.scaleY = _loc12_;
            this.m_view.prompt_mc.x = param8 ? -_loc13_ : _loc13_;
            this.m_view.illegalIcon_mc.x = param8 ? -_loc14_ : _loc14_;
         }
         this.m_view.prompt_mc.label_txt.autoSize = param8 ? TextFieldAutoSize.LEFT : TextFieldAutoSize.RIGHT;
         this.m_view.prompt_mc.desc_txt.autoSize = param8 ? TextFieldAutoSize.LEFT : TextFieldAutoSize.RIGHT;
         this.m_promptImage.platform = ControlsMain.getControllerType();
         this.m_view.promptHolder_mc.scaleX = this.m_view.promptHolder_mc.scaleY = this.m_promptImage.platform == "key" ? 0.8 : 1;
         if(param1 != -1)
         {
            this.m_promptImage.button = param1;
         }
         else
         {
            this.m_promptImage.customKey = param4;
         }
         var _loc9_:String;
         if((_loc9_ = param2.toUpperCase()) != this.m_sLabelCurrent)
         {
            this.m_view.prompt_mc.label_txt.htmlText = _loc9_;
            this.m_sLabelCurrent = _loc9_;
         }
         param3 = StringUtil.trim(param3);
         var _loc10_:Object = MenuConstants.InteractionIndicatorFontSpecs[this.m_nFontSizeCurrent];
         if(Boolean(param3) && param3.length > 0)
         {
            this.m_view.prompt_mc.desc_txt.visible = true;
            if((_loc15_ = param3.toUpperCase()) != this.m_sDescriptionCurrent)
            {
               this.m_view.prompt_mc.desc_txt.htmlText = _loc15_;
               this.m_sDescriptionCurrent = _loc15_;
            }
            this.m_view.prompt_mc.label_txt.y = _loc10_.yOffsetLabel;
            this.m_view.prompt_mc.desc_txt.y = _loc10_.yOffsetDesc;
         }
         else
         {
            this.m_view.prompt_mc.desc_txt.visible = false;
            this.m_view.prompt_mc.desc_txt.text = "";
            this.m_sDescriptionCurrent = "";
            this.m_view.prompt_mc.label_txt.y = _loc10_.yOffsetLabelSolo;
         }
         if(param2 == "")
         {
            this.m_view.illegalIcon_mc.visible = false;
         }
         else if(param7)
         {
            this.m_view.illegalIcon_mc.visible = true;
            this.m_view.illegalIcon_mc.gotoAndStop("susarmed");
         }
         else if(param6 || param5)
         {
            this.m_view.illegalIcon_mc.visible = true;
            this.m_view.illegalIcon_mc.gotoAndStop("visarmed");
         }
         else
         {
            this.m_view.illegalIcon_mc.visible = false;
         }
         var _loc11_:int = this.m_view.hold_mc.visible ? -3 : -7;
         if(param8)
         {
            this.m_view.prompt_mc.label_txt.x = -_loc11_ - this.m_view.prompt_mc.label_txt.width;
            this.m_view.prompt_mc.desc_txt.x = -_loc11_ - this.m_view.prompt_mc.desc_txt.width;
         }
         else
         {
            this.m_view.prompt_mc.label_txt.x = _loc11_;
            this.m_view.prompt_mc.desc_txt.x = _loc11_;
         }
      }
      
      override public function onSetViewport(param1:Number, param2:Number, param3:Number) : void
      {
         this.m_viewportScale = Math.min(param1,param2);
         this.updateScale();
      }
      
      private function updateScale() : void
      {
         var _loc1_:Boolean = !ControlsMain.isVrModeActive() && ControlsMain.getDisplaySize() == ControlsMain.DISPLAY_SIZE_SMALL;
         var _loc2_:Number = _loc1_ ? 1.25 : 1;
         var _loc3_:Object = MenuConstants.InteractionIndicatorFontSpecs[this.m_nFontSizeCurrent];
         this.m_view.scaleX = this.m_viewportScale * _loc2_ * _loc3_.fScaleGroup * _loc3_.fScaleIndividual;
         this.m_view.scaleY = this.m_viewportScale * _loc2_ * _loc3_.fScaleGroup * _loc3_.fScaleIndividual;
      }
   }
}
