// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.modal.ModalDialogGenericEditLine

package menu3.modal {
import flash.display.Sprite;
import flash.text.TextField;

import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.Animate;
import common.CommonUtils;

public class ModalDialogGenericEditLine extends ModalDialogFrameEdit {

	private const DISABLED_ALPHA:Number = 0.2;

	private var m_viewFrame:Sprite;
	private var m_viewTitle:TextField;
	private var m_viewDescription:TextField;
	private var m_viewSubTitle:TextField;
	private var m_viewInputField:TextField;
	private var m_viewErrorMsg:TextField;
	private var m_viewTileSelect:Sprite;
	private var m_view:ModalDialogGenericView;
	private var m_content:ModalDialogContentEditLineView;
	private var m_useSubTitle:Boolean = false;

	public function ModalDialogGenericEditLine(_arg_1:Object) {
		if (!_arg_1.hasOwnProperty("dialogWidth")) {
			_arg_1.dialogWidth = ModalDialogGeneric.FRAME_WIDTH;
		}
		;
		_arg_1.dialogHeight = ModalDialogGeneric.FRAME_HEIGHT_MIN;
		super(_arg_1);
		this.createView();
	}

	protected function createView():void {
		var _local_1:ModalDialogGenericView = new ModalDialogGenericView();
		this.m_viewTitle = _local_1.title;
		m_maxTitleWidth = this.m_viewTitle.width;
		this.m_viewDescription = _local_1.description;
		this.m_viewFrame = _local_1.bg;
		MenuUtils.setColor(this.m_viewFrame, MenuConstants.COLOR_MENU_SOLID_BACKGROUND, true, 1);
		this.m_view = _local_1;
		addChild(this.m_view);
		this.m_content = new ModalDialogContentEditLineView();
		this.m_viewInputField = this.m_content.description;
		this.m_viewErrorMsg = this.m_content.errormsg;
		this.m_viewTileSelect = this.m_content.tileSelect;
		this.m_viewSubTitle = this.m_content.title;
		MenuUtils.setColor(this.m_viewTileSelect, MenuConstants.COLOR_MENU_BUTTON_TILE_DESELECTED, true, 1);
		this.m_viewTitle.autoSize = "left";
		this.m_viewErrorMsg.autoSize = "left";
		this.m_viewSubTitle.autoSize = "left";
		this.m_viewDescription.autoSize = "left";
		this.m_viewDescription.text = "";
		setInputTextField(this.m_viewInputField);
	}

	override public function onSetData(_arg_1:Object):void {
		var _local_11:Number;
		this.m_useSubTitle = (!(_arg_1.subtitle == null));
		if (_arg_1.hint) {
			MenuUtils.setupText(this.m_viewDescription, _arg_1.hint, 21, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		}
		;
		var _local_2:Number = ((_arg_1.hasOwnProperty("frameheightmax")) ? _arg_1.frameheightmax : ModalDialogGeneric.FRAME_HEIGHT_MAX);
		var _local_3:Number = ((_arg_1.hasOwnProperty("frameheightmin")) ? _arg_1.frameheightmin : ModalDialogGeneric.FRAME_HEIGHT_MIN);
		m_dialogWidth = ((_arg_1.hasOwnProperty("dialogWidth")) ? _arg_1.dialogWidth : ModalDialogGeneric.FRAME_WIDTH);
		this.m_viewFrame.width = m_dialogWidth;
		var _local_4:Number = this.m_viewDescription.x;
		var _local_5:Number = this.m_viewDescription.y;
		var _local_6:Number = _local_4;
		var _local_7:Number = ModalDialogGeneric.FRAME_REST_HEIGHT;
		setupTitle(this.m_viewTitle, _arg_1);
		if (this.m_viewTitle.text.length == 0) {
			_local_7 = (_local_7 - (_local_5 - this.m_viewTitle.y));
			_local_5 = this.m_viewTitle.y;
		}
		;
		createAndAddScrollContainer(_local_4, _local_5, (m_dialogWidth - _local_4), (_local_2 - _local_7), _local_6);
		_arg_1.multiline = false;
		super.onSetData(_arg_1);
		this.m_viewTileSelect.alpha = this.DISABLED_ALPHA;
		if (this.m_viewDescription.text.length > 0) {
			this.m_viewDescription.x = 0;
			this.m_viewDescription.y = 0;
			m_scrollingContainer.append(this.m_viewDescription, false, this.m_viewDescription.height, false);
		}
		;
		setupInformation(_arg_1);
		if (m_scrollingContainer.getContentHeight() > 0) {
			_local_11 = m_scrollingContainer.getScrollDist();
			m_scrollingContainer.addGap(_local_11);
		}
		;
		var _local_8:Boolean;
		if (this.m_viewErrorMsg.text.length == 0) {
			this.m_viewErrorMsg.text = "ForSizeCheck";
			_local_8 = true;
		}
		;
		var _local_9:Number = ((_arg_1.compacterrorline === true) ? 30 : 0);
		m_scrollingContainer.append(this.m_content, false, (this.m_content.height - _local_9), false);
		if (_local_8) {
			this.m_viewErrorMsg.text = "";
		}
		;
		var _local_10:Number = (Math.ceil(m_scrollingContainer.getContentHeight()) + _local_7);
		m_dialogHeight = updateDialogHeight(_local_10, _local_3, _local_2);
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
		;
	}

	override protected function setTitle(_arg_1:String):void {
		super.setTitle(_arg_1);
		var _local_2:Number = -1;
		var _local_3:Number = 20;
		var _local_4:Number = 12;
		if (this.m_useSubTitle) {
			MenuUtils.setupTextAndShrinkToFit(this.m_viewSubTitle, _arg_1, 20, MenuConstants.FONT_TYPE_BOLD, m_maxTitleWidth, _local_2, _local_4, MenuConstants.FontColorWhite);
		} else {
			MenuUtils.setupTextAndShrinkToFit(this.m_viewTitle, _arg_1, 48, MenuConstants.FONT_TYPE_BOLD, m_maxTitleWidth, _local_2, _local_3, MenuConstants.FontColorWhite);
		}
		;
	}

	override protected function setInputFieldText(_arg_1:String):void {
		super.setInputFieldText(_arg_1);
		_arg_1 = MenuUtils.convertToEscapedHtmlString(_arg_1);
		MenuUtils.setupText(this.m_viewInputField, _arg_1, 21, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		CommonUtils.changeFontToGlobalIfNeeded(this.m_viewInputField);
	}

	override protected function setErrorMessage(_arg_1:ModalDialogValidation):void {
		super.setErrorMessage(_arg_1);
		if (_arg_1 == null) {
			this.m_viewErrorMsg.text = "";
			return;
		}
		;
		var _local_2:String = _arg_1.getMessage();
		if (((_local_2 == null) || (_local_2.length <= 0))) {
			this.m_viewErrorMsg.text = "";
			return;
		}
		;
		switch (_arg_1.getLevel()) {
			case 1:
				MenuUtils.setupText(this.m_viewErrorMsg, _local_2, 21, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorRed);
				return;
			default:
				MenuUtils.setupText(this.m_viewErrorMsg, _local_2, 21, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		}
		;
	}


}
}//package menu3.modal

