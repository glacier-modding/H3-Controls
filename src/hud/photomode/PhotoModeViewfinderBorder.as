// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.photomode.PhotoModeViewfinderBorder

package hud.photomode {
import common.BaseControl;
import common.menu.MenuConstants;

public class PhotoModeViewfinderBorder extends BaseControl {

	private var m_posX:int = 354;
	private var m_posY:int = 236;
	private var m_view:PhotoModeViewfinderBorderView;

	public function PhotoModeViewfinderBorder() {
		this.m_view = new PhotoModeViewfinderBorderView();
		this.m_view.corner_lt.alpha = (this.m_view.corner_rt.alpha = (this.m_view.corner_lb.alpha = (this.m_view.corner_rb.alpha = 0.3)));
		this.m_view.battery_mc.alpha = (this.m_view.flash_mc.alpha = 0.7);
		this.m_view.visible = false;
		addChild(this.m_view);
	}

	public function setViewFinderStyle(_arg_1:int):void {
		switch (_arg_1) {
			case PhotoModeWidget.VIEWFINDERSTYLE_NONE:
				this.m_view.visible = false;
				return;
			case PhotoModeWidget.VIEWFINDERSTYLE_CAMERAITEM:
				this.m_view.visible = false;
				return;
			case PhotoModeWidget.VIEWFINDERSTYLE_PHOTOOPP:
				this.m_view.visible = true;
				return;
			default:
				this.m_view.visible = false;
		}

	}

	override public function onSetSize(_arg_1:Number, _arg_2:Number):void {
		var _local_3:Number = ((_arg_1 > MenuConstants.BaseWidth) ? (_arg_1 / MenuConstants.BaseWidth) : 1);
		var _local_4:Number = ((_arg_2 > MenuConstants.BaseHeight) ? (_arg_2 / MenuConstants.BaseHeight) : 1);
		this.m_view.corner_lt.x = (this.m_posX * _local_3);
		this.m_view.corner_lt.y = (this.m_posY * _local_4);
		this.m_view.corner_rt.x = (_arg_1 - (this.m_posX * _local_3));
		this.m_view.corner_rt.y = (this.m_posY * _local_4);
		this.m_view.corner_lb.x = (this.m_posX * _local_3);
		this.m_view.corner_lb.y = (_arg_2 - (this.m_posY * _local_4));
		this.m_view.corner_rb.x = (_arg_1 - (this.m_posX * _local_3));
		this.m_view.corner_rb.y = (_arg_2 - (this.m_posY * _local_4));
		this.m_view.battery_mc.x = (this.m_view.flash_mc.x = (this.m_posX * _local_3));
		this.m_view.battery_mc.y = (this.m_view.flash_mc.y = (_arg_2 - (this.m_posY * _local_4)));
	}


}
}//package hud.photomode

