// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.OptionsInfoInteractionPromptSize

package menu3.basic {
import flash.text.TextField;

import common.menu.MenuConstants;
import common.CommonUtils;
import common.menu.MenuUtils;

public dynamic class OptionsInfoInteractionPromptSize extends OptionsInfo {

	private var m_customTextFieldLabel:TextField;
	private var m_customTextFieldDesc:TextField;

	public function OptionsInfoInteractionPromptSize(_arg_1:Object) {
		super(_arg_1);
	}

	override public function onSetData(_arg_1:Object):void {
		this.cleanupTextfield();
		super.onSetData(_arg_1);
		var _local_2:int = MenuConstants.INTERACTIONPROMPTSIZE_DEFAULT;
		if (((!(_arg_1.uioptionname == null)) && (_arg_1.uioptionname.length > 0))) {
			_local_2 = CommonUtils.getUIOptionValueNumber(_arg_1.uioptionname);
		}
		;
		var _local_3:Object = MenuConstants.InteractionIndicatorFontSpecs[_local_2];
		if (((!(_arg_1.customtext == null)) && (_arg_1.customtext.length > 0))) {
			this.m_customTextFieldLabel = this.setupTextfield(_arg_1.customtext, _local_3.fontSizeLabel, _local_3.yOffsetLabel, (_local_3.fScaleGroup * _local_3.fScaleIndividual), MenuConstants.FONT_TYPE_BOLD);
			this.m_customTextFieldDesc = this.setupTextfield(_arg_1.customtext, _local_3.fontSizeDesc, _local_3.yOffsetDesc, (_local_3.fScaleGroup * _local_3.fScaleIndividual), MenuConstants.FONT_TYPE_NORMAL);
			this.m_customTextFieldLabel.name = "m_customTextFieldLabel";
			this.m_customTextFieldDesc.name = "m_customTextFieldDesc";
		}
		;
	}

	override public function onUnregister():void {
		this.cleanupTextfield();
		super.onUnregister();
	}

	private function cleanupTextfield():void {
		if (this.m_customTextFieldLabel != null) {
			m_view.removeChild(this.m_customTextFieldLabel);
			this.m_customTextFieldLabel = null;
		}
		;
		if (this.m_customTextFieldDesc != null) {
			m_view.removeChild(this.m_customTextFieldDesc);
			this.m_customTextFieldDesc = null;
		}
		;
	}

	private function setupTextfield(_arg_1:String, _arg_2:int, _arg_3:int, _arg_4:Number, _arg_5:String):TextField {
		var _local_6:TextField = new TextField();
		_local_6.multiline = true;
		_local_6.wordWrap = true;
		_local_6.width = m_view.paragraph.width;
		_local_6.height = m_view.paragraph.height;
		_local_6.x = 0;
		_local_6.y = (((m_view.paragraph.y + m_view.paragraph.textHeight) + 70) + (_arg_3 * _arg_4));
		_local_6.scaleX = _arg_4;
		_local_6.scaleY = _arg_4;
		m_view.addChild(_local_6);
		MenuUtils.setupTextUpper(_local_6, _arg_1, _arg_2, _arg_5, MenuConstants.FontColorWhite);
		return (_local_6);
	}


}
}//package menu3.basic

