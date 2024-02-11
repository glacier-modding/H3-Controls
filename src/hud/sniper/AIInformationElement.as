// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.sniper.AIInformationElement

package hud.sniper {
import common.BaseControl;
import common.Animate;
import common.menu.MenuConstants;
import common.menu.MenuUtils;

import flash.external.ExternalInterface;

public class AIInformationElement extends BaseControl {

	private var m_view:AIInformationElementView;

	public function AIInformationElement() {
		this.m_view = new AIInformationElementView();
		addChild(this.m_view);
		this.m_view.visible = false;
	}

	public function onSetData(_arg_1:Object):void {
		this.showAIinformation(_arg_1.info, String(_arg_1.infoHash));
	}

	public function SetText(_arg_1:String):void {
		this.onSetData(_arg_1);
	}

	public function showText(_arg_1:String, _arg_2:String):void {
		var _local_3:* = "";
		if (_arg_1.length > 0) {
			_local_3 = (_local_3 + _arg_1);
			if (_arg_2.length > 0) {
				_local_3 = (_local_3 + " : ");
			}

		}

		_local_3 = (_local_3 + _arg_2);
		this.onSetData(_local_3);
	}

	public function showAIinformation(_arg_1:String, _arg_2:String):void {
		Animate.kill(this.m_view.overlay);
		this.m_view.overlay.alpha = 1;
		this.m_view.overlay.x = (this.m_view.overlay.y = 0);
		var _local_3:String = MenuConstants.FontColorWhite;
		switch (_arg_2) {
			case "1693438042":
				MenuUtils.setColor(this.m_view.bg, MenuConstants.COLOR_RED);
				_local_3 = MenuConstants.FontColorWhite;
				this.m_view.icons.gotoAndStop(2);
				break;
			case "771211205":
				MenuUtils.setColor(this.m_view.bg, MenuConstants.COLOR_YELLOW);
				_local_3 = MenuConstants.FontColorWhite;
				this.m_view.icons.gotoAndStop(3);
				break;
			case "884078140":
				MenuUtils.setColor(this.m_view.bg, MenuConstants.COLOR_YELLOW);
				_local_3 = MenuConstants.FontColorWhite;
				this.m_view.icons.gotoAndStop(3);
				break;
			case "1237512292":
				MenuUtils.setColor(this.m_view.bg, MenuConstants.COLOR_YELLOW);
				_local_3 = MenuConstants.FontColorWhite;
				this.m_view.icons.gotoAndStop(3);
				break;
			case "-699114243":
				MenuUtils.setColor(this.m_view.bg, MenuConstants.COLOR_YELLOW);
				_local_3 = MenuConstants.FontColorWhite;
				this.m_view.icons.gotoAndStop(3);
				break;
			case "-1549117600":
				MenuUtils.setColor(this.m_view.bg, MenuConstants.COLOR_YELLOW);
				_local_3 = MenuConstants.FontColorWhite;
				this.m_view.icons.gotoAndStop(1);
				break;
			case "-788287662":
				MenuUtils.setColor(this.m_view.bg, MenuConstants.COLOR_GREEN);
				_local_3 = MenuConstants.FontColorWhite;
				this.m_view.icons.gotoAndStop(4);
				break;
		}

		MenuUtils.setupText(this.m_view.info_txt, _arg_1, 18, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
		this.m_view.bg.width = ((45 + this.m_view.info_txt.textWidth) + 12);
		this.m_view.overlay.width = this.m_view.bg.width;
		this.m_view.overlay.height = this.m_view.bg.height;
		this.m_view.overlay.width = (this.m_view.overlay.width + 120);
		var _local_4:Number = (-120 / 2);
		var _local_5:Number = this.m_view.overlay.scaleX;
		this.m_view.overlay.width = this.m_view.bg.width;
		this.m_view.x = (this.m_view.bg.width / -2);
		this.m_view.visible = true;
		this.playSound("AI_Info_Displayed");
		Animate.to(this.m_view.overlay, 0.8, 0, {
			"scaleX": _local_5,
			"x": _local_4,
			"alpha": 0
		}, Animate.ExpoOut);
	}

	public function showTestString():void {
		this.showAIinformation("This is a test", "0");
	}

	public function hideObjectivesBar():void {
		Animate.kill(this.m_view.overlay);
		this.m_view.visible = false;
	}

	public function hideText():void {
		this.hideObjectivesBar();
	}

	public function playSound(_arg_1:String):void {
		ExternalInterface.call("PlaySound", _arg_1);
	}


}
}//package hud.sniper

