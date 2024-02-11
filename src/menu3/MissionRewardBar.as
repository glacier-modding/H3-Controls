// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.MissionRewardBar

package menu3 {
import common.Animate;
import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.Log;

import flash.display.MovieClip;

import common.Localization;

import flash.external.ExternalInterface;
import flash.text.TextFieldAutoSize;
import flash.text.TextField;

public class MissionRewardBar {

	private const ANIMATION_DIR_IN:String = "in";
	private const ANIMATION_DIR_OUT:String = "out";

	private var m_view:Object;
	private var m_levelPointsAccum:Array;
	private var m_levelMaxed:Boolean = false;
	private var m_startXPDisp:Number;
	private var m_endXPDisp:Number;
	private var m_barRatio:Number;
	private var m_displayLevel:Number;
	private var m_last_level:Number;
	private var m_last_barScale:Number;

	public function MissionRewardBar(_arg_1:Object) {
		this.m_view = _arg_1;
	}

	public function init(_arg_1:Array):void {
		this.m_view.mastery_txt.visible = false;
		this.m_view.xpnum_txt.visible = false;
		this.m_view.masteryLevelMc.visible = false;
		this.m_view.masteryBarFrameMc.visible = false;
		this.m_view.masteryBarFrameMc.top.scaleY = 0;
		this.m_view.masteryBarFrameMc.bottom.scaleY = 0;
		this.m_view.masteryBarFrameMc.left.scaleY = 0;
		this.m_view.masteryBarFrameMc.right.scaleY = 0;
		this.m_view.masteryBarFillMc.visible = false;
		this.m_view.masteryBarFillMc.scaleX = 0;
		if (_arg_1 != null) {
			this.m_levelPointsAccum = _arg_1;
		}

	}

	public function onUnregister():void {
		Animate.kill(this.m_view);
		Animate.kill(this.m_view.xpnum_txt);
		this.m_view = null;
	}

	public function animateShowBar():void {
		this.m_view.masteryBarFrameMc.visible = true;
		this.m_view.masteryBarFillMc.visible = true;
		Animate.delay(this.m_view.masteryBarFrameMc, 0.4, this.animateMasteryBar, this.ANIMATION_DIR_IN, this.m_view.masteryBarFrameMc.left, 0.2, Animate.ExpoOut);
		Animate.delay(this.m_view.masteryBarFrameMc, 0.45, this.animateMasteryBar, this.ANIMATION_DIR_IN, this.m_view.masteryBarFrameMc.top, 0.3, Animate.ExpoIn);
		Animate.delay(this.m_view.masteryBarFrameMc, 0.48, this.animateMasteryBar, this.ANIMATION_DIR_IN, this.m_view.masteryBarFrameMc.bottom, 0.3, Animate.ExpoIn, true);
		Animate.delay(this.m_view.masteryBarFrameMc, 0.95, this.animateMasteryBar, this.ANIMATION_DIR_IN, this.m_view.masteryBarFrameMc.right, 0.2, Animate.ExpoOut);
	}

	public function animateHideBar():void {
		Animate.to(this.m_view.masteryBarFillMc, 0.3, 0, {"scaleX": 0}, Animate.ExpoOut, function ():void {
			m_view.masteryBarFillMc.alpha = 0;
		});
		Animate.to(this.m_view.mastery_txt, 0.2, 0, {
			"alpha": 0,
			"y": (this.m_view.mastery_txt.y + 10)
		}, Animate.ExpoOut);
		Animate.to(this.m_view.xpnum_txt, 0.4, 0, {
			"alpha": 0,
			"x": (this.m_view.xpnum_txt.x - 15)
		}, Animate.ExpoOut);
		Animate.delay(this.m_view.masteryBarFrameMc, 0, this.animateMasteryBar, this.ANIMATION_DIR_OUT, this.m_view.masteryBarFrameMc.right, 0.1, Animate.ExpoOut);
		Animate.delay(this.m_view.masteryBarFrameMc, 0.1, this.animateMasteryBar, this.ANIMATION_DIR_OUT, this.m_view.masteryBarFrameMc.bottom, 0.15, Animate.ExpoIn);
		Animate.delay(this.m_view.masteryBarFrameMc, 0.1, this.animateMasteryBar, this.ANIMATION_DIR_OUT, this.m_view.masteryBarFrameMc.top, 0.15, Animate.ExpoIn);
		Animate.delay(this.m_view.masteryBarFrameMc, 0.25, this.animateMasteryBar, this.ANIMATION_DIR_OUT, this.m_view.masteryBarFrameMc.left, 0.1, Animate.ExpoOut, true);
	}

	public function setXpValues(_arg_1:Number, _arg_2:Number, _arg_3:String):void {
		this.m_startXPDisp = _arg_1;
		this.m_endXPDisp = _arg_2;
		this.m_levelMaxed = this.isLevelMaxed(this.m_startXPDisp);
		this.m_displayLevel = Math.floor(this.getLevelFromList(this.m_startXPDisp));
		this.m_last_level = this.m_displayLevel;
		MenuUtils.setupText(this.m_view.mastery_txt, _arg_3, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyDark);
	}

	public function getLevelFromList(_arg_1:Number):Number {
		if (!this.m_levelPointsAccum) {
			return (1);
		}

		var _local_2:int = this.m_levelPointsAccum.length;
		var _local_3:Number = 0;
		var _local_4:int;
		while (_local_4 < _local_2) {
			if (_arg_1 > this.m_levelPointsAccum[_local_4]) {
				_local_3 = _local_4;
			} else {
				break;
			}

			_local_4++;
		}

		var _local_5:Number = (_arg_1 - this.m_levelPointsAccum[_local_3]);
		var _local_6:Number = 0;
		if (_local_3 < (_local_2 - 1)) {
			_local_6 = (_local_5 / (this.m_levelPointsAccum[(_local_3 + 1)] - this.m_levelPointsAccum[_local_3]));
		}

		return ((_local_3 + 1) + _local_6);
	}

	public function isLevelMaxed(_arg_1:Number):Boolean {
		var _local_2:int = (this.m_levelPointsAccum.length - 1);
		if (_arg_1 >= this.m_levelPointsAccum[_local_2]) {
			return (true);
		}

		return (false);
	}

	private function animateMasteryBar(_arg_1:String, _arg_2:MovieClip, _arg_3:Number, _arg_4:int, _arg_5:Boolean = false):void {
		switch (_arg_1) {
			case this.ANIMATION_DIR_IN:
				if (_arg_5) {
					Animate.legacyTo(_arg_2, _arg_3, {"scaleY": 1}, _arg_4, this.onMasteryBarInComplete, null);
				} else {
					Animate.legacyTo(_arg_2, _arg_3, {"scaleY": 1}, _arg_4);
				}

				return;
			case this.ANIMATION_DIR_OUT:
				if (_arg_5) {
					Animate.legacyTo(_arg_2, _arg_3, {"scaleY": 0}, _arg_4, this.onMasteryBarOutComplete, null);
				} else {
					Animate.legacyTo(_arg_2, _arg_3, {"scaleY": 0}, _arg_4);
				}

				return;
			default:
				Log.info(Log.ChannelCommon, this, ("MissionRewardBar --> unhandled case in animateMasteryBar(): " + _arg_1));
		}

	}

	private function onMasteryBarInComplete(_arg_1:*):void {
		this.initXPBar();
	}

	private function onMasteryBarOutComplete(_arg_1:*):void {
	}

	public function showXPLeft():void {
		if (this.m_levelMaxed) {
			return;
		}

		this.m_view.xpnum_txt.visible = true;
		this.m_view.xpnum_txt.alpha = 0;
		this.m_view.xpnum_txt.x = (this.m_view.xpnum_txt.x - 15);
		Animate.legacyTo(this.m_view.xpnum_txt, 0.5, {
			"alpha": 1,
			"x": (this.m_view.xpnum_txt.x + 15)
		}, Animate.ExpoOut);
	}

	private function initXPBar():void {
		if (this.m_levelMaxed) {
			Animate.legacyTo(this.m_view.masteryBarFillMc, 0.3, {"scaleX": 1}, Animate.ExpoOut);
			this.m_last_barScale = 1;
		} else {
			this.m_barRatio = (this.getLevelFromList(this.m_startXPDisp) - this.m_displayLevel);
			this.m_last_barScale = this.m_barRatio;
			Animate.legacyTo(this.m_view.masteryBarFillMc, 0.3, {"scaleX": this.m_barRatio}, Animate.ExpoOut);
		}

		this.updateXPFields();
		this.m_view.mastery_txt.visible = true;
		this.m_view.mastery_txt.alpha = 0;
		this.m_view.mastery_txt.y = (this.m_view.mastery_txt.y + 15);
		Animate.legacyTo(this.m_view.mastery_txt, 0.3, {
			"alpha": 1,
			"y": (this.m_view.mastery_txt.y - 15)
		}, Animate.ExpoOut);
		this.m_view.masteryLevelMc.visible = true;
		this.m_view.masteryLevelMc.alpha = 0;
		this.m_view.masteryLevelMc.scaleX = 0;
		this.m_view.masteryLevelMc.scaleY = 0;
		Animate.legacyTo(this.m_view.masteryLevelMc, 0.4, {
			"alpha": 1,
			"scaleX": 1,
			"scaleY": 1
		}, Animate.ExpoOut);
		var _local_1:String = ((String(this.m_displayLevel) + "/") + String(this.m_levelPointsAccum.length));
		MenuUtils.setupText(this.m_view.masteryLevelMc.label_txt, _local_1, 30, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyDark);
	}

	public function updateXPBar(xpGain:Number):void {
		var oldXP:Number;
		oldXP = this.m_startXPDisp;
		this.m_startXPDisp = (this.m_startXPDisp + xpGain);
		this.m_startXPDisp = Math.min(this.m_startXPDisp, this.m_endXPDisp);
		this.m_displayLevel = Math.floor(this.getLevelFromList(this.m_startXPDisp));
		this.m_levelMaxed = this.isLevelMaxed(this.m_startXPDisp);
		Animate.delay(this.m_view, 0.3, function ():void {
			if (m_levelMaxed) {
				Animate.legacyTo(m_view.masteryBarFillMc, 0.3, {"scaleX": 1}, Animate.ExpoOut);
			} else {
				m_barRatio = (getLevelFromList(m_startXPDisp) - m_displayLevel);
				if (m_startXPDisp > oldXP) {
					if (m_barRatio > m_last_barScale) {
						Animate.legacyTo(m_view.masteryBarFillMc, 0.3, {"scaleX": m_barRatio}, Animate.ExpoOut);
					} else {
						Animate.legacyTo(m_view.masteryBarFillMc, 0.3, {"scaleX": 1}, Animate.ExpoOut, function ():void {
							m_view.masteryBarFillMc.scaleX = 0;
							Animate.legacyTo(m_view.masteryBarFillMc, 0.2, {"scaleX": m_barRatio}, Animate.ExpoIn);
						});
					}

				}

				m_last_barScale = m_barRatio;
			}

			updateXPFields();
		});
	}

	private function updateXPFields():void {
		var points:Number;
		var pointsToNextLevel:String;
		if (this.m_displayLevel > this.m_last_level) {
			this.playSound("LevelUp");
			Animate.legacyTo(this.m_view.masteryLevelMc, 0.3, {
				"alpha": 0,
				"scaleX": 0,
				"scaleY": 0
			}, Animate.ExpoOut);
			Animate.delay(this.m_view.masteryLevelMc, 0.2, function ():void {
				m_view.masteryLevelMc.alpha = 0;
				m_view.masteryLevelMc.scaleX = 2;
				m_view.masteryLevelMc.scaleY = 2;
				var _local_1:String = ((String(m_displayLevel) + "/") + String(m_levelPointsAccum.length));
				MenuUtils.setupText(m_view.masteryLevelMc.label_txt, _local_1, 30, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyDark);
				Animate.legacyTo(m_view.masteryLevelMc, 0.4, {
					"alpha": 1,
					"scaleX": 1,
					"scaleY": 1
				}, Animate.ExpoOut);
			});
		}

		this.m_last_level = this.m_displayLevel;
		if (this.m_startXPDisp > this.m_levelPointsAccum[(this.m_levelPointsAccum.length - 1)]) {
			MenuUtils.setupText(this.m_view.xpnum_txt, "", 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyDark);
		} else {
			if (!this.m_levelMaxed) {
				points = (this.m_levelPointsAccum[this.m_displayLevel] - this.m_startXPDisp);
				pointsToNextLevel = Localization.get("UI_MENU_PAGE_REWARD_POINTS_TO_NEXT_LEVEL").replace("{p}", points);
				MenuUtils.setupText(this.m_view.xpnum_txt, pointsToNextLevel, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyDark);
			}

			this.textFieldAutosize(this.m_view.xpnum_txt);
			this.m_view.xpnum_txt.x = ((this.m_view.masteryBarFrameMc.x + this.m_view.masteryBarFrameMc.width) - this.m_view.xpnum_txt.width);
		}

	}

	private function playSound(_arg_1:String):void {
		ExternalInterface.call("PlaySound", _arg_1);
	}

	private function textFieldAutosize(tf:TextField):void {
		var tempHeight:Number;
		var padding:Number;
		try {
			padding = 2;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tempHeight = tf.height;
			tf.autoSize = TextFieldAutoSize.NONE;
			tf.height = (tempHeight + padding);
		} catch (error:Error) {
			trace(("[TextFieldAutosize] " + error));
		}

	}


}
}//package menu3

