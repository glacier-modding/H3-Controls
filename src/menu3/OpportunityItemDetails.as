// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.OpportunityItemDetails

package menu3 {
import common.menu.MenuUtils;
import common.menu.MenuConstants;

public dynamic class OpportunityItemDetails extends MenuElementBase {

	private var m_view:OpportunityItemDetailsView;

	public function OpportunityItemDetails(_arg_1:Object) {
		super(_arg_1);
	}

	override public function onSetData(_arg_1:Object):void {
		if (this.m_view) {
			removeChild(this.m_view);
		}

		this.m_view = new OpportunityItemDetailsView();
		this.m_view.Body.description.height = 332;
		this.setupHeader(_arg_1.header, _arg_1.title, _arg_1.icon, _arg_1.completed);
		this.setupBody(_arg_1.descriptiontitle, _arg_1.description);
		addChild(this.m_view);
	}

	override public function onUnregister():void {
		if (this.m_view) {
			removeChild(this.m_view);
			this.m_view = null;
		}

	}

	private function setupHeader(_arg_1:String, _arg_2:String, _arg_3:String, _arg_4:Boolean):void {
		MenuUtils.setupText(this.m_view.Header.header, _arg_1, 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_view.Header.title, _arg_2, 60, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
		MenuUtils.setupIcon(this.m_view.Header.icon, _arg_3, MenuConstants.COLOR_WHITE, true, false);
	}

	private function setupBody(_arg_1:String, _arg_2:String):void {
		MenuUtils.setupTextAndShrinkToFit(this.m_view.Body.title, _arg_1, 28, MenuConstants.FONT_TYPE_MEDIUM, this.m_view.Body.title.width, -1, 24, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_view.Body.description, _arg_2, 18, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
	}


}
}//package menu3

