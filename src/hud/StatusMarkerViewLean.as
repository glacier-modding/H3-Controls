package hud
{
	import common.Localization;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextFormat;
	
	public class StatusMarkerViewLean extends Sprite
	{
		
		private var m_gradientOverlay:MovieClip;
		
		private var m_borderMc:MovieClip;
		
		private var m_gradientOverlayLVA:MovieClip;
		
		private var m_trespassingIndicatorMc:MovieClip;
		
		private var m_tensionIndicatorMc:MovieClip;
		
		private var m_informationBarLVA:MovieClip;
		
		private var m_isHiddenInCrowd:Boolean = false;
		
		private var m_isHiddenInVegetation:Boolean = false;
		
		private const m_lstrHiddenInCrowd:String = Localization.get("UI_MENU_LVA_BLENDING_IN_CROWD").toUpperCase();
		
		private const m_lstrHiddenInVegetation:String = Localization.get("UI_MENU_LVA_HIDDEN").toUpperCase();
		
		private const m_lstrDeepTrespassing:String = Localization.get("EGAME_TEXT_SL_HOSTILEAREA").toUpperCase();
		
		private const m_lstrTrespassing:String = Localization.get("EGAME_TEXT_SL_TRESPASSING_ON").toUpperCase();
		
		public function StatusMarkerViewLean()
		{
			super();
			var _loc1_:StatusMarkerView = new StatusMarkerView();
			this.m_gradientOverlay = _loc1_.gradientOverlay;
			addChild(this.m_gradientOverlay);
			this.m_borderMc = _loc1_.borderMc;
			addChild(this.m_borderMc);
			this.m_gradientOverlayLVA = _loc1_.gradientOverlayLVA;
			addChild(this.m_gradientOverlayLVA);
			this.m_trespassingIndicatorMc = _loc1_.trespassingIndicatorMc;
			addChild(this.m_trespassingIndicatorMc);
			this.m_tensionIndicatorMc = _loc1_.tensionIndicatorMc;
			addChild(this.m_tensionIndicatorMc);
			this.m_informationBarLVA = _loc1_.informationBarLVA;
			addChild(this.m_informationBarLVA);
			this.m_gradientOverlay.alpha = 0.3;
			this.m_gradientOverlayLVA.alpha = 0.6;
			this.m_gradientOverlayLVA.visible = false;
			this.m_trespassingIndicatorMc.visible = false;
			this.m_tensionIndicatorMc.visible = false;
			this.m_informationBarLVA.visible = false;
			var _loc2_:TextFormat = new TextFormat();
			_loc2_.leading = -3.5;
			this.m_trespassingIndicatorMc.bgGradient.alpha = 0.5;
			this.m_trespassingIndicatorMc.y = 105;
			this.m_trespassingIndicatorMc.removeChild(this.m_trespassingIndicatorMc.overlayMc);
			this.m_trespassingIndicatorMc.removeChild(this.m_trespassingIndicatorMc.pulseMc);
			this.m_tensionIndicatorMc.labelTxt.autoSize = "left";
			this.m_tensionIndicatorMc.labelTxt.multiline = true;
			this.m_tensionIndicatorMc.labelTxt.wordWrap = true;
			this.m_tensionIndicatorMc.labelTxt.width = 186;
			this.m_tensionIndicatorMc.labelTxt.text = "...";
			this.m_tensionIndicatorMc.labelTxt.setTextFormat(_loc2_);
			MenuUtils.setupText(this.m_tensionIndicatorMc.unconMc.labelTxt, "", 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
			this.m_tensionIndicatorMc.bgMc.height = 23;
			this.m_tensionIndicatorMc.bgGradient.alpha = 0.5;
			this.m_tensionIndicatorMc.y = -129;
			this.m_informationBarLVA.iconMc.gotoAndStop(OutfitAndStatusMarkersVR.ICON_HIDDENINLVA);
			this.m_informationBarLVA.labelTxt.autoSize = "left";
			this.m_informationBarLVA.labelTxt.multiline = true;
			this.m_informationBarLVA.labelTxt.wordWrap = true;
			this.m_informationBarLVA.labelTxt.width = 186;
			this.m_informationBarLVA.labelTxt.text = "";
			this.m_informationBarLVA.labelTxt.setTextFormat(_loc2_);
			MenuUtils.setupText(this.m_informationBarLVA.labelTxt, "...", 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
			this.m_informationBarLVA.y = -105;
		}
		
		public function setTrespassing(param1:Boolean, param2:Boolean):void
		{
			var _loc3_:String = null;
			var _loc4_:Number = NaN;
			var _loc5_:Number = NaN;
			if (param1 || param2)
			{
				_loc3_ = param2 ? String(this.m_lstrDeepTrespassing) : String(this.m_lstrTrespassing);
				_loc4_ = -1;
				_loc5_ = 9;
				MenuUtils.setupTextAndShrinkToFitUpper(this.m_trespassingIndicatorMc.labelTxt, _loc3_, 18, MenuConstants.FONT_TYPE_MEDIUM, 184, _loc4_, _loc5_, MenuConstants.FontColorGreyUltraDark);
				this.m_trespassingIndicatorMc.visible = true;
			}
			else
			{
				this.m_trespassingIndicatorMc.visible = false;
			}
		}
		
		public function hiddenInCrowd(param1:Boolean):void
		{
			this.m_isHiddenInCrowd = param1;
			this.applyLVA();
		}
		
		public function hiddenInVegetation(param1:Boolean):void
		{
			this.m_isHiddenInVegetation = param1;
			this.applyLVA();
		}
		
		private function applyLVA():void
		{
			if (this.m_isHiddenInCrowd)
			{
				this.m_informationBarLVA.labelTxt.text = this.m_lstrHiddenInCrowd;
				this.m_informationBarLVA.visible = true;
				this.m_gradientOverlayLVA.visible = true;
			}
			else if (this.m_isHiddenInVegetation)
			{
				this.m_informationBarLVA.labelTxt.text = this.m_lstrHiddenInVegetation;
				this.m_informationBarLVA.visible = true;
				this.m_gradientOverlayLVA.visible = true;
			}
			else
			{
				this.m_informationBarLVA.visible = false;
				this.m_gradientOverlayLVA.visible = false;
			}
		}
		
		public function setTensionMessage(param1:String, param2:int, param3:int):void
		{
			var _loc4_:String = null;
			if (param1 == "")
			{
				this.m_tensionIndicatorMc.visible = false;
			}
			else
			{
				this.m_tensionIndicatorMc.iconMc.gotoAndStop(param2 > 0 ? param2 : 1);
				this.m_tensionIndicatorMc.labelTxt.text = param1.toUpperCase();
				this.m_tensionIndicatorMc.bgMc.height = 23 + (this.m_tensionIndicatorMc.labelTxt.numLines - 1) * 19;
				this.m_tensionIndicatorMc.y = -129 - (this.m_tensionIndicatorMc.labelTxt.numLines - 1) * 19;
				if (param3 >= 1)
				{
					this.m_tensionIndicatorMc.iconMc.gotoAndStop(OutfitAndStatusMarkersVR.ICON_UNCONSCIOUSWITNESS);
					if (param3 >= 2)
					{
						_loc4_ = String(param3);
						this.m_tensionIndicatorMc.unconMc.labelTxt.text = _loc4_;
						this.m_tensionIndicatorMc.unconMc.bgMc.width = 29 + _loc4_.length * 12;
						this.m_tensionIndicatorMc.unconMc.bgMc.height = this.m_tensionIndicatorMc.bgMc.height;
					}
				}
				this.m_tensionIndicatorMc.visible = true;
				this.m_tensionIndicatorMc.unconMc.visible = param3 >= 2;
			}
		}
	}
}