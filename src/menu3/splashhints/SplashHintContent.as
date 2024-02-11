// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.splashhints.SplashHintContent

package menu3.splashhints {
import common.BaseControl;

import basic.IButtonPromptOwner;

import flash.display.Sprite;
import flash.display.MovieClip;
import flash.text.TextField;

import common.menu.MenuConstants;

import flash.text.TextFieldAutoSize;

import common.menu.MenuUtils;
import common.CommonUtils;

import basic.ButtonPromtUtil;

import common.Animate;

import flash.external.ExternalInterface;

public class SplashHintContent extends BaseControl implements ISplashHint, IButtonPromptOwner {

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
	private var m_highlightEffects:Array = [];
	private var iconProps:Object = {};
	private var headerProps:Object = {};
	private var titleProps:Object = {};
	private var m_firstTimeFlag:Boolean = true;
	private var m_sizeX:Number = MenuConstants.BaseWidth;
	private var m_sizeY:Number = MenuConstants.BaseHeight;
	private var m_safeAreaRatio:Number = 1;
	private var m_previousButtonPromptsData:Object = null;

	public function SplashHintContent() {
		this.m_imageContainer = new Sprite();
		addChild(this.m_imageContainer);
		this.m_container = new Sprite();
		addChild(this.m_container);
	}

	public function set AnimationDelayIn(_arg_1:Number):void {
		this.m_animationDelayIn = _arg_1;
	}

	public function set AnimationDelayOut(_arg_1:Number):void {
		this.m_animationDelayOut = _arg_1;
	}

	public function set isMissionTitle(_arg_1:Boolean):void {
		this.m_isMissionTitle = _arg_1;
	}

	public function onSetData(_arg_1:Object):void {
		var _local_2:Array;
		var _local_3:int;
		this.m_data = _arg_1;
		this.m_header = (_arg_1.header as String);
		this.m_title = (_arg_1.title as String);
		this.m_description = (_arg_1.description as String);
		this.m_imageRID = (_arg_1.imageRID as String);
		this.m_hintType = (_arg_1.hinttype as int);
		this.m_iconID = (_arg_1.iconID as String);
		if (this.m_view == null) {
			this.initView();
		}

		if (this.m_controllerMc != null) {
			_local_2 = this.getButtonIdFromText(this.m_description);
			_local_3 = 0;
			while (_local_3 < _local_2.length) {
				_local_3++;
			}

			this.setControllerButtons(_local_2);
		}

		this.updateView();
		this.setPrompts();
	}

	private function initView():void {
		var/*const*/ DX:Number = NaN;
		if (this.m_hintType == MenuConstants.SPLASH_HINT_TYPE_CONTROLLER) {
			this.m_view = new SplashHintControlHintView();
			this.m_controllerMc = this.m_view.controller;
			this.m_controllerMc.visible = false;
			this.m_controllerMc.alpha = 0;
		} else {
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
		if (((ControlsMain.isVrModeActive()) && (this.m_hintType == MenuConstants.SPLASH_HINT_TYPE_CONTROLLER))) {
			this.m_view.y = (MenuConstants.UserLineUpperYPos - MenuConstants.MenuHeight);
			DX = 250;
			if (this.m_view.controller != null) {
				this.m_view.controller.x = (this.m_view.controller.x - DX);
			}

			if (this.m_view.line != null) {
				this.m_view.line.x = (this.m_view.line.x + DX);
			}

			if (this.m_view.title != null) {
				this.m_view.title.x = (this.m_view.title.x + DX);
			}

			if (this.m_view.description != null) {
				this.m_view.description.x = (this.m_view.description.x + DX);
				this.m_view.description.width = 600;
			}

		} else {
			this.m_view.y = (MenuConstants.UserLineUpperYPos - 252);
		}

		if (this.m_imageRID != "") {
			this.m_imageMc = new SplashHintImage();
			this.m_imageContainer.addChild(this.m_imageMc);
			this.m_imageMc.loadImage(this.m_imageRID, function ():void {
				m_imageMc.x = (MenuConstants.BaseWidth - m_imageMc.width);
				m_imageMc.y = -(m_imageMc.height - MenuConstants.BaseHeight);
			});
		}

		this.m_container.addChild(this.m_view);
		this.m_promptContainer = new Sprite();
		this.m_promptContainer.x = (MenuConstants.menuXOffset + 96);
		this.m_promptContainer.y = MenuConstants.ButtonPromptsYPos;
		this.m_container.addChild(this.m_promptContainer);
		if (this.m_iconMc != null) {
			this.iconProps = {
				"xpos": this.m_iconMc.x,
				"ypos": this.m_iconMc.y,
				"scale": this.m_iconMc.scaleX
			};
		}

		if (this.m_headerTf != null) {
			this.headerProps = {
				"xpos": this.m_headerTf.x,
				"ypos": this.m_headerTf.y,
				"scale": this.m_headerTf.scaleX
			};
		}

		if (this.m_titleTf != null) {
			this.titleProps = {
				"xpos": this.m_titleTf.x,
				"ypos": this.m_titleTf.y,
				"scale": this.m_titleTf.scaleX
			};
		}

		if (this.m_descriptionTf != null) {
			this.m_descriptionTf.autoSize = TextFieldAutoSize.LEFT;
		}

	}

	private function updateView():void {
		var _local_1:Number;
		if (this.m_hintType == MenuConstants.SPLASH_HINT_TYPE_CONTROLLER) {
			_local_1 = ((ControlsMain.getDisplaySize() == ControlsMain.DISPLAY_SIZE_SMALL) ? 1.2 : 1);
			this.m_descriptionTf.scaleX = _local_1;
			this.m_descriptionTf.scaleY = _local_1;
		} else {
			this.m_descriptionTf.scaleX = 1;
			this.m_descriptionTf.scaleY = 1;
		}

		if (this.m_iconMc != null) {
			this.m_iconMc.icons.gotoAndStop(this.m_iconID);
			MenuUtils.setColor(this.m_iconMc.icons, MenuConstants.COLOR_WHITE);
		}

		if (this.m_headerTf != null) {
			MenuUtils.setupText(this.m_headerTf, this.m_header, 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGrey);
		}

		MenuUtils.setupTextAndShrinkToFit(this.m_titleTf, this.m_title, 60, MenuConstants.FONT_TYPE_BOLD, this.m_lineMc.width, 0, 9, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_descriptionTf, this.m_description, 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
	}

	private function setControllerButtons(_arg_1:Array):void {
		var _local_8:int;
		var _local_9:String;
		var _local_10:Boolean;
		var _local_11:Boolean;
		var _local_12:Boolean;
		var _local_13:Boolean;
		var _local_14:Boolean;
		var _local_15:Boolean;
		var _local_16:Boolean;
		var _local_17:String;
		var _local_18:Boolean;
		var _local_19:int;
		var _local_20:String;
		if (this.m_controllerMc == null) {
			return;
		}

		if (CommonUtils.getPlatformString() == CommonUtils.PLATFORM_STADIA) {
			return;
		}

		var _local_2:String = ControlsMain.getControllerType();
		if (_arg_1.length != 0) {
			_local_8 = 0;
			while (_local_8 < _arg_1.length) {
				_local_9 = _arg_1[_local_8];
				_local_10 = (_local_9.indexOf(POSTFIX_PS4) >= 0);
				_local_11 = (_local_9.indexOf(POSTFIX_KEY) >= 0);
				_local_12 = (_local_9.indexOf(POSTFIX_PS5) >= 0);
				_local_13 = (_local_9.indexOf(POSTFIX_NS) >= 0);
				_local_14 = (_local_9.indexOf(POSTFIX_OCULUSVR) >= 0);
				_local_15 = (_local_9.indexOf(POSTFIX_OPENVR) >= 0);
				_local_16 = false;
				if (_local_2 == CommonUtils.CONTROLLER_TYPE_PS4) {
					_local_16 = _local_10;
				} else {
					if (_local_2 == CommonUtils.CONTROLLER_TYPE_KEY) {
						_local_16 = _local_11;
					} else {
						if (_local_2 == CommonUtils.CONTROLLER_TYPE_PS5) {
							_local_16 = _local_12;
						} else {
							if (((_local_2 == CommonUtils.CONTROLLER_TYPE_SWITCHPRO) || (_local_2 == CommonUtils.CONTROLLER_TYPE_SWITCHJOYCON))) {
								_local_16 = _local_13;
							} else {
								if (_local_2 == CommonUtils.CONTROLLER_TYPE_OCULUSVR) {
									_local_16 = _local_14;
								} else {
									if (_local_2 == CommonUtils.CONTROLLER_TYPE_OPENVR) {
										_local_16 = _local_15;
									} else {
										_local_16 = ((((((!(_local_11)) && (!(_local_10))) && (!(_local_12))) && (!(_local_13))) && (!(_local_14))) && (!(_local_15)));
									}

								}

							}

						}

					}

				}

				if (!_local_16) {
					_arg_1.splice(_local_8, 1);
					_local_8--;
				}

				_local_8++;
			}

		}

		if (_arg_1.length == 0) {
			this.m_controllerMc.visible = false;
			return;
		}

		this.m_controllerMc.visible = true;
		this.m_controllerMc.gotoAndStop(_local_2);
		this.stopButtonEffects(true);
		var _local_3:* = "BTN";
		var _local_4:String = this.getInputPostFix(_local_2);
		var _local_5:int = this.getInputButtonStartIndex(_local_2);
		var _local_6:int = this.getInputButtonEndIndex(_local_2);
		var _local_7:int = _local_5;
		while (_local_7 <= _local_6) {
			_local_17 = ((_local_3 + _local_7.toString()) + _local_4);
			_local_18 = false;
			_local_19 = 0;
			while (((_local_19 < _arg_1.length) && (!(_local_18)))) {
				_local_20 = _arg_1[_local_19];
				_local_18 = (_local_20.toUpperCase() == _local_17.toUpperCase());
				_local_19++;
			}

			if (this.m_controllerMc.buttons[_local_17] != null) {
				this.m_controllerMc.buttons[_local_17].visible = _local_18;
				if (_local_18) {
					if (ControlsMain.isVrModeActive()) {
						MenuUtils.removeFilters(this.m_controllerMc.buttons[_local_17]);
					}

					this.addButtonEffect(_local_17);
				}

			}

			_local_7++;
		}

		if (!this.m_firstTimeFlag) {
			this.showController(0);
		}

	}

	private function getInputPostFix(_arg_1:String):String {
		if ((((_arg_1 == CommonUtils.CONTROLLER_TYPE_PC) || (_arg_1 == CommonUtils.CONTROLLER_TYPE_XBOXONE)) || (_arg_1 == CommonUtils.CONTROLLER_TYPE_XBOXSERIESX))) {
			return (POSTFIX_XBOX);
		}

		if (((_arg_1 == CommonUtils.CONTROLLER_TYPE_SWITCHPRO) || (_arg_1 == CommonUtils.CONTROLLER_TYPE_SWITCHJOYCON))) {
			return (POSTFIX_NS);
		}

		if (_arg_1 == CommonUtils.CONTROLLER_TYPE_OCULUSVR) {
			return (POSTFIX_OCULUSVR);
		}

		if (_arg_1 == CommonUtils.CONTROLLER_TYPE_OPENVR) {
			return (POSTFIX_OPENVR);
		}

		if (_arg_1 == CommonUtils.CONTROLLER_TYPE_PS4) {
			return (POSTFIX_PS4);
		}

		if (_arg_1 == CommonUtils.CONTROLLER_TYPE_PS5) {
			return (POSTFIX_PS5);
		}

		if (_arg_1 == CommonUtils.CONTROLLER_TYPE_KEY) {
			return (POSTFIX_KEY);
		}

		return ("");
	}

	private function getInputButtonStartIndex(_arg_1:String):int {
		if (_arg_1 == CommonUtils.CONTROLLER_TYPE_KEY) {
			return (KEYBOARD_MOUSE_BUTTON_INDEX_START);
		}

		return (CONTROLLER_BUTTON_INDEX_START);
	}

	private function getInputButtonEndIndex(_arg_1:String):int {
		if (_arg_1 == CommonUtils.CONTROLLER_TYPE_KEY) {
			return (KEYBOARD_MOUSE_BUTTON_INDEX_END);
		}

		return (CONTROLLER_BUTTON_INDEX_END);
	}

	private function setPrompts():void {
		this.m_previousButtonPromptsData = MenuUtils.parsePrompts(this.m_data, this.m_previousButtonPromptsData, this.m_promptContainer, false, this.handlePromptMouseEvent);
	}

	private function handlePromptMouseEvent(_arg_1:String):void {
		ButtonPromtUtil.handlePromptMouseEvent(sendEventWithValue, _arg_1);
	}

	public function updateButtonPrompts():void {
		this.setPrompts();
	}

	public function show():void {
		this.stopButtonEffects();
		this.clearAnimations();
		this.m_view.alpha = 1;
		this.m_imageContainer.alpha = 1;
		if (this.m_isMissionTitle) {
			this.playSound("play_ui_mission_title_appear");
		}

		if (this.m_iconMc != null) {
			this.m_iconMc.alpha = 0;
			this.m_iconMc.frame.visible = true;
			this.m_iconMc.bg.visible = false;
			MenuUtils.setColor(this.m_iconMc.frame, MenuConstants.COLOR_WHITE);
			Animate.fromTo(this.m_iconMc, 0.2, this.m_animationDelayIn, {"alpha": 0}, {"alpha": 1}, Animate.ExpoOut);
			Animate.addFromTo(this.m_iconMc, 0.4, this.m_animationDelayIn, {
				"scaleX": 0.4,
				"scaleY": 0.4
			}, {
				"scaleX": 1,
				"scaleY": 1
			}, Animate.ExpoOut);
		}

		if (this.m_headerTf != null) {
			this.m_headerTf.alpha = 0;
			Animate.fromTo(this.m_headerTf, 0.2, (this.m_animationDelayIn + 0.1), {"alpha": 0}, {"alpha": 1}, Animate.ExpoOut);
			Animate.addFromTo(this.m_headerTf, 0.3, (this.m_animationDelayIn + 0.1), {"x": (this.headerProps.xpos - 10)}, {"x": this.headerProps.xpos}, Animate.ExpoOut);
		}

		if (this.m_titleTf != null) {
			this.m_titleTf.alpha = 0;
			Animate.fromTo(this.m_titleTf, 0.2, (this.m_animationDelayIn + 0.2), {"alpha": 0}, {"alpha": 1}, Animate.ExpoOut);
			Animate.addFromTo(this.m_titleTf, 0.3, (this.m_animationDelayIn + 0.2), {"x": (this.titleProps.xpos - 10)}, {"x": this.titleProps.xpos}, Animate.ExpoOut);
		}

		if (this.m_lineMc != null) {
			this.m_lineMc.scaleX = 0;
			Animate.fromTo(this.m_lineMc, 0.3, (this.m_animationDelayIn + 0.3), {"scaleX": 0}, {"scaleX": 1}, Animate.ExpoOut);
		}

		if (this.m_descriptionTf != null) {
			this.m_descriptionTf.alpha = 0;
			Animate.fromTo(this.m_descriptionTf, 0.3, (this.m_animationDelayIn + 0.4), {"alpha": 0}, {"alpha": 1}, Animate.ExpoOut);
		}

		if (this.m_hintType == MenuConstants.SPLASH_HINT_TYPE_CONTROLLER) {
			this.showController((this.m_animationDelayIn + 0.4));
		} else {
			if (this.m_imageMc != null) {
				Animate.delay(this.m_imageMc, (this.m_animationDelayIn + 0.4), this.m_imageMc.show);
			}

		}

		this.m_firstTimeFlag = false;
	}

	public function hide():void {
		this.stopButtonEffects(true);
		this.clearAnimations();
		if (this.m_isMissionTitle) {
			this.playSound("play_ui_mission_title_disappear");
		}

		this.m_imageContainer.alpha = 0;
		if (this.m_view != null) {
			this.m_view.alpha = 0;
		}

	}

	public function playSound(_arg_1:String):void {
		ExternalInterface.call("PlaySound", _arg_1);
	}

	private function showController(_arg_1:Number):void {
		Animate.fromTo(this.m_controllerMc, 0.2, _arg_1, {"alpha": 0}, {"alpha": 1}, Animate.ExpoOut);
		Animate.addFrom(this.m_controllerMc, 0.4, _arg_1, {"x": (this.m_controllerMc.x + 25)}, Animate.ExpoOut);
		this.startButtonEffects(_arg_1);
	}

	private function addButtonEffect(_arg_1:String):void {
		var _local_2:MovieClip = new FxClipMc();
		_local_2.alpha = 0;
		_local_2.x = this.m_controllerMc.buttons[_arg_1].x;
		_local_2.y = this.m_controllerMc.buttons[_arg_1].y;
		this.m_controllerMc.buttons.addChild(_local_2);
		this.m_highlightEffects.push(_local_2);
	}

	private function startButtonEffects(_arg_1:Number):void {
		var _local_2:int;
		while (_local_2 < this.m_highlightEffects.length) {
			this.pulsate(this.m_highlightEffects[_local_2], _arg_1);
			_local_2++;
		}

	}

	private function stopButtonEffects(_arg_1:Boolean = false):void {
		var _local_2:int;
		while (_local_2 < this.m_highlightEffects.length) {
			Animate.kill(this.m_highlightEffects[_local_2]);
			if (_arg_1) {
				this.m_controllerMc.buttons.removeChild(this.m_highlightEffects[_local_2]);
			}

			_local_2++;
		}

		if (_arg_1) {
			this.m_highlightEffects = [];
		}

	}

	private function pulsate(_arg_1:MovieClip, _arg_2:Number):void {
		if (_arg_1 == null) {
			return;
		}

		_arg_1.alpha = 1;
		if (_arg_1.mc1 != null) {
			_arg_1.mc1.alpha = 0;
			Animate.fromTo(_arg_1.mc1, 1.4, _arg_2, {
				"alpha": 1,
				"scaleX": 1,
				"scaleY": 1
			}, {
				"alpha": 0,
				"scaleX": 4.5,
				"scaleY": 4.5
			}, Animate.ExpoOut);
		}

		if (_arg_1.mc2 != null) {
			_arg_1.mc2.alpha = 0;
			Animate.fromTo(_arg_1.mc2, 1.4, (_arg_2 + 0.25), {
				"alpha": 1,
				"scaleX": 1,
				"scaleY": 1
			}, {
				"alpha": 0,
				"scaleX": 4.5,
				"scaleY": 4.5
			}, Animate.ExpoOut, this.pulsateComplete, _arg_1);
		}

	}

	private function pulsateComplete(_arg_1:MovieClip):void {
		if (_arg_1 == null) {
			return;
		}

		if (_arg_1.mc1 != null) {
			_arg_1.mc1.scaleX = 1;
			_arg_1.mc1.scaleY = 1;
		}

		if (_arg_1.mc2 != null) {
			_arg_1.mc2.scaleX = 1;
			_arg_1.mc2.scaleY = 1;
		}

		Animate.delay(_arg_1, 0.5, this.pulsate, _arg_1, 0);
	}

	private function clearAnimations():void {
		if (this.m_iconMc != null) {
			Animate.complete(this.m_iconMc);
		}

		if (this.m_headerTf != null) {
			Animate.complete(this.m_headerTf);
		}

		Animate.complete(this.m_titleTf);
		Animate.complete(this.m_lineMc);
		Animate.complete(this.m_descriptionTf);
		if (this.m_imageMc != null) {
			Animate.complete(this.m_imageMc);
		}

		Animate.complete(this.m_controllerMc);
		Animate.complete(this.m_view);
	}

	private function getButtonIdFromText(_arg_1:String):Array {
		if (_arg_1 == null) {
			return ([]);
		}

		return (_arg_1.match(/btn\d+\w*/gi));
	}

	override public function getContainer():Sprite {
		return (this.m_view);
	}

	override public function onSetSize(_arg_1:Number, _arg_2:Number):void {
		super.onSetSize(_arg_1, _arg_2);
		this.m_sizeX = _arg_1;
		this.m_sizeY = _arg_2;
		this.scaleBackground(this.m_sizeX, this.m_sizeY, this.m_safeAreaRatio);
	}

	override public function onSetViewport(_arg_1:Number, _arg_2:Number, _arg_3:Number):void {
		super.onSetViewport(_arg_1, _arg_2, _arg_3);
		this.m_safeAreaRatio = _arg_3;
		this.scaleBackground(this.m_sizeX, this.m_sizeY, this.m_safeAreaRatio);
	}

	private function scaleBackground(_arg_1:Number, _arg_2:Number, _arg_3:Number):void {
		var _local_4:Number = Math.min((_arg_1 / MenuConstants.BaseWidth), (_arg_2 / MenuConstants.BaseHeight));
		var _local_5:Number = (_local_4 * _arg_3);
		var _local_6:Number = ((_arg_1 - (_local_5 * MenuConstants.BaseWidth)) / 2);
		var _local_7:Number = (_arg_2 - (_local_5 * MenuConstants.BaseHeight));
		var _local_8:Number = ((MenuConstants.BaseHeight * (1 - _arg_3)) / 2);
		this.m_container.scaleX = _local_5;
		this.m_container.x = _local_6;
		this.m_container.scaleY = _local_5;
		this.m_container.y = (_local_7 - _local_8);
		var _local_9:Number = ((_arg_1 - (_local_4 * MenuConstants.BaseWidth)) / 2);
		var _local_10:Number = (_arg_2 - (_local_4 * MenuConstants.BaseHeight));
		this.m_imageContainer.scaleX = _local_4;
		this.m_imageContainer.x = _local_9;
		this.m_imageContainer.scaleY = _local_4;
		this.m_imageContainer.y = _local_10;
	}


}
}//package menu3.splashhints

