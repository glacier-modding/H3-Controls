// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.FaceTheCameraVR

package hud {
import common.BaseControl;

import flash.display.Sprite;

import __AS3__.vec.Vector;

import flash.display.Shape;
import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

import common.menu.MenuUtils;
import common.Localization;
import common.menu.MenuConstants;
import common.Animate;

import __AS3__.vec.*;

public class FaceTheCameraVR extends BaseControl {

	private static const P2W:Number = (1 / 1000);//0.001
	private static const W2P:Number = (1000 / 1);//1000

	private var m_widgetContainer:Sprite;
	private var m_cameraWidget:Sprite;
	private var m_textWidget:Sprite;
	private var m_arrowStripWidget:Vector.<Shape>;
	private var m_worldZPositionOfRearPlane:Number = 0;
	private var m_fadeIn_Delay:Number;
	private var m_fadeIn_Duration:Number;
	private var m_fadeOut_Delay:Number;
	private var m_fadeOut_Duration:Number;
	private var m_rearPlane_MoveAnimDuration:Number;
	private var m_textWidget_Width:Number;
	private var m_arrowStripWidget_WidthSpacing:Number;
	private var m_arrowStripWidget_AngularSpan:Number;
	private var m_arrowStripWidget_ArrowLength:Number;
	private var m_arrowStripWidget_ArrowHeight:Number;
	private var m_arrowStripWidget_NumArrows:int;

	public function FaceTheCameraVR() {
		this.m_widgetContainer = new Sprite();
		addChild(this.m_widgetContainer);
		this.m_widgetContainer.alpha = 0;
		this.m_widgetContainer.scaleX = P2W;
		this.m_widgetContainer.scaleY = P2W;
		this.m_widgetContainer.scaleZ = P2W;
	}

	private static function drawArrow(_arg_1:Graphics, _arg_2:Number, _arg_3:Number):void {
		_arg_1.beginFill(0xFFFFFF);
		_arg_1.moveTo(0, (0 + (_arg_3 / 2)));
		_arg_1.lineTo((0 + _arg_2), (0 + (_arg_3 / 2)));
		_arg_1.lineTo(((0 + _arg_2) + (_arg_3 / 2)), 0);
		_arg_1.lineTo((0 + _arg_2), (0 - (_arg_3 / 2)));
		_arg_1.lineTo(0, (0 - (_arg_3 / 2)));
		_arg_1.lineTo((0 + (_arg_3 / 2)), 0);
		_arg_1.endFill();
	}

	private static function createXYZAxes(_arg_1:Number):Sprite {
		var _local_2:Sprite = new Sprite();
		var _local_3:Number = (_arg_1 / 200);
		var _local_4:uint = 0xFF0000;
		var _local_5:uint = 0xFF00;
		var _local_6:uint = 0xFF;
		_local_2.graphics.lineStyle(_local_3, _local_4);
		_local_2.graphics.moveTo(0, 0);
		_local_2.graphics.lineTo(_arg_1, 0);
		_local_2.graphics.lineStyle(_local_3, _local_5);
		_local_2.graphics.moveTo(0, 0);
		_local_2.graphics.lineTo(0, _arg_1);
		var _local_7:Shape = new Shape();
		_local_7.rotationY = -90;
		_local_2.addChild(_local_7);
		_local_7.graphics.lineStyle(_local_3, _local_6);
		_local_7.graphics.moveTo(0, 0);
		_local_7.graphics.lineTo(_arg_1, 0);
		return (_local_2);
	}


	public function set fadeIn_Delay(_arg_1:Number):void {
		this.m_fadeIn_Delay = _arg_1;
	}

	public function set fadeIn_Duration(_arg_1:Number):void {
		this.m_fadeIn_Duration = _arg_1;
	}

	public function set fadeOut_Delay(_arg_1:Number):void {
		this.m_fadeOut_Delay = _arg_1;
	}

	public function set fadeOut_Duration(_arg_1:Number):void {
		this.m_fadeOut_Duration = _arg_1;
	}

	public function set rearPlane_MoveAnimDuration(_arg_1:Number):void {
		this.m_rearPlane_MoveAnimDuration = _arg_1;
	}

	public function set textWidget_Width(_arg_1:Number):void {
		this.m_textWidget_Width = _arg_1;
		this.updateTextWidget();
	}

	public function set arrowStripWidget_WidthSpacing(_arg_1:Number):void {
		this.m_arrowStripWidget_WidthSpacing = _arg_1;
		this.updateArrowStripWidget();
	}

	public function set arrowStripWidget_AngularSpan(_arg_1:Number):void {
		this.m_arrowStripWidget_AngularSpan = _arg_1;
		this.updateArrowStripWidget();
	}

	public function set arrowStripWidget_ArrowLength(_arg_1:Number):void {
		this.m_arrowStripWidget_ArrowLength = _arg_1;
		this.updateArrowStripWidget();
	}

	public function set arrowStripWidget_ArrowHeight(_arg_1:Number):void {
		this.m_arrowStripWidget_ArrowHeight = _arg_1;
		this.updateArrowStripWidget();
	}

	public function set arrowStripWidget_NumArrows(_arg_1:int):void {
		this.m_arrowStripWidget_NumArrows = _arg_1;
		this.updateArrowStripWidget();
	}

	public function set cameraWidget(_arg_1:Boolean):void {
		if (((_arg_1) && (!(this.m_cameraWidget)))) {
			this.m_cameraWidget = new Sprite();
			this.m_widgetContainer.addChild(this.m_cameraWidget);
		} else {
			if (((!(_arg_1)) && (this.m_cameraWidget))) {
				this.m_widgetContainer.removeChild(this.m_cameraWidget);
				this.m_cameraWidget = null;
			}
			;
		}
		;
		this.updateCameraWidget();
	}

	public function set textWidget(_arg_1:Boolean):void {
		var _local_2:TextField;
		if (((_arg_1) && (!(this.m_textWidget)))) {
			this.m_textWidget = new Sprite();
			this.addChild(this.m_textWidget);
			_local_2 = new TextField();
			_local_2.autoSize = TextFieldAutoSize.LEFT;
			_local_2.multiline = false;
			MenuUtils.setupTextUpper(_local_2, Localization.get("UI_VR_HUD_FACE_THE_CAMERA"), 16, MenuConstants.FONT_TYPE_MEDIUM, "#ffffff");
			_local_2.x = (-(_local_2.width) / 2);
			_local_2.y = (-(_local_2.height) / 2);
			this.m_textWidget.rotation = 180;
			this.m_textWidget.z = this.m_worldZPositionOfRearPlane;
			this.m_textWidget.addChild(_local_2);
		} else {
			if (((!(_arg_1)) && (this.m_textWidget))) {
				Animate.kill(this.m_textWidget);
				this.removeChild(this.m_textWidget);
				this.m_textWidget = null;
			}
			;
		}
		;
		this.updateTextWidget();
	}

	public function set arrowStripWidget(_arg_1:Boolean):void {
		var _local_2:int;
		if (((_arg_1) && (!(this.m_arrowStripWidget)))) {
			this.m_arrowStripWidget = new Vector.<Shape>();
		} else {
			if (((!(_arg_1)) && (this.m_arrowStripWidget))) {
				_local_2 = 0;
				while (_local_2 < this.m_arrowStripWidget.length) {
					Animate.kill(this.m_arrowStripWidget[_local_2]);
					this.m_widgetContainer.removeChild(this.m_arrowStripWidget[_local_2]);
					_local_2++;
				}
				;
				this.m_arrowStripWidget = null;
			}
			;
		}
		;
		this.updateArrowStripWidget();
	}

	public function set showMeatSpaceAxes(_arg_1:Boolean):void {
		var _local_2:Sprite = Sprite(getChildByName("meatSpaceAxes"));
		if (((_arg_1) && (!(_local_2)))) {
			_local_2 = createXYZAxes(1);
			_local_2.name = "meatSpaceAxes";
			addChild(_local_2);
		} else {
			if (((!(_arg_1)) && (_local_2))) {
				removeChild(_local_2);
			}
			;
		}
		;
	}

	public function moveRearPlaneToZPosition(_arg_1:Number):void {
		var _local_2:int;
		var _local_3:Boolean;
		var _local_4:Number;
		var _local_5:Number;
		var _local_6:Number;
		var _local_7:Number;
		var _local_8:Number;
		var _local_9:Number;
		this.m_worldZPositionOfRearPlane = _arg_1;
		if (this.m_textWidget) {
			Animate.to(this.m_textWidget, this.m_rearPlane_MoveAnimDuration, 0, {"z": _arg_1}, Animate.SineOut);
		}
		;
		if (this.m_arrowStripWidget) {
			_local_2 = 0;
			while (_local_2 < this.m_arrowStripWidget.length) {
				_local_3 = (_local_2 >= this.m_arrowStripWidget_NumArrows);
				_local_4 = (Number((_local_2 % this.m_arrowStripWidget_NumArrows)) / this.m_arrowStripWidget_NumArrows);
				_local_5 = (_local_4 * this.m_arrowStripWidget_AngularSpan);
				_local_6 = ((_local_5 / 180) * Math.PI);
				_local_7 = (W2P * this.m_arrowStripWidget_WidthSpacing);
				_local_8 = ((W2P * this.m_worldZPositionOfRearPlane) / 2);
				_local_9 = (_local_7 + (_local_8 * Math.sin(_local_6)));
				_arg_1 = (_local_8 * (1 + Math.cos(_local_6)));
				if (_local_3) {
					_local_9 = (_local_9 * -1);
				}
				;
				Animate.to(this.m_arrowStripWidget[_local_2], this.m_rearPlane_MoveAnimDuration, 0, {
					"x": _local_9,
					"z": _arg_1
				}, Animate.SineOut);
				_local_2++;
			}
			;
		}
		;
	}

	public function fadeIn():void {
		Animate.kill(this.m_widgetContainer);
		Animate.to(this.m_widgetContainer, this.m_fadeIn_Duration, this.m_fadeIn_Delay, {"alpha": 1}, Animate.Linear);
	}

	public function fadeOut():void {
		Animate.kill(this.m_widgetContainer);
		Animate.to(this.m_widgetContainer, this.m_fadeOut_Duration, this.m_fadeOut_Delay, {"alpha": 0}, Animate.Linear);
	}

	private function updateCameraWidget():void {
		if (!this.m_cameraWidget) {
			return;
		}
		;
		var _local_1:Number = (W2P * 0.2);
		var _local_2:Number = (W2P * 0.04);
		var _local_3:Number = (W2P * 0.01);
		var _local_4:Number = (W2P * 0.005);
		var _local_5:Number = 0.75;
		var _local_6:uint;
		var _local_7:uint = 0xFFFFFF;
		var _local_8:Graphics = this.m_cameraWidget.graphics;
		_local_8.clear();
		_local_8.lineStyle(_local_4, _local_7);
		_local_8.beginFill(_local_6, _local_5);
		_local_8.drawRect((-(_local_1) / 2), (-(_local_2) / 2), _local_1, _local_2);
		_local_8.endFill();
		_local_8.drawCircle(((-3 * _local_1) / 12), 0, _local_3);
		_local_8.drawCircle(((3 * _local_1) / 12), 0, _local_3);
	}

	private function updateArrowStripWidget():void {
		var _local_1:Shape;
		var _local_3:Boolean;
		var _local_4:Number;
		var _local_5:Number;
		var _local_6:Number;
		var _local_7:Number;
		var _local_8:Number;
		var _local_9:Number;
		var _local_10:Number;
		var _local_11:Number;
		if (!this.m_arrowStripWidget) {
			return;
		}
		;
		if (this.m_arrowStripWidget_NumArrows < 0) {
			this.m_arrowStripWidget_NumArrows = 0;
		}
		;
		while (this.m_arrowStripWidget.length < (2 * this.m_arrowStripWidget_NumArrows)) {
			_local_1 = new Shape();
			this.m_arrowStripWidget.push(_local_1);
			this.m_widgetContainer.addChild(_local_1);
		}
		;
		while (this.m_arrowStripWidget.length > (2 * this.m_arrowStripWidget_NumArrows)) {
			_local_1 = this.m_arrowStripWidget.pop();
			Animate.kill(_local_1);
			this.m_widgetContainer.removeChild(_local_1);
		}
		;
		var _local_2:int;
		while (_local_2 < this.m_arrowStripWidget.length) {
			_local_1 = this.m_arrowStripWidget[_local_2];
			_local_3 = (_local_2 >= this.m_arrowStripWidget_NumArrows);
			_local_4 = (Number((_local_2 % this.m_arrowStripWidget_NumArrows)) / this.m_arrowStripWidget_NumArrows);
			_local_5 = (_local_4 * this.m_arrowStripWidget_AngularSpan);
			_local_6 = ((_local_5 / 180) * Math.PI);
			_local_7 = (W2P * this.m_arrowStripWidget_WidthSpacing);
			_local_8 = (W2P * this.m_arrowStripWidget_ArrowLength);
			_local_9 = (W2P * this.m_arrowStripWidget_ArrowHeight);
			_local_1.graphics.clear();
			drawArrow(_local_1.graphics, _local_8, _local_9);
			_local_10 = 0.5;
			_local_1.alpha = (_local_10 * (1 - _local_4));
			_local_11 = ((W2P * this.m_worldZPositionOfRearPlane) / 2);
			_local_1.x = (_local_7 + (_local_11 * Math.sin(_local_6)));
			_local_1.z = (_local_11 * (1 + Math.cos(_local_6)));
			_local_1.rotationY = (_local_5 + ((0.5 * this.m_arrowStripWidget_AngularSpan) / this.m_arrowStripWidget_NumArrows));
			if (_local_3) {
				_local_1.x = (_local_1.x * -1);
				_local_1.rotationY = (180 - _local_1.rotationY);
			}
			;
			_local_2++;
		}
		;
	}

	private function updateTextWidget():void {
		if (!this.m_textWidget) {
			return;
		}
		;
		this.m_textWidget.width = this.m_textWidget_Width;
		this.m_textWidget.scaleY = this.m_textWidget.scaleX;
	}


}
}//package hud

