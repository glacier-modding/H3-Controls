// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.missionend.MissionEndMultiplayerScoreStatistics

package menu3.missionend {
import menu3.MenuElementBase;

import common.menu.MenuConstants;
import common.Animate;

import basic.DottedLine;

import common.menu.MenuUtils;

public dynamic class MissionEndMultiplayerScoreStatistics extends MenuElementBase {

	private var m_view:MissionEndMultiplayerScoreStatisticsView;
	private var m_listElements:Array;

	public function MissionEndMultiplayerScoreStatistics(_arg_1:Object) {
		super(_arg_1);
		this.m_view = new MissionEndMultiplayerScoreStatisticsView();
		this.m_view.line_static.visible = false;
		addChild(this.m_view);
	}

	override public function onSetData(_arg_1:Object):void {
		var _local_2:int;
		var _local_3:MissionEndMultiplayerScoreStatisticsElementView;
		var _local_4:String;
		var _local_5:String;
		var _local_6:String;
		var _local_7:String;
		var _local_8:Number;
		super.onSetData(_arg_1);
		this.m_view.line_static.visible = false;
		this.cleanupElements();
		if (_arg_1.stats != null) {
			_arg_1.stats.reverse();
			this.m_listElements = new Array();
			this.m_view.line_static.visible = true;
			_local_2 = 0;
			while (_local_2 < _arg_1.stats.length) {
				_local_3 = new MissionEndMultiplayerScoreStatisticsElementView();
				this.m_listElements.push(_local_3);
				_local_3.alpha = 0;
				_local_3.y = (493 - (33 * _local_2));
				_local_3.playervalue.x = -231;
				_local_3.opponentvalue.x = 161;
				this.m_view.addChild(_local_3);
				_local_4 = ((_arg_1.stats[_local_2].player1 == null) ? "-" : _arg_1.stats[_local_2].player1);
				_local_5 = ((_arg_1.stats[_local_2].player2 == null) ? "-" : _arg_1.stats[_local_2].player2);
				_local_6 = ((_arg_1.stats[_local_2].player1 == null) ? MenuConstants.FontColorGreyMedium : ((_arg_1.stats[_local_2].player1 >= _arg_1.stats[_local_2].player2) ? MenuConstants.FontColorWhite : MenuConstants.FontColorGreyMedium));
				_local_7 = ((_arg_1.stats[_local_2].player2 == null) ? MenuConstants.FontColorGreyMedium : ((_arg_1.stats[_local_2].player2 >= _arg_1.stats[_local_2].player1) ? MenuConstants.FontColorWhite : MenuConstants.FontColorGreyMedium));
				this.setupStatisticElements(_local_3, _arg_1.stats[_local_2].name, _local_4, _local_5, _local_6, _local_7, ((_local_2 >= 1) ? true : false), _local_2);
				_local_8 = ((462 - (33 * _local_2)) / 100);
				_local_2++;
			}
			;
			Animate.to(this.m_view.line, (0.4 + (_local_2 / 20)), 0, {"scaleY": _local_8}, Animate.ExpoOut);
		}
		;
	}

	private function setupStatisticElements(_arg_1:MissionEndMultiplayerScoreStatisticsElementView, _arg_2:String, _arg_3:String, _arg_4:String, _arg_5:String, _arg_6:String, _arg_7:Boolean, _arg_8:int):void {
		var _local_9:DottedLine;
		MenuUtils.setupTextUpper(_arg_1.title, _arg_2, 20, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		if (_arg_7) {
			_local_9 = new DottedLine(460, MenuConstants.COLOR_GREY_LIGHT, DottedLine.TYPE_HORIZONTAL, 1, 2);
			_local_9.x = (460 / -2);
			_local_9.y = 33;
			_arg_1.addChild(_local_9);
		}
		;
		Animate.offset(_arg_1, 0.4, (_arg_8 / 20), {"y": -33}, Animate.ExpoOut);
		Animate.addTo(_arg_1, 0.4, (_arg_8 / 20), {"alpha": 1}, Animate.ExpoOut);
		if (_arg_3 != "-") {
			MenuUtils.setupText(_arg_1.playervalue, "0", 20, MenuConstants.FONT_TYPE_MEDIUM, _arg_5);
			Animate.fromTo(_arg_1.playervalue, 0.6, (_arg_8 / 20), {"intAnimation": "0"}, {"intAnimation": _arg_3}, Animate.Linear);
		} else {
			MenuUtils.setupText(_arg_1.playervalue, _arg_3, 20, MenuConstants.FONT_TYPE_MEDIUM, _arg_5);
		}
		;
		if (_arg_4 != "-") {
			MenuUtils.setupText(_arg_1.opponentvalue, "0", 20, MenuConstants.FONT_TYPE_MEDIUM, _arg_6);
			Animate.fromTo(_arg_1.opponentvalue, 0.6, (_arg_8 / 20), {"intAnimation": "0"}, {"intAnimation": _arg_4}, Animate.Linear);
		} else {
			MenuUtils.setupText(_arg_1.opponentvalue, _arg_4, 20, MenuConstants.FONT_TYPE_MEDIUM, _arg_6);
		}
		;
	}

	private function cleanupElements():void {
		var _local_1:int;
		Animate.kill(this.m_view.line);
		if (this.m_listElements) {
			_local_1 = 0;
			while (_local_1 < this.m_listElements.length) {
				Animate.kill(this.m_listElements[_local_1]);
				Animate.kill(this.m_listElements[_local_1].playervalue);
				Animate.kill(this.m_listElements[_local_1].opponentvalue);
				this.m_view.removeChild(this.m_listElements[_local_1]);
				_local_1++;
			}
			;
			this.m_listElements = [];
		}
		;
	}

	override public function onUnregister():void {
		if (this.m_view) {
			this.cleanupElements();
			removeChild(this.m_view);
			this.m_view = null;
		}
		;
		super.onUnregister();
	}


}
}//package menu3.missionend

