// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.versus.scoring.ActionXpBarElement

package hud.versus.scoring {
import hud.notification.NotificationListener;

import flash.display.Sprite;

import common.menu.MenuConstants;
import common.menu.MenuUtils;
import common.Animate;

import flash.external.ExternalInterface;

public class ActionXpBarElement extends NotificationListener {

	private var m_container:Sprite;
	private var m_view:ActionXpBarView;
	private var m_elementYOffset:int = 33;
	private var m_elementCount:int = 0;
	private var m_yposArray:Array;

	public function ActionXpBarElement() {
		this.m_container = new Sprite();
		this.m_container.y = (this.m_elementYOffset * 20);
		addChild(this.m_container);
		this.m_yposArray = [];
	}

	override public function ShowNotification(_arg_1:String, _arg_2:String, _arg_3:Object):void {
		var _local_9:String;
		var _local_4:ActionXpBarView = new ActionXpBarView();
		_local_4.header.autoSize = "left";
		_local_4.value.autoSize = "left";
		var _local_5:String = ((_arg_3.xpGain <= 0) ? _arg_2 : (_arg_2 + "     +"));
		var _local_6:String = ((_arg_3.xpGain <= 0) ? MenuConstants.FontColorRed : MenuConstants.FontColorWhite);
		_local_6 = ((_arg_3.isRepeated) ? MenuConstants.FontColorGreyMedium : _local_6);
		MenuUtils.setupTextUpper(_local_4.header, _local_5, 18, MenuConstants.FONT_TYPE_MEDIUM, _local_6);
		MenuUtils.setupTextUpper(_local_4.info.infotxt, ((_arg_3.additionaldescription != null) ? MenuUtils.removeHtmlLineBreaks(_arg_3.additionaldescription) : ""), 18, MenuConstants.FONT_TYPE_MEDIUM, _local_6);
		_local_4.info.scaleX = (_local_4.info.scaleY = 0);
		_local_4.info.alpha = 0;
		MenuUtils.setupText(_local_4.value, ((_arg_3.xpGain <= 0) ? "" : String(_arg_3.xpGain)), 18, MenuConstants.FONT_TYPE_MEDIUM, _local_6);
		var _local_7:int = Math.floor((_local_4.header.textWidth + _local_4.value.textWidth));
		var _local_8:int = Math.floor(_local_4.value.textWidth);
		_local_4.header.x = (Math.floor(_local_4.header.textWidth) / -2);
		_local_4.value.x = ((_local_7 / 2) - _local_8);
		MenuUtils.setupTextUpper(_local_4.header, _arg_2, 18, MenuConstants.FONT_TYPE_MEDIUM, _local_6);
		MenuUtils.setupText(_local_4.value, "", 18, MenuConstants.FONT_TYPE_MEDIUM, _local_6);
		_local_4.bg.alpha = 0;
		_local_4.bg.width = (_local_7 + 40);
		_local_4.alpha = 0;
		switch (true) {
			case (_arg_3.xpGain <= 0):
				_local_9 = "fail";
				break;
			case ((_arg_3.xpGain > 0) && (_arg_3.xpGain < 100)):
				_local_9 = "common";
				break;
			case ((_arg_3.xpGain >= 100) && (_arg_3.xpGain < 200)):
				_local_9 = "fair";
				break;
			case ((_arg_3.xpGain >= 200) && (_arg_3.xpGain < 300)):
				_local_9 = "good";
				break;
			case ((_arg_3.xpGain >= 300) && (_arg_3.xpGain < 400)):
				_local_9 = "excellent";
				break;
			case (_arg_3.xpGain >= 400):
				_local_9 = "awesome";
				break;
			default:
				_local_9 = "common";
		}

		var _local_10:int = (this.m_yposArray[(this.m_yposArray.length - 1)] + this.m_elementYOffset);
		this.m_yposArray.push((_local_10 + ((_arg_3.additionaldescription != null) ? 26 : 0)));
		_local_4.y = (_local_10 - (this.m_elementYOffset * 20));
		this.m_container.addChild(_local_4);
		var _local_11:Object = {
			"element": _local_4,
			"elementindex": this.m_yposArray.length,
			"description": _local_5,
			"xpgain": _arg_3.xpGain,
			"headerxoffset": (_local_7 / -2),
			"awesomeness": _local_9,
			"fontColor": _local_6,
			"isRepeated": _arg_3.isRepeated
		};
		this.startAnimation(_local_11);
	}

	private function startAnimation(_arg_1:Object):void {
		Animate.kill(_arg_1.element);
		Animate.offset(_arg_1.element, 0.6, (_arg_1.elementindex * 0.1), {"y": -(this.m_elementYOffset)}, Animate.ExpoOut, this.endAnimation, _arg_1);
		Animate.addTo(_arg_1.element, 0.6, (_arg_1.elementindex * 0.1), {"alpha": 1}, Animate.ExpoOut);
		if (this.m_yposArray.length >= 2) {
			Animate.offset(this.m_container, 0.2, 0, {"y": -(this.m_elementYOffset)}, Animate.ExpoOut);
		}

	}

	private function endAnimation(_arg_1:Object):void {
		Animate.kill(_arg_1.element);
		Animate.kill(_arg_1.element.bg);
		Animate.to(_arg_1.element.header, 0.2, 0, {"x": _arg_1.headerxoffset}, Animate.ExpoOut);
		MenuUtils.setupTextUpper(_arg_1.element.header, _arg_1.description, 18, MenuConstants.FONT_TYPE_MEDIUM, _arg_1.fontColor);
		Animate.to(_arg_1.element.info, 0.2, 0.2, {
			"alpha": 1,
			"scaleX": 1,
			"scaleY": 1
		}, Animate.ExpoOut);
		var _local_2:Number = (_arg_1.xpgain / 500);
		if (_arg_1.xpgain > 0) {
			Animate.fromTo(_arg_1.element.value, _local_2, 0, {"intAnimation": "0"}, {"intAnimation": String(_arg_1.xpgain)}, Animate.ExpoOut);
		}

		var _local_3:Number = (_arg_1.element.bg.scaleX + 0.6);
		var _local_4:Number = 0;
		if (_arg_1.awesomeness == "common") {
			this.playSound("ScoreCommon");
			_local_4 = 0.3;
		} else {
			if (_arg_1.awesomeness == "fair") {
				this.playSound("ScoreFair");
				_local_4 = 0.6;
			} else {
				if (_arg_1.awesomeness == "good") {
					this.playSound("ScoreGood");
					_local_4 = 0.8;
				} else {
					if (_arg_1.awesomeness == "excellent") {
						this.playSound("ScoreGood");
						_local_4 = 0.8;
					} else {
						if (_arg_1.awesomeness == "awesome") {
							this.playSound("ScoreAwesome");
							_local_4 = 1;
						} else {
							if (_arg_1.awesomeness == "fail") {
								this.playSound("ScoreFail");
								MenuUtils.setTintColor(_arg_1.element.bg, MenuUtils.TINT_COLOR_MAGENTA_DARK, false);
							}

						}

					}

				}

			}

		}

		if (!_arg_1.isRepeated) {
			_arg_1.element.bg.alpha = _local_4;
			Animate.to(_arg_1.element.bg, 0.8, 0, {
				"scaleX": _local_3,
				"alpha": 0
			}, Animate.ExpoOut);
		}

		Animate.offset(_arg_1.element, 0.4, (0.8 + (_arg_1.elementindex * 0.1)), {"y": (_arg_1.elementindex * -(this.m_elementYOffset))}, Animate.ExpoIn, this.finishAnimation, _arg_1.element);
	}

	private function finishAnimation(_arg_1:ActionXpBarView):void {
		Animate.kill(_arg_1);
		this.m_yposArray.shift();
		if (this.m_yposArray.length == 0) {
			this.m_container.y = (this.m_elementYOffset * 20);
		}

		this.m_container.removeChild(_arg_1);
		_arg_1 = null;
	}

	public function playSound(_arg_1:String):void {
		ExternalInterface.call("PlaySound", _arg_1);
	}


}
}//package hud.versus.scoring

