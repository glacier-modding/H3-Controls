package basic
{
   import common.BaseControl;
   import common.CommonUtils;
   import common.Localization;
   import common.ObjectPool;
   import common.menu.MenuUtils;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import scaleform.gfx.DisplayObjectEx;
   
   public class ButtonPromptImage extends BaseControl
   {
      
      private static var s_pool:ObjectPool = new ObjectPool(ButtonPromptImage,20);
      
      private static var s_pcLocalizedKey:Array = new Array({
         "id":39,
         "str":"cancel",
         "locStr":"UI_KEYPROMPT_ESC"
      },{
         "id":41,
         "str":"accept",
         "locStr":"UI_KEYPROMPT_ENTER"
      },{
         "id":42,
         "str":"",
         "locStr":"UI_KEYPROMPT_RALT"
      },{
         "id":43,
         "str":"",
         "locStr":"UI_KEYPROMPT_LALT"
      },{
         "id":44,
         "str":"",
         "locStr":"UI_KEYPROMPT_CAPSLOCK"
      },{
         "id":45,
         "str":"",
         "locStr":"UI_KEYPROMPT_RCTRL"
      },{
         "id":46,
         "str":"",
         "locStr":"UI_KEYPROMPT_LCTRL"
      },{
         "id":47,
         "str":"",
         "locStr":"UI_KEYPROMPT_RSHIFT"
      },{
         "id":48,
         "str":"",
         "locStr":"UI_KEYPROMPT_LSHIFT"
      },{
         "id":60,
         "str":"lb",
         "locStr":"UI_KEYPROMPT_PAGEUP"
      },{
         "id":61,
         "str":"rb",
         "locStr":"UI_KEYPROMPT_PAGEDOWN"
      });
       
      
      private var m_view:ButtonPromptView;
      
      private var m_platform:String;
      
      public function ButtonPromptImage()
      {
         super();
         this.m_view = new ButtonPromptView();
         this.platform = ControlsMain.getControllerType();
         addChild(this.m_view);
      }
      
      public static function AcquireInstance() : ButtonPromptImage
      {
         var _loc1_:ButtonPromptImage = s_pool.acquireObject();
         DisplayObjectEx.skipNextMatrixLerp(_loc1_);
         return _loc1_;
      }
      
      public static function ReleaseInstance(param1:ButtonPromptImage) : void
      {
         s_pool.releaseObject(param1);
      }
      
      public function getWidth() : Number
      {
         return this.m_view.button_mc.width;
      }
      
      public function set platform(param1:String) : void
      {
         if(this.m_platform != param1)
         {
            this.m_platform = param1;
            CommonUtils.gotoFrameLabelAndStop(this.m_view,param1);
         }
      }
      
      public function get platform() : String
      {
         return this.m_platform;
      }
      
      public function set button(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         this.m_view.button_mc.gotoAndStop(param1);
         if(this.m_platform == "key")
         {
            _loc2_ = 0;
            while(_loc2_ < s_pcLocalizedKey.length)
            {
               if(s_pcLocalizedKey[_loc2_].id == param1)
               {
                  this.localizeKey(s_pcLocalizedKey[_loc2_].locStr);
                  break;
               }
               _loc2_++;
            }
         }
         this.applyOpenVROffset();
      }
      
      public function set action(param1:String) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         if(this.platform == "pc")
         {
            if(param1 == "select" || param1 == "back")
            {
               _loc2_ = CommonUtils.isWindowsXBox360ControllerUsed();
               if(_loc2_)
               {
                  param1 += "_xbox360";
               }
            }
         }
         if(this.platform == "ps4")
         {
            if(param1 == "select")
            {
               _loc3_ = CommonUtils.isDualShock4TrackpadAlternativeButtonNeeded();
               if(_loc3_)
               {
                  param1 += "_alt";
               }
            }
         }
         if(this.m_platform != "key" && (param1 == "accept" || param1 == "cancel"))
         {
            _loc4_ = ControlsMain.getMenuAcceptCancelLayout();
            _loc5_ = 1;
            _loc6_ = 4;
            _loc7_ = param1 == "accept" ? (_loc4_ == CommonUtils.MENU_ACCEPTFACERIGHT_CANCELFACEDOWN ? _loc6_ : _loc5_) : (_loc4_ == CommonUtils.MENU_ACCEPTFACERIGHT_CANCELFACEDOWN ? _loc5_ : _loc6_);
            this.m_view.button_mc.gotoAndStop(_loc7_);
         }
         else
         {
            CommonUtils.gotoFrameLabelAndStop(this.m_view.button_mc,param1);
         }
         if(this.m_platform == "key" && param1 != "")
         {
            _loc8_ = 0;
            while(_loc8_ < s_pcLocalizedKey.length)
            {
               if(s_pcLocalizedKey[_loc8_].str == param1)
               {
                  this.localizeKey(s_pcLocalizedKey[_loc8_].locStr);
                  break;
               }
               _loc8_++;
            }
         }
         this.applyOpenVROffset();
      }
      
      public function set customKey(param1:String) : void
      {
         var _loc2_:TextFormat = null;
         this.platform = "key";
         this.m_view.button_mc.gotoAndStop("customKey");
         this.m_view.button_mc.key_txt.htmlText = param1;
         this.m_view.button_mc.key_txt.autoSize = TextFieldAutoSize.CENTER;
         if(!CommonUtils.changeFontToGlobalIfNeeded(this.m_view.button_mc.key_txt))
         {
            _loc2_ = this.m_view.button_mc.key_txt.defaultTextFormat;
            this.m_view.button_mc.key_txt.setTextFormat(_loc2_);
         }
         this.resetOpenVROffset();
      }
      
      private function localizeKey(param1:String) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         if(this.m_view.button_mc.button_txt != null)
         {
            _loc2_ = Localization.get(param1);
            this.m_view.button_mc.button_txt.text = _loc2_;
            _loc3_ = int(_loc2_.match(/[^\s]+/g).length);
            if(_loc3_ <= 1)
            {
               MenuUtils.shrinkTextToFit(this.m_view.button_mc.button_txt,-1,-1,9,1);
            }
            this.m_view.button_mc.button_txt.y = -Math.floor(this.m_view.button_mc.button_txt.textHeight / 2) - 2;
         }
         this.resetOpenVROffset();
      }
      
      private function applyOpenVROffset() : void
      {
         var _loc1_:* = undefined;
         if(this.m_platform == "openvr")
         {
            _loc1_ = BitmapReplacementOpenVR.getComponentDescForGamepadButtonID(this.m_view.button_mc.currentFrame);
            if(_loc1_ != null)
            {
               if(_loc1_.idArchetype == BitmapReplacementOpenVR.ARCHETYPEID_ButtonL || _loc1_.idArchetype == BitmapReplacementOpenVR.ARCHETYPEID_ButtonR)
               {
                  this.m_view.y = 3;
                  return;
               }
            }
         }
         this.m_view.y = 0;
      }
      
      private function resetOpenVROffset() : void
      {
         this.m_view.y = 0;
      }
   }
}
