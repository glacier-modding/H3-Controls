// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.QuestItemDetailTile

package menu3 {
import common.menu.textTicker;
import common.Log;
import common.menu.MenuUtils;
import common.menu.MenuConstants;

public dynamic class QuestItemDetailTile extends MenuElementBase {

	private var m_view:QuestItemDetailsView;
	private var m_textObj:Object;
	private var m_textTickerTitle:textTicker;

	public function QuestItemDetailTile(_arg_1:Object) {
		super(_arg_1);
	}

	override public function onSetData(_arg_1:Object):void {
		if (this.m_view) {
			removeChild(this.m_view);
		}

		Log.debugData(this, _arg_1);
		this.m_view = new QuestItemDetailsView();
		this.m_textObj = {};
		this.setupHeader(_arg_1.header, _arg_1.title, _arg_1.icon, _arg_1.completed);
		this.setupBody(_arg_1.description);
		addChild(this.m_view);
	}

	override public function onUnregister():void {
		if (this.m_textTickerTitle) {
			this.m_textTickerTitle.stopTextTicker(this.m_view.Header.title, this.m_textObj.title);
			this.m_textTickerTitle = null;
		}

		if (this.m_view) {
			removeChild(this.m_view);
			this.m_view = null;
		}

	}

	private function setupHeader(_arg_1:String, _arg_2:String, _arg_3:String, _arg_4:Boolean):void {
		MenuUtils.setupText(this.m_view.Header.header, _arg_1, 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_view.Header.title, _arg_2, 60, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
		this.m_textObj.title = this.m_view.Header.title.htmlText;
		MenuUtils.setupIcon(this.m_view.Header.icon, _arg_3, MenuConstants.COLOR_WHITE, true, false);
		this.callTextTicker(true);
	}

	private function setupBody(_arg_1:String):void {
		var _local_2:int = 18;
		if (ControlsMain.getDisplaySize() == ControlsMain.DISPLAY_SIZE_SMALL) {
			_local_2 = 22;
			this.m_view.Body.description.width = 1000;
		}

		MenuUtils.setupText(this.m_view.Body.description, _arg_1, _local_2, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
	}

	private function callTextTicker(_arg_1:Boolean):void {
		if (!this.m_textTickerTitle) {
			this.m_textTickerTitle = new textTicker();
		}

		if (_arg_1) {
			this.m_textTickerTitle.startTextTicker(this.m_view.Header.title, this.m_textObj.title);
		} else {
			this.m_textTickerTitle.stopTextTicker(this.m_view.Header.title, this.m_textObj.title);
			MenuUtils.truncateTextfield(this.m_view.Header.title, 1, MenuConstants.FontColorWhite);
		}

	}


}
}//package menu3

