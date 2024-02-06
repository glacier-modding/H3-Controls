package basic
{
   import flash.display.BitmapData;
   import flash.display.FrameLabel;
   import flash.display.MovieClip;
   import flash.geom.Matrix;
   import flash.text.TextField;
   
   public class BitmapReplacementOpenVR
   {
      
      public static const GAMEPADBUTTONID_FaceButtonBottom:int = 1;
      
      public static const GAMEPADBUTTONID_FaceButtonTop:int = 2;
      
      public static const GAMEPADBUTTONID_FaceButtonLeft:int = 3;
      
      public static const GAMEPADBUTTONID_FaceButtonRight:int = 4;
      
      public static const GAMEPADBUTTONID_DpadUp:int = 5;
      
      public static const GAMEPADBUTTONID_DpadRight:int = 6;
      
      public static const GAMEPADBUTTONID_DpadDown:int = 7;
      
      public static const GAMEPADBUTTONID_DpadLeft:int = 8;
      
      public static const GAMEPADBUTTONID_ShoulderRight:int = 9;
      
      public static const GAMEPADBUTTONID_TriggerRight:int = 10;
      
      public static const GAMEPADBUTTONID_StickRight:int = 11;
      
      public static const GAMEPADBUTTONID_StickRightPress:int = 12;
      
      public static const GAMEPADBUTTONID_ShoulderLeft:int = 13;
      
      public static const GAMEPADBUTTONID_TriggerLeft:int = 14;
      
      public static const GAMEPADBUTTONID_StickLeft:int = 15;
      
      public static const GAMEPADBUTTONID_StickLeftPress:int = 16;
      
      public static const GAMEPADBUTTONID_ButtonStart:int = 17;
      
      public static const GAMEPADBUTTONID_ButtonSelect:int = 18;
      
      public static const GAMEPADBUTTONID_ButtonSelectAlt:int = 19;
      
      public static const GAMEPADBUTTONID_ButtonStartAlt:int = 20;
      
      public static const GAMEPADBUTTONID_DpadAll:int = 21;
      
      public static const GAMEPADBUTTONID_DpadUpDown:int = 22;
      
      public static const GAMEPADBUTTONID_DpadLeftRight:int = 23;
      
      public static const GAMEPADBUTTONID_TriggersLR:int = 24;
      
      public static const GAMEPADBUTTONID_ButtonCapture:int = 25;
      
      public static const GAMEPADBUTTONID_ButtonHome:int = 26;
      
      public static const GAMEPADBUTTONID_ButtonAssistant:int = 27;
      
      public static const ARCHETYPEID_ButtonL:int = 1;
      
      public static const ARCHETYPEID_ButtonR:int = 2;
      
      public static const ARCHETYPEID_Button:int = 3;
      
      public static const ARCHETYPEID_GripL:int = 4;
      
      public static const ARCHETYPEID_GripR:int = 5;
      
      public static const ARCHETYPEID_Joystick:int = 6;
      
      public static const ARCHETYPEID_JoystickPressCenter:int = 7;
      
      public static const ARCHETYPEID_JoystickPressDirections:int = 8;
      
      public static const ARCHETYPEID_TrackpadRound:int = 9;
      
      public static const ARCHETYPEID_TrackpadRoundPressCenter:int = 10;
      
      public static const ARCHETYPEID_TrackpadRoundPressDirections:int = 11;
      
      public static const ARCHETYPEID_TrackpadTall:int = 12;
      
      public static const ARCHETYPEID_TrackpadTallPressCenter:int = 13;
      
      public static const ARCHETYPEID_TrackpadTallPressDirections:int = 14;
      
      public static const ARCHETYPEID_TriggerL:int = 15;
      
      public static const ARCHETYPEID_TriggerR:int = 16;
      
      public static const ARCHETYPEID_BumperL:int = 17;
      
      public static const ARCHETYPEID_BumperR:int = 18;
      
      public static const PRESSDIRECTION_North:int = 1;
      
      public static const PRESSDIRECTION_South:int = 2;
      
      public static const PRESSDIRECTION_East:int = 4;
      
      public static const PRESSDIRECTION_West:int = 8;
      
      public static const NameOfGamepadButtonID:Object = {
         "1":"FaceButtonBottom",
         "2":"FaceButtonTop",
         "3":"FaceButtonLeft",
         "4":"FaceButtonRight",
         "5":"DpadUp",
         "6":"DpadRight",
         "7":"DpadDown",
         "8":"DpadLeft",
         "9":"ShoulderRight",
         "10":"TriggerRight",
         "11":"StickRight",
         "12":"StickRightPress",
         "13":"ShoulderLeft",
         "14":"TriggerLeft",
         "15":"StickLeft",
         "16":"StickLeftPress",
         "17":"ButtonStart",
         "18":"ButtonSelect",
         "19":"ButtonSelectAlt",
         "20":"ButtonStartAlt",
         "21":"DpadAll",
         "22":"DpadUpDown",
         "23":"DpadLeftRight",
         "24":"TriggersLR",
         "25":"ButtonCapture",
         "26":"ButtonHome",
         "27":"ButtonAssistant"
      };
      
      public static const NameOfArchetypeID:Object = {
         "1":"ButtonL",
         "2":"ButtonR",
         "3":"Button",
         "4":"GripL",
         "5":"GripR",
         "6":"Joystick",
         "7":"JoystickPressCenter",
         "8":"JoystickPressDirections",
         "9":"TrackpadRound",
         "10":"TrackpadRoundPressCenter",
         "11":"TrackpadRoundPressDirections",
         "12":"TrackpadTall",
         "13":"TrackpadTallPressCenter",
         "14":"TrackpadTallPressDirections",
         "15":"TriggerL",
         "16":"TriggerR",
         "17":"BumperL",
         "18":"BumperR"
      };
      
      public static const PX_TEMPLATE_SIZE:int = 38;
      
      public static const PX_BITMAP_SIZE:int = 76;
      
      public static const PX_TEMPLATE_LABELTEXT_MAX_WIDTH:Number = 32;
      
      public static const bitmapData_FaceButtonBottom:BitmapData = new BitmapData(PX_BITMAP_SIZE,PX_BITMAP_SIZE,true,0);
      
      public static const bitmapData_FaceButtonTop:BitmapData = new BitmapData(PX_BITMAP_SIZE,PX_BITMAP_SIZE,true,0);
      
      public static const bitmapData_FaceButtonLeft:BitmapData = new BitmapData(PX_BITMAP_SIZE,PX_BITMAP_SIZE,true,0);
      
      public static const bitmapData_FaceButtonRight:BitmapData = new BitmapData(PX_BITMAP_SIZE,PX_BITMAP_SIZE,true,0);
      
      public static const bitmapData_ShoulderRight:BitmapData = new BitmapData(PX_BITMAP_SIZE,PX_BITMAP_SIZE,true,0);
      
      public static const bitmapData_TriggerRight:BitmapData = new BitmapData(PX_BITMAP_SIZE,PX_BITMAP_SIZE,true,0);
      
      public static const bitmapData_StickRight:BitmapData = new BitmapData(PX_BITMAP_SIZE,PX_BITMAP_SIZE,true,0);
      
      public static const bitmapData_StickRightPress:BitmapData = new BitmapData(PX_BITMAP_SIZE,PX_BITMAP_SIZE,true,0);
      
      public static const bitmapData_ShoulderLeft:BitmapData = new BitmapData(PX_BITMAP_SIZE,PX_BITMAP_SIZE,true,0);
      
      public static const bitmapData_TriggerLeft:BitmapData = new BitmapData(PX_BITMAP_SIZE,PX_BITMAP_SIZE,true,0);
      
      public static const bitmapData_StickLeft:BitmapData = new BitmapData(PX_BITMAP_SIZE,PX_BITMAP_SIZE,true,0);
      
      public static const bitmapData_StickLeftPress:BitmapData = new BitmapData(PX_BITMAP_SIZE,PX_BITMAP_SIZE,true,0);
      
      public static const bitmapData_ButtonStart:BitmapData = new BitmapData(PX_BITMAP_SIZE,PX_BITMAP_SIZE,true,0);
      
      private static var s_componentByButtonID:Vector.<Component> = null;
       
      
      public function BitmapReplacementOpenVR()
      {
         super();
      }
      
      public static function getBitmapDataForGamepadButtonID(param1:int) : BitmapData
      {
         switch(param1)
         {
            case GAMEPADBUTTONID_FaceButtonBottom:
               return bitmapData_FaceButtonBottom;
            case GAMEPADBUTTONID_FaceButtonTop:
               return bitmapData_FaceButtonTop;
            case GAMEPADBUTTONID_FaceButtonLeft:
               return bitmapData_FaceButtonLeft;
            case GAMEPADBUTTONID_FaceButtonRight:
               return bitmapData_FaceButtonRight;
            case GAMEPADBUTTONID_ShoulderRight:
               return bitmapData_ShoulderRight;
            case GAMEPADBUTTONID_TriggerRight:
               return bitmapData_TriggerRight;
            case GAMEPADBUTTONID_StickRight:
               return bitmapData_StickRight;
            case GAMEPADBUTTONID_StickRightPress:
               return bitmapData_StickRightPress;
            case GAMEPADBUTTONID_ShoulderLeft:
               return bitmapData_ShoulderLeft;
            case GAMEPADBUTTONID_TriggerLeft:
               return bitmapData_TriggerLeft;
            case GAMEPADBUTTONID_StickLeft:
               return bitmapData_StickLeft;
            case GAMEPADBUTTONID_StickLeftPress:
               return bitmapData_StickLeftPress;
            case GAMEPADBUTTONID_ButtonStart:
               return bitmapData_ButtonStart;
            case GAMEPADBUTTONID_ButtonSelect:
               return bitmapData_ButtonStart;
            default:
               return null;
         }
      }
      
      public static function getComponentDescForGamepadButtonID(param1:int) : Component
      {
         if(s_componentByButtonID == null || param1 < 0 || param1 >= s_componentByButtonID.length)
         {
            return null;
         }
         return s_componentByButtonID[param1];
      }
      
      private static function hasFrameLabel(param1:MovieClip, param2:String) : Boolean
      {
         var _loc3_:FrameLabel = null;
         for each(_loc3_ in param1.currentLabels)
         {
            if(_loc3_.name == param2)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function redrawBitmaps(param1:Array) : void
      {
         var _loc2_:Object = null;
         var _loc3_:BitmapData = null;
         var _loc4_:Object = null;
         var _loc5_:ButtonTemplateOpenVR = null;
         var _loc6_:MovieClip = null;
         var _loc7_:TextField = null;
         var _loc8_:MovieClip = null;
         var _loc9_:Matrix = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         s_componentByButtonID = new Vector.<Component>();
         for each(_loc2_ in param1)
         {
            while(s_componentByButtonID.length <= _loc2_.idSource)
            {
               s_componentByButtonID.push(null);
            }
            s_componentByButtonID[_loc2_.idSource] = new Component(_loc2_.component.idArchetype,_loc2_.component.direction,_loc2_.component.label);
            _loc3_ = getBitmapDataForGamepadButtonID(_loc2_.idSource);
            if(_loc3_ != null)
            {
               _loc3_.fillRect(_loc3_.rect,0);
               _loc4_ = _loc2_.component;
               (_loc5_ = new ButtonTemplateOpenVR()).gotoAndStop(_loc4_.idArchetype);
               _loc6_ = _loc5_.symbol_mc;
               _loc7_ = _loc5_.label_txt;
               _loc8_ = _loc5_.directions_mc;
               if(_loc6_ != null)
               {
                  if(hasFrameLabel(_loc6_,_loc4_.label.toLowerCase()))
                  {
                     _loc6_.gotoAndStop(_loc4_.label.toLowerCase());
                     _loc4_.label = "";
                  }
                  else
                  {
                     _loc6_.visible = false;
                  }
               }
               if(_loc7_ != null)
               {
                  _loc7_.text = _loc4_.label;
                  if(_loc7_.textWidth > PX_TEMPLATE_LABELTEXT_MAX_WIDTH)
                  {
                     _loc11_ = (_loc10_ = PX_TEMPLATE_LABELTEXT_MAX_WIDTH / _loc7_.textWidth) > 0.5 ? 1 : _loc10_ + 0.5;
                     _loc12_ = _loc7_.x + _loc7_.width / 2;
                     _loc13_ = _loc7_.y + _loc7_.height / 2;
                     _loc7_.scaleX = _loc10_;
                     _loc7_.scaleY = _loc11_;
                     _loc7_.x = _loc12_ - _loc7_.width / 2;
                     _loc7_.y = _loc13_ - _loc7_.height / 2;
                  }
               }
               if(_loc8_ != null)
               {
                  if(_loc8_.north_mc != null)
                  {
                     _loc8_.north_mc.visible = (_loc4_.direction & PRESSDIRECTION_North) != 0;
                  }
                  if(_loc8_.south_mc != null)
                  {
                     _loc8_.south_mc.visible = (_loc4_.direction & PRESSDIRECTION_South) != 0;
                  }
                  if(_loc8_.east_mc != null)
                  {
                     _loc8_.east_mc.visible = (_loc4_.direction & PRESSDIRECTION_East) != 0;
                  }
                  if(_loc8_.west_mc != null)
                  {
                     _loc8_.west_mc.visible = (_loc4_.direction & PRESSDIRECTION_West) != 0;
                  }
               }
               (_loc9_ = new Matrix()).scale(PX_BITMAP_SIZE / PX_TEMPLATE_SIZE,PX_BITMAP_SIZE / PX_TEMPLATE_SIZE);
               _loc9_.translate(PX_BITMAP_SIZE / 2,PX_BITMAP_SIZE / 2);
               _loc3_.draw(_loc5_,_loc9_,null,null,null,true);
            }
         }
      }
   }
}

class Component
{
    
   
   private var m_idArchetype:int;
   
   private var m_direction:int;
   
   private var m_label:String;
   
   public function Component(param1:int, param2:int, param3:String)
   {
      super();
      this.m_idArchetype = param1;
      this.m_direction = param2;
      this.m_label = param3;
   }
   
   public function get idArchetype() : int
   {
      return this.m_idArchetype;
   }
   
   public function get direction() : int
   {
      return this.m_direction;
   }
   
   public function get label() : String
   {
      return this.m_label;
   }
}
