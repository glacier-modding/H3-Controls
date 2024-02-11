// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.evergreen.SuspectPerformingWidget

package hud.evergreen {
import common.BaseControl;
import common.Animate;
import common.menu.MenuUtils;
import common.Localization;
import common.menu.MenuConstants;

public class SuspectPerformingWidget extends BaseControl {

	private var m_view:SuspectPerformingView = new SuspectPerformingView();
	private var currentIcon:String = "default";
	private var currentState:String = "";
	private var meterShowing:Boolean = false;

	public function SuspectPerformingWidget() {
		this.m_view.name = "m_view";
		addChild(this.m_view);
		this.m_view.visible = false;
		this.m_view.distance_txt.visible = false;
		this.m_view.scaleX = 0;
		this.m_view.scaleY = 0;
	}

	public function hide():void {
		this.animateHide();
	}

	public function showDefault():void {
		this.setIcon("default");
	}

	public function showSmoker():void {
		this.setIcon("Smoker");
	}

	public function showAllergic():void {
		this.setIcon("Allergic");
	}

	public function showSweetTooth():void {
		this.setIcon("SweetTooth");
	}

	public function showBookworm():void {
		this.setIcon("Bookworm");
	}

	public function showNervous():void {
		this.setIcon("Nervous");
	}

	public function showThirsty():void {
		this.setIcon("Thirsty");
	}

	public function showHungry():void {
		this.setIcon("Hungry");
	}

	public function showHandoverMeeting():void {
		this.setIcon("HandoverMeeting");
	}

	public function showBusinessMeeting():void {
		this.setIcon("BusinessMeeting");
	}

	public function showSecretMeeting():void {
		this.setIcon("SecretMeeting");
	}

	public function showNoMeeting():void {
		this.setIcon("NoMeeting");
	}

	public function showEscaping():void {
		this.setIcon("Escaping");
	}

	public function showBurnerPhone():void {
		this.setIcon("phone");
	}

	public function stateNotSuspect():void {
		this.setPrime("notsuspect");
	}

	public function stateSuspect():void {
		this.setPrime("suspect");
	}

	public function statePrimeSuspect():void {
		this.setPrime("prime");
	}

	private function setPrime(_arg_1:String):void {
		if (_arg_1 != this.currentState) {
			this.currentState = _arg_1;
			this.animateTransition(this.currentState, this.currentIcon);
		}

	}

	private function setIcon(_arg_1:String):void {
		if (_arg_1 != this.currentIcon) {
			this.currentIcon = _arg_1;
			this.animateTransition(this.currentState, this.currentIcon);
		}

	}

	private function animateTransition(newState:String, newIcon:String):void {
		Animate.to(this.m_view, 0.1, 0, {"scaleX": 0.01}, Animate.SineOut, function ():void {
			m_view.gotoAndStop(newState);
			m_view.icon_mc.gotoAndStop(newIcon);
			animateShow();
		});
	}

	private function animateHide():void {
		this.currentIcon = "";
		Animate.to(this.m_view, 0.2, 0, {
			"scaleX": 0.01,
			"scaleY": 0.01
		}, Animate.SineOut, function ():void {
			m_view.visible = false;
		});
	}

	private function animateShow():void {
		this.m_view.visible = true;
		Animate.to(this.m_view, 0.2, 0, {
			"scaleX": 1,
			"scaleY": 1
		}, Animate.SineOut);
	}

	[PROPERTY(HELPTEXT="Displace distance text - 0 or less hides text")]
	public function setDistance(_arg_1:Number):void {
		if (_arg_1 > 0) {
			this.m_view.distance_txt.visible = true;
			MenuUtils.setupText(this.m_view.distance_txt, ((Localization.get("EVERGREEN_HUD_SUSPECT_ESCAPING_DISTANCE") + " ") + Math.floor(_arg_1)), 20, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		} else {
			this.m_view.distance_txt.visible = false;
		}

	}

	[PROPERTY(CONSTRAINT="MinValue(0) MaxValue(1)", HELPTEXT="Show progress on icon - for timer on suspect escaping")]
	public function setProgressBack(_arg_1:Number):void {
		if (((_arg_1 > 0) && (!(this.meterShowing)))) {
			this.m_view.back_mc.gotoAndStop("fill");
			this.m_view.icon_mc.gotoAndStop("exit");
			this.meterShowing = true;
			this.m_view.back_mc.fill_mc.scaleY = _arg_1;
		} else {
			if (((_arg_1 <= 0) && (this.meterShowing))) {
				this.m_view.back_mc.gotoAndStop("normal");
				this.m_view.icon_mc.gotoAndStop(this.currentIcon);
				this.meterShowing = false;
			}

		}

		if (this.meterShowing) {
			Animate.to(this.m_view.back_mc.fill_mc, 0.5, 0, {
				"scaleX": 1,
				"scaleY": _arg_1
			}, Animate.SineOut);
		}

	}


}
}//package hud.evergreen

