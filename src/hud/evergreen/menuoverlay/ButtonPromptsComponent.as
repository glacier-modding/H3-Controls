// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.evergreen.menuoverlay.ButtonPromptsComponent

package hud.evergreen.menuoverlay {
import flash.display.Sprite;

import hud.evergreen.IMenuOverlayComponent;

import common.menu.MenuUtils;

import basic.ButtonPromptContainer;

public class ButtonPromptsComponent extends Sprite implements IMenuOverlayComponent {

	public static const DXPADDINGLEFT:Number = 25;
	public static const DYPADDINGTOP:Number = 25;
	public static const DYPROMPTSHEIGHT:Number = 55;

	private var m_promptsWrapper:Sprite = new Sprite();
	private var m_dataLastReceived:Object;
	private var m_prevPromptData:Object;
	private var m_yBottom:Number = 0;

	public function ButtonPromptsComponent() {
		this.m_promptsWrapper.name = "m_promptsWrapper";
		MenuUtils.addDropShadowFilter(this.m_promptsWrapper);
		addChild(this.m_promptsWrapper);
	}

	public function isLeftAligned():Boolean {
		return (true);
	}

	public function onControlLayoutChanged():void {
		this.m_prevPromptData = null;
		this.updatePrompts();
	}

	public function onUsableSizeChanged(_arg_1:Number, _arg_2:Number, _arg_3:Number):void {
		this.m_yBottom = _arg_3;
		this.updateLayout();
	}

	public function onSetData(_arg_1:Object):void {
		var _local_2:Object;
		for each (_local_2 in _arg_1.buttonprompts) {
			if (_local_2.actiontype == "lb_rb") {
				_local_2.actiontype = ["lb", "rb"];
			}
			;
		}
		;
		this.m_dataLastReceived = _arg_1;
		this.updatePrompts();
	}

	private function updatePrompts():void {
		this.m_prevPromptData = MenuUtils.parsePrompts(this.m_dataLastReceived, this.m_prevPromptData, this.m_promptsWrapper);
		var _local_1:ButtonPromptContainer = ButtonPromptContainer(this.m_promptsWrapper.getChildAt(0));
		var _local_2:int;
		var _local_3:int;
		var _local_4:Number = 0;
		while (_local_2 < this.m_dataLastReceived.buttonprompts.length) {
			_local_1.getChildAt(_local_3).x = (_local_1.getChildAt(_local_3).x + _local_4);
			if ((this.m_dataLastReceived.buttonprompts[_local_2].actiontype is Array)) {
				_local_4 = (_local_4 - 36);
				_local_1.getChildAt(++_local_3).x = (_local_1.getChildAt(_local_3).x + _local_4);
			}
			;
			_local_2++;
			_local_3++;
		}
		;
		this.updateLayout();
	}

	private function updateLayout():void {
		var _local_1:Number = 0;
		_local_1 = (_local_1 + DYPADDINGTOP);
		this.m_promptsWrapper.x = DXPADDINGLEFT;
		this.m_promptsWrapper.y = (_local_1 - 25);
		_local_1 = (_local_1 + DYPROMPTSHEIGHT);
		this.y = (this.m_yBottom - _local_1);
	}


}
}//package hud.evergreen.menuoverlay

