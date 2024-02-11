// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//basic.ButtonPromptImage

package basic {
import common.BaseControl;
import common.ObjectPool;

import scaleform.gfx.DisplayObjectEx;

import common.CommonUtils;

import flash.text.TextFormat;
import flash.text.TextFieldAutoSize;

import common.Localization;
import common.menu.MenuUtils;

public class ButtonPromptImage extends BaseControl {

	private static var s_pool:ObjectPool = new ObjectPool(ButtonPromptImage, 20);
	private static var s_pcLocalizedKey:Array = [{
		"id": 39,
		"str": "cancel",
		"locStr": "UI_KEYPROMPT_ESC"
	}, {
		"id": 41,
		"str": "accept",
		"locStr": "UI_KEYPROMPT_ENTER"
	}, {
		"id": 42,
		"str": "",
		"locStr": "UI_KEYPROMPT_RALT"
	}, {
		"id": 43,
		"str": "",
		"locStr": "UI_KEYPROMPT_LALT"
	}, {
		"id": 44,
		"str": "",
		"locStr": "UI_KEYPROMPT_CAPSLOCK"
	}, {
		"id": 45,
		"str": "",
		"locStr": "UI_KEYPROMPT_RCTRL"
	}, {
		"id": 46,
		"str": "",
		"locStr": "UI_KEYPROMPT_LCTRL"
	}, {
		"id": 47,
		"str": "",
		"locStr": "UI_KEYPROMPT_RSHIFT"
	}, {
		"id": 48,
		"str": "",
		"locStr": "UI_KEYPROMPT_LSHIFT"
	}, {
		"id": 60,
		"str": "lb",
		"locStr": "UI_KEYPROMPT_PAGEUP"
	}, {
		"id": 61,
		"str": "rb",
		"locStr": "UI_KEYPROMPT_PAGEDOWN"
	}];

	private var m_view:ButtonPromptView;
	private var m_platform:String;

	public function ButtonPromptImage():void {
		this.m_view = new ButtonPromptView();
		this.platform = ControlsMain.getControllerType();
		addChild(this.m_view);
	}

	public static function AcquireInstance():ButtonPromptImage {
		var _local_1:ButtonPromptImage = s_pool.acquireObject();
		DisplayObjectEx.skipNextMatrixLerp(_local_1);
		return (_local_1);
	}

	public static function ReleaseInstance(_arg_1:ButtonPromptImage):void {
		s_pool.releaseObject(_arg_1);
	}


	public function getWidth():Number {
		return (this.m_view.button_mc.width);
	}

	public function set platform(_arg_1:String):void {
		if (this.m_platform != _arg_1) {
			this.m_platform = _arg_1;
			CommonUtils.gotoFrameLabelAndStop(this.m_view, _arg_1);
		}

	}

	public function get platform():String {
		return (this.m_platform);
	}

	public function set button(_arg_1:Number):void {
		var _local_2:Number;
		this.m_view.button_mc.gotoAndStop(_arg_1);
		if (this.m_platform == "key") {
			_local_2 = 0;
			while (_local_2 < s_pcLocalizedKey.length) {
				if (s_pcLocalizedKey[_local_2].id == _arg_1) {
					this.localizeKey(s_pcLocalizedKey[_local_2].locStr);
					break;
				}

				_local_2++;
			}

		}

		this.applyOpenVROffset();
	}

	public function set action(_arg_1:String):void {
		var _local_2:Boolean;
		var _local_3:Boolean;
		var _local_4:int;
		var _local_5:int;
		var _local_6:int;
		var _local_7:int;
		var _local_8:Number;
		if (this.platform == "pc") {
			if (((_arg_1 == "select") || (_arg_1 == "back"))) {
				_local_2 = CommonUtils.isWindowsXBox360ControllerUsed();
				if (_local_2) {
					_arg_1 = (_arg_1 + "_xbox360");
				}

			}

		}

		if (this.platform == "ps4") {
			if (_arg_1 == "select") {
				_local_3 = CommonUtils.isDualShock4TrackpadAlternativeButtonNeeded();
				if (_local_3) {
					_arg_1 = (_arg_1 + "_alt");
				}

			}

		}

		if (((!(this.m_platform == "key")) && ((_arg_1 == "accept") || (_arg_1 == "cancel")))) {
			_local_4 = ControlsMain.getMenuAcceptCancelLayout();
			_local_5 = 1;
			_local_6 = 4;
			_local_7 = ((_arg_1 == "accept") ? ((_local_4 == CommonUtils.MENU_ACCEPTFACERIGHT_CANCELFACEDOWN) ? _local_6 : _local_5) : ((_local_4 == CommonUtils.MENU_ACCEPTFACERIGHT_CANCELFACEDOWN) ? _local_5 : _local_6));
			this.m_view.button_mc.gotoAndStop(_local_7);
		} else {
			CommonUtils.gotoFrameLabelAndStop(this.m_view.button_mc, _arg_1);
		}

		if (((this.m_platform == "key") && (!(_arg_1 == "")))) {
			_local_8 = 0;
			while (_local_8 < s_pcLocalizedKey.length) {
				if (s_pcLocalizedKey[_local_8].str == _arg_1) {
					this.localizeKey(s_pcLocalizedKey[_local_8].locStr);
					break;
				}

				_local_8++;
			}

		}

		this.applyOpenVROffset();
	}

	public function set customKey(_arg_1:String):void {
		var _local_2:TextFormat;
		this.platform = "key";
		this.m_view.button_mc.gotoAndStop("customKey");
		this.m_view.button_mc.key_txt.htmlText = _arg_1;
		this.m_view.button_mc.key_txt.autoSize = TextFieldAutoSize.CENTER;
		if (!CommonUtils.changeFontToGlobalIfNeeded(this.m_view.button_mc.key_txt)) {
			_local_2 = this.m_view.button_mc.key_txt.defaultTextFormat;
			this.m_view.button_mc.key_txt.setTextFormat(_local_2);
		}

		this.resetOpenVROffset();
	}

	private function localizeKey(_arg_1:String):void {
		var _local_2:String;
		var _local_3:int;
		if (this.m_view.button_mc.button_txt != null) {
			_local_2 = Localization.get(_arg_1);
			this.m_view.button_mc.button_txt.text = _local_2;
			_local_3 = _local_2.match(/[^\s]+/g).length;
			if (_local_3 <= 1) {
				MenuUtils.shrinkTextToFit(this.m_view.button_mc.button_txt, -1, -1, 9, 1);
			}

			this.m_view.button_mc.button_txt.y = (-(Math.floor((this.m_view.button_mc.button_txt.textHeight / 2))) - 2);
		}

		this.resetOpenVROffset();
	}

	private function applyOpenVROffset():void {
		var _local_1:*;
		if (this.m_platform == "openvr") {
			_local_1 = BitmapReplacementOpenVR.getComponentDescForGamepadButtonID(this.m_view.button_mc.currentFrame);
			if (_local_1 != null) {
				if (((_local_1.idArchetype == BitmapReplacementOpenVR.ARCHETYPEID_ButtonL) || (_local_1.idArchetype == BitmapReplacementOpenVR.ARCHETYPEID_ButtonR))) {
					this.m_view.y = 3;
					return;
				}

			}

		}

		this.m_view.y = 0;
	}

	private function resetOpenVROffset():void {
		this.m_view.y = 0;
	}


}
}//package basic

