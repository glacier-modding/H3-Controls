package menu3.basic
{
	import common.Localization;
	import flash.display.Shape;
	import flash.utils.*;
	import hud.ChallengeElement;
	import hud.evergreen.EconomyWidget;
	
	public dynamic class OptionsInfoTopRightPreview extends OptionsInfoPreview
	{
		
		private const m_lstrTitle:String = Localization.get("UI_CHALLENGES_PROLOGUE_BOARD_AS_GUARD_NAME");
		
		private var m_mask:Shape;
		
		private var m_challengeElement:ChallengeElement;
		
		private var m_economyWidget:EconomyWidget;
		
		private var m_imagePath:String;
		
		private var m_idIntervalRefresh:uint = 0;
		
		public function OptionsInfoTopRightPreview(param1:Object)
		{
			var _loc2_:Number = NaN;
			this.m_mask = new Shape();
			this.m_challengeElement = new ChallengeElement();
			this.m_economyWidget = new EconomyWidget();
			super(param1);
			this.m_mask.name = "m_mask";
			getPreviewContentContainer().addChild(this.m_mask);
			getPreviewContentContainer().mask = this.m_mask;
			this.m_challengeElement.name = "m_challengeElement";
			getPreviewContentContainer().addChild(this.m_challengeElement);
			this.m_economyWidget.name = "m_economyWidget";
			getPreviewContentContainer().addChild(this.m_economyWidget);
			_loc2_ = PX_PREVIEW_BACKGROUND_WIDTH;
			var _loc3_:Number = _loc2_ / 1920 * 1080;
			this.m_challengeElement.x = _loc2_ - 30;
			this.m_challengeElement.y = 30;
			this.m_economyWidget.x = _loc2_ - 30;
			this.m_economyWidget.y = 30;
			this.onSetData(param1);
		}
		
		override public function onSetData(param1:Object):void
		{
			super.onSetData(param1);
			if (!param1.previewData || !param1.previewData.showChallengeNotificationWithImage)
			{
				this.m_challengeElement.visible = false;
				clearInterval(this.m_idIntervalRefresh);
				this.m_idIntervalRefresh = 0;
			}
			else
			{
				this.m_challengeElement.visible = true;
				this.m_imagePath = param1.previewData.showChallengeNotificationWithImage;
				clearInterval(this.m_idIntervalRefresh);
				this.m_idIntervalRefresh = setInterval(this.showNotification, 5000);
				this.showNotification();
			}
			if (!param1.previewData || !param1.previewData.showEvergreenEconomyWidget)
			{
				this.m_economyWidget.visible = false;
			}
			else
			{
				this.m_economyWidget.visible = true;
				this.m_economyWidget.onSetData(1234);
			}
		}
		
		private function showNotification():void
		{
			this.m_challengeElement.onSetDataWithDelay({"title": this.m_lstrTitle, "total": 1, "count": 1, "completed": true, "timeRemaining": 4.5, "imagePath": this.m_imagePath}, 0.25);
		}
		
		override protected function onPreviewBackgroundImageLoaded():void
		{
			super.onPreviewBackgroundImageLoaded();
			var _loc1_:Number = getPreviewBackgroundImage().width;
			var _loc2_:Number = getPreviewBackgroundImage().height;
			this.m_mask.graphics.clear();
			this.m_mask.graphics.beginFill(0);
			this.m_mask.graphics.drawRect(0, 0, _loc1_, _loc2_);
		}
		
		override protected function onPreviewRemovedFromStage():void
		{
			clearInterval(this.m_idIntervalRefresh);
			this.m_idIntervalRefresh = 0;
			super.onPreviewRemovedFromStage();
		}
	}
}
