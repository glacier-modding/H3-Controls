// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//basic.ButtonPrompt

package basic {
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextFieldAutoSize;

import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.Log;
import common.CommonUtils;

public class ButtonPrompt extends Sprite {

	private var m_promptWidth:Number = 0;
	private var m_buttonPromptImage:ButtonPromptImage;

	public function ButtonPrompt(data:Object, tabsnavigation:Boolean, mouseCallback:Function, xOffset:Number, calculateWidth:Boolean = false) {
		var buttonPromptWidth:Number;
		super();
		var prompt:MenuButtonLegendView = new MenuButtonLegendView();
		this.m_buttonPromptImage = ButtonPromptImage.AcquireInstance();
		this.m_buttonPromptImage.y = 39;
		this.m_buttonPromptImage.alpha = 0.8;
		this.m_buttonPromptImage.platform = ((data.platform) || (ControlsMain.getControllerType()));
		this.setupSymbol(data, this.m_buttonPromptImage);
		if (mouseCallback != null) {
			prompt.addEventListener(MouseEvent.MOUSE_UP, function (_arg_1:MouseEvent):void {
				_arg_1.stopPropagation();
				mouseCallback(data.actiontype);
			}, false, 0, false);
		}
		;
		prompt.addChild(this.m_buttonPromptImage);
		prompt.x = xOffset;
		if (tabsnavigation) {
			prompt.y = 10;
		}
		;
		prompt.header.autoSize = TextFieldAutoSize.LEFT;
		MenuUtils.setupText(prompt.header, data.actionlabel, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		if (calculateWidth == false) {
			this.m_buttonPromptImage.x = 27;
		} else {
			buttonPromptWidth = this.m_buttonPromptImage.getWidth();
			this.setPromptPositions(prompt, this.m_buttonPromptImage, buttonPromptWidth);
			this.m_promptWidth = this.getPromptWidth(prompt, buttonPromptWidth);
		}
		;
		if (((tabsnavigation) && (data.actiontype == "lb"))) {
			prompt.indicator.arrowleft.visible = true;
			prompt.indicator.arrowright.visible = false;
			prompt.indicator.indicatorline.visible = false;
			prompt.indicator.visible = true;
		} else {
			if (((tabsnavigation) && (data.actiontype == "rb"))) {
				prompt.indicator.arrowleft.visible = false;
				prompt.indicator.arrowright.visible = true;
				prompt.indicator.indicatorline.visible = false;
				prompt.indicator.visible = true;
			} else {
				prompt.indicator.arrowleft.visible = false;
				prompt.indicator.arrowright.visible = false;
				prompt.indicator.indicatorline.visible = true;
				prompt.indicator.visible = false;
				if (data.hideIndicator === false) {
					prompt.indicator.visible = true;
				}
				;
			}
			;
		}
		;
		if (data.hidePrompt) {
			prompt.visible = false;
		}
		;
		if (data.transparentPrompt) {
			this.m_buttonPromptImage.alpha = 1;
			prompt.alpha = 0.4;
			prompt.indicator.visible = true;
			prompt.visible = true;
		}
		;
		if (data.disabledPrompt) {
			prompt.alpha = 0.2;
		}
		;
		addChild(prompt);
		if (!calculateWidth) {
			this.m_promptWidth = this.width;
		}
		;
	}

	public static function shouldSkipPrompt(_arg_1:Object):Boolean {
		var _local_3:String;
		var _local_4:String;
		if (_arg_1 == null) {
			return (false);
		}
		;
		var _local_2:Object = _arg_1.customplatform;
		if (_local_2 != null) {
			_local_3 = ((_arg_1.platform) || (ControlsMain.getControllerType()));
			_local_4 = (_local_2.platform as String);
			if (((!(_local_4 == null)) && (_local_4 == _local_3))) {
				if (_local_2.hide === true) {
					return (true);
				}
				;
			}
			;
		}
		;
		return (false);
	}

	private static function getPlatform(_arg_1:Object):String {
		if (((!(_arg_1 == null)) && (!(_arg_1.platform == null)))) {
			return (_arg_1.platform);
		}
		;
		return (ControlsMain.getControllerType());
	}


	public function getWidth():Number {
		return (this.m_promptWidth);
	}

	private function getPromptWidth(_arg_1:MenuButtonLegendView, _arg_2:Number):Number {
		return (_arg_1.header.x + _arg_1.header.width);
	}

	private function setPromptPositions(_arg_1:MenuButtonLegendView, _arg_2:ButtonPromptImage, _arg_3:Number):void {
		var _local_4:Number = 0;
		var _local_5:Number = 5;
		var _local_6:Number = ((_arg_3 / 2) + _local_4);
		_arg_2.x = Math.ceil(_local_6);
		_arg_1.header.x = Math.ceil(((_local_4 + _arg_3) + _local_5));
	}

	public function onUnregister():void {
		this.m_buttonPromptImage.parent.removeChild(this.m_buttonPromptImage);
		removeChildren();
		if (this.m_buttonPromptImage != null) {
			ButtonPromptImage.ReleaseInstance(this.m_buttonPromptImage);
		}
		;
	}

	private function setupSymbol(_arg_1:Object, _arg_2:ButtonPromptImage):void {
		var _local_4:String;
		if (((!(_arg_1.actionglyph == null)) && (_arg_1.actionglyph.length > 0))) {
			_arg_2.customKey = _arg_1.actionglyph;
		} else {
			if (((!(_arg_1.actiontype == null)) && (_arg_1.actiontype.length > 0))) {
				_arg_2.action = _arg_1.actiontype;
			} else {
				Log.xerror(Log.ChannelButtonPrompt, "neither actionglyph nor actiontype were specified");
			}
			;
		}
		;
		var _local_3:Object = _arg_1.customplatform;
		if (_local_3 == null) {
			if ((((CommonUtils.getPlatformString() == CommonUtils.PLATFORM_STADIA) && (_arg_2.platform == CommonUtils.CONTROLLER_TYPE_KEY)) && (_arg_1.actiontype == "cancel"))) {
				_local_3 = new Object();
				_local_3.platform = CommonUtils.CONTROLLER_TYPE_KEY;
				_local_3.actiontype = "kb_tab";
			}
			;
		}
		;
		if (_local_3 != null) {
			_local_4 = (_local_3.platform as String);
			if (((!(_local_4 == null)) && (_local_4 == _arg_2.platform))) {
				if (((!(_local_3.actionglyph == null)) && (_local_3.actionglyph.length > 0))) {
					_arg_2.customKey = _local_3.actionglyph;
				} else {
					if (((!(_local_3.actiontype == null)) && (_local_3.actiontype.length > 0))) {
						_arg_2.action = _local_3.actiontype;
					} else {
						Log.xerror(Log.ChannelButtonPrompt, "data.customplatform specified, but property 'actiontype' or 'actionglyph' not set");
					}
					;
				}
				;
			} else {
				if (((_local_4 == null) || (_local_4.length == 0))) {
					Log.xerror(Log.ChannelButtonPrompt, "data.customplatform specified, but property 'platform' not set");
				}
				;
			}
			;
		}
		;
	}


}
}//package basic

