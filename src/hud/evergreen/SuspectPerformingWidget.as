package hud.evergreen
{
	import common.Animate;
	import common.BaseControl;
	import common.Localization;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	
	public class SuspectPerformingWidget extends BaseControl
	{
		
		private var m_view:SuspectPerformingView;
		
		private var currentIcon:String = "default";
		
		private var currentState:String = "";
		
		private var meterShowing:Boolean = false;
		
		public function SuspectPerformingWidget()
		{
			this.m_view = new SuspectPerformingView();
			super();
			this.m_view.name = "m_view";
			addChild(this.m_view);
			this.m_view.visible = false;
			this.m_view.distance_txt.visible = false;
			this.m_view.scaleX = 0;
			this.m_view.scaleY = 0;
		}
		
		public function hide():void
		{
			this.animateHide();
		}
		
		public function showDefault():void
		{
			this.setIcon("default");
		}
		
		public function showSmoker():void
		{
			this.setIcon("Smoker");
		}
		
		public function showAllergic():void
		{
			this.setIcon("Allergic");
		}
		
		public function showSweetTooth():void
		{
			this.setIcon("SweetTooth");
		}
		
		public function showBookworm():void
		{
			this.setIcon("Bookworm");
		}
		
		public function showNervous():void
		{
			this.setIcon("Nervous");
		}
		
		public function showThirsty():void
		{
			this.setIcon("Thirsty");
		}
		
		public function showHungry():void
		{
			this.setIcon("Hungry");
		}
		
		public function showHandoverMeeting():void
		{
			this.setIcon("HandoverMeeting");
		}
		
		public function showBusinessMeeting():void
		{
			this.setIcon("BusinessMeeting");
		}
		
		public function showSecretMeeting():void
		{
			this.setIcon("SecretMeeting");
		}
		
		public function showNoMeeting():void
		{
			this.setIcon("NoMeeting");
		}
		
		public function showEscaping():void
		{
			this.setIcon("Escaping");
		}
		
		public function showBurnerPhone():void
		{
			this.setIcon("phone");
		}
		
		public function stateNotSuspect():void
		{
			this.setPrime("notsuspect");
		}
		
		public function stateSuspect():void
		{
			this.setPrime("suspect");
		}
		
		public function statePrimeSuspect():void
		{
			this.setPrime("prime");
		}
		
		private function setPrime(param1:String):void
		{
			if (param1 != this.currentState)
			{
				this.currentState = param1;
				this.animateTransition(this.currentState, this.currentIcon);
			}
		}
		
		private function setIcon(param1:String):void
		{
			if (param1 != this.currentIcon)
			{
				this.currentIcon = param1;
				this.animateTransition(this.currentState, this.currentIcon);
			}
		}
		
		private function animateTransition(param1:String, param2:String):void
		{
			var newState:String = param1;
			var newIcon:String = param2;
			Animate.to(this.m_view, 0.1, 0, {"scaleX": 0.01}, Animate.SineOut, function():void
			{
				m_view.gotoAndStop(newState);
				m_view.icon_mc.gotoAndStop(newIcon);
				animateShow();
			});
		}
		
		private function animateHide():void
		{
			this.currentIcon = "";
			Animate.to(this.m_view, 0.2, 0, {"scaleX": 0.01, "scaleY": 0.01}, Animate.SineOut, function():void
			{
				m_view.visible = false;
			});
		}
		
		private function animateShow():void
		{
			this.m_view.visible = true;
			Animate.to(this.m_view, 0.2, 0, {"scaleX": 1, "scaleY": 1}, Animate.SineOut);
		}
		
		[PROPERTY(HELPTEXT = "Displace distance text - 0 or less hides text")]
		public function setDistance(param1:Number):void
		{
			if (param1 > 0)
			{
				this.m_view.distance_txt.visible = true;
				MenuUtils.setupText(this.m_view.distance_txt, Localization.get("EVERGREEN_HUD_SUSPECT_ESCAPING_DISTANCE") + " " + Math.floor(param1), 20, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			}
			else
			{
				this.m_view.distance_txt.visible = false;
			}
		}
		
		[PROPERTY(CONSTRAINT = "MinValue(0) MaxValue(1)", HELPTEXT = "Show progress on icon - for timer on suspect escaping")]
		public function setProgressBack(param1:Number):void
		{
			if (param1 > 0 && !this.meterShowing)
			{
				this.m_view.back_mc.gotoAndStop("fill");
				this.m_view.icon_mc.gotoAndStop("exit");
				this.meterShowing = true;
				this.m_view.back_mc.fill_mc.scaleY = param1;
			}
			else if (param1 <= 0 && this.meterShowing)
			{
				this.m_view.back_mc.gotoAndStop("normal");
				this.m_view.icon_mc.gotoAndStop(this.currentIcon);
				this.meterShowing = false;
			}
			if (this.meterShowing)
			{
				Animate.to(this.m_view.back_mc.fill_mc, 0.5, 0, {"scaleX": 1, "scaleY": param1}, Animate.SineOut);
			}
		}
	}
}
