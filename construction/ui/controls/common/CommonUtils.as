package common
{
   import flash.display.FrameLabel;
   import flash.display.MovieClip;
   import flash.external.ExternalInterface;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class CommonUtils
   {
      
      public static const PLATFORM_PC:String = "pc";
      
      public static const PLATFORM_ORBIS:String = "orbis";
      
      public static const PLATFORM_PS5:String = "ps5";
      
      public static const PLATFORM_DURANGO:String = "durango";
      
      public static const PLATFORM_SCARLETT:String = "scarlett";
      
      public static const PLATFORM_STADIA:String = "stadia";
      
      public static const PLATFORM_IZUMO:String = "izumo";
      
      public static const CONTROLLER_TYPE_PS4:String = "ps4";
      
      public static const CONTROLLER_TYPE_PS5:String = "ps5";
      
      public static const CONTROLLER_TYPE_XBOXONE:String = "xboxone";
      
      public static const CONTROLLER_TYPE_XBOXSERIESX:String = "xboxseriesx";
      
      public static const CONTROLLER_TYPE_STADIA:String = "stadia";
      
      public static const CONTROLLER_TYPE_SWITCHPRO:String = "nspro";
      
      public static const CONTROLLER_TYPE_SWITCHJOYCON:String = "nsjc";
      
      public static const CONTROLLER_TYPE_PC:String = "pc";
      
      public static const CONTROLLER_TYPE_KEY:String = "key";
      
      public static const CONTROLLER_TYPE_OCULUSVR:String = "oculusvr";
      
      public static const CONTROLLER_TYPE_OPENVR:String = "openvr";
      
      public static const MENU_ACCEPTFACEDOWN_CANCELFACERIGHT:int = 0;
      
      public static const MENU_ACCEPTFACERIGHT_CANCELFACEDOWN:int = 1;
      
      private static var platformType:String = null;
       
      
      public function CommonUtils()
      {
         super();
      }
      
      public static function isWindowsXBox360ControllerUsed() : Boolean
      {
         return ExternalInterface.call("CommonUtilsIsWindowsXBox360ControllerUsed");
      }
      
      public static function isDualShock4TrackpadAlternativeButtonNeeded() : Boolean
      {
         return ExternalInterface.call("CommonUtilsIsDualShock4TrackpadAlternativeButtonNeeded");
      }
      
      public static function isPCVRControllerUsed(param1:String = null) : Boolean
      {
         if(param1 == null)
         {
            param1 = ControlsMain.getControllerType();
         }
         return param1 == CONTROLLER_TYPE_OCULUSVR || param1 == CONTROLLER_TYPE_OPENVR;
      }
      
      public static function getPlatformString() : String
      {
         if(platformType == null)
         {
            platformType = ExternalInterface.call("CommonUtilsGetPlatformString");
         }
         return platformType;
      }
      
      public static function hasFrameLabel(param1:MovieClip, param2:String) : Boolean
      {
         var _loc5_:FrameLabel = null;
         var _loc3_:Boolean = ExternalInterface.call("CommonUtilsGetEnableCommonUtilsDebug");
         if(!_loc3_)
         {
            return true;
         }
         var _loc4_:int = 0;
         while(_loc4_ < param1.currentLabels.length)
         {
            if((_loc5_ = param1.currentLabels[_loc4_]).name == param2)
            {
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      public static function changeFontToGlobalFont(param1:TextField) : void
      {
         var _loc2_:TextFormat = param1.defaultTextFormat;
         param1.setTextFormat(new TextFormat("$global",_loc2_.size,_loc2_.color,_loc2_.bold,_loc2_.italic,_loc2_.underline,_loc2_.url,_loc2_.target,_loc2_.align,_loc2_.leftMargin,_loc2_.rightMargin,_loc2_.indent,_loc2_.leading));
      }
      
      public static function changeFontToGlobalIfNeeded(param1:TextField) : Boolean
      {
         var _loc2_:TextFormat = null;
         if(ExternalInterface.call("GlobalFontNeededToDisplayString",param1.text,param1.defaultTextFormat.font))
         {
            _loc2_ = param1.defaultTextFormat;
            param1.setTextFormat(new TextFormat("$global",_loc2_.size,_loc2_.color,_loc2_.bold,_loc2_.italic,_loc2_.underline,_loc2_.url,_loc2_.target,_loc2_.align,_loc2_.leftMargin,_loc2_.rightMargin,_loc2_.indent,_loc2_.leading));
            return true;
         }
         return false;
      }
      
      public static function gotoFrameLabelAndStop(param1:MovieClip, param2:String) : void
      {
         if(hasFrameLabel(param1,param2))
         {
            param1.gotoAndStop(param2);
         }
         else
         {
            trace("Movie clip " + param1.name + " has no frame label \'" + param2 + "\'. Staying at frame " + param1.currentLabel + ".");
         }
      }
      
      public static function gotoFrameLabelAndPlay(param1:MovieClip, param2:String) : void
      {
         if(hasFrameLabel(param1,param2))
         {
            param1.gotoAndPlay(param2);
         }
         else
         {
            trace("Movie clip " + param1.name + " has no frame label \'" + param2 + "\'. Staying at frame " + param1.currentLabel + ".");
         }
      }
      
      public static function getActiveTextLocaleIndex() : int
      {
         return ExternalInterface.call("CommonUtilsGetActiveTextLocaleIndex");
      }
      
      public static function getUIOptionValue(param1:String) : Boolean
      {
         return ExternalInterface.call("CommonUtilsGetUIOptionValue",param1);
      }
      
      public static function getUIOptionValueNumber(param1:String) : Number
      {
         return ExternalInterface.call("CommonUtilsGetUIOptionValue",param1);
      }
      
      public static function getSubtitleSize() : Number
      {
         return ExternalInterface.call("CommonUtilsGetSubtitleSize");
      }
      
      public static function getSubtitleBGAlpha() : Number
      {
         return ExternalInterface.call("CommonUtilsGetSubtitleBGAlpha");
      }
   }
}
