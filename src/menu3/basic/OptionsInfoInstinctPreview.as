// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.OptionsInfoInstinctPreview

package menu3.basic {
import common.CommonUtils;

public dynamic class OptionsInfoInstinctPreview extends OptionsInfoPreview {

	private var m_indicator1:AIIndicatorView = new AIIndicatorView();
	private var m_indicator2:AIIndicatorView = new AIIndicatorView();
	private var m_indicator3:AIIndicatorView = new AIIndicatorView();
	private var m_indicator4:AIIndicatorView = new AIIndicatorView();

	public function OptionsInfoInstinctPreview(_arg_1:Object) {
		super(_arg_1);
		this.m_indicator1.name = "m_indicator1";
		this.m_indicator2.name = "m_indicator2";
		this.m_indicator3.name = "m_indicator3";
		this.m_indicator4.name = "m_indicator4";
		getPreviewContentContainer().addChild(this.m_indicator1);
		getPreviewContentContainer().addChild(this.m_indicator2);
		getPreviewContentContainer().addChild(this.m_indicator3);
		getPreviewContentContainer().addChild(this.m_indicator4);
		this.onSetData(_arg_1);
	}

	override public function onSetData(_arg_1:Object):void {
		var _local_4:AIIndicatorView;
		super.onSetData(_arg_1);
		var _local_2:Number = CommonUtils.getUIOptionValueNumber("UI_OPTION_GAME_AID_NPC_ICONS");
		var _local_3:Number = CommonUtils.getUIOptionValueNumber("UI_OPTION_GAME_AID_INSTINCT");
		if (!_local_2) {
			this.m_indicator1.visible = false;
			this.m_indicator2.visible = false;
			this.m_indicator3.visible = false;
			this.m_indicator4.visible = false;
		} else {
			for each (_local_4 in [this.m_indicator1, this.m_indicator2, this.m_indicator3, this.m_indicator4]) {
				_local_4.scaleX = 0.75;
				_local_4.scaleY = 0.75;
				_local_4.gotoAndStop("attentive");
				_local_4.witnessIcon.visible = false;
			}

			this.m_indicator1.x = 346;
			this.m_indicator1.y = 17;
			this.m_indicator2.x = 109;
			this.m_indicator2.y = 45;
			this.m_indicator3.x = 212;
			this.m_indicator3.y = 57;
			this.m_indicator4.x = 285;
			this.m_indicator4.y = 175;
			this.m_indicator1.visible = true;
			this.m_indicator2.visible = ((_local_3) ? true : false);
			this.m_indicator3.visible = ((_local_3) ? true : false);
			this.m_indicator4.visible = ((_local_3) ? true : false);
		}

	}

	override public function onUnregister():void {
		getPreviewContentContainer().removeChild(this.m_indicator4);
		getPreviewContentContainer().removeChild(this.m_indicator2);
		getPreviewContentContainer().removeChild(this.m_indicator3);
		getPreviewContentContainer().removeChild(this.m_indicator1);
		this.m_indicator4 = null;
		this.m_indicator2 = null;
		this.m_indicator3 = null;
		this.m_indicator1 = null;
		super.onUnregister();
	}


}
}//package menu3.basic

