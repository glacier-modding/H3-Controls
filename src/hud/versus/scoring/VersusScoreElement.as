// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.versus.scoring.VersusScoreElement

package hud.versus.scoring {
import common.BaseControl;
import common.Log;
import common.menu.MenuUtils;
import common.menu.MenuConstants;

import flash.text.TextFieldAutoSize;

import common.Animate;
import common.Localization;

import flash.external.ExternalInterface;

public class VersusScoreElement extends BaseControl {

	private var m_playerScoreElement:PlayerScoreElementView;
	private var m_opponentScoreElement:OpponentScoreElementView;
	private var m_unnoticedKillElement:UnnoticedKillElement;
	private var m_initPreScoreTimeUpdate:Boolean = true;
	private var m_currentPlayerScore:Number = -1;
	private var m_currentOpponentScore:Number = -1;

	public function VersusScoreElement() {
		this.m_playerScoreElement = new PlayerScoreElementView();
		this.m_opponentScoreElement = new OpponentScoreElementView();
		this.m_unnoticedKillElement = new UnnoticedKillElement();
		addChild(this.m_playerScoreElement);
		addChild(this.m_opponentScoreElement);
		addChild(this.m_unnoticedKillElement);
		this.m_playerScoreElement.visible = false;
		this.m_opponentScoreElement.visible = false;
		this.m_unnoticedKillElement.visible = false;
		this.m_playerScoreElement.x = -2;
		this.m_opponentScoreElement.x = 2;
		this.m_unnoticedKillElement.y = 76;
	}

	public function onSetData(_arg_1:Object):void {
		var _local_3:int;
		var _local_4:Number;
		Log.debugData(this, _arg_1);
		var _local_2:Array = _arg_1.players;
		if (_local_2 != null) {
			_local_3 = 0;
			while (_local_3 < _local_2.length) {
				if (_local_2[_local_3].isPlayer) {
					this.m_playerScoreElement.visible = true;
					if (_local_2[_local_3].playername != null) {
						if (_local_2[_local_3].playername != "") {
							MenuUtils.setupText(this.m_playerScoreElement.nameLabel, _local_2[_local_3].playername, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
							this.m_playerScoreElement.nameLabel.autoSize = TextFieldAutoSize.RIGHT;
						}

					}

					this.updatePlayerScore(_local_2[_local_3].score);
				} else {
					this.m_opponentScoreElement.visible = true;
					if (_local_2[_local_3].playername != null) {
						if (_local_2[_local_3].playername != "") {
							MenuUtils.setupText(this.m_opponentScoreElement.nameLabel, _local_2[_local_3].playername, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
							this.m_opponentScoreElement.nameLabel.autoSize = TextFieldAutoSize.LEFT;
						}

					}

					this.updateOpponentScore(_local_2[_local_3].score);
				}

				_local_3++;
			}

			_local_4 = ((this.m_playerScoreElement.nameLabel.width >= this.m_opponentScoreElement.nameLabel.width) ? this.m_playerScoreElement.nameLabel.width : this.m_opponentScoreElement.nameLabel.width);
			this.m_playerScoreElement.bgMc.width = (this.m_opponentScoreElement.bgMc.width = (100 + _local_4));
		}

	}

	private function updatePlayerScore(_arg_1:Number):void {
		if (_arg_1 == this.m_currentPlayerScore) {
			return;
		}

		MenuUtils.setupText(this.m_playerScoreElement.scoreMc.scoreLabel, _arg_1.toString(), 43, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
		if (_arg_1 > 0) {
			Animate.fromTo(this.m_playerScoreElement.scoreMc, 0.2, 0, {
				"scaleX": 2,
				"scaleY": 2
			}, {
				"scaleX": 1,
				"scaleY": 1
			}, Animate.ExpoOut);
		}

		this.m_currentPlayerScore = _arg_1;
	}

	private function updateOpponentScore(_arg_1:Number):void {
		if (_arg_1 == this.m_currentOpponentScore) {
			return;
		}

		MenuUtils.setupText(this.m_opponentScoreElement.scoreMc.scoreLabel, _arg_1.toString(), 43, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
		if (_arg_1 > 0) {
			Animate.fromTo(this.m_opponentScoreElement.scoreMc, 0.2, 0, {
				"scaleX": 2,
				"scaleY": 2
			}, {
				"scaleX": 1,
				"scaleY": 1
			}, Animate.ExpoOut);
		}

		this.m_currentOpponentScore = _arg_1;
	}

	public function updatePreScoreTimer(_arg_1:Object):void {
		var _local_4:Object;
		var _local_2:Boolean = _arg_1.IsMe;
		var _local_3:Number = _arg_1.TimeLeft;
		if (_local_2) {
			if (_local_3 > 0) {
				if (this.m_initPreScoreTimeUpdate) {
					this.m_initPreScoreTimeUpdate = false;
					_local_4 = {
						"header": Localization.get("UI_HUD_VS_UNNOTICED_KILL_TIMER"),
						"time": _local_3
					};
					this.m_unnoticedKillElement.visible = true;
					this.m_unnoticedKillElement.onSetData(_local_4);
				} else {
					this.m_unnoticedKillElement.update(_local_3);
				}

			} else {
				this.m_unnoticedKillElement.hide();
				this.m_initPreScoreTimeUpdate = true;
			}

		}

	}

	public function playSound(_arg_1:String):void {
		ExternalInterface.call("PlaySound", _arg_1);
	}


}
}//package hud.versus.scoring

