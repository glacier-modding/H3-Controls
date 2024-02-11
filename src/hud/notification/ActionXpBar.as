// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.notification.ActionXpBar

package hud.notification {
import flash.display.Sprite;

import __AS3__.vec.Vector;

import common.Localization;
import common.menu.MenuConstants;
import common.menu.MenuUtils;
import common.Animate;

import flash.external.ExternalInterface;

import __AS3__.vec.*;

public class ActionXpBar extends NotificationListener {

	private var m_container:Sprite;
	private var m_view:ActionXpBarView;
	private var m_elementYOffset:int = 33;
	private var m_elementCount:int = 0;
	private var m_yposArray:Array;
	private var m_elementsAvailable:Vector.<ActionXpBarView> = new Vector.<ActionXpBarView>();
	private var m_soundEnabled:Boolean;
	private var m_VR_YOffsetFactor:int = 2;
	private var m_strPerformanceMasteryXP:String = Localization.get("UI_PERFORMANCE_MASTERY_XP").toUpperCase();

	public function ActionXpBar() {
		if (!ControlsMain.isVrModeActive()) {
			this.m_VR_YOffsetFactor = 0;
		}

		this.m_container = new Sprite();
		this.m_container.y = (this.m_elementYOffset * 20);
		addChild(this.m_container);
		this.m_container.x = -2;
		this.m_yposArray = [];
		var _local_1:uint = 3;
		var _local_2:Vector.<ActionXpBarView> = new Vector.<ActionXpBarView>();
		while (_local_2.length < _local_1) {
			_local_2.push(this.acquireElement());
		}

		while (_local_2.length > 0) {
			this.releaseElement(_local_2.pop());
		}

	}

	override public function ShowNotification(_arg_1:String, _arg_2:String, _arg_3:Object):void {
		var _local_9:String;
		_arg_2 = _arg_2.toUpperCase();
		var _local_4:ActionXpBarView = this.acquireElement();
		var _local_5:String = ((_arg_3.xpGain <= 0) ? _arg_2 : (_arg_2 + "     +"));
		var _local_6:int = ((_arg_3.isRepeated) ? MenuConstants.COLOR_GREY_MEDIUM : ((_arg_3.xpGain <= 0) ? MenuConstants.COLOR_RED : MenuConstants.COLOR_WHITE));
		MenuUtils.setTextColor(_local_4.header, _local_6);
		MenuUtils.setTextColor(_local_4.info.infotxt, _local_6);
		MenuUtils.setTextColor(_local_4.value, _local_6);
		_local_4.header.text = _local_5;
		_local_4.info.infotxt.text = ((_arg_3.additionaldescription != null) ? MenuUtils.removeHtmlLineBreaks(_arg_3.additionaldescription).toUpperCase() : "");
		_local_4.value.text = ((_arg_3.xpGain <= 0) ? "" : ((String(_arg_3.xpGain) + " ") + this.m_strPerformanceMasteryXP));
		_local_4.info.scaleX = (_local_4.info.scaleY = 0);
		_local_4.info.alpha = 0;
		var _local_7:int = Math.floor((_local_4.header.textWidth + _local_4.value.textWidth));
		var _local_8:int = Math.floor(_local_4.value.textWidth);
		_local_4.header.text = _arg_2;
		_local_4.header.x = (Math.floor(_local_4.header.textWidth) / -2);
		_local_4.value.x = ((_local_7 / 2) - _local_8);
		_local_4.value.text = "";
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
		_local_4.y = (_local_10 - (this.m_elementYOffset * (20 + this.m_VR_YOffsetFactor)));
		var _local_11:Object = {
			"element": _local_4,
			"elementindex": this.m_yposArray.length,
			"description": _local_5,
			"xpgain": _arg_3.xpGain,
			"headerxoffset": (_local_7 / -2),
			"awesomeness": _local_9,
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

	private function endAnimation(actionXpElementData:Object):void {
		Animate.kill(actionXpElementData.element);
		Animate.kill(actionXpElementData.element.bg);
		Animate.to(actionXpElementData.element.header, 0.2, 0, {"x": actionXpElementData.headerxoffset}, Animate.ExpoOut);
		actionXpElementData.element.header.text = actionXpElementData.description;
		Animate.to(actionXpElementData.element.info, 0.2, 0.2, {
			"alpha": 1,
			"scaleX": 1,
			"scaleY": 1
		}, Animate.ExpoOut);
		var speed:Number = (actionXpElementData.xpgain / 500);
		if (actionXpElementData.xpgain > 0) {
			Animate.fromTo(actionXpElementData.element.value, speed, 0, {"intAnimation": 0}, {"intAnimation": actionXpElementData.xpgain}, Animate.ExpoOut, function ():void {
				actionXpElementData.element.value.text = ((String(actionXpElementData.xpgain) + " ") + m_strPerformanceMasteryXP);
			});
		}

		var scaleFactorX:Number = (actionXpElementData.element.bg.scaleX + 0.6);
		var bgAlpha:Number = 0;
		if (actionXpElementData.awesomeness == "common") {
			this.playSound("ScoreCommon");
			bgAlpha = 0.3;
		} else {
			if (actionXpElementData.awesomeness == "fair") {
				this.playSound("ScoreFair");
				bgAlpha = 0.6;
			} else {
				if (actionXpElementData.awesomeness == "good") {
					this.playSound("ScoreGood");
					bgAlpha = 0.8;
				} else {
					if (actionXpElementData.awesomeness == "excellent") {
						this.playSound("ScoreGood");
						bgAlpha = 0.8;
					} else {
						if (actionXpElementData.awesomeness == "awesome") {
							this.playSound("ScoreAwesome");
							bgAlpha = 1;
						} else {
							if (actionXpElementData.awesomeness == "fail") {
								this.playSound("ScoreFail");
								MenuUtils.setTintColor(actionXpElementData.element.bg, MenuUtils.TINT_COLOR_MAGENTA_DARK, false);
							}

						}

					}

				}

			}

		}

		if (!actionXpElementData.isRepeated) {
			actionXpElementData.element.bg.alpha = bgAlpha;
			Animate.to(actionXpElementData.element.bg, 0.8, 0, {
				"scaleX": scaleFactorX,
				"alpha": 0
			}, Animate.ExpoOut);
		}

		Animate.offset(actionXpElementData.element, 0.4, (0.8 + (actionXpElementData.elementindex * 0.1)), {"y": (actionXpElementData.elementindex * (this.m_elementYOffset * -4))}, Animate.ExpoIn, this.finishAnimation, actionXpElementData.element);
	}

	private function finishAnimation(_arg_1:ActionXpBarView):void {
		Animate.kill(_arg_1);
		this.m_yposArray.shift();
		if (this.m_yposArray.length == 0) {
			this.m_container.y = (this.m_elementYOffset * 20);
		}

		this.releaseElement(_arg_1);
	}

	public function playSound(_arg_1:String):void {
		if (!this.m_soundEnabled) {
			return;
		}

		ExternalInterface.call("PlaySound", _arg_1);
	}

	public function SetSoundEnabled(_arg_1:Boolean):void {
		this.m_soundEnabled = _arg_1;
	}

	public function testActionXPBar():void {
		var _local_4:Boolean;
		var _local_1:Object = {
			"xpGain": 500,
			"isRepeated": false
		};
		var _local_2:Object = {
			"xpGain": 0,
			"isRepeated": false
		};
		var _local_3:int;
		while (_local_3 < 7) {
			_local_4 = ((Math.random() > 0.5) ? true : false);
			this.ShowNotification("Wuss", "MMMMMMMM MMMMMMMM", ((_local_4) ? _local_1 : _local_2));
			_local_3++;
		}

	}

	private function acquireElement():ActionXpBarView {
		var _local_1:ActionXpBarView;
		if (this.m_elementsAvailable.length > 0) {
			_local_1 = this.m_elementsAvailable.pop();
			_local_1.visible = true;
		} else {
			_local_1 = new ActionXpBarView();
			_local_1.header.autoSize = "left";
			_local_1.value.autoSize = "left";
			MenuUtils.setupText(_local_1.header, "", 18, MenuConstants.FONT_TYPE_MEDIUM);
			MenuUtils.setupText(_local_1.info.infotxt, "", 18, MenuConstants.FONT_TYPE_MEDIUM);
			MenuUtils.setupText(_local_1.value, "", 18, MenuConstants.FONT_TYPE_MEDIUM);
			this.m_container.addChild(_local_1);
		}

		return (_local_1);
	}

	private function releaseElement(_arg_1:ActionXpBarView):void {
		MenuUtils.removeTint(_arg_1.bg);
		_arg_1.visible = false;
		this.m_elementsAvailable.push(_arg_1);
	}


}
}//package hud.notification

