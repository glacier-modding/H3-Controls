// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.OptionsInfoAttentionGainPreview

package menu3.basic {
import hud.AttentionIndicator;

import common.CommonUtils;

public dynamic class OptionsInfoAttentionGainPreview extends OptionsInfoPreview {

	private var m_indicator:AIIndicatorView = new AIIndicatorView();
	private var m_attention:AttentionIndicator = new AttentionIndicator();

	public function OptionsInfoAttentionGainPreview(_arg_1:Object) {
		super(_arg_1);
		this.m_indicator.name = "m_indicator";
		getPreviewContentContainer().addChild(this.m_indicator);
		getPreviewContentContainer().addChild(this.m_attention);
		this.m_indicator.x = 502;
		this.m_indicator.y = 32;
		this.m_indicator.scaleX = 0.75;
		this.m_indicator.scaleY = 0.75;
		this.m_indicator.gotoAndStop("attentive");
		this.m_indicator.witnessIcon.visible = false;
		this.m_indicator.anim_mc.alpha = 0.5;
		this.m_attention.x = 173;
		this.m_attention.y = 254;
		this.m_attention.scaleX = 0.62;
		this.m_attention.scaleY = 0.25;
		this.m_attention.ensureWedgesCount(1);
		var _local_2:AttentionWedge = this.m_attention.getWedges()[0];
		_local_2.visible = true;
		_local_2.rotation = 66;
		_local_2.wedgeMc.spike.gotoAndStop(50);
		_local_2.wedgeMc.spike2.gotoAndStop(50);
		this.onSetData(_arg_1);
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		var _local_2:Number = CommonUtils.getUIOptionValueNumber("UI_OPTION_GAME_AID_NPC_ICONS");
		var _local_3:Number = CommonUtils.getUIOptionValueNumber("UI_OPTION_GAME_AID_ATTENTION");
		this.m_indicator.visible = ((_local_2) ? true : false);
		this.m_attention.visible = ((_local_3) ? true : false);
	}

	override public function onUnregister():void {
		getPreviewContentContainer().removeChild(this.m_attention);
		getPreviewContentContainer().removeChild(this.m_indicator);
		this.m_attention = null;
		this.m_indicator = null;
		super.onUnregister();
	}


}
}//package menu3.basic

