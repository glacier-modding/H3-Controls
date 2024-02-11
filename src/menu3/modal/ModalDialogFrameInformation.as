// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.modal.ModalDialogFrameInformation

package menu3.modal {
import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.CommonUtils;

import flash.text.TextField;

public class ModalDialogFrameInformation extends ModalDialogFrame {

	protected var m_scrollingContainer:ModalScrollingContainer;
	protected var m_maxTitleWidth:Number = 0;

	public function ModalDialogFrameInformation(_arg_1:Object) {
		super(_arg_1);
	}

	override public function onScroll(_arg_1:Number, _arg_2:Boolean):void {
		super.onScroll(_arg_1, _arg_2);
		if (this.m_scrollingContainer == null) {
			return;
		}

		this.m_scrollingContainer.scroll(_arg_1, _arg_2);
	}

	override public function onFadeInFinished():void {
		super.onFadeInFinished();
		if (this.m_scrollingContainer == null) {
			return;
		}

		this.m_scrollingContainer.onFadeInFinished();
	}

	protected function setupTitle(_arg_1:TextField, _arg_2:Object):void {
		var _local_4:Number;
		var _local_5:Number;
		var _local_3:* = "";
		if (_arg_2.category) {
			_local_3 = _arg_2.category;
		}

		if (_arg_2.title) {
			if (_local_3.length > 0) {
				_local_3 = (_local_3 + " | ");
			}

			_local_3 = (_local_3 + _arg_2.title);
		}

		if (_local_3.length > 0) {
			if (this.m_maxTitleWidth <= 0) {
				this.m_maxTitleWidth = _arg_1.width;
			}

			_local_4 = -1;
			_local_5 = 20;
			MenuUtils.setupTextAndShrinkToFitUpper(_arg_1, _local_3, 48, MenuConstants.FONT_TYPE_BOLD, this.m_maxTitleWidth, _local_4, _local_5, MenuConstants.FontColorWhite);
			CommonUtils.changeFontToGlobalIfNeeded(_arg_1);
		}

	}

	protected function setupDescription(_arg_1:TextField, _arg_2:Object):void {
		if (_arg_2.description) {
			this.setupText(_arg_1, _arg_2.description);
		}

	}

	protected function setupText(_arg_1:TextField, _arg_2:String):void {
		MenuUtils.setupText(_arg_1, _arg_2, 21, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		CommonUtils.changeFontToGlobalIfNeeded(_arg_1);
	}

	protected function setupInformation(_arg_1:Object):void {
		if (_arg_1.information) {
			ModalContentInformation.createContent(this.m_scrollingContainer, _arg_1.information);
		}

	}

	protected function destroyInformation():void {
		var _local_2:ModalDialogContentInfoElementBase;
		var _local_1:int;
		while (_local_1 < this.m_scrollingContainer.numChildren) {
			_local_2 = (this.m_scrollingContainer.getChildAt(_local_1) as ModalDialogContentInfoElementBase);
			if (_local_2 != null) {
				_local_2.destroy();
			}

			_local_1++;
		}

		this.m_scrollingContainer.removeChildren();
		this.m_scrollingContainer.onUnregister();
	}

	protected function createAndAddScrollContainer(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number):void {
		var _local_6:Boolean = true;
		this.m_scrollingContainer = new ModalScrollingContainer(_arg_3, _arg_4, _arg_5, _local_6);
		addChild(this.m_scrollingContainer);
		this.m_scrollingContainer.x = _arg_1;
		this.m_scrollingContainer.y = _arg_2;
		addMouseWheelEventListener(this.m_scrollingContainer);
	}


}
}//package menu3.modal

