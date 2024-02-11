// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.ButtonPrompts

package hud {
import common.BaseControl;

import flash.display.Sprite;

import basic.ButtonPromptImage;

import common.menu.MenuUtils;
import common.Localization;
import common.menu.MenuConstants;

public class ButtonPrompts extends BaseControl {

	private var m_promptsContainer:Sprite;

	public function ButtonPrompts() {
		this.m_promptsContainer = new Sprite();
		addChild(this.m_promptsContainer);
	}

	public function onSetData(_arg_1:Object):void {
		var _local_4:MenuButtonLegendViewHUD;
		var _local_5:String;
		var _local_6:Array;
		var _local_7:int;
		var _local_8:Boolean;
		while (this.m_promptsContainer.numChildren > 0) {
			this.m_promptsContainer.removeChildAt(0);
		}
		;
		var _local_2:Number = 0;
		var _local_3:int;
		while (_local_3 < _arg_1.buttonprompts.length) {
			trace(_local_3);
			_local_5 = (_arg_1.buttonprompts[_local_3].actiontype as String);
			_local_6 = (_arg_1.buttonprompts[_local_3].actiontype as Array);
			if (_local_5 != null) {
				_local_4 = this.addPrompt(_arg_1.buttonprompts[_local_3], _local_2);
				_local_2 = (_local_2 + (_local_4.width + 24));
			} else {
				if (_local_6 != null) {
					_local_7 = 0;
					while (_local_7 < _local_6.length) {
						_local_8 = (_local_7 == (_local_6.length - 1));
						_local_4 = this.addPrompt({
							"actiontype": _local_6[_local_7],
							"actionlabel": ((_local_8) ? _arg_1.buttonprompts[_local_3].actionlabel : "")
						}, _local_2);
						_local_2 = (_local_2 + ((_local_8) ? (_local_4.width + 24) : _local_4.button.width));
						_local_7++;
					}
					;
				}
				;
			}
			;
			_local_3++;
		}
		;
	}

	private function addPrompt(_arg_1:Object, _arg_2:Number):MenuButtonLegendViewHUD {
		var _local_3:MenuButtonLegendViewHUD = new MenuButtonLegendViewHUD();
		var _local_4:ButtonPromptImage = new ButtonPromptImage();
		_local_4.x = 27;
		_local_4.y = 49;
		_local_4.platform = ControlsMain.getControllerType();
		_local_4.action = _arg_1.actiontype;
		_local_3.addChild(_local_4);
		_local_3.header.autoSize = "left";
		MenuUtils.setupText(_local_3.header, Localization.get(_arg_1.actionlabel), 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
		_local_3.x = _arg_2;
		this.m_promptsContainer.addChild(_local_3);
		return (_local_3);
	}


}
}//package hud

