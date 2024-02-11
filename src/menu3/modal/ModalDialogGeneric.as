// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.modal.ModalDialogGeneric

package menu3.modal {
import flash.text.TextField;
import flash.display.Sprite;

import common.menu.MenuUtils;
import common.menu.MenuConstants;

public dynamic class ModalDialogGeneric extends ModalDialogFrameInformation {

	public static const FRAME_REST_HEIGHT:Number = 160;
	public static const FRAME_HEIGHT_MIN:Number = 260;
	public static const FRAME_HEIGHT_MAX:Number = 768.223;
	public static const FRAME_WIDTH:Number = 750;

	protected var m_viewTitle:TextField;
	protected var m_viewDescription:TextField;
	protected var m_viewFrame:Sprite;
	private var m_view:ModalDialogGenericView;

	public function ModalDialogGeneric(_arg_1:Object) {
		if (!_arg_1.hasOwnProperty("dialogWidth")) {
			_arg_1.dialogWidth = ModalDialogGeneric.FRAME_WIDTH;
		}

		_arg_1.dialogHeight = ModalDialogGeneric.FRAME_HEIGHT_MIN;
		super(_arg_1);
		this.createView();
	}

	protected function createView():void {
		var _local_1:ModalDialogGenericView = new ModalDialogGenericView();
		this.m_viewTitle = _local_1.title;
		this.m_viewDescription = _local_1.description;
		this.m_viewFrame = _local_1.bg;
		MenuUtils.setColor(this.m_viewFrame, MenuConstants.COLOR_MENU_SOLID_BACKGROUND, true, 1);
		this.m_viewDescription.autoSize = "left";
		this.m_viewDescription.text = "";
		this.m_view = _local_1;
		addChild(this.m_view);
	}

	override public function getView():Sprite {
		return (this.m_view);
	}

	override public function onSetData(_arg_1:Object):void {
		var _local_2:Number = ((_arg_1.hasOwnProperty("frameheightmax")) ? _arg_1.frameheightmax : FRAME_HEIGHT_MAX);
		var _local_3:Number = ((_arg_1.hasOwnProperty("frameheightmin")) ? _arg_1.frameheightmin : FRAME_HEIGHT_MIN);
		m_dialogWidth = ((_arg_1.hasOwnProperty("dialogWidth")) ? _arg_1.dialogWidth : FRAME_WIDTH);
		this.m_viewFrame.width = m_dialogWidth;
		var _local_4:Number = this.m_viewDescription.x;
		var _local_5:Number = this.m_viewDescription.y;
		var _local_6:Number = _local_4;
		var _local_7:Number = FRAME_REST_HEIGHT;
		setupTitle(this.m_viewTitle, _arg_1);
		if (this.m_viewTitle.text.length == 0) {
			_local_7 = (_local_7 - (_local_5 - this.m_viewTitle.y));
			_local_5 = this.m_viewTitle.y;
		}

		createAndAddScrollContainer(_local_4, _local_5, (m_dialogWidth - _local_4), (_local_2 - _local_7), _local_6);
		super.onSetData(_arg_1);
		setupDescription(this.m_viewDescription, _arg_1);
		if (this.m_viewDescription.text.length > 0) {
			this.m_viewDescription.x = 0;
			this.m_viewDescription.y = 0;
			m_scrollingContainer.append(this.m_viewDescription, false, this.m_viewDescription.height, false);
		}

		setupInformation(_arg_1);
		var _local_8:Number = (Math.ceil(m_scrollingContainer.getContentHeight()) + _local_7);
		m_dialogHeight = updateDialogHeight(_local_8, _local_3, _local_2);
		this.m_viewFrame.height = m_dialogHeight;
	}

	override public function hide():void {
		destroyInformation();
		super.hide();
	}


}
}//package menu3.modal

