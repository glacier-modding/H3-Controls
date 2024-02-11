// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.sniper.ChallengeElement

package hud.sniper {
import common.BaseControl;
import common.ImageLoader;
import common.Log;
import common.Animate;
import common.menu.MenuUtils;
import common.menu.MenuConstants;

import flash.external.ExternalInterface;

public class ChallengeElement extends BaseControl {

	private var m_view:ChallengeElementView;
	private var m_loader:ImageLoader;

	public function ChallengeElement() {
		this.m_view = new ChallengeElementView();
		this.m_view.progressbar.bg.alpha = 0.25;
		this.m_view.progressbar.value.ScaleX = 0;
		this.m_view.visible = false;
		this.m_view.completedicons.alpha = 0;
		this.m_view.completedicons.gotoAndStop(2);
		this.m_view.completediconsoverlay.alpha = 0;
		this.m_view.imageoverlay.alpha = 0;
		this.m_view.image.alpha = 0;
		addChild(this.m_view);
	}

	public function onSetData(data:Object):void {
		Log.debugData(this, data);
		if (!data.imagePath) {
			data.imagePath = "";
		}

		Animate.delay(this.m_view, 1, function ():void {
			ShowNotification(data.title, data.icon, data.total, data.count, data.completed, data.text, data.type, (data.timeRemaining - 1), data.imagePath);
		});
	}

	public function ShowNotification(title:String, icon:String, total:uint, count:uint, completed:Boolean, challengename:String, type:String, timeRemaining:Number, imagePath:String):void {
		Animate.kill(this.m_view.progressbar.value);
		Animate.kill(this.m_view.overlay);
		Animate.kill(this.m_view.completediconsoverlay);
		Animate.kill(this.m_view.imageoverlay);
		Animate.kill(this.m_view.image);
		Animate.kill(this.m_view);
		this.m_view.completediconsoverlay.alpha = 0;
		this.m_view.imageoverlay.alpha = 0;
		this.m_view.completedicons.alpha = 0;
		this.m_view.image.alpha = 0;
		if (this.m_loader != null) {
			this.m_loader.cancel();
			this.m_view.image.removeChild(this.m_loader);
			this.m_loader = null;
		}

		this.m_view.x = 0;
		this.m_view.alpha = 1;
		this.m_view.overlay.alpha = 0;
		this.m_view.overlay.width = 520;
		var scaleFactorX:Number = this.m_view.overlay.scaleX;
		this.m_view.overlay.width = 280;
		this.m_view.overlay.alpha = 1;
		MenuUtils.setupText(this.m_view.challenge_txt, title, 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		MenuUtils.truncateTextfield(this.m_view.challenge_txt, 1, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_view.progress_txt, ((String(count) + "/") + String(total)), 12, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		if (count >= 1) {
			this.m_view.progressbar.value.scaleX = ((count - 1) / total);
		}

		this.m_view.visible = true;
		Animate.to(this.m_view.progressbar.value, 0.6, 0, {"scaleX": (count / total)}, Animate.ExpoOut);
		Animate.to(this.m_view.overlay, 0.8, 0, {
			"scaleX": scaleFactorX,
			"alpha": 0
		}, Animate.ExpoOut);
		if (((completed) && (!(imagePath == "")))) {
			this.playSound("ChallengeComplete");
			this.showCompleted(imagePath);
		} else {
			this.playSound("ChallengePartiallyComplete");
		}

		Animate.delay(this.m_view, (timeRemaining - 0.5), function ():void {
			Animate.kill(m_view.progressbar.value);
			Animate.kill(m_view.overlay);
			Animate.to(m_view, 0.5, 0, {
				"x": 400,
				"alpha": 0
			}, Animate.ExpoOut);
		});
	}

	private function showCompleted(imagePath:String):void {
		var scaleFactor01:Number;
		var scaleFactor02:Number;
		this.m_view.completediconsoverlay.width = (this.m_view.completediconsoverlay.height = 100);
		scaleFactor01 = this.m_view.completediconsoverlay.scaleX;
		this.m_view.completediconsoverlay.width = (this.m_view.completediconsoverlay.height = 30);
		this.m_view.imageoverlay.width = (this.m_view.imageoverlay.height = 240);
		scaleFactor02 = this.m_view.imageoverlay.scaleX;
		this.m_view.imageoverlay.width = (this.m_view.imageoverlay.height = 120);
		if (this.m_loader != null) {
			this.m_loader.cancel();
			this.m_view.image.removeChild(this.m_loader);
			this.m_loader = null;
		}

		this.m_loader = new ImageLoader();
		this.m_view.image.addChild(this.m_loader);
		this.m_loader.loadImage(imagePath, function ():void {
			m_loader.height = 120;
			m_loader.scaleX = m_loader.scaleY;
			if (m_loader.width < 120) {
				m_loader.width = 120;
				m_loader.scaleY = m_loader.scaleX;
			}

			m_loader.x = (m_loader.width / -2);
			m_loader.y = (m_loader.height / -2);
			Animate.delay(m_view.imageoverlay, 0.5, function ():void {
				m_view.imageoverlay.alpha = 1;
				m_view.image.alpha = 1;
				Animate.to(m_view.imageoverlay, 0.8, 0, {
					"scaleX": scaleFactor02,
					"scaleY": scaleFactor02,
					"alpha": 0
				}, Animate.ExpoOut);
				Animate.delay(m_view.completediconsoverlay, 0.3, function ():void {
					m_view.completediconsoverlay.alpha = 1;
					m_view.completedicons.alpha = 1;
					Animate.to(m_view.completediconsoverlay, 0.8, 0, {
						"scaleX": scaleFactor01,
						"scaleY": scaleFactor01,
						"alpha": 0
					}, Animate.ExpoOut);
				});
			});
		});
	}

	public function playSound(_arg_1:String):void {
		ExternalInterface.call("PlaySound", _arg_1);
	}

	public function HideNotification():void {
		this.m_view.visible = false;
	}

	public function ShowTestChallenge():void {
		this.ShowNotification("UI_CHALLENGES_HAWK_ALL_HEADSHOTS_NAME", "Challenge", 5, 5, true, "Teh Challenge internal name", "challengecounter", 3, "https://iohitmanbetastorage.blob.core.windows.net/resources-7-3/images/challenges/colorado/colorado_47_master_of_disguise.jpg?sv=2017-07-29&sr=c&sig=hV1RWAckVIDBGOYP4ZNMF4KxXWE5VTmE%2FbNbbvr0g5s%3D&se=2018-02-19T17%3A04%3A25Z&sp=r");
	}


}
}//package hud.sniper

