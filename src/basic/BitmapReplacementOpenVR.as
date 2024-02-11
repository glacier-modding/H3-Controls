// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//basic.BitmapReplacementOpenVR

package basic {
import flash.display.BitmapData;

import __AS3__.vec.Vector;

import flash.display.FrameLabel;
import flash.display.MovieClip;
import flash.text.TextField;
import flash.geom.Matrix;

import __AS3__.vec.*;

public class BitmapReplacementOpenVR {

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
		"1": "FaceButtonBottom",
		"2": "FaceButtonTop",
		"3": "FaceButtonLeft",
		"4": "FaceButtonRight",
		"5": "DpadUp",
		"6": "DpadRight",
		"7": "DpadDown",
		"8": "DpadLeft",
		"9": "ShoulderRight",
		"10": "TriggerRight",
		"11": "StickRight",
		"12": "StickRightPress",
		"13": "ShoulderLeft",
		"14": "TriggerLeft",
		"15": "StickLeft",
		"16": "StickLeftPress",
		"17": "ButtonStart",
		"18": "ButtonSelect",
		"19": "ButtonSelectAlt",
		"20": "ButtonStartAlt",
		"21": "DpadAll",
		"22": "DpadUpDown",
		"23": "DpadLeftRight",
		"24": "TriggersLR",
		"25": "ButtonCapture",
		"26": "ButtonHome",
		"27": "ButtonAssistant"
	};
	public static const NameOfArchetypeID:Object = {
		"1": "ButtonL",
		"2": "ButtonR",
		"3": "Button",
		"4": "GripL",
		"5": "GripR",
		"6": "Joystick",
		"7": "JoystickPressCenter",
		"8": "JoystickPressDirections",
		"9": "TrackpadRound",
		"10": "TrackpadRoundPressCenter",
		"11": "TrackpadRoundPressDirections",
		"12": "TrackpadTall",
		"13": "TrackpadTallPressCenter",
		"14": "TrackpadTallPressDirections",
		"15": "TriggerL",
		"16": "TriggerR",
		"17": "BumperL",
		"18": "BumperR"
	};
	public static const PX_TEMPLATE_SIZE:int = 38;
	public static const PX_BITMAP_SIZE:int = 76;
	public static const PX_TEMPLATE_LABELTEXT_MAX_WIDTH:Number = 32;
	public static const bitmapData_FaceButtonBottom:BitmapData = new BitmapData(PX_BITMAP_SIZE, PX_BITMAP_SIZE, true, 0);
	public static const bitmapData_FaceButtonTop:BitmapData = new BitmapData(PX_BITMAP_SIZE, PX_BITMAP_SIZE, true, 0);
	public static const bitmapData_FaceButtonLeft:BitmapData = new BitmapData(PX_BITMAP_SIZE, PX_BITMAP_SIZE, true, 0);
	public static const bitmapData_FaceButtonRight:BitmapData = new BitmapData(PX_BITMAP_SIZE, PX_BITMAP_SIZE, true, 0);
	public static const bitmapData_ShoulderRight:BitmapData = new BitmapData(PX_BITMAP_SIZE, PX_BITMAP_SIZE, true, 0);
	public static const bitmapData_TriggerRight:BitmapData = new BitmapData(PX_BITMAP_SIZE, PX_BITMAP_SIZE, true, 0);
	public static const bitmapData_StickRight:BitmapData = new BitmapData(PX_BITMAP_SIZE, PX_BITMAP_SIZE, true, 0);
	public static const bitmapData_StickRightPress:BitmapData = new BitmapData(PX_BITMAP_SIZE, PX_BITMAP_SIZE, true, 0);
	public static const bitmapData_ShoulderLeft:BitmapData = new BitmapData(PX_BITMAP_SIZE, PX_BITMAP_SIZE, true, 0);
	public static const bitmapData_TriggerLeft:BitmapData = new BitmapData(PX_BITMAP_SIZE, PX_BITMAP_SIZE, true, 0);
	public static const bitmapData_StickLeft:BitmapData = new BitmapData(PX_BITMAP_SIZE, PX_BITMAP_SIZE, true, 0);
	public static const bitmapData_StickLeftPress:BitmapData = new BitmapData(PX_BITMAP_SIZE, PX_BITMAP_SIZE, true, 0);
	public static const bitmapData_ButtonStart:BitmapData = new BitmapData(PX_BITMAP_SIZE, PX_BITMAP_SIZE, true, 0);
	private static var s_componentByButtonID:Vector.<Component> = null;


	public static function getBitmapDataForGamepadButtonID(_arg_1:int):BitmapData {
		switch (_arg_1) {
			case GAMEPADBUTTONID_FaceButtonBottom:
				return (bitmapData_FaceButtonBottom);
			case GAMEPADBUTTONID_FaceButtonTop:
				return (bitmapData_FaceButtonTop);
			case GAMEPADBUTTONID_FaceButtonLeft:
				return (bitmapData_FaceButtonLeft);
			case GAMEPADBUTTONID_FaceButtonRight:
				return (bitmapData_FaceButtonRight);
			case GAMEPADBUTTONID_ShoulderRight:
				return (bitmapData_ShoulderRight);
			case GAMEPADBUTTONID_TriggerRight:
				return (bitmapData_TriggerRight);
			case GAMEPADBUTTONID_StickRight:
				return (bitmapData_StickRight);
			case GAMEPADBUTTONID_StickRightPress:
				return (bitmapData_StickRightPress);
			case GAMEPADBUTTONID_ShoulderLeft:
				return (bitmapData_ShoulderLeft);
			case GAMEPADBUTTONID_TriggerLeft:
				return (bitmapData_TriggerLeft);
			case GAMEPADBUTTONID_StickLeft:
				return (bitmapData_StickLeft);
			case GAMEPADBUTTONID_StickLeftPress:
				return (bitmapData_StickLeftPress);
			case GAMEPADBUTTONID_ButtonStart:
				return (bitmapData_ButtonStart);
			case GAMEPADBUTTONID_ButtonSelect:
				return (bitmapData_ButtonStart);
		}
		;
		return (null);
	}

	public static function getComponentDescForGamepadButtonID(_arg_1:int):Component {
		if ((((s_componentByButtonID == null) || (_arg_1 < 0)) || (_arg_1 >= s_componentByButtonID.length))) {
			return (null);
		}
		;
		return (s_componentByButtonID[_arg_1]);
	}

	private static function hasFrameLabel(_arg_1:MovieClip, _arg_2:String):Boolean {
		var _local_3:FrameLabel;
		for each (_local_3 in _arg_1.currentLabels) {
			if (_local_3.name == _arg_2) {
				return (true);
			}
			;
		}
		;
		return (false);
	}

	public static function redrawBitmaps(_arg_1:Array):void {
		var _local_2:Object;
		var _local_3:BitmapData;
		var _local_4:Object;
		var _local_5:ButtonTemplateOpenVR;
		var _local_6:MovieClip;
		var _local_7:TextField;
		var _local_8:MovieClip;
		var _local_9:Matrix;
		var _local_10:Number;
		var _local_11:Number;
		var _local_12:Number;
		var _local_13:Number;
		s_componentByButtonID = new Vector.<Component>();
		for each (_local_2 in _arg_1) {
			while (s_componentByButtonID.length <= _local_2.idSource) {
				s_componentByButtonID.push(null);
			}
			;
			s_componentByButtonID[_local_2.idSource] = new Component(_local_2.component.idArchetype, _local_2.component.direction, _local_2.component.label);
			_local_3 = getBitmapDataForGamepadButtonID(_local_2.idSource);
			if (_local_3 != null) {
				_local_3.fillRect(_local_3.rect, 0);
				_local_4 = _local_2.component;
				_local_5 = new ButtonTemplateOpenVR();
				_local_5.gotoAndStop(_local_4.idArchetype);
				_local_6 = _local_5.symbol_mc;
				_local_7 = _local_5.label_txt;
				_local_8 = _local_5.directions_mc;
				if (_local_6 != null) {
					if (hasFrameLabel(_local_6, _local_4.label.toLowerCase())) {
						_local_6.gotoAndStop(_local_4.label.toLowerCase());
						_local_4.label = "";
					} else {
						_local_6.visible = false;
					}
					;
				}
				;
				if (_local_7 != null) {
					_local_7.text = _local_4.label;
					if (_local_7.textWidth > PX_TEMPLATE_LABELTEXT_MAX_WIDTH) {
						_local_10 = (PX_TEMPLATE_LABELTEXT_MAX_WIDTH / _local_7.textWidth);
						_local_11 = ((_local_10 > 0.5) ? 1 : (_local_10 + 0.5));
						_local_12 = (_local_7.x + (_local_7.width / 2));
						_local_13 = (_local_7.y + (_local_7.height / 2));
						_local_7.scaleX = _local_10;
						_local_7.scaleY = _local_11;
						_local_7.x = (_local_12 - (_local_7.width / 2));
						_local_7.y = (_local_13 - (_local_7.height / 2));
					}
					;
				}
				;
				if (_local_8 != null) {
					if (_local_8.north_mc != null) {
						_local_8.north_mc.visible = (!((_local_4.direction & PRESSDIRECTION_North) == 0));
					}
					;
					if (_local_8.south_mc != null) {
						_local_8.south_mc.visible = (!((_local_4.direction & PRESSDIRECTION_South) == 0));
					}
					;
					if (_local_8.east_mc != null) {
						_local_8.east_mc.visible = (!((_local_4.direction & PRESSDIRECTION_East) == 0));
					}
					;
					if (_local_8.west_mc != null) {
						_local_8.west_mc.visible = (!((_local_4.direction & PRESSDIRECTION_West) == 0));
					}
					;
				}
				;
				_local_9 = new Matrix();
				_local_9.scale((PX_BITMAP_SIZE / PX_TEMPLATE_SIZE), (PX_BITMAP_SIZE / PX_TEMPLATE_SIZE));
				_local_9.translate((PX_BITMAP_SIZE / 2), (PX_BITMAP_SIZE / 2));
				_local_3.draw(_local_5, _local_9, null, null, null, true);
			}
			;
		}
		;
	}


}
}//package basic

class Component {

	/*private*/
	var m_idArchetype:int;
	/*private*/
	var m_direction:int;
	/*private*/
	var m_label:String;

	public function Component(_arg_1:int, _arg_2:int, _arg_3:String) {
		this.m_idArchetype = _arg_1;
		this.m_direction = _arg_2;
		this.m_label = _arg_3;
	}

	public function get idArchetype():int {
		return (this.m_idArchetype);
	}

	public function get direction():int {
		return (this.m_direction);
	}

	public function get label():String {
		return (this.m_label);
	}


}


