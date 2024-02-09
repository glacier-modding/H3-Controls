package menu3.basic
{
	import common.Animate;
	import common.CommonUtils;
	import common.ImageLoader;
	import common.Localization;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.utils.*;
	import hud.ObjectivesBar;
	import hud.PipElement;
	
	public dynamic class OptionsInfoTopLeftPreview extends OptionsInfoPreview
	{
		
		private static const UIOPTION_OBJECTIVES_AUTO:Number = 0;
		
		private static const UIOPTION_OBJECTIVES_OFF:Number = 1;
		
		private static const UIOPTION_OBJECTIVES_ON:Number = 2;
		
		private const m_lstrObjectiveA:String = Localization.get("UI_AID_OBJECTIVES_EXAMPLE_1");
		
		private const m_lstrObjectiveB:String = Localization.get("UI_AID_OBJECTIVES_EXAMPLE_2");
		
		private const m_lstrObjectiveC:String = Localization.get("UI_AID_OBJECTIVES_EXAMPLE_3");
		
		private const m_lstrBodyFound:String = Localization.get("EGAME_TEXT_SL_BODYFOUND");
		
		private var m_objectivesBar:ObjectivesBar;
		
		private var m_pipImageScaler:Sprite;
		
		private var m_pipImageLoader:ImageLoader = null;
		
		private var m_pipMask:Shape;
		
		private var m_pipElement:PipElement;
		
		private var m_fScale:Number = 1;
		
		private var m_idTimeoutObjectives:uint = 0;
		
		public function OptionsInfoTopLeftPreview(param1:Object)
		{
			this.m_objectivesBar = new ObjectivesBar();
			this.m_pipImageScaler = new Sprite();
			this.m_pipMask = new Shape();
			this.m_pipElement = new PipElement();
			super(param1);
			this.m_objectivesBar.name = "m_objectivesBar";
			getPreviewContentContainer().addChild(this.m_objectivesBar);
			this.m_pipImageScaler.name = "m_pipImageScaler";
			this.m_pipImageScaler.visible = false;
			getPreviewContentContainer().addChild(this.m_pipImageScaler);
			this.m_pipMask.name = "m_pipMask";
			this.m_pipMask.graphics.beginFill(0);
			this.m_pipMask.graphics.drawRect(0, 0, 432, 240);
			getPreviewContentContainer().addChild(this.m_pipMask);
			this.m_pipImageScaler.mask = this.m_pipMask;
			this.m_pipElement.name = "m_pipElement";
			getPreviewContentContainer().addChild(this.m_pipElement);
			this.onSetData(param1);
		}
		
		private static function makeObjectivesEmptyData():Object
		{
			return {"primary": [], "secondary": []};
		}
		
		override public function onSetData(param1:Object):void
		{
			var pxBGHeight:Number;
			var pxBGWidth:Number = NaN;
			var thing:DisplayObject = null;
			var nOptionObjectives:Number = NaN;
			var data:Object = param1;
			super.onSetData(data);
			if (data.previewData.fScale != undefined)
			{
				this.m_fScale = data.previewData.fScale;
			}
			pxBGWidth = PX_PREVIEW_BACKGROUND_WIDTH;
			pxBGHeight = pxBGWidth / 1920 * 1080;
			this.m_objectivesBar.x = 30;
			this.m_objectivesBar.y = 30;
			this.m_pipImageScaler.x = 30 + this.m_pipMask.width / 2;
			this.m_pipImageScaler.y = 30 + this.m_pipMask.height / 2;
			this.m_pipMask.x = 30;
			this.m_pipMask.y = 30;
			this.m_pipElement.x = 30;
			this.m_pipElement.y = 30;
			for each (thing in[this.m_objectivesBar, this.m_pipImageScaler, this.m_pipMask, this.m_pipElement])
			{
				thing.scaleX = this.m_fScale;
				thing.scaleY = this.m_fScale;
			}
			nOptionObjectives = CommonUtils.getUIOptionValueNumber("UI_OPTION_GAME_AID_OBJECTIVES");
			if (this.m_idTimeoutObjectives != 0)
			{
				clearTimeout(this.m_idTimeoutObjectives);
				this.m_idTimeoutObjectives = 0;
			}
			switch (nOptionObjectives)
			{
			case UIOPTION_OBJECTIVES_OFF: 
				this.m_objectivesBar.updateAndShowObjectives(makeObjectivesEmptyData());
				break;
			case UIOPTION_OBJECTIVES_ON: 
				this.m_objectivesBar.updateAndShowObjectives(this.makeObjectivesData(true, false));
				break;
			case UIOPTION_OBJECTIVES_AUTO: 
				if (!data.previewData.showUpdatingObjectives)
				{
					this.m_objectivesBar.updateAndShowObjectives(makeObjectivesEmptyData());
				}
				else
				{
					this.showUpdatingObjectivesStep1();
				}
			}
			if (!data.previewData.showPiPWithImage)
			{
				this.m_objectivesBar.visible = true;
				this.m_pipImageScaler.visible = false;
				this.m_pipElement.setPipMessage("", 0);
			}
			else
			{
				this.m_pipImageLoader = new ImageLoader();
				this.m_pipImageLoader.name = "m_pipImageLoader";
				this.m_pipImageScaler.addChild(this.m_pipImageLoader);
				this.m_pipImageLoader.loadImage(data.previewData.showPiPWithImage, function():void
				{
					m_pipImageLoader.x = -m_pipImageLoader.width / 2;
					m_pipImageLoader.y = -m_pipImageLoader.height / 2;
				});
				this.showPiPStep1();
			}
		}
		
		private function showUpdatingObjectivesStep1():void
		{
			this.m_objectivesBar.updateAndShowObjectives(makeObjectivesEmptyData());
			this.m_idTimeoutObjectives = setTimeout(this.showUpdatingObjectivesStep2, 500);
		}
		
		private function showUpdatingObjectivesStep2():void
		{
			this.m_objectivesBar.updateAndShowObjectives(this.makeObjectivesData(false, false));
			this.m_objectivesBar.alpha = 0;
			Animate.to(this.m_objectivesBar, 0.125, 0, {"alpha": 1}, Animate.Linear);
			this.m_idTimeoutObjectives = setTimeout(this.showUpdatingObjectivesStep3, 750);
		}
		
		private function showUpdatingObjectivesStep3():void
		{
			this.m_objectivesBar.updateAndShowObjectives(this.makeObjectivesData(true, true));
			this.m_idTimeoutObjectives = setTimeout(this.showUpdatingObjectivesStep4, 2000);
		}
		
		private function showUpdatingObjectivesStep4():void
		{
			this.m_objectivesBar.hideObjectives();
			this.m_idTimeoutObjectives = setTimeout(this.showUpdatingObjectivesStep1, 1500);
		}
		
		private function makeObjectivesData(param1:Boolean, param2:Boolean):Object
		{
			return {"primary": [{"id": "AAAAAAAAAAA", "objTitle": this.m_lstrObjectiveA, "objType": 0}, {"id": "BBBBBBBBBBB", "objTitle": this.m_lstrObjectiveB, "objType": 0}, {"id": "CCCCCCCCCCC", "objTitle": this.m_lstrObjectiveC, "objType": 0, "objSuccess": param1, "objChanged": param2}], "secondary": []};
		}
		
		private function showPiPStep1():void
		{
			this.m_objectivesBar.visible = false;
			this.m_pipImageScaler.visible = true;
			this.m_pipElement.setPipMessage(this.m_lstrBodyFound, 0);
			this.m_pipImageScaler.scaleX = 0.5 * this.m_fScale;
			this.m_pipImageScaler.scaleY = 0.5 * this.m_fScale;
			Animate.fromTo(this.m_pipImageScaler, 6.5, 0, {"scaleX": 0.5 * this.m_fScale, "scaleY": 0.5 * this.m_fScale}, {"scaleX": 0.35 * this.m_fScale, "scaleY": 0.35 * this.m_fScale}, Animate.SineOut);
		}
		
		override protected function onPreviewRemovedFromStage():void
		{
			clearTimeout(this.m_idTimeoutObjectives);
			this.m_idTimeoutObjectives = 0;
			if (this.m_pipImageLoader)
			{
				this.m_pipImageLoader.cancelAndClearImage();
				this.m_pipImageLoader = null;
			}
			super.onPreviewRemovedFromStage();
		}
	}
}
