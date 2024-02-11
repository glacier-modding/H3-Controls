// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.notification.ChallengesBar

package hud.notification {
import common.ImageLoader;
import common.Animate;
import common.menu.MenuUtils;
import common.menu.MenuConstants;

public class ChallengesBar extends NotificationListener {

	private var m_view:ChallengesBarView;
	private var m_hLoader:ImageLoader;

	public function ChallengesBar() {
		this.m_view = new ChallengesBarView();
		this.m_view.desc.txt.multiline = true;
		this.m_view.desc.txt.wordWrap = true;
		this.m_view.visible = false;
		addChild(this.m_view);
		this.m_hLoader = new ImageLoader();
		this.m_view.image_mc.addChild(this.m_hLoader);
	}

	override public function ShowNotification(sCategory:String, sDescription:String, iData:Object):void {
		this.m_view.visible = true;
		this.m_view.imageheader.alpha = 0;
		this.m_view.imagetitle.alpha = 0;
		this.m_view.cat.alpha = 0;
		this.m_view.desc.alpha = 0;
		this.m_view.image_mc.alpha = 0;
		this.m_view.checkmark_mc.alpha = 0;
		this.m_view.checkmark_mc.scaleX = (this.m_view.checkmark_mc.scaleY = 0.1);
		if ((((!(iData == null)) && (!(iData.sImage == null))) && (!(iData.sImage == "")))) {
			this.m_view.image_mc.visible = true;
			Animate.to(this.m_view.checkmark_mc, 0.3, 1.8, {
				"alpha": 1,
				"scaleX": 1,
				"scaleY": 1
			}, Animate.ExpoOut);
			Animate.to(this.m_view.imageheader, 0.3, 0.2, {"alpha": 1}, Animate.ExpoIn);
			Animate.to(this.m_view.imagetitle, 0.3, 0.4, {"alpha": 1}, Animate.ExpoIn);
			this.m_hLoader.loadImage(iData.sImage, function ():void {
				m_hLoader.width = 241;
				m_hLoader.height = 180;
				Animate.to(m_view.image_mc, 0.3, 0, {"alpha": 1}, Animate.ExpoIn);
			});
			this.m_view.imageheader.txt.text = sCategory;
			this.m_view.imagetitle.txt.text = sDescription;
			Animate.kill(this.m_view.cat);
			Animate.kill(this.m_view.desc);
		} else {
			MenuUtils.setupText(this.m_view.cat.txt, sCategory, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGrey);
			Animate.to(this.m_view.cat, 0.3, 0, {"alpha": 1}, Animate.ExpoIn);
			MenuUtils.setupText(this.m_view.desc.txt, sDescription, 30, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorGreyUltraLight);
			Animate.to(this.m_view.desc, 0.3, 0.2, {"alpha": 1}, Animate.ExpoIn);
			Animate.kill(this.m_view.imageheader);
			Animate.kill(this.m_view.imagetitle);
			Animate.kill(this.m_view.image_mc);
			Animate.kill(this.m_view.checkmark_mc);
		}
		;
	}

	override public function HideNotification():void {
		this.m_view.visible = false;
	}


}
}//package hud.notification

