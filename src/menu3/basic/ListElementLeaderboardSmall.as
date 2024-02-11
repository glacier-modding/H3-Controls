// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.ListElementLeaderboardSmall

package menu3.basic {
import menu3.containers.CollapsableListContainer;

import common.menu.MenuUtils;
import common.Log;
import common.menu.MenuConstants;
import common.Animate;
import common.CommonUtils;

import flash.text.TextField;
import flash.display.Sprite;

import menu3.MenuElementBase;

public dynamic class ListElementLeaderboardSmall extends CollapsableListContainer {

	private var m_view:ListElementLeaderboardSmallView;
	private var m_pressable:Boolean = true;
	private var m_playernameOrigPosY:Number = 0;

	public function ListElementLeaderboardSmall(_arg_1:Object) {
		super(_arg_1);
		this.m_view = new ListElementLeaderboardSmallView();
		this.m_view.tileSelect.alpha = 0;
		MenuUtils.setTintColor(this.m_view.tileSelect, MenuUtils.TINT_COLOR_RED, false);
		this.m_view.tileDarkBg.alpha = 0;
		this.m_view.tileBg.alpha = 0;
		this.m_view.vr.visible = false;
		addChild(this.m_view);
		this.m_playernameOrigPosY = this.m_view.playername.y;
		setItemSelected(false);
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		Log.debugData(this, _arg_1);
		this.m_pressable = true;
		if (getNodeProp(this, "pressable") === false) {
			this.m_pressable = false;
		}

		if (_arg_1.isPlayer) {
			this.addLine(-0.5);
		} else {
			this.addLine(43.5);
		}

		var _local_2:String = ((_arg_1.isPlayer) ? MenuConstants.FontColorWhite : MenuConstants.FontColorWhite);
		this.m_view.vr.visible = (_arg_1.isVR === true);
		if (_arg_1.infotext) {
			this.setupTextField(this.m_view.infotext, _arg_1.infotext, _local_2, false);
			return;
		}

		if (_arg_1.rank != undefined) {
			this.setupTextField(this.m_view.rank, MenuUtils.formatNumber(_arg_1.rank), _local_2, false);
		}

		if (_arg_1.player) {
			if (_arg_1.player2 != null) {
				this.setupMultipartPlayername(_arg_1.player, _arg_1.player2, _local_2, true);
			} else {
				this.setupTextField(this.m_view.playername, _arg_1.player, _local_2, true);
			}

		}

		if (_arg_1.country) {
			this.setupTextField(this.m_view.country, _arg_1.country, _local_2, false);
		}

		if (_arg_1.score != undefined) {
			this.setupTextField(this.m_view.score, MenuUtils.formatNumber(_arg_1.score), _local_2, false);
		}

		this.handleSelectionChange();
	}

	override public function onUnregister():void {
		super.onUnregister();
		if (this.m_view) {
			Animate.complete(this.m_view.tileSelect);
			removeChild(this.m_view);
			this.m_view = null;
		}

	}

	private function setupTextField(_arg_1:TextField, _arg_2:String, _arg_3:String, _arg_4:Boolean = true):void {
		MenuUtils.setupText(_arg_1, _arg_2, 20, MenuConstants.FONT_TYPE_MEDIUM, _arg_3);
		CommonUtils.changeFontToGlobalIfNeeded(_arg_1);
		if (_arg_4) {
			MenuUtils.truncateTextfield(_arg_1, 1, _arg_3);
		} else {
			MenuUtils.shrinkTextToFit(_arg_1, _arg_1.width, -1);
		}

	}

	private function setupMultipartPlayername(_arg_1:String, _arg_2:String, _arg_3:String, _arg_4:Boolean = true):void {
		this.m_view.playername.y = this.m_playernameOrigPosY;
		var _local_5:String = ((_arg_1 + MenuConstants.PLAYER_MULTIPLAYER_DELIMITER) + _arg_2);
		MenuUtils.setupText(this.m_view.playername, _local_5, 20, MenuConstants.FONT_TYPE_MEDIUM, _arg_3);
		CommonUtils.changeFontToGlobalIfNeeded(this.m_view.playername);
		if (_arg_4) {
			MenuUtils.truncateMultipartTextfield(this.m_view.playername, _arg_1, _arg_2, MenuConstants.PLAYER_MULTIPLAYER_DELIMITER, MenuConstants.PLAYERNAME_MIN_CHAR_COUNT, _arg_3);
		}

		var _local_6:Number = this.m_view.playername.textHeight;
		MenuUtils.shrinkTextToFit(this.m_view.playername, this.m_view.playername.width, -1);
		var _local_7:Number = this.m_view.playername.textHeight;
		if (_local_7 < _local_6) {
			this.m_view.playername.y = (this.m_view.playername.y + ((_local_6 - _local_7) / 2));
		}

	}

	private function changeTextColor(_arg_1:TextField, _arg_2:uint):void {
		_arg_1.textColor = _arg_2;
	}

	private function addLine(_arg_1:Number):void {
		var _local_2:Sprite = new Sprite();
		_local_2.graphics.clear();
		_local_2.graphics.lineStyle(0, MenuConstants.COLOR_WHITE, 0.4);
		_local_2.graphics.moveTo(1, _arg_1);
		_local_2.graphics.lineTo((this.m_view.tileBg.width - 3), _arg_1);
		this.m_view.addChild(_local_2);
	}

	override public function onAddedAsChild(_arg_1:MenuElementBase):void {
		super.onAddedAsChild(_arg_1);
		if (m_parent.getChildElementIndex(this) == 1) {
		}

	}

	override public function addChild2(_arg_1:Sprite, _arg_2:int = -1):void {
		super.addChild2(_arg_1, _arg_2);
		if (getNodeProp(_arg_1, "col") === undefined) {
			if (((!(this.getData().direction == "horizontal")) && (!(this.getData().direction == "horizontalWrap")))) {
				_arg_1.x = 32;
			}

		}

	}

	override public function getView():Sprite {
		return (this.m_view.tileBg);
	}

	override protected function handleSelectionChange():void {
		Animate.kill(this.m_view.tileSelect);
		if (m_loading) {
			return;
		}

		if (m_isSelected) {
			Animate.to(this.m_view.tileSelect, MenuConstants.HiliteTime, 0, {"alpha": 1}, Animate.ExpoOut);
		} else {
			this.m_view.tileSelect.alpha = 0;
		}

	}


}
}//package menu3.basic

