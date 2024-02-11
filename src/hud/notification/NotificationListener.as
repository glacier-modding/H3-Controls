// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.notification.NotificationListener

package hud.notification {
import common.BaseControl;

public class NotificationListener extends BaseControl {


	public function onSetData(_arg_1:Object):void {
		this.ShowNotification(_arg_1.category, _arg_1.description, _arg_1.viewData);
	}

	public function ShowNotification(_arg_1:String, _arg_2:String, _arg_3:Object):void {
	}

	public function HideNotification():void {
	}

	public function SetText(_arg_1:String):void {
		this.ShowNotification(_arg_1, "", {});
	}


}
}//package hud.notification

