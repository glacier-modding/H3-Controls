// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.CallBackEvent

package menu3 {
import flash.events.Event;

public class CallBackEvent extends Event {

	public static const CLASS_GOT_CALLED:String = "itSureDidResize";

	public var classCalled:Object;

	public function CallBackEvent(_arg_1:String, _arg_2:Object, _arg_3:Boolean = false, _arg_4:Boolean = false) {
		super(_arg_1, _arg_3, _arg_4);
		this.classCalled = _arg_2;
	}

}
}//package menu3

