// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.missionend.ImageItemView

package menu3.missionend {
import menu3.MenuImageLoader;

import flash.display.Bitmap;
import flash.display.Sprite;

import common.Animate;
import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.Log;

import flash.display.MovieClip;
import flash.geom.Matrix;
import flash.display.BitmapData;

public dynamic class ImageItemView extends MissionRewardItemView {

	private var m_loader:MenuImageLoader;
	private var m_bitmapImage:Bitmap;
	private var m_bitmapContainer:Sprite;
	private var m_selectionFrameView:ChallengeSelectionFrameView;

	public function ImageItemView() {
		this.visible = false;
		this.tileDarkBg.alpha = 0;
		this.icon.visible = false;
		this.m_bitmapContainer = new Sprite();
		image.addChild(this.m_bitmapContainer);
		this.addSelectionFrame();
	}

	public function killAnimation():void {
		Animate.kill(this);
		Animate.kill(this.image);
		Animate.kill(this.icon);
		Animate.kill(this.m_selectionFrameView);
	}

	public function getImageWidth():int {
		return (imageMask.width);
	}

	public function getImageHeight():int {
		return (imageMask.height);
	}

	private function addSelectionFrame():void {
		if (this.m_selectionFrameView != null) {
			return;
		}
		;
		this.m_selectionFrameView = new ChallengeSelectionFrameView();
		this.m_selectionFrameView.x = image.x;
		this.m_selectionFrameView.y = image.y;
		this.m_selectionFrameView.width = imageMask.width;
		this.m_selectionFrameView.height = imageMask.height;
		this.m_selectionFrameView.alpha = 0;
		addChild(this.m_selectionFrameView);
	}

	public function setVisible(_arg_1:Boolean, _arg_2:Number = 1):void {
		this.killAnimation();
		if (_arg_1) {
			this.image.visible = true;
			this.image.alpha = _arg_2;
			this.image.scaleX = 1;
			this.image.scaleY = 1;
			this.visible = true;
		} else {
			this.visible = false;
			this.image.visible = false;
		}
		;
	}

	public function animateIn(_arg_1:String):void {
		switch (_arg_1) {
			case MissionEndChallengePage.CHALLENGE_STATE_NEW:
				MenuUtils.setColor(this.m_selectionFrameView, MenuConstants.COLOR_WHITE, false);
				Animate.fromTo(this.m_selectionFrameView, 0.8, 0, {"alpha": 0}, {"alpha": 1}, Animate.ExpoOut);
				this.image.filters = [];
				Animate.to(this.image, 0.5, 0, {"alpha": 1}, Animate.ExpoOut);
				return;
			case MissionEndChallengePage.CHALLENGE_STATE_NEW_UNLOCKED:
				Animate.fromTo(this.m_selectionFrameView, 0.4, 0, {"alpha": 1}, {"alpha": 0}, Animate.ExpoOut);
				this.icon.scaleX = (this.icon.scaleY = 0);
				this.icon.visible = true;
				MenuUtils.setupIcon(this.icon, "completed", MenuConstants.COLOR_WHITE, false, true, MenuConstants.COLOR_RED);
				Animate.to(this.icon, 0.2, 0, {
					"scaleX": 1,
					"scaleY": 1
				}, Animate.BackOut);
				return;
			case MissionEndChallengePage.CHALLENGE_STATE_COMPLETE:
				Animate.fromTo(this.m_selectionFrameView, 0.4, 0, {"alpha": 1}, {"alpha": 0}, Animate.ExpoOut);
				this.image.filters = [];
				Animate.to(this.image, 0.3, 0, {"alpha": 1}, Animate.ExpoOut);
				return;
			case MissionEndChallengePage.CHALLENGE_STATE_UNCOMPLETE:
				Animate.fromTo(this.m_selectionFrameView, 0.4, 0, {"alpha": 1}, {"alpha": 0}, Animate.ExpoOut);
				return;
			default:
				Log.info(Log.ChannelDebug, this, " No state set for challenge-tile!?");
		}
		;
	}

	public function animateOut(val:*):void {
		Animate.legacyTo(this, 0.2, {"alpha": 0}, Animate.ExpoOut, function (_arg_1:MovieClip):void {
			_arg_1.visible = false;
			_arg_1.image.visible = false;
		}, this);
		Animate.legacyTo(this.image, 0.3, {
			"scaleX": 0,
			"scaleY": 0
		}, Animate.ExpoOut);
	}

	public function loadImage(imagePath:String, callback:Function = null, failedCallback:Function = null, scale:Number = 1):void {
		this.unloadImage();
		this.m_loader = new MenuImageLoader();
		this.m_loader.center = true;
		image.addChild(this.m_loader);
		this.m_loader.loadImage(imagePath, function ():void {
			var _local_5:Bitmap;
			var _local_6:Matrix;
			var _local_7:BitmapData;
			var _local_1:Object;
			var _local_2:Number = 1;
			if (scale < 0.95) {
				_local_5 = m_loader.getImage();
				_local_6 = new Matrix();
				_local_6.scale(scale, scale);
				_local_7 = new BitmapData((_local_5.width * scale), (_local_5.height * scale), true);
				_local_7.draw(_local_5, _local_6);
				image.removeChild(m_loader);
				m_loader = null;
				m_bitmapImage = new Bitmap(_local_7, "auto", true);
				m_bitmapImage.x = (-(m_bitmapImage.width) / 2);
				m_bitmapImage.y = (-(m_bitmapImage.height) / 2);
				m_bitmapContainer.addChild(m_bitmapImage);
				_local_2 = (m_bitmapImage.width / m_bitmapImage.height);
				_local_1 = m_bitmapContainer;
			} else {
				_local_2 = (m_loader.width / m_loader.height);
				_local_1 = m_loader;
			}
			;
			var _local_3:int = imageMask.width;
			var _local_4:int = imageMask.height;
			_local_1.width = _local_3;
			_local_1.height = (_local_3 / _local_2);
			if (_local_1.height < _local_4) {
				_local_1.height = _local_4;
				_local_1.width = (_local_4 * _local_2);
			}
			;
			if (callback != null) {
				callback();
			}
			;
		}, failedCallback);
	}

	public function unloadImage():void {
		if (this.m_loader != null) {
			this.m_loader.cancelIfLoading();
			if (this.m_loader.parent != null) {
				this.m_loader.parent.removeChild(this.m_loader);
			}
			;
			this.m_loader = null;
		}
		;
		if (this.m_bitmapImage != null) {
			if (this.m_bitmapImage.parent != null) {
				this.m_bitmapImage.parent.removeChild(this.m_bitmapImage);
			}
			;
			this.m_bitmapImage = null;
		}
		;
	}


}
}//package menu3.missionend

