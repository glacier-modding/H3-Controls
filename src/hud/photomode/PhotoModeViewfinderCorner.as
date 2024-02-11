// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.photomode.PhotoModeViewfinderCorner

package hud.photomode {
import common.BaseControl;

public class PhotoModeViewfinderCorner extends BaseControl {

	private var m_view:PhotoModeViewfinderCornerView;

	public function PhotoModeViewfinderCorner() {
		this.m_view = new PhotoModeViewfinderCornerView();
		this.m_view.cameraitem_corner_mc.alpha = 0.4;
		this.m_view.visible = false;
		addChild(this.m_view);
	}

	public function setViewFinderStyle(_arg_1:int):void {
		switch (_arg_1) {
			case PhotoModeWidget.VIEWFINDERSTYLE_NONE:
				this.m_view.visible = false;
				return;
			case PhotoModeWidget.VIEWFINDERSTYLE_CAMERAITEM:
				this.m_view.visible = true;
				this.m_view.cameraitem_corner_mc.visible = true;
				return;
			case PhotoModeWidget.VIEWFINDERSTYLE_PHOTOOPP:
				this.m_view.visible = true;
				this.m_view.cameraitem_corner_mc.visible = false;
				return;
			case PhotoModeWidget.VIEWFINDERSTYLE_SPYCAM:
				this.m_view.visible = false;
				this.m_view.cameraitem_corner_mc.visible = false;
				return;
			default:
				this.m_view.visible = true;
				this.m_view.cameraitem_corner_mc.visible = true;
		}

	}


}
}//package hud.photomode

