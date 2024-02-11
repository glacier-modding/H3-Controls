// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.search.SearchSelectedTagElement

package menu3.search {
import common.menu.MenuUtils;
import common.menu.MenuConstants;

public dynamic class SearchSelectedTagElement extends SearchElementBase {

	private var m_isReadOnly:Boolean = false;

	public function SearchSelectedTagElement(_arg_1:Object) {
		super(_arg_1);
	}

	override protected function createPrivateView():* {
		return (new ContractSearchSelectedTagElementView());
	}

	override public function onSetData(_arg_1:Object):void {
		this.m_isReadOnly = ((_arg_1.readonly) ? _arg_1.readonly : false);
		if (this.m_isReadOnly) {
			getPrivateView().iconMc.visible = false;
		} else {
			MenuUtils.setupIcon(m_view.iconMc, "failed", MenuConstants.COLOR_WHITE, false, false);
		}

		super.onSetData(_arg_1);
	}

	override public function onUnregister():void {
		super.onUnregister();
	}

	override public function setItemSelected(_arg_1:Boolean):void {
		if (this.m_isReadOnly) {
			return;
		}

		super.setItemSelected(_arg_1);
	}

	override protected function setState(_arg_1:int):void {
		m_view.tileSelectPulsate.visible = false;
		m_view.tileHoverMc.visible = false;
		if (((_arg_1 == STATE_SELECT) || (_arg_1 == STATE_ACTIVE_SELECT))) {
			m_view.tileSelectMc.visible = true;
			changeTextColor(MenuConstants.COLOR_WHITE);
			MenuUtils.setColor(m_view.iconMc, MenuConstants.COLOR_WHITE, false);
			MenuUtils.setColor(m_view.tileSelectMc, MenuConstants.COLOR_RED, false);
		} else {
			m_view.tileSelectMc.visible = true;
			changeTextColor(MenuConstants.COLOR_WHITE);
			MenuUtils.setColor(m_view.iconMc, MenuConstants.COLOR_WHITE, false);
			MenuUtils.setColor(m_view.tileSelectMc, MenuConstants.COLOR_MENU_CONTRACT_SEARCH_GREY, false);
		}

	}

	override protected function setupTitleTextField(_arg_1:String):void {
		setupTextField(TitleTextField, _arg_1, MenuConstants.FontColorWhite);
	}


}
}//package menu3.search

