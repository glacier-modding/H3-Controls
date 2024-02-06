package menu3.basic
{
	import common.CommonUtils;
	
	public dynamic class OptionsInfoInstinctPreview extends OptionsInfoPreview
	{
		
		private var m_indicator1:AIIndicatorView;
		
		private var m_indicator2:AIIndicatorView;
		
		private var m_indicator3:AIIndicatorView;
		
		private var m_indicator4:AIIndicatorView;
		
		public function OptionsInfoInstinctPreview(param1:Object)
		{
			this.m_indicator1 = new AIIndicatorView();
			this.m_indicator2 = new AIIndicatorView();
			this.m_indicator3 = new AIIndicatorView();
			this.m_indicator4 = new AIIndicatorView();
			super(param1);
			this.m_indicator1.name = "m_indicator1";
			this.m_indicator2.name = "m_indicator2";
			this.m_indicator3.name = "m_indicator3";
			this.m_indicator4.name = "m_indicator4";
			getPreviewContentContainer().addChild(this.m_indicator1);
			getPreviewContentContainer().addChild(this.m_indicator2);
			getPreviewContentContainer().addChild(this.m_indicator3);
			getPreviewContentContainer().addChild(this.m_indicator4);
			this.onSetData(param1);
		}
		
		override public function onSetData(param1:Object):void
		{
			var _loc4_:AIIndicatorView = null;
			super.onSetData(param1);
			var _loc2_:Number = CommonUtils.getUIOptionValueNumber("UI_OPTION_GAME_AID_NPC_ICONS");
			var _loc3_:Number = CommonUtils.getUIOptionValueNumber("UI_OPTION_GAME_AID_INSTINCT");
			if (!_loc2_)
			{
				this.m_indicator1.visible = false;
				this.m_indicator2.visible = false;
				this.m_indicator3.visible = false;
				this.m_indicator4.visible = false;
			}
			else
			{
				for each (_loc4_ in[this.m_indicator1, this.m_indicator2, this.m_indicator3, this.m_indicator4])
				{
					_loc4_.scaleX = 0.75;
					_loc4_.scaleY = 0.75;
					_loc4_.gotoAndStop("attentive");
					_loc4_.witnessIcon.visible = false;
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
				this.m_indicator2.visible = !!_loc3_ ? true : false;
				this.m_indicator3.visible = !!_loc3_ ? true : false;
				this.m_indicator4.visible = !!_loc3_ ? true : false;
			}
		}
		
		override public function onUnregister():void
		{
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
}
