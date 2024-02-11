// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.maptrackers.LevelCheckedMapTracker

package hud.maptrackers {
import flash.display.Sprite;

import hud.HudConstants;

public class LevelCheckedMapTracker extends BaseMapTracker {

	private var m_view_level_check_above:minimapBlipArrowAboveView;
	private var m_view_level_check_below:minimapBlipArrowBelowView;
	private var m_currentLevelCheckedMapTrackerView:Sprite;

	public function LevelCheckedMapTracker() {
		this.setupLevelCheckedMapTracker();
	}

	private function setupLevelCheckedMapTracker():void {
		this.m_currentLevelCheckedMapTrackerView = null;
		this.m_view_level_check_above = new minimapBlipArrowAboveView();
		this.m_view_level_check_below = new minimapBlipArrowBelowView();
	}

	public function onSetData(_arg_1:Object):void {
		this.applyLevelCheckResult(m_mainView, _arg_1.levelCheckResult);
	}

	protected function applyLevelCheckResult(_arg_1:Sprite, _arg_2:int):void {
		switch (_arg_2) {
			case 0:
				_arg_1.alpha = 1;
				this.setLevelCheckedMapTrackerView(null);
				return;
			case 1:
				_arg_1.alpha = HudConstants.LayerDepthFadeOutFactor;
				this.setLevelCheckedMapTrackerView(this.m_view_level_check_above);
				return;
			case 2:
				_arg_1.alpha = HudConstants.LayerDepthFadeOutFactor;
				this.setLevelCheckedMapTrackerView(this.m_view_level_check_below);
				return;
			default:
				_arg_1.alpha = 1;
				this.setLevelCheckedMapTrackerView(null);
		}
		;
	}

	private function setLevelCheckedMapTrackerView(_arg_1:Sprite):void {
		if (this.m_currentLevelCheckedMapTrackerView == _arg_1) {
			return;
		}
		;
		if (this.m_currentLevelCheckedMapTrackerView != null) {
			removeChild(this.m_currentLevelCheckedMapTrackerView);
		}
		;
		this.m_currentLevelCheckedMapTrackerView = _arg_1;
		if (this.m_currentLevelCheckedMapTrackerView != null) {
			addChild(this.m_currentLevelCheckedMapTrackerView);
		}
		;
	}


}
}//package hud.maptrackers

