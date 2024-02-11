// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.modal.ModalDialogGenericEditText

package menu3.modal {
import flash.display.Sprite;
import flash.text.TextField;

import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.Animate;
import common.CommonUtils;

public class ModalDialogGenericEditText extends ModalDialogFrameEdit {

	private const DISABLED_ALPHA:Number = 0.2;

	private var m_viewFrame:Sprite;
	private var m_viewTitle:TextField;
	private var m_viewInputField:TextField;
	private var m_viewTileSelect:Sprite;
	private var m_view:ModalDialogGenericView;
	private var m_content:ModalDialogContentEditTextView;

	public function ModalDialogGenericEditText(_arg_1:Object) {
		_arg_1.dialogWidth = ModalDialogGeneric.FRAME_WIDTH;
		_arg_1.dialogHeight = ModalDialogGeneric.FRAME_HEIGHT_MIN;
		super(_arg_1);
		this.createView();
	}

	protected function createView():void {
		var _local_1:ModalDialogGenericView = new ModalDialogGenericView();
		this.m_viewTitle = _local_1.title;
		m_maxTitleWidth = this.m_viewTitle.width;
		this.m_viewFrame = _local_1.bg;
		MenuUtils.setColor(this.m_viewFrame, MenuConstants.COLOR_MENU_SOLID_BACKGROUND, true, 1);
		this.m_view = _local_1;
		addChild(this.m_view);
		this.m_content = new ModalDialogContentEditTextView();
		this.m_viewInputField = this.m_content.description;
		this.m_viewTileSelect = this.m_content.tileSelect;
		MenuUtils.setColor(this.m_viewTileSelect, MenuConstants.COLOR_MENU_BUTTON_TILE_DESELECTED, true, 1);
		addChild(this.m_content);
		this.m_viewTitle.autoSize = "left";
		var _local_2:Number = _local_1.description.x;
		var _local_3:Number = _local_1.description.y;
		_local_1.description.visible = false;
		this.m_content.x = _local_2;
		this.m_content.y = _local_3;
		setInputTextField(this.m_viewInputField);
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		this.m_viewTileSelect.alpha = this.DISABLED_ALPHA;
		var _local_2:Number = (Math.ceil(this.m_content.height) + ModalDialogGeneric.FRAME_REST_HEIGHT);
		m_dialogHeight = updateDialogHeight(_local_2, ModalDialogGeneric.FRAME_HEIGHT_MIN, ModalDialogGeneric.FRAME_HEIGHT_MAX);
		this.m_viewFrame.height = m_dialogHeight;
	}

	override protected function setItemSelected(_arg_1:Boolean):void {
		super.setItemSelected(_arg_1);
		Animate.kill(this.m_viewTileSelect);
		if (_arg_1) {
			Animate.legacyTo(this.m_viewTileSelect, MenuConstants.HiliteTime, {"alpha": 1}, Animate.Linear);
		} else {
			this.m_viewTileSelect.alpha = this.DISABLED_ALPHA;
		}

	}

	override protected function setTitle(_arg_1:String):void {
		super.setTitle(_arg_1);
		var _local_2:Number = -1;
		var _local_3:Number = 20;
		MenuUtils.setupTextAndShrinkToFit(this.m_viewTitle, _arg_1, 48, MenuConstants.FONT_TYPE_BOLD, m_maxTitleWidth, _local_2, _local_3, MenuConstants.FontColorWhite);
	}

	override protected function setInputFieldText(_arg_1:String):void {
		super.setInputFieldText(_arg_1);
		_arg_1 = MenuUtils.convertToEscapedHtmlString(_arg_1);
		MenuUtils.setupText(this.m_viewInputField, _arg_1, 21, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		CommonUtils.changeFontToGlobalIfNeeded(this.m_viewInputField);
	}


}
}//package menu3.modal

