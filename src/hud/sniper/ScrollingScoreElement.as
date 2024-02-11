// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.sniper.ScrollingScoreElement

package hud.sniper {
import common.BaseControl;

import flash.display.Sprite;

import common.menu.MenuConstants;
import common.menu.MenuUtils;
import common.Animate;

import flash.external.ExternalInterface;

public class ScrollingScoreElement extends BaseControl {

	private var m_elementYOffset:int = 26;
	private var m_elementsArray:Array;
	private var m_scrollingContainer:Sprite;
	private var m_staticContainer:Sprite;

	public function ScrollingScoreElement() {
		this.m_staticContainer = new Sprite();
		this.m_staticContainer.y = -(this.m_elementYOffset);
		addChild(this.m_staticContainer);
		this.m_scrollingContainer = new Sprite();
		this.m_scrollingContainer.y = (this.m_elementYOffset * 21);
		addChild(this.m_scrollingContainer);
		this.m_elementsArray = new Array();
	}

	public function onSetData(_arg_1:Object):void {
		var _local_7:String;
		if (_arg_1 == null) {
			return;
		}
		;
		if (_arg_1.type == 12) {
			return;
		}
		;
		var _local_2:String = ((_arg_1.point >= 0) ? "+" : "-");
		var _local_3:String = String(Math.abs(_arg_1.point));
		var _local_4:String = ((((_arg_1.name + "     ") + _local_2) + " ") + _local_3);
		var _local_5:ScrollingScoreElementView = new ScrollingScoreElementView();
		var _local_6:String = MenuConstants.FontColorWhite;
		switch (true) {
			case (_arg_1.point < 0):
				_local_7 = "fail";
				break;
			case ((_arg_1.point >= 0) && (_arg_1.point < 2000)):
				_local_7 = "common";
				break;
			case ((_arg_1.point >= 2000) && (_arg_1.point < 4000)):
				_local_7 = "fair";
				break;
			case ((_arg_1.point >= 4000) && (_arg_1.point < 5000)):
				_local_7 = "good";
				break;
			case (_arg_1.point >= 5000):
				_local_7 = "awesome";
				break;
			default:
				_local_7 = "common";
		}
		;
		switch (_arg_1.type) {
			case 3:
				_local_6 = MenuConstants.FontColorRed;
				break;
			case 7:
				_local_6 = MenuConstants.FontColorYellow;
				break;
			case 8:
				_local_6 = MenuConstants.FontColorYellow;
				break;
			case 9:
				_local_6 = MenuConstants.FontColorYellow;
				break;
			case 10:
				_local_6 = MenuConstants.FontColorGreen;
				break;
			case 11:
				_local_6 = MenuConstants.FontColorGreen;
				break;
			default:
				_local_6 = MenuConstants.FontColorWhite;
		}
		;
		MenuUtils.setupText(_local_5.score_mc.score_txt, _local_4, 18, MenuConstants.FONT_TYPE_MEDIUM, _local_6);
		_local_5.score_mc.alpha = 0.8;
		_local_5.alpha = 0;
		_local_5.y = ((this.m_elementsArray.length * this.m_elementYOffset) - (this.m_elementYOffset * 20));
		var _local_8:int;
		var _local_9:int;
		while (_local_9 < this.m_elementsArray.length) {
			if (this.m_elementsArray[_local_9].isactive) {
				_local_8 = (_local_8 + 1);
			}
			;
			_local_9++;
		}
		;
		_local_5.elementdelaynum = _local_8;
		_local_5.levelOfAwesomeness = _local_7;
		_local_5.isactive = true;
		this.m_elementsArray.push(_local_5);
		this.m_scrollingContainer.addChild(_local_5);
		this.scoreAnimFlowStart(_local_5);
	}

	private function scoreAnimFlowStart(_arg_1:ScrollingScoreElementView):void {
		Animate.offset(_arg_1, 0.6, (_arg_1.elementdelaynum * 0.1), {"y": -(this.m_elementYOffset)}, Animate.ExpoOut, this.scoreAnimFlowPop, _arg_1);
		Animate.addTo(_arg_1, 0.6, (_arg_1.elementdelaynum * 0.1), {"alpha": 1}, Animate.ExpoOut);
	}

	private function scoreAnimFlowPop(_arg_1:ScrollingScoreElementView):void {
		if (_arg_1.levelOfAwesomeness == "fail") {
			this.playSound("ScoreFail");
		} else {
			if (_arg_1.levelOfAwesomeness == "common") {
				this.playSound("ScoreCommon");
				Animate.to(_arg_1.score_mc, 0.4, 0, {"alpha": 1}, Animate.ExpoOut);
			} else {
				if (_arg_1.levelOfAwesomeness == "fair") {
					this.playSound("ScoreFair");
					Animate.to(_arg_1.score_mc, 0.4, 0, {"alpha": 1}, Animate.ExpoOut);
				} else {
					if (_arg_1.levelOfAwesomeness == "good") {
						this.playSound("ScoreGood");
						Animate.to(_arg_1.score_mc, 0.4, 0, {"alpha": 1}, Animate.ExpoOut);
					} else {
						if (_arg_1.levelOfAwesomeness == "awesome") {
							this.playSound("ScoreAwesome");
							Animate.to(_arg_1.score_mc, 0.4, 0, {
								"alpha": 1,
								"scaleX": 1.05,
								"scaleY": 1.05
							}, Animate.ExpoOut);
						}
						;
					}
					;
				}
				;
			}
			;
		}
		;
		Animate.offset(_arg_1, 0.4, (0.3 + (_arg_1.elementdelaynum * 0.2)), {"y": -(this.m_elementYOffset)}, Animate.ExpoIn, this.scoreAnimFlowSwipe, _arg_1);
	}

	private function scoreAnimFlowSwipe(_arg_1:ScrollingScoreElementView):void {
		this.m_scrollingContainer.removeChild(_arg_1);
		this.m_staticContainer.addChild(_arg_1);
		_arg_1.y = 0;
		Animate.to(_arg_1, 0.4, 0, {
			"x": 800,
			"y": (-(this.m_elementYOffset) * 2),
			"alpha": 0
		}, Animate.ExpoIn, this.scoreAnimFlowFinish, _arg_1);
		Animate.offset(this.m_scrollingContainer, 0.2, 0, {"y": -(this.m_elementYOffset)}, Animate.ExpoOut);
	}

	private function scoreAnimFlowFinish(_arg_1:ScrollingScoreElementView):void {
		Animate.kill(_arg_1);
		_arg_1.isactive = false;
		var _local_2:int;
		while (_local_2 < this.m_elementsArray.length) {
			if (this.m_elementsArray[_local_2].isactive) {
				return;
			}
			;
			_local_2++;
		}
		;
		this.m_elementsArray = [];
		this.m_scrollingContainer.y = (this.m_elementYOffset * 21);
		while (this.m_staticContainer.numChildren > 0) {
			this.m_staticContainer.removeChildAt(0);
		}
		;
	}

	public function playSound(_arg_1:String):void {
		ExternalInterface.call("PlaySound", _arg_1);
	}

	public function testScrollingScoreElement():void {
		var _local_1:int;
		while (_local_1 < 4) {
			this.onSetData({
				"type": 6,
				"point": 1000,
				"name": ("Test Wipe 0" + _local_1)
			});
			_local_1++;
		}
		;
	}


}
}//package hud.sniper

