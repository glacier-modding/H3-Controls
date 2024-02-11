// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.notification.ConnectionIndicator

package hud.notification {
import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.CommonUtils;
import common.Animate;

public class ConnectionIndicator extends NotificationListener {

	private var m_view:ConnectionIndicatorView;

	public function ConnectionIndicator() {
		this.m_view = new ConnectionIndicatorView();
		addChild(this.m_view);
		this.m_view.x = 350;
		this.m_view.visible = false;
	}

	override public function SetText(_arg_1:String):void {
		this.setTextFields(_arg_1);
	}

	private function setTextFields(_arg_1:String, _arg_2:String = null):void {
		if (_arg_2) {
			MenuUtils.setupText(this.m_view.label_txt, _arg_2, 18, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorRed);
			MenuUtils.setupText(this.m_view.label2_txt, _arg_1, 16, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorGreyUltraLight);
			this.m_view.label2_txt.y = ((this.m_view.label_txt.y + this.m_view.label_txt.textHeight) + 8);
			this.m_view.back_mc.height = ((this.m_view.label2_txt.y + this.m_view.label2_txt.textHeight) + 10);
		} else {
			MenuUtils.setupText(this.m_view.label_txt, _arg_1, 18, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorGreyUltraLight);
			MenuUtils.setupText(this.m_view.label2_txt, "", 16, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorGreyUltraLight);
			this.m_view.back_mc.height = ((this.m_view.label_txt.y + this.m_view.label_txt.textHeight) + 14);
		}
		;
		this.m_view.visible = true;
		this.m_view.spinner_mc.visible = true;
		CommonUtils.changeFontToGlobalFont(this.m_view.label_txt);
		CommonUtils.changeFontToGlobalFont(this.m_view.label2_txt);
		this.animateIndicator();
		Animate.legacyTo(this.m_view, 0.3, {
			"alpha": 1,
			"x": 0
		}, Animate.ExpoIn);
	}

	override public function ShowNotification(_arg_1:String, _arg_2:String, _arg_3:Object):void {
		this.setTextFields(_arg_2, _arg_1);
	}

	public function ShowTestString():void {
		this.ShowNotification("Connection status", "WWWWWWWWWWWWWWWW suckers!", {});
	}

	public function ShowTestString2():void {
		this.SetText("Connectionining to da networkaaa!");
	}

	private function animateIndicator():void {
		Animate.legacyTo(this.m_view.spinner_mc, 1.5, {"rotation": 360}, Animate.Linear, function ():void {
			animateIndicator();
		});
	}

	override public function HideNotification():void {
		Animate.legacyTo(this.m_view, 0.2, {
			"alpha": 0,
			"x": 350
		}, Animate.ExpoIn, function ():void {
			Animate.kill(m_view.spinner_mc);
			Animate.kill(m_view);
			m_view.visible = false;
			m_view.spinner_mc.visible = false;
		});
	}

	override public function onSetVisible(_arg_1:Boolean):void {
		if (!_arg_1) {
			this.HideNotification();
		}
		;
	}


}
}//package hud.notification

