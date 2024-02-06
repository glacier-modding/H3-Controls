package hud
{
	import common.Animate;
	import common.BaseControl;
	import common.CommonUtils;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import scaleform.gfx.Extensions;
	
	public class Breadcrumb extends BaseControl
	{
		
		private var m_view:breadcrumbView;
		
		private var m_scaleMod:Number = 1;
		
		private var m_icon:String;
		
		private var m_state:int = 0;
		
		private var m_cycles:int = 5;
		
		private var m_speed:Number = 0.4;
		
		private var m_discoverySymbol:String;
		
		private var m_hideDistanceDisplay:Boolean;
		
		private var m_attentionOutline:AttentionOutlineView;
		
		private var m_noResolutionScale:Boolean = false;
		
		public function Breadcrumb()
		{
			super();
			this.m_icon = "";
			this.m_view = new breadcrumbView();
			this.m_view.distance_txt.height *= 2;
			addChild(this.m_view);
			this.SetShowText(false);
		}
		
		public function onSetData(param1:Object):void
		{
			var resolutionScale:Number;
			var nMeters:int = 0;
			var distanceTextSize:int = 0;
			var data:Object = param1;
			if (data.id == "distance" && this.m_icon != "slappower" && !this.m_hideDistanceDisplay)
			{
				nMeters = int(data.distance);
				this.m_view.distance_txt.visible = nMeters > 0 ? true : false;
				distanceTextSize = ControlsMain.getDisplaySize() == ControlsMain.DISPLAY_SIZE_SMALL ? 24 : 12;
				MenuUtils.setupText(this.m_view.distance_txt, nMeters.toString() + "m", distanceTextSize, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
			}
			else
			{
				this.MainText = String(data.maintext) || "";
				this.SubText = String(data.subtext) || "";
			}
			if (data.progress)
			{
				if (this.m_icon == "missionobjective" || this.m_icon == "discovery" || this.m_icon == "discovery_a" || this.m_icon == "discovery_b" || this.m_icon == "discovery_c" || this.m_icon == "targetdiscovery" || this.m_icon == "location" || this.m_icon == "exit")
				{
					if (this.m_state == 1)
					{
						this.m_view.discoveryicon.progression.gotoAndStop(Math.ceil(data.progress * 100));
					}
				}
				if (this.m_icon == "slappower")
				{
					Animate.to(this.m_view.bar_mc.power_mc, 0.2, 0, {"scaleX": Math.min(data.progress, 1)}, Animate.ExpoOut);
					if (data.progress > 0)
					{
						this.m_view.bar_mc.icon_mc.scaleX = this.m_view.bar_mc.icon_mc.scaleY = 1.25;
						Animate.to(this.m_view.bar_mc.icon_mc, 0.15, 0.05, {"scaleX": 1, "scaleY": 1}, Animate.ExpoOut);
					}
				}
			}
			else if (this.m_icon == "slappower" && data.progress == 0)
			{
				this.m_view.bar_mc.power_mc.scaleX = 0;
			}
			if (data.state != null)
			{
				if (this.m_icon == "missionobjective" || this.m_icon == "discovery" || this.m_icon == "discovery_a" || this.m_icon == "discovery_b" || this.m_icon == "discovery_c" || this.m_icon == "targetdiscovery")
				{
					if (data.state != this.m_state)
					{
						if (data.state == -1)
						{
							this.pulsateScannerTraceIcon(false);
							this.m_view.discoveryicon.tracer.alpha = 1;
							Animate.to(this.m_view.discoveryicon.tracer, 0.4, 0, {"alpha": 0, "scaleX": 1.5, "scaleY": 1.5}, Animate.ExpoOut);
							this.m_view.discoveryicon.progression.gotoAndStop(1);
							this.m_view.discoveryicon.symbol.gotoAndStop(this.m_discoverySymbol);
							this.m_view.discoveryicon.symbol.alpha = 1;
							Animate.kill(this.m_view.discoveryicon.bg);
							this.m_view.discoveryicon.bg.gotoAndStop(1);
							this.m_view.discoveryicon.bg.alpha = 1;
						}
						else if (data.state == 0)
						{
							this.pulsateScannerTraceIcon(false);
							this.m_view.discoveryicon.tracer.alpha = 1;
							Animate.to(this.m_view.discoveryicon.tracer, 0.4, 0, {"alpha": 0, "scaleX": 1.5, "scaleY": 1.5}, Animate.ExpoOut);
							this.m_view.discoveryicon.progression.gotoAndStop(1);
							this.m_view.discoveryicon.symbol.gotoAndStop(this.m_discoverySymbol);
							this.m_view.discoveryicon.symbol.alpha = 1;
							Animate.kill(this.m_view.discoveryicon.bg);
							this.m_view.discoveryicon.bg.gotoAndStop(1);
							this.m_view.discoveryicon.bg.alpha = 0;
							Animate.to(this.m_view.discoveryicon.bg, 0.4, 0, {"alpha": 0.4}, Animate.ExpoOut);
						}
						else if (data.state == 1)
						{
							this.pulsateScannerTraceIcon(true);
							this.m_view.discoveryicon.symbol.gotoAndStop(this.m_discoverySymbol);
							this.m_view.discoveryicon.symbol.alpha = 1;
							Animate.kill(this.m_view.discoveryicon.bg);
							this.m_view.discoveryicon.bg.gotoAndStop(1);
							this.m_view.discoveryicon.bg.alpha = 0.4;
						}
						else if (data.state == 2)
						{
							this.pulsateScannerTraceIcon(false);
							this.m_view.discoveryicon.tracer.alpha = 1;
							Animate.to(this.m_view.discoveryicon.tracer, 0.4, 0, {"alpha": 0, "scaleX": 1.5, "scaleY": 1.5}, Animate.ExpoOut);
							this.m_view.discoveryicon.progression.gotoAndStop(1);
							this.m_view.discoveryicon.symbol.gotoAndStop("symbol_error");
							this.m_view.discoveryicon.symbol.alpha = 1;
							Animate.kill(this.m_view.discoveryicon.bg);
							this.m_view.discoveryicon.bg.gotoAndStop(2);
							this.m_view.discoveryicon.bg.alpha = 0;
							Animate.to(this.m_view.discoveryicon.bg, 0.4, 0, {"alpha": 0.4}, Animate.ExpoOut);
						}
						else if (data.state == 3 && this.m_icon == "targetdiscovery")
						{
							this.pulsateTargetDiscovery(false);
							this.m_view.discoveryicon.tracer.alpha = 1;
							this.m_view.discoveryicon.progression.gotoAndStop(1);
							this.m_view.discoveryicon.symbol.gotoAndStop(this.m_discoverySymbol);
							this.m_view.discoveryicon.symbol.alpha = 1;
							Animate.kill(this.m_view.discoveryicon.bg);
							this.m_view.discoveryicon.bg.gotoAndStop(1);
							this.m_view.discoveryicon.bg.alpha = 1;
							this.pulsateTargetDiscovery(true, this.m_cycles, this.m_speed);
						}
						else if (data.state == 4 && this.m_icon == "targetdiscovery")
						{
							this.pulsateTargetDiscovery(false);
							this.m_view.discoveryicon.tracer.alpha = 1;
							this.m_view.discoveryicon.progression.gotoAndStop(1);
							this.m_view.discoveryicon.symbol.gotoAndStop(this.m_discoverySymbol);
							this.m_view.discoveryicon.symbol.alpha = 1;
							Animate.kill(this.m_view.discoveryicon.bg);
							this.m_view.discoveryicon.bg.gotoAndStop(1);
							this.m_view.discoveryicon.bg.alpha = 1;
							Animate.to(this.m_view.discoveryicon.symbol, 0.4, 0, {"alpha": 0, "scaleX": 0, "scaleY": 0}, Animate.ExpoOut);
							Animate.to(this.m_view.discoveryicon.bg, 0.4, 0, {"alpha": 0, "scaleX": 0, "scaleY": 0}, Animate.ExpoOut);
							Animate.to(this.m_view.discoveryicon.tracer, 0.4, 0, {"alpha": 0, "scaleX": 1.5, "scaleY": 1.5}, Animate.ExpoOut, function():void
							{
								m_view.distance_txt.alpha = 0;
							});
						}
						this.m_state = data.state;
					}
				}
				if (this.m_icon == "location" || this.m_icon == "exit")
				{
					if (data.state != this.m_state)
					{
						if (data.state == -1)
						{
							this.pulsateScannerTraceIcon(false);
							this.m_view.discoveryicon.tracer.alpha = 1;
							Animate.to(this.m_view.discoveryicon.tracer, 0.4, 0, {"alpha": 0, "scaleX": 1.5, "scaleY": 1.5}, Animate.ExpoOut);
							this.m_view.discoveryicon.progression.gotoAndStop(1);
							this.m_view.discoveryicon.symbol.gotoAndStop(this.m_discoverySymbol);
							this.m_view.discoveryicon.symbol.alpha = 1;
							Animate.kill(this.m_view.discoveryicon.bg);
							this.m_view.discoveryicon.bg.gotoAndStop(2);
							this.m_view.discoveryicon.bg.alpha = 1;
						}
						else if (data.state == 0)
						{
							this.pulsateScannerTraceIcon(false);
							this.m_view.discoveryicon.tracer.alpha = 1;
							Animate.to(this.m_view.discoveryicon.tracer, 0.4, 0, {"alpha": 0, "scaleX": 1.5, "scaleY": 1.5}, Animate.ExpoOut);
							this.m_view.discoveryicon.progression.gotoAndStop(1);
							this.m_view.discoveryicon.symbol.gotoAndStop(this.m_discoverySymbol);
							this.m_view.discoveryicon.symbol.alpha = 1;
							Animate.kill(this.m_view.discoveryicon.bg);
							this.m_view.discoveryicon.bg.gotoAndStop(2);
							this.m_view.discoveryicon.bg.alpha = 0;
							Animate.to(this.m_view.discoveryicon.bg, 0.4, 0, {"alpha": 0.4}, Animate.ExpoOut);
						}
						else if (data.state == 1)
						{
							this.pulsateScannerTraceIcon(true);
							this.m_view.discoveryicon.symbol.gotoAndStop(this.m_discoverySymbol);
							this.m_view.discoveryicon.symbol.alpha = 1;
							Animate.kill(this.m_view.discoveryicon.bg);
							this.m_view.discoveryicon.bg.gotoAndStop(2);
							this.m_view.discoveryicon.bg.alpha = 1;
						}
						this.m_state = data.state;
					}
				}
			}
			resolutionScale = 1;
			if (!ControlsMain.isVrModeActive())
			{
				resolutionScale = Extensions.visibleRect.height / 1080;
			}
			if (this.m_scaleMod != resolutionScale)
			{
				this.onSetSize(0, 0);
			}
		}
		
		private function pulsateTargetDiscovery(param1:Boolean, param2:int = 0, param3:Number = 0):void
		{
			Animate.kill(this.m_view.discoveryicon.tracer);
			this.m_view.discoveryicon.tracer.alpha = 0;
			this.m_view.discoveryicon.tracer.scaleX = this.m_view.discoveryicon.tracer.scaleY = 1;
			Animate.kill(this.m_view.discoveryicon.bg);
			this.m_view.discoveryicon.bg.scaleX = this.m_view.discoveryicon.bg.scaleY = 1;
			this.m_view.discoveryicon.symbol.scaleX = this.m_view.discoveryicon.symbol.scaleY = 1;
			if (param1)
			{
				this.pulsateTargetDiscoveryCycle(param2, param3);
			}
		}
		
		private function pulsateTargetDiscoveryCycle(param1:int, param2:Number = 0):void
		{
			var cycles:int = param1;
			var speed:Number = param2;
			if (cycles <= 0)
			{
				this.m_view.distance_txt.alpha = 0;
				Animate.to(this.m_view.discoveryicon.symbol, 0.4, 0, {"alpha": 0, "scaleX": 0, "scaleY": 0}, Animate.ExpoOut);
				Animate.to(this.m_view.discoveryicon.bg, 0.4, 0, {"alpha": 0, "scaleX": 0, "scaleY": 0}, Animate.ExpoOut);
				return;
			}
			cycles--;
			this.m_view.discoveryicon.bg.scaleX = this.m_view.discoveryicon.bg.scaleY = 1.2;
			Animate.to(this.m_view.discoveryicon.bg, speed, 0, {"scaleX": 1, "scaleY": 1}, Animate.ExpoOut, function():void
			{
				pulsateTargetDiscoveryCycle(cycles, speed);
			});
			this.m_view.discoveryicon.tracer.scaleX = this.m_view.discoveryicon.tracer.scaleY = 1;
			this.m_view.discoveryicon.tracer.alpha = 1;
			Animate.to(this.m_view.discoveryicon.tracer, speed, 0, {"alpha": 0, "scaleX": 1.5, "scaleY": 1.5}, Animate.ExpoOut);
		}
		
		private function pulsateScannerTraceIcon(param1:Boolean):void
		{
			Animate.kill(this.m_view.discoveryicon.tracer);
			this.m_view.discoveryicon.tracer.alpha = 0;
			this.m_view.discoveryicon.tracer.scaleX = this.m_view.discoveryicon.tracer.scaleY = 1;
			Animate.kill(this.m_view.discoveryicon.bg);
			this.m_view.discoveryicon.bg.scaleX = this.m_view.discoveryicon.bg.scaleY = 1;
			this.m_view.discoveryicon.symbol.scaleX = this.m_view.discoveryicon.symbol.scaleY = 1;
			if (param1)
			{
				this.pulsateScannerTraceIconIn();
			}
		}
		
		private function pulsateScannerTraceIconIn():void
		{
			Animate.to(this.m_view.discoveryicon.tracer, 0.3, 0, {"alpha": 1}, Animate.ExpoIn, this.pulsateScannerTraceIconOut);
		}
		
		private function pulsateScannerTraceIconOut():void
		{
			Animate.to(this.m_view.discoveryicon.tracer, 0.1, 0.1, {"alpha": 0}, Animate.ExpoOut, this.pulsateScannerTraceIconIn);
		}
		
		public function set MainText(param1:String):void
		{
			if (param1 == "")
			{
				this.m_view.main_txt.visible = false;
			}
			else
			{
				MenuUtils.setupText(this.m_view.main_txt, param1, 24, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
				this.m_view.main_txt.visible = true;
			}
		}
		
		public function set SubText(param1:String):void
		{
			if (param1 == "")
			{
				this.m_view.sub_txt.visible = false;
			}
			else
			{
				MenuUtils.setupText(this.m_view.sub_txt, param1, 20, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
				this.m_view.sub_txt.visible = true;
			}
		}
		
		public function set IconType(param1:String):void
		{
			this.ChangeIconType(param1);
		}
		
		public function set TargetIdentifiedCycles(param1:int):void
		{
			this.m_cycles = param1;
		}
		
		public function set TargetIdentifiedCycleSpeed(param1:Number):void
		{
			this.m_speed = param1;
		}
		
		public function ChangeIconType(param1:String):void
		{
			this.m_icon = param1;
			if (CommonUtils.hasFrameLabel(this.m_view, param1) && param1 != "")
			{
				this.m_view.gotoAndStop(param1);
				if (param1 == "missionobjective" || param1 == "discovery" || param1 == "discovery_a" || param1 == "discovery_b" || param1 == "discovery_c" || param1 == "targetdiscovery")
				{
					MenuUtils.removeColor(this.m_view.discoveryicon.progression);
					switch (param1)
					{
					case "missionobjective": 
						this.m_discoverySymbol = "symbol_objective";
						break;
					case "discovery": 
						this.m_discoverySymbol = "symbol_question";
						break;
					case "discovery_a": 
						this.m_discoverySymbol = "symbol_a";
						break;
					case "discovery_b": 
						this.m_discoverySymbol = "symbol_b";
						break;
					case "discovery_c": 
						this.m_discoverySymbol = "symbol_c";
						break;
					case "targetdiscovery": 
						this.m_discoverySymbol = "symbol_target";
						MenuUtils.setColor(this.m_view.discoveryicon.progression, MenuConstants.COLOR_RED);
						break;
					default: 
						this.m_discoverySymbol = "symbol_question";
					}
					this.pulsateScannerTraceIcon(false);
					this.m_view.discoveryicon.bg.alpha = 0.4;
					this.m_view.discoveryicon.symbol.gotoAndStop(this.m_discoverySymbol);
				}
				if (this.m_icon == "location" || this.m_icon == "exit")
				{
					MenuUtils.setColor(this.m_view.discoveryicon.progression, MenuConstants.COLOR_GREEN);
					switch (param1)
					{
					case "location": 
						this.m_discoverySymbol = "symbol_location";
						break;
					case "exit": 
						this.m_discoverySymbol = "symbol_exit";
						break;
					default: 
						this.m_discoverySymbol = "symbol_question";
					}
					this.pulsateScannerTraceIcon(false);
					this.m_view.discoveryicon.bg.alpha = 1;
					this.m_view.discoveryicon.symbol.gotoAndStop(this.m_discoverySymbol);
				}
				if (this.m_icon == "slappower")
				{
					this.m_view.bar_mc.power_mc.scaleX = 0;
					this.m_view.distance_txt.visible = false;
				}
			}
		}
		
		private function pulsateAttentionOutline(param1:Boolean):void
		{
			Animate.kill(this.m_attentionOutline);
			this.m_attentionOutline.alpha = 0;
			if (param1)
			{
				this.pulsateAttentionOutlineIn();
			}
		}
		
		private function pulsateAttentionOutlineIn():void
		{
			this.m_attentionOutline.scaleX = this.m_attentionOutline.scaleY = 0.44;
			this.m_attentionOutline.alpha = 0;
			Animate.to(this.m_attentionOutline, 0.5, 0, {"alpha": 1, "scaleX": 0.6, "scaleY": 0.6}, Animate.ExpoIn, this.pulsateAttentionOutlineOut);
		}
		
		private function pulsateAttentionOutlineOut():void
		{
			Animate.to(this.m_attentionOutline, 0.7, 0, {"alpha": 0, "scaleX": 0.66, "scaleY": 0.66}, Animate.ExpoOut, this.pulsateAttentionOutlineDelay);
		}
		
		private function pulsateAttentionOutlineDelay():void
		{
			Animate.delay(this.m_attentionOutline, 0.4, this.pulsateAttentionOutlineIn);
		}
		
		public function showAttentionOutline():void
		{
			if (!this.m_attentionOutline)
			{
				this.m_attentionOutline = new AttentionOutlineView();
				this.m_view.addChild(this.m_attentionOutline);
				this.pulsateAttentionOutline(true);
			}
		}
		
		public function hideAttentionOutline():void
		{
			if (this.m_attentionOutline)
			{
				this.pulsateAttentionOutline(false);
				this.m_view.removeChild(this.m_attentionOutline);
				this.m_attentionOutline = null;
			}
		}
		
		public function SetWithinProximity(param1:Boolean):void
		{
		}
		
		public function set HideDistanceDisplay(param1:Boolean):void
		{
			this.m_hideDistanceDisplay = param1;
		}
		
		public function SetShowText(param1:Boolean):void
		{
			this.m_view.sub_txt.y = this.m_view.main_txt.y + this.m_view.main_txt.textHeight + 6;
			this.m_view.main_txt.visible = param1;
			this.m_view.sub_txt.visible = param1;
		}
		
		public function set noResolutionScale(param1:Boolean):void
		{
			this.m_noResolutionScale = param1;
			this.onSetSize(0, 0);
		}
		
		override public function onSetSize(param1:Number, param2:Number):void
		{
			var _loc3_:Number = 1;
			if (!(this.m_noResolutionScale || ControlsMain.isVrModeActive()))
			{
				_loc3_ = Extensions.visibleRect.height / 1080;
			}
			this.m_scaleMod = this.m_view.scaleX = this.m_view.scaleY = _loc3_;
		}
	}
}
