﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//basic.GameChatIndicator

package basic {
import common.BaseControl;
import common.Log;
import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.CommonUtils;
import common.Animate;

public class GameChatIndicator extends BaseControl {

	private var m_view:GameChatIndicatorView;
	private var m_aStatusArray:Array = ["TALKING", "NON_TALKING", "MUTED", "RESTRICTED"];

	public function GameChatIndicator() {
		this.m_view = new GameChatIndicatorView();
		this.m_view.bg.alpha = 0.6;
		addChild(this.m_view);
		this.m_view.visible = false;
	}

	public function onSetData(_arg_1:Object):void {
		Log.debugData(this, _arg_1);
		this.hideGameChat();
		if (((_arg_1) && (!(_arg_1 == null)))) {
			this.showGameChat(_arg_1.name, _arg_1.status);
		}

	}

	private function showGameChat(_arg_1:String, _arg_2:String):void {
		MenuUtils.setupText(this.m_view.profilename, _arg_1, 22, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGrey);
		CommonUtils.changeFontToGlobalIfNeeded(this.m_view.profilename);
		MenuUtils.truncateTextfieldWithCharLimit(this.m_view.profilename, 1, MenuConstants.PLAYERNAME_MIN_CHAR_COUNT);
		MenuUtils.shrinkTextToFit(this.m_view.profilename, this.m_view.profilename.width, -1);
		this.m_view.bg.width = ((45 + this.m_view.profilename.textWidth) + 5);
		MenuUtils.removeTint(this.m_view.icon);
		this.m_view.icon.gotoAndStop(_arg_2);
		switch (_arg_2) {
			case "TALKING":
				this.m_view.visible = true;
				return;
			case "NON_TALKING":
				this.m_view.visible = true;
				Animate.delay(this, 2, this.hideGameChat);
				return;
			case "MUTED":
				MenuUtils.setTintColor(this.m_view.icon, MenuUtils.TINT_COLOR_COLOR_GREY_GOTY, false);
				this.m_view.visible = true;
				Animate.delay(this, 2, this.hideGameChat);
				return;
			case "RESTRICTED":
				MenuUtils.setTintColor(this.m_view.icon, MenuUtils.TINT_COLOR_REAL_RED, false);
				this.m_view.visible = true;
				Animate.delay(this, 2, this.hideGameChat);
				return;
			default:
				this.hideGameChat();
		}

	}

	private function hideGameChat():void {
		Animate.kill(this);
		this.m_view.visible = false;
	}

	public function showTestChat():void {
		this.showGameChat("Profile_Name_Test_String", this.m_aStatusArray[MenuUtils.getRandomInRange(0, 3)]);
	}


}
}//package basic

