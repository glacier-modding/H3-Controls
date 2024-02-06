package hud.notification
{
	import common.Animate;
	import common.Localization;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.display.Sprite;
	import flash.external.ExternalInterface;
	
	public class ActionXpBar extends NotificationListener
	{
		
		private var m_container:Sprite;
		
		private var m_view:ActionXpBarView;
		
		private var m_elementYOffset:int = 33;
		
		private var m_elementCount:int = 0;
		
		private var m_yposArray:Array;
		
		private var m_elementsAvailable:Vector.<ActionXpBarView>;
		
		private var m_soundEnabled:Boolean;
		
		private var m_VR_YOffsetFactor:int = 2;
		
		private var m_strPerformanceMasteryXP:String;
		
		public function ActionXpBar()
		{
			this.m_elementsAvailable = new Vector.<ActionXpBarView>();
			this.m_strPerformanceMasteryXP = Localization.get("UI_PERFORMANCE_MASTERY_XP").toUpperCase();
			super();
			if (!ControlsMain.isVrModeActive())
			{
				this.m_VR_YOffsetFactor = 0;
			}
			this.m_container = new Sprite();
			this.m_container.y = this.m_elementYOffset * 20;
			addChild(this.m_container);
			this.m_container.x = -2;
			this.m_yposArray = new Array();
			var _loc1_:uint = 3;
			var _loc2_:Vector.<ActionXpBarView> = new Vector.<ActionXpBarView>();
			while (_loc2_.length < _loc1_)
			{
				_loc2_.push(this.acquireElement());
			}
			while (_loc2_.length > 0)
			{
				this.releaseElement(_loc2_.pop());
			}
		}
		
		override public function ShowNotification(param1:String, param2:String, param3:Object):void
		{
			var _loc9_:String = null;
			param2 = param2.toUpperCase();
			var _loc4_:ActionXpBarView = this.acquireElement();
			var _loc5_:String = param3.xpGain <= 0 ? param2 : param2 + "     +";
			var _loc6_:int = !!param3.isRepeated ? MenuConstants.COLOR_GREY_MEDIUM : (param3.xpGain <= 0 ? MenuConstants.COLOR_RED : MenuConstants.COLOR_WHITE);
			MenuUtils.setTextColor(_loc4_.header, _loc6_);
			MenuUtils.setTextColor(_loc4_.info.infotxt, _loc6_);
			MenuUtils.setTextColor(_loc4_.value, _loc6_);
			_loc4_.header.text = _loc5_;
			_loc4_.info.infotxt.text = param3.additionaldescription != null ? MenuUtils.removeHtmlLineBreaks(param3.additionaldescription).toUpperCase() : "";
			_loc4_.value.text = param3.xpGain <= 0 ? "" : String(param3.xpGain) + " " + this.m_strPerformanceMasteryXP;
			_loc4_.info.scaleX = _loc4_.info.scaleY = 0;
			_loc4_.info.alpha = 0;
			var _loc7_:int = Math.floor(_loc4_.header.textWidth + _loc4_.value.textWidth);
			var _loc8_:int = Math.floor(_loc4_.value.textWidth);
			_loc4_.header.text = param2;
			_loc4_.header.x = Math.floor(_loc4_.header.textWidth) / -2;
			_loc4_.value.x = _loc7_ / 2 - _loc8_;
			_loc4_.value.text = "";
			_loc4_.bg.alpha = 0;
			_loc4_.bg.width = _loc7_ + 40;
			_loc4_.alpha = 0;
			switch (true)
			{
			case param3.xpGain <= 0: 
				_loc9_ = "fail";
				break;
			case param3.xpGain > 0 && param3.xpGain < 100: 
				_loc9_ = "common";
				break;
			case param3.xpGain >= 100 && param3.xpGain < 200: 
				_loc9_ = "fair";
				break;
			case param3.xpGain >= 200 && param3.xpGain < 300: 
				_loc9_ = "good";
				break;
			case param3.xpGain >= 300 && param3.xpGain < 400: 
				_loc9_ = "excellent";
				break;
			case param3.xpGain >= 400: 
				_loc9_ = "awesome";
				break;
			default: 
				_loc9_ = "common";
			}
			var _loc10_:int = this.m_yposArray[this.m_yposArray.length - 1] + this.m_elementYOffset;
			this.m_yposArray.push(_loc10_ + (param3.additionaldescription != null ? 26 : 0));
			_loc4_.y = _loc10_ - this.m_elementYOffset * (20 + this.m_VR_YOffsetFactor);
			var _loc11_:Object = {"element": _loc4_, "elementindex": this.m_yposArray.length, "description": _loc5_, "xpgain": param3.xpGain, "headerxoffset": _loc7_ / -2, "awesomeness": _loc9_, "isRepeated": param3.isRepeated};
			this.startAnimation(_loc11_);
		}
		
		private function startAnimation(param1:Object):void
		{
			Animate.kill(param1.element);
			Animate.offset(param1.element, 0.6, param1.elementindex * 0.1, {"y": -this.m_elementYOffset}, Animate.ExpoOut, this.endAnimation, param1);
			Animate.addTo(param1.element, 0.6, param1.elementindex * 0.1, {"alpha": 1}, Animate.ExpoOut);
			if (this.m_yposArray.length >= 2)
			{
				Animate.offset(this.m_container, 0.2, 0, {"y": -this.m_elementYOffset}, Animate.ExpoOut);
			}
		}
		
		private function endAnimation(param1:Object):void
		{
			var speed:Number;
			var scaleFactorX:Number;
			var bgAlpha:Number;
			var actionXpElementData:Object = param1;
			Animate.kill(actionXpElementData.element);
			Animate.kill(actionXpElementData.element.bg);
			Animate.to(actionXpElementData.element.header, 0.2, 0, {"x": actionXpElementData.headerxoffset}, Animate.ExpoOut);
			actionXpElementData.element.header.text = actionXpElementData.description;
			Animate.to(actionXpElementData.element.info, 0.2, 0.2, {"alpha": 1, "scaleX": 1, "scaleY": 1}, Animate.ExpoOut);
			speed = actionXpElementData.xpgain / 500;
			if (actionXpElementData.xpgain > 0)
			{
				Animate.fromTo(actionXpElementData.element.value, speed, 0, {"intAnimation": 0}, {"intAnimation": actionXpElementData.xpgain}, Animate.ExpoOut, function():void
				{
					actionXpElementData.element.value.text = String(actionXpElementData.xpgain) + " " + m_strPerformanceMasteryXP;
				});
			}
			scaleFactorX = actionXpElementData.element.bg.scaleX + 0.6;
			bgAlpha = 0;
			if (actionXpElementData.awesomeness == "common")
			{
				this.playSound("ScoreCommon");
				bgAlpha = 0.3;
			}
			else if (actionXpElementData.awesomeness == "fair")
			{
				this.playSound("ScoreFair");
				bgAlpha = 0.6;
			}
			else if (actionXpElementData.awesomeness == "good")
			{
				this.playSound("ScoreGood");
				bgAlpha = 0.8;
			}
			else if (actionXpElementData.awesomeness == "excellent")
			{
				this.playSound("ScoreGood");
				bgAlpha = 0.8;
			}
			else if (actionXpElementData.awesomeness == "awesome")
			{
				this.playSound("ScoreAwesome");
				bgAlpha = 1;
			}
			else if (actionXpElementData.awesomeness == "fail")
			{
				this.playSound("ScoreFail");
				MenuUtils.setTintColor(actionXpElementData.element.bg, MenuUtils.TINT_COLOR_MAGENTA_DARK, false);
			}
			if (!actionXpElementData.isRepeated)
			{
				actionXpElementData.element.bg.alpha = bgAlpha;
				Animate.to(actionXpElementData.element.bg, 0.8, 0, {"scaleX": scaleFactorX, "alpha": 0}, Animate.ExpoOut);
			}
			Animate.offset(actionXpElementData.element, 0.4, 0.8 + actionXpElementData.elementindex * 0.1, {"y": actionXpElementData.elementindex * (this.m_elementYOffset * -4)}, Animate.ExpoIn, this.finishAnimation, actionXpElementData.element);
		}
		
		private function finishAnimation(param1:ActionXpBarView):void
		{
			Animate.kill(param1);
			this.m_yposArray.shift();
			if (this.m_yposArray.length == 0)
			{
				this.m_container.y = this.m_elementYOffset * 20;
			}
			this.releaseElement(param1);
		}
		
		public function playSound(param1:String):void
		{
			if (!this.m_soundEnabled)
			{
				return;
			}
			ExternalInterface.call("PlaySound", param1);
		}
		
		public function SetSoundEnabled(param1:Boolean):void
		{
			this.m_soundEnabled = param1;
		}
		
		public function testActionXPBar():void
		{
			var _loc4_:Boolean = false;
			var _loc1_:Object = {"xpGain": 500, "isRepeated": false};
			var _loc2_:Object = {"xpGain": 0, "isRepeated": false};
			var _loc3_:int = 0;
			while (_loc3_ < 7)
			{
				_loc4_ = Math.random() > 0.5 ? true : false;
				this.ShowNotification("Wuss", "MMMMMMMM MMMMMMMM", _loc4_ ? _loc1_ : _loc2_);
				_loc3_++;
			}
		}
		
		private function acquireElement():ActionXpBarView
		{
			var _loc1_:ActionXpBarView = null;
			if (this.m_elementsAvailable.length > 0)
			{
				_loc1_ = this.m_elementsAvailable.pop();
				_loc1_.visible = true;
			}
			else
			{
				_loc1_ = new ActionXpBarView();
				_loc1_.header.autoSize = "left";
				_loc1_.value.autoSize = "left";
				MenuUtils.setupText(_loc1_.header, "", 18, MenuConstants.FONT_TYPE_MEDIUM);
				MenuUtils.setupText(_loc1_.info.infotxt, "", 18, MenuConstants.FONT_TYPE_MEDIUM);
				MenuUtils.setupText(_loc1_.value, "", 18, MenuConstants.FONT_TYPE_MEDIUM);
				this.m_container.addChild(_loc1_);
			}
			return _loc1_;
		}
		
		private function releaseElement(param1:ActionXpBarView):void
		{
			MenuUtils.removeTint(param1.bg);
			param1.visible = false;
			this.m_elementsAvailable.push(param1);
		}
	}
}
