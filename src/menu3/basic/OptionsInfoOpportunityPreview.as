// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.OptionsInfoOpportunityPreview

package menu3.basic {
import hud.OpportunityPreview;
import hud.Breadcrumb;

import common.CommonUtils;
import common.Animate;

public dynamic class OptionsInfoOpportunityPreview extends OptionsInfoPreview {

	private static const UIOPTION_OPPORTUNITIES_OFF:Number = 0;
	private static const UIOPTION_OPPORTUNITIES_MINIMAL:Number = 1;
	private static const UIOPTION_OPPORTUNITIES_FULL:Number = 2;

	private var m_oppPreview:OpportunityPreview = new OpportunityPreview();
	private var m_breadcrumb:Breadcrumb = new Breadcrumb();

	public function OptionsInfoOpportunityPreview(_arg_1:Object) {
		var _local_2:Number;
		super(_arg_1);
		this.m_oppPreview.name = "m_oppPreview";
		getPreviewContentContainer().addChild(this.m_oppPreview);
		this.m_breadcrumb.name = "m_breadcrumb";
		getPreviewContentContainer().addChild(this.m_breadcrumb);
		_local_2 = PX_PREVIEW_BACKGROUND_WIDTH;
		var _local_3:Number = ((_local_2 / 1920) * 1080);
		this.m_oppPreview.x = (_local_2 / 2);
		this.m_oppPreview.y = 12;
		this.m_breadcrumb.x = ((_local_2 * 436) / 620);
		this.m_breadcrumb.y = ((_local_3 * 137) / 352);
		this.m_breadcrumb.noResolutionScale = true;
		this.onSetData(_arg_1);
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		var _local_2:Number = CommonUtils.getUIOptionValueNumber("UI_OPTION_GAME_AID_OPPORTUNITIES");
		if (_local_2 != UIOPTION_OPPORTUNITIES_FULL) {
			this.m_breadcrumb.visible = false;
		} else {
			this.m_breadcrumb.ChangeIconType("opdiscovered");
			this.m_breadcrumb.showAttentionOutline();
			this.m_breadcrumb.onSetData({
				"id": "distance",
				"distance": 12
			});
			this.m_breadcrumb.visible = true;
			this.m_breadcrumb.scaleX = 0;
			this.m_breadcrumb.scaleY = 0;
			Animate.to(this.m_breadcrumb, 0.125, 0.5, {
				"scaleX": 1,
				"scaleY": 1
			}, Animate.SineOut);
		}
		;
		if (_local_2 == UIOPTION_OPPORTUNITIES_OFF) {
			this.m_oppPreview.onSetData({"state": OpportunityPreview.STATE_DEFAULT});
		} else {
			this.m_oppPreview.onSetData({"state": OpportunityPreview.STATE_FAR});
		}
		;
	}

	override protected function onPreviewRemovedFromStage():void {
		this.m_breadcrumb.hideAttentionOutline();
		super.onPreviewRemovedFromStage();
	}


}
}//package menu3.basic

