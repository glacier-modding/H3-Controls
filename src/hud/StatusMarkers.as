package hud
{
	import common.Animate;
	import common.BaseControl;
	import common.Localization;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.display.MovieClip;
	import flash.external.ExternalInterface;
	import flash.text.TextFormat;
	
	public class StatusMarkers extends BaseControl
	{
		
		private var m_view:StatusMarkerView;
		
		public var borderMc:MovieClip;
		
		public var gradientOverlay:MovieClip;
		
		public var gradientOverlayLVA:MovieClip;
		
		public var informationBarLVA:MovieClip;
		
		public var informationBarMinimapHidden:MovieClip;
		
		public var alertMc:MovieClip;
		
		public var tensionIndicatorMc:MovieClip;
		
		public var trespassingIndicatorMc:MovieClip;
		
		public var mapHiddenBg_Container:MovieClip;
		
		private var m_trespassingInitDelay:Number = 0.1;
		
		private var m_trespassingIsActive:Boolean = false;
		
		private var m_isTrespassing:Boolean = false;
		
		private var m_isHostileArea:Boolean = false;
		
		private var m_isHiddenInCrowd:Boolean = false;
		
		private var m_isHiddenInVegetation:Boolean = false;
		
		private var m_hiddenStateFirstTimeInitiated:Boolean;
		
		private var m_labelTxtTextFormat:TextFormat;
		
		private var m_previousMsg:String;
		
		private var m_witnessShown:Boolean;
		
		private var m_minimapHidden:Boolean;
		
		public function StatusMarkers()
		{
			super();
			this.m_view = new StatusMarkerView();
			addChild(this.m_view);
			this.borderMc = this.m_view.borderMc;
			this.gradientOverlay = this.m_view.gradientOverlay;
			this.gradientOverlayLVA = this.m_view.gradientOverlayLVA;
			this.informationBarLVA = this.m_view.informationBarLVA;
			this.informationBarMinimapHidden = this.m_view.informationBarMinimapHidden;
			this.alertMc = this.m_view.alertMc;
			this.tensionIndicatorMc = this.m_view.tensionIndicatorMc;
			this.trespassingIndicatorMc = this.m_view.trespassingIndicatorMc;
			this.mapHiddenBg_Container = this.m_view.mapHiddenBg_Container;
			this.alertMc.visible = false;
			this.borderMc.alpha = 0.6;
			this.borderMc.width = 212;
			this.borderMc.height = 212;
			this.gradientOverlay.width = 211;
			this.gradientOverlay.height = 211;
			this.gradientOverlay.alpha = 0.6;
			this.gradientOverlayLVA.alpha = 0;
			this.informationBarLVA.alpha = 0;
			this.informationBarLVA.y = -112;
			this.informationBarLVA.iconMc.gotoAndStop(6);
			this.informationBarLVA.iconMc.alpha = 0;
			this.informationBarLVA.iconMc.scaleX = this.informationBarLVA.iconMc.scaleY = 0;
			this.informationBarMinimapHidden.alpha = 0;
			this.informationBarMinimapHidden.y = 86;
			this.informationBarMinimapHidden.iconMc.gotoAndStop(10);
			this.informationBarMinimapHidden.iconMc.alpha = 0;
			this.informationBarMinimapHidden.iconMc.scaleX = this.informationBarMinimapHidden.iconMc.scaleY = 0;
			this.mapHiddenBg_Container.alpha = 0;
			this.hideTension();
			this.m_labelTxtTextFormat = new TextFormat();
			this.m_labelTxtTextFormat.leading = -3.5;
			this.tensionIndicatorMc.labelTxt.autoSize = "left";
			this.tensionIndicatorMc.labelTxt.multiline = true;
			this.tensionIndicatorMc.labelTxt.wordWrap = true;
			this.tensionIndicatorMc.labelTxt.width = 186;
			this.tensionIndicatorMc.labelTxt.text = "";
			this.tensionIndicatorMc.labelTxt.setTextFormat(this.m_labelTxtTextFormat);
			this.tensionIndicatorMc.bgMc.height = 23;
			this.tensionIndicatorMc.y = -129;
			this.informationBarLVA.labelTxt.autoSize = "left";
			this.informationBarLVA.labelTxt.multiline = true;
			this.informationBarLVA.labelTxt.wordWrap = true;
			this.informationBarLVA.labelTxt.width = 186;
			this.informationBarLVA.labelTxt.text = "";
			this.informationBarLVA.labelTxt.setTextFormat(this.m_labelTxtTextFormat);
			this.informationBarMinimapHidden.labelTxt.autoSize = "left";
			this.informationBarMinimapHidden.labelTxt.multiline = true;
			this.informationBarMinimapHidden.labelTxt.wordWrap = true;
			this.informationBarMinimapHidden.labelTxt.width = 186;
			this.informationBarMinimapHidden.labelTxt.text = "";
			this.informationBarMinimapHidden.labelTxt.setTextFormat(this.m_labelTxtTextFormat);
			MenuUtils.setupTextUpper(this.informationBarMinimapHidden.labelTxt, Localization.get("UI_MENU_ELEMENT_NO_CONTENT"), 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
			this.hideTrespassing(false);
			this.trespassingIndicatorMc.labelTxt.text = "";
		}
		
		public function onSetData(param1:Object):void
		{
			this.m_isTrespassing = false;
			this.m_isHostileArea = false;
			if (param1.bDeepTrespassing)
			{
				this.m_isHostileArea = true;
			}
			else if (param1.bTrespassing)
			{
				this.m_isTrespassing = true;
			}
			Animate.kill(this);
			Animate.delay(this, this.m_trespassingInitDelay, this.checkTrespassing);
		}
		
		override public function onSetSize(param1:Number, param2:Number):void
		{
			this.m_view.scaleX = param1;
			this.m_view.scaleY = param2;
		}
		
		private function checkTrespassing():void
		{
			if (this.m_isHostileArea)
			{
				this.showTrespassing(Localization.get("EGAME_TEXT_SL_HOSTILEAREA"));
			}
			else if (this.m_isTrespassing)
			{
				this.showTrespassing(Localization.get("EGAME_TEXT_SL_TRESPASSING_ON"));
			}
			else if (this.m_trespassingIsActive)
			{
				this.clearTrespassing();
			}
		}
		
		private function showTrespassing(param1:String = ""):void
		{
			this.clearTrespassingIndicatorAnimations();
			this.setTrespassingMessage(param1);
			this.m_trespassingIsActive = true;
		}
		
		private function clearTrespassing():void
		{
			this.pulsate(false);
			this.hideTrespassing(true);
		}
		
		private function hideTrespassing(param1:Boolean):void
		{
			var animate:Boolean = param1;
			this.m_trespassingIsActive = false;
			this.clearTrespassingIndicatorAnimations();
			this.playSound("play_ui_trespass_deactivate");
			this.trespassingIndicatorMc.overlayMc.alpha = 0;
			this.trespassingIndicatorMc.pulseMc.alpha = 0;
			this.trespassingIndicatorMc.bgGradient.alpha = 0;
			this.trespassingIndicatorMc.iconMc.alpha = 0;
			if (animate)
			{
				Animate.to(this.trespassingIndicatorMc.labelTxt, 0.3, 0, {"alpha": 0}, Animate.ExpoOut);
				Animate.fromTo(this.trespassingIndicatorMc.bgMc, 0.3, 0, {"y": 11.5, "scaleY": 1}, {"y": 0, "scaleY": 0}, Animate.ExpoOut, function():void
				{
					trespassingIndicatorMc.visible = false;
				});
			}
			else
			{
				this.trespassingIndicatorMc.visible = false;
			}
			this.setTrespassingMessage();
		}
		
		private function setTrespassingMessage(param1:String = ""):void
		{
			var DISABLE_MIN_HEIGHT:Number = NaN;
			var MIN_FONT_SIZE:Number = NaN;
			var msg:String = param1;
			if (msg != "")
			{
				if (msg != this.m_previousMsg)
				{
					this.playSound(this.m_isHostileArea ? "play_ui_deeptrespass_activate" : "play_ui_trespass_activate");
					this.trespassingIndicatorMc.iconMc.alpha = 0;
					this.trespassingIndicatorMc.labelTxt.alpha = 0;
					if (!this.m_trespassingIsActive)
					{
						this.trespassingIndicatorMc.visible = true;
						this.trespassingIndicatorMc.y = -11.5;
						this.trespassingIndicatorMc.bgMc.y = 11.5;
						this.trespassingIndicatorMc.bgMc.scaleY = 1;
						this.trespassingIndicatorMc.pulseMc.alpha = 0;
						this.trespassingIndicatorMc.overlayMc.alpha = 1;
						Animate.fromTo(this.trespassingIndicatorMc.overlayMc, 0.1, 0, {"scaleY": 9.13}, {"scaleY": 1}, Animate.ExpoIn);
						Animate.fromTo(this.trespassingIndicatorMc.bgGradient, 0.3, 0, {"alpha": 0}, {"alpha": 0.3}, Animate.ExpoIn);
						Animate.to(this.trespassingIndicatorMc, 0.3, 0.1, {"y": 105}, Animate.ExpoOut, function():void
						{
							pulsate(true);
						});
					}
					else
					{
						this.trespassingIndicatorMc.overlayMc.scaleY = 1;
						this.trespassingIndicatorMc.bgGradient.alpha = 0.3;
						this.trespassingIndicatorMc.y = 105;
					}
					Animate.fromTo(this.trespassingIndicatorMc.iconMc, 0.3, 0.1, {"alpha": 0}, {"alpha": 1}, Animate.Linear);
					Animate.fromTo(this.trespassingIndicatorMc.labelTxt, 0.3, 0.15, {"alpha": 0}, {"alpha": 1}, Animate.Linear);
				}
				DISABLE_MIN_HEIGHT = -1;
				MIN_FONT_SIZE = 9;
				MenuUtils.setupTextAndShrinkToFitUpper(this.trespassingIndicatorMc.labelTxt, msg, 18, MenuConstants.FONT_TYPE_MEDIUM, 184, DISABLE_MIN_HEIGHT, MIN_FONT_SIZE, MenuConstants.FontColorGreyUltraDark);
			}
			this.m_previousMsg = msg;
		}
		
		private function clearTrespassingIndicatorAnimations():void
		{
			Animate.kill(this.trespassingIndicatorMc);
			Animate.kill(this.trespassingIndicatorMc.bgGradient);
			Animate.kill(this.trespassingIndicatorMc.bgMc);
			Animate.kill(this.trespassingIndicatorMc.iconMc);
			Animate.kill(this.trespassingIndicatorMc.labelTxt);
		}
		
		private function pulsate(param1:Boolean):void
		{
			Animate.kill(this.trespassingIndicatorMc.overlayMc);
			Animate.kill(this.trespassingIndicatorMc.pulseMc);
			Animate.kill(this.trespassingIndicatorMc.bgGradient);
			this.trespassingIndicatorMc.overlayMc.alpha = 1;
			this.trespassingIndicatorMc.pulseMc.alpha = 0;
			this.trespassingIndicatorMc.bgGradient.alpha = 0.3;
			if (param1)
			{
				this.pulsateIn();
			}
		}
		
		private function pulsateIn():void
		{
			this.trespassingIndicatorMc.pulseMc.scaleX = 1.1;
			this.trespassingIndicatorMc.pulseMc.alpha = 0;
			Animate.fromTo(this.trespassingIndicatorMc.overlayMc, 3, 1, {"alpha": 1}, {"alpha": 0}, Animate.ExpoIn, this.pulsateOut);
			Animate.fromTo(this.trespassingIndicatorMc.bgGradient, 3, 1, {"alpha": 0.3}, {"alpha": 0.1}, Animate.ExpoIn);
		}
		
		private function pulsateOut():void
		{
			this.trespassingIndicatorMc.overlayMc.alpha = 1;
			this.trespassingIndicatorMc.bgGradient.alpha = 0.3;
			Animate.fromTo(this.trespassingIndicatorMc.pulseMc, 0.3, 0, {"alpha": 1, "scaleX": 1.1}, {"alpha": 0, "scaleX": 1.4}, Animate.ExpoOut, this.pulsateIn);
		}
		
		public function setTensionMessage(param1:String, param2:Number, param3:int):void
		{
			var _loc4_:String = null;
			Animate.kill(this.tensionIndicatorMc.unconMc);
			this.tensionIndicatorMc.unconMc.alpha = 0;
			if (param1 != "")
			{
				this.tensionIndicatorMc.iconMc.gotoAndStop(param2 > 0 ? param2 : 1);
				MenuUtils.setupTextUpper(this.tensionIndicatorMc.labelTxt, param1, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
				this.tensionIndicatorMc.labelTxt.setTextFormat(this.m_labelTxtTextFormat);
				this.tensionIndicatorMc.bgMc.height = 23 + (this.tensionIndicatorMc.labelTxt.numLines - 1) * 19;
				this.tensionIndicatorMc.y = -129 - (this.tensionIndicatorMc.labelTxt.numLines - 1) * 19;
				if (!this.m_witnessShown)
				{
					this.showTension();
				}
				if (param3 >= 1)
				{
					this.tensionIndicatorMc.iconMc.gotoAndStop(8);
					if (param3 >= 2)
					{
						_loc4_ = String(param3);
						MenuUtils.setupText(this.tensionIndicatorMc.unconMc.labelTxt, _loc4_, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
						this.tensionIndicatorMc.unconMc.bgMc.width = 29 + _loc4_.length * 12;
						this.tensionIndicatorMc.unconMc.bgMc.height = this.tensionIndicatorMc.bgMc.height;
						Animate.fromTo(this.tensionIndicatorMc.unconMc, 0.2, 0.3, {"alpha": 0, "x": 150}, {"alpha": 1, "x": 212}, Animate.ExpoOut);
					}
					this.m_witnessShown = true;
				}
				else
				{
					this.m_witnessShown = false;
					this.showTension();
				}
			}
			else
			{
				this.m_witnessShown = false;
				this.hideTension();
			}
		}
		
		private function showTension():void
		{
			this.clearTensionAnimations();
			this.tensionIndicatorMc.visible = true;
			this.tensionIndicatorMc.alpha = 0;
			this.tensionIndicatorMc.bgGradient.alpha = 0;
			this.tensionIndicatorMc.iconMc.alpha = 0;
			this.tensionIndicatorMc.labelTxt.alpha = 0;
			Animate.fromTo(this.tensionIndicatorMc, 0.2, 0, {"alpha": 0}, {"alpha": 1}, Animate.ExpoOut);
			Animate.fromTo(this.tensionIndicatorMc.bgGradient, 0.5, 0, {"alpha": 0}, {"alpha": 0.4}, Animate.ExpoOut);
			Animate.fromTo(this.tensionIndicatorMc.iconMc, 0.3, 0.1, {"alpha": 0, "scaleX": 0, "scaleY": 0}, {"alpha": 1, "scaleX": 1, "scaleY": 1}, Animate.BackOut);
			Animate.fromTo(this.tensionIndicatorMc.labelTxt, 0.3, 0.15, {"alpha": 0, "x": 16}, {"alpha": 1, "x": 21}, Animate.ExpoOut);
		}
		
		private function hideTension():void
		{
			this.clearTensionAnimations();
			this.tensionIndicatorMc.unconMc.alpha = 0;
			Animate.to(this.tensionIndicatorMc, 0.5, 0, {"alpha": 0}, Animate.ExpoOut, function():void
			{
				tensionIndicatorMc.labelTxt.text = "";
				tensionIndicatorMc.visible = false;
			});
		}
		
		private function clearTensionAnimations():void
		{
			Animate.kill(this.tensionIndicatorMc);
			Animate.kill(this.tensionIndicatorMc.iconMc);
			Animate.kill(this.tensionIndicatorMc.bgGradient);
			Animate.kill(this.tensionIndicatorMc.labelTxt);
			Animate.kill(this.tensionIndicatorMc.unconMc);
		}
		
		public function hiddenInCrowd(param1:Boolean):void
		{
			this.m_isHiddenInCrowd = param1;
			if (param1)
			{
				MenuUtils.setupTextUpper(this.informationBarLVA.labelTxt, Localization.get("UI_MENU_LVA_BLENDING_IN_CROWD"), 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
			}
			this.informationBarLVA.labelTxt.setTextFormat(this.m_labelTxtTextFormat);
			this.setGradientOverlayLVA(this.m_isHiddenInCrowd || this.m_isHiddenInVegetation);
		}
		
		public function hiddenInVegetation(param1:Boolean):void
		{
			this.m_isHiddenInVegetation = param1;
			if (param1)
			{
				MenuUtils.setupTextUpper(this.informationBarLVA.labelTxt, Localization.get("UI_MENU_LVA_HIDDEN"), 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
			}
			this.informationBarLVA.labelTxt.setTextFormat(this.m_labelTxtTextFormat);
			this.setGradientOverlayLVA(this.m_isHiddenInCrowd || this.m_isHiddenInVegetation);
		}
		
		private function setGradientOverlayLVA(param1:Boolean):void
		{
			Animate.kill(this.gradientOverlayLVA);
			Animate.kill(this.informationBarLVA);
			Animate.kill(this.informationBarLVA.iconMc);
			if (!this.m_hiddenStateFirstTimeInitiated && param1)
			{
				this.m_hiddenStateFirstTimeInitiated = true;
			}
			if (this.m_hiddenStateFirstTimeInitiated)
			{
				this.playSound(param1 ? "play_ui_crowd_blendin" : "play_ui_crowd_blendout");
			}
			Animate.to(this.gradientOverlayLVA, 0.5, 0, {"alpha": (param1 ? 0.9 : 0)}, Animate.ExpoOut);
			Animate.to(this.informationBarLVA, 0.5, 0, {"y": (param1 ? -104 : -112), "alpha": (param1 ? 0.9 : 0)}, Animate.ExpoOut);
			Animate.to(this.informationBarLVA.iconMc, 0.5, 0, {"alpha": (param1 ? 1 : 0), "scaleX": (param1 ? 1 : 0), "scaleY": (param1 ? 1 : 0)}, Animate.ExpoOut);
		}
		
		public function minimapHidden(param1:Boolean):void
		{
			var minimapHiddenBg:minimapHiddenBgView = null;
			var hidden:Boolean = param1;
			if (hidden && !this.m_minimapHidden)
			{
				minimapHiddenBg = new minimapHiddenBgView();
				this.mapHiddenBg_Container.addChild(minimapHiddenBg);
				this.m_minimapHidden = true;
			}
			if (this.m_minimapHidden)
			{
				Animate.kill(this.informationBarMinimapHidden);
				Animate.kill(this.informationBarMinimapHidden.iconMc);
				Animate.kill(this.mapHiddenBg_Container);
				Animate.to(this.informationBarMinimapHidden, 0.5, 0, {"y": (hidden ? 78 - (this.informationBarMinimapHidden.labelTxt.numLines - 1) * 17 : 86), "alpha": (hidden ? 0.9 : 0)}, Animate.ExpoOut);
				Animate.to(this.informationBarMinimapHidden.iconMc, 0.5, 0, {"alpha": (hidden ? 1 : 0), "scaleX": (hidden ? 1 : 0), "scaleY": (hidden ? 1 : 0)}, Animate.ExpoOut);
				Animate.to(this.mapHiddenBg_Container, 0.5, 0, {"alpha": (hidden ? 1 : 0)}, Animate.ExpoOut, function():void
				{
					if (!hidden)
					{
						mapHiddenBg_Container.removeChildAt(0);
						m_minimapHidden = false;
					}
				});
			}
		}
		
		public function playSound(param1:String):void
		{
			ExternalInterface.call("PlaySound", param1);
		}
	}
}
