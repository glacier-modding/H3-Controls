// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.OptionsInfoNpcIconsPreview

package menu3.basic {
public dynamic class OptionsInfoNpcIconsPreview extends OptionsInfoPreview {

	private var m_indicator1:AIIndicatorView = new AIIndicatorView();
	private var m_indicator2:AIIndicatorView = new AIIndicatorView();
	private var m_indicator3:AIIndicatorView = new AIIndicatorView();
	private var m_indicator4:AIIndicatorView = new AIIndicatorView();

	public function OptionsInfoNpcIconsPreview(_arg_1:Object) {
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
		var _local_2:AIIndicatorView;
		super.onSetData(_arg_1);
		if (!_arg_1.previewData.showNpcIcons) {
			this.m_indicator1.visible = false;
			this.m_indicator2.visible = false;
			this.m_indicator3.visible = false;
			this.m_indicator4.visible = false;
		} else {
			for each (_local_2 in [this.m_indicator1, this.m_indicator2, this.m_indicator3, this.m_indicator4]) {
				_local_2.visible = true;
				_local_2.gotoAndStop("attentive");
				_local_2.witnessIcon.visible = false;
			}

			this.m_indicator1.x = 395;
			this.m_indicator1.y = 204;
			this.m_indicator2.x = 119;
			this.m_indicator2.y = 202;
			this.m_indicator3.x = 50;
			this.m_indicator3.y = 209;
			this.m_indicator4.x = 400;
			this.m_indicator4.y = 14;
			this.m_indicator1.anim_mc.alpha = 0.75;
		}

	}


}
}//package menu3.basic

