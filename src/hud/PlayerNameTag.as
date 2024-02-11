// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.PlayerNameTag

package hud {
import common.BaseControl;

import flash.display.Shape;

import common.Log;
import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.CommonUtils;

public class PlayerNameTag extends BaseControl {

	private var m_view:PlayerNameTagView;
	private var m_teamColor:Shape;
	private var m_displayTeamColor:Boolean = true;
	private var m_teamIconOffsetX:Number = 0;
	private var m_teamIconOffsetY:Number = 0;
	private var m_teamIconSize:Number = 30;

	public function PlayerNameTag() {
		this.m_view = new PlayerNameTagView();
		this.m_view.bg.alpha = 0.6;
		this.m_view.visible = false;
		addChild(this.m_view);
		this.m_teamColor = new Shape();
		this.updateTeamColor(0);
		this.m_teamColor.visible = false;
		addChild(this.m_teamColor);
	}

	public function onSetData(_arg_1:Object):void {
		var _local_2:Number;
		var _local_3:Number;
		var _local_4:Number;
		var _local_5:uint;
		this.updateName(_arg_1.name);
		Log.info(Log.ChannelVideo, this, ("PlayerNameTag data:" + _arg_1));
		if (_arg_1.team_color) {
			_local_2 = (_arg_1.team_color.r * 0xFF);
			_local_3 = (_arg_1.team_color.g * 0xFF);
			_local_4 = (_arg_1.team_color.b * 0xFF);
			_local_5 = (((_local_2 << 16) | (_local_3 << 8)) | _local_4);
			this.updateTeamColor(_local_5);
		} else {
			this.m_teamColor.visible = false;
		}

	}

	public function set DisplayTeamColor(_arg_1:Boolean):void {
		this.m_displayTeamColor = _arg_1;
		this.m_teamColor.visible = this.m_displayTeamColor;
	}

	public function set TeamIconOffsetX(_arg_1:Number):void {
		this.m_teamIconOffsetX = _arg_1;
		this.updateTeamColorPos();
	}

	public function set TeamIconOffsetY(_arg_1:Number):void {
		this.m_teamIconOffsetY = _arg_1;
		this.updateTeamColorPos();
	}

	public function set TeamIconSize(_arg_1:Number):void {
		this.m_teamIconSize = _arg_1;
		this.updateTeamColorPos();
	}

	private function updateName(_arg_1:String):void {
		if (_arg_1 == "") {
			this.m_view.visible = false;
			return;
		}

		this.m_view.visible = true;
		MenuUtils.setupText(this.m_view.profilename, _arg_1, 22, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGrey);
		CommonUtils.changeFontToGlobalIfNeeded(this.m_view.profilename);
		MenuUtils.truncateTextfieldWithCharLimit(this.m_view.profilename, 1, MenuConstants.PLAYERNAME_MIN_CHAR_COUNT);
		MenuUtils.shrinkTextToFit(this.m_view.profilename, this.m_view.profilename.width, -1);
		this.m_view.bg.width = (this.m_view.profilename.textWidth + 10);
	}

	private function updateTeamColorPos():void {
		this.m_teamColor.x = this.m_teamIconOffsetX;
		this.m_teamColor.y = this.m_teamIconOffsetY;
		this.m_teamColor.x = (this.m_teamColor.x - (this.m_teamIconSize / 4));
		this.m_teamColor.y = (this.m_teamColor.y - (this.m_teamIconSize / 2));
	}

	private function updateTeamColor(_arg_1:uint):void {
		this.m_teamColor.graphics.clear();
		this.m_teamColor.graphics.lineStyle(1, _arg_1);
		this.m_teamColor.graphics.beginFill(_arg_1);
		this.m_teamColor.graphics.moveTo((this.m_teamIconSize / 2), 0);
		this.m_teamColor.graphics.lineTo(this.m_teamIconSize, this.m_teamIconSize);
		this.m_teamColor.graphics.lineTo(0, this.m_teamIconSize);
		this.m_teamColor.graphics.lineTo((this.m_teamIconSize / 2), 0);
		this.m_teamColor.visible = this.m_displayTeamColor;
		this.updateTeamColorPos();
	}


}
}//package hud

