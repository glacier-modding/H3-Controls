// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.search.SearchTagGroupHeader

package menu3.search {
import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.CommonUtils;

public dynamic class SearchTagGroupHeader extends SearchElementBase {

	public function SearchTagGroupHeader(_arg_1:Object) {
		super(_arg_1);
	}

	override protected function createPrivateView():* {
		return (new ContractSearchTagGroupHeaderView());
	}

	protected function get Icon():iconsAll40x40View {
		return (getPrivateView().icon);
	}

	override public function onSetData(_arg_1:Object):void {
		if (_arg_1.width != null) {
			this.updateWidth(_arg_1.width);
		}
		;
		super.onSetData(_arg_1);
		if (_arg_1.icon) {
			MenuUtils.setupIcon(this.Icon, _arg_1.icon, MenuConstants.COLOR_WHITE, true, false);
		}
		;
	}

	override public function onUnregister():void {
		super.onUnregister();
	}

	override protected function setupTitleTextField(_arg_1:String):void {
		MenuUtils.setupText(TitleTextField, _arg_1, 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		CommonUtils.changeFontToGlobalIfNeeded(TitleTextField);
		MenuUtils.shrinkTextToFit(TitleTextField, TitleTextField.width, 0);
	}

	override public function setItemSelected(_arg_1:Boolean):void {
	}

	override protected function setState(_arg_1:int):void {
	}

	private function updateWidth(_arg_1:Number):void {
		var _local_2:Number = 8;
		var _local_3:Number = 4;
		var _local_4:* = getPrivateView();
		_local_4.bg.x = (_arg_1 / 2);
		_local_4.bg.width = (_arg_1 - _local_2);
		TitleTextField.width = ((_arg_1 - TitleTextField.x) - _local_3);
	}


}
}//package menu3.search

