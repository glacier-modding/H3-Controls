// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.evergreen.EvergreenBreadcrumb

package hud.evergreen {
import common.BaseControl;

public class EvergreenBreadcrumb extends BaseControl {

	private var m_view:EvergreenBreadcrumbView = new EvergreenBreadcrumbView();

	public function EvergreenBreadcrumb() {
		this.m_view.name = "m_view";
		addChild(this.m_view);
	}

	[PROPERTY(HELPTEXT="Possible values: mule, safe, stash, supplier, meeting_secret, meeting_business, meeting_handover", CATEGORY="Evergreen Breadcrumb")]
	public function set Icon(_arg_1:String):void {
		switch (_arg_1) {
			case "mule":
			case "safe":
			case "stash":
			case "supplier":
			case "meeting_secret":
			case "meeting_business":
			case "meeting_handover":
				this.m_view.gotoAndStop(_arg_1);
				return;
			default:
				this.m_view.gotoAndStop("none");
		}
		;
	}


}
}//package hud.evergreen

