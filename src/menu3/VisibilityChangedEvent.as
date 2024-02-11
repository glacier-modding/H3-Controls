// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.VisibilityChangedEvent

package menu3 {
import flash.events.Event;

public class VisibilityChangedEvent extends Event {

	public static const VISIBILITY_CHANGED:String = "visibilityChanged";

	public var visible:Boolean;

	public function VisibilityChangedEvent(_arg_1:String, _arg_2:Boolean, _arg_3:Boolean = false, _arg_4:Boolean = false) {
		super(_arg_1, _arg_3, _arg_4);
		this.visible = _arg_2;
	}

}
}//package menu3

