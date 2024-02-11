// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.OptionsInfo

package menu3.basic {
import menu3.MenuElementTileBase;

import basic.IButtonPromptOwner;

import common.MouseUtil;

import flash.display.Sprite;

import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.Localization;

import basic.ButtonPromtUtil;

import flash.text.TextField;

import common.Animate;

public dynamic class OptionsInfo extends MenuElementTileBase implements IButtonPromptOwner {

	protected var m_view:OptionsInfoView;
	private var m_isActiveButtonPromptOwner:Boolean = false;

	public function OptionsInfo(_arg_1:Object) {
		super(_arg_1);
		m_mouseMode = MouseUtil.MODE_DISABLE;
		this.m_view = new OptionsInfoView();
		addChild(this.m_view);
	}

	override public function onSetData(_arg_1:Object):void {
		var _local_4:Sprite;
		super.onSetData(_arg_1);
		MenuUtils.setupText(this.m_view.title, _arg_1.title, 28, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		var _local_2:String = _arg_1.paragraph;
		if (_arg_1.locaParagraph != null) {
			_local_2 = Localization.get(_arg_1.locaParagraph);
		}
		;
		if (_arg_1.replaceParagraphBreakHeight != null) {
			_local_2 = _local_2.replace(/<br><br>/gi, (('<br><img width="1" height="' + _arg_1.replaceParagraphBreakHeight) + '">'));
		}
		;
		this.m_view.paragraph.height = 725;
		MenuUtils.setupText(this.m_view.paragraph, _local_2, 20, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		MenuUtils.truncateTextfield(this.m_view.title, 1);
		if (_arg_1.useImage) {
			if (_arg_1.imageId) {
				switch (_arg_1.imageId) {
					case "gamma":
						_local_4 = new GammaImageView();
						_local_4.x = 0;
						_local_4.y = ((this.m_view.paragraph.y + this.m_view.paragraph.textHeight) + 15);
						this.m_view.addChild(_local_4);
						break;
					default:
						trace("unhandled case in : ");
				}
				;
			}
			;
		}
		;
		var _local_3:* = (_arg_1.updateButtonPrompts === true);
		if (_local_3 != this.m_isActiveButtonPromptOwner) {
			this.m_isActiveButtonPromptOwner = _local_3;
			if (this.m_isActiveButtonPromptOwner) {
				ButtonPromtUtil.registerButtonPromptOwner(this);
			} else {
				ButtonPromtUtil.unregisterButtonPromptOwner(this);
			}
			;
		}
		;
	}

	override public function addChild2(_arg_1:Sprite, _arg_2:int = -1):void {
		super.addChild2(_arg_1, _arg_2);
		if (getNodeProp(_arg_1, "col") === undefined) {
			if (((!(this.getData().direction == "horizontal")) && (!(this.getData().direction == "horizontalWrap")))) {
				_arg_1.x = 32;
			}
			;
		}
		;
	}

	public function updateButtonPrompts():void {
		var _local_1:Object = getData();
		if (_local_1 != null) {
			this.onSetData(_local_1);
		}
		;
	}

	private function changeTextColor(_arg_1:uint, _arg_2:TextField):void {
		_arg_2.textColor = _arg_1;
	}

	override public function onUnregister():void {
		if (this.m_isActiveButtonPromptOwner) {
			ButtonPromtUtil.unregisterButtonPromptOwner(this);
		}
		;
		if (this.m_view) {
			Animate.kill(this.m_view);
			removeChild(this.m_view);
			this.m_view = null;
		}
		;
		super.onUnregister();
	}


}
}//package menu3.basic

