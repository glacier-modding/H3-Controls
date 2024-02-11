// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.tutorial.TutorialBar

package hud.tutorial {
import common.BaseControl;
import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.Animate;

public class TutorialBar extends BaseControl {

	private var m_view:TutorialBarView;

	public function TutorialBar() {
		this.m_view = new TutorialBarView();
		addChild(this.m_view);
		this.m_view.visible = false;
		var _local_1:Number = ((ControlsMain.getDisplaySize() == ControlsMain.DISPLAY_SIZE_SMALL) ? 1.2 : 1);
		this.m_view.scaleX = _local_1;
		this.m_view.scaleY = _local_1;
	}

	public function onSetData(_arg_1:Object):void {
		var _local_2:Number = ((ControlsMain.getDisplaySize() == ControlsMain.DISPLAY_SIZE_SMALL) ? 1.2 : 1);
		if (this.m_view.scaleX != _local_2) {
			this.m_view.scaleX = _local_2;
			this.m_view.scaleY = _local_2;
		}
		;
		MenuUtils.setupText(this.m_view.label_txt, ((_arg_1.title) || ("")), 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
	}

	public function ShowNotification():void {
		this.m_view.visible = true;
		this.m_view.box_mc.height = (this.m_view.label_txt.textHeight + 34);
		if (this.m_view.box_mc.height < 64) {
			this.m_view.box_mc.height = 64;
		}
		;
		this.m_view.icon_mc.scaleX = (this.m_view.icon_mc.scaleY = 1.3);
		this.m_view.icon_mc.alpha = 0.5;
		Animate.legacyTo(this.m_view.icon_mc, 0.7, {
			"scaleX": 1,
			"scaleY": 1,
			"alpha": 1
		}, Animate.ExpoIn);
		this.m_view.alpha = 0;
		var _local_1:Number = 0;
		if (this.m_view.box_mc.height > 60) {
			_local_1 = (60 - this.m_view.box_mc.height);
		}
		;
		this.m_view.y = (_local_1 + 20);
		Animate.legacyTo(this.m_view, 0.5, {
			"alpha": 1,
			"y": _local_1
		}, Animate.ExpoIn);
	}

	public function HideNotification():void {
		Animate.legacyTo(this.m_view, 0.5, {"alpha": 0}, Animate.ExpoIn, function ():void {
			m_view.visible = false;
		});
	}


}
}//package hud.tutorial

