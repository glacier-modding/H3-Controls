package menu3
{
	import flash.events.Event;
	
	public class CallBackEvent extends Event
	{
		
		public static const CLASS_GOT_CALLED:String = "itSureDidResize";
		
		public var classCalled:Object;
		
		public function CallBackEvent(param1:String, param2:Object, param3:Boolean = false, param4:Boolean = false)
		{
			super(param1, param3, param4);
			this.classCalled = param2;
		}
	}
}
