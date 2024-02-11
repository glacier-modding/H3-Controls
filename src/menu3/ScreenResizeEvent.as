// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.ScreenResizeEvent

package menu3 {
import flash.events.Event;

public class ScreenResizeEvent extends Event {

	public static const SCREEN_RESIZED:String = "itSureDidResize";

	public var screenSize:Object;

	public function ScreenResizeEvent(_arg_1:String, _arg_2:Object, _arg_3:Boolean = false, _arg_4:Boolean = false) {
		super(_arg_1, _arg_3, _arg_4);
		this.screenSize = _arg_2;
	}

}
}//package menu3

