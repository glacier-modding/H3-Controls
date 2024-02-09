package menu3.splashhints
{
   import basic.ButtonPromtUtil;
   import basic.IButtonPromptOwner;
   import common.Animate;
   import common.BaseControl;
   import common.CommonUtils;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.external.ExternalInterface;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class SplashHintContent extends BaseControl implements ISplashHint, IButtonPromptOwner
   {
      
      private static const CONTROLLER_BUTTON_INDEX_START:int = 1;
      
      private static const CONTROLLER_BUTTON_INDEX_END:int = 20;
      
      private static const KEYBOARD_MOUSE_BUTTON_INDEX_START:int = 50;
      
      private static const KEYBOARD_MOUSE_BUTTON_INDEX_END:int = 66;
      
      private static const POSTFIX_XBOX:String = "";
      
      private static const POSTFIX_PS4:String = "ps";
      
      private static const POSTFIX_KEY:String = "key";
      
      private static const POSTFIX_PS5:String = "ps5";
      
      private static const POSTFIX_NS:String = "nsp";
      
      private static const POSTFIX_OCULUSVR:String = "oculusvr";
      
      private static const POSTFIX_OPENVR:String = "openvr";
       
      
      private var m_animationDelayIn:Number;
      
      private var m_animationDelayOut:Number;
      
      private var m_isMissionTitle:Boolean;
      
      private var m_data:Object;
      
      private var m_header:String;
      
      private var m_title:String;
      
      private var m_description:String;
      
      private var m_imageRID:String;
      
      private var m_hintType:int;
      
      private var m_iconID:String;
      
      private var m_container:Sprite;
      
      private var m_imageContainer:Sprite;
      
      private var m_view:MovieClip;
      
      private var m_imageMc:SplashHintImage;
      
      private var m_promptContainer:Sprite;
      
      private var m_iconMc:MovieClip;
      
      private var m_lineMc:Sprite;
      
      private var m_headerTf:TextField;
      
      private var m_titleTf:TextField;
      
      private var m_descriptionTf:TextField;
      
      private var m_controllerMc:MovieClip;
      
      private var m_highlightEffects:Array;
      
      private var iconProps:Object;
      
      private var headerProps:Object;
      
      private var titleProps:Object;
      
      private var m_firstTimeFlag:Boolean = true;
      
      private var m_sizeX:Number;
      
      private var m_sizeY:Number;
      
      private var m_safeAreaRatio:Number = 1;
      
      private var m_previousButtonPromptsData:Object = null;
      
      public function SplashHintContent()
      {
         this.m_highlightEffects = [];
         this.iconProps = {};
         this.headerProps = {};
         this.titleProps = {};
         this.m_sizeX = MenuConstants.BaseWidth;
         this.m_sizeY = MenuConstants.BaseHeight;
         super();
         this.m_imageContainer = new Sprite();
         addChild(this.m_imageContainer);
         this.m_container = new Sprite();
         addChild(this.m_container);
      }
      
      public function set AnimationDelayIn(param1:Number) : void
      {
         this.m_animationDelayIn = param1;
      }
      
      public function set AnimationDelayOut(param1:Number) : void
      {
         this.m_animationDelayOut = param1;
      }
      
      public function set isMissionTitle(param1:Boolean) : void
      {
         this.m_isMissionTitle = param1;
      }
      
      public function onSetData(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         this.m_data = param1;
         this.m_header = param1.header as String;
         this.m_title = param1.title as String;
         this.m_description = param1.description as String;
         this.m_imageRID = param1.imageRID as String;
         this.m_hintType = param1.hinttype as int;
         this.m_iconID = param1.iconID as String;
         if(this.m_view == null)
         {
            this.initView();
         }
         if(this.m_controllerMc != null)
         {
            _loc2_ = this.getButtonIdFromText(this.m_description);
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               _loc3_++;
            }
            this.setControllerButtons(_loc2_);
         }
         this.updateView();
         this.setPrompts();
      }
      
      private function initView() : void
      {
         var DX:Number = NaN;
         if(this.m_hintType == MenuConstants.SPLASH_HINT_TYPE_CONTROLLER)
         {
            this.m_view = new SplashHintControlHintView();
            this.m_controllerMc = this.m_view.controller;
            this.m_controllerMc.visible = false;
            this.m_controllerMc.alpha = 0;
         }
         else
         {
            this.m_view = new SplashHintGlobalHintView();
            this.m_iconMc = this.m_view.icon;
            this.m_headerTf = this.m_view.header;
         }
         this.m_lineMc = this.m_view.line;
         this.m_titleTf = this.m_view.title;
         this.m_descriptionTf = this.m_view.description;
         this.m_imageContainer.alpha = 0;
         this.m_view.alpha = 0;
         this.m_view.x = 0;
         if(ControlsMain.isVrModeActive() && this.m_hintType == MenuConstants.SPLASH_HINT_TYPE_CONTROLLER)
         {
            this.m_view.y = MenuConstants.UserLineUpperYPos - MenuConstants.MenuHeight;
            DX = 250;
            if(this.m_view.controller != null)
            {
               this.m_view.controller.x -= DX;
            }
            if(this.m_view.line != null)
            {
               this.m_view.line.x += DX;
            }
            if(this.m_view.title != null)
            {
               this.m_view.title.x += DX;
            }
            if(this.m_view.description != null)
            {
               this.m_view.description.x += DX;
               this.m_view.description.width = 600;
            }
         }
         else
         {
            this.m_view.y = MenuConstants.UserLineUpperYPos - 252;
         }
         if(this.m_imageRID != "")
         {
            this.m_imageMc = new SplashHintImage();
            this.m_imageContainer.addChild(this.m_imageMc);
            this.m_imageMc.loadImage(this.m_imageRID,function():void
            {
               m_imageMc.x = MenuConstants.BaseWidth - m_imageMc.width;
               m_imageMc.y = -(m_imageMc.height - MenuConstants.BaseHeight);
            });
         }
         this.m_container.addChild(this.m_view);
         this.m_promptContainer = new Sprite();
         this.m_promptContainer.x = MenuConstants.menuXOffset + 96;
         this.m_promptContainer.y = MenuConstants.ButtonPromptsYPos;
         this.m_container.addChild(this.m_promptContainer);
         if(this.m_iconMc != null)
         {
            this.iconProps = {
               "xpos":this.m_iconMc.x,
               "ypos":this.m_iconMc.y,
               "scale":this.m_iconMc.scaleX
            };
         }
         if(this.m_headerTf != null)
         {
            this.headerProps = {
               "xpos":this.m_headerTf.x,
               "ypos":this.m_headerTf.y,
               "scale":this.m_headerTf.scaleX
            };
         }
         if(this.m_titleTf != null)
         {
            this.titleProps = {
               "xpos":this.m_titleTf.x,
               "ypos":this.m_titleTf.y,
               "scale":this.m_titleTf.scaleX
            };
         }
         if(this.m_descriptionTf != null)
         {
            this.m_descriptionTf.autoSize = TextFieldAutoSize.LEFT;
         }
      }
      
      private function updateView() : void
      {
         var _loc1_:Number = NaN;
         if(this.m_hintType == MenuConstants.SPLASH_HINT_TYPE_CONTROLLER)
         {
            _loc1_ = ControlsMain.getDisplaySize() == ControlsMain.DISPLAY_SIZE_SMALL ? 1.2 : 1;
            this.m_descriptionTf.scaleX = _loc1_;
            this.m_descriptionTf.scaleY = _loc1_;
         }
         else
         {
            this.m_descriptionTf.scaleX = 1;
            this.m_descriptionTf.scaleY = 1;
         }
         if(this.m_iconMc != null)
         {
            this.m_iconMc.icons.gotoAndStop(this.m_iconID);
            MenuUtils.setColor(this.m_iconMc.icons,MenuConstants.COLOR_WHITE);
         }
         if(this.m_headerTf != null)
         {
            MenuUtils.setupText(this.m_headerTf,this.m_header,24,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorGrey);
         }
         MenuUtils.setupTextAndShrinkToFit(this.m_titleTf,this.m_title,60,MenuConstants.FONT_TYPE_BOLD,this.m_lineMc.width,0,9,MenuConstants.FontColorWhite);
         MenuUtils.setupText(this.m_descriptionTf,this.m_description,24,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
      }
      
      private function setControllerButtons(param1:Array) : void
      {
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:* = false;
         var _loc11_:* = false;
         var _loc12_:* = false;
         var _loc13_:* = false;
         var _loc14_:* = false;
         var _loc15_:* = false;
         var _loc16_:Boolean = false;
         var _loc17_:String = null;
         var _loc18_:* = false;
         var _loc19_:int = 0;
         var _loc20_:String = null;
         if(this.m_controllerMc == null)
         {
            return;
         }
         if(CommonUtils.getPlatformString() == CommonUtils.PLATFORM_STADIA)
         {
            return;
         }
         var _loc2_:String = ControlsMain.getControllerType();
         if(param1.length != 0)
         {
            _loc8_ = 0;
            while(_loc8_ < param1.length)
            {
               _loc10_ = (_loc9_ = String(param1[_loc8_])).indexOf(POSTFIX_PS4) >= 0;
               _loc11_ = _loc9_.indexOf(POSTFIX_KEY) >= 0;
               _loc12_ = _loc9_.indexOf(POSTFIX_PS5) >= 0;
               _loc13_ = _loc9_.indexOf(POSTFIX_NS) >= 0;
               _loc14_ = _loc9_.indexOf(POSTFIX_OCULUSVR) >= 0;
               _loc15_ = _loc9_.indexOf(POSTFIX_OPENVR) >= 0;
               _loc16_ = false;
               if(_loc2_ == CommonUtils.CONTROLLER_TYPE_PS4)
               {
                  _loc16_ = _loc10_;
               }
               else if(_loc2_ == CommonUtils.CONTROLLER_TYPE_KEY)
               {
                  _loc16_ = _loc11_;
               }
               else if(_loc2_ == CommonUtils.CONTROLLER_TYPE_PS5)
               {
                  _loc16_ = _loc12_;
               }
               else if(_loc2_ == CommonUtils.CONTROLLER_TYPE_SWITCHPRO || _loc2_ == CommonUtils.CONTROLLER_TYPE_SWITCHJOYCON)
               {
                  _loc16_ = _loc13_;
               }
               else if(_loc2_ == CommonUtils.CONTROLLER_TYPE_OCULUSVR)
               {
                  _loc16_ = _loc14_;
               }
               else if(_loc2_ == CommonUtils.CONTROLLER_TYPE_OPENVR)
               {
                  _loc16_ = _loc15_;
               }
               else
               {
                  _loc16_ = !_loc11_ && !_loc10_ && !_loc12_ && !_loc13_ && !_loc14_ && !_loc15_;
               }
               if(!_loc16_)
               {
                  param1.splice(_loc8_,1);
                  _loc8_--;
               }
               _loc8_++;
            }
         }
         if(param1.length == 0)
         {
            this.m_controllerMc.visible = false;
            return;
         }
         this.m_controllerMc.visible = true;
         this.m_controllerMc.gotoAndStop(_loc2_);
         this.stopButtonEffects(true);
         var _loc3_:String = "BTN";
         var _loc4_:String = this.getInputPostFix(_loc2_);
         var _loc5_:int = this.getInputButtonStartIndex(_loc2_);
         var _loc6_:int = this.getInputButtonEndIndex(_loc2_);
         var _loc7_:int = _loc5_;
         while(_loc7_ <= _loc6_)
         {
            _loc17_ = _loc3_ + _loc7_.toString() + _loc4_;
            _loc18_ = false;
            _loc19_ = 0;
            while(_loc19_ < param1.length && !_loc18_)
            {
               _loc18_ = (_loc20_ = String(param1[_loc19_])).toUpperCase() == _loc17_.toUpperCase();
               _loc19_++;
            }
            if(this.m_controllerMc.buttons[_loc17_] != null)
            {
               this.m_controllerMc.buttons[_loc17_].visible = _loc18_;
               if(_loc18_)
               {
                  if(ControlsMain.isVrModeActive())
                  {
                     MenuUtils.removeFilters(this.m_controllerMc.buttons[_loc17_]);
                  }
                  this.addButtonEffect(_loc17_);
               }
            }
            _loc7_++;
         }
         if(!this.m_firstTimeFlag)
         {
            this.showController(0);
         }
      }
      
      private function getInputPostFix(param1:String) : String
      {
         if(param1 == CommonUtils.CONTROLLER_TYPE_PC || param1 == CommonUtils.CONTROLLER_TYPE_XBOXONE || param1 == CommonUtils.CONTROLLER_TYPE_XBOXSERIESX)
         {
            return POSTFIX_XBOX;
         }
         if(param1 == CommonUtils.CONTROLLER_TYPE_SWITCHPRO || param1 == CommonUtils.CONTROLLER_TYPE_SWITCHJOYCON)
         {
            return POSTFIX_NS;
         }
         if(param1 == CommonUtils.CONTROLLER_TYPE_OCULUSVR)
         {
            return POSTFIX_OCULUSVR;
         }
         if(param1 == CommonUtils.CONTROLLER_TYPE_OPENVR)
         {
            return POSTFIX_OPENVR;
         }
         if(param1 == CommonUtils.CONTROLLER_TYPE_PS4)
         {
            return POSTFIX_PS4;
         }
         if(param1 == CommonUtils.CONTROLLER_TYPE_PS5)
         {
            return POSTFIX_PS5;
         }
         if(param1 == CommonUtils.CONTROLLER_TYPE_KEY)
         {
            return POSTFIX_KEY;
         }
         return "";
      }
      
      private function getInputButtonStartIndex(param1:String) : int
      {
         if(param1 == CommonUtils.CONTROLLER_TYPE_KEY)
         {
            return KEYBOARD_MOUSE_BUTTON_INDEX_START;
         }
         return CONTROLLER_BUTTON_INDEX_START;
      }
      
      private function getInputButtonEndIndex(param1:String) : int
      {
         if(param1 == CommonUtils.CONTROLLER_TYPE_KEY)
         {
            return KEYBOARD_MOUSE_BUTTON_INDEX_END;
         }
         return CONTROLLER_BUTTON_INDEX_END;
      }
      
      private function setPrompts() : void
      {
         this.m_previousButtonPromptsData = MenuUtils.parsePrompts(this.m_data,this.m_previousButtonPromptsData,this.m_promptContainer,false,this.handlePromptMouseEvent);
      }
      
      private function handlePromptMouseEvent(param1:String) : void
      {
         ButtonPromtUtil.handlePromptMouseEvent(sendEventWithValue,param1);
      }
      
      public function updateButtonPrompts() : void
      {
         this.setPrompts();
      }
      
      public function show() : void
      {
         this.stopButtonEffects();
         this.clearAnimations();
         this.m_view.alpha = 1;
         this.m_imageContainer.alpha = 1;
         if(this.m_isMissionTitle)
         {
            this.playSound("play_ui_mission_title_appear");
         }
         if(this.m_iconMc != null)
         {
            this.m_iconMc.alpha = 0;
            this.m_iconMc.frame.visible = true;
            this.m_iconMc.bg.visible = false;
            MenuUtils.setColor(this.m_iconMc.frame,MenuConstants.COLOR_WHITE);
            Animate.fromTo(this.m_iconMc,0.2,this.m_animationDelayIn,{"alpha":0},{"alpha":1},Animate.ExpoOut);
            Animate.addFromTo(this.m_iconMc,0.4,this.m_animationDelayIn,{
               "scaleX":0.4,
               "scaleY":0.4
            },{
               "scaleX":1,
               "scaleY":1
            },Animate.ExpoOut);
         }
         if(this.m_headerTf != null)
         {
            this.m_headerTf.alpha = 0;
            Animate.fromTo(this.m_headerTf,0.2,this.m_animationDelayIn + 0.1,{"alpha":0},{"alpha":1},Animate.ExpoOut);
            Animate.addFromTo(this.m_headerTf,0.3,this.m_animationDelayIn + 0.1,{"x":this.headerProps.xpos - 10},{"x":this.headerProps.xpos},Animate.ExpoOut);
         }
         if(this.m_titleTf != null)
         {
            this.m_titleTf.alpha = 0;
            Animate.fromTo(this.m_titleTf,0.2,this.m_animationDelayIn + 0.2,{"alpha":0},{"alpha":1},Animate.ExpoOut);
            Animate.addFromTo(this.m_titleTf,0.3,this.m_animationDelayIn + 0.2,{"x":this.titleProps.xpos - 10},{"x":this.titleProps.xpos},Animate.ExpoOut);
         }
         if(this.m_lineMc != null)
         {
            this.m_lineMc.scaleX = 0;
            Animate.fromTo(this.m_lineMc,0.3,this.m_animationDelayIn + 0.3,{"scaleX":0},{"scaleX":1},Animate.ExpoOut);
         }
         if(this.m_descriptionTf != null)
         {
            this.m_descriptionTf.alpha = 0;
            Animate.fromTo(this.m_descriptionTf,0.3,this.m_animationDelayIn + 0.4,{"alpha":0},{"alpha":1},Animate.ExpoOut);
         }
         if(this.m_hintType == MenuConstants.SPLASH_HINT_TYPE_CONTROLLER)
         {
            this.showController(this.m_animationDelayIn + 0.4);
         }
         else if(this.m_imageMc != null)
         {
            Animate.delay(this.m_imageMc,this.m_animationDelayIn + 0.4,this.m_imageMc.show);
         }
         this.m_firstTimeFlag = false;
      }
      
      public function hide() : void
      {
         this.stopButtonEffects(true);
         this.clearAnimations();
         if(this.m_isMissionTitle)
         {
            this.playSound("play_ui_mission_title_disappear");
         }
         this.m_imageContainer.alpha = 0;
         if(this.m_view != null)
         {
            this.m_view.alpha = 0;
         }
      }
      
      public function playSound(param1:String) : void
      {
         ExternalInterface.call("PlaySound",param1);
      }
      
      private function showController(param1:Number) : void
      {
         Animate.fromTo(this.m_controllerMc,0.2,param1,{"alpha":0},{"alpha":1},Animate.ExpoOut);
         Animate.addFrom(this.m_controllerMc,0.4,param1,{"x":this.m_controllerMc.x + 25},Animate.ExpoOut);
         this.startButtonEffects(param1);
      }
      
      private function addButtonEffect(param1:String) : void
      {
         var _loc2_:MovieClip = new FxClipMc();
         _loc2_.alpha = 0;
         _loc2_.x = this.m_controllerMc.buttons[param1].x;
         _loc2_.y = this.m_controllerMc.buttons[param1].y;
         this.m_controllerMc.buttons.addChild(_loc2_);
         this.m_highlightEffects.push(_loc2_);
      }
      
      private function startButtonEffects(param1:Number) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.m_highlightEffects.length)
         {
            this.pulsate(this.m_highlightEffects[_loc2_],param1);
            _loc2_++;
         }
      }
      
      private function stopButtonEffects(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.m_highlightEffects.length)
         {
            Animate.kill(this.m_highlightEffects[_loc2_]);
            if(param1)
            {
               this.m_controllerMc.buttons.removeChild(this.m_highlightEffects[_loc2_]);
            }
            _loc2_++;
         }
         if(param1)
         {
            this.m_highlightEffects = [];
         }
      }
      
      private function pulsate(param1:MovieClip, param2:Number) : void
      {
         if(param1 == null)
         {
            return;
         }
         param1.alpha = 1;
         if(param1.mc1 != null)
         {
            param1.mc1.alpha = 0;
            Animate.fromTo(param1.mc1,1.4,param2,{
               "alpha":1,
               "scaleX":1,
               "scaleY":1
            },{
               "alpha":0,
               "scaleX":4.5,
               "scaleY":4.5
            },Animate.ExpoOut);
         }
         if(param1.mc2 != null)
         {
            param1.mc2.alpha = 0;
            Animate.fromTo(param1.mc2,1.4,param2 + 0.25,{
               "alpha":1,
               "scaleX":1,
               "scaleY":1
            },{
               "alpha":0,
               "scaleX":4.5,
               "scaleY":4.5
            },Animate.ExpoOut,this.pulsateComplete,param1);
         }
      }
      
      private function pulsateComplete(param1:MovieClip) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param1.mc1 != null)
         {
            param1.mc1.scaleX = 1;
            param1.mc1.scaleY = 1;
         }
         if(param1.mc2 != null)
         {
            param1.mc2.scaleX = 1;
            param1.mc2.scaleY = 1;
         }
         Animate.delay(param1,0.5,this.pulsate,param1,0);
      }
      
      private function clearAnimations() : void
      {
         if(this.m_iconMc != null)
         {
            Animate.complete(this.m_iconMc);
         }
         if(this.m_headerTf != null)
         {
            Animate.complete(this.m_headerTf);
         }
         Animate.complete(this.m_titleTf);
         Animate.complete(this.m_lineMc);
         Animate.complete(this.m_descriptionTf);
         if(this.m_imageMc != null)
         {
            Animate.complete(this.m_imageMc);
         }
         Animate.complete(this.m_controllerMc);
         Animate.complete(this.m_view);
      }
      
      private function getButtonIdFromText(param1:String) : Array
      {
         if(param1 == null)
         {
            return [];
         }
         return param1.match(/btn\d+\w*/gi);
      }
      
      override public function getContainer() : Sprite
      {
         return this.m_view;
      }
      
      override public function onSetSize(param1:Number, param2:Number) : void
      {
         super.onSetSize(param1,param2);
         this.m_sizeX = param1;
         this.m_sizeY = param2;
         this.scaleBackground(this.m_sizeX,this.m_sizeY,this.m_safeAreaRatio);
      }
      
      override public function onSetViewport(param1:Number, param2:Number, param3:Number) : void
      {
         super.onSetViewport(param1,param2,param3);
         this.m_safeAreaRatio = param3;
         this.scaleBackground(this.m_sizeX,this.m_sizeY,this.m_safeAreaRatio);
      }
      
      private function scaleBackground(param1:Number, param2:Number, param3:Number) : void
      {
         var _loc4_:Number;
         var _loc5_:Number = (_loc4_ = Math.min(param1 / MenuConstants.BaseWidth,param2 / MenuConstants.BaseHeight)) * param3;
         var _loc6_:Number = (param1 - _loc5_ * MenuConstants.BaseWidth) / 2;
         var _loc7_:Number = param2 - _loc5_ * MenuConstants.BaseHeight;
         var _loc8_:Number = MenuConstants.BaseHeight * (1 - param3) / 2;
         this.m_container.scaleX = _loc5_;
         this.m_container.x = _loc6_;
         this.m_container.scaleY = _loc5_;
         this.m_container.y = _loc7_ - _loc8_;
         var _loc9_:Number = (param1 - _loc4_ * MenuConstants.BaseWidth) / 2;
         var _loc10_:Number = param2 - _loc4_ * MenuConstants.BaseHeight;
         this.m_imageContainer.scaleX = _loc4_;
         this.m_imageContainer.x = _loc9_;
         this.m_imageContainer.scaleY = _loc4_;
         this.m_imageContainer.y = _loc10_;
      }
   }
}
