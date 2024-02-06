package menu3
{
	import flash.events.Event;
	
	public class VisibilityChangedEvent extends Event
	{
		
		public static const VISIBILITY_CHANGED:String = "visibilityChanged";
		
		public var visible:Boolean;
		
		public function VisibilityChangedEvent(param1:String, param2:Boolean, param3:Boolean = false, param4:Boolean = false)
		{
			super(param1, param3, param4);
			this.visible = param2;
		}
	}
}
