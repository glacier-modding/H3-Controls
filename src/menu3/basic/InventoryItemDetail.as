// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.InventoryItemDetail

package menu3.basic {
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

import common.menu.MenuUtils;
import common.menu.MenuConstants;

public class InventoryItemDetail extends Sprite {

	private const DETAIL_VIEW_BEGIN_X:int = 5;
	private const DETAIL_VIEW_BEGIN_Y:int = 40;
	private const SPACE_Y:int = 40;

	private var m_title:TextField = new TextField();
	private var m_views:Array = [];

	public function InventoryItemDetail() {
		this.m_title.autoSize = TextFieldAutoSize.LEFT;
		addChild(this.m_title);
	}

	public function onSetData(_arg_1:Object):void {
		var _local_3:InventoryItemDetailView;
		this.removeAllViews();
		if (_arg_1 == null) {
			return;
		}

		MenuUtils.setupText(this.m_title, _arg_1.label, 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
		if (((_arg_1.details == null) || (_arg_1.details.length <= 0))) {
			return;
		}

		var _local_2:int;
		while (_local_2 < _arg_1.details.length) {
			_local_3 = this.createDetailView(_arg_1.details[_local_2]);
			if (_local_3 != null) {
				this.m_views.push(_local_3);
				addChild(_local_3);
				_local_3.x = this.DETAIL_VIEW_BEGIN_X;
				_local_3.y = (this.DETAIL_VIEW_BEGIN_Y + (this.SPACE_Y * _local_2));
			}

			_local_2++;
		}

	}

	public function onUnregister():void {
		this.removeAllViews();
	}

	private function createDetailView(_arg_1:Object):InventoryItemDetailView {
		var _local_3:int;
		var _local_2:InventoryItemDetailView = new InventoryItemDetailView();
		if (_arg_1.icon != undefined) {
			if (_arg_1.icon == "frisk") {
				MenuUtils.setupIcon(_local_2.icon, _arg_1.icon, MenuConstants.COLOR_WHITE, false, true, MenuConstants.COLOR_RED);
			} else {
				if (_arg_1.icon == "warning") {
					MenuUtils.setupIcon(_local_2.icon, _arg_1.icon, MenuConstants.COLOR_BLACK, false, true, MenuConstants.COLOR_YELLOW);
				} else {
					MenuUtils.setupIcon(_local_2.icon, _arg_1.icon, MenuConstants.COLOR_WHITE, true, false);
				}

			}

		}

		if (((!(_arg_1.title == undefined)) && (_arg_1.title.length > 0))) {
			_local_2.valuebar.visible = false;
			MenuUtils.setupText(_local_2.title, _arg_1.title, 20, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorGreyUltraLight);
		} else {
			if (_arg_1.value != undefined) {
				_local_2.title.visible = false;
				_local_3 = (_arg_1.value * 6);
				_local_2.valuebar.gotoAndStop(("value" + _local_3.toString()));
			}

		}

		return (_local_2);
	}

	private function removeAllViews():void {
		var _local_1:int;
		while (_local_1 < this.m_views.length) {
			removeChild(this.m_views[_local_1]);
			_local_1++;
		}

		this.m_views.length = 0;
	}


}
}//package menu3.basic

