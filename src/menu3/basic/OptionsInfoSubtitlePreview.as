// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.OptionsInfoSubtitlePreview

package menu3.basic {
import basic.Subtitle;

import scaleform.gfx.DisplayObjectEx;

public dynamic class OptionsInfoSubtitlePreview extends OptionsInfoPreview {

	private var m_subtitle:Subtitle = new Subtitle();

	public function OptionsInfoSubtitlePreview(_arg_1:Object) {
		super(_arg_1);
		this.m_subtitle.name = "m_subtitle";
		getPreviewContentContainer().addChild(this.m_subtitle);
		this.m_subtitle.isAntiFreakoutDisabled = true;
		this.onSetData(_arg_1);
	}

	override public function onSetData(_arg_1:Object):void {
		var _local_2:Number;
		super.onSetData(_arg_1);
		DisplayObjectEx.skipNextMatrixLerp(this.m_subtitle);
		this.m_subtitle.onSetData({
			"text": _arg_1.subtitleText,
			"fontsize": _arg_1.subtitleFontSize,
			"pctBGAlpha": _arg_1.subtitleBGAlpha
		});
		_local_2 = PX_PREVIEW_BACKGROUND_WIDTH;
		var _local_3:Number = ((_local_2 / 1920) * 1080);
		this.m_subtitle.onSetSize((_local_2 - 60), 30);
		this.m_subtitle.x = 30;
		this.m_subtitle.y = (_local_3 - 80);
	}


}
}//package menu3.basic

