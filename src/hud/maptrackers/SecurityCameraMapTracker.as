// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.maptrackers.SecurityCameraMapTracker

package hud.maptrackers {
import common.Localization;

public class SecurityCameraMapTracker extends LevelCheckedMapTracker {

	private var m_view:minimapBlipCameraView;

	public function SecurityCameraMapTracker() {
		this.setupSecurityCameraMapTracker();
	}

	private function setupSecurityCameraMapTracker():void {
		this.m_view = new minimapBlipCameraView();
		setMainView(this.m_view);
	}

	override public function getTextForLegend():String {
		return (Localization.get("UI_MAP_SECURITY_CAMERA"));
	}


}
}//package hud.maptrackers

