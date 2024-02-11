// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.ItemBreadcrumb

package hud {
import common.BaseControl;
import common.menu.MenuUtils;
import common.menu.MenuConstants;

import scaleform.gfx.Extensions;

import common.Animate;

public class ItemBreadcrumb extends BaseControl {

	private var m_view:ItemBreadcrumbView;
	private var m_scaleMod:Number = 1;
	private var m_state:int = 0;
	private var m_duration:Number = 0;

	public function ItemBreadcrumb() {
		this.m_view = new ItemBreadcrumbView();
		this.m_view.distance_txt.height = (this.m_view.distance_txt.height * 2);
		this.m_view.visible = false;
		addChild(this.m_view);
	}

	public function onSetData(_arg_1:Object):void {
		var _local_3:int;
		var _local_4:int;
		if (_arg_1.id == "distance") {
			_local_3 = _arg_1.distance;
			this.m_view.distance_txt.visible = ((_local_3 > 0) ? true : false);
			_local_4 = ((ControlsMain.getDisplaySize() == ControlsMain.DISPLAY_SIZE_SMALL) ? 24 : 12);
			MenuUtils.setupText(this.m_view.distance_txt, (_local_3.toString() + "m"), _local_4, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		}

		var _local_2:Number = 1;
		if (!ControlsMain.isVrModeActive()) {
			_local_2 = (Extensions.visibleRect.height / 1080);
		}

		if (this.m_scaleMod != _local_2) {
			this.onSetSize(0, 0);
		}

	}

	private function pulsateAttentionOutline(_arg_1:Boolean):void {
		Animate.kill(this.m_view.attentionoutline);
		this.m_view.attentionoutline.alpha = 0;
		if (_arg_1) {
			this.pulsateAttentionOutlineIn();
		}

	}

	private function pulsateAttentionOutlineIn():void {
		this.m_view.attentionoutline.scaleX = (this.m_view.attentionoutline.scaleY = 0.44);
		this.m_view.attentionoutline.alpha = 0;
		Animate.to(this.m_view.attentionoutline, 0.2, 0, {
			"alpha": 1,
			"scaleX": 0.6,
			"scaleY": 0.6
		}, Animate.ExpoIn, this.pulsateAttentionOutlineOut);
	}

	private function pulsateAttentionOutlineOut():void {
		Animate.to(this.m_view.attentionoutline, 0.3, 0, {
			"alpha": 0,
			"scaleX": 0.66,
			"scaleY": 0.66
		}, Animate.ExpoOut, this.pulsateAttentionOutlineIn);
	}

	public function attachedToNpc(_arg_1:Boolean):void {
		this.m_view.visible = _arg_1;
		if (((_arg_1 == true) && (this.m_duration > 0))) {
			this.pulsateAttentionOutline(true);
		}

	}

	public function reset():void {
		this.pulsateAttentionOutline(false);
		this.m_view.visible = false;
	}

	public function set Duration(_arg_1:Number):void {
		this.m_duration = (_arg_1 / 1000);
	}

	override public function onSetSize(_arg_1:Number, _arg_2:Number):void {
		var _local_3:Number = 1;
		if (!ControlsMain.isVrModeActive()) {
			_local_3 = (Extensions.visibleRect.height / 1080);
		}

		this.m_scaleMod = (this.m_view.scaleX = (this.m_view.scaleY = _local_3));
	}


}
}//package hud

