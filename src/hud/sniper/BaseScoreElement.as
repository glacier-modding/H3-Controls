// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.sniper.BaseScoreElement

package hud.sniper {
import common.BaseControl;
import common.Animate;
import common.menu.MenuUtils;
import common.menu.MenuConstants;

import flash.external.ExternalInterface;

public class BaseScoreElement extends BaseControl {

	private var m_view:BaseScoreElementView;
	private var m_previousScore:int = 0;
	private var m_scoreStackArray:Array = new Array();
	private var m_scoreAnimatingArray:Array = new Array();
	private var m_scoreStackCount:int = 1;

	public function BaseScoreElement() {
		this.m_view = new BaseScoreElementView();
		addChild(this.m_view);
		this.hideText();
	}

	public function onSetData(_arg_1:Object):void {
		this.showText(_arg_1.title, _arg_1.body);
	}

	public function showText(_arg_1:String, _arg_2:String):void {
		var _local_3:BaseScoreElementTextView = new BaseScoreElementTextView();
		this.m_view.scorecontainer.addChild(_local_3);
		var _local_4:int = int(_arg_2);
		var _local_5:int = (_local_4 - this.m_previousScore);
		var _local_6:Number = 1;
		if (_local_5 < 0) {
			_local_6 = 0.8;
		} else {
			if (((_local_5 >= 0) && (_local_5 <= 1000))) {
				_local_6 = 1.2;
			} else {
				if (((_local_5 > 1000) && (_local_5 <= 2000))) {
					_local_6 = 1.4;
				} else {
					if (((_local_5 > 2000) && (_local_5 <= 3000))) {
						_local_6 = 1.7;
					} else {
						if (_local_5 > 3000) {
							_local_6 = 2;
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
		this.m_scoreStackArray.push({
			"theClip": _local_3,
			"previousScore": this.m_previousScore,
			"currentScore": _local_4,
			"scoreDifference": _local_5,
			"scaleValue": _local_6
		});
		this.delayAnimation();
		this.m_previousScore = _local_4;
		this.setVisible(true);
	}

	private function delayAnimation():void {
		var scoreObject:Object;
		var delay:Number = (((0.6 + (this.m_scoreStackArray.length * 0.1)) + ((0.4 + 0.3) + (this.m_scoreStackArray.length * 0.2))) + 0.4);
		scoreObject = this.m_scoreStackArray[(this.m_scoreStackArray.length - 1)];
		Animate.delay(scoreObject.theClip, delay, function ():void {
			startAnimation(scoreObject);
		});
	}

	private function startAnimation(scoreObject:Object):void {
		var currentScore:int;
		var oldScoreObject:Object;
		var offsetX:Number;
		this.m_scoreAnimatingArray.push(scoreObject);
		if (this.m_scoreAnimatingArray.length >= 2) {
			oldScoreObject = this.m_scoreAnimatingArray.shift();
			this.m_scoreStackArray.shift();
			Animate.kill(oldScoreObject.theClip.score_txt);
			Animate.kill(oldScoreObject.theClip);
			this.m_view.scorecontainer.removeChild(oldScoreObject.theClip);
			oldScoreObject.theClip = null;
		}
		;
		var previousScoreString:String = String(scoreObject.previousScore);
		var currentScoreString:String = String(scoreObject.currentScore);
		currentScore = scoreObject.currentScore;
		MenuUtils.setupText(scoreObject.theClip.score_txt, previousScoreString, 18, MenuConstants.FONT_TYPE_BOLD, ((scoreObject.scoreDifference < 0) ? MenuConstants.FontColorRed : MenuConstants.FontColorWhite));
		if (scoreObject.scoreDifference != 0) {
			offsetX = (((scoreObject.theClip.score_txt.textWidth * scoreObject.scaleValue) - scoreObject.theClip.score_txt.textWidth) / 2);
			this.playSound("ScoreStartUpdate");
			Animate.fromTo(scoreObject.theClip.score_txt, 0.6, 0, {"intAnimation": previousScoreString}, {"intAnimation": currentScoreString}, Animate.ExpoOut, function ():void {
				MenuUtils.setupText(scoreObject.theClip.score_txt, MenuUtils.formatNumber(currentScore), 18, MenuConstants.FONT_TYPE_BOLD, ((currentScore < 0) ? MenuConstants.FontColorRed : MenuConstants.FontColorWhite));
				m_scoreStackArray.shift();
				playSound("ScoreStopUpdate");
			});
			Animate.fromTo(scoreObject.theClip, 0.6, 0, {
				"scaleX": scoreObject.scaleValue,
				"scaleY": scoreObject.scaleValue,
				"x": offsetX
			}, {
				"scaleX": 1,
				"scaleY": 1,
				"x": 0
			}, Animate.ExpoOut);
		} else {
			this.m_scoreStackArray.shift();
		}
		;
	}

	public function hideText():void {
		this.m_view.visible = false;
	}

	private function setVisible(_arg_1:Boolean):void {
		this.m_view.visible = _arg_1;
	}

	public function playSound(_arg_1:String):void {
		ExternalInterface.call("PlaySound", _arg_1);
	}


}
}//package hud.sniper

